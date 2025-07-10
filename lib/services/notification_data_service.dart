import 'package:supabase_flutter/supabase_flutter.dart';

import '../core/app_export.dart';

/// Service for handling notification data operations with Supabase
class NotificationDataService {
  static final NotificationDataService _instance = NotificationDataService._internal();
  late final SupabaseClient _client;
  bool _isInitialized = false;

  factory NotificationDataService() {
    return _instance;
  }

  NotificationDataService._internal();

  Future<void> initialize() async {
    if (_isInitialized) return;
    
    try {
      final supabaseService = SupabaseService();
      _client = await supabaseService.client;
      _isInitialized = true;
    } catch (e) {
      debugPrint('Failed to initialize NotificationDataService: $e');
      rethrow;
    }
  }

  Future<void> _ensureInitialized() async {
    if (!_isInitialized) {
      await initialize();
    }
  }

  Future<List<Map<String, dynamic>>> getNotifications() async {
    try {
      await _ensureInitialized();
      
      final response = await _client
          .from('notifications')
          .select('*')
          .order('created_at', ascending: false);

      return List<Map<String, dynamic>>.from(response);
    } catch (e) {
      debugPrint('Failed to get notifications: $e');
      return [];
    }
  }

  Future<Map<String, dynamic>?> getNotificationSettings(String userId) async {
    try {
      await _ensureInitialized();
      
      final response = await _client
          .from('user_notification_settings')
          .select('*')
          .eq('user_id', userId)
          .single();

      return response;
    } catch (e) {
      debugPrint('Failed to get notification settings: $e');
      return null;
    }
  }

  // NEW: Alias method for compatibility
  Future<Map<String, dynamic>?> getSettings(String userId) async {
    return await getNotificationSettings(userId);
  }

  Future<bool> updateNotificationSettings(String userId, Map<String, dynamic> settings) async {
    try {
      await _ensureInitialized();
      
      await _client
          .from('user_notification_settings')
          .upsert({
            'user_id': userId,
            ...settings,
            'updated_at': DateTime.now().toIso8601String(),
          });

      return true;
    } catch (e) {
      debugPrint('Failed to update notification settings: $e');
      return false;
    }
  }

  // NEW: Alias method for compatibility
  Future<bool> updateSettings(String userId, Map<String, dynamic> settings) async {
    return await updateNotificationSettings(userId, settings);
  }
}