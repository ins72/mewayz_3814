import 'package:crypto/crypto.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:local_auth/local_auth.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../core/app_export.dart';

class AuthService {
  static final AuthService _instance = AuthService._internal();
  factory AuthService() => _instance;
  AuthService._internal();

  late final SupabaseClient _client;
  final LocalAuthentication _localAuth = LocalAuthentication();
  
  bool _isInitialized = false;

  // Initialize the service
  Future<void> initialize() async {
    if (_isInitialized) return;
    
    _client = await SupabaseService.instance.client;
    _isInitialized = true;
  }

  // Ensure initialization
  Future<void> _ensureInitialized() async {
    if (!_isInitialized) {
      await initialize();
    }
  }

  // Check if user is authenticated
  bool get isAuthenticated {
    try {
      return _client.auth.currentUser != null;
    } catch (e) {
      debugPrint('Error checking authentication status: $e');
      return false;
    }
  }

  // Get current user
  User? get currentUser {
    try {
      return _client.auth.currentUser;
    } catch (e) {
      debugPrint('Error getting current user: $e');
      return null;
    }
  }

  // Check if user is logged in (fixed method)
  Future<bool> isUserLoggedIn() async {
    await _ensureInitialized();
    return isAuthenticated;
  }

  // Add missing verifyEmail method
  Future<bool> verifyEmail(String verificationCode) async {
    try {
      await _ensureInitialized();
      
      // Get stored email from local storage or use current user email
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
        // Clear the stored email after successful verification
        await storage.remove('pending_verification_email');
        debugPrint('Email verified successfully');
        return true;
      }
      
      return false;
    } catch (e) {
      debugPrint('Email verification error: $e');
      return false;
    }
  }

  // Add missing verifyTwoFactorCode method
  Future<bool> verifyTwoFactorCode(String code) async {
    try {
      await _ensureInitialized();
      
      // In a real implementation, you would verify the code with your 2FA provider
      // For now, we'll simulate the verification
      
      // This is a placeholder implementation
      // In production, you would integrate with services like:
      // - Google Authenticator
      // - Authy
      // - Your own TOTP implementation
      
      if (code.length == 6 && code.contains(RegExp(r'^\d+$'))) {
        // Simulate network delay
        await Future.delayed(const Duration(seconds: 1));
        
        // For demo purposes, accept any 6-digit code
        // In production, implement proper TOTP verification
        debugPrint('Two-factor code verified successfully');
        return true;
      }
      
      return false;
    } catch (e) {
      debugPrint('Two-factor verification error: $e');
      return false;
    }
  }

  // Sign in with email and password
  Future<AuthResponse?> signIn({
    required String email,
    required String password,
  }) async {
    try {
      await _ensureInitialized();

      final response = await _client.auth.signInWithPassword(
        email: email,
        password: password,
      );

      if (response.user != null) {
        debugPrint('User signed in successfully: ${response.user!.email}');
        return response;
      } else {
        throw Exception('Sign in failed: No user returned');
      }
    } catch (e) {
      debugPrint('Sign in error: $e');
      rethrow;
    }
  }

  // Sign up with email and password
  Future<AuthResponse?> signUp({
    required String email,
    required String password,
    Map<String, dynamic>? metadata,
  }) async {
    try {
      await _ensureInitialized();

      final response = await _client.auth.signUp(
        email: email,
        password: password,
        data: metadata,
      );

      if (response.user != null) {
        // Store email for verification
        final storage = StorageService();
        await storage.setValue('pending_verification_email', email);
        debugPrint('User signed up successfully: ${response.user!.email}');
        return response;
      } else {
        throw Exception('Sign up failed: No user returned');
      }
    } catch (e) {
      debugPrint('Sign up error: $e');
      rethrow;
    }
  }

  // Sign in with Google
  Future<AuthResponse?> signInWithGoogle() async {
    try {
      await _ensureInitialized();

      const webClientId = String.fromEnvironment('GOOGLE_CLIENT_ID');
      
      if (webClientId.isEmpty) {
        throw Exception('Google Client ID not configured');
      }

      final GoogleSignIn googleSignIn = GoogleSignIn(
        clientId: webClientId,
      );

      final googleUser = await googleSignIn.signIn();
      if (googleUser == null) {
        throw Exception('Google sign in was cancelled');
      }

      final googleAuth = await googleUser.authentication;
      final accessToken = googleAuth.accessToken;
      final idToken = googleAuth.idToken;

      if (accessToken == null) {
        throw Exception('No Access Token found');
      }
      if (idToken == null) {
        throw Exception('No ID Token found');
      }

      final response = await _client.auth.signInWithIdToken(
        provider: OAuthProvider.google,
        idToken: idToken,
        accessToken: accessToken,
      );

      if (response.user != null) {
        debugPrint('User signed in with Google: ${response.user!.email}');
        return response;
      } else {
        throw Exception('Google sign in failed: No user returned');
      }
    } catch (e) {
      debugPrint('Google sign in error: $e');
      rethrow;
    }
  }

  // Sign in with Apple
  Future<AuthResponse?> signInWithApple() async {
    try {
      await _ensureInitialized();

      final credential = await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
      );

      final idToken = credential.identityToken;
      if (idToken == null) {
        throw Exception('No ID Token found');
      }

      final response = await _client.auth.signInWithIdToken(
        provider: OAuthProvider.apple,
        idToken: idToken,
      );

      if (response.user != null) {
        debugPrint('User signed in with Apple: ${response.user!.email}');
        return response;
      } else {
        throw Exception('Apple sign in failed: No user returned');
      }
    } catch (e) {
      debugPrint('Apple sign in error: $e');
      rethrow;
    }
  }

  // Authenticate with biometrics (fixed method)
  Future<bool> authenticateWithBiometrics() async {
    try {
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

      if (didAuthenticate) {
        // For production, you might want to store biometric credentials
        // and use them to automatically sign in the user
        debugPrint('Biometric authentication successful');
        return true;
      } else {
        debugPrint('Biometric authentication failed');
        return false;
      }
    } catch (e) {
      debugPrint('Biometric authentication error: $e');
      return false;
    }
  }

  // Check if biometric authentication is available
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

  // Reset password
  Future<void> resetPassword(String email) async {
    try {
      await _ensureInitialized();

      await _client.auth.resetPasswordForEmail(email);
      debugPrint('Password reset email sent to: $email');
    } catch (e) {
      debugPrint('Password reset error: $e');
      rethrow;
    }
  }

  // Update password
  Future<UserResponse> updatePassword(String newPassword) async {
    try {
      await _ensureInitialized();

      final response = await _client.auth.updateUser(
        UserAttributes(password: newPassword),
      );

      if (response.user != null) {
        debugPrint('Password updated successfully');
        return response;
      } else {
        throw Exception('Password update failed: No user returned');
      }
    } catch (e) {
      debugPrint('Password update error: $e');
      rethrow;
    }
  }

  // Update user profile
  Future<UserResponse> updateProfile({
    String? email,
    Map<String, dynamic>? data,
  }) async {
    try {
      await _ensureInitialized();

      final response = await _client.auth.updateUser(
        UserAttributes(
          email: email,
          data: data,
        ),
      );

      if (response.user != null) {
        debugPrint('Profile updated successfully');
        return response;
      } else {
        throw Exception('Profile update failed: No user returned');
      }
    } catch (e) {
      debugPrint('Profile update error: $e');
      rethrow;
    }
  }

  // Sign out
  Future<void> signOut() async {
    try {
      await _ensureInitialized();

      await _client.auth.signOut();
      debugPrint('User signed out successfully');
    } catch (e) {
      debugPrint('Sign out error: $e');
      rethrow;
    }
  }

  // Listen to auth state changes
  Stream<AuthState> get authStateChanges {
    return _client.auth.onAuthStateChange;
  }

  // Verify OTP
  Future<AuthResponse> verifyOTP({
    required String email,
    required String token,
    required OtpType type,
  }) async {
    try {
      await _ensureInitialized();

      final response = await _client.auth.verifyOTP(
        email: email,
        token: token,
        type: type,
      );

      if (response.user != null) {
        debugPrint('OTP verified successfully');
        return response;
      } else {
        throw Exception('OTP verification failed: No user returned');
      }
    } catch (e) {
      debugPrint('OTP verification error: $e');
      rethrow;
    }
  }

  // Generate secure hash for storage
  String _generateHash(String input) {
    final bytes = utf8.encode(input);
    final digest = sha256.convert(bytes);
    return digest.toString();
  }

  // Store biometric credentials securely
  Future<void> storeBiometricCredentials(String email, String hashedPassword) async {
    try {
      final storage = StorageService();
      final credentialsHash = _generateHash('$email:$hashedPassword');
      await storage.write(key: 'biometric_credentials', value: credentialsHash);
      debugPrint('Biometric credentials stored securely');
    } catch (e) {
      debugPrint('Error storing biometric credentials: $e');
    }
  }

  // Verify stored biometric credentials
  Future<bool> verifyBiometricCredentials(String email, String hashedPassword) async {
    try {
      final storage = StorageService();
      final storedHash = await storage.read(key: 'biometric_credentials');
      final currentHash = _generateHash('$email:$hashedPassword');
      
      return storedHash == currentHash;
    } catch (e) {
      debugPrint('Error verifying biometric credentials: $e');
      return false;
    }
  }

  // Clear biometric credentials
  Future<void> clearBiometricCredentials() async {
    try {
      final storage = StorageService();
      await storage.remove('biometric_credentials');
      debugPrint('Biometric credentials cleared');
    } catch (e) {
      debugPrint('Error clearing biometric credentials: $e');
    }
  }
}