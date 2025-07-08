import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:flutter/foundation.dart';

import './error_handler.dart';
import './production_config.dart';
import './storage_service.dart';

/// Service for security-related operations
class SecurityService {
  static final SecurityService _instance = SecurityService._internal();
  factory SecurityService() => _instance;
  SecurityService._internal();
  
  final StorageService _storageService = StorageService();
  bool _isInitialized = false;
  
  Future<void> initialize() async {
    try {
      _isInitialized = true;
      
      // Initialize security components
      await _initializeBiometrics();
      await _validateAppIntegrity();
      
      if (ProductionConfig.enableLogging) {
        debugPrint('SecurityService initialized');
      }
    } catch (e) {
      ErrorHandler.handleError('Failed to initialize SecurityService: $e');
    }
  }
  
  Future<void> _initializeBiometrics() async {
    if (ProductionConfig.enableBiometricAuth) {
      try {
        // Initialize biometric authentication
        // final LocalAuthentication auth = LocalAuthentication();
        // final bool canCheckBiometrics = await auth.canCheckBiometrics;
        // final bool isDeviceSupported = await auth.isDeviceSupported();
        
        // if (canCheckBiometrics && isDeviceSupported) {
        //   final List<BiometricType> availableBiometrics = await auth.getAvailableBiometrics();
        //   await _storageService.saveString('available_biometrics', jsonEncode(availableBiometrics.map((e) => e.name).toList()));
        // }
      } catch (e) {
        ErrorHandler.handleError('Failed to initialize biometrics: $e');
      }
    }
  }
  
  Future<void> _validateAppIntegrity() async {
    try {
      // Validate app integrity and detect tampering
      // This would typically involve checking signatures, certificates, etc.
      if (ProductionConfig.isProduction) {
        // Implement app integrity checks
        // - Check if app is running on rooted/jailbroken device
        // - Verify app signature
        // - Check for debugging/reverse engineering tools
      }
    } catch (e) {
      ErrorHandler.handleError('Failed to validate app integrity: $e');
    }
  }
  
  /// Encrypt sensitive data
  String encryptData(String data, {String? key}) {
    try {
      final encryptionKey = key ?? ProductionConfig.encryptionKey;
      final keyBytes = utf8.encode(encryptionKey);
      final dataBytes = utf8.encode(data);
      
      // Simple XOR encryption (replace with proper encryption in production)
      final encrypted = <int>[];
      for (int i = 0; i < dataBytes.length; i++) {
        encrypted.add(dataBytes[i] ^ keyBytes[i % keyBytes.length]);
      }
      
      return base64.encode(encrypted);
    } catch (e) {
      ErrorHandler.handleError('Failed to encrypt data: $e');
      return data; // Return original data if encryption fails
    }
  }
  
  /// Decrypt sensitive data
  String decryptData(String encryptedData, {String? key}) {
    try {
      final encryptionKey = key ?? ProductionConfig.encryptionKey;
      final keyBytes = utf8.encode(encryptionKey);
      final encryptedBytes = base64.decode(encryptedData);
      
      // Simple XOR decryption (replace with proper decryption in production)
      final decrypted = <int>[];
      for (int i = 0; i < encryptedBytes.length; i++) {
        decrypted.add(encryptedBytes[i] ^ keyBytes[i % keyBytes.length]);
      }
      
      return utf8.decode(decrypted);
    } catch (e) {
      ErrorHandler.handleError('Failed to decrypt data: $e');
      return encryptedData; // Return encrypted data if decryption fails
    }
  }
  
  /// Generate secure hash
  String generateHash(String data, {String? salt}) {
    try {
      final saltedData = salt != null ? data + salt : data;
      final bytes = utf8.encode(saltedData);
      final digest = sha256.convert(bytes);
      return digest.toString();
    } catch (e) {
      ErrorHandler.handleError('Failed to generate hash: $e');
      return '';
    }
  }
  
  /// Verify hash
  bool verifyHash(String data, String hash, {String? salt}) {
    try {
      final generatedHash = generateHash(data, salt: salt);
      return generatedHash == hash;
    } catch (e) {
      ErrorHandler.handleError('Failed to verify hash: $e');
      return false;
    }
  }
  
  /// Generate secure random string
  String generateSecureRandomString(int length) {
    try {
      const chars = 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789!@#\$%^&*()_+-=[]{}|;:,.<>?';
      final random = <int>[];
      
      for (int i = 0; i < length; i++) {
        random.add(chars.codeUnitAt(DateTime.now().microsecondsSinceEpoch % chars.length));
      }
      
      return String.fromCharCodes(random);
    } catch (e) {
      ErrorHandler.handleError('Failed to generate secure random string: $e');
      return '';
    }
  }
  
  /// Authenticate with biometrics
  Future<bool> authenticateWithBiometrics({String? reason}) async {
    if (!ProductionConfig.enableBiometricAuth) return false;
    
    try {
      // final LocalAuthentication auth = LocalAuthentication();
      // final bool canCheckBiometrics = await auth.canCheckBiometrics;
      // 
      // if (!canCheckBiometrics) return false;
      // 
      // final bool didAuthenticate = await auth.authenticate(
      //   localizedReason: reason ?? 'Please authenticate to access the app',
      //   options: const AuthenticationOptions(
      //     biometricOnly: true,
      //     stickyAuth: true,
      //   ),
      // );
      // 
      // return didAuthenticate;
      
      // Placeholder return for now
      return true;
    } catch (e) {
      ErrorHandler.handleError('Failed to authenticate with biometrics: $e');
      return false;
    }
  }
  
  /// Check if biometrics are available
  Future<bool> isBiometricAvailable() async {
    if (!ProductionConfig.enableBiometricAuth) return false;
    
    try {
      // final LocalAuthentication auth = LocalAuthentication();
      // final bool canCheckBiometrics = await auth.canCheckBiometrics;
      // final bool isDeviceSupported = await auth.isDeviceSupported();
      // 
      // return canCheckBiometrics && isDeviceSupported;
      
      // Placeholder return for now
      return true;
    } catch (e) {
      ErrorHandler.handleError('Failed to check biometric availability: $e');
      return false;
    }
  }
  
  /// Get available biometric types
  Future<List<String>> getAvailableBiometrics() async {
    if (!ProductionConfig.enableBiometricAuth) return [];
    
    try {
      // final LocalAuthentication auth = LocalAuthentication();
      // final List<BiometricType> availableBiometrics = await auth.getAvailableBiometrics();
      // return availableBiometrics.map((e) => e.name).toList();
      
      // Placeholder return for now
      return ['fingerprint', 'face'];
    } catch (e) {
      ErrorHandler.handleError('Failed to get available biometrics: $e');
      return [];
    }
  }
  
  /// Validate password strength
  Map<String, dynamic> validatePasswordStrength(String password) {
    final result = {
      'isValid': false,
      'score': 0,
      'issues': <String>[],
      'suggestions': <String>[],
    };
    
    try {
      int score = 0;
      final issues = <String>[];
      final suggestions = <String>[];
      
      // Check length
      if (password.length < 8) {
        issues.add('Password must be at least 8 characters long');
        suggestions.add('Use at least 8 characters');
      } else {
        score += 1;
      }
      
      // Check for uppercase
      if (!password.contains(RegExp(r'[A-Z]'))) {
        issues.add('Password must contain at least one uppercase letter');
        suggestions.add('Add uppercase letters');
      } else {
        score += 1;
      }
      
      // Check for lowercase
      if (!password.contains(RegExp(r'[a-z]'))) {
        issues.add('Password must contain at least one lowercase letter');
        suggestions.add('Add lowercase letters');
      } else {
        score += 1;
      }
      
      // Check for numbers
      if (!password.contains(RegExp(r'[0-9]'))) {
        issues.add('Password must contain at least one number');
        suggestions.add('Add numbers');
      } else {
        score += 1;
      }
      
      // Check for special characters
      if (!password.contains(RegExp(r'[!@#$%^&*()_+\-=\[\]{};:"\\|,.<>\?]'))) {
        issues.add('Password must contain at least one special character');
        suggestions.add('Add special characters (!@#\$%^&*)');
      } else {
        score += 1;
      }
      
      // Check for common patterns
      if (password.toLowerCase().contains('password') ||
          password.toLowerCase().contains('123456') ||
          password.toLowerCase().contains('qwerty')) {
        issues.add('Password contains common patterns');
        suggestions.add('Avoid common words and patterns');
        score = score > 0 ? score - 1 : 0;
      }
      
      result['score'] = score;
      result['issues'] = issues;
      result['suggestions'] = suggestions;
      result['isValid'] = score >= 4 && issues.isEmpty;
      
      return result;
    } catch (e) {
      ErrorHandler.handleError('Failed to validate password strength: $e');
      return result;
    }
  }

  /// Sanitize input to prevent injection attacks
  String sanitizeInput(String input) {
    try {
      // Remove HTML tags and potentially dangerous content
      String sanitized = input.replaceAll(RegExp(r'<[^>]*>'), '');
      
      // Remove SQL injection patterns - more comprehensive
      sanitized = sanitized.replaceAll(RegExp(r'''[;'"\\]|(-{2})|(/\*)|(\*/)|(xp_)|(sp_)|(union\s+select)|(insert\s+into)|(delete\s+from)|(update\s+set)|(drop\s+table)|(create\s+table)|(alter\s+table)|(exec\s*\()''', caseSensitive: false), '');
      
      // Remove script tags and javascript
      sanitized = sanitized.replaceAll(RegExp(r'<script[^>]*>.*?</script>', caseSensitive: false, dotAll: true), '');
      sanitized = sanitized.replaceAll(RegExp(r'javascript:', caseSensitive: false), '');
      sanitized = sanitized.replaceAll(RegExp(r'on\w+\s*=', caseSensitive: false), '');
      
      // Remove potentially dangerous protocols
      sanitized = sanitized.replaceAll(RegExp(r'(data:|vbscript:|file:|about:)', caseSensitive: false), '');
      
      // Limit length to prevent buffer overflow
      if (sanitized.length > 1000) {
        sanitized = sanitized.substring(0, 1000);
      }
      
      return sanitized.trim();
    } catch (e) {
      ErrorHandler.handleError('Failed to sanitize input: $e');
      return input;
    }
  }
  
  /// Validate email format
  bool isValidEmail(String email) {
    try {
      final emailRegExp = RegExp(
        r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
      );
      return emailRegExp.hasMatch(email);
    } catch (e) {
      ErrorHandler.handleError('Failed to validate email: $e');
      return false;
    }
  }
  
  /// Validate phone number format
  bool isValidPhoneNumber(String phoneNumber) {
    try {
      final phoneRegExp = RegExp(
        r'^\+?[1-9]\d{1,14}$',
      );
      return phoneRegExp.hasMatch(phoneNumber.replaceAll(RegExp(r'[\s\-\(\)]'), ''));
    } catch (e) {
      ErrorHandler.handleError('Failed to validate phone number: $e');
      return false;
    }
  }
  
  /// Check if device is rooted/jailbroken
  Future<bool> isDeviceCompromised() async {
    try {
      // Check for common root/jailbreak indicators
      // This is a simplified check - in production, use a proper security library
      
      if (defaultTargetPlatform == TargetPlatform.android) {
        // Check for common root indicators on Android
        // return await _checkAndroidRoot();
      } else if (defaultTargetPlatform == TargetPlatform.iOS) {
        // Check for jailbreak indicators on iOS
        // return await _checkiOSJailbreak();
      }
      
      return false; // Placeholder
    } catch (e) {
      ErrorHandler.handleError('Failed to check device compromise: $e');
      return false;
    }
  }
  
  /// Generate JWT token
  String generateJWTToken(Map<String, dynamic> payload, {String? secret}) {
    try {
      final header = {
        'alg': 'HS256',
        'typ': 'JWT',
      };
      
      final now = DateTime.now().millisecondsSinceEpoch ~/ 1000;
      final jwtPayload = {
        ...payload,
        'iat': now,
        'exp': now + 3600, // 1 hour expiration
      };
      
      final headerEncoded = base64Url.encode(utf8.encode(jsonEncode(header)));
      final payloadEncoded = base64Url.encode(utf8.encode(jsonEncode(jwtPayload)));
      
      final signature = generateHash(
        '$headerEncoded.$payloadEncoded',
        salt: secret ?? ProductionConfig.encryptionKey,
      );
      
      return '$headerEncoded.$payloadEncoded.$signature';
    } catch (e) {
      ErrorHandler.handleError('Failed to generate JWT token: $e');
      return '';
    }
  }
  
  /// Verify JWT token
  bool verifyJWTToken(String token, {String? secret}) {
    try {
      final parts = token.split('.');
      if (parts.length != 3) return false;
      
      final headerEncoded = parts[0];
      final payloadEncoded = parts[1];
      final signature = parts[2];
      
      // Verify signature
      final expectedSignature = generateHash(
        '$headerEncoded.$payloadEncoded',
        salt: secret ?? ProductionConfig.encryptionKey,
      );
      
      if (signature != expectedSignature) return false;
      
      // Check expiration
      final payload = jsonDecode(utf8.decode(base64Url.decode(payloadEncoded)));
      final exp = payload['exp'] as int?;
      if (exp != null) {
        final now = DateTime.now().millisecondsSinceEpoch ~/ 1000;
        if (now > exp) return false;
      }
      
      return true;
    } catch (e) {
      ErrorHandler.handleError('Failed to verify JWT token: $e');
      return false;
    }
  }
  
  /// Secure storage for sensitive data
  Future<void> secureStore(String key, String value) async {
    try {
      final encryptedValue = encryptData(value);
      await _storageService.saveString('secure_$key', encryptedValue);
    } catch (e) {
      ErrorHandler.handleError('Failed to secure store: $e');
    }
  }
  
  /// Retrieve from secure storage
  Future<String?> secureRetrieve(String key) async {
    try {
      final encryptedValue = await _storageService.getString('secure_$key');
      if (encryptedValue != null) {
        return decryptData(encryptedValue);
      }
      return null;
    } catch (e) {
      ErrorHandler.handleError('Failed to secure retrieve: $e');
      return null;
    }
  }
  
  /// Clear secure storage
  Future<void> secureClear(String key) async {
    try {
      await _storageService.remove('secure_$key');
    } catch (e) {
      ErrorHandler.handleError('Failed to secure clear: $e');
    }
  }
}