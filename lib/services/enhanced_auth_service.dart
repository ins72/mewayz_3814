import 'dart:async';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter/foundation.dart';
import 'package:local_auth/local_auth.dart';

import '../core/enhanced_supabase_service.dart';
import '../core/resilient_error_handler.dart';
import '../core/storage_service.dart';

class EnhancedAuthService {
  static EnhancedAuthService? _instance;
  static EnhancedAuthService get instance => _instance ??= EnhancedAuthService._internal();
  
  EnhancedAuthService._internal();
  factory EnhancedAuthService() => instance;

  late EnhancedSupabaseService _supabaseService;
  late StorageService _storageService;
  final ResilientErrorHandler _errorHandler = ResilientErrorHandler();
  final LocalAuthentication _localAuth = LocalAuthentication();
  
  bool _isInitialized = false;
  User? _currentUser;
  Timer? _sessionRefreshTimer;
  Timer? _authStateCheckTimer;
  bool _isAuthenticating = false;
  
  // Stream controller for auth state changes
  final StreamController<AuthState> _authStateController = StreamController<AuthState>.broadcast();

  /// Initialize the enhanced auth service
  Future<void> initialize() async {
    if (_isInitialized) return;

    try {
      _supabaseService = EnhancedSupabaseService.enhancedInstance;
      _storageService = StorageService();
      
      // Ensure storage is initialized
      await _storageService.initialize();
      
      // Ensure supabase service is initialized
      await _supabaseService.initialize();
      
      // Set up auth state listener with enhanced error handling
      _setupEnhancedAuthListener();
      
      // Start session monitoring
      _startSessionMonitoring();
      
      // Get current user safely
      await _getCurrentUserSafely();
      
      _isInitialized = true;
      debugPrint('✅ Enhanced Auth Service initialized successfully');
    } catch (e) {
      await _errorHandler.handleError(
        e,
        context: 'enhanced_auth_service_initialization',
        shouldRetry: true,
        maxRetries: 2,
      );
      rethrow;
    }
  }

  /// Get current user safely with error handling
  Future<void> _getCurrentUserSafely() async {
    try {
      if (!_supabaseService.initialized) {
        await _supabaseService.initialize();
      }
      
      _currentUser = _supabaseService.client.auth.currentUser;
      debugPrint('Current user status: ${_currentUser != null ? 'authenticated' : 'not authenticated'}');
    } catch (e) {
      debugPrint('Failed to get current user: $e');
      _currentUser = null;
    }
  }

  /// Set up enhanced auth state listener
  void _setupEnhancedAuthListener() {
    try {
      _supabaseService.client.auth.onAuthStateChange.listen(
        (data) async {
          await _handleAuthStateChange(data);
          _authStateController.add(data);
        },
        onError: (error) async {
          await _errorHandler.handleError(
            error,
            context: 'auth_state_listener',
            shouldRetry: false,
          );
        },
      );
    } catch (e) {
      debugPrint('Failed to setup auth listener: $e');
    }
  }

  /// Handle auth state changes with enhanced error handling
  Future<void> _handleAuthStateChange(AuthState data) async {
    try {
      final event = data.event;
      final session = data.session;
      
      debugPrint('Auth state change: $event');
      
      switch (event) {
        case AuthChangeEvent.signedIn:
          _currentUser = session?.user;
          await _onSignedIn(session?.user);
          break;
        case AuthChangeEvent.signedOut:
          _currentUser = null;
          await _onSignedOut();
          break;
        case AuthChangeEvent.tokenRefreshed:
          _currentUser = session?.user;
          await _onTokenRefreshed(session);
          break;
        case AuthChangeEvent.userUpdated:
          _currentUser = session?.user;
          await _onUserUpdated(session?.user);
          break;
        default:
          debugPrint('Unhandled auth event: $event');
      }
    } catch (e) {
      await _errorHandler.handleError(
        e,
        context: 'auth_state_change_handling',
        metadata: {'event': data.event.toString()},
        shouldRetry: false,
      );
    }
  }

  /// Handle signed in event
  Future<void> _onSignedIn(User? user) async {
    if (user == null) return;
    
    try {
      // Cache user data
      await _cacheUserData(user);
      
      // Start session refresh timer
      _startSessionRefreshTimer();
      
      debugPrint('✅ User signed in successfully: ${user.email}');
    } catch (e) {
      debugPrint('Error handling sign in: $e');
    }
  }

  /// Handle signed out event
  Future<void> _onSignedOut() async {
    try {
      // Clear cached data
      await _clearCachedData();
      
      // Stop timers
      _stopSessionRefreshTimer();
      
      debugPrint('✅ User signed out successfully');
    } catch (e) {
      debugPrint('Error handling sign out: $e');
    }
  }

  /// Handle token refreshed event
  Future<void> _onTokenRefreshed(Session? session) async {
    if (session == null) return;
    
    try {
      // Update cached session data
      await _updateCachedSession(session);
      
      debugPrint('✅ Token refreshed successfully');
    } catch (e) {
      debugPrint('Error handling token refresh: $e');
    }
  }

  /// Handle user updated event
  Future<void> _onUserUpdated(User? user) async {
    if (user == null) return;
    
    try {
      // Update cached user data
      await _cacheUserData(user);
      
      debugPrint('✅ User data updated successfully');
    } catch (e) {
      debugPrint('Error handling user update: $e');
    }
  }

  /// Start session monitoring
  void _startSessionMonitoring() {
    _authStateCheckTimer?.cancel();
    _authStateCheckTimer = Timer.periodic(
      const Duration(minutes: 5),
      (_) => _checkSessionValidity(),
    );
  }

  /// Check session validity
  Future<void> _checkSessionValidity() async {
    try {
      final session = _supabaseService.client.auth.currentSession;
      
      if (session == null && _currentUser != null) {
        // Session expired but we think user is still logged in
        debugPrint('⚠️ Session expired, signing out user');
        _currentUser = null;
        await _onSignedOut();
      } else if (session != null && session.isExpired) {
        // Session is expired, try to refresh
        debugPrint('🔄 Session is expired, attempting refresh');
        await _refreshSession();
      }
    } catch (e) {
      debugPrint('Session validity check failed: $e');
    }
  }

  /// Start session refresh timer
  void _startSessionRefreshTimer() {
    _sessionRefreshTimer?.cancel();
    
    // Refresh session every 45 minutes (tokens expire after 1 hour)
    _sessionRefreshTimer = Timer.periodic(
      const Duration(minutes: 45),
      (_) => _refreshSession(),
    );
  }

  /// Stop session refresh timer
  void _stopSessionRefreshTimer() {
    _sessionRefreshTimer?.cancel();
    _sessionRefreshTimer = null;
  }

  /// Refresh session with error handling
  Future<void> _refreshSession() async {
    try {
      await _supabaseService.executeWithRetry(
        () => _supabaseService.client.auth.refreshSession(),
        maxRetries: 2,
        requiresConnection: true,
      );
      
      debugPrint('✅ Session refreshed successfully');
    } catch (e) {
      await _errorHandler.handleError(
        e,
        context: 'session_refresh',
        shouldRetry: false,
      );
      
      // If refresh fails, sign out user
      if (_currentUser != null) {
        debugPrint('⚠️ Session refresh failed, signing out user');
        await signOut();
      }
    }
  }

  /// Cache user data
  Future<void> _cacheUserData(User user) async {
    try {
      await _storageService.setValue('cached_user_id', user.id);
      await _storageService.setValue('cached_user_email', user.email ?? '');
      await _storageService.setValue('last_signin_time', DateTime.now().toIso8601String());
    } catch (e) {
      debugPrint('Failed to cache user data: $e');
    }
  }

  /// Update cached session data
  Future<void> _updateCachedSession(Session session) async {
    try {
      await _storageService.setValue('last_token_refresh', DateTime.now().toIso8601String());
      await _storageService.setValue('session_expires_at', session.expiresAt.toString());
    } catch (e) {
      debugPrint('Failed to update cached session: $e');
    }
  }

  /// Clear cached data
  Future<void> _clearCachedData() async {
    try {
      await _storageService.remove('cached_user_id');
      await _storageService.remove('cached_user_email');
      await _storageService.remove('last_signin_time');
      await _storageService.remove('last_token_refresh');
      await _storageService.remove('session_expires_at');
    } catch (e) {
      debugPrint('Failed to clear cached data: $e');
    }
  }

  /// Sign in with email and password with enhanced error handling
  Future<AuthResponse> signInWithEmailAndPassword(String email, String password) async {
    if (_isAuthenticating) {
      throw Exception('Authentication already in progress');
    }

    _isAuthenticating = true;
    
    try {
      final response = await _supabaseService.executeWithRetry(
        () => _supabaseService.client.auth.signInWithPassword(
          email: email,
          password: password,
        ),
        maxRetries: 2,
        requiresConnection: true,
      );

      if (response.user == null) {
        throw Exception('Sign in failed: No user returned');
      }

      debugPrint('✅ Sign in successful for: $email');
      return response;
    } catch (e) {
      await _errorHandler.handleError(
        e,
        context: 'email_password_signin',
        metadata: {'email': email},
        shouldRetry: false,
      );
      rethrow;
    } finally {
      _isAuthenticating = false;
    }
  }

  /// Sign up with email and password with enhanced error handling
  Future<AuthResponse> signUpWithEmailAndPassword(String email, String password) async {
    if (_isAuthenticating) {
      throw Exception('Authentication already in progress');
    }

    _isAuthenticating = true;
    
    try {
      final response = await _supabaseService.executeWithRetry(
        () => _supabaseService.client.auth.signUp(
          email: email,
          password: password,
        ),
        maxRetries: 2,
        requiresConnection: true,
      );

      debugPrint('✅ Sign up successful for: $email');
      return response;
    } catch (e) {
      await _errorHandler.handleError(
        e,
        context: 'email_password_signup',
        metadata: {'email': email},
        shouldRetry: false,
      );
      rethrow;
    } finally {
      _isAuthenticating = false;
    }
  }

  /// Sign out with enhanced error handling
  Future<void> signOut() async {
    try {
      await _supabaseService.executeWithRetry(
        () => _supabaseService.client.auth.signOut(),
        maxRetries: 1,
        requiresConnection: false, // Allow offline sign out
      );

      debugPrint('✅ Sign out successful');
    } catch (e) {
      // Even if signOut fails, clear local state
      _currentUser = null;
      await _onSignedOut();
      
      await _errorHandler.handleError(
        e,
        context: 'signout',
        shouldRetry: false,
      );
    }
  }

  /// Check if biometric authentication is available
  Future<bool> isBiometricAvailable() async {
    try {
      final bool isAvailable = await _localAuth.canCheckBiometrics;
      final bool isDeviceSupported = await _localAuth.isDeviceSupported();
      
      return isAvailable && isDeviceSupported;
    } catch (e) {
      debugPrint('Error checking biometric availability: $e');
      return false;
    }
  }

  /// Authenticate with biometrics
  Future<AuthResponse?> authenticateWithBiometrics() async {
    try {
      final bool isAvailable = await isBiometricAvailable();
      if (!isAvailable) {
        throw Exception('Biometric authentication is not available');
      }

      final bool didAuthenticate = await _localAuth.authenticate(
        localizedReason: 'Please authenticate to access your account',
        options: const AuthenticationOptions(
          biometricOnly: true,
          stickyAuth: true,
        ),
      );

      if (didAuthenticate) {
        // Check if user has cached credentials for biometric sign-in
        final cachedEmail = await _storageService.getValue('cached_user_email');
        if (cachedEmail != null && cachedEmail.isNotEmpty) {
          // For biometric auth, we'll rely on session validation
          final session = _supabaseService.client.auth.currentSession;
          if (session != null && !session.isExpired) {
            return AuthResponse(
              user: session.user,
              session: session,
            );
          }
        }
        
        throw Exception('Biometric authentication successful but no valid session found');
      } else {
        throw Exception('Biometric authentication failed');
      }
    } catch (e) {
      await _errorHandler.handleError(
        e,
        context: 'biometric_authentication',
        shouldRetry: false,
      );
      return null;
    }
  }

  /// Check device registration for biometric authentication
  Future<bool> checkDeviceRegistration() async {
    try {
      final deviceId = await _storageService.getValue('device_id');
      final isRegistered = await _storageService.getValue('device_registered');
      
      return deviceId != null && isRegistered == 'true';
    } catch (e) {
      debugPrint('Error checking device registration: $e');
      return false;
    }
  }

  /// Register device for biometric authentication
  Future<Map<String, dynamic>> registerDevice(String deviceName) async {
    try {
      final deviceId = DateTime.now().millisecondsSinceEpoch.toString();
      
      await _storageService.setValue('device_id', deviceId);
      await _storageService.setValue('device_name', deviceName);
      await _storageService.setValue('device_registered', 'true');
      await _storageService.setValue('registration_date', DateTime.now().toIso8601String());
      
      return {
        'success': true,
        'device_id': deviceId,
        'device_name': deviceName,
        'registration_date': DateTime.now().toIso8601String(),
      };
    } catch (e) {
      await _errorHandler.handleError(
        e,
        context: 'device_registration',
        shouldRetry: false,
      );
      
      return {
        'success': false,
        'error': e.toString(),
      };
    }
  }

  /// Verify two-factor authentication code
  Future<bool> verifyTwoFactorCode(String code) async {
    try {
      // Implementation for 2FA verification
      // This would typically involve verifying the code with Supabase
      // For now, we'll return a basic implementation
      
      if (code.isEmpty || code.length != 6) {
        return false;
      }
      
      // Here you would implement the actual 2FA verification logic
      // This is a placeholder implementation
      await Future.delayed(const Duration(seconds: 1));
      
      return true; // Placeholder - implement actual verification
    } catch (e) {
      await _errorHandler.handleError(
        e,
        context: 'two_factor_verification',
        shouldRetry: false,
      );
      return false;
    }
  }

  /// Check if user is logged in with validation
  Future<bool> isUserLoggedIn() async {
    try {
      if (!_isInitialized) {
        await initialize();
      }

      final session = _supabaseService.client.auth.currentSession;
      final user = _supabaseService.client.auth.currentUser;
      
      if (session == null || user == null) {
        _currentUser = null;
        return false;
      }

      if (session.isExpired) {
        debugPrint('Session is expired');
        _currentUser = null;
        return false;
      }

      _currentUser = user;
      return true;
    } catch (e) {
      debugPrint('Error checking login status: $e');
      _currentUser = null;
      return false;
    }
  }

  /// Get current user
  User? get currentUser => _currentUser;

  /// Check if authenticated
  bool get isAuthenticated => _currentUser != null;

  /// Check if initializing
  bool get isInitialized => _isInitialized;

  /// Check if authenticating
  bool get isAuthenticating => _isAuthenticating;

  /// Get auth state changes stream
  Stream<AuthState> get onAuthStateChanged => _authStateController.stream;

  /// Get auth service status
  Map<String, dynamic> getAuthStatus() {
    return {
      'is_initialized': _isInitialized,
      'is_authenticated': isAuthenticated,
      'is_authenticating': _isAuthenticating,
      'current_user_id': _currentUser?.id,
      'current_user_email': _currentUser?.email,
      'session_refresh_active': _sessionRefreshTimer?.isActive ?? false,
      'auth_state_monitoring_active': _authStateCheckTimer?.isActive ?? false,
      'supabase_health_score': _supabaseService.getConnectionHealthScore(),
    };
  }

  /// Dispose resources
  void dispose() {
    _sessionRefreshTimer?.cancel();
    _authStateCheckTimer?.cancel();
    _authStateController.close();
    _errorHandler.dispose();
  }
}