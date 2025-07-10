import 'dart:async';

import 'package:crypto/crypto.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:local_auth/local_auth.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../core/app_export.dart';
import '../core/enhanced_supabase_service.dart';

/// Enhanced authentication service with biometric support and security optimizations
class EnhancedAuthService {
  static final EnhancedAuthService _instance = EnhancedAuthService._internal();
  factory EnhancedAuthService() => _instance;
  EnhancedAuthService._internal();

  late final SupabaseClient _client;
  final LocalAuthentication _localAuth = LocalAuthentication();
  
  bool _isInitialized = false;
  String? _currentSessionToken;
  Map<String, dynamic>? _userSecurityProfile;

  // Enhanced session management
  Timer? _sessionTimer;
  StreamSubscription<AuthState>? _authStateSubscription;

  // Initialize the enhanced service
  Future<void> initialize() async {
    if (_isInitialized) return;
    
    try {
      _client = await EnhancedSupabaseService.instance.client;
      
      // Setup auth state monitoring
      _setupAuthStateMonitoring();
      
      // Initialize session management
      await _initializeSessionManagement();
      
      _isInitialized = true;
      debugPrint('✅ Enhanced Auth Service initialized');
    } catch (e) {
      debugPrint('Failed to initialize Enhanced AuthService: $e');
      _isInitialized = false;
    }
  }

  /// Setup enhanced auth state monitoring
  void _setupAuthStateMonitoring() {
    _authStateSubscription = _client.auth.onAuthStateChange.listen((data) {
      final event = data.event;
      final user = data.session?.user;
      
      switch (event) {
        case AuthChangeEvent.signedIn:
          _onUserSignedIn(user, data.session);
          break;
        case AuthChangeEvent.signedOut:
          _onUserSignedOut();
          break;
        case AuthChangeEvent.tokenRefreshed:
          _onTokenRefreshed(data.session);
          break;
        default:
          break;
      }
    });
  }

  /// Initialize enhanced session management
  Future<void> _initializeSessionManagement() async {
    final currentUser = _client.auth.currentUser;
    if (currentUser != null) {
      await _createEnhancedSession(currentUser);
    }
  }

  /// Handle user sign in with enhanced session creation
  Future<void> _onUserSignedIn(User? user, Session? session) async {
    if (user != null && session != null) {
      await _createEnhancedSession(user);
      await _loadUserSecurityProfile(user.id);
      
      // Record sign in analytics
      await _recordAuthEvent('user_signed_in', {
        'user_id': user.id,
        'auth_method': 'enhanced',
      });
    }
  }

  /// Handle user sign out with cleanup
  Future<void> _onUserSignedOut() async {
    await _cleanupEnhancedSession();
    _userSecurityProfile = null;
    
    await _recordAuthEvent('user_signed_out', {});
  }

  /// Handle token refresh
  Future<void> _onTokenRefreshed(Session? session) async {
    if (session != null) {
      await _updateSessionActivity();
    }
  }

  /// Create enhanced session with security tracking
  Future<void> _createEnhancedSession(User user) async {
    try {
      _currentSessionToken = _generateSecureToken();
      
      // Get device information
      final deviceInfo = await _getDeviceFingerprint();
      
      // Create enhanced session record
      await _client.rpc('create_enhanced_session', params: {
        'user_uuid': user.id,
        'session_token_param': _currentSessionToken,
        'device_fingerprint_param': deviceInfo,
        'ip_address_param': await _getCurrentIP(),
        'user_agent_param': await _getUserAgent(),
      });
      
      // Setup session refresh timer
      _setupSessionTimer();
      
      debugPrint('✅ Enhanced session created for user: ${user.email}');
    } catch (e) {
      debugPrint('Failed to create enhanced session: $e');
    }
  }

  /// Update session activity
  Future<void> _updateSessionActivity() async {
    if (_currentSessionToken != null) {
      try {
        await _client.rpc('update_session_activity', params: {
          'session_token_param': _currentSessionToken,
        });
      } catch (e) {
        debugPrint('Failed to update session activity: $e');
      }
    }
  }

  /// Setup session refresh timer
  void _setupSessionTimer() {
    _sessionTimer?.cancel();
    _sessionTimer = Timer.periodic(const Duration(minutes: 5), (_) {
      _updateSessionActivity();
    });
  }

  /// Cleanup enhanced session
  Future<void> _cleanupEnhancedSession() async {
    if (_currentSessionToken != null) {
      try {
        await _client.rpc('cleanup_enhanced_session', params: {
          'session_token_param': _currentSessionToken,
        });
      } catch (e) {
        debugPrint('Failed to cleanup enhanced session: $e');
      }
    }
    
    _sessionTimer?.cancel();
    _currentSessionToken = null;
  }

  /// Load user security profile
  Future<void> _loadUserSecurityProfile(String userId) async {
    try {
      final profile = await _client.rpc('get_user_security_profile', params: {
        'user_uuid': userId,
      });
      
      _userSecurityProfile = profile as Map<String, dynamic>?;
    } catch (e) {
      debugPrint('Failed to load user security profile: $e');
    }
  }

  // Ensure initialization
  Future<void> _ensureInitialized() async {
    if (!_isInitialized) {
      await initialize();
    }
  }

  // Check if user is authenticated with enhanced verification
  bool get isAuthenticated {
    try {
      if (!_isInitialized) return false;
      return _client.auth.currentUser != null && _currentSessionToken != null;
    } catch (e) {
      debugPrint('Error checking enhanced authentication status: $e');
      return false;
    }
  }

  // Get current user with enhanced profile
  User? get currentUser {
    try {
      if (!_isInitialized) return null;
      return _client.auth.currentUser;
    } catch (e) {
      debugPrint('Error getting current user: $e');
      return null;
    }
  }

  /// Get user security profile
  Map<String, dynamic>? get userSecurityProfile => _userSecurityProfile;

  /// Check if user is logged in with enhanced verification
  Future<bool> isUserLoggedIn() async {
    await _ensureInitialized();
    
    if (!isAuthenticated) return false;
    
    // Verify session is still valid
    return await _verifyEnhancedSession();
  }

  /// Verify enhanced session validity
  Future<bool> _verifyEnhancedSession() async {
    if (_currentSessionToken == null) return false;
    
    try {
      final verification = await _client.rpc('verify_enhanced_authentication', params: {
        'user_uuid': currentUser?.id,
        'session_token_param': _currentSessionToken,
        'device_fingerprint_param': await _getDeviceFingerprint(),
      });
      
      final result = verification as Map<String, dynamic>?;
      return result?['authenticated'] == true;
    } catch (e) {
      debugPrint('Session verification failed: $e');
      return false;
    }
  }

  /// Enhanced sign in with email and password
  Future<AuthResponse?> signIn({
    required String email,
    required String password,
  }) async {
    try {
      await _ensureInitialized();

      if (!_isInitialized) {
        debugPrint('Enhanced AuthService not initialized - simulating sign in');
        return null;
      }

      final response = await _client.auth.signInWithPassword(
        email: email,
        password: password,
      );

      if (response.user != null) {
        await _recordAuthEvent('email_signin_success', {
          'email': email,
          'user_id': response.user!.id,
        });
        
        debugPrint('User signed in successfully: ${response.user!.email}');
        return response;
      } else {
        await _recordAuthEvent('email_signin_failed', {
          'email': email,
          'reason': 'no_user_returned',
        });
        throw Exception('Sign in failed: No user returned');
      }
    } catch (e) {
      await _recordAuthEvent('email_signin_error', {
        'email': email,
        'error': e.toString(),
      });
      debugPrint('Enhanced sign in error: $e');
      rethrow;
    }
  }

  /// Enhanced sign up with email and password
  Future<AuthResponse?> signUp({
    required String email,
    required String password,
    Map<String, dynamic>? metadata,
  }) async {
    try {
      await _ensureInitialized();

      if (!_isInitialized) {
        debugPrint('Enhanced AuthService not initialized - simulating sign up');
        final storage = StorageService();
        await storage.setValue('pending_verification_email', email);
        return null;
      }

      final response = await _client.auth.signUp(
        email: email,
        password: password,
        data: metadata,
      );

      if (response.user != null) {
        // Store email for verification
        final storage = StorageService();
        await storage.setValue('pending_verification_email', email);
        
        // Create initial security profile
        await _createInitialSecurityProfile(response.user!.id);
        
        await _recordAuthEvent('email_signup_success', {
          'email': email,
          'user_id': response.user!.id,
        });
        
        debugPrint('User signed up successfully: ${response.user!.email}');
        return response;
      } else {
        await _recordAuthEvent('email_signup_failed', {
          'email': email,
          'reason': 'no_user_returned',
        });
        throw Exception('Sign up failed: No user returned');
      }
    } catch (e) {
      await _recordAuthEvent('email_signup_error', {
        'email': email,
        'error': e.toString(),
      });
      debugPrint('Enhanced sign up error: $e');
      rethrow;
    }
  }

  /// Create initial security profile for new users
  Future<void> _createInitialSecurityProfile(String userId) async {
    try {
      await _client.rpc('create_initial_security_profile', params: {
        'user_uuid': userId,
        'initial_security_level': 1,
      });
    } catch (e) {
      debugPrint('Failed to create initial security profile: $e');
    }
  }

  /// Check if device is registered for biometric authentication
  Future<bool> checkDeviceRegistration() async {
    try {
      await _ensureInitialized();
      
      if (currentUser == null) return false;
      
      final deviceId = await _getDeviceId();
      final result = await _client.rpc('check_device_registration', params: {
        'user_uuid': currentUser!.id,
        'device_id_param': deviceId,
      });
      
      final resultMap = result as Map<String, dynamic>?;
      return resultMap?['is_registered'] == true;
    } catch (e) {
      debugPrint('Error checking device registration: $e');
      return false;
    }
  }

  /// Check if device is registered (alias for backward compatibility)
  Future<bool> isDeviceRegistered() async {
    return await checkDeviceRegistration();
  }

  /// Register device for biometric authentication
  Future<Map<String, dynamic>?> registerDevice({
    String? email,
    String? fullName,
  }) async {
    try {
      await _ensureInitialized();
      
      if (currentUser == null) {
        throw Exception('User must be authenticated to register device');
      }
      
      final deviceId = await _getDeviceId();
      final deviceFingerprint = await _getDeviceFingerprint();
      
      final result = await _client.rpc('register_device_for_biometrics', params: {
        'user_uuid': currentUser!.id,
        'device_id_param': deviceId,
        'device_fingerprint_param': deviceFingerprint,
        'device_name_param': await _getDeviceName(),
        'email_param': email,
        'full_name_param': fullName,
      });
      
      await _recordAuthEvent('device_registration_success', {
        'user_id': currentUser!.id,
        'device_id': deviceId,
      });
      
      return result as Map<String, dynamic>?;
    } catch (e) {
      await _recordAuthEvent('device_registration_error', {
        'user_id': currentUser?.id,
        'error': e.toString(),
      });
      debugPrint('Device registration error: $e');
      rethrow;
    }
  }

  /// Register biometrics (new method name for consistency)
  Future<Map<String, dynamic>?> registerBiometrics({
    String? email,
    String? fullName,
  }) async {
    return await registerDevice(email: email, fullName: fullName);
  }

  /// Enhanced biometric authentication
  Future<bool> authenticateWithBiometrics({
    String biometricType = 'fingerprint',
  }) async {
    try {
      await _ensureInitialized();
      
      // Check if biometric authentication is available
      final bool isAvailable = await _localAuth.canCheckBiometrics;
      if (!isAvailable) {
        debugPrint('Biometric authentication not available');
        return false;
      }

      // Check if device has biometric setup
      final List<BiometricType> availableBiometrics = 
          await _localAuth.getAvailableBiometrics();
      
      if (availableBiometrics.isEmpty) {
        debugPrint('No biometric authentication methods available');
        return false;
      }

      // Perform biometric authentication
      final bool didAuthenticate = await _localAuth.authenticate(
        localizedReason: 'Please authenticate to access Mewayz',
        options: const AuthenticationOptions(
          biometricOnly: true,
          stickyAuth: true,
        ),
      );

      if (didAuthenticate && currentUser != null) {
        // Verify with database
        final verification = await _client.rpc('verify_biometric_authentication', params: {
          'user_uuid': currentUser!.id,
          'biometric_type_param': biometricType,
          'device_id_param': await _getDeviceId(),
        });
        
        final verificationMap = verification as Map<String, dynamic>?;
        final verified = verificationMap != null && verificationMap['verified'] == true;
        
        if (verified) {
          await _recordAuthEvent('biometric_auth_success', {
            'user_id': currentUser!.id,
            'biometric_type': biometricType,
          });
          
          // Update session with biometric verification
          await _updateSessionBiometricStatus(true);
          
          debugPrint('Enhanced biometric authentication successful');
          return true;
        }
      }
      
      await _recordAuthEvent('biometric_auth_failed', {
        'user_id': currentUser?.id,
        'biometric_type': biometricType,
      });
      
      return false;
    } catch (e) {
      await _recordAuthEvent('biometric_auth_error', {
        'user_id': currentUser?.id,
        'error': e.toString(),
      });
      debugPrint('Enhanced biometric authentication error: $e');
      return false;
    }
  }

  /// Setup biometric authentication for user
  Future<bool> setupBiometricAuthentication({
    String biometricType = 'fingerprint',
    int securityLevel = 1,
  }) async {
    try {
      await _ensureInitialized();
      
      if (currentUser == null) {
        throw Exception('User must be authenticated to setup biometric auth');
      }
      
      // Check biometric availability
      final isAvailable = await isBiometricAvailable();
      if (!isAvailable) {
        return false;
      }
      
      // Perform initial biometric authentication
      final authenticated = await _localAuth.authenticate(
        localizedReason: 'Setup biometric authentication for Mewayz',
        options: const AuthenticationOptions(
          biometricOnly: true,
          stickyAuth: true,
        ),
      );
      
      if (!authenticated) {
        return false;
      }
      
      // Store biometric data in database
      await _client.rpc('setup_biometric_authentication', params: {
        'user_uuid': currentUser!.id,
        'biometric_type_param': biometricType,
        'device_id_param': await _getDeviceId(),
        'security_level_param': securityLevel,
      });
      
      await _recordAuthEvent('biometric_setup_success', {
        'user_id': currentUser!.id,
        'biometric_type': biometricType,
      });
      
      debugPrint('Biometric authentication setup successful');
      return true;
    } catch (e) {
      await _recordAuthEvent('biometric_setup_error', {
        'user_id': currentUser?.id,
        'error': e.toString(),
      });
      debugPrint('Biometric setup error: $e');
      return false;
    }
  }

  /// Enhanced two-factor authentication verification
  Future<bool> verifyTwoFactorCode(String code, {String method = 'authenticator'}) async {
    try {
      await _ensureInitialized();
      
      if (currentUser == null) {
        return false;
      }
      
      final verification = await _client.rpc('verify_two_factor_authentication', params: {
        'user_uuid': currentUser!.id,
        'verification_code': code,
        'method_type_param': method,
      });
      
      final verificationMap = verification as Map<String, dynamic>?;
      final verified = verificationMap != null && verificationMap['verified'] == true;
      
      if (verified) {
        // Update session with 2FA verification
        await _updateSessionTwoFactorStatus(true);
        
        await _recordAuthEvent('two_factor_success', {
          'user_id': currentUser!.id,
          'method': method,
        });
        
        debugPrint('Two-factor authentication successful');
        return true;
      }
      
      await _recordAuthEvent('two_factor_failed', {
        'user_id': currentUser!.id,
        'method': method,
      });
      
      return false;
    } catch (e) {
      await _recordAuthEvent('two_factor_error', {
        'user_id': currentUser?.id,
        'error': e.toString(),
      });
      debugPrint('Two-factor verification error: $e');
      return false;
    }
  }

  /// Setup two-factor authentication
  Future<Map<String, dynamic>?> setupTwoFactorAuthentication({
    String method = 'authenticator',
    String? phoneNumber,
    String? email,
  }) async {
    try {
      await _ensureInitialized();
      
      if (currentUser == null) {
        throw Exception('User must be authenticated to setup 2FA');
      }
      
      final setup = await _client.rpc('setup_two_factor_authentication', params: {
        'user_uuid': currentUser!.id,
        'method_type_param': method,
        'phone_number_param': phoneNumber,
        'email_address_param': email,
      });
      
      await _recordAuthEvent('two_factor_setup_initiated', {
        'user_id': currentUser!.id,
        'method': method,
      });
      
      return setup as Map<String, dynamic>?;
    } catch (e) {
      await _recordAuthEvent('two_factor_setup_error', {
        'user_id': currentUser?.id,
        'error': e.toString(),
      });
      debugPrint('Two-factor setup error: $e');
      return null;
    }
  }

  /// Update session biometric status
  Future<void> _updateSessionBiometricStatus(bool verified) async {
    if (_currentSessionToken != null) {
      try {
        await _client.rpc('update_session_biometric_status', params: {
          'session_token_param': _currentSessionToken,
          'biometric_verified_param': verified,
        });
      } catch (e) {
        debugPrint('Failed to update session biometric status: $e');
      }
    }
  }

  /// Update session two-factor status
  Future<void> _updateSessionTwoFactorStatus(bool verified) async {
    if (_currentSessionToken != null) {
      try {
        await _client.rpc('update_session_two_factor_status', params: {
          'session_token_param': _currentSessionToken,
          'two_factor_verified_param': verified,
        });
      } catch (e) {
        debugPrint('Failed to update session two-factor status: $e');
      }
    }
  }

  /// Enhanced sign out with cleanup
  Future<void> signOut() async {
    try {
      await _ensureInitialized();

      if (!_isInitialized) {
        debugPrint('Enhanced AuthService not initialized - simulating sign out');
        return;
      }

      // Record sign out before cleanup
      await _recordAuthEvent('user_signout_initiated', {
        'user_id': currentUser?.id,
      });

      // Cleanup enhanced session
      await _cleanupEnhancedSession();

      // Sign out from Supabase
      await _client.auth.signOut();
      
      debugPrint('Enhanced user signed out successfully');
    } catch (e) {
      debugPrint('Enhanced sign out error: $e');
      rethrow;
    }
  }

  /// Helper methods
  Future<String> _getDeviceFingerprint() async {
    try {
      // Mock implementation since DeviceInfoService is not defined
      return _generateHash('mock_device_fingerprint');
    } catch (e) {
      return _generateHash('unknown_device');
    }
  }

  Future<String> _getDeviceId() async {
    try {
      // Mock implementation since DeviceInfoService is not defined
      return 'mock_device_id';
    } catch (e) {
      return 'unknown';
    }
  }

  Future<String> _getDeviceName() async {
    try {
      // Mock implementation
      return 'Mewayz Device';
    } catch (e) {
      return 'Unknown Device';
    }
  }

  Future<String> _getCurrentIP() async {
    // This would get the actual IP address
    return '0.0.0.0'; // Placeholder
  }

  Future<String> _getUserAgent() async {
    // This would get the actual user agent
    return 'Mewayz/1.0.0'; // Placeholder
  }

  String _generateSecureToken() {
    final random = Random.secure();
    final bytes = List<int>.generate(32, (_) => random.nextInt(256));
    return base64Encode(bytes);
  }

  String _generateHash(String input) {
    final bytes = utf8.encode(input);
    final digest = sha256.convert(bytes);
    return digest.toString();
  }

  /// Record authentication events for analytics
  Future<void> _recordAuthEvent(String eventName, Map<String, dynamic> data) async {
    try {
      if (_isInitialized) {
        await _client.rpc('track_analytics_event', params: {
          'event_name': 'auth_$eventName',
          'event_data': data,
          'workspace_uuid': null, // Auth events are user-level
        });
      }
    } catch (e) {
      // Silently fail for analytics
    }
  }

  /// Check if biometric authentication is available
  Future<bool> isBiometricAvailable() async {
    try {
      final bool isAvailable = await _localAuth.canCheckBiometrics;
      final List<BiometricType> availableBiometrics = 
          await _localAuth.getAvailableBiometrics();
      
      return isAvailable && availableBiometrics.isNotEmpty;
    } catch (e) {
      debugPrint('Error checking biometric availability: $e');
      return false;
    }
  }

  /// Get user's authentication methods
  Future<List<String>> getUserAuthMethods() async {
    try {
      if (currentUser == null) return [];
      
      final methods = await _client.rpc('get_user_auth_methods', params: {
        'user_uuid': currentUser!.id,
      });
      
      return List<String>.from(methods as List? ?? []);
    } catch (e) {
      debugPrint('Error getting user auth methods: $e');
      return [];
    }
  }

  /// Get security score for current session
  Future<int> getSecurityScore() async {
    try {
      if (_currentSessionToken == null) return 0;
      
      final score = await _client.rpc('get_session_security_score', params: {
        'session_token_param': _currentSessionToken,
      });
      
      return (score as int?) ?? 0;
    } catch (e) {
      debugPrint('Error getting security score: $e');
      return 0;
    }
  }

  /// Dispose and cleanup
  Future<void> dispose() async {
    _sessionTimer?.cancel();
    await _authStateSubscription?.cancel();
    await _cleanupEnhancedSession();
    
    debugPrint('🧹 Enhanced Auth Service disposed');
  }

  /// Listen to auth state changes
  Stream<AuthState>? get authStateChanges {
    try {
      if (!_isInitialized) return null;
      return _client.auth.onAuthStateChange;
    } catch (e) {
      debugPrint('Error getting auth state changes: $e');
      return null;
    }
  }

  /// Additional methods for backward compatibility with existing auth service
  Future<bool> verifyEmail(String verificationCode) async {
    try {
      await _ensureInitialized();
      
      if (!_isInitialized) {
        return verificationCode.length == 6;
      }
      
      final storage = StorageService();
      final storedEmail = await storage.getValue('pending_verification_email');
      
      if (storedEmail == null) {
        throw Exception('No email found for verification');
      }
      
      final response = await _client.auth.verifyOTP(
        email: storedEmail,
        token: verificationCode,
        type: OtpType.signup,
      );
      
      if (response.user != null) {
        await storage.remove('pending_verification_email');
        
        await _recordAuthEvent('email_verification_success', {
          'email': storedEmail,
          'user_id': response.user!.id,
        });
        
        return true;
      }
      
      return false;
    } catch (e) {
      await _recordAuthEvent('email_verification_error', {
        'error': e.toString(),
      });
      debugPrint('Email verification error: $e');
      return false;
    }
  }

  /// OAuth sign-in methods
  Future<AuthResponse?> signInWithGoogle() async {
    try {
      await _ensureInitialized();

      if (!_isInitialized) {
        return null;
      }

      const webClientId = String.fromEnvironment('GOOGLE_CLIENT_ID');
      
      if (webClientId.isEmpty) {
        throw Exception('Google Client ID not configured');
      }

      final GoogleSignIn googleSignIn = GoogleSignIn(clientId: webClientId);
      final googleUser = await googleSignIn.signIn();
      
      if (googleUser == null) {
        throw Exception('Google sign in was cancelled');
      }

      final googleAuth = await googleUser.authentication;
      final response = await _client.auth.signInWithIdToken(
        provider: OAuthProvider.google,
        idToken: googleAuth.idToken!,
        accessToken: googleAuth.accessToken!,
      );

      if (response.user != null) {
        await _recordAuthEvent('google_signin_success', {
          'user_id': response.user!.id,
          'email': response.user!.email,
        });
        
        return response;
      }
      
      return null;
    } catch (e) {
      await _recordAuthEvent('google_signin_error', {
        'error': e.toString(),
      });
      debugPrint('Google sign in error: $e');
      rethrow;
    }
  }

  Future<AuthResponse?> signInWithApple() async {
    try {
      await _ensureInitialized();

      if (!_isInitialized) {
        return null;
      }

      final credential = await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
      );

      final response = await _client.auth.signInWithIdToken(
        provider: OAuthProvider.apple,
        idToken: credential.identityToken!,
      );

      if (response.user != null) {
        await _recordAuthEvent('apple_signin_success', {
          'user_id': response.user!.id,
          'email': response.user!.email,
        });
        
        return response;
      }
      
      return null;
    } catch (e) {
      await _recordAuthEvent('apple_signin_error', {
        'error': e.toString(),
      });
      debugPrint('Apple sign in error: $e');
      rethrow;
    }
  }

  // Password management
  Future<void> resetPassword(String email) async {
    try {
      await _ensureInitialized();

      if (!_isInitialized) {
        return;
      }

      await _client.auth.resetPasswordForEmail(email);
      
      await _recordAuthEvent('password_reset_requested', {
        'email': email,
      });
      
      debugPrint('Password reset email sent to: $email');
    } catch (e) {
      await _recordAuthEvent('password_reset_error', {
        'email': email,
        'error': e.toString(),
      });
      debugPrint('Password reset error: $e');
      rethrow;
    }
  }

  Future<UserResponse?> updatePassword(String newPassword) async {
    try {
      await _ensureInitialized();

      if (!_isInitialized) {
        return null;
      }

      final response = await _client.auth.updateUser(
        UserAttributes(password: newPassword),
      );

      if (response.user != null) {
        await _recordAuthEvent('password_updated', {
          'user_id': response.user!.id,
        });
        
        debugPrint('Password updated successfully');
        return response;
      }
      
      return null;
    } catch (e) {
      await _recordAuthEvent('password_update_error', {
        'user_id': currentUser?.id,
        'error': e.toString(),
      });
      debugPrint('Password update error: $e');
      rethrow;
    }
  }

  Future<UserResponse?> updateProfile({
    String? email,
    Map<String, dynamic>? data,
  }) async {
    try {
      await _ensureInitialized();

      if (!_isInitialized) {
        return null;
      }

      final response = await _client.auth.updateUser(
        UserAttributes(
          email: email,
          data: data,
        ),
      );

      if (response.user != null) {
        await _recordAuthEvent('profile_updated', {
          'user_id': response.user!.id,
          'fields_updated': [
            if (email != null) 'email',
            if (data != null) ...data.keys,
          ],
        });
        
        debugPrint('Profile updated successfully');
        return response;
      }
      
      return null;
    } catch (e) {
      await _recordAuthEvent('profile_update_error', {
        'user_id': currentUser?.id,
        'error': e.toString(),
      });
      debugPrint('Profile update error: $e');
      rethrow;
    }
  }

  Future<AuthResponse?> verifyOTP({
    required String email,
    required String token,
    required OtpType type,
  }) async {
    try {
      await _ensureInitialized();

      if (!_isInitialized) {
        return null;
      }

      final response = await _client.auth.verifyOTP(
        email: email,
        token: token,
        type: type,
      );

      if (response.user != null) {
        await _recordAuthEvent('otp_verification_success', {
          'email': email,
          'type': type.toString(),
          'user_id': response.user!.id,
        });
        
        return response;
      }
      
      return null;
    } catch (e) {
      await _recordAuthEvent('otp_verification_error', {
        'email': email,
        'type': type.toString(),
        'error': e.toString(),
      });
      debugPrint('OTP verification error: $e');
      rethrow;
    }
  }
}

// Create alias for backward compatibility
typedef AuthService = EnhancedAuthService;