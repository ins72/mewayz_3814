import 'package:flutter/material.dart';

import '../presentation/account_settings_screen/account_settings_screen.dart';
import '../presentation/advanced_crm_management_hub/advanced_crm_management_hub.dart';
import '../presentation/analytics_dashboard/analytics_dashboard.dart';
import '../presentation/app_store_optimization_screen/app_store_optimization_screen.dart';
import '../presentation/contact_us_screen/contact_us_screen.dart';
import '../presentation/content_calendar_screen/content_calendar_screen.dart';
import '../presentation/content_templates_screen/content_templates_screen.dart';
import '../presentation/course_creator/course_creator.dart';
import '../presentation/crm_contact_management/crm_contact_management.dart';
import '../presentation/custom_domain_management_screen/custom_domain_management_screen.dart';
import '../presentation/email_marketing_campaign/email_marketing_campaign.dart';
import '../presentation/email_verification_screen/email_verification_screen.dart';
import '../presentation/enhanced_registration_screen/enhanced_registration_screen.dart';
import '../presentation/enhanced_workspace_dashboard/enhanced_workspace_dashboard.dart';
import '../presentation/forgot_password_screen/forgot_password_screen.dart';
import '../presentation/goal_based_subscription_pricing_screen/goal_based_subscription_pricing_screen.dart';
import '../presentation/goal_based_workspace_creation_screen/goal_based_workspace_creation_screen.dart';
import '../presentation/goal_customized_workspace_dashboard/goal_customized_workspace_dashboard.dart';
import '../presentation/goal_selection_screen/goal_selection_screen.dart';
import '../presentation/hashtag_research_screen/hashtag_research_screen.dart';
import '../presentation/instagram_lead_search/instagram_lead_search.dart';
import '../presentation/link_in_bio_analytics_screen/link_in_bio_analytics_screen.dart';
import '../presentation/link_in_bio_templates_screen/link_in_bio_templates_screen.dart';
import '../presentation/login_screen/login_screen.dart';
import '../presentation/marketplace_store/marketplace_store.dart';
import '../presentation/multi_platform_posting_screen/multi_platform_posting_screen.dart';
import '../presentation/notification_settings_screen/notification_settings_screen.dart';
import '../presentation/post_creation_team_invitation_screen/post_creation_team_invitation_screen.dart';
import '../presentation/premium_social_media_hub/premium_social_media_hub.dart';
import '../presentation/privacy_policy_screen/privacy_policy_screen.dart';
import '../presentation/production_dashboard_screen/production_dashboard_screen.dart';
import '../presentation/production_release_checklist_screen/production_release_checklist_screen.dart';
import '../presentation/professional_readme_documentation_screen/professional_readme_documentation_screen.dart';
import '../presentation/profile_settings_screen/profile_settings_screen.dart';
import '../presentation/qr_code_generator_screen/qr_code_generator_screen.dart';
import '../presentation/register_screen/register_screen.dart';
import '../presentation/reset_password_screen/reset_password_screen.dart';
import '../presentation/role_based_access_control_screen/role_based_access_control_screen.dart';
import '../presentation/security_settings_screen/security_settings_screen.dart';
import '../presentation/settings_account_management/settings_account_management.dart';
import '../presentation/settings_screen/settings_screen.dart';
import '../presentation/setup_progress_screen/setup_progress_screen.dart';
import '../presentation/social_media_analytics_screen/social_media_analytics_screen.dart';
import '../presentation/social_media_management_hub/social_media_management_hub.dart';
import '../presentation/social_media_management_screen/social_media_management_screen.dart';
import '../presentation/social_media_manager/social_media_manager.dart';
import '../presentation/social_media_scheduler/social_media_scheduler.dart';
import '../presentation/social_media_scheduler_screen/social_media_scheduler_screen.dart';
import '../presentation/splash_screen/splash_screen.dart';
import '../presentation/team_member_invitation_screen/team_member_invitation_screen.dart';
import '../presentation/terms_of_service_screen/terms_of_service_screen.dart';
import '../presentation/two_factor_authentication_screen/two_factor_authentication_screen.dart';
import '../presentation/unified_analytics_screen/unified_analytics_screen.dart';
import '../presentation/unified_settings_screen/unified_settings_screen.dart';
import '../presentation/users_team_management_screen/users_team_management_screen.dart';
import '../presentation/workspace_creation_screen/workspace_creation_screen.dart';
import '../presentation/workspace_dashboard/workspace_dashboard.dart';
import '../presentation/workspace_selector_screen/workspace_selector_screen.dart';
import '../presentation/workspace_settings_screen/workspace_settings_screen.dart';
import '../presentation/page_not_found_screen/page_not_found_screen.dart';

class AppRoutes {
  // Main screens
  static const String splashScreen = '/splash';
  static const String home = '/home';
  static const String loginScreen = '/login';
  static const String registerScreen = '/register';
  static const String enhancedRegistrationScreen = '/enhanced-register';
  static const String forgotPasswordScreen = '/forgot-password';
  static const String resetPasswordScreen = '/reset-password';
  static const String emailVerificationScreen = '/email-verification';
  static const String twoFactorAuthenticationScreen = '/two-factor-authentication';
  
  // Onboarding
  static const String userOnboardingScreen = '/user-onboarding';
  static const String onboardingScreen = '/onboarding';
  static const String unifiedOnboardingScreen = '/unified-onboarding';
  static const String goalSelectionScreen = '/goal-selection';
  static const String setupProgressScreen = '/setup-progress';
  
  // Error handling
  static const String pageNotFoundScreen = '/page-not-found';
  
  // Workspace management
  static const String workspaceSelectorScreen = '/workspace-selector';
  static const String workspaceCreationScreen = '/workspace-creation';
  static const String goalBasedWorkspaceCreationScreen = '/goal-based-workspace-creation';
  static const String workspaceDashboard = '/workspace-dashboard';
  static const String enhancedWorkspaceDashboard = '/enhanced-workspace-dashboard';
  static const String goalCustomizedWorkspaceDashboard = '/goal-customized-workspace-dashboard';
  static const String workspaceSettingsScreen = '/workspace-settings';
  
  // Team management
  static const String teamMemberInvitationScreen = '/team-member-invitation';
  static const String postCreationTeamInvitationScreen = '/post-creation-team-invitation';
  static const String usersTeamManagementScreen = '/users-team-management';
  static const String roleBasedAccessControlScreen = '/role-based-access-control';
  
  // Social media
  static const String socialMedia = '/social-media';
  static const String socialMediaManagerScreen = '/social-media-manager';
  static const String socialMediaManagementScreen = '/social-media-management';
  static const String socialMediaManagementHubScreen = '/social-media-management-hub';
  static const String premiumSocialMediaHubScreen = '/premium-social-media-hub';
  static const String socialMediaSchedulerScreen = '/social-media-scheduler';
  static const String socialMediaScheduler = '/social-media-scheduler-v2';
  static const String multiPlatformPostingScreen = '/multi-platform-posting';
  
  // Analytics
  static const String analyticsDashboard = '/analytics-dashboard';
  static const String unifiedAnalyticsScreen = '/unified-analytics';
  static const String socialMediaAnalyticsScreen = '/social-media-analytics';
  static const String linkInBioAnalyticsScreen = '/link-in-bio-analytics';
  
  // Content management
  static const String contentTemplatesScreen = '/content-templates';
  static const String contentCalendarScreen = '/content-calendar';
  static const String hashtagResearchScreen = '/hashtag-research';
  static const String courseCreatorScreen = '/course-creator';
  static const String courses = '/courses';
  
  // Link in bio
  static const String linkInBio = '/link-in-bio';
  static const String linkInBioTemplatesScreen = '/link-in-bio-templates';
  
  // CRM
  static const String crmContacts = '/crm-contacts';
  static const String crmContactManagementScreen = '/crm-contact-management';
  static const String advancedCrmManagementHubScreen = '/advanced-crm-management-hub';
  static const String instagramLeadSearchScreen = '/instagram-lead-search';
  
  // E-commerce
  static const String marketplace = '/marketplace';
  static const String marketplaceStoreScreen = '/marketplace-store';
  
  // Marketing
  static const String emailMarketing = '/email-marketing';
  static const String emailMarketingCampaignScreen = '/email-marketing-campaign';
  static const String qrCodeGeneratorScreen = '/qr-code-generator';
  
  // Settings
  static const String settingsScreen = '/settings';
  static const String unifiedSettingsScreen = '/unified-settings';
  static const String accountSettingsScreen = '/account-settings';
  static const String settingsAccountManagementScreen = '/settings-account-management';
  static const String profileSettingsScreen = '/profile-settings';
  static const String securitySettingsScreen = '/security-settings';
  static const String notificationSettingsScreen = '/notification-settings';
  
  // Subscription and pricing
  static const String goalBasedSubscriptionPricingScreen = '/goal-based-subscription-pricing';
  
  // Legal and support
  static const String privacyPolicyScreen = '/privacy-policy';
  static const String termsOfServiceScreen = '/terms-of-service';
  static const String contactUsScreen = '/contact-us';
  
  // Development and documentation
  static const String professionalReadmeDocumentationScreen = '/professional-readme-documentation';
  static const String customDomainManagementScreen = '/custom-domain-management';
  static const String appStoreOptimizationScreen = '/app-store-optimization';
  
  // Production management
  static const String productionReleaseChecklistScreen = '/production-release-checklist';
  static const String productionDashboardScreen = '/production-dashboard';

  // Route map
  static Map<String, WidgetBuilder> get routes => {
    // Main screens
    splashScreen: (context) => const SplashScreen(),
    home: (context) => const EnhancedWorkspaceDashboard(),
    loginScreen: (context) => const LoginScreen(),
    registerScreen: (context) => const RegisterScreen(),
    enhancedRegistrationScreen: (context) => const EnhancedRegistrationScreen(),
    forgotPasswordScreen: (context) => const ForgotPasswordScreen(),
    resetPasswordScreen: (context) => const ResetPasswordScreen(),
    emailVerificationScreen: (context) => const EmailVerificationScreen(),
    twoFactorAuthenticationScreen: (context) => const TwoFactorAuthenticationScreen(),
    
    // Onboarding    unifiedOnboardingScreen: (context) => const UnifiedOnboardingScreen(),
    goalSelectionScreen: (context) => const GoalSelectionScreen(),
    setupProgressScreen: (context) => const SetupProgressScreen(),
    
    // Error handling
    pageNotFoundScreen: (context) => const PageNotFoundScreen(),
    
    // Workspace management
    workspaceSelectorScreen: (context) => const WorkspaceSelectorScreen(),
    workspaceCreationScreen: (context) => const WorkspaceCreationScreen(),
    goalBasedWorkspaceCreationScreen: (context) => const GoalBasedWorkspaceCreationScreen(),
    workspaceDashboard: (context) => const WorkspaceDashboard(),
    enhancedWorkspaceDashboard: (context) => const EnhancedWorkspaceDashboard(),
    goalCustomizedWorkspaceDashboard: (context) => const GoalCustomizedWorkspaceDashboard(),
    workspaceSettingsScreen: (context) => const WorkspaceSettingsScreen(),
    
    // Team management
    teamMemberInvitationScreen: (context) => const TeamMemberInvitationScreen(),
    postCreationTeamInvitationScreen: (context) => const PostCreationTeamInvitationScreen(),
    usersTeamManagementScreen: (context) => const UsersTeamManagementScreen(),
    roleBasedAccessControlScreen: (context) => const RoleBasedAccessControlScreen(),
    
    // Social media
    socialMedia: (context) => const SocialMediaManager(),
    socialMediaManagerScreen: (context) => const SocialMediaManager(),
    socialMediaManagementScreen: (context) => const SocialMediaManagementScreen(),
    socialMediaManagementHubScreen: (context) => const SocialMediaManagementHub(),
    premiumSocialMediaHubScreen: (context) => const PremiumSocialMediaHub(),
    socialMediaSchedulerScreen: (context) => const SocialMediaSchedulerScreen(),
    socialMediaScheduler: (context) => const SocialMediaScheduler(),
    multiPlatformPostingScreen: (context) => const MultiPlatformPostingScreen(),
    
    // Analytics
    analyticsDashboard: (context) => const AnalyticsDashboard(),
    unifiedAnalyticsScreen: (context) => const UnifiedAnalyticsScreen(),
    socialMediaAnalyticsScreen: (context) => const SocialMediaAnalyticsScreen(),
    linkInBioAnalyticsScreen: (context) => const LinkInBioAnalyticsScreen(),
    
    // Content management
    contentTemplatesScreen: (context) => const ContentTemplatesScreen(),
    contentCalendarScreen: (context) => const ContentCalendarScreen(),
    hashtagResearchScreen: (context) => const HashtagResearchScreen(),
    courseCreatorScreen: (context) => const CourseCreator(),
    courses: (context) => const CourseCreator(),
    
    // Link in bio
    linkInBio: (context) => const LinkInBioTemplatesScreen(),
    linkInBioTemplatesScreen: (context) => const LinkInBioTemplatesScreen(),
    
    // CRM
    crmContacts: (context) => const CrmContactManagement(),
    crmContactManagementScreen: (context) => const CrmContactManagement(),
    advancedCrmManagementHubScreen: (context) => const AdvancedCrmManagementHub(),
    instagramLeadSearchScreen: (context) => const InstagramLeadSearch(),
    
    // E-commerce
    marketplace: (context) => const MarketplaceStore(),
    marketplaceStoreScreen: (context) => const MarketplaceStore(),
    
    // Marketing
    emailMarketing: (context) => const EmailMarketingCampaign(),
    emailMarketingCampaignScreen: (context) => const EmailMarketingCampaign(),
    qrCodeGeneratorScreen: (context) => const QrCodeGeneratorScreen(),
    
    // Settings
    settingsScreen: (context) => const SettingsScreen(),
    unifiedSettingsScreen: (context) => const UnifiedSettingsScreen(),
    accountSettingsScreen: (context) => const AccountSettingsScreen(),
    settingsAccountManagementScreen: (context) => const SettingsAccountManagement(),
    profileSettingsScreen: (context) => const ProfileSettingsScreen(),
    securitySettingsScreen: (context) => const SecuritySettingsScreen(),
    notificationSettingsScreen: (context) => const NotificationSettingsScreen(),
    
    // Subscription and pricing
    goalBasedSubscriptionPricingScreen: (context) => const GoalBasedSubscriptionPricingScreen(),
    
    // Legal and support
    privacyPolicyScreen: (context) => const PrivacyPolicyScreen(),
    termsOfServiceScreen: (context) => const TermsOfServiceScreen(),
    contactUsScreen: (context) => const ContactUsScreen(),
    
    // Development and documentation
    professionalReadmeDocumentationScreen: (context) => const ProfessionalReadmeDocumentationScreen(),
    customDomainManagementScreen: (context) => const CustomDomainManagementScreen(),
    appStoreOptimizationScreen: (context) => const AppStoreOptimizationScreen(),
    
    // Production management
    productionReleaseChecklistScreen: (context) => const ProductionReleaseChecklistScreen(),
    productionDashboardScreen: (context) => const ProductionDashboardScreen(),
  };

  // Handle unknown routes
  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    // Check if the route exists in our defined routes
    final routeBuilder = routes[settings.name];
    if (routeBuilder != null) {
      return MaterialPageRoute(
        builder: routeBuilder,
        settings: settings,
      );
    }
    
    // If route doesn't exist, show page not found
    return MaterialPageRoute(
      builder: (context) => const PageNotFoundScreen(),
      settings: settings,
    );
  }
}