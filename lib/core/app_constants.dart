/// Application-wide constants for production deployment
class AppConstants {
  // App Information
  static const String appName = 'Mewayz';
  static const String appDescription = 'All-in-One Business Platform';
  static const String appVersion = '1.0.0';
  
  // Supabase Configuration
  static const String supabaseUrlKey = 'SUPABASE_URL';
  static const String supabaseAnonKeyKey = 'SUPABASE_ANON_KEY';
  
  // OAuth Configuration
  static const String googleClientIdKey = 'GOOGLE_CLIENT_ID';
  
  // Storage Buckets
  static const String uploadsBucket = 'uploads';
  static const String avatarsBucket = 'avatars';
  static const String productImagesBucket = 'product-images';
  
  // Database Tables
  static const String userProfilesTable = 'user_profiles';
  static const String workspacesTable = 'workspaces';
  static const String workspaceMembersTable = 'workspace_members';
  static const String analyticsEventsTable = 'analytics_events';
  static const String socialMediaPostsTable = 'social_media_posts';
  static const String socialMediaAccountsTable = 'social_media_accounts';
  static const String productsTable = 'products';
  static const String ordersTable = 'orders';
  static const String orderItemsTable = 'order_items';
  static const String notificationsTable = 'notifications';
  static const String workspaceInvitationsTable = 'workspace_invitations';
  
  // Real-time Channels
  static const String analyticsChannelPrefix = 'analytics_';
  static const String socialMediaChannelPrefix = 'social_media_';
  static const String productsChannelPrefix = 'products_';
  static const String ordersChannelPrefix = 'orders_';
  static const String notificationsChannelPrefix = 'notifications_';
  
  // Cache Keys
  static const String userWorkspacesCacheKey = 'user_workspaces';
  static const String analyticsCacheKey = 'analytics_data';
  static const String productsCacheKey = 'products_data';
  static const String notificationsCacheKey = 'notifications_data';
  
  // Local Storage Keys
  static const String authTokenKey = 'auth_token';
  static const String currentWorkspaceKey = 'current_workspace';
  static const String userPreferencesKey = 'user_preferences';
  static const String offlineQueueKey = 'offline_queue';
  static const String biometricCredentialsKey = 'biometric_credentials';
  
  // Analytics Events
  static const String userSignupEvent = 'user_signup';
  static const String userSigninEvent = 'user_signin';
  static const String workspaceCreatedEvent = 'workspace_created';
  static const String postCreatedEvent = 'post_created';
  static const String productCreatedEvent = 'product_created';
  static const String orderCreatedEvent = 'order_created';
  static const String pageViewEvent = 'page_view';
  static const String buttonClickEvent = 'button_click';
  static const String formSubmitEvent = 'form_submit';
  
  // Error Messages
  static const String networkErrorMessage = 'Network connection error. Please check your internet connection.';
  static const String authErrorMessage = 'Authentication failed. Please try again.';
  static const String serverErrorMessage = 'Server error occurred. Please try again later.';
  static const String validationErrorMessage = 'Please check your input and try again.';
  static const String permissionErrorMessage = 'You don\'t have permission to perform this action.';
  
  // Success Messages
  static const String dataUpdatedMessage = 'Data updated successfully';
  static const String dataCreatedMessage = 'Data created successfully';
  static const String dataDeletedMessage = 'Data deleted successfully';
  static const String emailSentMessage = 'Email sent successfully';
  
  // Validation Rules
  static const int minPasswordLength = 8;
  static const int maxFileSize = 10 * 1024 * 1024; // 10MB
  static const List<String> allowedImageFormats = ['jpg', 'jpeg', 'png', 'webp'];
  static const List<String> allowedDocumentFormats = ['pdf', 'doc', 'docx', 'txt'];
  
  // Pagination
  static const int defaultPageSize = 20;
  static const int maxPageSize = 100;
  
  // Timeouts
  static const Duration apiTimeout = Duration(seconds: 30);
  static const Duration uploadTimeout = Duration(minutes: 5);
  static const Duration downloadTimeout = Duration(minutes: 2);
  
  // Production Environment Checks
  static const List<String> requiredEnvironmentVariables = [
    supabaseUrlKey,
    supabaseAnonKeyKey,
  ];
  
  // Feature Flags
  static const bool enableAnalytics = true;
  static const bool enableCrashReporting = true;
  static const bool enablePerformanceMonitoring = true;
  static const bool enableOfflineMode = true;
  static const bool enableBiometricAuth = true;
  static const bool enablePushNotifications = true;
  
  // URL Patterns
  static const String emailPattern = r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$';
  static const String phonePattern = r'^\+?[1-9]\d{1,14}$';
  static const String urlPattern = r'^https?:\/\/(www\.)?[-a-zA-Z0-9@:%._\+~#=]{1,256}\.[a-zA-Z0-9()]{1,6}\b([-a-zA-Z0-9()@:%_\+.~#?&//=]*)$';
  
  // Social Media Platforms
  static const List<String> supportedSocialPlatforms = [
    'facebook',
    'instagram',
    'twitter',
    'linkedin',
    'youtube',
    'tiktok',
  ];
  
  // Product Categories
  static const List<String> defaultProductCategories = [
    'Electronics',
    'Clothing',
    'Books',
    'Home & Garden',
    'Sports',
    'Toys',
    'Food & Beverages',
    'Other',
  ];
  
  // Workspace Goals
  static const List<String> workspaceGoals = [
    'social_media_management',
    'e_commerce_store',
    'lead_generation',
    'content_creation',
    'customer_management',
    'email_marketing',
    'analytics_tracking',
    'team_collaboration',
    'custom',
  ];
  
  // Notification Types
  static const String orderNotification = 'order';
  static const String workspaceNotification = 'workspace';
  static const String systemNotification = 'system';
  static const String marketingNotification = 'marketing';
  
  // User Roles
  static const String ownerRole = 'owner';
  static const String adminRole = 'admin';
  static const String memberRole = 'member';
  static const String viewerRole = 'viewer';
  
  // Order Status
  static const String pendingOrderStatus = 'pending';
  static const String processingOrderStatus = 'processing';
  static const String shippedOrderStatus = 'shipped';
  static const String deliveredOrderStatus = 'delivered';
  static const String cancelledOrderStatus = 'cancelled';
  
  // Product Status
  static const String activeProductStatus = 'active';
  static const String inactiveProductStatus = 'inactive';
  static const String outOfStockProductStatus = 'out_of_stock';
  
  // Post Status
  static const String draftPostStatus = 'draft';
  static const String scheduledPostStatus = 'scheduled';
  static const String publishedPostStatus = 'published';
  static const String failedPostStatus = 'failed';
}