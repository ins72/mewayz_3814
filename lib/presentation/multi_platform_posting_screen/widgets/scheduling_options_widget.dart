import 'package:flutter/material.dart';

import '../../../core/app_export.dart';
import '../../../theme/app_theme.dart';

class SchedulingOptionsWidget extends StatelessWidget {
  final bool isScheduled;
  final DateTime? scheduledTime;
  final Function(bool) onScheduleToggle;
  final Function(DateTime) onTimeSelected;

  const SchedulingOptionsWidget({
    super.key,
    required this.isScheduled,
    required this.scheduledTime,
    required this.onScheduleToggle,
    required this.onTimeSelected,
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
                'Scheduling',
                style: TextStyle(
                  color: AppTheme.primaryText,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const Spacer(),
              Switch(
                value: isScheduled,
                onChanged: onScheduleToggle,
                activeColor: AppTheme.accent,
              ),
            ],
          ),
          if (isScheduled) ...[
            const SizedBox(height: 16),
            _buildScheduleOptions(context),
          ],
        ],
      ),
    );
  }

  Widget _buildScheduleOptions(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: _buildTimeSelector(context),
            ),
            const SizedBox(width: 12),
            _buildOptimalTimeButton(),
          ],
        ),
        const SizedBox(height: 12),
        _buildOptimalTimeSuggestions(),
      ],
    );
  }

  Widget _buildTimeSelector(BuildContext context) {
    return GestureDetector(
      onTap: () => _selectDateTime(context),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: AppTheme.primaryBackground,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: AppTheme.border),
        ),
        child: Row(
          children: [
            const Icon(
              Icons.schedule,
              color: AppTheme.secondaryText,
              size: 20,
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                scheduledTime != null
                    ? _formatDateTime(scheduledTime!)
                    : 'Select date & time',
                style: TextStyle(
                  color: scheduledTime != null
                      ? AppTheme.primaryText
                      : AppTheme.secondaryText,
                  fontSize: 14,
                ),
              ),
            ),
            const Icon(
              Icons.arrow_drop_down,
              color: AppTheme.secondaryText,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOptimalTimeButton() {
    return OutlinedButton.icon(
      onPressed: _suggestOptimalTime,
      icon: const Icon(Icons.auto_awesome, size: 16),
      label: const Text('AI'),
      style: OutlinedButton.styleFrom(
        foregroundColor: AppTheme.accent,
        side: const BorderSide(color: AppTheme.accent),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      ),
    );
  }

  Widget _buildOptimalTimeSuggestions() {
    final suggestions = [
      {'time': '9:00 AM', 'engagement': '85%', 'day': 'Today'},
      {'time': '1:00 PM', 'engagement': '78%', 'day': 'Today'},
      {'time': '6:00 PM', 'engagement': '92%', 'day': 'Today'},
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Optimal Times',
          style: TextStyle(
            color: AppTheme.primaryText,
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: suggestions.map((suggestion) {
            return GestureDetector(
              onTap: () => _selectSuggestedTime(suggestion),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: AppTheme.primaryBackground,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: AppTheme.border),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      suggestion['time']!,
                      style: const TextStyle(
                        color: AppTheme.primaryText,
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Text(
                      '${suggestion['engagement']} engagement',
                      style: const TextStyle(
                        color: AppTheme.success,
                        fontSize: 10,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  String _formatDateTime(DateTime dateTime) {
    return '${dateTime.day}/${dateTime.month}/${dateTime.year} at ${dateTime.hour}:${dateTime.minute.toString().padLeft(2, '0')}';
  }

  void _selectDateTime(BuildContext context) async {
    final date = await showDatePicker(
      context: context,
      initialDate: scheduledTime ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );

    if (date != null) {
      final time = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.fromDateTime(scheduledTime ?? DateTime.now()),
      );

      if (time != null) {
        final dateTime = DateTime(
          date.year,
          date.month,
          date.day,
          time.hour,
          time.minute,
        );
        onTimeSelected(dateTime);
      }
    }
  }

  void _suggestOptimalTime() {
    // AI-powered optimal time suggestion
    final now = DateTime.now();
    final optimalTime = DateTime(
      now.year,
      now.month,
      now.day,
      18, // 6 PM
      0,
    );
    onTimeSelected(optimalTime);
  }

  void _selectSuggestedTime(Map<String, String> suggestion) {
    // Parse and select suggested time
    final now = DateTime.now();
    final time = suggestion['time']!;
    // Parse time string and create DateTime
    final hour = time.contains('PM') ? 12 + int.parse(time.split(':')[0]) : int.parse(time.split(':')[0]);
    final optimalTime = DateTime(now.year, now.month, now.day, hour, 0);
    onTimeSelected(optimalTime);
  }
}