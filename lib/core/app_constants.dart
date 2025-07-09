
/// Application constants for production deployment
class AppConstants {
  // API Configuration
  static const String baseUrl = 'https://api.example.com';
  static const int connectTimeout = 30000;
  static const int receiveTimeout = 30000;
  
  // Storage Keys
  static const String accessToken = 'access_token';
  static const String refreshToken = 'refresh_token';
  static const String userId = 'user_id';
  static const String userEmail = 'user_email';
  static const String userName = 'user_name';
  static const String userAvatar = 'user_avatar';
  static const String themeMode = 'theme_mode';
  static const String language = 'language';
  static const String onboardingCompleted = 'onboarding_completed';
  static const String biometricEnabled = 'biometric_enabled';
  static const String notificationsEnabled = 'notifications_enabled';
  static const String autoSaveEnabled = 'auto_save_enabled';
  static const String darkModeEnabled = 'dark_mode_enabled';
  static const String firstLaunch = 'first_launch';
  static const String lastSyncTime = 'last_sync_time';
  static const String offlineMode = 'offline_mode';
  static const String dataUsageWarning = 'data_usage_warning';
  static const String cacheSize = 'cache_size';
  static const String maxCacheSize = 'max_cache_size';
  static const String autoBackup = 'auto_backup';
  static const String backupFrequency = 'backup_frequency';
  static const String lastBackupTime = 'last_backup_time';
  static const String analyticsEnabled = 'analytics_enabled';
  static const String crashReportingEnabled = 'crash_reporting_enabled';
  static const String performanceTrackingEnabled = 'performance_tracking_enabled';
}

// Centralized enum definitions
enum WorkspaceGoal {
  socialMediaManagement,
  ecommerceBusiness,
  courseCreation,
  leadGeneration,
  allInOneBusiness,
}

enum MemberRole {
  owner,
  admin,
  manager,
  member,
  viewer,
}

// Extension methods for enum conversion
extension WorkspaceGoalExtension on WorkspaceGoal {
  String get value {
    switch (this) {
      case WorkspaceGoal.socialMediaManagement:
        return 'social_media_management';
      case WorkspaceGoal.ecommerceBusiness:
        return 'ecommerce_business';
      case WorkspaceGoal.courseCreation:
        return 'course_creation';
      case WorkspaceGoal.leadGeneration:
        return 'lead_generation';
      case WorkspaceGoal.allInOneBusiness:
        return 'all_in_one_business';
    }
  }
  
  String get displayName {
    switch (this) {
      case WorkspaceGoal.socialMediaManagement:
        return 'Social Media Management';
      case WorkspaceGoal.ecommerceBusiness:
        return 'E-commerce Business';
      case WorkspaceGoal.courseCreation:
        return 'Course Creation';
      case WorkspaceGoal.leadGeneration:
        return 'Lead Generation';
      case WorkspaceGoal.allInOneBusiness:
        return 'All-in-One Business';
    }
  }
}

extension MemberRoleExtension on MemberRole {
  String get value {
    switch (this) {
      case MemberRole.owner:
        return 'owner';
      case MemberRole.admin:
        return 'admin';
      case MemberRole.manager:
        return 'manager';
      case MemberRole.member:
        return 'member';
      case MemberRole.viewer:
        return 'viewer';
    }
  }
  
  String get displayName {
    switch (this) {
      case MemberRole.owner:
        return 'Owner';
      case MemberRole.admin:
        return 'Admin';
      case MemberRole.manager:
        return 'Manager';
      case MemberRole.member:
        return 'Member';
      case MemberRole.viewer:
        return 'Viewer';
    }
  }
}