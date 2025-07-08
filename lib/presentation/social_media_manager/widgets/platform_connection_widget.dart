import 'package:flutter/material.dart';

import '../../../core/app_export.dart';

class PlatformConnectionWidget extends StatelessWidget {
  const PlatformConnectionWidget({Key? key}) : super(key: key);

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
                Icons.connect_without_contact_rounded,
                color: AppTheme.accent,
                size: 20,
              ),
              SizedBox(width: 8.w),
              Text(
                'Connected Platforms',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const Spacer(),
              PopupMenuButton<String>(
                icon: Icon(
                  Icons.more_vert_rounded,
                  color: AppTheme.secondaryText,
                ),
                color: AppTheme.surface,
                onSelected: (value) {
                  // Handle platform actions
                },
                itemBuilder: (context) => [
                  PopupMenuItem(
                    value: 'add',
                    child: Row(
                      children: [
                        Icon(Icons.add_rounded, color: AppTheme.primaryText),
                        SizedBox(width: 12.w),
                        Text('Add Platform'),
                      ],
                    ),
                  ),
                  PopupMenuItem(
                    value: 'manage',
                    child: Row(
                      children: [
                        Icon(Icons.settings_rounded,
                            color: AppTheme.primaryText),
                        SizedBox(width: 12.w),
                        Text('Manage Connections'),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
          SizedBox(height: 16.h),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _buildPlatformChip('Instagram', Icons.camera_alt_rounded, true),
                SizedBox(width: 12.w),
                _buildPlatformChip('Facebook', Icons.facebook_rounded, true),
                SizedBox(width: 12.w),
                _buildPlatformChip(
                    'Twitter', Icons.alternate_email_rounded, false),
                SizedBox(width: 12.w),
                _buildPlatformChip('LinkedIn', Icons.work_rounded, true),
                SizedBox(width: 12.w),
                _buildPlatformChip('TikTok', Icons.music_video_rounded, false),
                SizedBox(width: 12.w),
                _buildPlatformChip(
                    'YouTube', Icons.play_circle_outline_rounded, false),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPlatformChip(String platform, IconData icon, bool isConnected) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: isConnected
            ? AppTheme.accent.withAlpha(26)
            : AppTheme.primaryBackground,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isConnected ? AppTheme.accent : AppTheme.border,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 16,
            color: isConnected ? AppTheme.accent : AppTheme.secondaryText,
          ),
          SizedBox(width: 6.w),
          Text(
            platform,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: isConnected ? AppTheme.accent : AppTheme.secondaryText,
            ),
          ),
          if (isConnected) ...[
            SizedBox(width: 4.w),
            Container(
              width: 6,
              height: 6,
              decoration: const BoxDecoration(
                color: AppTheme.success,
                shape: BoxShape.circle,
              ),
            ),
          ],
        ],
      ),
    );
  }
}