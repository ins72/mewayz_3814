import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class PlatformStatusWidget extends StatelessWidget {
  final Map<String, Map<String, dynamic>> platformStatus;
  final Function(String) onToggleConnection;

  const PlatformStatusWidget({
    Key? key,
    required this.platformStatus,
    required this.onToggleConnection,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      scrollDirection: Axis.horizontal,
      padding: EdgeInsets.symmetric(horizontal: 4.w),
      itemCount: platformStatus.length,
      itemBuilder: (context, index) {
        final platform = platformStatus.keys.elementAt(index);
        final status = platformStatus[platform]!;

        return Container(
          width: 40.w,
          margin: EdgeInsets.only(right: 3.w),
          padding: EdgeInsets.all(3.w),
          decoration: BoxDecoration(
            color: AppTheme.primaryBackground,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: status['connected']
                  ? _getPlatformColor(platform)
                  : AppTheme.border,
              width: 1,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 8.w,
                    height: 8.w,
                    decoration: BoxDecoration(
                      color: _getPlatformColor(platform),
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: CustomIconWidget(
                        iconName: _getPlatformIcon(platform),
                        color: AppTheme.primaryAction,
                        size: 16,
                      ),
                    ),
                  ),
                  const Spacer(),
                  Switch(
                    value: status['connected'],
                    onChanged: (_) => onToggleConnection(platform),
                    activeColor: _getPlatformColor(platform),
                  ),
                ],
              ),
              SizedBox(height: 1.h),
              Text(
                platform.toUpperCase(),
                style: AppTheme.darkTheme.textTheme.labelMedium?.copyWith(
                  color: _getPlatformColor(platform),
                  fontWeight: FontWeight.w600,
                ),
              ),
              if (status['connected'] && status['account'] != null) ...[
                SizedBox(height: 0.5.h),
                Text(
                  status['account'],
                  style: AppTheme.darkTheme.textTheme.bodySmall,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ] else if (!status['connected']) ...[
                SizedBox(height: 0.5.h),
                Text(
                  'Not connected',
                  style: AppTheme.darkTheme.textTheme.bodySmall?.copyWith(
                    color: AppTheme.secondaryText,
                  ),
                ),
              ],
            ],
          ),
        );
      },
    );
  }

  Color _getPlatformColor(String platform) {
    switch (platform) {
      case 'instagram':
        return const Color(0xFFE4405F);
      case 'facebook':
        return const Color(0xFF1877F2);
      case 'twitter':
        return const Color(0xFF1DA1F2);
      case 'linkedin':
        return const Color(0xFF0A66C2);
      case 'tiktok':
        return const Color(0xFF000000);
      case 'youtube':
        return const Color(0xFFFF0000);
      default:
        return AppTheme.accent;
    }
  }

  String _getPlatformIcon(String platform) {
    switch (platform) {
      case 'instagram':
        return 'camera_alt';
      case 'facebook':
        return 'facebook';
      case 'twitter':
        return 'alternate_email';
      case 'linkedin':
        return 'business';
      case 'tiktok':
        return 'music_note';
      case 'youtube':
        return 'play_circle_filled';
      default:
        return 'public';
    }
  }
}
