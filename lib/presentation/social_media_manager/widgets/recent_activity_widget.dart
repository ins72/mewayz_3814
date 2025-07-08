import 'package:flutter/material.dart';

import '../../../core/app_export.dart';

class RecentActivityWidget extends StatelessWidget {
  const RecentActivityWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppTheme.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.history_rounded,
                color: AppTheme.accent,
                size: 20,
              ),
              SizedBox(width: 8.w),
              Text(
                'Recent Activity',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const Spacer(),
              TextButton(
                onPressed: () {
                  // Navigate to full activity log
                },
                child: Text(
                  'View All',
                  style: TextStyle(
                    color: AppTheme.accent,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 16.h),
          Column(
            children: [
              _buildActivityItem(
                'New follower on Instagram',
                '@techinfluencer started following you',
                '2 minutes ago',
                Icons.person_add_rounded,
                AppTheme.success,
              ),
              SizedBox(height: 12.h),
              _buildActivityItem(
                'Post published successfully',
                'Your Instagram post went live',
                '15 minutes ago',
                Icons.check_circle_rounded,
                AppTheme.success,
              ),
              SizedBox(height: 12.h),
              _buildActivityItem(
                'New comment on Facebook',
                'Someone commented on your latest post',
                '1 hour ago',
                Icons.comment_rounded,
                AppTheme.accent,
              ),
              SizedBox(height: 12.h),
              _buildActivityItem(
                'Lead captured',
                'New lead from Instagram bio link',
                '2 hours ago',
                Icons.star_rounded,
                AppTheme.warning,
              ),
              SizedBox(height: 12.h),
              _buildActivityItem(
                'Engagement milestone',
                'Reached 1000 likes on latest post',
                '3 hours ago',
                Icons.favorite_rounded,
                AppTheme.error,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildActivityItem(
    String title,
    String subtitle,
    String time,
    IconData icon,
    Color color,
  ) {
    return Builder(
      builder: (context) => Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withAlpha(26),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              icon,
              size: 16,
              color: color,
            ),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w500,
                        color: AppTheme.primaryText,
                      ),
                ),
                SizedBox(height: 2.h),
                Text(
                  subtitle,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppTheme.secondaryText,
                      ),
                ),
              ],
            ),
          ),
          Text(
            time,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: AppTheme.secondaryText,
                ),
          ),
        ],
      ),
    );
  }
}