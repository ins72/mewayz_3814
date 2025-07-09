import './environment_config.dart';

/// Application constants for production deployment
class AppConstants {
  // App Information
  static const String appName = 'Mewayz';
  static const String appVersion = '1.0.0';
  static const String buildNumber = '1';
  static const String packageName = 'com.mewayz.app';
  
  // Store Information
  static const String appStoreId = 'REPLACE_WITH_ACTUAL_APP_STORE_ID';
  static const String playStoreId = 'com.mewayz.app';
  static const String appStoreUrl = 'https://apps.apple.com/app/id$appStoreId';
  static const String playStoreUrl = 'https://play.google.com/store/apps/details?id=$playStoreId';
  
  // Support Information
  static const String supportEmail = 'support@mewayz.com';
  static const String websiteUrl = 'https://mewayz.com';
  static const String privacyPolicyUrl = 'https://mewayz.com/privacy-policy';
  static const String termsOfServiceUrl = 'https://mewayz.com/terms-of-service';
  static const String helpUrl = 'https://mewayz.com/help';
  
  // API Configuration
  static String get apiBaseUrl => EnvironmentConfig.apiBaseUrl;
  static String get socketUrl => EnvironmentConfig.socketUrl;
  static String get cdnBaseUrl => EnvironmentConfig.cdnBaseUrl;
  
  // Timeouts and Limits
  static const int connectionTimeout = 30000; // 30 seconds
  static const int receiveTimeout = 30000; // 30 seconds
  static const int sendTimeout = 30000; // 30 seconds
  static const int maxRetryAttempts = 3;
  static const int retryDelay = 2000; // 2 seconds
  
  // File Upload Limits
  static const int maxImageSize = 10 * 1024 * 1024; // 10MB
  static const int maxVideoSize = 100 * 1024 * 1024; // 100MB
  static const int maxAudioSize = 50 * 1024 * 1024; // 50MB
  static const int maxDocumentSize = 25 * 1024 * 1024; // 25MB
  
  // Cache Configuration
  static const int imageCacheMaxSize = 50 * 1024 * 1024; // 50MB
  static const int dataCacheMaxSize = 10 * 1024 * 1024; // 10MB
  static const int cacheExpiration = 24 * 60 * 60 * 1000; // 24 hours
  
  // Social Media Platforms
  static const List<String> supportedPlatforms = [
    'instagram',
    'facebook',
    'twitter',
    'linkedin',
    'youtube',
    'tiktok',
    'pinterest',
  ];
  
  // Content Types
  static const List<String> supportedImageTypes = [
    'jpg',
    'jpeg',
    'png',
    'gif',
    'webp',
  ];
  
  static const List<String> supportedVideoTypes = [
    'mp4',
    'mov',
    'avi',
    'wmv',
    'flv',
  ];
  
  static const List<String> supportedAudioTypes = [
    'mp3',
    'wav',
    'aac',
    'flac',
  ];
  
  // Security Configuration
  static const int minPasswordLength = 8;
  static const int maxPasswordLength = 128;
  static const int sessionTimeout = 24 * 60 * 60 * 1000; // 24 hours
  static const int refreshTokenExpiry = 30 * 24 * 60 * 60 * 1000; // 30 days
  
  // Feature Flags
  static bool get enableBiometricAuth => EnvironmentConfig.enableBiometricAuth;
  static bool get enablePushNotifications => EnvironmentConfig.enablePushNotifications;
  static bool get enableAnalytics => EnvironmentConfig.enableAnalytics;
  static bool get enableCrashlytics => EnvironmentConfig.enableCrashlytics;
  static bool get enableOfflineMode => EnvironmentConfig.enableOfflineMode;
  static bool get enableDeepLinking => EnvironmentConfig.enableDeepLinking;
  static bool get enableTwoFactorAuth => EnvironmentConfig.enableTwoFactorAuth;
  static bool get enableOAuthSignIn => EnvironmentConfig.enableOAuthSignin;
  
  // Analytics Events
  static const String analyticsAppOpen = 'app_open';
  static const String analyticsAppClose = 'app_close';
  static const String analyticsUserLogin = 'user_login';
  static const String analyticsUserLogout = 'user_logout';
  static const String analyticsUserRegister = 'user_register';
  static const String analyticsPostCreate = 'post_create';
  static const String analyticsPostPublish = 'post_publish';
  static const String analyticsPostSchedule = 'post_schedule';
  static const String analyticsAnalyticsView = 'analytics_view';
  static const String analyticsSettingsView = 'settings_view';
  static const String analyticsErrorOccurred = 'error_occurred';
  
  // Notification Types
  static const String notificationPostPublished = 'post_published';
  static const String notificationPostScheduled = 'post_scheduled';
  static const String notificationAnalyticsUpdate = 'analytics_update';
  static const String notificationSystemUpdate = 'system_update';
  static const String notificationSecurityAlert = 'security_alert';
  
  // Error Codes
  static const String errorNetworkConnection = 'network_connection_error';
  static const String errorAuthentication = 'authentication_error';
  static const String errorAuthorization = 'authorization_error';
  static const String errorValidation = 'validation_error';
  static const String errorServerError = 'server_error';
  static const String errorUnknown = 'unknown_error';
  
  // Default Values
  static const String defaultProfileImage = 'assets/images/no-image.jpg';
  static const String defaultPostImage = 'assets/images/no-image.jpg';
  static const String defaultLogoImage = 'assets/images/img_app_logo.svg';
  static const String defaultErrorImage = 'assets/images/no-image.jpg';
  static const String defaultPlaceholderImage = 'assets/images/no-image.jpg';
  
  // Pagination
  static const int defaultPageSize = 20;
  static const int maxPageSize = 100;
  static const int minPageSize = 5;
  
  // Validation Patterns
  static const String emailPattern = r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$';
  static const String phonePattern = r'^\+?[1-9]\d{1,14}$';
  static const String urlPattern = r'^https?:\/\/(www\.)?[-a-zA-Z0-9@:%._\+~#=]{1,256}\.[a-zA-Z0-9()]{1,6}\b([-a-zA-Z0-9()@:%_\+.~#?&//=]*)$';
  static const String hashtagPattern = r'^#[a-zA-Z0-9_]+$';
  
  // Rate Limiting
  static const int maxApiCallsPerMinute = 100;
  static const int maxUploadRequestsPerMinute = 10;
  static const int maxLoginAttemptsPerMinute = 5;
  
  // Production Environment Checks
  static bool get isProduction => EnvironmentConfig.isProduction;
  static bool get isDevelopment => EnvironmentConfig.isDevelopment;
  static bool get isDebugMode => EnvironmentConfig.debugMode;
  static bool get enableLogging => EnvironmentConfig.enableLogging;
  
  // Configuration Validation
  static bool get hasValidConfiguration => EnvironmentConfig.isProductionReady;
  static String get configurationStatus => EnvironmentConfig.configurationSummary;
  
  // Social Media Limits
  static const Map<String, Map<String, int>> platformLimits = {
    'instagram': {
      'maxCaptionLength': 2200,
      'maxHashtags': 30,
      'maxImageSize': 8388608, // 8MB
      'maxVideoSize': 104857600, // 100MB
      'maxVideoDuration': 60, // seconds
    },
    'facebook': {
      'maxCaptionLength': 63206,
      'maxHashtags': 100,
      'maxImageSize': 10485760, // 10MB
      'maxVideoSize': 1073741824, // 1GB
      'maxVideoDuration': 240, // seconds
    },
    'twitter': {
      'maxCaptionLength': 280,
      'maxHashtags': 20,
      'maxImageSize': 5242880, // 5MB
      'maxVideoSize': 536870912, // 512MB
      'maxVideoDuration': 140, // seconds
    },
    'linkedin': {
      'maxCaptionLength': 3000,
      'maxHashtags': 50,
      'maxImageSize': 10485760, // 10MB
      'maxVideoSize': 5368709120, // 5GB
      'maxVideoDuration': 600, // seconds
    },
    'youtube': {
      'maxCaptionLength': 5000,
      'maxHashtags': 15,
      'maxImageSize': 2097152, // 2MB (thumbnail)
      'maxVideoSize': 137438953472, // 128GB
      'maxVideoDuration': 43200, // seconds (12 hours)
    },
    'tiktok': {
      'maxCaptionLength': 150,
      'maxHashtags': 100,
      'maxImageSize': 10485760, // 10MB
      'maxVideoSize': 287309824, // 274MB
      'maxVideoDuration': 180, // seconds
    },
  };
  
  // App Store Optimization
  static const String appDescription = 'Mewayz is the ultimate all-in-one business platform for social media management, CRM, e-commerce, and more. Streamline your business operations with our comprehensive suite of tools designed for modern entrepreneurs and businesses.';
  
  static const List<String> appKeywords = [
    'social media management',
    'business platform',
    'CRM',
    'e-commerce',
    'analytics',
    'marketing',
    'productivity',
    'automation',
  ];
  
  static const String appCategory = 'Business';
  static const String appSubcategory = 'Productivity';
  
  // Legal Information
  static const String copyrightText = '© 2024 Mewayz. All rights reserved.';
  static const String developerName = 'Mewayz Inc.';
  static const String developerEmail = 'developer@mewayz.com';
  static const String developerWebsite = 'https://mewayz.com';
  
  // Emergency Configuration
  static const String emergencyContactEmail = 'emergency@mewayz.com';
  static const String statusPageUrl = 'https://status.mewayz.com';
  static const String maintenanceUrl = 'https://mewayz.com/maintenance';
  
  // Version Check
  static const String versionCheckUrl = 'https://api.mewayz.com/version/check';
  static const String updateRequiredUrl = 'https://mewayz.com/update-required';
  
  // Deep Linking
  static const String deepLinkScheme = 'mewayz';
  static const String deepLinkHost = 'app.mewayz.com';
  static const String universalLinkDomain = 'mewayz.com';
  
  // Performance Thresholds
  static const int maxAppStartupTime = 3000; // 3 seconds
  static const int maxMemoryUsage = 150 * 1024 * 1024; // 150MB
  static const int maxCpuUsage = 80; // 80%
  static const int maxBatteryUsage = 10; // 10%
  
  // Localization
  static const String defaultLocale = 'en_US';
  static const List<String> supportedLocales = [
    'en_US', // English (US)
    'en_GB', // English (UK)
    'es_ES', // Spanish
    'fr_FR', // French
    'de_DE', // German
    'it_IT', // Italian
    'pt_BR', // Portuguese (Brazil)
    'ja_JP', // Japanese
    'ko_KR', // Korean
    'zh_CN', // Chinese (Simplified)
    'zh_TW', // Chinese (Traditional)
    'ar_SA', // Arabic
    'hi_IN', // Hindi
    'ru_RU', // Russian
  ];
  
  // Accessibility
  static const double minTouchTargetSize = 44.0;
  static const double maxTextScaleFactor = 2.0;
  static const double minTextScaleFactor = 0.8;
  static const List<String> supportedAccessibilityFeatures = [
    'screen_reader',
    'voice_control',
    'high_contrast',
    'large_text',
    'reduced_motion',
    'dark_mode',
  ];
}