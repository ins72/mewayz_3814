/// Production configuration class for the Mewayz application
class ProductionConfig {
  static const String appName = 'Mewayz';
  static const String appVersion = '1.0.0';
  static const String buildNumber = '1';
  
  // API Configuration
  static const String baseUrl = 'https://api.mewayz.com';
  static const String socketUrl = 'wss://socket.mewayz.com';
  static const int connectionTimeout = 30000;
  static const int receiveTimeout = 30000;
  static const int sendTimeout = 30000;
  
  // Security Configuration
  static const String encryptionKey = String.fromEnvironment(
    'ENCRYPTION_KEY',
    defaultValue: 'REPLACE_WITH_ACTUAL_SECURE_KEY_32_CHARS'
  );
  static const bool enableHttpsOnly = true;
  static const bool enableCertificatePinning = true;
  static const Duration sessionTimeout = Duration(hours: 24);
  static const Duration refreshTokenTimeout = Duration(days: 30);
  
  // Analytics Configuration
  static const String firebaseProjectId = String.fromEnvironment(
    'FIREBASE_PROJECT_ID',
    defaultValue: 'your-firebase-project-id'
  );
  static const String mixpanelToken = String.fromEnvironment(
    'MIXPANEL_TOKEN',
    defaultValue: 'REPLACE_WITH_ACTUAL_MIXPANEL_TOKEN'
  );
  static const bool enableCrashlytics = true;
  static const bool enablePerformanceMonitoring = true;
  
  // Feature Flags
  static const bool enableBiometricAuth = true;
  static const bool enablePushNotifications = true;
  static const bool enableDeepLinking = true;
  static const bool enableOfflineMode = true;
  static const bool enableAdvancedAnalytics = true;
  
  // Cache Configuration
  static const int maxCacheSize = 100 * 1024 * 1024; // 100MB
  static const Duration cacheExpiration = Duration(hours: 24);
  static const int maxImageCacheSize = 50 * 1024 * 1024; // 50MB
  
  // Performance Configuration
  static const int maxConcurrentRequests = 10;
  static const int maxRetryAttempts = 3;
  static const Duration retryDelay = Duration(seconds: 2);
  
  // Social Media API Keys - Use environment variables in production
  static const String instagramClientId = String.fromEnvironment(
    'INSTAGRAM_CLIENT_ID',
    defaultValue: 'REPLACE_WITH_ACTUAL_INSTAGRAM_CLIENT_ID'
  );
  static const String instagramClientSecret = String.fromEnvironment(
    'INSTAGRAM_CLIENT_SECRET',
    defaultValue: 'REPLACE_WITH_ACTUAL_INSTAGRAM_CLIENT_SECRET'
  );
  static const String facebookAppId = String.fromEnvironment(
    'FACEBOOK_APP_ID',
    defaultValue: 'REPLACE_WITH_ACTUAL_FACEBOOK_APP_ID'
  );
  static const String facebookAppSecret = String.fromEnvironment(
    'FACEBOOK_APP_SECRET',
    defaultValue: 'REPLACE_WITH_ACTUAL_FACEBOOK_APP_SECRET'
  );
  static const String twitterApiKey = String.fromEnvironment(
    'TWITTER_API_KEY',
    defaultValue: 'REPLACE_WITH_ACTUAL_TWITTER_API_KEY'
  );
  static const String twitterApiSecret = String.fromEnvironment(
    'TWITTER_API_SECRET',
    defaultValue: 'REPLACE_WITH_ACTUAL_TWITTER_API_SECRET'
  );
  static const String linkedinClientId = String.fromEnvironment(
    'LINKEDIN_CLIENT_ID',
    defaultValue: 'REPLACE_WITH_ACTUAL_LINKEDIN_CLIENT_ID'
  );
  static const String linkedinClientSecret = String.fromEnvironment(
    'LINKEDIN_CLIENT_SECRET',
    defaultValue: 'REPLACE_WITH_ACTUAL_LINKEDIN_CLIENT_SECRET'
  );
  static const String youtubeApiKey = String.fromEnvironment(
    'YOUTUBE_API_KEY',
    defaultValue: 'REPLACE_WITH_ACTUAL_YOUTUBE_API_KEY'
  );
  static const String tiktokClientId = String.fromEnvironment(
    'TIKTOK_CLIENT_ID',
    defaultValue: 'REPLACE_WITH_ACTUAL_TIKTOK_CLIENT_ID'
  );
  static const String tiktokClientSecret = String.fromEnvironment(
    'TIKTOK_CLIENT_SECRET',
    defaultValue: 'REPLACE_WITH_ACTUAL_TIKTOK_CLIENT_SECRET'
  );
  
  // Third-party Services - Use environment variables in production
  static const String stripePublishableKey = String.fromEnvironment(
    'STRIPE_PUBLISHABLE_KEY',
    defaultValue: 'REPLACE_WITH_ACTUAL_STRIPE_PUBLISHABLE_KEY'
  );
  static const String stripeSecretKey = String.fromEnvironment(
    'STRIPE_SECRET_KEY',
    defaultValue: 'REPLACE_WITH_ACTUAL_STRIPE_SECRET_KEY'
  );
  static const String sendgridApiKey = String.fromEnvironment(
    'SENDGRID_API_KEY',
    defaultValue: 'REPLACE_WITH_ACTUAL_SENDGRID_API_KEY'
  );
  static const String twilioAccountSid = String.fromEnvironment(
    'TWILIO_ACCOUNT_SID',
    defaultValue: 'REPLACE_WITH_ACTUAL_TWILIO_ACCOUNT_SID'
  );
  static const String twilioAuthToken = String.fromEnvironment(
    'TWILIO_AUTH_TOKEN',
    defaultValue: 'REPLACE_WITH_ACTUAL_TWILIO_AUTH_TOKEN'
  );
  static const String cloudinaryCloudName = String.fromEnvironment(
    'CLOUDINARY_CLOUD_NAME',
    defaultValue: 'REPLACE_WITH_ACTUAL_CLOUDINARY_CLOUD_NAME'
  );
  static const String cloudinaryApiKey = String.fromEnvironment(
    'CLOUDINARY_API_KEY',
    defaultValue: 'REPLACE_WITH_ACTUAL_CLOUDINARY_API_KEY'
  );
  static const String cloudinaryApiSecret = String.fromEnvironment(
    'CLOUDINARY_API_SECRET',
    defaultValue: 'REPLACE_WITH_ACTUAL_CLOUDINARY_API_SECRET'
  );
  
  // Environment Detection
  static bool get isProduction => const bool.fromEnvironment('dart.vm.product');
  static bool get isDebug => !isProduction;
  
  // Logging Configuration
  static bool get enableLogging => isDebug;
  static String get logLevel => isProduction ? 'ERROR' : 'DEBUG';
  
  // App Store Configuration
  static const String appStoreId = String.fromEnvironment(
    'APP_STORE_ID',
    defaultValue: 'REPLACE_WITH_ACTUAL_APP_STORE_ID'
  );
  static const String playStoreId = 'com.mewayz.app';
  static const String appStoreUrl = 'https://apps.apple.com/app/id$appStoreId';
  static const String playStoreUrl = 'https://play.google.com/store/apps/details?id=$playStoreId';
  
  // Legal and Privacy
  static const String privacyPolicyUrl = 'https://mewayz.com/privacy-policy';
  static const String termsOfServiceUrl = 'https://mewayz.com/terms-of-service';
  static const String supportUrl = 'https://mewayz.com/support';
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
  static const String fcmServerKey = String.fromEnvironment(
    'FCM_SERVER_KEY',
    defaultValue: 'REPLACE_WITH_ACTUAL_FCM_SERVER_KEY'
  );
  static const String apnsCertificate = String.fromEnvironment(
    'APNS_CERTIFICATE',
    defaultValue: 'REPLACE_WITH_ACTUAL_APNS_CERTIFICATE'
  );
  
  // CDN Configuration
  static const String cdnBaseUrl = 'https://cdn.mewayz.com';
  static const String imagesCdnUrl = '$cdnBaseUrl/images';
  static const String videosCdnUrl = '$cdnBaseUrl/videos';
  static const String assetsCdnUrl = '$cdnBaseUrl/assets';
  
  // Rate Limiting
  static const int maxApiCallsPerMinute = 100;
  static const int maxUploadSizeBytes = 10 * 1024 * 1024; // 10MB
  static const int maxVideoUploadSizeBytes = 100 * 1024 * 1024; // 100MB
  
  // Backup Configuration
  static const bool enableAutomaticBackup = true;
  static const Duration backupInterval = Duration(hours: 6);
  static const int maxBackupFiles = 5;
  
  // Security validation
  static bool get hasValidConfiguration {
    // Check if critical configuration values have been replaced
    return encryptionKey != 'REPLACE_WITH_ACTUAL_SECURE_KEY_32_CHARS' &&
           instagramClientId != 'REPLACE_WITH_ACTUAL_INSTAGRAM_CLIENT_ID' &&
           facebookAppId != 'REPLACE_WITH_ACTUAL_FACEBOOK_APP_ID' &&
           stripePublishableKey != 'REPLACE_WITH_ACTUAL_STRIPE_PUBLISHABLE_KEY';
  }
  
  // Production readiness check
  static Map<String, bool> get productionReadinessCheck {
    return {
      'Environment Variables Set': hasValidConfiguration,
      'Production Mode': isProduction,
      'HTTPS Enabled': enableHttpsOnly,
      'Certificate Pinning': enableCertificatePinning,
      'Database Encryption': enableDatabaseEncryption,
      'Crashlytics Enabled': enableCrashlytics,
      'Performance Monitoring': enablePerformanceMonitoring,
      'Automatic Backup': enableAutomaticBackup,
    };
  }
  
  // Get configuration status
  static String get configurationStatus {
    final readiness = productionReadinessCheck;
    final totalChecks = readiness.length;
    final passedChecks = readiness.values.where((v) => v).length;
    
    if (passedChecks == totalChecks) {
      return 'PRODUCTION_READY';
    } else if (passedChecks >= totalChecks * 0.8) {
      return 'MOSTLY_READY';
    } else {
      return 'NEEDS_CONFIGURATION';
    }
  }
}