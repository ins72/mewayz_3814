import 'package:flutter/material.dart';

import '../../../core/app_export.dart';
import '../../../theme/app_theme.dart';

class PlatformTabsWidget extends StatelessWidget {
  final List<String> selectedPlatforms;
  final String activePlatform;
  final Function(String) onPlatformSelected;

  const PlatformTabsWidget({
    super.key,
    required this.selectedPlatforms,
    required this.activePlatform,
    required this.onPlatformSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: selectedPlatforms.length,
        itemBuilder: (context, index) {
          final platform = selectedPlatforms[index];
          final isActive = platform == activePlatform;
          
          return _buildPlatformTab(platform, isActive);
        },
      ),
    );
  }

  Widget _buildPlatformTab(String platform, bool isActive) {
    final platformData = _getPlatformData(platform);
    
    return GestureDetector(
      onTap: () => onPlatformSelected(platform),
      child: Container(
        margin: const EdgeInsets.only(right: 12),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isActive ? AppTheme.accent : AppTheme.surface,
          borderRadius: BorderRadius.circular(25),
          border: Border.all(
            color: isActive ? AppTheme.accent : AppTheme.border,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              platformData['icon'] as IconData,
              size: 18,
              color: isActive ? AppTheme.primaryText : AppTheme.secondaryText,
            ),
            const SizedBox(width: 8),
            Text(
              platformData['name'] as String,
              style: TextStyle(
                color: isActive ? AppTheme.primaryText : AppTheme.secondaryText,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Map<String, dynamic> _getPlatformData(String platform) {
    switch (platform) {
      case 'instagram':
        return {'name': 'Instagram', 'icon': Icons.camera_alt, 'color': Colors.purple};
      case 'facebook':
        return {'name': 'Facebook', 'icon': Icons.facebook, 'color': Colors.blue};
      case 'twitter':
        return {'name': 'Twitter', 'icon': Icons.alternate_email, 'color': Colors.lightBlue};
      case 'linkedin':
        return {'name': 'LinkedIn', 'icon': Icons.business, 'color': Colors.indigo};
      case 'tiktok':
        return {'name': 'TikTok', 'icon': Icons.music_video, 'color': Colors.black};
      case 'youtube':
        return {'name': 'YouTube', 'icon': Icons.play_circle, 'color': Colors.red};
      default:
        return {'name': 'Unknown', 'icon': Icons.help, 'color': Colors.grey};
    }
  }
}