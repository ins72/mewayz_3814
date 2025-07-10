import 'dart:io';

/// Production-ready environment configuration
class EnvironmentConfig {
  static bool _isInitialized = false;
  static EnvironmentConfig? _instance;
  
  // Environment variables
  static const String supabaseUrl = String.fromEnvironment('SUPABASE_URL', defaultValue: '');
  static const String supabaseAnonKey = String.fromEnvironment('SUPABASE_ANON_KEY', defaultValue: '');
  static const String googleClientId = String.fromEnvironment('GOOGLE_CLIENT_ID', defaultValue: '');
  static const String environment = String.fromEnvironment('ENVIRONMENT', defaultValue: 'development');
  
  // Analytics configuration
  static const String firebaseProjectId = String.fromEnvironment('FIREBASE_PROJECT_ID', defaultValue: '');
  static const String mixpanelToken = String.fromEnvironment('MIXPANEL_TOKEN', defaultValue: '');
  static const String amplitudeApiKey = String.fromEnvironment('AMPLITUDE_API_KEY', defaultValue: '');
  static const bool enableAnalytics = bool.fromEnvironment('ENABLE_ANALYTICS', defaultValue: true);
  
  // Notification configuration
  static const bool enablePushNotifications = bool.fromEnvironment('ENABLE_PUSH_NOTIFICATIONS', defaultValue: true);
  static const String fcmServerKey = String.fromEnvironment('FCM_SERVER_KEY', defaultValue: '');
  static const String apnsKeyId = String.fromEnvironment('APNS_KEY_ID', defaultValue: '');
  
  // Security configuration
  static const String encryptionKey = String.fromEnvironment('ENCRYPTION_KEY', defaultValue: '');
  static const String jwtSecret = String.fromEnvironment('JWT_SECRET', defaultValue: '');
  static const String apiSecretKey = String.fromEnvironment('API_SECRET_KEY', defaultValue: '');
  static const bool enableBiometricAuth = bool.fromEnvironment('ENABLE_BIOMETRIC_AUTH', defaultValue: true);
  static const bool enableTwoFactorAuth = bool.fromEnvironment('ENABLE_TWO_FACTOR_AUTH', defaultValue: false);
  static const bool debugMode = bool.fromEnvironment('DEBUG_MODE', defaultValue: false);

  // Singleton instance
  static EnvironmentConfig get instance {
    _instance ??= EnvironmentConfig._internal();
    return _instance!;
  }

  EnvironmentConfig._internal();

  // Factory constructor for backwards compatibility
  factory EnvironmentConfig() => instance;

  /// Initialize environment configuration
  static Future<void> initialize() async {
    if (_isInitialized) return;
    
    _validateEnvironmentVariables();
    _isInitialized = true;
  }
  
  /// Validate all required environment variables
  static void _validateEnvironmentVariables() {
    final missingVars = <String>[];
    
    if (supabaseUrl.isEmpty) missingVars.add('SUPABASE_URL');
    if (supabaseAnonKey.isEmpty) missingVars.add('SUPABASE_ANON_KEY');
    
    if (missingVars.isNotEmpty) {
      throw Exception(
        'Missing required environment variables: ${missingVars.join(', ')}\n'
        'Please configure these variables using --dart-define or env.json'
      );
    }
    
    // Validate Supabase URL format
    if (!supabaseUrl.startsWith('https://') || !supabaseUrl.contains('.supabase.co')) {
      throw Exception('Invalid SUPABASE_URL format. Must be a valid Supabase project URL.');
    }
  }
  
  /// Check if environment is production ready
  static bool get isProductionReady {
    return _isInitialized && 
           supabaseUrl.isNotEmpty && 
           supabaseAnonKey.isNotEmpty &&
           supabaseUrl.startsWith('https://');
  }
  
  /// Check if running in production
  static bool get isProduction => environment.toLowerCase() == 'production';
  
  /// Check if running in development
  static bool get isDevelopment => environment.toLowerCase() == 'development';
  
  /// Get platform information
  static String get platform {
    if (Platform.isAndroid) return 'android';
    if (Platform.isIOS) return 'ios';
    if (Platform.isMacOS) return 'macos';
    if (Platform.isWindows) return 'windows';
    if (Platform.isLinux) return 'linux';
    return 'unknown';
  }
}