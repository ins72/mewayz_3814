import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class InstagramAccountCardWidget extends StatelessWidget {
  final Map<String, dynamic> account;
  final VoidCallback onExport;
  final VoidCallback onSave;
  final VoidCallback onMessage;
  final VoidCallback onLongPress;

  const InstagramAccountCardWidget({
    Key? key,
    required this.account,
    required this.onExport,
    required this.onSave,
    required this.onMessage,
    required this.onLongPress,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onLongPress: onLongPress,
      child: Container(
        margin: EdgeInsets.only(bottom: 2.h),
        padding: EdgeInsets.all(4.w),
        decoration: BoxDecoration(
          color: AppTheme.surface,
          borderRadius: BorderRadius.circular(3.w),
          border: Border.all(color: AppTheme.border.withValues(alpha: 0.3)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildProfileHeader(),
            SizedBox(height: 2.h),
            _buildStats(),
            SizedBox(height: 2.h),
            _buildBio(),
            SizedBox(height: 3.h),
            _buildActionButtons(),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileHeader() {
    return Row(
      children: [
        Container(
          width: 15.w,
          height: 15.w,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: AppTheme.accent.withValues(alpha: 0.3),
              width: 2,
            ),
          ),
          child: ClipOval(
            child: CustomImageWidget(
              imageUrl: account['profileImage'] ?? '',
              width: 15.w,
              height: 15.w,
              fit: BoxFit.cover,
            ),
          ),
        ),
        SizedBox(width: 3.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Flexible(
                    child: Text(
                      '@${account['username'] ?? ''}',
                      style: AppTheme.darkTheme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  if (account['isVerified'] == true) ...[
                    SizedBox(width: 1.w),
                    CustomIconWidget(
                      iconName: 'verified',
                      color: AppTheme.accent,
                      size: 4.w,
                    ),
                  ],
                ],
              ),
              SizedBox(height: 0.5.h),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.5.h),
                decoration: BoxDecoration(
                  color: AppTheme.accent.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(1.w),
                ),
                child: Text(
                  account['accountType'] ?? 'Personal',
                  style: AppTheme.darkTheme.textTheme.labelSmall?.copyWith(
                    color: AppTheme.accent,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ),
        if (account['location'] != null)
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              CustomIconWidget(
                iconName: 'location_on',
                color: AppTheme.secondaryText,
                size: 4.w,
              ),
              SizedBox(height: 0.5.h),
              Text(
                account['location'],
                style: AppTheme.darkTheme.textTheme.labelSmall?.copyWith(
                  color: AppTheme.secondaryText,
                ),
                textAlign: TextAlign.end,
              ),
            ],
          ),
      ],
    );
  }

  Widget _buildStats() {
    return Row(
      children: [
        _buildStatItem(
          'Followers',
          _formatNumber(account['followerCount'] ?? 0),
          AppTheme.primaryText,
        ),
        SizedBox(width: 6.w),
        _buildStatItem(
          'Following',
          _formatNumber(account['followingCount'] ?? 0),
          AppTheme.secondaryText,
        ),
        SizedBox(width: 6.w),
        _buildStatItem(
          'Posts',
          _formatNumber(account['postsCount'] ?? 0),
          AppTheme.secondaryText,
        ),
        Spacer(),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
          decoration: BoxDecoration(
            color: _getEngagementColor().withValues(alpha: 0.2),
            borderRadius: BorderRadius.circular(2.w),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              CustomIconWidget(
                iconName: 'trending_up',
                color: _getEngagementColor(),
                size: 4.w,
              ),
              SizedBox(width: 1.w),
              Text(
                '${account['engagementRate']?.toStringAsFixed(1) ?? '0.0'}%',
                style: AppTheme.darkTheme.textTheme.labelMedium?.copyWith(
                  color: _getEngagementColor(),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildStatItem(String label, String value, Color color) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          value,
          style: AppTheme.darkTheme.textTheme.titleSmall?.copyWith(
            color: color,
            fontWeight: FontWeight.w600,
          ),
        ),
        Text(
          label,
          style: AppTheme.darkTheme.textTheme.labelSmall?.copyWith(
            color: AppTheme.secondaryText,
          ),
        ),
      ],
    );
  }

  Widget _buildBio() {
    return Text(
      account['bio'] ?? '',
      style: AppTheme.darkTheme.textTheme.bodyMedium,
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
    );
  }

  Widget _buildActionButtons() {
    return Row(
      children: [
        Expanded(
          child: _buildActionButton(
            'Export',
            'file_download',
            onExport,
          ),
        ),
        SizedBox(width: 3.w),
        Expanded(
          child: _buildActionButton(
            'Save',
            'bookmark_border',
            onSave,
          ),
        ),
        SizedBox(width: 3.w),
        Expanded(
          child: _buildActionButton(
            'Message',
            'message',
            onMessage,
          ),
        ),
      ],
    );
  }

  Widget _buildActionButton(String label, String iconName, VoidCallback onTap) {
    return GestureDetector(
      onTap: () {
        HapticFeedback.selectionClick();
        onTap();
      },
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 2.h),
        decoration: BoxDecoration(
          color: AppTheme.surface,
          borderRadius: BorderRadius.circular(2.w),
          border: Border.all(color: AppTheme.border),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CustomIconWidget(
              iconName: iconName,
              color: AppTheme.primaryText,
              size: 4.w,
            ),
            SizedBox(width: 2.w),
            Text(
              label,
              style: AppTheme.darkTheme.textTheme.labelMedium?.copyWith(
                color: AppTheme.primaryText,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatNumber(int number) {
    if (number >= 1000000) {
      return '${(number / 1000000).toStringAsFixed(1)}M';
    } else if (number >= 1000) {
      return '${(number / 1000).toStringAsFixed(1)}K';
    }
    return number.toString();
  }

  Color _getEngagementColor() {
    double rate = account['engagementRate']?.toDouble() ?? 0.0;
    if (rate >= 6.0) return AppTheme.success;
    if (rate >= 3.0) return AppTheme.warning;
    return AppTheme.error;
  }
}
