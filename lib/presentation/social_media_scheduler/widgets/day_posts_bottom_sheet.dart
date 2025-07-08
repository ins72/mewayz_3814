import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../core/app_export.dart';

class DayPostsBottomSheet extends StatelessWidget {
  final DateTime date;
  final List<Map<String, dynamic>> posts;
  final Function(String) onEditPost;
  final Function(String) onDeletePost;
  final Function(String) onRetryPost;

  const DayPostsBottomSheet({
    Key? key,
    required this.date,
    required this.posts,
    required this.onEditPost,
    required this.onDeletePost,
    required this.onRetryPost,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: posts.isEmpty ? 40.h : 70.h,
      decoration: BoxDecoration(
        color: AppTheme.surface,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: Column(
        children: [
          _buildHeader(),
          posts.isEmpty ? _buildEmptyState() : _buildPostsList(),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: AppTheme.border, width: 1),
        ),
      ),
      child: Column(
        children: [
          Container(
            width: 12.w,
            height: 0.5.h,
            decoration: BoxDecoration(
              color: AppTheme.secondaryText,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          SizedBox(height: 2.h),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _formatDate(date),
                      style: AppTheme.darkTheme.textTheme.titleMedium,
                    ),
                    Text(
                      '${posts.length} ${posts.length == 1 ? 'post' : 'posts'} scheduled',
                      style: AppTheme.darkTheme.textTheme.bodyMedium?.copyWith(
                        color: AppTheme.secondaryText,
                      ),
                    ),
                  ],
                ),
              ),
              if (posts.isNotEmpty)
                IconButton(
                  onPressed: () {
                    // Add new post for this date
                    HapticFeedback.lightImpact();
                  },
                  icon: CustomIconWidget(
                    iconName: 'add',
                    color: AppTheme.accent,
                    size: 24,
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Expanded(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CustomIconWidget(
              iconName: 'event_note',
              color: AppTheme.secondaryText,
              size: 48,
            ),
            SizedBox(height: 2.h),
            Text(
              'No posts scheduled',
              style: AppTheme.darkTheme.textTheme.titleMedium?.copyWith(
                color: AppTheme.secondaryText,
              ),
            ),
            SizedBox(height: 1.h),
            Text(
              'Tap the + button to add a post for this date',
              style: AppTheme.darkTheme.textTheme.bodyMedium?.copyWith(
                color: AppTheme.secondaryText,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPostsList() {
    return Expanded(
      child: ListView.builder(
        padding: EdgeInsets.all(4.w),
        itemCount: posts.length,
        itemBuilder: (context, index) {
          final post = posts[index];
          return Dismissible(
            key: Key(post['id']),
            background: _buildSwipeBackground(false),
            secondaryBackground: _buildSwipeBackground(true),
            onDismissed: (direction) {
              HapticFeedback.mediumImpact();
              if (direction == DismissDirection.endToStart) {
                onDeletePost(post['id']);
              } else {
                onEditPost(post['id']);
              }
            },
            child: _buildPostCard(post),
          );
        },
      ),
    );
  }

  Widget _buildSwipeBackground(bool isDelete) {
    return Container(
      margin: EdgeInsets.only(bottom: 2.h),
      decoration: BoxDecoration(
        color: isDelete ? AppTheme.error : AppTheme.accent,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Align(
        alignment: isDelete ? Alignment.centerRight : Alignment.centerLeft,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 4.w),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CustomIconWidget(
                iconName: isDelete ? 'delete' : 'edit',
                color: AppTheme.primaryAction,
                size: 24,
              ),
              SizedBox(height: 0.5.h),
              Text(
                isDelete ? 'Delete' : 'Edit',
                style: AppTheme.darkTheme.textTheme.labelMedium?.copyWith(
                  color: AppTheme.primaryAction,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPostCard(Map<String, dynamic> post) {
    final platformColor = _getPlatformColor(post['platform']);
    final statusColor = _getStatusColor(post['status']);

    return Container(
      margin: EdgeInsets.only(bottom: 2.h),
      decoration: BoxDecoration(
        color: AppTheme.primaryBackground,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppTheme.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Post header
          Container(
            padding: EdgeInsets.all(4.w),
            decoration: BoxDecoration(
              color: platformColor.withValues(alpha: 0.1),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(12),
                topRight: Radius.circular(12),
              ),
            ),
            child: Row(
              children: [
                Container(
                  width: 8.w,
                  height: 8.w,
                  decoration: BoxDecoration(
                    color: platformColor,
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: CustomIconWidget(
                      iconName: _getPlatformIcon(post['platform']),
                      color: AppTheme.primaryAction,
                      size: 16,
                    ),
                  ),
                ),
                SizedBox(width: 3.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        post['platform'].toString().toUpperCase(),
                        style:
                            AppTheme.darkTheme.textTheme.labelMedium?.copyWith(
                          color: platformColor,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        post['scheduledTime'],
                        style: AppTheme.darkTheme.textTheme.bodySmall,
                      ),
                    ],
                  ),
                ),
                Container(
                  padding:
                      EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.5.h),
                  decoration: BoxDecoration(
                    color: statusColor.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    post['status'].toString().toUpperCase(),
                    style: AppTheme.darkTheme.textTheme.labelSmall?.copyWith(
                      color: statusColor,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                SizedBox(width: 2.w),
                PopupMenuButton<String>(
                  icon: CustomIconWidget(
                    iconName: 'more_vert',
                    color: AppTheme.secondaryText,
                    size: 20,
                  ),
                  color: AppTheme.surface,
                  onSelected: (value) {
                    HapticFeedback.lightImpact();
                    switch (value) {
                      case 'edit':
                        onEditPost(post['id']);
                        break;
                      case 'duplicate':
                        // Handle duplicate
                        break;
                      case 'analytics':
                        // Handle analytics
                        break;
                      case 'delete':
                        onDeletePost(post['id']);
                        break;
                      case 'retry':
                        onRetryPost(post['id']);
                        break;
                    }
                  },
                  itemBuilder: (context) => [
                    PopupMenuItem(
                      value: 'edit',
                      child: Row(
                        children: [
                          CustomIconWidget(
                            iconName: 'edit',
                            color: AppTheme.primaryText,
                            size: 16,
                          ),
                          SizedBox(width: 2.w),
                          Text('Edit'),
                        ],
                      ),
                    ),
                    PopupMenuItem(
                      value: 'duplicate',
                      child: Row(
                        children: [
                          CustomIconWidget(
                            iconName: 'content_copy',
                            color: AppTheme.primaryText,
                            size: 16,
                          ),
                          SizedBox(width: 2.w),
                          Text('Duplicate'),
                        ],
                      ),
                    ),
                    if (post['status'] == 'posted')
                      PopupMenuItem(
                        value: 'analytics',
                        child: Row(
                          children: [
                            CustomIconWidget(
                              iconName: 'analytics',
                              color: AppTheme.primaryText,
                              size: 16,
                            ),
                            SizedBox(width: 2.w),
                            Text('Analytics'),
                          ],
                        ),
                      ),
                    if (post['status'] == 'failed')
                      PopupMenuItem(
                        value: 'retry',
                        child: Row(
                          children: [
                            CustomIconWidget(
                              iconName: 'refresh',
                              color: AppTheme.accent,
                              size: 16,
                            ),
                            SizedBox(width: 2.w),
                            Text('Retry'),
                          ],
                        ),
                      ),
                    PopupMenuItem(
                      value: 'delete',
                      child: Row(
                        children: [
                          CustomIconWidget(
                            iconName: 'delete',
                            color: AppTheme.error,
                            size: 16,
                          ),
                          SizedBox(width: 2.w),
                          Text('Delete'),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Post content
          Padding(
            padding: EdgeInsets.all(4.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (post['imageUrl'] != null) ...[
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: CustomImageWidget(
                      imageUrl: post['imageUrl'],
                      width: double.infinity,
                      height: 15.h,
                      fit: BoxFit.cover,
                    ),
                  ),
                  SizedBox(height: 2.h),
                ],
                Text(
                  post['content'],
                  style: AppTheme.darkTheme.textTheme.bodyMedium,
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),

                // Engagement metrics or retry button
                if (post['status'] == 'posted') ...[
                  SizedBox(height: 2.h),
                  Row(
                    children: [
                      _buildEngagementMetric(
                        'favorite',
                        post['engagement']['likes'].toString(),
                      ),
                      SizedBox(width: 4.w),
                      _buildEngagementMetric(
                        'comment',
                        post['engagement']['comments'].toString(),
                      ),
                      SizedBox(width: 4.w),
                      _buildEngagementMetric(
                        'share',
                        post['engagement']['shares'].toString(),
                      ),
                    ],
                  ),
                ] else if (post['status'] == 'failed') ...[
                  SizedBox(height: 2.h),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          'Failed to publish',
                          style:
                              AppTheme.darkTheme.textTheme.bodySmall?.copyWith(
                            color: AppTheme.error,
                          ),
                        ),
                      ),
                      TextButton(
                        onPressed: () => onRetryPost(post['id']),
                        child: Text(
                          'Retry',
                          style: AppTheme.darkTheme.textTheme.labelMedium
                              ?.copyWith(
                            color: AppTheme.accent,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEngagementMetric(String iconName, String value) {
    return Row(
      children: [
        CustomIconWidget(
          iconName: iconName,
          color: AppTheme.secondaryText,
          size: 16,
        ),
        SizedBox(width: 1.w),
        Text(
          value,
          style: AppTheme.darkTheme.textTheme.bodySmall,
        ),
      ],
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

  Color _getStatusColor(String status) {
    switch (status) {
      case 'scheduled':
        return AppTheme.warning;
      case 'posted':
        return AppTheme.success;
      case 'failed':
        return AppTheme.error;
      default:
        return AppTheme.secondaryText;
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

  String _formatDate(DateTime date) {
    const months = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December'
    ];
    const weekdays = [
      'Monday',
      'Tuesday',
      'Wednesday',
      'Thursday',
      'Friday',
      'Saturday',
      'Sunday'
    ];

    return '${weekdays[date.weekday - 1]}, ${months[date.month - 1]} ${date.day}';
  }
}