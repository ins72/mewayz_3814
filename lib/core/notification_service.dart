import 'dart:convert';

import 'package:flutter/foundation.dart';

import './api_client.dart';
import './error_handler.dart';
import './production_config.dart';
import './storage_service.dart';

/// Service for handling push notifications
class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();
  
  final StorageService _storageService = StorageService();
  final ApiClient _apiClient = ApiClient();
  bool _isInitialized = false;
  String? _fcmToken;
  
  Future<void> initialize() async {
    if (ProductionConfig.enablePushNotifications) {
      try {
        await _initializeFirebaseMessaging();
        await _initializeLocalNotifications();
        await _requestPermissions();
        await _setupNotificationHandlers();
        
        _isInitialized = true;
        
        if (ProductionConfig.enableLogging) {
          debugPrint('NotificationService initialized');
        }
      } catch (e) {
        ErrorHandler.handleError('Failed to initialize NotificationService: $e');
      }
    }
  }
  
  Future<void> _initializeFirebaseMessaging() async {
    try {
      // Initialize Firebase Messaging
      if (ProductionConfig.fcmServerKey.isNotEmpty) {
        // FirebaseMessaging messaging = FirebaseMessaging.instance;
        // _fcmToken = await messaging.getToken();
        
        // Save FCM token
        if (_fcmToken != null) {
          await _storageService.saveString('fcm_token', _fcmToken!);
          await _sendTokenToServer(_fcmToken!);
        }
        
        if (ProductionConfig.enableLogging) {
          debugPrint('Firebase Messaging initialized with token: $_fcmToken');
        }
      }
    } catch (e) {
      ErrorHandler.handleError('Failed to initialize Firebase Messaging: $e');
    }
  }
  
  Future<void> _initializeLocalNotifications() async {
    try {
      // Initialize local notifications
      // const AndroidInitializationSettings initializationSettingsAndroid =
      //     AndroidInitializationSettings('@mipmap/ic_launcher');
      // const IOSInitializationSettings initializationSettingsIOS =
      //     IOSInitializationSettings();
      // const InitializationSettings initializationSettings =
      //     InitializationSettings(
      //       android: initializationSettingsAndroid,
      //       iOS: initializationSettingsIOS,
      //     );
      
      // await flutterLocalNotificationsPlugin.initialize(
      //   initializationSettings,
      //   onSelectNotification: _onNotificationTapped,
      // );
    } catch (e) {
      ErrorHandler.handleError('Failed to initialize local notifications: $e');
    }
  }
  
  Future<void> _requestPermissions() async {
    try {
      // Request notification permissions
      // FirebaseMessaging messaging = FirebaseMessaging.instance;
      // NotificationSettings settings = await messaging.requestPermission(
      //   alert: true,
      //   announcement: false,
      //   badge: true,
      //   carPlay: false,
      //   criticalAlert: false,
      //   provisional: false,
      //   sound: true,
      // );
      
      // if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      //   debugPrint('User granted permission');
      // } else if (settings.authorizationStatus == AuthorizationStatus.provisional) {
      //   debugPrint('User granted provisional permission');
      // } else {
      //   debugPrint('User declined or has not accepted permission');
      // }
    } catch (e) {
      ErrorHandler.handleError('Failed to request notification permissions: $e');
    }
  }
  
  Future<void> _setupNotificationHandlers() async {
    try {
      // Handle foreground messages
      // FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      //   _handleForegroundMessage(message);
      // });
      
      // Handle background messages
      // FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
      
      // Handle notification taps when app is in background
      // FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      //   _handleNotificationTap(message);
      // });
      
      // Handle notification tap when app is terminated
      // FirebaseMessaging.instance.getInitialMessage().then((RemoteMessage? message) {
      //   if (message != null) {
      //     _handleNotificationTap(message);
      //   }
      // });
    } catch (e) {
      ErrorHandler.handleError('Failed to setup notification handlers: $e');
    }
  }
  
  Future<void> _handleForegroundMessage(dynamic message) async {
    try {
      // Handle foreground notifications
      final title = message.notification?.title ?? 'New notification';
      final body = message.notification?.body ?? '';
      final data = message.data ?? {};
      
      // Show local notification
      await _showLocalNotification(title, body, data);
      
      // Track notification received
      // AnalyticsService().trackEvent('notification_received', {
      //   'title': title,
      //   'body': body,
      //   'data': data,
      //   'in_foreground': true,
      // });
    } catch (e) {
      ErrorHandler.handleError('Failed to handle foreground message: $e');
    }
  }
  
  Future<void> _handleNotificationTap(dynamic message) async {
    try {
      final data = message.data ?? {};
      
      // Handle notification tap based on data
      if (data['screen'] != null) {
        await _navigateToScreen(data['screen'], data);
      }
      
      // Track notification tapped
      // AnalyticsService().trackEvent('notification_tapped', {
      //   'title': message.notification?.title,
      //   'body': message.notification?.body,
      //   'data': data,
      // });
    } catch (e) {
      ErrorHandler.handleError('Failed to handle notification tap: $e');
    }
  }
  
  Future<void> _onNotificationTapped(String? payload) async {
    try {
      if (payload != null) {
        final data = jsonDecode(payload);
        if (data['screen'] != null) {
          await _navigateToScreen(data['screen'], data);
        }
      }
    } catch (e) {
      ErrorHandler.handleError('Failed to handle local notification tap: $e');
    }
  }
  
  Future<void> _navigateToScreen(String screen, Map<String, dynamic> data) async {
    try {
      // Navigate to specific screen based on notification data
      // This would typically use a navigation service or global navigator
      // NavigationService.navigateTo(screen, arguments: data);
    } catch (e) {
      ErrorHandler.handleError('Failed to navigate to screen: $e');
    }
  }
  
  Future<void> _showLocalNotification(String title, String body, Map<String, dynamic> data) async {
    try {
      // Show local notification
      // const AndroidNotificationDetails androidPlatformChannelSpecifics =
      //     AndroidNotificationDetails(
      //   'mewayz_channel',
      //   'Mewayz Notifications',
      //   channelDescription: 'Notifications from Mewayz app',
      //   importance: Importance.max,
      //   priority: Priority.high,
      //   showWhen: false,
      // );
      
      // const IOSNotificationDetails iOSPlatformChannelSpecifics =
      //     IOSNotificationDetails();
      
      // const NotificationDetails platformChannelSpecifics = NotificationDetails(
      //   android: androidPlatformChannelSpecifics,
      //   iOS: iOSPlatformChannelSpecifics,
      // );
      
      // await flutterLocalNotificationsPlugin.show(
      //   0,
      //   title,
      //   body,
      //   platformChannelSpecifics,
      //   payload: jsonEncode(data),
      // );
    } catch (e) {
      ErrorHandler.handleError('Failed to show local notification: $e');
    }
  }
  
  Future<void> _sendTokenToServer(String token) async {
    try {
      await _apiClient.post('/notifications/token', data: {
        'token': token,
        'platform': defaultTargetPlatform.name,
      });
    } catch (e) {
      // Don't throw error for token registration failure
      if (ProductionConfig.enableLogging) {
        debugPrint('Failed to send token to server: $e');
      }
    }
  }
  
  /// Subscribe to a topic
  Future<void> subscribeToTopic(String topic) async {
    if (!_isInitialized) return;
    
    try {
      // FirebaseMessaging.instance.subscribeToTopic(topic);
      
      if (ProductionConfig.enableLogging) {
        debugPrint('Subscribed to topic: $topic');
      }
    } catch (e) {
      ErrorHandler.handleError('Failed to subscribe to topic: $e');
    }
  }
  
  /// Unsubscribe from a topic
  Future<void> unsubscribeFromTopic(String topic) async {
    if (!_isInitialized) return;
    
    try {
      // FirebaseMessaging.instance.unsubscribeFromTopic(topic);
      
      if (ProductionConfig.enableLogging) {
        debugPrint('Unsubscribed from topic: $topic');
      }
    } catch (e) {
      ErrorHandler.handleError('Failed to unsubscribe from topic: $e');
    }
  }
  
  /// Get FCM token
  Future<String?> getToken() async {
    if (!_isInitialized) return null;
    
    try {
      return _fcmToken ?? await _storageService.getString('fcm_token');
    } catch (e) {
      ErrorHandler.handleError('Failed to get FCM token: $e');
      return null;
    }
  }
  
  /// Delete FCM token
  Future<void> deleteToken() async {
    if (!_isInitialized) return;
    
    try {
      // await FirebaseMessaging.instance.deleteToken();
      await _storageService.remove('fcm_token');
      _fcmToken = null;
      
      if (ProductionConfig.enableLogging) {
        debugPrint('FCM token deleted');
      }
    } catch (e) {
      ErrorHandler.handleError('Failed to delete FCM token: $e');
    }
  }
  
  /// Schedule local notification
  Future<void> scheduleNotification(
    int id,
    String title,
    String body,
    DateTime scheduledTime, {
    Map<String, dynamic>? data,
  }) async {
    if (!_isInitialized) return;
    
    try {
      // const AndroidNotificationDetails androidPlatformChannelSpecifics =
      //     AndroidNotificationDetails(
      //   'mewayz_scheduled_channel',
      //   'Mewayz Scheduled Notifications',
      //   channelDescription: 'Scheduled notifications from Mewayz app',
      //   importance: Importance.max,
      //   priority: Priority.high,
      // );
      
      // const IOSNotificationDetails iOSPlatformChannelSpecifics =
      //     IOSNotificationDetails();
      
      // const NotificationDetails platformChannelSpecifics = NotificationDetails(
      //   android: androidPlatformChannelSpecifics,
      //   iOS: iOSPlatformChannelSpecifics,
      // );
      
      // await flutterLocalNotificationsPlugin.zonedSchedule(
      //   id,
      //   title,
      //   body,
      //   tz.TZDateTime.from(scheduledTime, tz.local),
      //   platformChannelSpecifics,
      //   androidAllowWhileIdle: true,
      //   uiLocalNotificationDateInterpretation:
      //       UILocalNotificationDateInterpretation.absoluteTime,
      //   payload: data != null ? jsonEncode(data) : null,
      // );
      
      if (ProductionConfig.enableLogging) {
        debugPrint('Scheduled notification for: $scheduledTime');
      }
    } catch (e) {
      ErrorHandler.handleError('Failed to schedule notification: $e');
    }
  }
  
  /// Cancel scheduled notification
  Future<void> cancelNotification(int id) async {
    if (!_isInitialized) return;
    
    try {
      // await flutterLocalNotificationsPlugin.cancel(id);
      
      if (ProductionConfig.enableLogging) {
        debugPrint('Cancelled notification with id: $id');
      }
    } catch (e) {
      ErrorHandler.handleError('Failed to cancel notification: $e');
    }
  }
  
  /// Cancel all scheduled notifications
  Future<void> cancelAllNotifications() async {
    if (!_isInitialized) return;
    
    try {
      // await flutterLocalNotificationsPlugin.cancelAll();
      
      if (ProductionConfig.enableLogging) {
        debugPrint('Cancelled all notifications');
      }
    } catch (e) {
      ErrorHandler.handleError('Failed to cancel all notifications: $e');
    }
  }
  
  /// Update notification settings
  Future<void> updateNotificationSettings(Map<String, bool> settings) async {
    try {
      await _storageService.saveNotificationSettings(settings);
      
      // Update server with new settings
      await _apiClient.put('/notifications/settings', data: settings);
      
      if (ProductionConfig.enableLogging) {
        debugPrint('Updated notification settings: $settings');
      }
    } catch (e) {
      ErrorHandler.handleError('Failed to update notification settings: $e');
    }
  }
}

// Background message handler
// @pragma('vm:entry-point')
// Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
//   // Handle background messages
//   await Firebase.initializeApp();
//   
//   // Track notification received in background
//   try {
//     // You can perform background tasks here
//     print('Handling a background message: ${message.messageId}');
//   } catch (e) {
//     print('Error handling background message: $e');
//   }
// }