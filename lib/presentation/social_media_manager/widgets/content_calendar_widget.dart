import 'package:flutter/material.dart';

import '../../../core/app_export.dart';

class ContentCalendarWidget extends StatelessWidget {
  const ContentCalendarWidget({Key? key}) : super(key: key);

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
                Icons.calendar_today_rounded,
                color: AppTheme.accent,
                size: 20,
              ),
              SizedBox(width: 8.w),
              Text(
                'Content Calendar',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const Spacer(),
              TextButton(
                onPressed: () => Navigator.pushNamed(
                    context, AppRoutes.socialMediaScheduler),
                child: Text(
                  'View Calendar',
                  style: TextStyle(
                    color: AppTheme.accent,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 16.h),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _buildScheduledPost(
                  'Instagram Post',
                  'Today, 2:00 PM',
                  'Marketing campaign launch',
                  Icons.camera_alt_rounded,
                  AppTheme.accent,
                ),
                SizedBox(width: 12.w),
                _buildScheduledPost(
                  'Facebook Story',
                  'Today, 6:00 PM',
                  'Behind the scenes content',
                  Icons.facebook_rounded,
                  AppTheme.accent,
                ),
                SizedBox(width: 12.w),
                _buildScheduledPost(
                  'LinkedIn Article',
                  'Tomorrow, 9:00 AM',
                  'Industry insights post',
                  Icons.work_rounded,
                  AppTheme.warning,
                ),
              ],
            ),
          ),
          SizedBox(height: 16.h),
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () => Navigator.pushNamed(
                      context, AppRoutes.socialMediaScheduler),
                  icon: const Icon(Icons.schedule_rounded),
                  label: const Text('Schedule Post'),
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () {
                    // Quick post
                  },
                  icon: const Icon(Icons.add_rounded),
                  label: const Text('Quick Post'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildScheduledPost(
    String platform,
    String time,
    String content,
    IconData icon,
    Color color,
  ) {
    return Container(
      width: 200.w,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppTheme.primaryBackground,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppTheme.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: color.withAlpha(26),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Icon(
                  icon,
                  size: 14,
                  color: color,
                ),
              ),
              SizedBox(width: 8.w),
              Expanded(
                child: Text(
                  platform,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: AppTheme.primaryText,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 8.h),
          Text(
            time,
            style: TextStyle(
              fontSize: 11,
              color: AppTheme.secondaryText,
            ),
          ),
          SizedBox(height: 6.h),
          Text(
            content,
            style: TextStyle(
              fontSize: 12,
              color: AppTheme.primaryText,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}