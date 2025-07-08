import 'package:flutter/material.dart';

import '../../../core/app_export.dart';

class QuickActionsGridWidget extends StatelessWidget {
  const QuickActionsGridWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              Icons.flash_on_rounded,
              color: AppTheme.accent,
              size: 20,
            ),
            SizedBox(width: 8.w),
            Text(
              'Quick Actions',
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ],
        ),
        SizedBox(height: 16.h),
        GridView.count(
          crossAxisCount: 2,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          childAspectRatio: 1.3,
          children: [
            _buildActionCard(
              'Instagram Lead Search',
              Icons.search_rounded,
              AppTheme.accent,
              () => Navigator.pushNamed(context, AppRoutes.instagramLeadSearch),
            ),
            _buildActionCard(
              'Content Scheduler',
              Icons.schedule_send_rounded,
              AppTheme.success,
              () =>
                  Navigator.pushNamed(context, AppRoutes.socialMediaScheduler),
            ),
            _buildActionCard(
              'Post Creator',
              Icons.create_rounded,
              AppTheme.warning,
              () {
                // Navigate to post creator
              },
            ),
            _buildActionCard(
              'Hashtag Research',
              Icons.tag_rounded,
              AppTheme.accent,
              () {
                // Navigate to hashtag research
              },
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildActionCard(
    String title,
    IconData icon,
    Color color,
    VoidCallback onTap,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppTheme.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppTheme.border),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: color.withAlpha(26),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                icon,
                size: 24,
                color: color,
              ),
            ),
            SizedBox(height: 12.h),
            Text(
              title,
              style: TextStyle(
                fontWeight: FontWeight.w500,
                color: AppTheme.primaryText,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}