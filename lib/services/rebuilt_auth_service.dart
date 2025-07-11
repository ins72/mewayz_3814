import 'dart:async';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter/foundation.dart';
import 'package:local_auth/local_auth.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:crypto/crypto.dart';
import 'dart:convert';
import 'dart:io';

import '../core/rebuilt_supabase_service.dart';
import '../core/resilient_error_handler.dart';
import '../core/storage_service.dart';

/// Rebuilt authentication service with enhanced security, session management, and biometric support
class RebuiltAuthService {
  static RebuiltAuthService? _instance;
  static RebuiltAuthService get instance => _instance ??= RebuiltAuthService._internal();
  
  RebuiltAuthService._internal();

  late RebuiltSupabaseService _supabaseService;
  late StorageService _storageService;
  final ResilientErrorHandler _errorHandler = ResilientErrorHandler();
  final LocalAuthentication _localAuth = LocalAuthentication();
  final DeviceInfoPlugin _deviceInfo = DeviceInfoPlugin();
  
  bool _isInitialized = false;
  User? _currentUser;
  Timer? _sessionRefreshTimer;
  Timer? _authValidationTimer;
  bool _isAuthenticating = false;
  String? _deviceFingerprint;
  
  // Enhanced auth state stream
  final StreamController<AuthState> _authStateController = StreamController<AuthState>.broadcast();
  final StreamController<Map<String, dynamic>> _authStatusController = StreamController<Map<String, dynamic>>.broadcast();

  /// Initialize the rebuilt auth service
  Future<void> initialize() async {
    if (_isInitialized) return;

    try {
      debugPrint('🔐 Initializing Rebuilt Auth Service...');
      
      _supabaseService = RebuiltSupabaseService.instance;
      _storageService = StorageService();
      
      // Ensure dependencies are initialized
      await _storageService.initialize();
      await _supabaseService.initialize();
      
      // Generate device fingerprint
      await _generateDeviceFingerprint();
      
      // Setup enhanced auth listener
      _setupEnhancedAuthListener();
      
      // Start session monitoring
      _startSessionMonitoring();
      
      // Validate current session
      await _validateCurrentSession();
      
      _isInitialized = true;
      debugPrint('✅ Rebuilt Auth Service initialized successfully');
      
    } catch (e) {
      await _errorHandler.handleError(
        e,
        context: 'rebuilt_auth_service_initialization',
        shouldRetry: true,
        maxRetries: 2,
      );
      rethrow;
    }
  }

  /// Generate device fingerprint for security
  Future<void> _generateDeviceFingerprint() async {
    try {
      String deviceInfo = '';
      
      if (Platform.isAndroid) {
        final androidInfo = await _deviceInfo.androidInfo;
        deviceInfo = '${androidInfo.model}_${androidInfo.id}_${androidInfo.brand}';
      } else if (Platform.isIOS) {
        final iosInfo = await _deviceInfo.iosInfo;
        deviceInfo = '${iosInfo.model}_${iosInfo.identifierForVendor}_${iosInfo.systemVersion}';
      }
      
      // Create hash for privacy
      final bytes = utf8.encode(deviceInfo);
      final digest = sha256.convert(bytes);
      _deviceFingerprint = digest.toString().substring(0, 16);
      
      await _storageService.setValue('device_fingerprint', _deviceFingerprint!);
      
    } catch (e) {
      debugPrint('Failed to generate device fingerprint: $e');
      _deviceFingerprint = 'unknown_device';
    }
  }

  /// Setup enhanced auth state listener
  void _setupEnhancedAuthListener() {
    try {
      _supabaseService.client.auth.onAuthStateChange.listen(
        (data) async {
          await _handleAuthStateChange(data);
          _authStateController.add(data);
          _broadcastAuthStatus();
        },
        onError: (error) async {
          await _errorHandler.handleError(
            error,
            context: 'rebuilt_auth_state_listener',
            shouldRetry: false,
          );
        },
      );
    } catch (e) {
      debugPrint('Failed to setup enhanced auth listener: $e');
    }
  }

  /// Handle auth state changes with enhanced security
  Future<void> _handleAuthStateChange(AuthState data) async {
    try {
      final event = data.event;
      final session = data.session;
      
      debugPrint('🔐 Auth state change: $event');
      
      switch (event) {
        case AuthChangeEvent.signedIn:
          _currentUser = session?.user;
          await _onSignedIn(session);
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
        case AuthChangeEvent.passwordRecovery:
          await _onPasswordRecovery(session);
          break;
        default:
          debugPrint('Unhandled auth event: $event');
      }
    } catch (e) {
      await _errorHandler.handleError(
        e,
        context: 'rebuilt_auth_state_change_handling',
        metadata: {'event': data.event.toString()},
        shouldRetry: false,
      );
    }
  }

  /// Handle signed in event with security logging
  Future<void> _onSignedIn(Session? session) async {
    if (session?.user == null) return;
    
    try {
      final user = session!.user;
      
      // Cache user data securely
      await _cacheUserDataSecurely(user, session);
      
      // Log sign-in event
      await _logSecurityEvent('user_signed_in', {
        'user_id': user.id,
        'email': user.email,
        'device_fingerprint': _deviceFingerprint,
        'sign_in_method': user.appMetadata['provider'] ?? 'email',
      });
      
      // Start session refresh timer
      _startSessionRefreshTimer(session);
      
      // Sync user profile if needed
      await _syncUserProfile(user);
      
      debugPrint('✅ User signed in successfully: ${user.email}');
      
    } catch (e) {
      debugPrint('Error handling sign in: $e');
    }
  }

  /// Handle signed out event with cleanup
  Future<void> _onSignedOut() async {
    try {
      // Clear cached data
      await _clearSecureData();
      
      // Stop timers
      _stopSessionRefreshTimer();
      
      // Log sign-out event
      await _logSecurityEvent('user_signed_out', {
        'device_fingerprint': _deviceFingerprint,
      });
      
      debugPrint('✅ User signed out successfully');
      
    } catch (e) {
      debugPrint('Error handling sign out: $e');
    }
  }

  /// Handle token refresh with security validation
  Future<void> _onTokenRefreshed(Session? session) async {
    if (session == null) return;
    
    try {
      // Update cached session data
      await _updateCachedSessionSecurely(session);
      
      // Log token refresh
      await _logSecurityEvent('token_refreshed', {
        'user_id': session.user.id,
        'expires_at': session.expiresAt,
      });
      
      debugPrint('✅ Token refreshed successfully');
      
    } catch (e) {
      debugPrint('Error handling token refresh: $e');
    }
  }

  /// Handle user update event
  Future<void> _onUserUpdated(User? user) async {
    if (user == null) return;
    
    try {
      // Update cached user data
      await _cacheUserDataSecurely(user, null);
      
      // Sync profile changes
      await _syncUserProfile(user);
      
      debugPrint('✅ User data updated successfully');
      
    } catch (e) {
      debugPrint('Error handling user update: $e');
    }
  }

  /// Handle password recovery
  Future<void> _onPasswordRecovery(Session? session) async {
    try {
      await _logSecurityEvent('password_recovery_initiated', {
        'device_fingerprint': _deviceFingerprint,
      });
      
      debugPrint('🔐 Password recovery initiated');
      
    } catch (e) {
      debugPrint('Error handling password recovery: $e');
    }
  }

  /// Start session monitoring with enhanced validation
  void _startSessionMonitoring() {
    _authValidationTimer?.cancel();
    _authValidationTimer = Timer.periodic(
      const Duration(minutes: 3),
      (_) => _validateSessionSecurity(),
    );
  }

  /// Validate session security
  Future<void> _validateSessionSecurity() async {
    try {
      final session = _supabaseService.client.auth.currentSession;
      
      if (session == null && _currentUser != null) {
        debugPrint('⚠️ Session expired, signing out user');
        _currentUser = null;
        await _onSignedOut();
        return;
      }
      
      if (session != null) {
        // Check if session is close to expiring (within 10 minutes)
        final expiresAt = session.expiresAt;
        final now = DateTime.now().millisecondsSinceEpoch ~/ 1000;
        final timeUntilExpiry = expiresAt != null ? expiresAt - now : 0;
        
        if (timeUntilExpiry < 600) { // 10 minutes
          debugPrint('🔄 Session expiring soon, refreshing...');
          await _refreshSession();
        }
        
        // Validate device fingerprint
        await _validateDeviceFingerprint();
      }
      
    } catch (e) {
      debugPrint('Session security validation failed: $e');
    }
  }

  /// Validate device fingerprint for security
  Future<void> _validateDeviceFingerprint() async {
    try {
      final storedFingerprint = await _storageService.getValue('device_fingerprint');
      
      if (storedFingerprint != _deviceFingerprint) {
        debugPrint('⚠️ Device fingerprint mismatch - potential security risk');
        
        await _logSecurityEvent('device_fingerprint_mismatch', {
          'stored': storedFingerprint,
          'current': _deviceFingerprint,
        });
        
        // Optionally force re-authentication
        // await signOut();
      }
      
    } catch (e) {
      debugPrint('Device fingerprint validation failed: $e');
    }
  }

  /// Start session refresh timer with smart timing
  void _startSessionRefreshTimer(Session session) {
    _sessionRefreshTimer?.cancel();
    
    // Refresh session when 75% of its lifetime has passed
    final expiresAt = session.expiresAt;
    final now = DateTime.now().millisecondsSinceEpoch ~/ 1000;
    final totalLifetime = expiresAt != null ? expiresAt - now : 0;
    final refreshIn = (totalLifetime * 0.75).round();
    
    if (refreshIn > 0) {
      _sessionRefreshTimer = Timer(
        Duration(seconds: refreshIn),
        () => _refreshSession(),
      );
    }
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
        context: 'rebuilt_session_refresh',
        shouldRetry: false,
      );
      
      // If refresh fails, sign out user
      if (_currentUser != null) {
        debugPrint('⚠️ Session refresh failed, signing out user');
        await signOut();
      }
    }
  }

  /// Validate current session on initialization
  Future<void> _validateCurrentSession() async {
    try {
      final session = _supabaseService.client.auth.currentSession;
      
      if (session != null) {
        if (session.isExpired) {
          debugPrint('Current session is expired, attempting refresh');
          await _refreshSession();
        } else {
          _currentUser = session.user;
          debugPrint('Current session is valid for user: ${session.user.email}');
        }
      }
      
    } catch (e) {
      debugPrint('Session validation failed: $e');
      _currentUser = null;
    }
  }

  /// Sign in with email and password with enhanced security
  Future<AuthResponse> signInWithEmailAndPassword(String email, String password) async {
    if (_isAuthenticating) {
      throw Exception('Authentication already in progress');
    }

    _isAuthenticating = true;
    
    try {
      // Log sign-in attempt
      await _logSecurityEvent('sign_in_attempt', {
        'email': email,
        'device_fingerprint': _deviceFingerprint,
      });
      
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
      // Log failed sign-in attempt
      await _logSecurityEvent('sign_in_failed', {
        'email': email,
        'error': e.toString(),
        'device_fingerprint': _deviceFingerprint,
      });
      
      await _errorHandler.handleError(
        e,
        context: 'rebuilt_email_password_signin',
        metadata: {'email': email},
        shouldRetry: false,
      );
      rethrow;
    } finally {
      _isAuthenticating = false;
    }
  }

  /// Sign up with email and password with enhanced validation
  Future<AuthResponse> signUpWithEmailAndPassword(String email, String password, {
    String? fullName,
    Map<String, dynamic>? additionalData,
  }) async {
    if (_isAuthenticating) {
      throw Exception('Authentication already in progress');
    }

    _isAuthenticating = true;
    
    try {
      // Prepare user metadata
      final userMetadata = {
        'full_name': fullName ?? email.split('@')[0],
        'device_fingerprint': _deviceFingerprint,
        'registration_timestamp': DateTime.now().toIso8601String(),
        ...?additionalData,
      };
      
      // Log sign-up attempt
      await _logSecurityEvent('sign_up_attempt', {
        'email': email,
        'device_fingerprint': _deviceFingerprint,
      });
      
      final response = await _supabaseService.executeWithRetry(
        () => _supabaseService.client.auth.signUp(
          email: email,
          password: password,
          data: userMetadata,
        ),
        maxRetries: 2,
        requiresConnection: true,
      );

      debugPrint('✅ Sign up successful for: $email');
      return response;
      
    } catch (e) {
      // Log failed sign-up attempt
      await _logSecurityEvent('sign_up_failed', {
        'email': email,
        'error': e.toString(),
        'device_fingerprint': _deviceFingerprint,
      });
      
      await _errorHandler.handleError(
        e,
        context: 'rebuilt_email_password_signup',
        metadata: {'email': email},
        shouldRetry: false,
      );
      rethrow;
    } finally {
      _isAuthenticating = false;
    }
  }

  /// Sign out with comprehensive cleanup
  Future<void> signOut() async {
    try {
      // Log sign-out attempt
      await _logSecurityEvent('sign_out_attempt', {
        'user_id': _currentUser?.id,
        'device_fingerprint': _deviceFingerprint,
      });
      
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
        context: 'rebuilt_signout',
        shouldRetry: false,
      );
    }
  }

  /// Enhanced biometric authentication
  Future<AuthResponse?> authenticateWithBiometrics() async {
    try {
      final isAvailable = await _localAuth.canCheckBiometrics;
      final isDeviceSupported = await _localAuth.isDeviceSupported();
      
      if (!isAvailable || !isDeviceSupported) {
        throw Exception('Biometric authentication is not available on this device');
      }

      final availableBiometrics = await _localAuth.getAvailableBiometrics();
      
      final didAuthenticate = await _localAuth.authenticate(
        localizedReason: 'Please authenticate to access your account',
        options: const AuthenticationOptions(
          biometricOnly: true,
          stickyAuth: true,
        ),
      );

      if (didAuthenticate) {
        // Validate current session
        final session = _supabaseService.client.auth.currentSession;
        if (session != null && !session.isExpired) {
          await _logSecurityEvent('biometric_auth_success', {
            'user_id': session.user.id,
            'biometric_types': availableBiometrics.map((e) => e.name).toList(),
            'device_fingerprint': _deviceFingerprint,
          });
          
          return AuthResponse(
            user: session.user,
            session: session,
          );
        } else {
          throw Exception('No valid session found after biometric authentication');
        }
      } else {
        throw Exception('Biometric authentication was cancelled or failed');
      }
      
    } catch (e) {
      await _logSecurityEvent('biometric_auth_failed', {
        'error': e.toString(),
        'device_fingerprint': _deviceFingerprint,
      });
      
      await _errorHandler.handleError(
        e,
        context: 'rebuilt_biometric_authentication',
        shouldRetry: false,
      );
      return null;
    }
  }

  /// Cache user data securely
  Future<void> _cacheUserDataSecurely(User user, Session? session) async {
    try {
      await _storageService.setValue('cached_user_id', user.id);
      await _storageService.setValue('cached_user_email', user.email ?? '');
      await _storageService.setValue('last_signin_time', DateTime.now().toIso8601String());
      
      if (session != null) {
        await _storageService.setValue('session_expires_at', session.expiresAt.toString());
      }
    } catch (e) {
      debugPrint('Failed to cache user data: $e');
    }
  }

  /// Update cached session data securely
  Future<void> _updateCachedSessionSecurely(Session session) async {
    try {
      await _storageService.setValue('last_token_refresh', DateTime.now().toIso8601String());
      await _storageService.setValue('session_expires_at', session.expiresAt.toString());
    } catch (e) {
      debugPrint('Failed to update cached session: $e');
    }
  }

  /// Clear secure data
  Future<void> _clearSecureData() async {
    try {
      final keysToRemove = [
        'cached_user_id',
        'cached_user_email',
        'last_signin_time',
        'last_token_refresh',
        'session_expires_at',
        'user_preferences',
        'biometric_enabled',
      ];
      
      for (final key in keysToRemove) {
        await _storageService.remove(key);
      }
    } catch (e) {
      debugPrint('Failed to clear secure data: $e');
    }
  }

  /// Sync user profile with database
  Future<void> _syncUserProfile(User user) async {
    try {
      // Check if user profile exists in database
      final existingProfile = await _supabaseService.executeWithRetry(
        () => _supabaseService.client
            .from('user_profiles')
            .select()
            .eq('id', user.id)
            .maybeSingle(),
        offlineDefault: null,
      );
      
      if (existingProfile == null) {
        // Create user profile
        final profileData = {
          'id': user.id,
          'email': user.email,
          'full_name': user.userMetadata?['full_name'] ?? user.email?.split('@')[0],
          'avatar_url': user.userMetadata?['avatar_url'],
          'role': 'member', // Default role
        };
        
        await _supabaseService.executeWithRetry(
          () => _supabaseService.client
              .from('user_profiles')
              .insert(profileData),
        );
        
        debugPrint('✅ User profile created');
      }
      
    } catch (e) {
      debugPrint('Failed to sync user profile: $e');
    }
  }

  /// Log security events
  Future<void> _logSecurityEvent(String eventType, Map<String, dynamic> data) async {
    try {
      final eventData = {
        'event_type': eventType,
        'timestamp': DateTime.now().toIso8601String(),
        'user_agent': 'Mewayz Mobile App',
        'data': data,
      };
      
      await _supabaseService.executeWithRetry(
        () => _supabaseService.client
            .from('security_events')
            .insert(eventData),
        requiresConnection: true,
        offlineDefault: null,
      );
      
    } catch (e) {
      // Don't throw on logging failures
      debugPrint('Failed to log security event: $e');
    }
  }

  /// Broadcast auth status changes
  void _broadcastAuthStatus() {
    final status = getAuthStatus();
    _authStatusController.add(status);
  }

  /// Check if user is logged in with comprehensive validation
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
        debugPrint('Session is expired, attempting refresh');
        try {
          await _refreshSession();
          // Check again after refresh
          final newSession = _supabaseService.client.auth.currentSession;
          if (newSession == null || newSession.isExpired) {
            _currentUser = null;
            return false;
          }
        } catch (e) {
          debugPrint('Session refresh failed: $e');
          _currentUser = null;
          return false;
        }
      }

      _currentUser = user;
      return true;
      
    } catch (e) {
      debugPrint('Error checking login status: $e');
      _currentUser = null;
      return false;
    }
  }

  /// Get comprehensive auth status
  Map<String, dynamic> getAuthStatus() {
    final session = _supabaseService.client.auth.currentSession;
    
    return {
      'is_initialized': _isInitialized,
      'is_authenticated': _currentUser != null,
      'is_authenticating': _isAuthenticating,
      'current_user_id': _currentUser?.id,
      'current_user_email': _currentUser?.email,
      'session_valid': session != null && !session.isExpired,
      'session_expires_at': session?.expiresAt,
      'time_until_expiry': session != null && session.expiresAt != null 
          ? session.expiresAt! - (DateTime.now().millisecondsSinceEpoch ~/ 1000)
          : null,
      'session_refresh_active': _sessionRefreshTimer?.isActive ?? false,
      'auth_validation_active': _authValidationTimer?.isActive ?? false,
      'device_fingerprint': _deviceFingerprint,
      'supabase_health_score': _supabaseService.getConnectionHealthScore(),
      'supabase_status': _supabaseService.getServiceStatus(),
      'last_status_check': DateTime.now().toIso8601String(),
    };
  }

  /// Get current user
  User? get currentUser => _currentUser;

  /// Check if authenticated
  bool get isAuthenticated => _currentUser != null;

  /// Check if initialized
  bool get isInitialized => _isInitialized;

  /// Check if authenticating
  bool get isAuthenticating => _isAuthenticating;

  /// Get auth state changes stream
  Stream<AuthState> get onAuthStateChanged => _authStateController.stream;

  /// Get auth status changes stream
  Stream<Map<String, dynamic>> get onAuthStatusChanged => _authStatusController.stream;

  /// Dispose resources
  void dispose() {
    _sessionRefreshTimer?.cancel();
    _authValidationTimer?.cancel();
    _authStateController.close();
    _authStatusController.close();
    _errorHandler.dispose();
  }
}