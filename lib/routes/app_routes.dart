import 'package:flutter/material.dart';

import '../presentation/enhanced_workspace_dashboard/enhanced_workspace_dashboard.dart';
import '../presentation/premium_social_media_hub/premium_social_media_hub.dart';

class AppRoutes {
  // Main screens - Only two screens preserved
  static const String home = '/enhanced-workspace-dashboard';
  static const String enhancedWorkspaceDashboard = '/enhanced-workspace-dashboard';
  static const String premiumSocialMediaHub = '/premium-social-media-hub';

  // Route map - Only two screens preserved
  static Map<String, WidgetBuilder> get routes => {
    home: (context) => const EnhancedWorkspaceDashboard(),
    enhancedWorkspaceDashboard: (context) => const EnhancedWorkspaceDashboard(),
    premiumSocialMediaHub: (context) => const PremiumSocialMediaHub(),
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
    
    // If route doesn't exist, redirect to home
    return MaterialPageRoute(
      builder: (context) => const EnhancedWorkspaceDashboard(),
      settings: settings,
    );
  }
}