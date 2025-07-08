import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../theme/app_theme.dart';

class PrivacyControlsWidget extends StatelessWidget {
  final bool dataSharing;
  final bool marketingCommunications;
  final String accountVisibility;
  final String selectedLanguage;
  final String selectedTimezone;
  final Function(bool) onDataSharingChanged;
  final Function(bool) onMarketingChanged;
  final Function(String) onVisibilityChanged;
  final Function(String) onLanguageChanged;
  final Function(String) onTimezoneChanged;

  const PrivacyControlsWidget({
    Key? key,
    required this.dataSharing,
    required this.marketingCommunications,
    required this.accountVisibility,
    required this.selectedLanguage,
    required this.selectedTimezone,
    required this.onDataSharingChanged,
    required this.onMarketingChanged,
    required this.onVisibilityChanged,
    required this.onLanguageChanged,
    required this.onTimezoneChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16),
      padding: EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppTheme.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Privacy Controls',
            style: GoogleFonts.inter(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: AppTheme.primaryText,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Control your data sharing and privacy preferences',
            style: GoogleFonts.inter(
              fontSize: 14,
              color: AppTheme.secondaryText,
            ),
          ),
          const SizedBox(height: 24),

          // Data Sharing Preferences
          Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppTheme.primaryBackground,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppTheme.border),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.share_outlined,
                  color: AppTheme.secondaryText,
                  size: 20,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Data Sharing',
                        style: GoogleFonts.inter(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: AppTheme.primaryText,
                        ),
                      ),
                      Text(
                        'Share analytics data to improve service',
                        style: GoogleFonts.inter(
                          fontSize: 12,
                          color: AppTheme.secondaryText,
                        ),
                      ),
                    ],
                  ),
                ),
                Switch(
                  value: dataSharing,
                  onChanged: onDataSharingChanged,
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Marketing Communications
          Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppTheme.primaryBackground,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppTheme.border),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.campaign_outlined,
                  color: AppTheme.secondaryText,
                  size: 20,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Marketing Communications',
                        style: GoogleFonts.inter(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: AppTheme.primaryText,
                        ),
                      ),
                      Text(
                        'Receive promotional emails and updates',
                        style: GoogleFonts.inter(
                          fontSize: 12,
                          color: AppTheme.secondaryText,
                        ),
                      ),
                    ],
                  ),
                ),
                Switch(
                  value: marketingCommunications,
                  onChanged: onMarketingChanged,
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Account Visibility
          Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppTheme.primaryBackground,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppTheme.border),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.visibility_outlined,
                      color: AppTheme.secondaryText,
                      size: 20,
                    ),
                    const SizedBox(width: 12),
                    Text(
                      'Account Visibility',
                      style: GoogleFonts.inter(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: AppTheme.primaryText,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  value: accountVisibility,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(color: AppTheme.border),
                    ),
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  ),
                  dropdownColor: AppTheme.surface,
                  style: GoogleFonts.inter(
                    color: AppTheme.primaryText,
                    fontSize: 14,
                  ),
                  items: [
                    DropdownMenuItem(
                      value: 'public',
                      child: Text('Public'),
                    ),
                    DropdownMenuItem(
                      value: 'private',
                      child: Text('Private'),
                    ),
                    DropdownMenuItem(
                      value: 'friends',
                      child: Text('Friends Only'),
                    ),
                  ],
                  onChanged: (value) {
                    if (value != null) {
                      onVisibilityChanged(value);
                    }
                  },
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // Language & Timezone
          Text(
            'Localization',
            style: GoogleFonts.inter(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: AppTheme.primaryText,
            ),
          ),
          const SizedBox(height: 16),

          // Language
          Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppTheme.primaryBackground,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppTheme.border),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.language,
                      color: AppTheme.secondaryText,
                      size: 20,
                    ),
                    const SizedBox(width: 12),
                    Text(
                      'Language',
                      style: GoogleFonts.inter(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: AppTheme.primaryText,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  value: selectedLanguage,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(color: AppTheme.border),
                    ),
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  ),
                  dropdownColor: AppTheme.surface,
                  style: GoogleFonts.inter(
                    color: AppTheme.primaryText,
                    fontSize: 14,
                  ),
                  items: [
                    DropdownMenuItem(value: 'English', child: Text('English')),
                    DropdownMenuItem(value: 'Spanish', child: Text('Spanish')),
                    DropdownMenuItem(value: 'French', child: Text('French')),
                    DropdownMenuItem(value: 'German', child: Text('German')),
                    DropdownMenuItem(value: 'Italian', child: Text('Italian')),
                    DropdownMenuItem(
                        value: 'Portuguese', child: Text('Portuguese')),
                  ],
                  onChanged: (value) {
                    if (value != null) {
                      onLanguageChanged(value);
                    }
                  },
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Timezone
          Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppTheme.primaryBackground,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppTheme.border),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.access_time,
                      color: AppTheme.secondaryText,
                      size: 20,
                    ),
                    const SizedBox(width: 12),
                    Text(
                      'Timezone',
                      style: GoogleFonts.inter(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: AppTheme.primaryText,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  value: selectedTimezone,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(color: AppTheme.border),
                    ),
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  ),
                  dropdownColor: AppTheme.surface,
                  style: GoogleFonts.inter(
                    color: AppTheme.primaryText,
                    fontSize: 14,
                  ),
                  items: [
                    DropdownMenuItem(
                        value: 'UTC-5 (Eastern Time)',
                        child: Text('UTC-5 (Eastern Time)')),
                    DropdownMenuItem(
                        value: 'UTC-6 (Central Time)',
                        child: Text('UTC-6 (Central Time)')),
                    DropdownMenuItem(
                        value: 'UTC-7 (Mountain Time)',
                        child: Text('UTC-7 (Mountain Time)')),
                    DropdownMenuItem(
                        value: 'UTC-8 (Pacific Time)',
                        child: Text('UTC-8 (Pacific Time)')),
                    DropdownMenuItem(
                        value: 'UTC+0 (GMT)', child: Text('UTC+0 (GMT)')),
                    DropdownMenuItem(
                        value: 'UTC+1 (CET)', child: Text('UTC+1 (CET)')),
                  ],
                  onChanged: (value) {
                    if (value != null) {
                      onTimezoneChanged(value);
                    }
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
