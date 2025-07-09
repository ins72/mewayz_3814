import 'package:flutter/material.dart';
import '../presentation/account_settings_screen/account_settings_screen.dart';
import '../presentation/analytics_dashboard/analytics_dashboard.dart';
import '../presentation/app_store_optimization_screen/app_store_optimization_screen.dart';
import '../presentation/contact_us_screen/contact_us_screen.dart';
import '../presentation/content_calendar_screen/content_calendar_screen.dart';
import '../presentation/content_templates_screen/content_templates_screen.dart';
import '../presentation/course_creator/course_creator.dart';
import '../presentation/crm_contact_management/crm_contact_management.dart';
import '../presentation/email_marketing_campaign/email_marketing_campaign.dart';
import '../presentation/email_verification_screen/email_verification_screen.dart';
import '../presentation/forgot_password_screen/forgot_password_screen.dart';
import '../presentation/goal_selection_screen/goal_selection_screen.dart';
import '../presentation/hashtag_research_screen/hashtag_research_screen.dart';
import '../presentation/instagram_lead_search/instagram_lead_search.dart';
import '../presentation/link_in_bio_analytics_screen/link_in_bio_analytics_screen.dart';
import '../presentation/link_in_bio_templates_screen/link_in_bio_templates_screen.dart';
import '../presentation/login_screen/login_screen.dart';
import '../presentation/marketplace_store/marketplace_store.dart';
import '../presentation/multi_platform_posting_screen/multi_platform_posting_screen.dart';
import '../presentation/notification_settings_screen/notification_settings_screen.dart';
import '../presentation/production_release_checklist_screen/production_release_checklist_screen.dart';
import '../presentation/professional_readme_documentation_screen/professional_readme_documentation_screen.dart';
import '../presentation/profile_settings_screen/profile_settings_screen.dart';
import '../presentation/qr_code_generator_screen/qr_code_generator_screen.dart';
import '../presentation/register_screen/register_screen.dart';
import '../presentation/reset_password_screen/reset_password_screen.dart';
import '../presentation/role_based_access_control_screen/role_based_access_control_screen.dart';
import '../presentation/security_settings_screen/security_settings_screen.dart';
import '../presentation/settings_screen/settings_screen.dart';
import '../presentation/setup_progress_screen/setup_progress_screen.dart';
import '../presentation/social_media_analytics_screen/social_media_analytics_screen.dart';
import '../presentation/social_media_manager/social_media_manager.dart';
import '../presentation/social_media_scheduler/social_media_scheduler.dart';
import '../presentation/social_media_scheduler_screen/social_media_scheduler_screen.dart';
import '../presentation/splash_screen/splash_screen.dart';
import '../presentation/team_member_invitation_screen/team_member_invitation_screen.dart';
import '../presentation/two_factor_authentication_screen/two_factor_authentication_screen.dart';
import '../presentation/user_onboarding_screen/user_onboarding_screen.dart';
import '../presentation/users_team_management_screen/users_team_management_screen.dart';
import '../presentation/workspace_creation_screen/workspace_creation_screen.dart';
import '../presentation/workspace_dashboard/workspace_dashboard.dart';
import '../presentation/workspace_selector_screen/workspace_selector_screen.dart';
import '../presentation/workspace_settings_screen/workspace_settings_screen.dart';

class AppRoutes {
  static const String initial = '/';
  static const String splashScreen = '/splash-screen';
  static const String userOnboardingScreen = '/user-onboarding-screen';
  static const String goalSelectionScreen = '/goal-selection-screen';
  static const String workspaceCreationScreen = '/workspace-creation-screen';
  static const String workspaceSelectorScreen = '/workspace-selector-screen';
  static const String workspaceDashboard = '/workspace-dashboard';
  static const String setupProgressScreen = '/setup-progress-screen';
  static const String loginScreen = '/login-screen';
  static const String registerScreen = '/register-screen';
  static const String forgotPasswordScreen = '/forgot-password-screen';
  static const String resetPasswordScreen = '/reset-password-screen';
  static const String emailVerificationScreen = '/email-verification-screen';
  static const String twoFactorAuthenticationScreen = '/two-factor-authentication-screen';
  static const String linkInBioTemplatesScreen = '/link-in-bio-templates-screen';
  static const String linkInBioBuilder = '/link-in-bio-builder';
  static const String linkInBioAnalyticsScreen = '/link-in-bio-analytics-screen';
  static const String socialMediaManagerScreen = '/social-media-manager-screen';
  static const String socialMediaSchedulerScreen = '/social-media-scheduler-screen';
  static const String socialMediaScheduler = '/social-media-scheduler';
  static const String socialMediaAnalyticsScreen = '/social-media-analytics-screen';
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
  static const String analyticsScreen = '/analytics-screen';
  static const String analyticsDetailsScreen = '/analytics-details-screen';
  static const String analyticsReportScreen = '/analytics-report-screen';
  static const String analyticsExportScreen = '/analytics-export-screen';
  static const String settingsScreen = '/settings-screen';
  static const String profileSettingsScreen = '/profile-settings-screen';
  static const String accountSettingsScreen = '/account-settings-screen';
  static const String notificationSettingsScreen = '/notification-settings-screen';
  static const String securitySettingsScreen = '/security-settings-screen';
  static const String workspaceSettingsScreen = '/workspace-settings-screen';
  static const String roleBasedAccessControlScreen = '/role-based-access-control-screen';
  static const String usersTeamManagementScreen = '/users-team-management-screen';
  static const String teamMemberInvitationScreen = '/team-member-invitation-screen';
  static const String contactUsScreen = '/contact-us-screen';
  static const String appStoreOptimizationScreen = '/app-store-optimization-screen';
  static const String productionReleaseChecklistScreen = '/production-release-checklist-screen';
  static const String professionalReadmeDocumentationScreen = '/professional-readme-documentation-screen';
  static const String analyticsDashboard = '/analytics-dashboard';

  static Map<String, Widget Function(BuildContext)> get routes => {
    initial: (context) => const SplashScreen(),
    splashScreen: (context) => const SplashScreen(),
    userOnboardingScreen: (context) => const UserOnboardingScreen(),
    goalSelectionScreen: (context) => const GoalSelectionScreen(),
    workspaceCreationScreen: (context) => const WorkspaceCreationScreen(),
    workspaceSelectorScreen: (context) => const WorkspaceSelectorScreen(),
    workspaceDashboard: (context) => const WorkspaceDashboard(),
    setupProgressScreen: (context) => const SetupProgressScreen(),
    loginScreen: (context) => const LoginScreen(),
    registerScreen: (context) => const RegisterScreen(),
    forgotPasswordScreen: (context) => const ForgotPasswordScreen(),
    resetPasswordScreen: (context) => const ResetPasswordScreen(),
    emailVerificationScreen: (context) => const EmailVerificationScreen(),
    twoFactorAuthenticationScreen: (context) => const TwoFactorAuthenticationScreen(),
    linkInBioTemplatesScreen: (context) => const LinkInBioTemplatesScreen(),    linkInBioAnalyticsScreen: (context) => const LinkInBioAnalyticsScreen(),
    socialMediaManagerScreen: (context) => const SocialMediaManager(),
    socialMediaSchedulerScreen: (context) => const SocialMediaSchedulerScreen(),
    socialMediaScheduler: (context) => const SocialMediaScheduler(),
    socialMediaAnalyticsScreen: (context) => const SocialMediaAnalyticsScreen(),
    hashtagResearchScreen: (context) => const HashtagResearchScreen(),
    instagramLeadSearch: (context) => const InstagramLeadSearch(),
    multiPlatformPostingScreen: (context) => const MultiPlatformPostingScreen(),
    contentTemplatesScreen: (context) => const ContentTemplatesScreen(),
    contentCalendarScreen: (context) => const ContentCalendarScreen(),
    qrCodeGeneratorScreen: (context) => const QrCodeGeneratorScreen(),
    emailMarketingCampaign: (context) => const EmailMarketingCampaign(),
    crmContactManagement: (context) => const CrmContactManagement(),
    marketplaceStore: (context) => const MarketplaceStore(),
    courseCreator: (context) => const CourseCreator(),
    analyticsScreen: (context) => const AnalyticsDashboard(),
    analyticsDetailsScreen: (context) => const AnalyticsDashboard(),
    analyticsReportScreen: (context) => const AnalyticsDashboard(),
    analyticsExportScreen: (context) => const AnalyticsDashboard(),
    settingsScreen: (context) => const SettingsScreen(),
    profileSettingsScreen: (context) => const ProfileSettingsScreen(),
    accountSettingsScreen: (context) => const AccountSettingsScreen(),
    notificationSettingsScreen: (context) => const NotificationSettingsScreen(),
    securitySettingsScreen: (context) => const SecuritySettingsScreen(),
    workspaceSettingsScreen: (context) => const WorkspaceSettingsScreen(),
    roleBasedAccessControlScreen: (context) => const RoleBasedAccessControlScreen(),
    usersTeamManagementScreen: (context) => const UsersTeamManagementScreen(),
    teamMemberInvitationScreen: (context) => const TeamMemberInvitationScreen(),
    contactUsScreen: (context) => const ContactUsScreen(),
    appStoreOptimizationScreen: (context) => const AppStoreOptimizationScreen(),
    productionReleaseChecklistScreen: (context) => const ProductionReleaseChecklistScreen(),
    professionalReadmeDocumentationScreen: (context) => const ProfessionalReadmeDocumentationScreen(),
    analyticsDashboard: (context) => const AnalyticsDashboard(),
  };
}