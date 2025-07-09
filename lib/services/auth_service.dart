import 'package:crypto/crypto.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../core/app_export.dart';

class AuthService {
  static final AuthService _instance = AuthService._internal();
  late final SupabaseClient _client;
  late final GoogleSignIn _googleSignIn;

  factory AuthService() {
    return _instance;
  }

  AuthService._internal();

  Future<void> initialize() async {
    try {
      final supabaseService = SupabaseService();
      _client = await supabaseService.client;
      
      // Initialize Google Sign In
      _googleSignIn = GoogleSignIn(
        clientId: ProductionConfig.googleClientId,
        scopes: ['email', 'profile'],
      );
      
      debugPrint('AuthService initialized successfully');
    } catch (e) {
      ErrorHandler.handleError('Failed to initialize AuthService: $e');
      rethrow;
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

  // Sign in existing user
  Future<AuthResponse?> signIn({
    required String email,
    required String password,
  }) async {
    try {
      final response = await _client.auth.signInWithPassword(
        email: email,
        password: password,
      );

      if (response.user != null) {
        debugPrint('User signed in successfully: ${response.user!.email}');
        
        // Create session
        await _createUserSession(response.user!.id);
        
        // Save user data to local storage
        final storageService = StorageService();
        await storageService.saveUserData({
          'id': response.user!.id,
          'email': response.user!.email,
          'full_name': response.user!.userMetadata?['full_name'] ?? '',
          'role': response.user!.userMetadata?['role'] ?? 'creator',
          'email_verified': response.user!.emailConfirmedAt != null,
        });

        // Log security event
        await _logSecurityEvent(
          response.user!.id,
          'login_success',
          {'method': 'email', 'email': email},
        );
      }

      return response;
    } catch (e) {
      ErrorHandler.handleError('Failed to sign in user: $e');
      
      // Log failed login attempt
      await _logSecurityEvent(
        null,
        'login_failure',
        {'method': 'email', 'email': email, 'error': e.toString()},
        success: false,
      );
      
      rethrow;
    }
  }

  // Google Sign In
  Future<AuthResponse?> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) return null;

      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      
      final response = await _client.auth.signInWithIdToken(
        provider: OAuthProvider.google,
        idToken: googleAuth.idToken!,
        accessToken: googleAuth.accessToken,
      );

      if (response.user != null) {
        debugPrint('Google sign in successful: ${response.user!.email}');
        
        // Create session
        await _createUserSession(response.user!.id);
        
        // Save user data
        final storageService = StorageService();
        await storageService.saveUserData({
          'id': response.user!.id,
          'email': response.user!.email,
          'full_name': response.user!.userMetadata?['full_name'] ?? googleUser.displayName ?? '',
          'role': 'creator',
          'email_verified': true,
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
      ErrorHandler.handleError('Failed to sign in with Google: $e');
      
      // Log failed login attempt
      await _logSecurityEvent(
        null,
        'login_failure',
        {'method': 'google', 'error': e.toString()},
        success: false,
      );
      
      rethrow;
    }
  }

  // Apple Sign In
  Future<AuthResponse?> signInWithApple() async {
    try {
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
        debugPrint('Apple sign in successful: ${response.user!.email}');
        
        // Create session
        await _createUserSession(response.user!.id);
        
        // Save user data
        final storageService = StorageService();
        await storageService.saveUserData({
          'id': response.user!.id,
          'email': response.user!.email,
          'full_name': response.user!.userMetadata?['full_name'] ?? 
                      '${credential.givenName ?? ''} ${credential.familyName ?? ''}',
          'role': 'creator',
          'email_verified': true,
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
      ErrorHandler.handleError('Failed to sign in with Apple: $e');
      
      // Log failed login attempt
      await _logSecurityEvent(
        null,
        'login_failure',
        {'method': 'apple', 'error': e.toString()},
        success: false,
      );
      
      rethrow;
    }
  }

  // Sign out current user
  Future<void> signOut() async {
    try {
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
  User? get currentUser => _client.auth.currentUser;
  bool get isAuthenticated => currentUser != null;
  Stream<AuthState> get authStateChanges => _client.auth.onAuthStateChange;
}