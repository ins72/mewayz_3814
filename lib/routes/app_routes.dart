import 'package:flutter/material.dart';
import '../presentation/splash_screen/splash_screen.dart';
import '../presentation/workspace_dashboard/workspace_dashboard.dart';
import '../presentation/login_screen/login_screen.dart';
import '../presentation/register_screen/register_screen.dart';
import '../presentation/forgot_password_screen/forgot_password_screen.dart';
import '../presentation/reset_password_screen/reset_password_screen.dart';
import '../presentation/email_verification_screen/email_verification_screen.dart';
import '../presentation/two_factor_authentication_screen/two_factor_authentication_screen.dart';
import '../presentation/user_onboarding_screen/user_onboarding_screen.dart';
import '../presentation/instagram_lead_search/instagram_lead_search.dart';
import '../presentation/social_media_scheduler/social_media_scheduler.dart';
import '../presentation/marketplace_store/marketplace_store.dart';
import '../presentation/course_creator/course_creator.dart';
import '../presentation/analytics_dashboard/analytics_dashboard.dart';
import '../presentation/crm_contact_management/crm_contact_management.dart';

class AppRoutes {
  // TODO: Add your routes here
  static const String initial = '/';
  static const String splashScreen = '/splash-screen';
  static const String workspaceDashboard = '/workspace-dashboard';
  static const String loginScreen = '/login-screen';
  static const String registerScreen = '/register-screen';
  static const String forgotPasswordScreen = '/forgot-password-screen';
  static const String resetPasswordScreen = '/reset-password-screen';
  static const String emailVerificationScreen = '/email-verification-screen';
  static const String twoFactorAuthenticationScreen =
      '/two-factor-authentication-screen';
  static const String userOnboardingScreen = '/user-onboarding-screen';
  static const String instagramLeadSearch = '/instagram-lead-search';
  static const String linkInBioBuilder = '/link-in-bio-builder';
  static const String socialMediaScheduler = '/social-media-scheduler';
  static const String marketplaceStore = '/marketplace-store';
  static const String courseCreator = '/course-creator';
  static const String analyticsDashboard = '/analytics-dashboard';
  static const String crmContactManagement = '/crm-contact-management';

  static Map<String, WidgetBuilder> routes = {
    initial: (context) => const SplashScreen(),
    splashScreen: (context) => const SplashScreen(),
    workspaceDashboard: (context) => const WorkspaceDashboard(),
    loginScreen: (context) => const LoginScreen(),
    registerScreen: (context) => const RegisterScreen(),
    forgotPasswordScreen: (context) => const ForgotPasswordScreen(),
    resetPasswordScreen: (context) => const ResetPasswordScreen(),
    emailVerificationScreen: (context) => const EmailVerificationScreen(),
    twoFactorAuthenticationScreen: (context) =>
        const TwoFactorAuthenticationScreen(),
    userOnboardingScreen: (context) => const UserOnboardingScreen(),
    instagramLeadSearch: (context) => const InstagramLeadSearch(),
    socialMediaScheduler: (context) => const SocialMediaScheduler(),
    marketplaceStore: (context) => const MarketplaceStore(),
    courseCreator: (context) => const CourseCreator(),
    analyticsDashboard: (context) => const AnalyticsDashboard(),
    crmContactManagement: (context) => const CrmContactManagement(),
    // TODO: Add your other routes here
  };
}
