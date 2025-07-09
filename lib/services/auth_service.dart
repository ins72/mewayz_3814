import 'package:supabase_flutter/supabase_flutter.dart';

import '../core/app_export.dart';

class AuthService {
  static final AuthService _instance = AuthService._internal();
  late final SupabaseClient _client;

  factory AuthService() {
    return _instance;
  }

  AuthService._internal();

  Future<void> initialize() async {
    try {
      final supabaseService = SupabaseService();
      _client = await supabaseService.client;
      debugPrint('AuthService initialized successfully');
    } catch (e) {
      ErrorHandler.handleError('Failed to initialize AuthService: $e');
      rethrow;
    }
  }

  // Sign up new user
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
      }

      return response;
    } catch (e) {
      ErrorHandler.handleError('Failed to sign in user: $e');
      rethrow;
    }
  }

  // Sign out current user
  Future<void> signOut() async {
    try {
      await _client.auth.signOut();
      debugPrint('User signed out successfully');
    } catch (e) {
      ErrorHandler.handleError('Failed to sign out user: $e');
      rethrow;
    }
  }

  // Get current user
  User? get currentUser => _client.auth.currentUser;

  // Check if user is authenticated
  bool get isAuthenticated => currentUser != null;

  // Auth state stream
  Stream<AuthState> get authStateChanges => _client.auth.onAuthStateChange;

  // Reset password
  Future<void> resetPassword(String email) async {
    try {
      await _client.auth.resetPasswordForEmail(email);
      debugPrint('Password reset email sent to: $email');
    } catch (e) {
      ErrorHandler.handleError('Failed to reset password: $e');
      rethrow;
    }
  }

  // Update user password
  Future<UserResponse?> updatePassword(String newPassword) async {
    try {
      final response = await _client.auth.updateUser(
        UserAttributes(
          password: newPassword,
        ),
      );
      
      debugPrint('Password updated successfully');
      return response;
    } catch (e) {
      ErrorHandler.handleError('Failed to update password: $e');
      rethrow;
    }
  }

  // Update user email
  Future<UserResponse?> updateEmail(String newEmail) async {
    try {
      final response = await _client.auth.updateUser(
        UserAttributes(
          email: newEmail,
        ),
      );
      
      debugPrint('Email update requested');
      return response;
    } catch (e) {
      ErrorHandler.handleError('Failed to update email: $e');
      rethrow;
    }
  }

  // OAuth sign in
  Future<bool> signInWithOAuth(OAuthProvider provider) async {
    try {
      final response = await _client.auth.signInWithOAuth(provider);
      return response;
    } catch (e) {
      ErrorHandler.handleError('Failed to sign in with OAuth: $e');
      rethrow;
    }
  }
}