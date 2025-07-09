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
import '../presentation/email_marketing_campaign/email_marketing_campaign.dart';
import '../presentation/email_verification_screen/email_verification_screen.dart';
import '../presentation/enhanced_registration_screen/enhanced_registration_screen.dart';
import '../presentation/enhanced_workspace_dashboard/enhanced_workspace_dashboard.dart';
import '../presentation/forgot_password_screen/forgot_password_screen.dart';
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
import '../presentation/production_release_checklist_screen/production_release_checklist_screen.dart';
import '../presentation/professional_readme_documentation_screen/professional_readme_documentation_screen.dart';
import '../presentation/profile_settings_screen/profile_settings_screen.dart';
import '../presentation/qr_code_generator_screen/qr_code_generator_screen.dart';
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
import '../presentation/unified_onboarding_screen/unified_onboarding_screen.dart';
import '../presentation/unified_settings_screen/unified_settings_screen.dart';
import '../presentation/users_team_management_screen/users_team_management_screen.dart';
import '../presentation/workspace_creation_screen/workspace_creation_screen.dart';
import '../presentation/workspace_selector_screen/workspace_selector_screen.dart';
import '../presentation/workspace_settings_screen/workspace_settings_screen.dart';
import '../widgets/auth_guard_widget.dart';

class AppRoutes {
  static const String initial = '/login-screen';
  static const String splashScreen = '/splash-screen';
  static const String onboarding = '/onboarding';
  static const String home = '/home';
  static const String linkInBio = '/link-in-bio';
  static const String forgotPassword = '/forgot-password';
  static const String register = '/register';
  static const String postingScreen = '/posting-screen';
  static const String scheduler = '/scheduler';
  static const String socialMediaAnalytics = '/social-media-analytics';
  static const String linkInBioAnalytics = '/link-in-bio-analytics';
  static const String qrCodeGenerator = '/qr-code-generator';
  static const String goalSelectionScreen = '/goal-selection-screen';
  static const String goalBasedWorkspaceCreationScreen = '/goal-based-workspace-creation-screen';
  static const String postCreationTeamInvitationScreen = '/post-creation-team-invitation-screen';
  static const String workspaceCreationScreen = '/workspace-creation-screen';
  static const String workspaceSelectorScreen = '/workspace-selector-screen';
  static const String workspaceDashboard = '/workspace-dashboard';
  static const String enhancedWorkspaceDashboard = '/enhanced-workspace-dashboard';
  static const String enhancedRegistrationScreen = '/enhanced-registration-screen';
  static const String goalCustomizedWorkspaceDashboard = '/goal-customized-workspace-dashboard';
  static const String premiumSocialMediaHub = '/premium-social-media-hub';
  static const String loginScreen = '/login-screen';
  static const String onboardingScreen = '/onboarding-screen';
  static const String registerScreen = '/register-screen';
  static const String termsOfServiceScreen = '/terms-of-service-screen';
  static const String privacyPolicyScreen = '/privacy-policy-screen';
  static const String forgotPasswordScreen = '/forgot-password-screen';
  static const String resetPasswordScreen = '/reset-password-screen';
  static const String emailVerificationScreen = '/email-verification-screen';
  static const String userOnboardingScreen = '/user-onboarding-screen';
  static const String twoFactorAuthenticationScreen = '/two-factor-authentication-screen';
  static const String linkInBioTemplatesScreen = '/link-in-bio-templates-screen';
  static const String advancedCrmManagementHub = '/advanced-crm-management-hub';
  static const String socialMediaManagementScreen = '/social-media-management-screen';
  static const String socialMediaManagementHub = '/social-media-management-hub';
  static const String socialMediaManager = '/social-media-manager';
  static const String socialMediaScheduler = '/social-media-scheduler';
  static const String socialMediaSchedulerScreen = '/social-media-scheduler-screen';
  static const String socialMediaAnalyticsScreen = '/social-media-analytics-screen';
  static const String settingsScreen = '/settings-screen';
  static const String settingsAccountManagement = '/settings-account-management';
  static const String accountSettingsScreen = '/account-settings-screen';
  static const String profileSettingsScreen = '/profile-settings-screen';
  static const String notificationSettingsScreen = '/notification-settings-screen';
  static const String securitySettingsScreen = '/security-settings-screen';
  static const String analyticsDashboard = '/analytics-dashboard';
  static const String linkInBioAnalyticsScreen = '/link-in-bio-analytics-screen';
  static const String unifiedSettingsScreen = '/unified-settings-screen';
  static const String hashtagResearchScreen = '/hashtag-research-screen';
  static const String instagramLeadSearch = '/instagram-lead-search';
  static const String multiPlatformPostingScreen = '/multi-platform-posting-screen';
  static const String contentTemplatesScreen = '/content-templates-screen';
  static const String contentCalendarScreen = '/content-calendar-screen';
  static const String qrCodeGeneratorScreen = '/qr-code-generator-screen';
  static const String emailMarketingCampaign = '/email-marketing-campaign';
  static const String crmContactManagement = '/crm-contact-management';
  static const String marketplaceStore = '/marketplace-store';
  static const String courseCreator = '/course-creator';
  static const String workspaceSettingsScreen = '/workspace-settings-screen';
  static const String roleBasedAccessControlScreen = '/role-based-access-control-screen';
  static const String usersTeamManagementScreen = '/users-team-management-screen';
  static const String teamMemberInvitationScreen = '/team-member-invitation-screen';
  static const String contactUsScreen = '/contact-us-screen';
  static const String appStoreOptimizationScreen = '/app-store-optimization-screen';
  static const String productionReleaseChecklistScreen = '/production-release-checklist-screen';
  static const String professionalReadmeDocumentationScreen = '/professional-readme-documentation-screen';
  static const String setupProgressScreen = '/setup-progress-screen';

  static Map<String, Widget Function(BuildContext)> get routes => {
    initial: (context) => const AuthGuard(child: SplashScreen()),
    splashScreen: (context) => const AuthGuard(child: SplashScreen()),
    onboardingScreen: (context) => const AuthGuard(child: UnifiedOnboardingScreen()),
    home: (context) => const AuthGuard(child: EnhancedWorkspaceDashboard()),
    linkInBio: (context) => const AuthGuard(child: LinkInBioTemplatesScreen()),
    forgotPassword: (context) => const ForgotPasswordScreen(),
    register: (context) => const EnhancedRegistrationScreen(),
    postingScreen: (context) => const AuthGuard(child: MultiPlatformPostingScreen()),
    scheduler: (context) => const AuthGuard(child: SocialMediaScheduler()),
    socialMediaAnalytics: (context) => const AuthGuard(child: SocialMediaAnalyticsScreen()),
    linkInBioAnalytics: (context) => const AuthGuard(child: LinkInBioAnalyticsScreen()),
    qrCodeGenerator: (context) => const AuthGuard(child: QrCodeGeneratorScreen()),
    goalSelectionScreen: (context) => const AuthGuard(child: GoalSelectionScreen()),
    goalBasedWorkspaceCreationScreen: (context) => const AuthGuard(child: GoalBasedWorkspaceCreationScreen()),
    postCreationTeamInvitationScreen: (context) => const AuthGuard(child: PostCreationTeamInvitationScreen()),
    workspaceCreationScreen: (context) => const AuthGuard(child: WorkspaceCreationScreen()),
    workspaceSelectorScreen: (context) => const AuthGuard(child: WorkspaceSelectorScreen()),
    workspaceDashboard: (context) => const AuthGuard(child: EnhancedWorkspaceDashboard()),
    enhancedWorkspaceDashboard: (context) => const AuthGuard(child: EnhancedWorkspaceDashboard()),
    enhancedRegistrationScreen: (context) => const EnhancedRegistrationScreen(),
    goalCustomizedWorkspaceDashboard: (context) => const AuthGuard(child: GoalCustomizedWorkspaceDashboard()),
    premiumSocialMediaHub: (context) => const AuthGuard(child: PremiumSocialMediaHub()),
    loginScreen: (context) => const LoginScreen(),
    registerScreen: (context) => const EnhancedRegistrationScreen(),
    termsOfServiceScreen: (context) => const TermsOfServiceScreen(),
    privacyPolicyScreen: (context) => const PrivacyPolicyScreen(),
    forgotPasswordScreen: (context) => const ForgotPasswordScreen(),
    resetPasswordScreen: (context) => const ResetPasswordScreen(),
    emailVerificationScreen: (context) => const EmailVerificationScreen(),
    twoFactorAuthenticationScreen: (context) => const TwoFactorAuthenticationScreen(),
    linkInBioTemplatesScreen: (context) => const AuthGuard(child: LinkInBioTemplatesScreen()),
    advancedCrmManagementHub: (context) => const AuthGuard(child: AdvancedCrmManagementHub()),
    socialMediaManagementScreen: (context) => const AuthGuard(child: SocialMediaManagementScreen()),
    socialMediaManagementHub: (context) => const AuthGuard(child: SocialMediaManagementHub()),
    socialMediaManager: (context) => const AuthGuard(child: SocialMediaManager()),
    socialMediaScheduler: (context) => const AuthGuard(child: SocialMediaScheduler()),
    socialMediaSchedulerScreen: (context) => const AuthGuard(child: SocialMediaSchedulerScreen()),
    socialMediaAnalyticsScreen: (context) => const AuthGuard(child: SocialMediaAnalyticsScreen()),
    settingsScreen: (context) => const AuthGuard(child: SettingsScreen()),
    settingsAccountManagement: (context) => const AuthGuard(child: SettingsAccountManagement()),
    accountSettingsScreen: (context) => const AuthGuard(child: AccountSettingsScreen()),
    profileSettingsScreen: (context) => const AuthGuard(child: ProfileSettingsScreen()),
    notificationSettingsScreen: (context) => const AuthGuard(child: NotificationSettingsScreen()),
    securitySettingsScreen: (context) => const AuthGuard(child: SecuritySettingsScreen()),
    analyticsDashboard: (context) => const AuthGuard(child: AnalyticsDashboard()),
    linkInBioAnalyticsScreen: (context) => const AuthGuard(child: LinkInBioAnalyticsScreen()),
    unifiedSettingsScreen: (context) => const AuthGuard(child: UnifiedSettingsScreen()),
    hashtagResearchScreen: (context) => const AuthGuard(child: HashtagResearchScreen()),
    instagramLeadSearch: (context) => const AuthGuard(child: InstagramLeadSearch()),
    multiPlatformPostingScreen: (context) => const AuthGuard(child: MultiPlatformPostingScreen()),
    contentTemplatesScreen: (context) => const AuthGuard(child: ContentTemplatesScreen()),
    contentCalendarScreen: (context) => const AuthGuard(child: ContentCalendarScreen()),
    qrCodeGeneratorScreen: (context) => const AuthGuard(child: QrCodeGeneratorScreen()),
    emailMarketingCampaign: (context) => const AuthGuard(child: EmailMarketingCampaign()),
    crmContactManagement: (context) => const AuthGuard(child: CrmContactManagement()),
    marketplaceStore: (context) => const AuthGuard(child: MarketplaceStore()),
    courseCreator: (context) => const AuthGuard(child: CourseCreator()),
    workspaceSettingsScreen: (context) => const AuthGuard(child: WorkspaceSettingsScreen()),
    roleBasedAccessControlScreen: (context) => const AuthGuard(child: RoleBasedAccessControlScreen()),
    usersTeamManagementScreen: (context) => const AuthGuard(child: UsersTeamManagementScreen()),
    teamMemberInvitationScreen: (context) => const AuthGuard(child: TeamMemberInvitationScreen()),
    contactUsScreen: (context) => const AuthGuard(child: ContactUsScreen()),
    appStoreOptimizationScreen: (context) => const AuthGuard(child: AppStoreOptimizationScreen()),
    productionReleaseChecklistScreen: (context) => const AuthGuard(child: ProductionReleaseChecklistScreen()),
    professionalReadmeDocumentationScreen: (context) => const AuthGuard(child: ProfessionalReadmeDocumentationScreen()),
    setupProgressScreen: (context) => const AuthGuard(child: SetupProgressScreen()),
    
    // Legacy and alternative routes for backward compatibility
    '/social-media-management-hub': (context) => const AuthGuard(child: SocialMediaManagementHub()),
    '/social-media-manager-screen': (context) => const AuthGuard(child: SocialMediaManager()),
    '/analytics-hub': (context) => const AuthGuard(child: UnifiedAnalyticsScreen()),
    '/profile-settings': (context) => const AuthGuard(child: ProfileSettingsScreen()),
    '/account-settings': (context) => const AuthGuard(child: AccountSettingsScreen()),
    '/notification-settings': (context) => const AuthGuard(child: NotificationSettingsScreen()),
    '/security-settings': (context) => const AuthGuard(child: SecuritySettingsScreen()),
    '/setup-progress': (context) => const AuthGuard(child: SetupProgressScreen()),
    '/content-scheduler': (context) => const AuthGuard(child: SocialMediaScheduler()),
    '/unified-settings': (context) => const AuthGuard(child: UnifiedSettingsScreen()),
    '/goal-customized-workspace-dashboard': (context) => const AuthGuard(child: GoalCustomizedWorkspaceDashboard()),
  };
}