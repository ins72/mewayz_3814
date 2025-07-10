import 'package:package_info_plus/package_info_plus.dart';
import './environment_config.dart';

/// Production configuration and constants
class ProductionConfig {
  static late PackageInfo _packageInfo;
  static bool _isInitialized = false;
  
  /// Initialize production configuration
  static Future<void> initialize() async {
    if (_isInitialized) return;
    
    try {
      _packageInfo = await PackageInfo.fromPlatform();
      _isInitialized = true;
    } catch (e) {
      throw Exception('Failed to initialize production config: $e');
    }
  }
  
  /// App version
  static String get appVersion => _packageInfo.version;
  
  /// App build number
  static String get buildNumber => _packageInfo.buildNumber;
  
  /// App name
  static String get appName => _packageInfo.appName;
  
  /// Package name
  static String get packageName => _packageInfo.packageName;
  
  /// Base URL for the application
  static String get baseUrl => EnvironmentConfig.supabaseUrl;
  
  /// Check if running in production
  static bool get isProduction => EnvironmentConfig.isProduction;
  
  /// API timeout configurations
  static const Duration apiTimeout = Duration(seconds: 30);
  static const Duration uploadTimeout = Duration(minutes: 5);
  static const Duration downloadTimeout = Duration(minutes: 10);
  
  /// Real-time configuration
  static const Duration heartbeatInterval = Duration(seconds: 30);
  static const Duration reconnectDelay = Duration(seconds: 5);
  static const int maxReconnectAttempts = 10;
  
  /// Cache configuration
  static const Duration cacheExpiry = Duration(hours: 24);
  static const int maxCacheSize = 100; // MB
  
  /// Performance monitoring
  static const bool enablePerformanceMonitoring = true;
  static const bool enableCrashReporting = true;
  static const bool enableAnalytics = true;
  
  /// Logging configuration
  static bool get enableDetailedLogging => !isProduction;
  static bool get enableNetworkLogging => !isProduction;
  
  /// Feature flags
  static const bool enableOfflineMode = true;
  static const bool enableBiometricAuth = true;
  static const bool enablePushNotifications = true;
  
  /// Security configuration
  static const bool enableSSLPinning = true;
  static const bool enableCertificateTransparency = true;
  static const Duration sessionTimeout = Duration(hours: 24);
  
  /// Database configuration
  static const int maxRetryAttempts = 3;
  static const Duration retryDelay = Duration(seconds: 2);
  static const int batchSize = 1000;
}