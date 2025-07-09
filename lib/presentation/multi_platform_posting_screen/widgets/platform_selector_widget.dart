import 'package:flutter/material.dart';

import '../../../core/app_export.dart';
import '../../../theme/app_theme.dart';

class PlatformSelectorWidget extends StatelessWidget {
  final List<String> selectedPlatforms;
  final Function(String) onPlatformToggle;

  const PlatformSelectorWidget({
    super.key,
    required this.selectedPlatforms,
    required this.onPlatformToggle,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(
        color: AppTheme.surface,
        border: Border(
          bottom: BorderSide(color: AppTheme.border),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Select Platforms',
            style: TextStyle(
              color: AppTheme.primaryText,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 12,
            runSpacing: 8,
            children: _buildPlatformChips(),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildPlatformChips() {
    final platforms = [
      {'id': 'instagram', 'name': 'Instagram', 'icon': Icons.camera_alt, 'color': Colors.purple},
      {'id': 'facebook', 'name': 'Facebook', 'icon': Icons.facebook, 'color': Colors.blue},
      {'id': 'twitter', 'name': 'Twitter', 'icon': Icons.alternate_email, 'color': Colors.lightBlue},
      {'id': 'linkedin', 'name': 'LinkedIn', 'icon': Icons.business, 'color': Colors.indigo},
      {'id': 'tiktok', 'name': 'TikTok', 'icon': Icons.music_video, 'color': Colors.black},
      {'id': 'youtube', 'name': 'YouTube', 'icon': Icons.play_circle, 'color': Colors.red},
    ];

    return platforms.map((platform) {
      final isSelected = selectedPlatforms.contains(platform['id']);
      return GestureDetector(
        onTap: () => onPlatformToggle(platform['id'] as String),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: isSelected ? AppTheme.accent : AppTheme.surface,
            border: Border.all(
              color: isSelected ? AppTheme.accent : AppTheme.border,
              width: 1,
            ),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                platform['icon'] as IconData,
                color: isSelected ? AppTheme.primaryText : AppTheme.secondaryText,
                size: 16,
              ),
              const SizedBox(width: 8),
              Text(
                platform['name'] as String,
                style: TextStyle(
                  color: isSelected ? AppTheme.primaryText : AppTheme.secondaryText,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
              if (isSelected) ...[
                const SizedBox(width: 4),
                const Icon(
                  Icons.check_circle,
                  color: AppTheme.success,
                  size: 16,
                ),
              ],
            ],
          ),
        ),
      );
    }).toList();
  }
}