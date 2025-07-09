import 'package:flutter/material.dart';

import '../../../core/app_export.dart';
import '../../../theme/app_theme.dart';

class BulkPostingHistoryWidget extends StatelessWidget {
  final Function(Map<String, dynamic>) onRepost;

  const BulkPostingHistoryWidget({
    super.key,
    required this.onRepost,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Text(
                'Posting History',
                style: TextStyle(
                  color: AppTheme.primaryText,
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const Spacer(),
              TextButton.icon(
                onPressed: _exportHistory,
                icon: const Icon(Icons.download, size: 16),
                label: const Text('Export'),
                style: TextButton.styleFrom(
                  foregroundColor: AppTheme.accent,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _buildFilterTabs(),
          const SizedBox(height: 16),
          ..._buildPostHistory(),
        ],
      ),
    );
  }

  Widget _buildFilterTabs() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          _buildFilterChip('All', true),
          _buildFilterChip('Published', false),
          _buildFilterChip('Scheduled', false),
          _buildFilterChip('Draft', false),
          _buildFilterChip('Failed', false),
        ],
      ),
    );
  }

  Widget _buildFilterChip(String label, bool isSelected) {
    return Container(
      margin: const EdgeInsets.only(right: 8),
      child: FilterChip(
        label: Text(label),
        selected: isSelected,
        onSelected: (selected) => _filterPosts(label),
        backgroundColor: AppTheme.surface,
        selectedColor: AppTheme.accent.withAlpha(51),
        labelStyle: TextStyle(
          color: isSelected ? AppTheme.accent : AppTheme.secondaryText,
          fontSize: 12,
        ),
        side: BorderSide(
          color: isSelected ? AppTheme.accent : AppTheme.border,
        ),
      ),
    );
  }

  List<Widget> _buildPostHistory() {
    final posts = _getPostHistory();
    
    return posts.map((post) => _buildPostHistoryItem(post)).toList();
  }

  Widget _buildPostHistoryItem(Map<String, dynamic> post) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
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
              Expanded(
                child: Text(
                  post['content'].toString().substring(0, 50) + '...',
                  style: const TextStyle(
                    color: AppTheme.primaryText,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              _buildStatusBadge(post['status']),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Icon(
                Icons.schedule,
                color: AppTheme.secondaryText,
                size: 16,
              ),
              const SizedBox(width: 4),
              Text(
                post['date'],
                style: const TextStyle(
                  color: AppTheme.secondaryText,
                  fontSize: 12,
                ),
              ),
              const SizedBox(width: 16),
              Icon(
                Icons.visibility,
                color: AppTheme.secondaryText,
                size: 16,
              ),
              const SizedBox(width: 4),
              Text(
                '${post['reach']} reach',
                style: const TextStyle(
                  color: AppTheme.secondaryText,
                  fontSize: 12,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          _buildPlatformTags(post['platforms']),
          const SizedBox(height: 12),
          _buildPerformanceMetrics(post['metrics']),
          const SizedBox(height: 12),
          _buildActionButtons(post),
        ],
      ),
    );
  }

  Widget _buildStatusBadge(String status) {
    Color color;
    switch (status) {
      case 'published':
        color = AppTheme.success;
        break;
      case 'scheduled':
        color = AppTheme.warning;
        break;
      case 'draft':
        color = AppTheme.secondaryText;
        break;
      case 'failed':
        color = AppTheme.error;
        break;
      default:
        color = AppTheme.secondaryText;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withAlpha(26),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        status.toUpperCase(),
        style: TextStyle(
          color: color,
          fontSize: 10,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _buildPlatformTags(List<String> platforms) {
    return Wrap(
      spacing: 6,
      children: platforms.map((platform) {
        final platformData = _getPlatformData(platform);
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: platformData['color'].withAlpha(26),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                platformData['icon'],
                size: 12,
                color: platformData['color'],
              ),
              const SizedBox(width: 4),
              Text(
                platform,
                style: TextStyle(
                  color: platformData['color'],
                  fontSize: 10,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget _buildPerformanceMetrics(Map<String, dynamic> metrics) {
    return Row(
      children: [
        _buildMetric('Engagement', '${metrics['engagement']}%'),
        _buildMetric('Clicks', '${metrics['clicks']}'),
        _buildMetric('Shares', '${metrics['shares']}'),
        _buildMetric('Comments', '${metrics['comments']}'),
      ],
    );
  }

  Widget _buildMetric(String label, String value) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            value,
            style: const TextStyle(
              color: AppTheme.primaryText,
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
          Text(
            label,
            style: const TextStyle(
              color: AppTheme.secondaryText,
              fontSize: 10,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons(Map<String, dynamic> post) {
    return Row(
      children: [
        TextButton.icon(
          onPressed: () => _viewDetails(post),
          icon: const Icon(Icons.visibility, size: 16),
          label: const Text('View'),
          style: TextButton.styleFrom(
            foregroundColor: AppTheme.accent,
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          ),
        ),
        TextButton.icon(
          onPressed: () => onRepost(post),
          icon: const Icon(Icons.repeat, size: 16),
          label: const Text('Repost'),
          style: TextButton.styleFrom(
            foregroundColor: AppTheme.accent,
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          ),
        ),
        TextButton.icon(
          onPressed: () => _editPost(post),
          icon: const Icon(Icons.edit, size: 16),
          label: const Text('Edit'),
          style: TextButton.styleFrom(
            foregroundColor: AppTheme.accent,
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          ),
        ),
        TextButton.icon(
          onPressed: () => _deletePost(post),
          icon: const Icon(Icons.delete, size: 16),
          label: const Text('Delete'),
          style: TextButton.styleFrom(
            foregroundColor: AppTheme.error,
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          ),
        ),
      ],
    );
  }

  Map<String, dynamic> _getPlatformData(String platform) {
    switch (platform) {
      case 'instagram':
        return {'icon': Icons.camera_alt, 'color': Colors.purple};
      case 'facebook':
        return {'icon': Icons.facebook, 'color': Colors.blue};
      case 'twitter':
        return {'icon': Icons.alternate_email, 'color': Colors.lightBlue};
      case 'linkedin':
        return {'icon': Icons.business, 'color': Colors.indigo};
      case 'tiktok':
        return {'icon': Icons.music_video, 'color': Colors.black};
      case 'youtube':
        return {'icon': Icons.play_circle, 'color': Colors.red};
      default:
        return {'icon': Icons.help, 'color': Colors.grey};
    }
  }

  List<Map<String, dynamic>> _getPostHistory() {
    return [
      {
        'id': '1',
        'content': 'Exciting news! We\'re launching our new product line next week. Stay tuned for more updates!',
        'status': 'published',
        'date': '2024-01-15 09:00 AM',
        'reach': '2.5K',
        'platforms': ['instagram', 'facebook', 'twitter'],
        'metrics': {
          'engagement': 8.5,
          'clicks': 124,
          'shares': 45,
          'comments': 23,
        },
      },
      {
        'id': '2',
        'content': 'Behind the scenes look at our creative process. Here\'s how we bring ideas to life!',
        'status': 'scheduled',
        'date': '2024-01-16 02:00 PM',
        'reach': '0',
        'platforms': ['instagram', 'linkedin'],
        'metrics': {
          'engagement': 0,
          'clicks': 0,
          'shares': 0,
          'comments': 0,
        },
      },
      {
        'id': '3',
        'content': 'Thank you to all our amazing customers for your continued support. You make everything possible!',
        'status': 'draft',
        'date': '2024-01-14 11:30 AM',
        'reach': '0',
        'platforms': ['facebook', 'twitter', 'linkedin'],
        'metrics': {
          'engagement': 0,
          'clicks': 0,
          'shares': 0,
          'comments': 0,
        },
      },
    ];
  }

  void _filterPosts(String filter) {
    // Filter posts based on selected filter
  }

  void _exportHistory() {
    // Export posting history
  }

  void _viewDetails(Map<String, dynamic> post) {
    // View detailed post analytics
  }

  void _editPost(Map<String, dynamic> post) {
    // Edit existing post
  }

  void _deletePost(Map<String, dynamic> post) {
    // Delete post
  }
}