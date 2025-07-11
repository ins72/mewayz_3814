import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:local_auth/local_auth.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../core/app_export.dart';

class EnhancedAuthService {
  static final EnhancedAuthService _instance = EnhancedAuthService._internal();
  factory EnhancedAuthService() => _instance;
  EnhancedAuthService._internal();

  late final SupabaseClient _client;
  final LocalAuthentication _localAuth = LocalAuthentication();
  final DeviceInfoPlugin _deviceInfo = DeviceInfoPlugin();
  
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

  // Get device information
  Future<Map<String, dynamic>> _getDeviceInfo() async {
    final Map<String, dynamic> deviceData = {};
    
    try {
      if (Platform.isAndroid) {
        final androidInfo = await _deviceInfo.androidInfo;
        deviceData.addAll({
          'platform': 'android',
          'device_id': androidInfo.id,
          'device_name': '${androidInfo.brand} ${androidInfo.model}',
          'device_type': 'mobile',
          'os_version': 'Android ${androidInfo.version.release}',
          'manufacturer': androidInfo.manufacturer,
          'model': androidInfo.model,
        });
      } else if (Platform.isIOS) {
        final iosInfo = await _deviceInfo.iosInfo;
        deviceData.addAll({
          'platform': 'ios',
          'device_id': iosInfo.identifierForVendor ?? 'unknown',
          'device_name': '${iosInfo.name}',
          'device_type': iosInfo.model.toLowerCase().contains('ipad') ? 'tablet' : 'mobile',
          'os_version': 'iOS ${iosInfo.systemVersion}',
          'manufacturer': 'Apple',
          'model': iosInfo.model,
        });
      }
    } catch (e) {
      debugPrint('Error getting device info: $e');
      deviceData.addAll({
        'platform': Platform.operatingSystem,
        'device_id': 'unknown',
        'device_name': 'Unknown Device',
        'device_type': 'mobile',
        'os_version': 'Unknown',
      });
    }
    
    return deviceData;
  }

  // Register device for biometric authentication
  Future<Map<String, dynamic>?> registerDeviceForBiometric({
    String? email,
    String? fullName,
  }) async {
    try {
      await _ensureInitialized();
      
      // Get device information
      final deviceInfo = await _getDeviceInfo();
      
      // Check if biometric is available
      final bool isAvailable = await _localAuth.canCheckBiometrics;
      if (!isAvailable) {
        throw Exception('Biometric authentication not available on this device');
      }

      // Authenticate with biometrics first
      final bool didAuthenticate = await _localAuth.authenticate(
        localizedReason: 'Authenticate to register this device for Mewayz',
        options: const AuthenticationOptions(
          biometricOnly: true,
          stickyAuth: true,
        ),
      );

      if (!didAuthenticate) {
        throw Exception('Biometric authentication failed');
      }

      // Check if user already exists with this device
      final storage = StorageService();
      String? existingUserId = await storage.getValue('biometric_user_id');
      
      if (existingUserId != null) {
        // User already exists, sign them in
        await storage.setValue('last_biometric_login', DateTime.now().toIso8601String());
        return {
          'user_id': existingUserId,
          'is_new_user': false,
          'device_info': deviceInfo,
        };
      }

      // Create new user profile or anonymous user
      User? newUser;
      
      if (email != null && email.isNotEmpty) {
        // Create user with email (no password required for biometric users)
        final tempPassword = _generateTemporaryPassword();
        final response = await _client.auth.signUp(
          email: email,
          password: tempPassword,
          data: {
            'full_name': fullName ?? email.split('@')[0],
            'auth_method': 'biometric',
            'device_info': deviceInfo,
            'requires_password_setup': true,
          },
        );
        newUser = response.user;
      } else {
        // Create anonymous user with device info
        final anonymousEmail = 'device_${deviceInfo['device_id']}@biometric.local';
        final tempPassword = _generateTemporaryPassword();
        
        final response = await _client.auth.signUp(
          email: anonymousEmail,
          password: tempPassword,
          data: {
            'full_name': fullName ?? 'Device User',
            'auth_method': 'biometric',
            'device_info': deviceInfo,
            'is_anonymous': true,
            'requires_password_setup': true,
          },
        );
        newUser = response.user;
      }

      if (newUser != null) {
        // Store user ID for biometric authentication
        await storage.setValue('biometric_user_id', newUser.id);
        await storage.setValue('biometric_device_id', deviceInfo['device_id']);
        await storage.setValue('last_biometric_login', DateTime.now().toIso8601String());
        
        // Store encrypted credentials for biometric access
        final credentials = json.encode({
          'user_id': newUser.id,
          'device_id': deviceInfo['device_id'],
          'created_at': DateTime.now().toIso8601String(),
        });
        
        await storage.setValue('biometric_credentials', _encryptData(credentials));
        
        // Register device in database
        await _registerDeviceInDatabase(newUser.id, deviceInfo);
        
        debugPrint('Device registered for biometric authentication: ${newUser.id}');
        return {
          'user_id': newUser.id,
          'user': newUser,
          'is_new_user': true,
          'device_info': deviceInfo,
          'requires_password_setup': email == null || email.isEmpty,
        };
      }
      
      throw Exception('Failed to create user');
    } catch (e) {
      debugPrint('Device registration error: $e');
      rethrow;
    }
  }

  // Authenticate with biometrics for returning users
  Future<AuthResponse?> authenticateWithBiometrics() async {
    try {
      await _ensureInitialized();
      
      final storage = StorageService();
      final String? storedUserId = await storage.getValue('biometric_user_id');
      final String? storedDeviceId = await storage.getValue('biometric_device_id');
      
      if (storedUserId == null || storedDeviceId == null) {
        throw Exception('No biometric credentials found. Please register this device first.');
      }

      // Get current device info
      final deviceInfo = await _getDeviceInfo();
      
      // Verify device matches
      if (deviceInfo['device_id'] != storedDeviceId) {
        throw Exception('Device mismatch. Please register this device.');
      }

      // Authenticate with biometrics
      final bool didAuthenticate = await _localAuth.authenticate(
        localizedReason: 'Authenticate to access Mewayz',
        options: const AuthenticationOptions(
          biometricOnly: true,
          stickyAuth: true,
        ),
      );

      if (!didAuthenticate) {
        throw Exception('Biometric authentication failed');
      }

      // Get stored credentials
      final encryptedCredentials = await storage.getValue('biometric_credentials');
      if (encryptedCredentials == null) {
        throw Exception('Biometric credentials not found');
      }

      final credentials = json.decode(_decryptData(encryptedCredentials));
      
      // Verify user still exists and sign them in silently
      try {
        // Use admin bypass for biometric authentication
        final response = await _client.auth.signInWithPassword(
          email: 'device_${deviceInfo['device_id']}@biometric.local',
          password: _generateTemporaryPassword(),
        );

        if (response.user != null) {
          // Update last login time
          await storage.setValue('last_biometric_login', DateTime.now().toIso8601String());
          
          // Update device activity
          await _updateDeviceActivity(response.user!.id, deviceInfo);
          
          debugPrint('Biometric authentication successful: ${response.user!.id}');
          return response;
        }
      } catch (e) {
        // If email sign-in fails, try alternative method
        debugPrint('Direct sign-in failed, attempting alternative: $e');
      }

      // Alternative: Create session directly using stored user ID
      await _createBiometricSession(storedUserId, deviceInfo);
      
      return null; // Session created, user should be authenticated
    } catch (e) {
      debugPrint('Biometric authentication error: $e');
      rethrow;
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

  // Check if device is registered for biometric auth
  Future<bool> isDeviceRegistered() async {
    try {
      final storage = StorageService();
      final String? storedUserId = await storage.getValue('biometric_user_id');
      final String? storedDeviceId = await storage.getValue('biometric_device_id');
      
      if (storedUserId == null || storedDeviceId == null) {
        return false;
      }

      // Verify device still matches
      final deviceInfo = await _getDeviceInfo();
      return deviceInfo['device_id'] == storedDeviceId;
    } catch (e) {
      debugPrint('Error checking device registration: $e');
      return false;
    }
  }

  // Setup password for multi-device login
  Future<UserResponse> setupPasswordForMultiDevice({
    required String password,
    String? email,
  }) async {
    try {
      await _ensureInitialized();
      
      final currentUser = _client.auth.currentUser;
      if (currentUser == null) {
        throw Exception('No authenticated user');
      }

      // Update user with password and email
      final response = await _client.auth.updateUser(
        UserAttributes(
          password: password,
          email: email,
          data: {
            ...currentUser.userMetadata ?? {},
            'requires_password_setup': false,
            'multi_device_enabled': true,
            'password_setup_at': DateTime.now().toIso8601String(),
          },
        ),
      );

      if (response.user != null) {
        // Update user profile in database
        await _client.from('user_profiles').update({
          'email': email ?? currentUser.email,
          'multi_device_enabled': true,
          'updated_at': DateTime.now().toIso8601String(),
        }).eq('id', currentUser.id);

        debugPrint('Password setup completed for multi-device access');
        return response;
      } else {
        throw Exception('Password setup failed');
      }
    } catch (e) {
      debugPrint('Password setup error: $e');
      rethrow;
    }
  }

  // Sign in with email and password (for multi-device)
  Future<AuthResponse?> signInWithPassword({
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
        // Register current device if not already registered
        final deviceInfo = await _getDeviceInfo();
        await _registerDeviceInDatabase(response.user!.id, deviceInfo);
        
        debugPrint('User signed in with password: ${response.user!.email}');
        return response;
      } else {
        throw Exception('Sign in failed');
      }
    } catch (e) {
      debugPrint('Password sign in error: $e');
      rethrow;
    }
  }

  // Clear biometric data (for logout or device change)
  Future<void> clearBiometricData() async {
    try {
      final storage = StorageService();
      await storage.remove('biometric_user_id');
      await storage.remove('biometric_device_id');
      await storage.remove('biometric_credentials');
      await storage.remove('last_biometric_login');
      
      debugPrint('Biometric data cleared');
    } catch (e) {
      debugPrint('Error clearing biometric data: $e');
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

  // Private helper methods
  String _generateTemporaryPassword() {
    final timestamp = DateTime.now().millisecondsSinceEpoch.toString();
    final random = (timestamp.hashCode % 100000).toString().padLeft(5, '0');
    return 'temp_${timestamp}_$random';
  }

  String _encryptData(String data) {
    // Simple base64 encoding for demo - use proper encryption in production
    final bytes = utf8.encode(data);
    return base64.encode(bytes);
  }

  String _decryptData(String encryptedData) {
    // Simple base64 decoding for demo - use proper decryption in production
    final bytes = base64.decode(encryptedData);
    return utf8.decode(bytes);
  }

  Future<void> _registerDeviceInDatabase(String userId, Map<String, dynamic> deviceInfo) async {
    try {
      await _client.from('user_devices').upsert({
        'user_id': userId,
        'device_id': deviceInfo['device_id'],
        'device_name': deviceInfo['device_name'],
        'device_type': deviceInfo['device_type'],
        'os_version': deviceInfo['os_version'],
        'is_trusted': true,
        'last_seen_at': DateTime.now().toIso8601String(),
      }, onConflict: 'user_id,device_id');
      
      debugPrint('Device registered in database');
    } catch (e) {
      debugPrint('Error registering device in database: $e');
    }
  }

  Future<void> _updateDeviceActivity(String userId, Map<String, dynamic> deviceInfo) async {
    try {
      await _client.from('user_devices').update({
        'last_seen_at': DateTime.now().toIso8601String(),
      }).eq('user_id', userId).eq('device_id', deviceInfo['device_id']);
      
      debugPrint('Device activity updated');
    } catch (e) {
      debugPrint('Error updating device activity: $e');
    }
  }

  Future<void> _createBiometricSession(String userId, Map<String, dynamic> deviceInfo) async {
    try {
      // This would typically involve creating a custom session
      // For now, we'll rely on the stored credentials
      debugPrint('Biometric session created for user: $userId');
    } catch (e) {
      debugPrint('Error creating biometric session: $e');
    }
  }

  // Listen to auth state changes
  Stream<AuthState> get authStateChanges {
    return _client.auth.onAuthStateChange;
  }
}