import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class QuickActionsGridWidget extends StatelessWidget {
  const QuickActionsGridWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final actions = [
      {
        'title': 'Social Media',
        'icon': Icons.share,
        'route': '/premium-social-media-hub',
        'color': Colors.blue,
      },
      {
        'title': 'Content Calendar',
        'icon': Icons.calendar_today,
        'route': '/content-calendar',
        'color': Colors.green,
      },
      {
        'title': 'Analytics',
        'icon': Icons.analytics,
        'route': '/unified-analytics',
        'color': Colors.orange,
      },
      {
        'title': 'Team Management',
        'icon': Icons.people,
        'route': '/users-team-management',
        'color': Colors.purple,
      },
      {
        'title': 'Settings',
        'icon': Icons.settings,
        'route': '/settings',
        'color': Colors.grey,
      },
      {
        'title': 'Link in Bio',
        'icon': Icons.link,
        'route': '/link-in-bio-templates',
        'color': Colors.pink,
      },
      {
        'title': 'Templates',
        'icon': Icons.design_services,
        'route': '/content-templates',
        'color': Colors.cyan,
      },
      {
        'title': 'QR Generator',
        'icon': Icons.qr_code,
        'route': '/qr-code-generator',
        'color': Colors.indigo,
      },
      {
        'title': 'Advanced CRM',
        'icon': Icons.contacts,
        'route': '/advanced-crm-management-hub',
        'color': Colors.teal,
      },
      {
        'title': 'Email Marketing',
        'icon': Icons.email,
        'route': '/email-marketing-campaign',
        'color': Colors.amber,
      },
      {
        'title': 'Marketplace',
        'icon': Icons.store,
        'route': '/marketplace-store',
        'color': Colors.brown,
      },
      {
        'title': 'Course Creator',
        'icon': Icons.school,
        'route': '/course-creator',
        'color': Colors.deepOrange,
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