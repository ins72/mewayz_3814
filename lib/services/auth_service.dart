import 'package:crypto/crypto.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:local_auth/local_auth.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../core/app_export.dart';

class AuthService {
  static final AuthService _instance = AuthService._internal();
  late final SupabaseClient _client;
  late final GoogleSignIn _googleSignIn;
  late final LocalAuthentication _localAuth;
  bool _isInitialized = false;

  factory AuthService() {
    return _instance;
  }

  AuthService._internal();

  Future<void> initialize() async {
    if (_isInitialized) return;
    
    try {
      final supabaseService = SupabaseService();
      _client = await supabaseService.client;
      
      // Initialize Google Sign In
      _googleSignIn = GoogleSignIn(
        clientId: ProductionConfig.googleClientId,
        scopes: ['email', 'profile'],
      );
      
      // Initialize Local Authentication
      _localAuth = LocalAuthentication();
      
      _isInitialized = true;
      debugPrint('AuthService initialized successfully');
    } catch (e) {
      ErrorHandler.handleError('Failed to initialize AuthService: $e');
      rethrow;
    }
  }

  // Check if biometric authentication is available
  Future<bool> isBiometricAvailable() async {
    try {
      await _ensureInitialized();
      final bool isAvailable = await _localAuth.canCheckBiometrics;
      final bool isDeviceSupported = await _localAuth.isDeviceSupported();
      final List<BiometricType> availableBiometrics = await _localAuth.getAvailableBiometrics();
      
      return isAvailable && isDeviceSupported && availableBiometrics.isNotEmpty;
    } catch (e) {
      debugPrint('Error checking biometric availability: $e');
      return false;
    }
  }

  // Authenticate with biometrics
  Future<bool> authenticateWithBiometrics() async {
    try {
      await _ensureInitialized();
      
      if (!await isBiometricAvailable()) {
        throw Exception('Biometric authentication not available');
      }

      final bool didAuthenticate = await _localAuth.authenticate(
        localizedReason: 'Please authenticate to access your account',
        options: const AuthenticationOptions(
          biometricOnly: true,
          stickyAuth: true,
        ),
      );

      if (didAuthenticate) {
        // Check if user has stored session
        final StorageService storageService = StorageService();
        final userData = await storageService.getUserData();
        
        if (userData != null && userData['biometric_enabled'] == true) {
          // Log security event
          await _logSecurityEvent(
            userData['id'],
            'biometric_login_success',
            {'method': 'biometric'},
          );
          
          return true;
        }
      }
      
      return false;
    } catch (e) {
      ErrorHandler.handleError('Biometric authentication failed: $e');
      return false;
    }
  }

  // Enable biometric authentication for user
  Future<bool> enableBiometricAuthentication() async {
    try {
      await _ensureInitialized();
      
      if (!await isBiometricAvailable()) {
        throw Exception('Biometric authentication not available on this device');
      }

      final bool didAuthenticate = await _localAuth.authenticate(
        localizedReason: 'Please authenticate to enable biometric login',
        options: const AuthenticationOptions(
          biometricOnly: true,
          stickyAuth: true,
        ),
      );

      if (didAuthenticate) {
        // Save biometric preference
        final StorageService storageService = StorageService();
        final userData = await storageService.getUserData();
        
        if (userData != null) {
          userData['biometric_enabled'] = true;
          await storageService.saveUserData(userData);
          
          // Log security event
          await _logSecurityEvent(
            userData['id'],
            'biometric_enabled',
            {'method': 'settings'},
          );
          
          return true;
        }
      }
      
      return false;
    } catch (e) {
      ErrorHandler.handleError('Failed to enable biometric authentication: $e');
      return false;
    }
  }

  // Disable biometric authentication
  Future<bool> disableBiometricAuthentication() async {
    try {
      await _ensureInitialized();
      
      final StorageService storageService = StorageService();
      final userData = await storageService.getUserData();
      
      if (userData != null) {
        userData['biometric_enabled'] = false;
        await storageService.saveUserData(userData);
        
        // Log security event
        await _logSecurityEvent(
          userData['id'],
          'biometric_disabled',
          {'method': 'settings'},
        );
        
        return true;
      }
      
      return false;
    } catch (e) {
      ErrorHandler.handleError('Failed to disable biometric authentication: $e');
      return false;
    }
  }

  // Sign up new user with email verification
  Future<AuthResponse?> signUp({
    required String email,
    required String password,
    required String fullName,
    String role = 'creator',
  }) async {
    try {
      await _ensureInitialized();
      
      final response = await _client.auth.signUp(
        email: email,
        password: password,
        data: {
          'full_name': fullName,
          'role': role,
        },
      );

      if (response.user != null) {
        debugPrint('User signed up successfully: ${response.user!.email}');
        
        // Send email verification
        await _sendEmailVerification(response.user!.id);
        
        // Save user data to local storage
        final storageService = StorageService();
        await storageService.saveUserData({
          'id': response.user!.id,
          'email': response.user!.email,
          'full_name': fullName,
          'role': role,
          'email_verified': false,
          'biometric_enabled': false,
        });

        // Log security event
        await _logSecurityEvent(
          response.user!.id,
          'user_signup',
          {'method': 'email', 'email': email},
        );
      }

      return response;
    } catch (e) {
      ErrorHandler.handleError('Failed to sign up user: $e');
      rethrow;
    }
  }

  // Sign in existing user with enhanced error handling
  Future<AuthResponse?> signIn({
    required String email,
    required String password,
  }) async {
    try {
      await _ensureInitialized();
      
      // Validate input parameters
      if (email.isEmpty || password.isEmpty) {
        throw Exception('Email and password are required');
      }

      final response = await _client.auth.signInWithPassword(
        email: email,
        password: password,
      );

      // Enhanced response validation
      if (response.user != null) {
        debugPrint('User signed in successfully: ${response.user!.email}');
        
        // Create session
        await _createUserSession(response.user!.id);
        
        // Save user data to local storage with persistent session
        final storageService = StorageService();
        await storageService.saveUserData({
          'id': response.user!.id,
          'email': response.user!.email,
          'full_name': response.user!.userMetadata?['full_name'] ?? '',
          'role': response.user!.userMetadata?['role'] ?? 'creator',
          'email_verified': response.user!.emailConfirmedAt != null,
          'biometric_enabled': false,
          'logged_in': true,
          'session_token': response.session?.accessToken,
        });

        // Log security event
        await _logSecurityEvent(
          response.user!.id,
          'login_success',
          {'method': 'email', 'email': email},
        );
      } else {
        throw Exception('Invalid credentials or user not found');
      }

      return response;
    } on AuthException catch (e) {
      // Handle Supabase auth exceptions specifically
      String errorMessage = 'Authentication failed';
      
      switch (e.statusCode) {
        case '400':
          errorMessage = 'Invalid email or password format';
          break;
        case '401':
          errorMessage = 'Invalid email or password';
          break;
        case '422':
          errorMessage = 'Email not confirmed. Please check your email';
          break;
        case '429':
          errorMessage = 'Too many login attempts. Please try again later';
          break;
        default:
          errorMessage = e.message ?? 'Authentication failed';
      }
      
      // Log failed login attempt
      await _logSecurityEvent(
        null,
        'login_failure',
        {'method': 'email', 'email': email, 'error': errorMessage},
        success: false,
      );
      
      ErrorHandler.handleAuthError(errorMessage);
      throw Exception(errorMessage);
    } catch (e) {
      // Handle JSON parsing and other errors
      String errorMessage = 'Authentication failed';
      
      if (e.toString().contains('JSON') || e.toString().contains('SyntaxError')) {
        errorMessage = 'Server response error. Please try again';
      } else if (e.toString().contains('Network') || e.toString().contains('Connection')) {
        errorMessage = 'Network error. Please check your connection';
      } else if (e.toString().contains('Timeout')) {
        errorMessage = 'Request timeout. Please try again';
      }
      
      // Log failed login attempt
      await _logSecurityEvent(
        null,
        'login_failure',
        {'method': 'email', 'email': email, 'error': e.toString()},
        success: false,
      );
      
      ErrorHandler.handleAuthError(errorMessage);
      throw Exception(errorMessage);
    }
  }

  // Check if user is logged in from storage
  Future<bool> isUserLoggedIn() async {
    try {
      await _ensureInitialized();
      
      // Check current session
      final currentSession = _client.auth.currentSession;
      if (currentSession != null && !currentSession.isExpired) {
        return true;
      }
      
      // Check stored session
      final StorageService storageService = StorageService();
      final userData = await storageService.getUserData();
      
      return userData != null && userData['logged_in'] == true;
    } catch (e) {
      debugPrint('Error checking login status: $e');
      return false;
    }
  }

  // Google Sign In with enhanced error handling
  Future<AuthResponse?> signInWithGoogle() async {
    try {
      await _ensureInitialized();
      
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        throw Exception('Google sign in was cancelled');
      }

      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      
      if (googleAuth.idToken == null) {
        throw Exception('Google authentication failed - no ID token');
      }
      
      final response = await _client.auth.signInWithIdToken(
        provider: OAuthProvider.google,
        idToken: googleAuth.idToken!,
        accessToken: googleAuth.accessToken,
      );

      if (response.user != null) {
        debugPrint('Google sign in successful: ${response.user!.email}');
        
        // Create session
        await _createUserSession(response.user!.id);
        
        // Save user data with persistent session
        final storageService = StorageService();
        await storageService.saveUserData({
          'id': response.user!.id,
          'email': response.user!.email,
          'full_name': response.user!.userMetadata?['full_name'] ?? googleUser.displayName ?? '',
          'role': 'creator',
          'email_verified': true,
          'biometric_enabled': false,
          'logged_in': true,
          'session_token': response.session?.accessToken,
        });

        // Log security event
        await _logSecurityEvent(
          response.user!.id,
          'login_success',
          {'method': 'google', 'email': response.user!.email},
        );
      }

      return response;
    } catch (e) {
      String errorMessage = 'Google sign in failed';
      
      if (e.toString().contains('cancelled')) {
        errorMessage = 'Google sign in was cancelled';
      } else if (e.toString().contains('network')) {
        errorMessage = 'Network error during Google sign in';
      }
      
      ErrorHandler.handleAuthError(errorMessage);
      
      // Log failed login attempt
      await _logSecurityEvent(
        null,
        'login_failure',
        {'method': 'google', 'error': errorMessage},
        success: false,
      );
      
      throw Exception(errorMessage);
    }
  }

  // Apple Sign In with enhanced error handling
  Future<AuthResponse?> signInWithApple() async {
    try {
      await _ensureInitialized();
      
      final credential = await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
      );

      if (credential.identityToken == null) {
        throw Exception('Apple authentication failed - no identity token');
      }

      final response = await _client.auth.signInWithIdToken(
        provider: OAuthProvider.apple,
        idToken: credential.identityToken!,
      );

      if (response.user != null) {
        debugPrint('Apple sign in successful: ${response.user!.email}');
        
        // Create session
        await _createUserSession(response.user!.id);
        
        // Save user data with persistent session
        final storageService = StorageService();
        await storageService.saveUserData({
          'id': response.user!.id,
          'email': response.user!.email,
          'full_name': response.user!.userMetadata?['full_name'] ?? 
                      '${credential.givenName ?? ''} ${credential.familyName ?? ''}',
          'role': 'creator',
          'email_verified': true,
          'biometric_enabled': false,
          'logged_in': true,
          'session_token': response.session?.accessToken,
        });

        // Log security event
        await _logSecurityEvent(
          response.user!.id,
          'login_success',
          {'method': 'apple', 'email': response.user!.email},
        );
      }

      return response;
    } catch (e) {
      String errorMessage = 'Apple sign in failed';
      
      if (e.toString().contains('cancelled')) {
        errorMessage = 'Apple sign in was cancelled';
      } else if (e.toString().contains('network')) {
        errorMessage = 'Network error during Apple sign in';
      }
      
      ErrorHandler.handleAuthError(errorMessage);
      
      // Log failed login attempt
      await _logSecurityEvent(
        null,
        'login_failure',
        {'method': 'apple', 'error': errorMessage},
        success: false,
      );
      
      throw Exception(errorMessage);
    }
  }

  // Sign out current user
  Future<void> signOut() async {
    try {
      await _ensureInitialized();
      
      final userId = currentUser?.id;
      
      await _client.auth.signOut();
      
      // Clear user data from local storage
      final storageService = StorageService();
      await storageService.clearAuthData();
      
      // Sign out from Google
      await _googleSignIn.signOut();
      
      // Log security event
      if (userId != null) {
        await _logSecurityEvent(
          userId,
          'logout',
          {'method': 'manual'},
        );
      }
      
      debugPrint('User signed out successfully');
    } catch (e) {
      ErrorHandler.handleError('Failed to sign out user: $e');
      rethrow;
    }
  }

  // Ensure AuthService is initialized
  Future<void> _ensureInitialized() async {
    if (!_isInitialized) {
      await initialize();
    }
  }

  // Send email verification
  Future<void> _sendEmailVerification(String userId) async {
    try {
      final code = _generateVerificationCode();
      
      await _client.from('email_verification_codes').insert({
        'user_id': userId,
        'email': currentUser?.email,
        'code': code,
        'expires_at': DateTime.now().add(Duration(minutes: 10)).toIso8601String(),
      });
      
      // In a real app, you would send this via email service
      debugPrint('Email verification code: $code');
    } catch (e) {
      ErrorHandler.handleError('Failed to send email verification: $e');
    }
  }

  // Verify email with code
  Future<bool> verifyEmail(String code) async {
    try {
      final userId = currentUser?.id;
      if (userId == null) return false;
      
      final result = await _client.rpc('verify_email_code', params: {
        'user_uuid': userId,
        'verification_code': code,
      });
      
      if (result == true) {
        // Update local storage
        final storageService = StorageService();
        final userData = await storageService.getUserData();
        if (userData != null) {
          userData['email_verified'] = true;
          await storageService.saveUserData(userData);
        }
        
        // Log security event
        await _logSecurityEvent(
          userId,
          'email_verified',
          {'method': 'verification_code'},
        );
        
        return true;
      }
      
      return false;
    } catch (e) {
      ErrorHandler.handleError('Failed to verify email: $e');
      return false;
    }
  }

  // Generate 2FA backup codes
  Future<List<String>> generateBackupCodes() async {
    try {
      final userId = currentUser?.id;
      if (userId == null) throw Exception('User not authenticated');
      
      final codes = List.generate(8, (index) => _generateBackupCode());
      
      await _client.from('user_two_factor_auth').upsert({
        'user_id': userId,
        'backup_codes': codes,
        'updated_at': DateTime.now().toIso8601String(),
      });
      
      return codes;
    } catch (e) {
      ErrorHandler.handleError('Failed to generate backup codes: $e');
      rethrow;
    }
  }

  // Enable 2FA
  Future<String> enableTwoFactorAuth() async {
    try {
      final userId = currentUser?.id;
      if (userId == null) throw Exception('User not authenticated');
      
      final secret = _generateSecretKey();
      
      await _client.from('user_two_factor_auth').upsert({
        'user_id': userId,
        'is_enabled': true,
        'secret_key': secret,
        'updated_at': DateTime.now().toIso8601String(),
      });
      
      return secret;
    } catch (e) {
      ErrorHandler.handleError('Failed to enable 2FA: $e');
      rethrow;
    }
  }

  // Verify 2FA code
  Future<bool> verifyTwoFactorCode(String code) async {
    try {
      final userId = currentUser?.id;
      if (userId == null) return false;
      
      // This would typically verify against TOTP
      // For demo purposes, we'll accept any 6-digit code
      final isValid = code.length == 6 && int.tryParse(code) != null;
      
      if (isValid) {
        await _logSecurityEvent(
          userId,
          '2fa_verification_success',
          {'method': 'totp'},
        );
      } else {
        await _logSecurityEvent(
          userId,
          '2fa_verification_failure',
          {'method': 'totp'},
          success: false,
        );
      }
      
      return isValid;
    } catch (e) {
      ErrorHandler.handleError('Failed to verify 2FA code: $e');
      return false;
    }
  }

  // Reset password
  Future<void> resetPassword(String email) async {
    try {
      await _client.auth.resetPasswordForEmail(email);
      
      // Log security event
      await _logSecurityEvent(
        null,
        'password_reset_requested',
        {'email': email},
      );
      
      debugPrint('Password reset email sent to: $email');
    } catch (e) {
      ErrorHandler.handleError('Failed to reset password: $e');
      rethrow;
    }
  }

  // Update user password
  Future<UserResponse?> updatePassword(String newPassword) async {
    try {
      final userId = currentUser?.id;
      
      final response = await _client.auth.updateUser(
        UserAttributes(
          password: newPassword,
        ),
      );
      
      if (userId != null) {
        await _logSecurityEvent(
          userId,
          'password_updated',
          {'method': 'manual'},
        );
      }
      
      debugPrint('Password updated successfully');
      return response;
    } catch (e) {
      ErrorHandler.handleError('Failed to update password: $e');
      rethrow;
    }
  }

  // Private helper methods
  Future<void> _createUserSession(String userId) async {
    try {
      await _client.rpc('create_user_session', params: {
        'user_uuid': userId,
        'session_token': _generateSessionToken(),
        'device_info': {
          'device': 'Mobile',
          'os': 'Flutter',
          'app_version': ProductionConfig.appVersion,
        },
      });
    } catch (e) {
      debugPrint('Failed to create user session: $e');
    }
  }

  Future<void> _logSecurityEvent(
    String? userId,
    String actionType,
    Map<String, dynamic> details, {
    bool success = true,
  }) async {
    try {
      await _client.rpc('log_security_event', params: {
        'user_uuid': userId,
        'action_type': actionType,
        'details': details,
        'success_flag': success,
      });
    } catch (e) {
      debugPrint('Failed to log security event: $e');
    }
  }

  String _generateVerificationCode() {
    final random = Random();
    return (100000 + random.nextInt(900000)).toString();
  }

  String _generateBackupCode() {
    final random = Random();
    return (10000000 + random.nextInt(90000000)).toString();
  }

  String _generateSecretKey() {
    final random = Random();
    final bytes = List<int>.generate(20, (i) => random.nextInt(256));
    return base64Encode(bytes);
  }

  String _generateSessionToken() {
    final random = Random();
    final bytes = List<int>.generate(32, (i) => random.nextInt(256));
    return sha256.convert(bytes).toString();
  }

  // Getters
  User? get currentUser => _isInitialized ? _client.auth.currentUser : null;
  bool get isAuthenticated => currentUser != null;
  Stream<AuthState> get authStateChanges => _isInitialized ? _client.auth.onAuthStateChange : const Stream.empty();
}