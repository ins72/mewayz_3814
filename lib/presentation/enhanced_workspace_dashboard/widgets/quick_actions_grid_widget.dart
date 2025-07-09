import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../routes/app_routes.dart';

class QuickActionsGridWidget extends StatelessWidget {
  const QuickActionsGridWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final actions = [
      {
        'title': 'Instagram Search',
        'icon': Icons.search,
        'color': const Color(0xFFE1306C),
        'route': AppRoutes.instagramLeadSearch,
      },
      {
        'title': 'Post Scheduler',
        'icon': Icons.schedule,
        'color': const Color(0xFF007AFF),
        'route': AppRoutes.socialMediaScheduler,
      },
      {
        'title': 'Link Builder',
        'icon': Icons.link,
        'color': const Color(0xFF34C759),
        'route': AppRoutes.linkInBioTemplatesScreen,
      },
      {
        'title': 'Course Creator',
        'icon': Icons.school,
        'color': const Color(0xFFFF9500),
        'route': AppRoutes.courseCreator,
      },
      {
        'title': 'Store Manager',
        'icon': Icons.store,
        'color': const Color(0xFF5856D6),
        'route': AppRoutes.marketplaceStore,
      },
      {
        'title': 'CRM Hub',
        'icon': Icons.contacts,
        'color': const Color(0xFFFF3B30),
        'route': AppRoutes.crmContactManagement,
      },
      {
        'title': 'Email Marketing',
        'icon': Icons.email,
        'color': const Color(0xFF32D74B),
        'route': AppRoutes.emailMarketingCampaign,
      },
      {
        'title': 'Content Calendar',
        'icon': Icons.calendar_today,
        'color': const Color(0xFFFF2D92),
        'route': AppRoutes.contentCalendarScreen,
      },
      {
        'title': 'QR Generator',
        'icon': Icons.qr_code,
        'color': const Color(0xFF8E8E93),
        'route': AppRoutes.qrCodeGeneratorScreen,
      },
      {
        'title': 'Analytics',
        'icon': Icons.analytics,
        'color': const Color(0xFF007AFF),
        'route': AppRoutes.analyticsDashboard,
      },
      {
        'title': 'App Store Prep',
        'icon': Icons.mobile_friendly,
        'color': const Color(0xFFFF9500),
        'route': AppRoutes.appStoreOptimizationScreen,
      },
      {
        'title': 'Production Checklist',
        'icon': Icons.checklist,
        'color': const Color(0xFF34C759),
        'route': AppRoutes.productionReleaseChecklistScreen,
      },
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: 1.0,
      ),
      itemCount: actions.length,
      itemBuilder: (context, index) {
        final action = actions[index];
        return _buildActionCard(
          context,
          title: action['title'] as String,
          icon: action['icon'] as IconData,
          color: action['color'] as Color,
          route: action['route'] as String,
        );
      },
    );
  }

  Widget _buildActionCard(
    BuildContext context, {
    required String title,
    required IconData icon,
    required Color color,
    required String route,
  }) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, route);
      },
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFF191919),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: const Color(0xFF2C2C2E),
            width: 1,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: color.withAlpha(26),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                icon,
                color: color,
                size: 24,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              title,
              textAlign: TextAlign.center,
              style: GoogleFonts.inter(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}