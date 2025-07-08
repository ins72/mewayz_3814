import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../theme/app_theme.dart';

class NotificationCategoryWidget extends StatefulWidget {
  final String title;
  final String description;
  final IconData icon;
  final Map<String, bool> settings;
  final Function(String, bool) onSettingChanged;
  final VoidCallback onEnableAll;
  final VoidCallback onDisableAll;

  const NotificationCategoryWidget({
    Key? key,
    required this.title,
    required this.description,
    required this.icon,
    required this.settings,
    required this.onSettingChanged,
    required this.onEnableAll,
    required this.onDisableAll,
  }) : super(key: key);

  @override
  State<NotificationCategoryWidget> createState() =>
      _NotificationCategoryWidgetState();
}

class _NotificationCategoryWidgetState
    extends State<NotificationCategoryWidget> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppTheme.border),
      ),
      child: Column(
        children: [
          // Header
          InkWell(
            onTap: () {
              setState(() {
                _isExpanded = !_isExpanded;
              });
            },
            borderRadius: BorderRadius.circular(16),
            child: Container(
              padding: EdgeInsets.all(20),
              child: Row(
                children: [
                  Container(
                    padding: EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppTheme.primaryBackground,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      widget.icon,
                      color: AppTheme.accent,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.title,
                          style: GoogleFonts.inter(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: AppTheme.primaryText,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          widget.description,
                          style: GoogleFonts.inter(
                            fontSize: 14,
                            color: AppTheme.secondaryText,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Icon(
                    _isExpanded ? Icons.expand_less : Icons.expand_more,
                    color: AppTheme.secondaryText,
                  ),
                ],
              ),
            ),
          ),

          // Expanded Content
          if (_isExpanded) ...[
            Divider(
              color: AppTheme.border,
              height: 1,
            ),
            Padding(
              padding: EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Notification Types
                  _buildNotificationToggle(
                    'Email Notifications',
                    'Receive notifications via email',
                    Icons.email_outlined,
                    widget.settings['email'] ?? false,
                    (value) => widget.onSettingChanged('email', value),
                  ),
                  const SizedBox(height: 16),
                  _buildNotificationToggle(
                    'Push Notifications',
                    'Receive push notifications on your device',
                    Icons.notifications_outlined,
                    widget.settings['push'] ?? false,
                    (value) => widget.onSettingChanged('push', value),
                  ),
                  const SizedBox(height: 16),
                  _buildNotificationToggle(
                    'In-App Alerts',
                    'Show notifications within the app',
                    Icons.info_outlined,
                    widget.settings['inApp'] ?? false,
                    (value) => widget.onSettingChanged('inApp', value),
                  ),
                  const SizedBox(height: 20),

                  // Bulk Actions
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: widget.onEnableAll,
                          style: OutlinedButton.styleFrom(
                            side: BorderSide(color: AppTheme.border),
                            padding: EdgeInsets.symmetric(vertical: 12),
                          ),
                          child: Text(
                            'Enable All',
                            style: GoogleFonts.inter(
                              fontSize: 14,
                              color: AppTheme.primaryText,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: OutlinedButton(
                          onPressed: widget.onDisableAll,
                          style: OutlinedButton.styleFrom(
                            side: BorderSide(color: AppTheme.border),
                            padding: EdgeInsets.symmetric(vertical: 12),
                          ),
                          child: Text(
                            'Disable All',
                            style: GoogleFonts.inter(
                              fontSize: 14,
                              color: AppTheme.primaryText,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildNotificationToggle(
    String title,
    String description,
    IconData icon,
    bool value,
    Function(bool) onChanged,
  ) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.primaryBackground,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppTheme.border),
      ),
      child: Row(
        children: [
          Icon(
            icon,
            color: AppTheme.secondaryText,
            size: 20,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: AppTheme.primaryText,
                  ),
                ),
                Text(
                  description,
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    color: AppTheme.secondaryText,
                  ),
                ),
              ],
            ),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }
}
