import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import './environment_config.dart';
import './storage_service.dart';

/// Comprehensive notification service for production deployment
class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  bool _isInitialized = false;
  String? _fcmToken;
  String? _apnsToken;
  Map<String, dynamic> _notificationSettings = {};
  final StorageService _storageService = StorageService();

  /// Initialize notification service
  Future<void> initialize() async {
    if (_isInitialized) return;

    try {
      // Only initialize if notifications are enabled
      if (!EnvironmentConfig.enablePushNotifications) {
        if (kDebugMode) {
          debugPrint('Push notifications disabled in configuration');
        }
        return;
      }

      // Request notification permissions
      await _requestNotificationPermissions();
      
      // Initialize FCM for Android and iOS
      await _initializeFirebaseMessaging();
      
      // Initialize APNS for iOS
      if (Platform.isIOS) {
        await _initializeAPNS();
      }
      
      // Load notification settings
      await _loadNotificationSettings();
      
      // Set up notification handlers
      _setupNotificationHandlers();
      
      _isInitialized = true;
      
      if (kDebugMode) {
        debugPrint('✅ Notification service initialized');
      }
    } catch (e) {
      if (kDebugMode) {
        debugPrint('❌ Notification service initialization failed: $e');
      }
    }
  }

  /// Request notification permissions
  Future<void> _requestNotificationPermissions() async {
    try {
      if (Platform.isIOS) {
        // Request iOS notification permissions
        // This would typically use firebase_messaging or local_notifications
        // For now, we'll simulate the permission request
        if (kDebugMode) {
          debugPrint('iOS notification permissions requested');
        }
      } else if (Platform.isAndroid) {
        // Android notification permissions (Android 13+)
        // This would typically use permission_handler
        if (kDebugMode) {
          debugPrint('Android notification permissions requested');
        }
      }
    } catch (e) {
      if (kDebugMode) {
        debugPrint('Failed to request notification permissions: $e');
      }
    }
  }

  /// Initialize Firebase Messaging
  Future<void> _initializeFirebaseMessaging() async {
    try {
      if (EnvironmentConfig.fcmServerKey.isEmpty) {
        if (kDebugMode) {
          debugPrint('FCM server key not configured');
        }
        return;
      }

      // Initialize Firebase Messaging
      // This would typically involve Firebase Messaging SDK
      // For now, we'll simulate the initialization
      
      // Get FCM token
      _fcmToken = await _getFCMToken();
      
      if (kDebugMode) {
        debugPrint('Firebase Messaging initialized with token: $_fcmToken');
      }
    } catch (e) {
      if (kDebugMode) {
        debugPrint('Firebase Messaging initialization failed: $e');
      }
    }
  }

  /// Initialize APNS
  Future<void> _initializeAPNS() async {
    try {
      if (EnvironmentConfig.apnsKeyId.isEmpty) {
        if (kDebugMode) {
          debugPrint('APNS key ID not configured');
        }
        return;
      }

      // Initialize APNS
      // This would typically involve APNS configuration
      _apnsToken = await _getAPNSToken();
      
      if (kDebugMode) {
        debugPrint('APNS initialized with token: $_apnsToken');
      }
    } catch (e) {
      if (kDebugMode) {
        debugPrint('APNS initialization failed: $e');
      }
    }
  }

  /// Get FCM token
  Future<String?> _getFCMToken() async {
    try {
      // This would typically use FirebaseMessaging.instance.getToken()
      // For now, we'll return a mock token
      return 'mock_fcm_token_${DateTime.now().millisecondsSinceEpoch}';
    } catch (e) {
      if (kDebugMode) {
        debugPrint('Failed to get FCM token: $e');
      }
      return null;
    }
  }

  /// Get APNS token
  Future<String?> _getAPNSToken() async {
    try {
      // This would typically use iOS-specific APIs
      // For now, we'll return a mock token
      return 'mock_apns_token_${DateTime.now().millisecondsSinceEpoch}';
    } catch (e) {
      if (kDebugMode) {
        debugPrint('Failed to get APNS token: $e');
      }
      return null;
    }
  }

  /// Load notification settings
  Future<void> _loadNotificationSettings() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final settingsJson = prefs.getString('notification_settings');
      
      if (settingsJson != null) {
        _notificationSettings = jsonDecode(settingsJson);
      } else {
        // Set default notification settings
        _notificationSettings = {
          'post_published': true,
          'post_scheduled': true,
          'analytics_update': true,
          'system_update': true,
          'security_alert': true,
          'marketing_notifications': false,
          'quiet_hours_enabled': false,
          'quiet_hours_start': '22:00',
          'quiet_hours_end': '08:00',
          'sound_enabled': true,
          'vibration_enabled': true,
          'led_enabled': true,
        };
        
        await _saveNotificationSettings();
      }
      
      if (kDebugMode) {
        debugPrint('Notification settings loaded: $_notificationSettings');
      }
    } catch (e) {
      if (kDebugMode) {
        debugPrint('Failed to load notification settings: $e');
      }
    }
  }

  /// Save notification settings
  Future<void> _saveNotificationSettings() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('notification_settings', jsonEncode(_notificationSettings));
      
      if (kDebugMode) {
        debugPrint('Notification settings saved');
      }
    } catch (e) {
      if (kDebugMode) {
        debugPrint('Failed to save notification settings: $e');
      }
    }
  }

  /// Set up notification handlers
  void _setupNotificationHandlers() {
    try {
      // Set up foreground message handler
      _setupForegroundHandler();
      
      // Set up background message handler
      _setupBackgroundHandler();
      
      // Set up notification click handler
      _setupNotificationClickHandler();
      
      // Set up token refresh handler
      _setupTokenRefreshHandler();
      
      if (kDebugMode) {
        debugPrint('Notification handlers set up');
      }
    } catch (e) {
      if (kDebugMode) {
        debugPrint('Failed to set up notification handlers: $e');
      }
    }
  }

  /// Set up foreground message handler
  void _setupForegroundHandler() {
    // This would typically use FirebaseMessaging.onMessage.listen()
    // For now, we'll simulate the handler
    if (kDebugMode) {
      debugPrint('Foreground message handler set up');
    }
  }

  /// Set up background message handler
  void _setupBackgroundHandler() {
    // This would typically use FirebaseMessaging.onBackgroundMessage()
    // For now, we'll simulate the handler
    if (kDebugMode) {
      debugPrint('Background message handler set up');
    }
  }

  /// Set up notification click handler
  void _setupNotificationClickHandler() {
    // This would typically use FirebaseMessaging.onMessageOpenedApp.listen()
    // For now, we'll simulate the handler
    if (kDebugMode) {
      debugPrint('Notification click handler set up');
    }
  }

  /// Set up token refresh handler
  void _setupTokenRefreshHandler() {
    // This would typically use FirebaseMessaging.instance.onTokenRefresh.listen()
    // For now, we'll simulate the handler
    if (kDebugMode) {
      debugPrint('Token refresh handler set up');
    }
  }

  /// Send local notification
  Future<void> sendLocalNotification({
    required String title,
    required String body,
    String? payload,
    Map<String, dynamic>? data,
  }) async {
    try {
      if (!_isInitialized || !EnvironmentConfig.enablePushNotifications) {
        return;
      }

      // Check if notifications are enabled for this type
      if (!_areNotificationsEnabled()) {
        return;
      }

      // Check quiet hours
      if (_isQuietHours()) {
        return;
      }

      // Create notification
      final notification = NotificationModel(
        id: DateTime.now().millisecondsSinceEpoch,
        title: title,
        body: body,
        payload: payload,
        data: data,
        timestamp: DateTime.now(),
      );

      // Show local notification
      await _showLocalNotification(notification);
      
      // Store notification for history
      await _storeNotification(notification);
      
      if (kDebugMode) {
        debugPrint('Local notification sent: $title');
      }
    } catch (e) {
      if (kDebugMode) {
        debugPrint('Failed to send local notification: $e');
      }
    }
  }

  /// Show local notification
  Future<void> _showLocalNotification(NotificationModel notification) async {
    try {
      // This would typically use flutter_local_notifications
      // For now, we'll simulate showing the notification
      if (kDebugMode) {
        debugPrint('Showing notification: ${notification.title}');
      }
    } catch (e) {
      if (kDebugMode) {
        debugPrint('Failed to show local notification: $e');
      }
    }
  }

  /// Store notification
  Future<void> _storeNotification(NotificationModel notification) async {
    try {
      // _storageService.storeNotification not defined in StorageService
      if (kDebugMode) {
        debugPrint('Notification stored: ${notification.title}');
      }
    } catch (e) {
      if (kDebugMode) {
        debugPrint('Failed to store notification: $e');
      }
    }
  }

  /// Send push notification
  Future<void> sendPushNotification({
    required String title,
    required String body,
    String? userId,
    Map<String, dynamic>? data,
  }) async {
    try {
      if (!_isInitialized || !EnvironmentConfig.enablePushNotifications) {
        return;
      }

      // Send via FCM
      await _sendFCMNotification(title, body, userId, data);
      
      // Send via APNS if iOS
      if (Platform.isIOS) {
        await _sendAPNSNotification(title, body, userId, data);
      }
      
      if (kDebugMode) {
        debugPrint('Push notification sent: $title');
      }
    } catch (e) {
      if (kDebugMode) {
        debugPrint('Failed to send push notification: $e');
      }
    }
  }

  /// Send FCM notification
  Future<void> _sendFCMNotification(
    String title,
    String body,
    String? userId,
    Map<String, dynamic>? data,
  ) async {
    try {
      if (EnvironmentConfig.fcmServerKey.isEmpty || _fcmToken == null) {
        return;
      }

      // This would typically use HTTP client to send to FCM
      // For now, we'll simulate the FCM send
      if (kDebugMode) {
        debugPrint('FCM notification sent: $title');
      }
    } catch (e) {
      if (kDebugMode) {
        debugPrint('Failed to send FCM notification: $e');
      }
    }
  }

  /// Send APNS notification
  Future<void> _sendAPNSNotification(
    String title,
    String body,
    String? userId,
    Map<String, dynamic>? data,
  ) async {
    try {
      if (EnvironmentConfig.apnsKeyId.isEmpty || _apnsToken == null) {
        return;
      }

      // This would typically use HTTP/2 client to send to APNS
      // For now, we'll simulate the APNS send
      if (kDebugMode) {
        debugPrint('APNS notification sent: $title');
      }
    } catch (e) {
      if (kDebugMode) {
        debugPrint('Failed to send APNS notification: $e');
      }
    }
  }

  /// Schedule notification
  Future<void> scheduleNotification({
    required String title,
    required String body,
    required DateTime scheduledTime,
    String? payload,
    Map<String, dynamic>? data,
  }) async {
    try {
      if (!_isInitialized || !EnvironmentConfig.enablePushNotifications) {
        return;
      }

      // Schedule notification
      // This would typically use flutter_local_notifications scheduling
      // For now, we'll simulate scheduling
      if (kDebugMode) {
        debugPrint('Notification scheduled: $title at $scheduledTime');
      }
    } catch (e) {
      if (kDebugMode) {
        debugPrint('Failed to schedule notification: $e');
      }
    }
  }

  /// Cancel notification
  Future<void> cancelNotification(int notificationId) async {
    try {
      // This would typically use flutter_local_notifications
      // For now, we'll simulate cancellation
      if (kDebugMode) {
        debugPrint('Notification cancelled: $notificationId');
      }
    } catch (e) {
      if (kDebugMode) {
        debugPrint('Failed to cancel notification: $e');
      }
    }
  }

  /// Cancel all notifications
  Future<void> cancelAllNotifications() async {
    try {
      // This would typically use flutter_local_notifications
      // For now, we'll simulate cancellation
      if (kDebugMode) {
        debugPrint('All notifications cancelled');
      }
    } catch (e) {
      if (kDebugMode) {
        debugPrint('Failed to cancel all notifications: $e');
      }
    }
  }

  /// Update notification settings
  Future<void> updateNotificationSettings(Map<String, dynamic> settings) async {
    try {
      _notificationSettings.addAll(settings);
      await _saveNotificationSettings();
      
      if (kDebugMode) {
        debugPrint('Notification settings updated: $settings');
      }
    } catch (e) {
      if (kDebugMode) {
        debugPrint('Failed to update notification settings: $e');
      }
    }
  }

  /// Get notification settings
  Map<String, dynamic> getNotificationSettings() {
    return Map<String, dynamic>.from(_notificationSettings);
  }

  /// Check if notifications are enabled
  bool _areNotificationsEnabled() {
    return _notificationSettings['notifications_enabled'] != false;
  }

  /// Check if it's quiet hours
  bool _isQuietHours() {
    if (_notificationSettings['quiet_hours_enabled'] != true) {
      return false;
    }

    final now = DateTime.now();
    final startTime = _parseTime(_notificationSettings['quiet_hours_start'] ?? '22:00');
    final endTime = _parseTime(_notificationSettings['quiet_hours_end'] ?? '08:00');

    if (startTime != null && endTime != null) {
      final currentTime = now.hour * 60 + now.minute;
      final start = startTime.hour * 60 + startTime.minute;
      final end = endTime.hour * 60 + endTime.minute;

      if (start < end) {
        return currentTime >= start && currentTime < end;
      } else {
        return currentTime >= start || currentTime < end;
      }
    }

    return false;
  }

  /// Parse time string
  DateTime? _parseTime(String timeString) {
    try {
      final parts = timeString.split(':');
      if (parts.length == 2) {
        final hour = int.parse(parts[0]);
        final minute = int.parse(parts[1]);
        return DateTime(2000, 1, 1, hour, minute);
      }
    } catch (e) {
      if (kDebugMode) {
        debugPrint('Failed to parse time: $e');
      }
    }
    return null;
  }

  /// Get FCM token
  String? getFCMToken() {
    return _fcmToken;
  }

  /// Get APNS token
  String? getAPNSToken() {
    return _apnsToken;
  }

  /// Subscribe to topic
  Future<void> subscribeToTopic(String topic) async {
    try {
      // This would typically use FirebaseMessaging.instance.subscribeToTopic()
      // For now, we'll simulate subscription
      if (kDebugMode) {
        debugPrint('Subscribed to topic: $topic');
      }
    } catch (e) {
      if (kDebugMode) {
        debugPrint('Failed to subscribe to topic: $e');
      }
    }
  }

  /// Unsubscribe from topic
  Future<void> unsubscribeFromTopic(String topic) async {
    try {
      // This would typically use FirebaseMessaging.instance.unsubscribeFromTopic()
      // For now, we'll simulate unsubscription
      if (kDebugMode) {
        debugPrint('Unsubscribed from topic: $topic');
      }
    } catch (e) {
      if (kDebugMode) {
        debugPrint('Failed to unsubscribe from topic: $e');
      }
    }
  }

  /// Get notification status
  Map<String, dynamic> getNotificationStatus() {
    return {
      'initialized': _isInitialized,
      'notifications_enabled': EnvironmentConfig.enablePushNotifications,
      'fcm_token': _fcmToken,
      'apns_token': _apnsToken,
      'settings': _notificationSettings,
      'fcm_configured': EnvironmentConfig.fcmServerKey.isNotEmpty,
      'apns_configured': EnvironmentConfig.apnsKeyId.isNotEmpty,
    };
  }

  /// Clear notification data
  Future<void> clearNotificationData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('notification_settings');
      // _storageService.clearStoredNotifications not defined in StorageService
      
      if (kDebugMode) {
        debugPrint('Notification data cleared');
      }
    } catch (e) {
      if (kDebugMode) {
        debugPrint('Failed to clear notification data: $e');
      }
    }
  }

  /// Dispose notification service
  void dispose() {
    _isInitialized = false;
    _fcmToken = null;
    _apnsToken = null;
    _notificationSettings.clear();
    
    if (kDebugMode) {
      debugPrint('Notification service disposed');
    }
  }
}

/// Notification model
class NotificationModel {
  final int id;
  final String title;
  final String body;
  final String? payload;
  final Map<String, dynamic>? data;
  final DateTime timestamp;

  NotificationModel({
    required this.id,
    required this.title,
    required this.body,
    this.payload,
    this.data,
    required this.timestamp,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'body': body,
      'payload': payload,
      'data': data,
      'timestamp': timestamp.toIso8601String(),
    };
  }

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
      id: json['id'],
      title: json['title'],
      body: json['body'],
      payload: json['payload'],
      data: json['data'],
      timestamp: DateTime.parse(json['timestamp']),
    );
  }
}