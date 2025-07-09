import 'package:flutter/material.dart';

import '../../../core/app_export.dart';
import '../../../theme/app_theme.dart';

class ContentPerformanceWidget extends StatelessWidget {
  final List<String> selectedPlatforms;
  final String dateRange;

  const ContentPerformanceWidget({
    super.key,
    required this.selectedPlatforms,
    required this.dateRange,
  });

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
              const Text(
                'Top Performing Content',
                style: TextStyle(
                  color: AppTheme.primaryText,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const Spacer(),
              TextButton(
                onPressed: _viewAllContent,
                child: const Text(
                  'View All',
                  style: TextStyle(
                    color: AppTheme.accent,
                    fontSize: 12,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _buildContentList(),
        ],
      ),
    );
  }

  Widget _buildContentList() {
    final content = _getTopContent();
    
    return Column(
      children: content.map((item) => _buildContentItem(item)).toList(),
    );
  }

  Widget _buildContentItem(Map<String, dynamic> item) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppTheme.primaryBackground,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppTheme.border),
      ),
      child: Row(
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: AppTheme.border,
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(
              Icons.image,
              color: AppTheme.secondaryText,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item['title'] as String,
                  style: const TextStyle(
                    color: AppTheme.primaryText,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    _buildPlatformIcon(item['platform'] as String),
                    const SizedBox(width: 8),
                    Text(
                      item['date'] as String,
                      style: const TextStyle(
                        color: AppTheme.secondaryText,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                _buildMetrics(item['metrics'] as Map<String, dynamic>),
              ],
            ),
          ),
          IconButton(
            onPressed: () => _viewContentDetails(item),
            icon: const Icon(
              Icons.arrow_forward_ios,
              color: AppTheme.secondaryText,
              size: 16,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPlatformIcon(String platform) {
    final platformData = _getPlatformData(platform);
    
    return Container(
      width: 20,
      height: 20,
      decoration: BoxDecoration(
        color: platformData['color'],
        borderRadius: BorderRadius.circular(4),
      ),
      child: Icon(
        platformData['icon'],
        color: Colors.white,
        size: 12,
      ),
    );
  }

  Widget _buildMetrics(Map<String, dynamic> metrics) {
    return Row(
      children: [
        _buildMetricItem(Icons.visibility, metrics['reach'].toString()),
        const SizedBox(width: 12),
        _buildMetricItem(Icons.favorite, metrics['likes'].toString()),
        const SizedBox(width: 12),
        _buildMetricItem(Icons.comment, metrics['comments'].toString()),
        const SizedBox(width: 12),
        _buildMetricItem(Icons.share, metrics['shares'].toString()),
      ],
    );
  }

  Widget _buildMetricItem(IconData icon, String value) {
    return Row(
      children: [
        Icon(
          icon,
          size: 12,
          color: AppTheme.secondaryText,
        ),
        const SizedBox(width: 2),
        Text(
          value,
          style: const TextStyle(
            color: AppTheme.secondaryText,
            fontSize: 10,
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

  List<Map<String, dynamic>> _getTopContent() {
    return [
      {
        'title': 'Behind the scenes of our latest product launch',
        'platform': 'instagram',
        'date': '2 days ago',
        'metrics': {
          'reach': '12.5K',
          'likes': '856',
          'comments': '45',
          'shares': '23',
        },
      },
      {
        'title': 'Tips for growing your business in 2024',
        'platform': 'linkedin',
        'date': '5 days ago',
        'metrics': {
          'reach': '8.9K',
          'likes': '432',
          'comments': '78',
          'shares': '67',
        },
      },
      {
        'title': 'Customer success story: How we helped...',
        'platform': 'facebook',
        'date': '1 week ago',
        'metrics': {
          'reach': '15.2K',
          'likes': '1.2K',
          'comments': '123',
          'shares': '89',
        },
      },
    ];
  }

  void _viewAllContent() {
    // Navigate to detailed content performance page
  }

  void _viewContentDetails(Map<String, dynamic> content) {
    // View detailed analytics for specific content
  }
}