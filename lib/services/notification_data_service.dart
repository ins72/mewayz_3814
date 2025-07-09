import '../core/app_export.dart';

/// Service for handling notification data operations with Supabase
class NotificationDataService {
  static final NotificationDataService _instance = NotificationDataService._internal();
  factory NotificationDataService() => _instance;
  NotificationDataService._internal();

  final SupabaseService _supabaseService = SupabaseService();

  /// Get notification settings for user
  Future<Map<String, dynamic>> getNotificationSettings(String userId, String workspaceId) async {
    try {
      final client = await _supabaseService.client;
      
      final response = await client
          .from('notification_settings')
          .select()
          .eq('user_id', userId)
          .eq('workspace_id', workspaceId);
      
      final settings = List<Map<String, dynamic>>.from(response);
      
      // Convert to format expected by UI
      final settingsMap = <String, Map<String, bool>>{};
      
      for (final setting in settings) {
        final type = setting['notification_type'] as String;
        settingsMap[type] = {
          'email': setting['email_enabled'] as bool,
          'push': setting['push_enabled'] as bool,
          'inApp': setting['in_app_enabled'] as bool,
        };
      }
      
      // Add default settings for missing types
      final defaultTypes = ['workspace', 'social_media', 'crm', 'marketplace', 'courses', 'financial', 'system'];
      for (final type in defaultTypes) {
        if (!settingsMap.containsKey(type)) {
          settingsMap[type] = {
            'email': true,
            'push': true,
            'inApp': true,
          };
        }
      }
      
      return {
        'notification_settings': settingsMap,
        'quiet_hours_enabled': settings.isNotEmpty ? settings.first['quiet_hours_enabled'] : false,
        'quiet_hours_start': settings.isNotEmpty ? settings.first['quiet_hours_start'] : '22:00',
        'quiet_hours_end': settings.isNotEmpty ? settings.first['quiet_hours_end'] : '08:00',
        'timezone': settings.isNotEmpty ? settings.first['timezone'] : 'UTC',
      };
    } catch (e) {
      if (kDebugMode) {
        debugPrint('Failed to get notification settings: $e');
      }
      return _getDefaultNotificationSettings();
    }
  }

  /// Update notification settings
  Future<bool> updateNotificationSettings(
    String userId,
    String workspaceId,
    Map<String, Map<String, bool>> settings,
    {bool? quietHoursEnabled, String? quietHoursStart, String? quietHoursEnd, String? timezone}
  ) async {
    try {
      final client = await _supabaseService.client;
      
      // Update each notification type setting
      for (final entry in settings.entries) {
        final notificationType = entry.key;
        final typeSettings = entry.value;
        
        await client
            .from('notification_settings')
            .upsert({
              'user_id': userId,
              'workspace_id': workspaceId,
              'notification_type': notificationType,
              'email_enabled': typeSettings['email'] ?? true,
              'push_enabled': typeSettings['push'] ?? true,
              'in_app_enabled': typeSettings['inApp'] ?? true,
              'quiet_hours_enabled': quietHoursEnabled ?? false,
              'quiet_hours_start': quietHoursStart ?? '22:00',
              'quiet_hours_end': quietHoursEnd ?? '08:00',
              'timezone': timezone ?? 'UTC',
            });
      }
      
      if (kDebugMode) {
        debugPrint('Notification settings updated successfully');
      }
      
      return true;
    } catch (e) {
      if (kDebugMode) {
        debugPrint('Failed to update notification settings: $e');
      }
      return false;
    }
  }

  /// Send notification
  Future<bool> sendNotification(
    String userId,
    String workspaceId,
    String notificationType,
    String title,
    String message,
    {Map<String, dynamic>? data, String priority = 'medium'}
  ) async {
    try {
      final client = await _supabaseService.client;
      
      final response = await client.rpc('send_notification', params: {
        'user_uuid': userId,
        'workspace_uuid': workspaceId,
        'notification_type_param': notificationType,
        'title_param': title,
        'message_param': message,
        'data_param': data ?? {},
        'priority_param': priority,
      });
      
      if (response != null) {
        if (kDebugMode) {
          debugPrint('Notification sent: $title');
        }
        return true;
      }
      
      return false;
    } catch (e) {
      if (kDebugMode) {
        debugPrint('Failed to send notification: $e');
      }
      return false;
    }
  }

  /// Get notifications for user
  Future<List<Map<String, dynamic>>> getNotifications(
    String userId,
    String workspaceId,
    {int limit = 50, bool unreadOnly = false}
  ) async {
    try {
      final client = await _supabaseService.client;
      
      var query = client
          .from('notifications')
          .select()
          .eq('user_id', userId)
          .eq('workspace_id', workspaceId);
      
      if (unreadOnly) {
        query = query.isFilter('read_at', null);
      }
      
      final response = await query
          .order('created_at', ascending: false)
          .limit(limit);
      
      return List<Map<String, dynamic>>.from(response);
    } catch (e) {
      if (kDebugMode) {
        debugPrint('Failed to get notifications: $e');
      }
      return [];
    }
  }

  /// Mark notification as read
  Future<bool> markNotificationAsRead(String notificationId) async {
    try {
      final client = await _supabaseService.client;
      
      await client
          .from('notifications')
          .update({'read_at': DateTime.now().toIso8601String()})
          .eq('id', notificationId);
      
      if (kDebugMode) {
        debugPrint('Notification marked as read: $notificationId');
      }
      
      return true;
    } catch (e) {
      if (kDebugMode) {
        debugPrint('Failed to mark notification as read: $e');
      }
      return false;
    }
  }

  /// Mark all notifications as read
  Future<bool> markAllNotificationsAsRead(String userId, String workspaceId) async {
    try {
      final client = await _supabaseService.client;
      
      await client
          .from('notifications')
          .update({'read_at': DateTime.now().toIso8601String()})
          .eq('user_id', userId)
          .eq('workspace_id', workspaceId)
          .isFilter('read_at', null);
      
      if (kDebugMode) {
        debugPrint('All notifications marked as read');
      }
      
      return true;
    } catch (e) {
      if (kDebugMode) {
        debugPrint('Failed to mark all notifications as read: $e');
      }
      return false;
    }
  }

  /// Delete notification
  Future<bool> deleteNotification(String notificationId) async {
    try {
      final client = await _supabaseService.client;
      
      await client
          .from('notifications')
          .delete()
          .eq('id', notificationId);
      
      if (kDebugMode) {
        debugPrint('Notification deleted: $notificationId');
      }
      
      return true;
    } catch (e) {
      if (kDebugMode) {
        debugPrint('Failed to delete notification: $e');
      }
      return false;
    }
  }

  /// Save notification token
  Future<bool> saveNotificationToken(String userId, String token, String platform) async {
    try {
      final client = await _supabaseService.client;
      
      await client
          .from('notification_tokens')
          .upsert({
            'user_id': userId,
            'token': token,
            'platform': platform,
            'is_active': true,
          });
      
      if (kDebugMode) {
        debugPrint('Notification token saved: $platform');
      }
      
      return true;
    } catch (e) {
      if (kDebugMode) {
        debugPrint('Failed to save notification token: $e');
      }
      return false;
    }
  }

  /// Get notification statistics
  Future<Map<String, dynamic>> getNotificationStats(String userId, String workspaceId) async {
    try {
      final client = await _supabaseService.client;
      
      final response = await client
          .from('notifications')
          .select('id, status, read_at, created_at')
          .eq('user_id', userId)
          .eq('workspace_id', workspaceId);
      
      final notifications = List<Map<String, dynamic>>.from(response);
      
      final stats = {
        'total_notifications': notifications.length,
        'unread_notifications': notifications.where((n) => n['read_at'] == null).length,
        'read_notifications': notifications.where((n) => n['read_at'] != null).length,
        'notifications_by_status': <String, int>{},
        'recent_notifications': notifications.take(5).toList(),
      };
      
      // Count by status
      for (final notification in notifications) {
        final status = notification['status'] as String;
        final statusMap = stats['notifications_by_status'] as Map<String, int>;
        statusMap[status] = (statusMap[status] ?? 0) + 1;
      }
      
      return stats;
    } catch (e) {
      if (kDebugMode) {
        debugPrint('Failed to get notification stats: $e');
      }
      return {
        'total_notifications': 0,
        'unread_notifications': 0,
        'read_notifications': 0,
        'notifications_by_status': {},
        'recent_notifications': [],
      };
    }
  }

  /// Get real-time notifications
  Stream<List<Map<String, dynamic>>> getRealtimeNotifications(String userId, String workspaceId) async* {
    try {
      final client = await _supabaseService.client;
      
      // Listen to workspace notifications
      yield* SupabaseService().client
          .from('notifications')
          .stream(primaryKey: ['id'])
          .eq('workspace_id', workspaceId)
          .map((data) {
            return data.map((item) => Map<String, dynamic>.from(item)).toList();
          });

    } catch (e) {
      if (kDebugMode) {
        debugPrint('Failed to get real-time notifications: $e');
      }
      yield [];
    }
  }

  /// Schedule notification
  Future<bool> scheduleNotification(
    String userId,
    String workspaceId,
    String notificationType,
    String title,
    String message,
    DateTime scheduledFor,
    {Map<String, dynamic>? data, String priority = 'medium'}
  ) async {
    try {
      final client = await _supabaseService.client;
      
      await client.from('notifications').insert({
        'user_id': userId,
        'workspace_id': workspaceId,
        'notification_type': notificationType,
        'title': title,
        'message': message,
        'data': data ?? {},
        'priority': priority,
        'status': 'pending',
        'scheduled_for': scheduledFor.toIso8601String(),
      });
      
      if (kDebugMode) {
        debugPrint('Notification scheduled: $title for ${scheduledFor.toIso8601String()}');
      }
      
      return true;
    } catch (e) {
      if (kDebugMode) {
        debugPrint('Failed to schedule notification: $e');
      }
      return false;
    }
  }

  /// Send bulk notifications
  Future<bool> sendBulkNotifications(
    List<String> userIds,
    String workspaceId,
    String notificationType,
    String title,
    String message,
    {Map<String, dynamic>? data, String priority = 'medium'}
  ) async {
    try {
      final client = await _supabaseService.client;
      
      final notifications = userIds.map((userId) => {
        'user_id': userId,
        'workspace_id': workspaceId,
        'notification_type': notificationType,
        'title': title,
        'message': message,
        'data': data ?? {},
        'priority': priority,
        'status': 'pending',
      }).toList();
      
      await client.from('notifications').insert(notifications);
      
      if (kDebugMode) {
        debugPrint('Bulk notifications sent: ${userIds.length} recipients');
      }
      
      return true;
    } catch (e) {
      if (kDebugMode) {
        debugPrint('Failed to send bulk notifications: $e');
      }
      return false;
    }
  }

  /// Get default notification settings
  Map<String, dynamic> _getDefaultNotificationSettings() {
    return {
      'notification_settings': {
        'workspace': {'email': true, 'push': true, 'inApp': true},
        'social_media': {'email': true, 'push': true, 'inApp': true},
        'crm': {'email': true, 'push': true, 'inApp': true},
        'marketplace': {'email': true, 'push': true, 'inApp': true},
        'courses': {'email': true, 'push': true, 'inApp': true},
        'financial': {'email': true, 'push': true, 'inApp': true},
        'system': {'email': true, 'push': false, 'inApp': true},
      },
      'quiet_hours_enabled': false,
      'quiet_hours_start': '22:00',
      'quiet_hours_end': '08:00',
      'timezone': 'UTC',
    };
  }
}