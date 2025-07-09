import '../../core/app_export.dart';
import '../../services/notification_data_service.dart';
import '../../services/workspace_service.dart';
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
  bool _isLoading = false;
  
  final NotificationDataService _notificationService = NotificationDataService();
  final WorkspaceService _workspaceService = WorkspaceService();
  
  String? _currentWorkspaceId;
  String? _currentUserId;

  // Notification Categories
  Map<String, Map<String, bool>> _notificationSettings = {};

  // Quiet Hours
  TimeOfDay _quietHoursStart = TimeOfDay(hour: 22, minute: 0);
  TimeOfDay _quietHoursEnd = TimeOfDay(hour: 8, minute: 0);
  bool _quietHoursEnabled = false;
  String _selectedTimezone = 'UTC';

  @override
  void initState() {
    super.initState();
    _loadNotificationSettings();
  }

  Future<void> _loadNotificationSettings() async {
    setState(() {
      _isLoading = true;
    });

    try {
      // Get current workspace and user
      final workspaces = await _workspaceService.getUserWorkspaces();
      if (workspaces.isNotEmpty) {
        _currentWorkspaceId = workspaces.first['id'];
        _currentUserId = workspaces.first['user_id'];
        
        // Load notification settings
        final settings = await _notificationService.getNotificationSettings(
          _currentUserId!,
          _currentWorkspaceId!,
        );
        
        setState(() {
          _notificationSettings = Map<String, Map<String, bool>>.from(
            settings['notification_settings'] ?? {},
          );
          _quietHoursEnabled = settings['quiet_hours_enabled'] ?? false;
          _quietHoursStart = _parseTime(settings['quiet_hours_start'] ?? '22:00') ?? TimeOfDay(hour: 22, minute: 0);
          _quietHoursEnd = _parseTime(settings['quiet_hours_end'] ?? '08:00') ?? TimeOfDay(hour: 8, minute: 0);
          _selectedTimezone = settings['timezone'] ?? 'UTC';
        });
      }
    } catch (e) {
      if (kDebugMode) {
        debugPrint('Failed to load notification settings: $e');
      }
      _setDefaultSettings();
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _setDefaultSettings() {
    setState(() {
      _notificationSettings = {
        'workspace': {'email': true, 'push': true, 'inApp': true},
        'social_media': {'email': false, 'push': true, 'inApp': true},
        'crm': {'email': true, 'push': true, 'inApp': true},
        'courses': {'email': true, 'push': false, 'inApp': true},
        'marketplace': {'email': true, 'push': true, 'inApp': true},
        'financial': {'email': true, 'push': true, 'inApp': true},
        'system': {'email': true, 'push': false, 'inApp': true},
      };
    });
  }

  TimeOfDay? _parseTime(String timeString) {
    try {
      final parts = timeString.split(':');
      if (parts.length == 2) {
        final hour = int.parse(parts[0]);
        final minute = int.parse(parts[1]);
        return TimeOfDay(hour: hour, minute: minute);
      }
    } catch (e) {
      if (kDebugMode) {
        debugPrint('Failed to parse time: $e');
      }
    }
    return null;
  }

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
    _setDefaultSettings();
    setState(() {
      _quietHoursEnabled = false;
      _quietHoursStart = TimeOfDay(hour: 22, minute: 0);
      _quietHoursEnd = TimeOfDay(hour: 8, minute: 0);
      _selectedTimezone = 'UTC';
      _hasChanges = true;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Notification settings reset to defaults'),
        backgroundColor: AppTheme.success,
      ),
    );
  }

  Future<void> _saveChanges() async {
    if (_currentUserId == null || _currentWorkspaceId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Unable to save settings. Please try again.'),
          backgroundColor: AppTheme.error,
        ),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final success = await _notificationService.updateNotificationSettings(
        _currentUserId!,
        _currentWorkspaceId!,
        _notificationSettings,
        quietHoursEnabled: _quietHoursEnabled,
        quietHoursStart: '${_quietHoursStart.hour.toString().padLeft(2, '0')}:${_quietHoursStart.minute.toString().padLeft(2, '0')}',
        quietHoursEnd: '${_quietHoursEnd.hour.toString().padLeft(2, '0')}:${_quietHoursEnd.minute.toString().padLeft(2, '0')}',
        timezone: _selectedTimezone,
      );

      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Notification settings saved successfully'),
            backgroundColor: AppTheme.success,
          ),
        );
        setState(() {
          _hasChanges = false;
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to save notification settings'),
            backgroundColor: AppTheme.error,
          ),
        );
      }
    } catch (e) {
      if (kDebugMode) {
        debugPrint('Failed to save notification settings: $e');
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error saving notification settings'),
          backgroundColor: AppTheme.error,
        ),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
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
          // Loading overlay
          if (_isLoading)
            Container(
              color: AppTheme.primaryBackground.withAlpha(204),
              child: const Center(
                child: CircularProgressIndicator(),
              ),
            ),
          
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
                  settings: _notificationSettings['workspace'] ?? {'email': true, 'push': true, 'inApp': true},
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
                  settings: _notificationSettings['social_media'] ?? {'email': false, 'push': true, 'inApp': true},
                  onSettingChanged: (type, value) =>
                      _onSettingChanged('social_media', type, value),
                  onEnableAll: () => _enableAllCategory('social_media'),
                  onDisableAll: () => _disableAllCategory('social_media'),
                ),

                const SizedBox(height: 16),

                // CRM & Leads
                NotificationCategoryWidget(
                  title: 'CRM & Leads',
                  description:
                      'New leads, pipeline updates, and email campaign results',
                  icon: Icons.people_outline,
                  settings: _notificationSettings['crm'] ?? {'email': true, 'push': true, 'inApp': true},
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
                  settings: _notificationSettings['courses'] ?? {'email': true, 'push': false, 'inApp': true},
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
                  settings: _notificationSettings['marketplace'] ?? {'email': true, 'push': true, 'inApp': true},
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
                  settings: _notificationSettings['financial'] ?? {'email': true, 'push': true, 'inApp': true},
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
                  settings: _notificationSettings['system'] ?? {'email': true, 'push': false, 'inApp': true},
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