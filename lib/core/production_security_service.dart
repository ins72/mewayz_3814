import 'dart:io';

import 'package:crypto/crypto.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:local_auth/local_auth.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'app_export.dart';

/// Production-grade security service for enhanced authentication and device management
class ProductionSecurityService {
  static final ProductionSecurityService _instance = ProductionSecurityService._internal();
  factory ProductionSecurityService() => _instance;
  ProductionSecurityService._internal();

  late final SupabaseClient _client;
  final LocalAuthentication _localAuth = LocalAuthentication();
  final DeviceInfoPlugin _deviceInfo = DeviceInfoPlugin();
  
  bool _isInitialized = false;
  String? _deviceFingerprint;
  String? _encryptionKey;

  /// Initialize the security service
  Future<void> initialize() async {
    if (_isInitialized) return;
    
    try {
      _client = Supabase.instance.client;
      _deviceFingerprint = await _generateDeviceFingerprint();
      _encryptionKey = await _generateEncryptionKey();
      _isInitialized = true;
      
      debugPrint('✅ Production Security Service initialized');
    } catch (e) {
      debugPrint('❌ Security service initialization failed: $e');
      rethrow;
    }
  }

  Future<void> _ensureInitialized() async {
    if (!_isInitialized) {
      await initialize();
    }
  }

  /// Generate unique device fingerprint for security tracking
  Future<String> _generateDeviceFingerprint() async {
    try {
      final Map<String, dynamic> deviceData = {};
      
      if (Platform.isAndroid) {
        final androidInfo = await _deviceInfo.androidInfo;
        deviceData.addAll({
          'platform': 'android',
          'brand': androidInfo.brand,
          'model': androidInfo.model,
          'device': androidInfo.device,
          'id': androidInfo.id,
          'hardware': androidInfo.hardware,
          'bootloader': androidInfo.bootloader,
          'fingerprint': androidInfo.fingerprint,
        });
      } else if (Platform.isIOS) {
        final iosInfo = await _deviceInfo.iosInfo;
        deviceData.addAll({
          'platform': 'ios',
          'name': iosInfo.name,
          'model': iosInfo.model,
          'systemName': iosInfo.systemName,
          'systemVersion': iosInfo.systemVersion,
          'identifierForVendor': iosInfo.identifierForVendor,
          'isPhysicalDevice': iosInfo.isPhysicalDevice,
        });
      }

      // Add package info
      final packageInfo = await PackageInfo.fromPlatform();
      deviceData.addAll({
        'appName': packageInfo.appName,
        'packageName': packageInfo.packageName,
        'version': packageInfo.version,
        'buildNumber': packageInfo.buildNumber,
      });

      // Generate fingerprint hash
      final fingerprintString = json.encode(deviceData);
      final bytes = utf8.encode(fingerprintString);
      final digest = sha256.convert(bytes);
      
      return digest.toString();
    } catch (e) {
      debugPrint('Error generating device fingerprint: $e');
      return 'unknown_device_${DateTime.now().millisecondsSinceEpoch}';
    }
  }

  /// Generate encryption key for secure data storage
  Future<String> _generateEncryptionKey() async {
    try {
      final storage = StorageService();
      String? existingKey = await storage.getValue('encryption_key');
      
      if (existingKey != null && existingKey.isNotEmpty) {
        return existingKey;
      }

      // Generate new encryption key
      final timestamp = DateTime.now().millisecondsSinceEpoch.toString();
      final fingerprint = _deviceFingerprint ?? 'unknown';
      final keyString = '$timestamp-$fingerprint-${Platform.operatingSystem}';
      final bytes = utf8.encode(keyString);
      final digest = sha512.convert(bytes);
      final encryptionKey = digest.toString();

      await storage.setValue('encryption_key', encryptionKey);
      return encryptionKey;
    } catch (e) {
      debugPrint('Error generating encryption key: $e');
      return 'fallback_key_${DateTime.now().millisecondsSinceEpoch}';
    }
  }

  /// Authenticate user with enhanced security checks
  Future<Map<String, dynamic>> authenticateWithEnhancedSecurity({
    required String email,
    String? password,
    bool biometricVerification = false,
  }) async {
    try {
      await _ensureInitialized();

      // Get detailed device information
      final deviceInfo = await _getDetailedDeviceInfo();
      
      // Check rate limiting first
      final rateLimitOk = await _checkRateLimit(email, 'authentication');
      if (!rateLimitOk) {
        throw Exception('Rate limit exceeded. Please try again later.');
      }

      // Perform biometric verification if requested
      if (biometricVerification) {
        final biometricResult = await _performBiometricAuthentication();
        if (!biometricResult) {
          await _logSecurityEvent(
            null, 'biometric_authentication_failed', false, 
            'Biometric authentication failed', deviceInfo, riskScore: 60
          );
          throw Exception('Biometric authentication failed');
        }
      }

      // Authenticate with Supabase
      AuthResponse? authResponse;
      if (password != null) {
        authResponse = await _client.auth.signInWithPassword(
          email: email,
          password: password,
        );
      } else {
        // For biometric-only authentication, use stored credentials
        authResponse = await _authenticateWithStoredCredentials(email, deviceInfo);
      }

      if (authResponse?.user == null) {
        await _logSecurityEvent(
          null, 'authentication_failed', false, 
          'Invalid credentials', deviceInfo, riskScore: 40
        );
        throw Exception('Authentication failed');
      }

      // Enhanced authentication with device verification
      final result = await _client.rpc('authenticate_user_with_device', params: {
        'user_email': email,
        'device_info': deviceInfo,
        'biometric_verified': biometricVerification,
      });

      // Store secure session data
      await _storeSecureSession(authResponse!.user!, deviceInfo, biometricVerification);

      // Log successful authentication
      await _logSecurityEvent(
        authResponse.user!.id, 'authentication_success', true, 
        'User authenticated successfully', deviceInfo, riskScore: result['risk_score'] ?? 0
      );

      return {
        'success': true,
        'user': authResponse.user,
        'session': authResponse.session,
        'device_info': deviceInfo,
        'risk_score': result['risk_score'] ?? 0,
        'requires_2fa': result['requires_2fa'] ?? false,
        'device_trusted': result['device_trusted'] ?? false,
      };
    } catch (e) {
      await _logSecurityEvent(
        null, 'authentication_error', false, 
        e.toString(), await _getDetailedDeviceInfo(), riskScore: 70
      );
      rethrow;
    }
  }

  /// Perform biometric authentication
  Future<bool> _performBiometricAuthentication() async {
    try {
      final bool isAvailable = await _localAuth.canCheckBiometrics;
      if (!isAvailable) {
        return false;
      }

      final bool didAuthenticate = await _localAuth.authenticate(
        localizedReason: 'Authenticate to access Mewayz',
        options: const AuthenticationOptions(
          biometricOnly: true,
          stickyAuth: true,
        ),
      );

      return didAuthenticate;
    } catch (e) {
      debugPrint('Biometric authentication error: $e');
      return false;
    }
  }

  /// Get detailed device information for security analysis
  Future<Map<String, dynamic>> _getDetailedDeviceInfo() async {
    final Map<String, dynamic> deviceInfo = {};
    
    try {
      if (Platform.isAndroid) {
        final androidInfo = await _deviceInfo.androidInfo;
        deviceInfo.addAll({
          'platform': 'android',
          'device_id': androidInfo.id,
          'device_name': '${androidInfo.brand} ${androidInfo.model}',
          'device_type': 'mobile',
          'os_version': 'Android ${androidInfo.version.release}',
          'manufacturer': androidInfo.manufacturer,
          'model': androidInfo.model,
          'hardware': androidInfo.hardware,
          'is_physical_device': androidInfo.isPhysicalDevice,
          'fingerprint': androidInfo.fingerprint,
          'security_patch': androidInfo.version.securityPatch,
        });
      } else if (Platform.isIOS) {
        final iosInfo = await _deviceInfo.iosInfo;
        deviceInfo.addAll({
          'platform': 'ios',
          'device_id': iosInfo.identifierForVendor ?? 'unknown',
          'device_name': iosInfo.name,
          'device_type': iosInfo.model.toLowerCase().contains('ipad') ? 'tablet' : 'mobile',
          'os_version': 'iOS ${iosInfo.systemVersion}',
          'manufacturer': 'Apple',
          'model': iosInfo.model,
          'is_physical_device': iosInfo.isPhysicalDevice,
          'system_name': iosInfo.systemName,
        });
      }

      // Add app information
      final packageInfo = await PackageInfo.fromPlatform();
      deviceInfo.addAll({
        'app_name': packageInfo.appName,
        'app_version': packageInfo.version,
        'build_number': packageInfo.buildNumber,
        'package_name': packageInfo.packageName,
      });

      // Add security fingerprint
      deviceInfo['security_fingerprint'] = _deviceFingerprint;
      deviceInfo['timestamp'] = DateTime.now().toIso8601String();

      return deviceInfo;
    } catch (e) {
      debugPrint('Error getting device info: $e');
      return {
        'platform': Platform.operatingSystem,
        'device_id': 'unknown',
        'device_name': 'Unknown Device',
        'device_type': 'mobile',
        'error': e.toString(),
      };
    }
  }

  /// Check API rate limiting
  Future<bool> _checkRateLimit(String identifier, String endpoint) async {
    try {
      final currentUser = _client.auth.currentUser;
      if (currentUser == null && identifier.isEmpty) return false;

      final result = await _client.rpc('check_rate_limit', params: {
        'user_uuid': currentUser?.id,
        'endpoint_path': endpoint,
        'requests_per_hour': _getRateLimitForEndpoint(endpoint),
      });

      return result ?? false;
    } catch (e) {
      debugPrint('Rate limit check error: $e');
      return true; // Allow if check fails
    }
  }

  /// Get rate limit for specific endpoint
  int _getRateLimitForEndpoint(String endpoint) {
    switch (endpoint) {
      case 'authentication':
        return 20; // 20 attempts per hour
      case 'password_reset':
        return 5; // 5 attempts per hour
      case 'api_call':
        return 1000; // 1000 API calls per hour
      default:
        return 100;
    }
  }

  /// Authenticate with stored credentials (for biometric users)
  Future<AuthResponse?> _authenticateWithStoredCredentials(
    String email, 
    Map<String, dynamic> deviceInfo
  ) async {
    try {
      final storage = StorageService();
      final encryptedCredentials = await storage.getValue('secure_credentials_$email');
      
      if (encryptedCredentials == null) {
        throw Exception('No stored credentials found');
      }

      final credentials = _decryptData(encryptedCredentials);
      final credentialData = json.decode(credentials);

      // Verify device matches
      if (credentialData['device_id'] != deviceInfo['device_id']) {
        throw Exception('Device mismatch');
      }

      // Use temporary authentication method for biometric users
      final response = await _client.auth.signInWithPassword(
        email: credentialData['email'],
        password: credentialData['temp_password'],
      );

      return response;
    } catch (e) {
      debugPrint('Stored credential authentication error: $e');
      return null;
    }
  }

  /// Store secure session data
  Future<void> _storeSecureSession(
    User user,
    Map<String, dynamic> deviceInfo,
    bool biometricVerified,
  ) async {
    try {
      final storage = StorageService();
      
      // Store session data securely
      final sessionData = {
        'user_id': user.id,
        'email': user.email,
        'device_id': deviceInfo['device_id'],
        'biometric_verified': biometricVerified,
        'login_timestamp': DateTime.now().toIso8601String(),
        'fingerprint': _deviceFingerprint,
      };

      final encryptedSession = _encryptData(json.encode(sessionData));
      await storage.setValue('secure_session', encryptedSession);
      await storage.setValue('last_login', DateTime.now().toIso8601String());

      // Store credentials for biometric authentication if enabled
      if (biometricVerified) {
        final tempPassword = _generateTemporaryPassword();
        final credentialData = {
          'email': user.email,
          'temp_password': tempPassword,
          'device_id': deviceInfo['device_id'],
          'created_at': DateTime.now().toIso8601String(),
        };

        final encryptedCredentials = _encryptData(json.encode(credentialData));
        await storage.setValue('secure_credentials_${user.email}', encryptedCredentials);
      }
    } catch (e) {
      debugPrint('Error storing secure session: $e');
    }
  }

  /// Log security events for audit trail
  Future<void> _logSecurityEvent(
    String? userId,
    String actionType,
    bool success,
    String details,
    Map<String, dynamic> deviceInfo, {
    int riskScore = 0,
  }) async {
    try {
      await _client.from('security_audit_log').insert({
        'user_id': userId,
        'action_type': actionType,
        'success': success,
        'failure_reason': success ? null : details,
        'risk_score': riskScore,
        'ip_address': await _getClientIP(),
        'user_agent': _getUserAgent(),
        'device_id': deviceInfo['device_id'],
        'metadata': {
          'device_info': deviceInfo,
          'app_version': deviceInfo['app_version'],
          'timestamp': DateTime.now().toIso8601String(),
        },
      });
    } catch (e) {
      debugPrint('Error logging security event: $e');
    }
  }

  /// Register device for trusted access
  Future<bool> registerTrustedDevice() async {
    try {
      await _ensureInitialized();
      
      final currentUser = _client.auth.currentUser;
      if (currentUser == null) return false;

      final deviceInfo = await _getDetailedDeviceInfo();
      
      // Perform additional security verification
      final biometricVerified = await _performBiometricAuthentication();
      if (!biometricVerified) {
        throw Exception('Biometric verification required for trusted device registration');
      }

      // Register device in database
      await _client.from('user_devices').upsert({
        'user_id': currentUser.id,
        'device_id': deviceInfo['device_id'],
        'device_name': deviceInfo['device_name'],
        'device_type': deviceInfo['device_type'],
        'os_version': deviceInfo['os_version'],
        'app_version': deviceInfo['app_version'],
        'is_trusted': true,
        'biometric_enabled': true,
        'security_fingerprint': _deviceFingerprint,
        'last_seen_at': DateTime.now().toIso8601String(),
      }, onConflict: 'user_id,device_id');

      await _logSecurityEvent(
        currentUser.id, 'device_registration', true,
        'Device registered as trusted', deviceInfo, riskScore: 0
      );

      debugPrint('✅ Device registered as trusted');
      return true;
    } catch (e) {
      debugPrint('❌ Device registration failed: $e');
      return false;
    }
  }

  /// Check if current device is trusted
  Future<bool> isDeviceTrusted() async {
    try {
      await _ensureInitialized();
      
      final currentUser = _client.auth.currentUser;
      if (currentUser == null) return false;

      final deviceInfo = await _getDetailedDeviceInfo();
      
      final response = await _client
          .from('user_devices')
          .select('is_trusted')
          .eq('user_id', currentUser.id)
          .eq('device_id', deviceInfo['device_id'])
          .maybeSingle();

      return response?['is_trusted'] ?? false;
    } catch (e) {
      debugPrint('Error checking device trust status: $e');
      return false;
    }
  }

  /// Revoke device access
  Future<bool> revokeDeviceAccess(String deviceId) async {
    try {
      await _ensureInitialized();
      
      final currentUser = _client.auth.currentUser;
      if (currentUser == null) return false;

      await _client
          .from('user_devices')
          .update({'is_trusted': false})
          .eq('user_id', currentUser.id)
          .eq('device_id', deviceId);

      await _logSecurityEvent(
        currentUser.id, 'device_revocation', true,
        'Device access revoked', {'device_id': deviceId}, riskScore: 10
      );

      return true;
    } catch (e) {
      debugPrint('Error revoking device access: $e');
      return false;
    }
  }

  /// Get user's registered devices
  Future<List<Map<String, dynamic>>> getUserDevices() async {
    try {
      await _ensureInitialized();
      
      final currentUser = _client.auth.currentUser;
      if (currentUser == null) return [];

      final response = await _client
          .from('user_devices')
          .select('*')
          .eq('user_id', currentUser.id)
          .order('last_seen_at', ascending: false);

      return List<Map<String, dynamic>>.from(response);
    } catch (e) {
      debugPrint('Error getting user devices: $e');
      return [];
    }
  }

  /// Clear all security data (for logout)
  Future<void> clearSecurityData() async {
    try {
      final storage = StorageService();
      final currentUser = _client.auth.currentUser;
      
      if (currentUser != null) {
        await storage.remove('secure_session');
        await storage.remove('secure_credentials_${currentUser.email}');
        await storage.remove('last_login');
        
        await _logSecurityEvent(
          currentUser.id, 'security_data_cleared', true,
          'Security data cleared on logout', await _getDetailedDeviceInfo()
        );
      }
      
      debugPrint('✅ Security data cleared');
    } catch (e) {
      debugPrint('❌ Error clearing security data: $e');
    }
  }

  /// Utility methods
  String _encryptData(String data) {
    if (_encryptionKey == null) return data;
    
    // Simple XOR encryption for demo - use proper encryption in production
    final keyBytes = utf8.encode(_encryptionKey!);
    final dataBytes = utf8.encode(data);
    final encryptedBytes = <int>[];
    
    for (int i = 0; i < dataBytes.length; i++) {
      encryptedBytes.add(dataBytes[i] ^ keyBytes[i % keyBytes.length]);
    }
    
    return base64.encode(encryptedBytes);
  }

  String _decryptData(String encryptedData) {
    if (_encryptionKey == null) return encryptedData;
    
    try {
      final keyBytes = utf8.encode(_encryptionKey!);
      final encryptedBytes = base64.decode(encryptedData);
      final decryptedBytes = <int>[];
      
      for (int i = 0; i < encryptedBytes.length; i++) {
        decryptedBytes.add(encryptedBytes[i] ^ keyBytes[i % keyBytes.length]);
      }
      
      return utf8.decode(decryptedBytes);
    } catch (e) {
      debugPrint('Decryption error: $e');
      return encryptedData;
    }
  }

  String _generateTemporaryPassword() {
    final timestamp = DateTime.now().millisecondsSinceEpoch.toString();
    final fingerprint = _deviceFingerprint?.substring(0, 8) ?? 'unknown';
    return 'temp_${fingerprint}_$timestamp';
  }

  Future<String?> _getClientIP() async {
    try {
      // In a real app, this would get the actual client IP
      return '127.0.0.1';
    } catch (e) {
      return null;
    }
  }

  String _getUserAgent() {
    return '${Platform.operatingSystem}_mewayz_app';
  }

  /// Get security status report
  Future<Map<String, dynamic>> getSecurityStatusReport() async {
    try {
      await _ensureInitialized();
      
      final currentUser = _client.auth.currentUser;
      if (currentUser == null) {
        return {'error': 'No authenticated user'};
      }

      final devices = await getUserDevices();
      final trustedDevices = devices.where((d) => d['is_trusted'] == true).length;
      final biometricDevices = devices.where((d) => d['biometric_enabled'] == true).length;
      
      // Get recent security events
      final recentEvents = await _client
          .from('security_audit_log')
          .select('action_type, success, risk_score, created_at')
          .eq('user_id', currentUser.id)
          .gte('created_at', DateTime.now().subtract(const Duration(days: 7)).toIso8601String())
          .order('created_at', ascending: false)
          .limit(10);

      final highRiskEvents = recentEvents.where((e) => e['risk_score'] > 50).length;
      final failedAttempts = recentEvents.where((e) => e['success'] == false).length;

      return {
        'user_id': currentUser.id,
        'email': currentUser.email,
        'total_devices': devices.length,
        'trusted_devices': trustedDevices,
        'biometric_devices': biometricDevices,
        'recent_high_risk_events': highRiskEvents,
        'recent_failed_attempts': failedAttempts,
        'current_device_trusted': await isDeviceTrusted(),
        'security_score': _calculateSecurityScore(
          trustedDevices, biometricDevices, highRiskEvents, failedAttempts
        ),
        'last_updated': DateTime.now().toIso8601String(),
      };
    } catch (e) {
      debugPrint('Error getting security status: $e');
      return {'error': e.toString()};
    }
  }

  int _calculateSecurityScore(int trustedDevices, int biometricDevices, int highRiskEvents, int failedAttempts) {
    int score = 70; // Base score
    
    // Add points for security features
    score += trustedDevices * 5;
    score += biometricDevices * 10;
    
    // Subtract points for security issues
    score -= highRiskEvents * 15;
    score -= failedAttempts * 10;
    
    return score.clamp(0, 100);
  }
}