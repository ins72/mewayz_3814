
/// Environment configuration manager for production deployments
class EnvironmentConfig {
  static final EnvironmentConfig _instance = EnvironmentConfig._internal();
  factory EnvironmentConfig() => _instance;
  EnvironmentConfig._internal();

  // Core application settings
  static String get appName => const String.fromEnvironment('APP_NAME', defaultValue: 'Mewayz');
  static String get appVersion => const String.fromEnvironment('APP_VERSION', defaultValue: '1.0.0');
  static String get buildNumber => const String.fromEnvironment('BUILD_NUMBER', defaultValue: '1');
  static String get environment => const String.fromEnvironment('ENVIRONMENT', defaultValue: 'production');

  // Supabase configuration
  static String get supabaseUrl => const String.fromEnvironment('SUPABASE_URL', defaultValue: '');
  static String get supabaseAnonKey => const String.fromEnvironment('SUPABASE_ANON_KEY', defaultValue: '');
  static String get supabaseServiceKey => const String.fromEnvironment('SUPABASE_SERVICE_KEY', defaultValue: '');

  // Security configuration
  static String get encryptionKey => const String.fromEnvironment('ENCRYPTION_KEY', defaultValue: '');
  static String get jwtSecret => const String.fromEnvironment('JWT_SECRET', defaultValue: '');
  static String get apiSecretKey => const String.fromEnvironment('API_SECRET_KEY', defaultValue: '');

  // OAuth configuration
  static String get googleClientId => const String.fromEnvironment('GOOGLE_CLIENT_ID', defaultValue: '');
  static String get googleClientSecret => const String.fromEnvironment('GOOGLE_CLIENT_SECRET', defaultValue: '');
  static String get appleClientId => const String.fromEnvironment('APPLE_CLIENT_ID', defaultValue: 'com.mewayz.app');
  static String get appleTeamId => const String.fromEnvironment('APPLE_TEAM_ID', defaultValue: '');
  static String get appleKeyId => const String.fromEnvironment('APPLE_KEY_ID', defaultValue: '');
  static String get applePrivateKey => const String.fromEnvironment('APPLE_PRIVATE_KEY', defaultValue: '');

  // Social media API keys
  static String get instagramClientId => const String.fromEnvironment('INSTAGRAM_CLIENT_ID', defaultValue: '');
  static String get instagramClientSecret => const String.fromEnvironment('INSTAGRAM_CLIENT_SECRET', defaultValue: '');
  static String get facebookAppId => const String.fromEnvironment('FACEBOOK_APP_ID', defaultValue: '');
  static String get facebookAppSecret => const String.fromEnvironment('FACEBOOK_APP_SECRET', defaultValue: '');
  static String get twitterApiKey => const String.fromEnvironment('TWITTER_API_KEY', defaultValue: '');
  static String get twitterApiSecret => const String.fromEnvironment('TWITTER_API_SECRET', defaultValue: '');
  static String get twitterBearerToken => const String.fromEnvironment('TWITTER_BEARER_TOKEN', defaultValue: '');
  static String get linkedinClientId => const String.fromEnvironment('LINKEDIN_CLIENT_ID', defaultValue: '');
  static String get linkedinClientSecret => const String.fromEnvironment('LINKEDIN_CLIENT_SECRET', defaultValue: '');
  static String get youtubeApiKey => const String.fromEnvironment('YOUTUBE_API_KEY', defaultValue: '');
  static String get tiktokClientId => const String.fromEnvironment('TIKTOK_CLIENT_ID', defaultValue: '');
  static String get tiktokClientSecret => const String.fromEnvironment('TIKTOK_CLIENT_SECRET', defaultValue: '');

  // Payment processing
  static String get stripePublishableKey => const String.fromEnvironment('STRIPE_PUBLISHABLE_KEY', defaultValue: '');
  static String get stripeSecretKey => const String.fromEnvironment('STRIPE_SECRET_KEY', defaultValue: '');
  static String get stripeWebhookSecret => const String.fromEnvironment('STRIPE_WEBHOOK_SECRET', defaultValue: '');
  static String get paypalClientId => const String.fromEnvironment('PAYPAL_CLIENT_ID', defaultValue: '');
  static String get paypalClientSecret => const String.fromEnvironment('PAYPAL_CLIENT_SECRET', defaultValue: '');

  // Email services
  static String get sendgridApiKey => const String.fromEnvironment('SENDGRID_API_KEY', defaultValue: '');
  static String get mailgunApiKey => const String.fromEnvironment('MAILGUN_API_KEY', defaultValue: '');
  static String get mailgunDomain => const String.fromEnvironment('MAILGUN_DOMAIN', defaultValue: '');

  // SMS services
  static String get twilioAccountSid => const String.fromEnvironment('TWILIO_ACCOUNT_SID', defaultValue: '');
  static String get twilioAuthToken => const String.fromEnvironment('TWILIO_AUTH_TOKEN', defaultValue: '');
  static String get twilioPhoneNumber => const String.fromEnvironment('TWILIO_PHONE_NUMBER', defaultValue: '');

  // Cloud storage
  static String get cloudinaryCloudName => const String.fromEnvironment('CLOUDINARY_CLOUD_NAME', defaultValue: '');
  static String get cloudinaryApiKey => const String.fromEnvironment('CLOUDINARY_API_KEY', defaultValue: '');
  static String get cloudinaryApiSecret => const String.fromEnvironment('CLOUDINARY_API_SECRET', defaultValue: '');
  static String get awsAccessKeyId => const String.fromEnvironment('AWS_ACCESS_KEY_ID', defaultValue: '');
  static String get awsSecretAccessKey => const String.fromEnvironment('AWS_SECRET_ACCESS_KEY', defaultValue: '');
  static String get awsRegion => const String.fromEnvironment('AWS_REGION', defaultValue: 'us-east-1');
  static String get awsS3Bucket => const String.fromEnvironment('AWS_S3_BUCKET', defaultValue: '');

  // Analytics & monitoring
  static String get firebaseProjectId => const String.fromEnvironment('FIREBASE_PROJECT_ID', defaultValue: '');
  static String get firebaseApiKey => const String.fromEnvironment('FIREBASE_API_KEY', defaultValue: '');
  static String get mixpanelToken => const String.fromEnvironment('MIXPANEL_TOKEN', defaultValue: '');
  static String get sentryDsn => const String.fromEnvironment('SENTRY_DSN', defaultValue: '');
  static String get amplitudeApiKey => const String.fromEnvironment('AMPLITUDE_API_KEY', defaultValue: '');

  // Push notifications
  static String get fcmServerKey => const String.fromEnvironment('FCM_SERVER_KEY', defaultValue: '');
  static String get apnsKeyId => const String.fromEnvironment('APNS_KEY_ID', defaultValue: '');
  static String get apnsTeamId => const String.fromEnvironment('APNS_TEAM_ID', defaultValue: '');
  static String get apnsBundleId => const String.fromEnvironment('APNS_BUNDLE_ID', defaultValue: 'com.mewayz.app');
  static String get apnsPrivateKey => const String.fromEnvironment('APNS_PRIVATE_KEY', defaultValue: '');

  // App store configuration
  static String get appStoreConnectApiKey => const String.fromEnvironment('APP_STORE_CONNECT_API_KEY', defaultValue: '');
  static String get appStoreConnectIssuerId => const String.fromEnvironment('APP_STORE_CONNECT_ISSUER_ID', defaultValue: '');
  static String get appStoreConnectKeyId => const String.fromEnvironment('APP_STORE_CONNECT_KEY_ID', defaultValue: '');
  static String get googlePlayServiceAccountJson => const String.fromEnvironment('GOOGLE_PLAY_SERVICE_ACCOUNT_JSON', defaultValue: '');

  // Production URLs
  static String get apiBaseUrl => const String.fromEnvironment('API_BASE_URL', defaultValue: 'https://api.mewayz.com');
  static String get socketUrl => const String.fromEnvironment('SOCKET_URL', defaultValue: 'wss://socket.mewayz.com');
  static String get cdnBaseUrl => const String.fromEnvironment('CDN_BASE_URL', defaultValue: 'https://cdn.mewayz.com');
  static String get websiteUrl => const String.fromEnvironment('WEBSITE_URL', defaultValue: 'https://mewayz.com');
  static String get privacyPolicyUrl => const String.fromEnvironment('PRIVACY_POLICY_URL', defaultValue: 'https://mewayz.com/privacy-policy');
  static String get termsOfServiceUrl => const String.fromEnvironment('TERMS_OF_SERVICE_URL', defaultValue: 'https://mewayz.com/terms-of-service');
  static String get supportUrl => const String.fromEnvironment('SUPPORT_URL', defaultValue: 'https://mewayz.com/support');

  // Feature flags
  static bool get enableBiometricAuth => const bool.fromEnvironment('ENABLE_BIOMETRIC_AUTH', defaultValue: true);
  static bool get enablePushNotifications => const bool.fromEnvironment('ENABLE_PUSH_NOTIFICATIONS', defaultValue: true);
  static bool get enableAnalytics => const bool.fromEnvironment('ENABLE_ANALYTICS', defaultValue: true);
  static bool get enableCrashlytics => const bool.fromEnvironment('ENABLE_CRASHLYTICS', defaultValue: true);
  static bool get enablePerformanceMonitoring => const bool.fromEnvironment('ENABLE_PERFORMANCE_MONITORING', defaultValue: true);
  static bool get enableOfflineMode => const bool.fromEnvironment('ENABLE_OFFLINE_MODE', defaultValue: true);
  static bool get enableDeepLinking => const bool.fromEnvironment('ENABLE_DEEP_LINKING', defaultValue: true);
  static bool get enableTwoFactorAuth => const bool.fromEnvironment('ENABLE_TWO_FACTOR_AUTH', defaultValue: true);
  static bool get enableOAuthSignin => const bool.fromEnvironment('ENABLE_OAUTH_SIGNIN', defaultValue: true);
  static bool get enableAdvancedAnalytics => const String.fromEnvironment('ENABLE_ADVANCED_ANALYTICS', defaultValue: 'true').toLowerCase() == 'true';

  // Development settings
  static bool get debugMode => const bool.fromEnvironment('DEBUG_MODE', defaultValue: false);
  static bool get enableLogging => const bool.fromEnvironment('ENABLE_LOGGING', defaultValue: false);
  static String get logLevel => const String.fromEnvironment('LOG_LEVEL', defaultValue: 'ERROR');
  static bool get enableNetworkLogging => const bool.fromEnvironment('ENABLE_NETWORK_LOGGING', defaultValue: false);
  static bool get enableDebuggingTools => const bool.fromEnvironment('ENABLE_DEBUGGING_TOOLS', defaultValue: false);

  // Environment detection
  static bool get isProduction => environment == 'production';
  static bool get isDevelopment => environment == 'development';
  static bool get isStaging => environment == 'staging';

  // Validation methods
  static bool get isValidSupabaseConfig => supabaseUrl.isNotEmpty && supabaseAnonKey.isNotEmpty;
  static bool get isValidOAuthConfig => googleClientId.isNotEmpty && appleClientId.isNotEmpty;
  static bool get isValidPaymentConfig => stripePublishableKey.isNotEmpty;
  static bool get isValidAnalyticsConfig => firebaseProjectId.isNotEmpty || mixpanelToken.isNotEmpty;
  static bool get isValidNotificationConfig => fcmServerKey.isNotEmpty || apnsKeyId.isNotEmpty;

  // Configuration validation
  static Map<String, bool> get configurationStatus {
    return {
      'Supabase': isValidSupabaseConfig,
      'OAuth': isValidOAuthConfig,
      'Payment': isValidPaymentConfig,
      'Analytics': isValidAnalyticsConfig,
      'Notifications': isValidNotificationConfig,
      'Instagram API': instagramClientId.isNotEmpty,
      'Facebook API': facebookAppId.isNotEmpty,
      'Twitter API': twitterApiKey.isNotEmpty,
      'LinkedIn API': linkedinClientId.isNotEmpty,
      'YouTube API': youtubeApiKey.isNotEmpty,
      'TikTok API': tiktokClientId.isNotEmpty,
      'Email Service': sendgridApiKey.isNotEmpty,
      'SMS Service': twilioAccountSid.isNotEmpty,
      'Cloud Storage': cloudinaryCloudName.isNotEmpty || awsAccessKeyId.isNotEmpty,
      'Security': encryptionKey.isNotEmpty,
    };
  }

  // Production readiness check
  static bool get isProductionReady {
    final required = [
      isValidSupabaseConfig,
      isValidOAuthConfig,
      encryptionKey.isNotEmpty,
      isProduction,
    ];
    return required.every((element) => element);
  }

  // Configuration summary
  static String get configurationSummary {
    final status = configurationStatus;
    final configured = status.values.where((v) => v).length;
    final total = status.length;
    
    return 'Configuration: $configured/$total ready';
  }

  // Print configuration status (for debugging)
  static void printConfigurationStatus() {
    if (!isProduction) {
      print('=== Mewayz Configuration Status ===');
      print('Environment: $environment');
      print('App Version: $appVersion ($buildNumber)');
      print('Production Ready: $isProductionReady');
      print('');
      
      configurationStatus.forEach((key, value) {
        final status = value ? '✅' : '❌';
        print('$status $key');
      });
      
      print('');
      print('Configuration Summary: $configurationSummary');
      print('===================================');
    }
  }

  // Validate critical configuration
  static List<String> validateConfiguration() {
    final errors = <String>[];

    if (!isValidSupabaseConfig) {
      errors.add('Supabase configuration is missing or invalid');
    }

    if (!isValidOAuthConfig) {
      errors.add('OAuth configuration is missing or invalid');
    }

    if (encryptionKey.isEmpty) {
      errors.add('Encryption key is missing');
    }

    if (encryptionKey.length < 32) {
      errors.add('Encryption key must be at least 32 characters long');
    }

    if (isProduction && debugMode) {
      errors.add('Debug mode should be disabled in production');
    }

    if (isProduction && enableDebuggingTools) {
      errors.add('Debugging tools should be disabled in production');
    }

    return errors;
  }

  // Initialize configuration
  static Future<void> initialize() async {
    if (!isProduction) {
      printConfigurationStatus();
    }

    final errors = validateConfiguration();
    if (errors.isNotEmpty) {
      final errorMessage = 'Configuration errors:\n${errors.join('\n')}';
      if (isProduction) {
        throw Exception(errorMessage);
      } else {
        print('⚠️ $errorMessage');
      }
    }
  }
}