import 'package:flutter/material.dart';

import '../../../core/app_export.dart';
import '../../../theme/app_theme.dart';

class CrossPostingRulesWidget extends StatelessWidget {
  final List<String> selectedPlatforms;
  final Function(String) onRuleChanged;

  const CrossPostingRulesWidget({
    super.key,
    required this.selectedPlatforms,
    required this.onRuleChanged,
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
          const Text(
            'Cross-Posting Rules',
            style: TextStyle(
              color: AppTheme.primaryText,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 12),
          _buildRulesList(),
        ],
      ),
    );
  }

  Widget _buildRulesList() {
    return Column(
      children: [
        _buildRuleItem(
          'Auto-crop images',
          'Automatically crop images to fit each platform\'s requirements',
          true,
        ),
        _buildRuleItem(
          'Platform-specific hashtags',
          'Use different hashtags optimized for each platform',
          false,
        ),
        _buildRuleItem(
          'Character limit adaptation',
          'Automatically truncate content to fit platform limits',
          true,
        ),
        _buildRuleItem(
          'Remove duplicate mentions',
          'Prevent double-tagging users across platforms',
          false,
        ),
      ],
    );
  }

  Widget _buildRuleItem(String title, String description, bool isEnabled) {
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
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: AppTheme.primaryText,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: const TextStyle(
                    color: AppTheme.secondaryText,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          Switch(
            value: isEnabled,
            onChanged: (value) => onRuleChanged(title),
            activeColor: AppTheme.accent,
          ),
        ],
      ),
    );
  }
}