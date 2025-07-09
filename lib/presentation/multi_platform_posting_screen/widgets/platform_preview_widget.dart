import 'package:flutter/material.dart';

import '../../../core/app_export.dart';
import '../../../theme/app_theme.dart';

class PlatformPreviewWidget extends StatelessWidget {
  final List<String> selectedPlatforms;
  final String content;
  final List<String> media;

  const PlatformPreviewWidget({
    super.key,
    required this.selectedPlatforms,
    required this.content,
    required this.media,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Preview',
          style: TextStyle(
            color: AppTheme.primaryText,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 16),
        ...selectedPlatforms.map((platform) => _buildPlatformPreview(platform)),
      ],
    );
  }

  Widget _buildPlatformPreview(String platform) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppTheme.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildPlatformHeader(platform),
          const SizedBox(height: 12),
          _buildPostPreview(platform),
        ],
      ),
    );
  }

  Widget _buildPlatformHeader(String platform) {
    final platformData = _getPlatformData(platform);
    
    return Row(
      children: [
        Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            color: platformData['color'],
            borderRadius: BorderRadius.circular(6),
          ),
          child: Icon(
            platformData['icon'],
            color: Colors.white,
            size: 18,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                platformData['name'],
                style: const TextStyle(
                  color: AppTheme.primaryText,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                _getCharacterCount(platform),
                style: const TextStyle(
                  color: AppTheme.secondaryText,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: AppTheme.success.withAlpha(26),
            borderRadius: BorderRadius.circular(4),
          ),
          child: const Text(
            'Connected',
            style: TextStyle(
              color: AppTheme.success,
              fontSize: 10,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPostPreview(String platform) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppTheme.primaryBackground,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppTheme.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildUserHeader(),
          const SizedBox(height: 8),
          if (content.isNotEmpty) _buildContentPreview(platform),
          if (media.isNotEmpty) _buildMediaPreview(platform),
          const SizedBox(height: 8),
          _buildPlatformActions(platform),
        ],
      ),
    );
  }

  Widget _buildUserHeader() {
    return Row(
      children: [
        Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            color: AppTheme.accent,
            borderRadius: BorderRadius.circular(16),
          ),
          child: const Icon(
            Icons.person,
            color: Colors.white,
            size: 18,
          ),
        ),
        const SizedBox(width: 8),
        const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Your Business',
              style: TextStyle(
                color: AppTheme.primaryText,
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
            Text(
              'now',
              style: TextStyle(
                color: AppTheme.secondaryText,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildContentPreview(String platform) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      child: Text(
        content,
        style: const TextStyle(
          color: AppTheme.primaryText,
          fontSize: 14,
          height: 1.4,
        ),
      ),
    );
  }

  Widget _buildMediaPreview(String platform) {
    return Container(
      height: 180,
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: AppTheme.border,
        borderRadius: BorderRadius.circular(8),
      ),
      child: media.length == 1
          ? _buildSingleMedia()
          : _buildMultipleMedia(),
    );
  }

  Widget _buildSingleMedia() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppTheme.border,
        borderRadius: BorderRadius.circular(8),
      ),
      child: const Icon(
        Icons.image,
        color: AppTheme.secondaryText,
        size: 48,
      ),
    );
  }

  Widget _buildMultipleMedia() {
    return Row(
      children: [
        Expanded(
          child: Container(
            decoration: BoxDecoration(
              color: AppTheme.border,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(8),
                bottomLeft: Radius.circular(8),
              ),
            ),
            child: const Icon(
              Icons.image,
              color: AppTheme.secondaryText,
              size: 32,
            ),
          ),
        ),
        const SizedBox(width: 2),
        Expanded(
          child: Column(
            children: [
              Expanded(
                child: Container(
                  decoration: const BoxDecoration(
                    color: AppTheme.border,
                    borderRadius: BorderRadius.only(
                      topRight: Radius.circular(8),
                    ),
                  ),
                  child: const Icon(
                    Icons.image,
                    color: AppTheme.secondaryText,
                    size: 24,
                  ),
                ),
              ),
              const SizedBox(height: 2),
              Expanded(
                child: Container(
                  decoration: const BoxDecoration(
                    color: AppTheme.border,
                    borderRadius: BorderRadius.only(
                      bottomRight: Radius.circular(8),
                    ),
                  ),
                  child: media.length > 2
                      ? Stack(
                          children: [
                            const Icon(
                              Icons.image,
                              color: AppTheme.secondaryText,
                              size: 24,
                            ),
                            Positioned(
                              bottom: 4,
                              right: 4,
                              child: Container(
                                padding: const EdgeInsets.all(4),
                                decoration: BoxDecoration(
                                  color: AppTheme.primaryBackground.withAlpha(204),
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: Text(
                                  '+${media.length - 2}',
                                  style: const TextStyle(
                                    color: AppTheme.primaryText,
                                    fontSize: 10,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        )
                      : const Icon(
                          Icons.image,
                          color: AppTheme.secondaryText,
                          size: 24,
                        ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildPlatformActions(String platform) {
    final actions = _getPlatformActions(platform);
    
    return Row(
      children: actions.map((action) {
        return Padding(
          padding: const EdgeInsets.only(right: 16),
          child: Row(
            children: [
              Icon(
                action['icon'],
                color: AppTheme.secondaryText,
                size: 16,
              ),
              const SizedBox(width: 4),
              Text(
                action['label'],
                style: const TextStyle(
                  color: AppTheme.secondaryText,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  Map<String, dynamic> _getPlatformData(String platform) {
    switch (platform) {
      case 'instagram':
        return {
          'name': 'Instagram',
          'icon': Icons.camera_alt,
          'color': Colors.purple,
        };
      case 'facebook':
        return {
          'name': 'Facebook',
          'icon': Icons.facebook,
          'color': Colors.blue,
        };
      case 'twitter':
        return {
          'name': 'Twitter',
          'icon': Icons.alternate_email,
          'color': Colors.lightBlue,
        };
      case 'linkedin':
        return {
          'name': 'LinkedIn',
          'icon': Icons.business,
          'color': Colors.indigo,
        };
      case 'tiktok':
        return {
          'name': 'TikTok',
          'icon': Icons.music_video,
          'color': Colors.black,
        };
      case 'youtube':
        return {
          'name': 'YouTube',
          'icon': Icons.play_circle,
          'color': Colors.red,
        };
      default:
        return {
          'name': 'Unknown',
          'icon': Icons.help,
          'color': Colors.grey,
        };
    }
  }

  String _getCharacterCount(String platform) {
    final count = content.length;
    final limit = _getCharacterLimit(platform);
    return '$count/$limit characters';
  }

  int _getCharacterLimit(String platform) {
    switch (platform) {
      case 'twitter':
        return 280;
      case 'instagram':
        return 2200;
      case 'facebook':
        return 63206;
      case 'linkedin':
        return 3000;
      case 'tiktok':
        return 2200;
      case 'youtube':
        return 5000;
      default:
        return 500;
    }
  }

  List<Map<String, dynamic>> _getPlatformActions(String platform) {
    switch (platform) {
      case 'instagram':
        return [
          {'icon': Icons.favorite_border, 'label': 'Like'},
          {'icon': Icons.comment, 'label': 'Comment'},
          {'icon': Icons.share, 'label': 'Share'},
        ];
      case 'facebook':
        return [
          {'icon': Icons.thumb_up, 'label': 'Like'},
          {'icon': Icons.comment, 'label': 'Comment'},
          {'icon': Icons.share, 'label': 'Share'},
        ];
      case 'twitter':
        return [
          {'icon': Icons.repeat, 'label': 'Retweet'},
          {'icon': Icons.favorite_border, 'label': 'Like'},
          {'icon': Icons.share, 'label': 'Share'},
        ];
      case 'linkedin':
        return [
          {'icon': Icons.thumb_up, 'label': 'Like'},
          {'icon': Icons.comment, 'label': 'Comment'},
          {'icon': Icons.share, 'label': 'Share'},
        ];
      default:
        return [
          {'icon': Icons.favorite_border, 'label': 'Like'},
          {'icon': Icons.comment, 'label': 'Comment'},
          {'icon': Icons.share, 'label': 'Share'},
        ];
    }
  }
}