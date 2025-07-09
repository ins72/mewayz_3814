import './environment_config.dart';

/// Production configuration class for the Mewayz application
class ProductionConfig {
  static String get appName => EnvironmentConfig.appName;
  static String get appVersion => EnvironmentConfig.appVersion;
  static String get buildNumber => EnvironmentConfig.buildNumber;
  
  // API Configuration
  static String get baseUrl => EnvironmentConfig.apiBaseUrl;
  static String get socketUrl => EnvironmentConfig.socketUrl;
  static const int connectionTimeout = 30000;
  static const int receiveTimeout = 30000;
  static const int sendTimeout = 30000;
  
  // Security Configuration
  static String get encryptionKey => EnvironmentConfig.encryptionKey;
  static const bool enableHttpsOnly = true;
  static const bool enableCertificatePinning = true;
  static const Duration sessionTimeout = Duration(hours: 24);
  static const Duration refreshTokenTimeout = Duration(days: 30);
  
  // Supabase Configuration
  static String get supabaseUrl => EnvironmentConfig.supabaseUrl;
  static String get supabaseAnonKey => EnvironmentConfig.supabaseAnonKey;
  
  // OAuth Configuration
  static String get googleClientId => EnvironmentConfig.googleClientId;
  static String get appleClientId => EnvironmentConfig.appleClientId;
  
  // Analytics Configuration
  static String get firebaseProjectId => EnvironmentConfig.firebaseProjectId;
  static String get mixpanelToken => EnvironmentConfig.mixpanelToken;
  static bool get enableCrashlytics => EnvironmentConfig.enableCrashlytics;
  static bool get enablePerformanceMonitoring => EnvironmentConfig.enablePerformanceMonitoring;
  
  // Feature Flags
  static bool get enableBiometricAuth => EnvironmentConfig.enableBiometricAuth;
  static bool get enablePushNotifications => EnvironmentConfig.enablePushNotifications;
  static bool get enableDeepLinking => EnvironmentConfig.enableDeepLinking;
  static bool get enableOfflineMode => EnvironmentConfig.enableOfflineMode;
  static bool get enableAdvancedAnalytics => EnvironmentConfig.enableAdvancedAnalytics;
  static bool get enableOAuthSignIn => EnvironmentConfig.enableOAuthSignin;
  static bool get enableTwoFactorAuth => EnvironmentConfig.enableTwoFactorAuth;
  
  // Cache Configuration
  static const int maxCacheSize = 100 * 1024 * 1024; // 100MB
  static const Duration cacheExpiration = Duration(hours: 24);
  static const int maxImageCacheSize = 50 * 1024 * 1024; // 50MB
  
  // Performance Configuration
  static const int maxConcurrentRequests = 10;
  static const int maxRetryAttempts = 3;
  static const Duration retryDelay = Duration(seconds: 2);
  static const Duration requestTimeout = Duration(seconds: 30);
  
  // Social Media API Keys - Use environment variables in production
  static String get instagramClientId => EnvironmentConfig.instagramClientId;
  static String get instagramClientSecret => EnvironmentConfig.instagramClientSecret;
  static String get facebookAppId => EnvironmentConfig.facebookAppId;
  static String get facebookAppSecret => EnvironmentConfig.facebookAppSecret;
  static String get twitterApiKey => EnvironmentConfig.twitterApiKey;
  static String get twitterApiSecret => EnvironmentConfig.twitterApiSecret;
  static String get linkedinClientId => EnvironmentConfig.linkedinClientId;
  static String get linkedinClientSecret => EnvironmentConfig.linkedinClientSecret;
  static String get youtubeApiKey => EnvironmentConfig.youtubeApiKey;
  static String get tiktokClientId => EnvironmentConfig.tiktokClientId;
  static String get tiktokClientSecret => EnvironmentConfig.tiktokClientSecret;
  
  // Third-party Services - Use environment variables in production
  static String get stripePublishableKey => EnvironmentConfig.stripePublishableKey;
  static String get stripeSecretKey => EnvironmentConfig.stripeSecretKey;
  static String get sendgridApiKey => EnvironmentConfig.sendgridApiKey;
  static String get twilioAccountSid => EnvironmentConfig.twilioAccountSid;
  static String get twilioAuthToken => EnvironmentConfig.twilioAuthToken;
  static String get cloudinaryCloudName => EnvironmentConfig.cloudinaryCloudName;
  static String get cloudinaryApiKey => EnvironmentConfig.cloudinaryApiKey;
  static String get cloudinaryApiSecret => EnvironmentConfig.cloudinaryApiSecret;
  
  // Environment Detection
  static bool get isProduction => EnvironmentConfig.isProduction;
  static bool get isDebug => !isProduction;
  
  // Logging Configuration
  static bool get enableLogging => EnvironmentConfig.enableLogging;
  static String get logLevel => EnvironmentConfig.logLevel;
  
  // App Store Configuration
  static const String appStoreId = String.fromEnvironment(
    'APP_STORE_ID',
    defaultValue: 'REPLACE_WITH_ACTUAL_APP_STORE_ID'
  );
  static const String playStoreId = 'com.mewayz.app';
  static const String appStoreUrl = 'https://apps.apple.com/app/id$appStoreId';
  static const String playStoreUrl = 'https://play.google.com/store/apps/details?id=$playStoreId';
  
  // Legal and Privacy
  static String get privacyPolicyUrl => EnvironmentConfig.privacyPolicyUrl;
  static String get termsOfServiceUrl => EnvironmentConfig.termsOfServiceUrl;
  static String get supportUrl => EnvironmentConfig.supportUrl;
  static const String contactEmail = 'support@mewayz.com';
  
  // Regional Configuration
  static const String defaultLocale = 'en_US';
  static const String defaultCurrency = 'USD';
  static const String defaultTimeZone = 'UTC';
  
  // Database Configuration
  static const String databaseName = 'mewayz_production';
  static const int databaseVersion = 1;
  static const bool enableDatabaseEncryption = true;
  
  // Push Notification Configuration
  static String get fcmServerKey => EnvironmentConfig.fcmServerKey;
  static String get apnsCertificate => EnvironmentConfig.apnsPrivateKey;
  
  // CDN Configuration
  static String get cdnBaseUrl => EnvironmentConfig.cdnBaseUrl;
  static String get imagesCdnUrl => '$cdnBaseUrl/images';
  static String get videosCdnUrl => '$cdnBaseUrl/videos';
  static String get assetsCdnUrl => '$cdnBaseUrl/assets';
  
  // Rate Limiting
  static const int maxApiCallsPerMinute = 100;
  static const int maxUploadSizeBytes = 10 * 1024 * 1024; // 10MB
  static const int maxVideoUploadSizeBytes = 100 * 1024 * 1024; // 100MB
  
  // Backup Configuration
  static const bool enableAutomaticBackup = true;
  static const Duration backupInterval = Duration(hours: 6);
  static const int maxBackupFiles = 5;
  
  // Network Configuration
  static const int connectionCheckInterval = 30; // seconds
  static const int offlineQueueSize = 100;
  static const bool enableNetworkLogging = true;
  
  // Security validation
  static bool get hasValidConfiguration => EnvironmentConfig.isProductionReady;
  
  // Production readiness check
  static Map<String, bool> get productionReadinessCheck => EnvironmentConfig.configurationStatus;
  
  // Get configuration status
  static String get configurationStatus => EnvironmentConfig.configurationSummary;
  
  // Connection retry configuration
  static const List<Duration> retryDelays = [
    Duration(seconds: 1),
    Duration(seconds: 2),
    Duration(seconds: 4),
    Duration(seconds: 8),
    Duration(seconds: 16),
  ];
  
  // Error handling configuration
  static const Map<String, int> errorRetryLimits = {
    'network_error': 5,
    'timeout_error': 3,
    'auth_error': 2,
    'server_error': 3,
    'rate_limit_error': 1,
  };
  
  // Initialize production configuration
  static Future<void> initialize() async {
    await EnvironmentConfig.initialize();
  }
}