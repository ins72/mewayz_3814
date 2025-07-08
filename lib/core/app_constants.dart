/// Application-wide constants
class AppConstants {
  // API endpoints
  static const String baseUrl = 'https://api.mewayz.com';
  static const String apiVersion = '/v1';
  static const String authEndpoint = '$apiVersion/auth';
  static const String userEndpoint = '$apiVersion/users';
  static const String workspaceEndpoint = '$apiVersion/workspaces';
  static const String socialMediaEndpoint = '$apiVersion/social-media';
  static const String crmEndpoint = '$apiVersion/crm';
  static const String marketplaceEndpoint = '$apiVersion/marketplace';
  static const String analyticsEndpoint = '$apiVersion/analytics';
  static const String notificationEndpoint = '$apiVersion/notifications';
  
  // App information
  static const String appName = 'Mewayz';
  static const String appVersion = '1.0.0';
  static const String appDescription = 'A comprehensive platform for social media management, CRM, e-commerce, and more';
  static const String appWebsite = 'https://mewayz.com';
  static const String supportEmail = 'support@mewayz.com';
  static const String privacyPolicyUrl = 'https://mewayz.com/privacy';
  static const String termsOfServiceUrl = 'https://mewayz.com/terms';
  
  // Storage keys
  static const String authTokenKey = 'auth_token';
  static const String refreshTokenKey = 'refresh_token';
  static const String userDataKey = 'user_data';
  static const String workspaceDataKey = 'workspace_data';
  static const String settingsKey = 'app_settings';
  static const String themeKey = 'theme_mode';
  static const String languageKey = 'language';
  static const String onboardingKey = 'onboarding_completed';
  static const String biometricKey = 'biometric_enabled';
  static const String notificationKey = 'notification_settings';
  
  // Validation patterns
  static const String emailPattern = r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$';
  static const String phonePattern = r'^\+?[1-9]\d{1,14}$';
  static const String passwordPattern = r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]{8,}$';
  static const String urlPattern = r'^https?:\/\/(www\.)?[-a-zA-Z0-9@:%._\+~#=]{1,256}\.[a-zA-Z0-9()]{1,6}\b([-a-zA-Z0-9()@:%_\+.~#?&//=]*)$';
  
  // Social media platforms
  static const List<String> socialMediaPlatforms = [
    'instagram',
    'facebook',
    'twitter',
    'linkedin',
    'youtube',
    'tiktok',
    'snapchat',
    'pinterest',
    'telegram',
    'whatsapp',
  ];
  
  // File upload limits
  static const int maxImageSize = 10 * 1024 * 1024; // 10MB
  static const int maxVideoSize = 100 * 1024 * 1024; // 100MB
  static const int maxDocumentSize = 50 * 1024 * 1024; // 50MB
  static const List<String> allowedImageExtensions = ['.jpg', '.jpeg', '.png', '.gif', '.webp'];
  static const List<String> allowedVideoExtensions = ['.mp4', '.mov', '.avi', '.mkv', '.webm'];
  static const List<String> allowedDocumentExtensions = ['.pdf', '.doc', '.docx', '.txt', '.csv', '.xlsx'];
  
  // Pagination
  static const int defaultPageSize = 20;
  static const int maxPageSize = 100;
  
  // Cache durations
  static const Duration shortCacheDuration = Duration(minutes: 5);
  static const Duration mediumCacheDuration = Duration(hours: 1);
  static const Duration longCacheDuration = Duration(days: 1);
  
  // Animation durations
  static const Duration shortAnimationDuration = Duration(milliseconds: 200);
  static const Duration mediumAnimationDuration = Duration(milliseconds: 300);
  static const Duration longAnimationDuration = Duration(milliseconds: 500);
  
  // Default values
  static const String defaultLanguage = 'en';
  static const String defaultCurrency = 'USD';
  static const String defaultTimezone = 'UTC';
  static const String defaultDateFormat = 'yyyy-MM-dd';
  static const String defaultTimeFormat = 'HH:mm';
  static const String defaultDateTimeFormat = 'yyyy-MM-dd HH:mm';
  
  // Error messages
  static const String networkErrorMessage = 'Network connection error. Please check your internet connection.';
  static const String serverErrorMessage = 'Server error. Please try again later.';
  static const String authErrorMessage = 'Authentication failed. Please login again.';
  static const String permissionErrorMessage = 'Permission denied. Please check your permissions.';
  static const String validationErrorMessage = 'Validation failed. Please check your input.';
  static const String unknownErrorMessage = 'An unknown error occurred. Please try again.';
  
  // Success messages
  static const String loginSuccessMessage = 'Login successful!';
  static const String registrationSuccessMessage = 'Registration successful!';
  static const String updateSuccessMessage = 'Update successful!';
  static const String deleteSuccessMessage = 'Delete successful!';
  static const String saveSuccessMessage = 'Save successful!';
  static const String sendSuccessMessage = 'Send successful!';
  
  // Feature flags
  static const bool enableBiometricAuth = true;
  static const bool enablePushNotifications = true;
  static const bool enableAnalytics = true;
  static const bool enableCrashReporting = true;
  static const bool enableOfflineMode = true;
  static const bool enableDarkMode = true;
  static const bool enableMultiLanguage = true;
  static const bool enableSocialLogin = true;
  static const bool enableTwoFactorAuth = true;
  static const bool enableDeepLinking = true;
  
  // Subscription plans
  static const List<String> subscriptionPlans = [
    'free',
    'starter',
    'professional',
    'enterprise',
  ];
  
  // User roles
  static const List<String> userRoles = [
    'owner',
    'admin',
    'manager',
    'member',
    'viewer',
  ];
  
  // Workspace limits
  static const int maxWorkspacesPerUser = 5;
  static const int maxMembersPerWorkspace = 50;
  static const int maxProjectsPerWorkspace = 100;
  
  // Rate limiting
  static const int maxApiCallsPerMinute = 100;
  static const int maxUploadsPerHour = 50;
  static const int maxEmailsPerDay = 1000;
  
  // Social media limits
  static const int maxPostsPerDay = 100;
  static const int maxHashtagsPerPost = 30;
  static const int maxMentionsPerPost = 10;
  static const int maxCharactersPerPost = 2200;
  
  // CRM limits
  static const int maxContactsPerWorkspace = 10000;
  static const int maxLeadsPerWorkspace = 5000;
  static const int maxDealsPerWorkspace = 1000;
  
  // E-commerce limits
  static const int maxProductsPerStore = 10000;
  static const int maxCategoriesPerStore = 100;
  static const int maxOrdersPerDay = 1000;
  
  // Analytics retention
  static const int analyticsRetentionDays = 365;
  static const int reportsRetentionDays = 90;
  static const int logsRetentionDays = 30;
  
  // Notification types
  static const List<String> notificationTypes = [
    'system',
    'security',
    'marketing',
    'social',
    'crm',
    'ecommerce',
    'analytics',
    'billing',
  ];
  
  // Time zones
  static const List<String> supportedTimezones = [
    'UTC',
    'America/New_York',
    'America/Los_Angeles',
    'Europe/London',
    'Europe/Paris',
    'Asia/Tokyo',
    'Asia/Shanghai',
    'Australia/Sydney',
  ];
  
  // Currencies
  static const List<String> supportedCurrencies = [
    'USD',
    'EUR',
    'GBP',
    'JPY',
    'AUD',
    'CAD',
    'CHF',
    'CNY',
    'INR',
    'BRL',
  ];
  
  // Languages
  static const List<String> supportedLanguages = [
    'en',
    'es',
    'fr',
    'de',
    'it',
    'pt',
    'ru',
    'ja',
    'ko',
    'zh',
    'ar',
    'hi',
  ];
  
  // Chart colors
  static const List<String> chartColors = [
    '#3B82F6',
    '#10B981',
    '#F59E0B',
    '#EF4444',
    '#8B5CF6',
    '#F97316',
    '#06B6D4',
    '#84CC16',
    '#EC4899',
    '#6B7280',
  ];
  
  // Export formats
  static const List<String> exportFormats = [
    'csv',
    'xlsx',
    'pdf',
    'json',
    'xml',
  ];
  
  // Image sizes
  static const Map<String, Map<String, int>> imageSizes = {
    'avatar': {'width': 200, 'height': 200},
    'thumbnail': {'width': 300, 'height': 300},
    'small': {'width': 600, 'height': 600},
    'medium': {'width': 1200, 'height': 1200},
    'large': {'width': 2048, 'height': 2048},
  };
  
  // Video qualities
  static const List<String> videoQualities = [
    '240p',
    '360p',
    '480p',
    '720p',
    '1080p',
    '1440p',
    '2160p',
  ];
  
  // Backup settings
  static const Duration backupInterval = Duration(hours: 6);
  static const int maxBackupFiles = 10;
  static const Duration backupRetention = Duration(days: 30);
  
  // Security settings
  static const int maxLoginAttempts = 5;
  static const Duration lockoutDuration = Duration(minutes: 15);
  static const int sessionTimeoutMinutes = 30;
  static const int passwordMinLength = 8;
  static const int passwordMaxLength = 128;
  
  // Content moderation
  static const List<String> bannedWords = [
    // Add banned words here
  ];
  
  // Regular expressions
  static const String hashtagRegex = r'#[a-zA-Z0-9_]+';
  static const String mentionRegex = r'@[a-zA-Z0-9_]+';
  static const String urlRegex = r'https?:\/\/(www\.)?[-a-zA-Z0-9@:%._\+~#=]{1,256}\.[a-zA-Z0-9()]{1,6}\b([-a-zA-Z0-9()@:%_\+.~#?&//=]*)';
  
  // Device information
  static const String deviceInfoKey = 'device_info';
  static const String appInstallKey = 'app_install_date';
  static const String lastUpdateKey = 'last_update_date';
  
  // Performance monitoring
  static const Duration performanceThreshold = Duration(seconds: 2);
  static const int maxMemoryUsage = 512; // MB
  static const int maxCpuUsage = 80; // Percentage
  
  // Database settings
  static const String databaseName = 'mewayz.db';
  static const int databaseVersion = 1;
  static const Duration databaseTimeout = Duration(seconds: 30);
  
  // WebSocket settings
  static const String websocketUrl = 'wss://socket.mewayz.com';
  static const Duration websocketReconnectInterval = Duration(seconds: 5);
  static const int maxWebsocketReconnectAttempts = 10;
  
  // CDN settings
  static const String cdnUrl = 'https://cdn.mewayz.com';
  static const Duration cdnCacheExpiry = Duration(hours: 24);
  
  // Search settings
  static const int maxSearchResults = 50;
  static const int minSearchLength = 3;
  static const Duration searchDebounceDelay = Duration(milliseconds: 300);
  
  // Infinite scroll settings
  static const int infiniteScrollThreshold = 200;
  static const int infiniteScrollBuffer = 5;
  
  // Map settings
  static const double defaultLatitude = 40.7128;
  static const double defaultLongitude = -74.0060;
  static const double defaultZoom = 10.0;
  
  // Audio settings
  static const int audioSampleRate = 44100;
  static const int audioBitRate = 128000;
  static const List<String> audioFormats = ['mp3', 'wav', 'aac', 'm4a'];
  
  // Notification settings
  static const Duration notificationDisplayDuration = Duration(seconds: 5);
  static const int maxNotificationsPerDay = 50;
  static const List<String> notificationSounds = [
    'default',
    'chime',
    'bell',
    'alert',
    'notification',
  ];
}