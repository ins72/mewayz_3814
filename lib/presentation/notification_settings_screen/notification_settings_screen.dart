import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../core/app_export.dart';
import '../../theme/app_theme.dart';
import './widgets/notification_category_widget.dart';
import './widgets/notification_preview_widget.dart';
import './widgets/quiet_hours_widget.dart';

class NotificationSettingsScreen extends StatefulWidget {
  const NotificationSettingsScreen({Key? key}) : super(key: key);

  @override
  State<NotificationSettingsScreen> createState() =>
      _NotificationSettingsScreenState();
}

class _NotificationSettingsScreenState
    extends State<NotificationSettingsScreen> {
  bool _hasChanges = false;

  // Notification Categories
  Map<String, Map<String, bool>> _notificationSettings = {
    'workspace': {
      'email': true,
      'push': true,
      'inApp': true,
    },
    'social': {
      'email': false,
      'push': true,
      'inApp': true,
    },
    'crm': {
      'email': true,
      'push': true,
      'inApp': true,
    },
    'courses': {
      'email': true,
      'push': false,
      'inApp': true,
    },
    'marketplace': {
      'email': true,
      'push': true,
      'inApp': true,
    },
    'financial': {
      'email': true,
      'push': true,
      'inApp': true,
    },
    'system': {
      'email': true,
      'push': false,
      'inApp': true,
    },
  };

  // Quiet Hours
  TimeOfDay _quietHoursStart = TimeOfDay(hour: 22, minute: 0);
  TimeOfDay _quietHoursEnd = TimeOfDay(hour: 8, minute: 0);
  bool _quietHoursEnabled = false;
  String _selectedTimezone = 'UTC-5 (Eastern Time)';

  void _onSettingChanged(String category, String type, bool value) {
    setState(() {
      _notificationSettings[category]![type] = value;
      _hasChanges = true;
    });
  }

  void _onQuietHoursChanged(
      bool enabled, TimeOfDay? start, TimeOfDay? end, String? timezone) {
    setState(() {
      _quietHoursEnabled = enabled;
      if (start != null) _quietHoursStart = start;
      if (end != null) _quietHoursEnd = end;
      if (timezone != null) _selectedTimezone = timezone;
      _hasChanges = true;
    });
  }

  void _resetToDefaults() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppTheme.surface,
        title: Text(
          'Reset to Defaults',
          style: GoogleFonts.inter(
            color: AppTheme.primaryText,
            fontWeight: FontWeight.w600,
          ),
        ),
        content: Text(
          'Are you sure you want to reset all notification settings to their default values?',
          style: GoogleFonts.inter(
            color: AppTheme.secondaryText,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Cancel',
              style: GoogleFonts.inter(
                color: AppTheme.secondaryText,
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _resetSettings();
            },
            child: Text('Reset'),
          ),
        ],
      ),
    );
  }

  void _resetSettings() {
    setState(() {
      _notificationSettings = {
        'workspace': {'email': true, 'push': true, 'inApp': true},
        'social': {'email': false, 'push': true, 'inApp': true},
        'crm': {'email': true, 'push': true, 'inApp': true},
        'courses': {'email': true, 'push': false, 'inApp': true},
        'marketplace': {'email': true, 'push': true, 'inApp': true},
        'financial': {'email': true, 'push': true, 'inApp': true},
        'system': {'email': true, 'push': false, 'inApp': true},
      };
      _quietHoursEnabled = false;
      _quietHoursStart = TimeOfDay(hour: 22, minute: 0);
      _quietHoursEnd = TimeOfDay(hour: 8, minute: 0);
      _selectedTimezone = 'UTC-5 (Eastern Time)';
      _hasChanges = false;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Notification settings reset to defaults'),
        backgroundColor: AppTheme.success,
      ),
    );
  }

  void _saveChanges() {
    // TODO: Implement save logic
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Notification settings saved successfully'),
        backgroundColor: AppTheme.success,
      ),
    );
    setState(() {
      _hasChanges = false;
    });
  }

  void _enableAllCategory(String category) {
    setState(() {
      _notificationSettings[category]!.forEach((key, value) {
        _notificationSettings[category]![key] = true;
      });
      _hasChanges = true;
    });
  }

  void _disableAllCategory(String category) {
    setState(() {
      _notificationSettings[category]!.forEach((key, value) {
        _notificationSettings[category]![key] = false;
      });
      _hasChanges = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.primaryBackground,
      body: Stack(
        children: [
          // Main content
          SingleChildScrollView(
            padding: EdgeInsets.only(
              top: MediaQuery.of(context).padding.top + 60,
              bottom: 24,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Workspace Activity
                NotificationCategoryWidget(
                  title: 'Workspace Activity',
                  description:
                      'Team member activity, project updates, and mentions',
                  icon: Icons.groups_outlined,
                  settings: _notificationSettings['workspace']!,
                  onSettingChanged: (type, value) =>
                      _onSettingChanged('workspace', type, value),
                  onEnableAll: () => _enableAllCategory('workspace'),
                  onDisableAll: () => _disableAllCategory('workspace'),
                ),

                const SizedBox(height: 16),

                // Social Media
                NotificationCategoryWidget(
                  title: 'Social Media',
                  description:
                      'Post scheduling, engagement alerts, and follower milestones',
                  icon: Icons.share_outlined,
                  settings: _notificationSettings['social']!,
                  onSettingChanged: (type, value) =>
                      _onSettingChanged('social', type, value),
                  onEnableAll: () => _enableAllCategory('social'),
                  onDisableAll: () => _disableAllCategory('social'),
                ),

                const SizedBox(height: 16),

                // CRM & Leads
                NotificationCategoryWidget(
                  title: 'CRM & Leads',
                  description:
                      'New leads, pipeline updates, and email campaign results',
                  icon: Icons.people_outline,
                  settings: _notificationSettings['crm']!,
                  onSettingChanged: (type, value) =>
                      _onSettingChanged('crm', type, value),
                  onEnableAll: () => _enableAllCategory('crm'),
                  onDisableAll: () => _disableAllCategory('crm'),
                ),

                const SizedBox(height: 16),

                // Courses & Community
                NotificationCategoryWidget(
                  title: 'Courses & Community',
                  description:
                      'Student enrollments, completion certificates, and discussions',
                  icon: Icons.school_outlined,
                  settings: _notificationSettings['courses']!,
                  onSettingChanged: (type, value) =>
                      _onSettingChanged('courses', type, value),
                  onEnableAll: () => _enableAllCategory('courses'),
                  onDisableAll: () => _disableAllCategory('courses'),
                ),

                const SizedBox(height: 16),

                // Marketplace
                NotificationCategoryWidget(
                  title: 'Marketplace',
                  description:
                      'New orders, payment confirmations, and review notifications',
                  icon: Icons.store_outlined,
                  settings: _notificationSettings['marketplace']!,
                  onSettingChanged: (type, value) =>
                      _onSettingChanged('marketplace', type, value),
                  onEnableAll: () => _enableAllCategory('marketplace'),
                  onDisableAll: () => _disableAllCategory('marketplace'),
                ),

                const SizedBox(height: 16),

                // Financial
                NotificationCategoryWidget(
                  title: 'Financial',
                  description:
                      'Invoice payments, subscription renewals, and transactions',
                  icon: Icons.payment_outlined,
                  settings: _notificationSettings['financial']!,
                  onSettingChanged: (type, value) =>
                      _onSettingChanged('financial', type, value),
                  onEnableAll: () => _enableAllCategory('financial'),
                  onDisableAll: () => _disableAllCategory('financial'),
                ),

                const SizedBox(height: 16),

                // System Updates
                NotificationCategoryWidget(
                  title: 'System Updates',
                  description:
                      'Maintenance, feature announcements, and security alerts',
                  icon: Icons.system_update_outlined,
                  settings: _notificationSettings['system']!,
                  onSettingChanged: (type, value) =>
                      _onSettingChanged('system', type, value),
                  onEnableAll: () => _enableAllCategory('system'),
                  onDisableAll: () => _disableAllCategory('system'),
                ),

                const SizedBox(height: 32),

                // Quiet Hours
                QuietHoursWidget(
                  enabled: _quietHoursEnabled,
                  startTime: _quietHoursStart,
                  endTime: _quietHoursEnd,
                  selectedTimezone: _selectedTimezone,
                  onChanged: _onQuietHoursChanged,
                ),

                const SizedBox(height: 32),

                // Notification Preview
                NotificationPreviewWidget(
                  notificationSettings: _notificationSettings,
                ),

                const SizedBox(height: 100),
              ],
            ),
          ),

          // Header with reset button
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Container(
              height: MediaQuery.of(context).padding.top + 60,
              decoration: BoxDecoration(
                color: AppTheme.primaryBackground,
                border: Border(
                  bottom: BorderSide(
                    color: AppTheme.border,
                    width: 1,
                  ),
                ),
              ),
              child: SafeArea(
                child: Row(
                  children: [
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: Icon(
                        Icons.arrow_back_ios,
                        color: AppTheme.primaryText,
                        size: 20,
                      ),
                    ),
                    Expanded(
                      child: Text(
                        'Notification Settings',
                        style: GoogleFonts.inter(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: AppTheme.primaryText,
                        ),
                      ),
                    ),
                    TextButton(
                      onPressed: _resetToDefaults,
                      child: Text(
                        'Reset',
                        style: GoogleFonts.inter(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: AppTheme.accent,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    AnimatedContainer(
                      duration: Duration(milliseconds: 300),
                      child: ElevatedButton(
                        onPressed: _hasChanges ? _saveChanges : null,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: _hasChanges
                              ? AppTheme.primaryAction
                              : AppTheme.border,
                          foregroundColor: _hasChanges
                              ? AppTheme.primaryBackground
                              : AppTheme.secondaryText,
                          padding:
                              EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: Text(
                          'Save',
                          style: GoogleFonts.inter(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
