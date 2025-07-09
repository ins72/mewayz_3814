import 'package:flutter/material.dart';

import '../../../core/app_export.dart';
import '../../../theme/app_theme.dart';

class AnalyticsHeaderWidget extends StatelessWidget {
  final String selectedDateRange;
  final List<String> selectedPlatforms;
  final Function(String) onDateRangeChanged;
  final Function(String) onPlatformToggle;

  const AnalyticsHeaderWidget({
    super.key,
    required this.selectedDateRange,
    required this.selectedPlatforms,
    required this.onDateRangeChanged,
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
          Row(
            children: [
              Expanded(
                child: _buildDateRangeSelector(),
              ),
              const SizedBox(width: 12),
              _buildCustomDateButton(),
            ],
          ),
          const SizedBox(height: 16),
          const Text(
            'Platforms',
            style: TextStyle(
              color: AppTheme.primaryText,
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          _buildPlatformFilters(),
        ],
      ),
    );
  }

  Widget _buildDateRangeSelector() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: AppTheme.primaryBackground,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppTheme.border),
      ),
      child: DropdownButton<String>(
        value: selectedDateRange,
        icon: const Icon(Icons.keyboard_arrow_down, color: AppTheme.secondaryText),
        underline: Container(),
        dropdownColor: AppTheme.surface,
        style: const TextStyle(
          color: AppTheme.primaryText,
          fontSize: 14,
        ),
        items: [
          '7 days',
          '30 days',
          '90 days',
          '6 months',
          '1 year',
        ].map((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(value),
          );
        }).toList(),
        onChanged: (String? newValue) {
          if (newValue != null) {
            onDateRangeChanged(newValue);
          }
        },
      ),
    );
  }

  Widget _buildCustomDateButton() {
    return OutlinedButton.icon(
      onPressed: _showCustomDatePicker,
      icon: const Icon(Icons.calendar_today, size: 16),
      label: const Text('Custom'),
      style: OutlinedButton.styleFrom(
        foregroundColor: AppTheme.accent,
        side: const BorderSide(color: AppTheme.accent),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      ),
    );
  }

  Widget _buildPlatformFilters() {
    final platforms = [
      {'id': 'instagram', 'name': 'Instagram', 'icon': Icons.camera_alt, 'color': Colors.purple},
      {'id': 'facebook', 'name': 'Facebook', 'icon': Icons.facebook, 'color': Colors.blue},
      {'id': 'twitter', 'name': 'Twitter', 'icon': Icons.alternate_email, 'color': Colors.lightBlue},
      {'id': 'linkedin', 'name': 'LinkedIn', 'icon': Icons.business, 'color': Colors.indigo},
      {'id': 'tiktok', 'name': 'TikTok', 'icon': Icons.music_video, 'color': Colors.black},
      {'id': 'youtube', 'name': 'YouTube', 'icon': Icons.play_circle, 'color': Colors.red},
    ];

    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: platforms.map((platform) {
        final isSelected = selectedPlatforms.contains(platform['id']);
        return FilterChip(
          label: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                platform['icon'] as IconData,
                size: 16,
                color: isSelected ? AppTheme.primaryText : AppTheme.secondaryText,
              ),
              const SizedBox(width: 4),
              Text(platform['name'] as String),
            ],
          ),
          selected: isSelected,
          onSelected: (selected) => onPlatformToggle(platform['id'] as String),
          backgroundColor: AppTheme.primaryBackground,
          selectedColor: AppTheme.accent.withAlpha(51),
          checkmarkColor: AppTheme.accent,
          labelStyle: TextStyle(
            color: isSelected ? AppTheme.primaryText : AppTheme.secondaryText,
            fontSize: 12,
          ),
          side: BorderSide(
            color: isSelected ? AppTheme.accent : AppTheme.border,
          ),
        );
      }).toList(),
    );
  }

  void _showCustomDatePicker() {
    // Show custom date range picker
  }
}