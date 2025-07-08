import 'package:flutter/material.dart';

import '../../../core/app_export.dart';

class NotificationPreferencesWidget extends StatelessWidget {
  final bool enableEmailNotifications;
  final bool enablePushNotifications;
  final bool enableMarketingEmails;
  final String selectedLanguage;
  final String selectedTimezone;
  final ValueChanged<bool> onEmailNotificationsChanged;
  final ValueChanged<bool> onPushNotificationsChanged;
  final ValueChanged<bool> onMarketingEmailsChanged;
  final ValueChanged<String> onLanguageChanged;
  final ValueChanged<String> onTimezoneChanged;

  const NotificationPreferencesWidget({
    Key? key,
    required this.enableEmailNotifications,
    required this.enablePushNotifications,
    required this.enableMarketingEmails,
    required this.selectedLanguage,
    required this.selectedTimezone,
    required this.onEmailNotificationsChanged,
    required this.onPushNotificationsChanged,
    required this.onMarketingEmailsChanged,
    required this.onLanguageChanged,
    required this.onTimezoneChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(24),
      margin: EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppTheme.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Notification Preferences',
            style: GoogleFonts.inter(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: AppTheme.primaryText,
            ),
          ),

          const SizedBox(height: 24),

          // Notification Settings
          _buildToggleOption(
            'Email Notifications',
            'Receive important updates via email',
            enableEmailNotifications,
            onEmailNotificationsChanged,
          ),

          const SizedBox(height: 16),

          _buildToggleOption(
            'Push Notifications',
            'Receive push notifications on your device',
            enablePushNotifications,
            onPushNotificationsChanged,
          ),

          const SizedBox(height: 16),

          _buildToggleOption(
            'Marketing Emails',
            'Receive newsletters and promotional content',
            enableMarketingEmails,
            onMarketingEmailsChanged,
          ),

          const SizedBox(height: 32),

          // Language and Timezone
          Text(
            'Localization',
            style: GoogleFonts.inter(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: AppTheme.primaryText,
            ),
          ),

          const SizedBox(height: 16),

          _buildDropdownField(
            label: 'Language',
            value: selectedLanguage,
            items: [
              'English',
              'Spanish',
              'French',
              'German',
              'Italian',
              'Portuguese',
              'Dutch',
              'Russian',
              'Japanese',
              'Chinese',
              'Korean',
              'Arabic',
            ],
            onChanged: onLanguageChanged,
          ),

          const SizedBox(height: 20),

          _buildDropdownField(
            label: 'Timezone',
            value: selectedTimezone,
            items: [
              'UTC-12 (Baker Island)',
              'UTC-11 (Midway Island)',
              'UTC-10 (Hawaii)',
              'UTC-9 (Alaska)',
              'UTC-8 (Pacific Time)',
              'UTC-7 (Mountain Time)',
              'UTC-6 (Central Time)',
              'UTC-5 (Eastern Time)',
              'UTC-4 (Atlantic Time)',
              'UTC-3 (Brazil)',
              'UTC-2 (Mid-Atlantic)',
              'UTC-1 (Azores)',
              'UTC+0 (London)',
              'UTC+1 (Paris)',
              'UTC+2 (Berlin)',
              'UTC+3 (Moscow)',
              'UTC+4 (Dubai)',
              'UTC+5 (Islamabad)',
              'UTC+6 (Dhaka)',
              'UTC+7 (Bangkok)',
              'UTC+8 (Beijing)',
              'UTC+9 (Tokyo)',
              'UTC+10 (Sydney)',
              'UTC+11 (Solomon Islands)',
              'UTC+12 (Fiji)',
            ],
            onChanged: onTimezoneChanged,
          ),
        ],
      ),
    );
  }

  Widget _buildToggleOption(
    String title,
    String description,
    bool value,
    ValueChanged<bool> onChanged,
  ) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: GoogleFonts.inter(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: AppTheme.primaryText,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                description,
                style: GoogleFonts.inter(
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  color: AppTheme.secondaryText,
                ),
              ),
            ],
          ),
        ),
        Switch(
          value: value,
          onChanged: onChanged,
          activeColor: AppTheme.accent,
          inactiveTrackColor: AppTheme.border,
        ),
      ],
    );
  }

  Widget _buildDropdownField({
    required String label,
    required String value,
    required List<String> items,
    required ValueChanged<String> onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.inter(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: AppTheme.primaryText,
          ),
        ),
        const SizedBox(height: 8),
        DropdownButtonFormField<String>(
          value: value,
          style: GoogleFonts.inter(
            fontSize: 16,
            fontWeight: FontWeight.w400,
            color: AppTheme.primaryText,
          ),
          dropdownColor: AppTheme.surface,
          decoration: InputDecoration(
            fillColor: AppTheme.primaryBackground,
            filled: true,
            contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: AppTheme.border),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: AppTheme.border),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: AppTheme.accent, width: 2),
            ),
          ),
          items: items.map((String item) {
            return DropdownMenuItem<String>(
              value: item,
              child: Text(
                item,
                style: GoogleFonts.inter(
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                  color: AppTheme.primaryText,
                ),
              ),
            );
          }).toList(),
          onChanged: (String? newValue) {
            if (newValue != null) {
              onChanged(newValue);
            }
          },
        ),
      ],
    );
  }
}