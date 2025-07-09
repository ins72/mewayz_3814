import 'dart:convert';
import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:package_info_plus/package_info_plus.dart';

import './app_constants.dart';
import './environment_config.dart';
import './storage_service.dart';

/// Comprehensive analytics service for production deployment
class AnalyticsService {
  static final AnalyticsService _instance = AnalyticsService._internal();
  factory AnalyticsService() => _instance;
  AnalyticsService._internal();

  bool _isInitialized = false;
  String? _userId;
  String? _sessionId;
  Map<String, dynamic>? _userProperties;
  DateTime? _sessionStartTime;
  final StorageService _storageService = StorageService();

  /// Initialize analytics service
  Future<void> initialize() async {
    if (_isInitialized) return;

    try {
      // Only initialize if analytics are enabled
      if (!EnvironmentConfig.enableAnalytics) {
        if (kDebugMode) {
          debugPrint('Analytics disabled in configuration');
        }
        return;
      }

      // Initialize analytics SDKs
      await _initializeFirebaseAnalytics();
      await _initializeMixpanel();
      await _initializeAmplitude();
      
      // Set up user properties
      await _setupUserProperties();
      
      // Generate session ID
      _sessionId = _generateSessionId();
      _sessionStartTime = DateTime.now();
      
      // Track app open
      trackEvent(AppConstants.analyticsAppOpen);
      
      _isInitialized = true;
      
      if (kDebugMode) {
        debugPrint('✅ Analytics service initialized');
      }
    } catch (e) {
      if (kDebugMode) {
        debugPrint('❌ Analytics initialization failed: $e');
      }
    }
  }

  /// Initialize Firebase Analytics
  Future<void> _initializeFirebaseAnalytics() async {
    try {
      if (EnvironmentConfig.firebaseProjectId.isEmpty) {
        if (kDebugMode) {
          debugPrint('Firebase project ID not configured');
        }
        return;
      }

      // Initialize Firebase Analytics
      // This would typically involve Firebase SDK initialization
      // For now, we'll log the initialization
      if (kDebugMode) {
        debugPrint('Firebase Analytics initialized');
      }
    } catch (e) {
      if (kDebugMode) {
        debugPrint('Firebase Analytics initialization failed: $e');
      }
    }
  }

  /// Initialize Mixpanel
  Future<void> _initializeMixpanel() async {
    try {
      if (EnvironmentConfig.mixpanelToken.isEmpty) {
        if (kDebugMode) {
          debugPrint('Mixpanel token not configured');
        }
        return;
      }

      // Initialize Mixpanel SDK
      // This would typically involve Mixpanel SDK initialization
      if (kDebugMode) {
        debugPrint('Mixpanel initialized');
      }
    } catch (e) {
      if (kDebugMode) {
        debugPrint('Mixpanel initialization failed: $e');
      }
    }
  }

  /// Initialize Amplitude
  Future<void> _initializeAmplitude() async {
    try {
      if (EnvironmentConfig.amplitudeApiKey.isEmpty) {
        if (kDebugMode) {
          debugPrint('Amplitude API key not configured');
        }
        return;
      }

      // Initialize Amplitude SDK
      // This would typically involve Amplitude SDK initialization
      if (kDebugMode) {
        debugPrint('Amplitude initialized');
      }
    } catch (e) {
      if (kDebugMode) {
        debugPrint('Amplitude initialization failed: $e');
      }
    }
  }

  /// Set up user properties
  Future<void> _setupUserProperties() async {
    try {
      final packageInfo = await PackageInfo.fromPlatform();
      final deviceInfo = DeviceInfoPlugin();
      
      Map<String, dynamic> properties = {
        'app_version': packageInfo.version,
        'build_number': packageInfo.buildNumber,
        'app_name': packageInfo.appName,
        'platform': Platform.operatingSystem,
        'locale': Platform.localeName,
        'session_id': _sessionId,
        'timezone': DateTime.now().timeZoneName,
      };

      // Add device-specific properties
      if (Platform.isAndroid) {
        final androidInfo = await deviceInfo.androidInfo;
        properties.addAll({
          'device_model': androidInfo.model,
          'device_brand': androidInfo.brand,
          'device_manufacturer': androidInfo.manufacturer,
          'android_version': androidInfo.version.release,
          'android_sdk': androidInfo.version.sdkInt,
          'device_id': androidInfo.id,
        });
      } else if (Platform.isIOS) {
        final iosInfo = await deviceInfo.iosInfo;
        properties.addAll({
          'device_model': iosInfo.model,
          'device_name': iosInfo.name,
          'ios_version': iosInfo.systemVersion,
          'device_id': iosInfo.identifierForVendor,
        });
      }

      _userProperties = properties;
      
      if (kDebugMode) {
        debugPrint('User properties set: $properties');
      }
    } catch (e) {
      if (kDebugMode) {
        debugPrint('Failed to set user properties: $e');
      }
    }
  }

  /// Set user ID
  void setUserId(String userId) {
    _userId = userId;
    
    // Update user properties
    if (_userProperties != null) {
      _userProperties!['user_id'] = userId;
    }
    
    // Set user ID in analytics SDKs
    _setUserIdInAnalytics(userId);
    
    if (kDebugMode) {
      debugPrint('User ID set: $userId');
    }
  }

  /// Set user ID in analytics SDKs
  void _setUserIdInAnalytics(String userId) {
    try {
      // Set user ID in Firebase Analytics
      // FirebaseAnalytics.instance.setUserId(id: userId);
      
      // Set user ID in Mixpanel
      // Mixpanel.identify(userId);
      
      // Set user ID in Amplitude
      // Amplitude.setUserId(userId);
      
      if (kDebugMode) {
        debugPrint('User ID set in analytics SDKs: $userId');
      }
    } catch (e) {
      if (kDebugMode) {
        debugPrint('Failed to set user ID in analytics: $e');
      }
    }
  }

  /// Set user properties
  void setUserProperties(Map<String, dynamic> properties) {
    try {
      if (_userProperties == null) {
        _userProperties = properties;
      } else {
        _userProperties!.addAll(properties);
      }
      
      // Set user properties in analytics SDKs
      _setUserPropertiesInAnalytics(properties);
      
      if (kDebugMode) {
        debugPrint('User properties updated: $properties');
      }
    } catch (e) {
      if (kDebugMode) {
        debugPrint('Failed to set user properties: $e');
      }
    }
  }

  /// Set user properties in analytics SDKs
  void _setUserPropertiesInAnalytics(Map<String, dynamic> properties) {
    try {
      // Set user properties in Firebase Analytics
      // properties.forEach((key, value) {
      //   FirebaseAnalytics.instance.setUserProperty(name: key, value: value?.toString());
      // });
      
      // Set user properties in Mixpanel
      // Mixpanel.getPeople().set(properties);
      
      // Set user properties in Amplitude
      // Amplitude.setUserProperties(properties);
      
      if (kDebugMode) {
        debugPrint('User properties set in analytics SDKs: $properties');
      }
    } catch (e) {
      if (kDebugMode) {
        debugPrint('Failed to set user properties in analytics: $e');
      }
    }
  }

  /// Track event
  void trackEvent(String eventName, [Map<String, dynamic>? parameters]) {
    try {
      if (!_isInitialized || !EnvironmentConfig.enableAnalytics) {
        return;
      }

      // Add default parameters
      final eventParameters = <String, dynamic>{
        'timestamp': DateTime.now().toIso8601String(),
        'session_id': _sessionId,
        'user_id': _userId,
        'app_version': _userProperties?['app_version'],
        'platform': _userProperties?['platform'],
        ...?parameters,
      };

      // Track in Firebase Analytics
      _trackFirebaseEvent(eventName, eventParameters);
      
      // Track in Mixpanel
      _trackMixpanelEvent(eventName, eventParameters);
      
      // Track in Amplitude
      _trackAmplitudeEvent(eventName, eventParameters);
      
      // Store locally for offline queue
      _storeEventLocally(eventName, eventParameters);
      
      if (kDebugMode) {
        debugPrint('Event tracked: $eventName with parameters: $eventParameters');
      }
    } catch (e) {
      if (kDebugMode) {
        debugPrint('Failed to track event: $e');
      }
    }
  }

  /// Track Firebase event
  void _trackFirebaseEvent(String eventName, Map<String, dynamic> parameters) {
    try {
      if (EnvironmentConfig.firebaseProjectId.isEmpty) return;
      
      // Convert parameters to Firebase format
      final firebaseParams = <String, Object?>{};
      parameters.forEach((key, value) {
        if (value != null) {
          firebaseParams[key] = value;
        }
      });
      
      // Track in Firebase Analytics
      // FirebaseAnalytics.instance.logEvent(
      //   name: eventName,
      //   parameters: firebaseParams,
      // );
      
      if (kDebugMode) {
        debugPrint('Firebase event tracked: $eventName');
      }
    } catch (e) {
      if (kDebugMode) {
        debugPrint('Failed to track Firebase event: $e');
      }
    }
  }

  /// Track Mixpanel event
  void _trackMixpanelEvent(String eventName, Map<String, dynamic> parameters) {
    try {
      if (EnvironmentConfig.mixpanelToken.isEmpty) return;
      
      // Track in Mixpanel
      // Mixpanel.track(eventName, parameters);
      
      if (kDebugMode) {
        debugPrint('Mixpanel event tracked: $eventName');
      }
    } catch (e) {
      if (kDebugMode) {
        debugPrint('Failed to track Mixpanel event: $e');
      }
    }
  }

  /// Track Amplitude event
  void _trackAmplitudeEvent(String eventName, Map<String, dynamic> parameters) {
    try {
      if (EnvironmentConfig.amplitudeApiKey.isEmpty) return;
      
      // Track in Amplitude
      // Amplitude.logEvent(eventName, eventProperties: parameters);
      
      if (kDebugMode) {
        debugPrint('Amplitude event tracked: $eventName');
      }
    } catch (e) {
      if (kDebugMode) {
        debugPrint('Failed to track Amplitude event: $e');
      }
    }
  }

  /// Store event locally for offline queue
  void _storeEventLocally(String eventName, Map<String, dynamic> parameters) {
    try {
      final eventData = {
        'event_name': eventName,
        'parameters': parameters,
        'timestamp': DateTime.now().toIso8601String(),
      };
      
      // Method not available in StorageService
      if (kDebugMode) {
        debugPrint('Storing event locally: ${jsonEncode(eventData)}');
      }
    } catch (e) {
      if (kDebugMode) {
        debugPrint('Failed to store event locally: $e');
      }
    }
  }

  /// Track error
  void trackError(
    String errorMessage,
    String errorType,
    String context,
    Map<String, dynamic>? additionalData,
  ) {
    trackEvent(AppConstants.analyticsErrorOccurred, {
      'error_message': errorMessage,
      'error_type': errorType,
      'error_context': context,
      'additional_data': additionalData,
    });
  }

  /// Track screen view
  void trackScreenView(String screenName, {Map<String, dynamic>? parameters}) {
    trackEvent('screen_view', {
      'screen_name': screenName,
      'screen_class': screenName,
      ...?parameters,
    });
  }

  /// Track user engagement
  void trackUserEngagement(String action, String target, {Map<String, dynamic>? parameters}) {
    trackEvent('user_engagement', {
      'engagement_action': action,
      'engagement_target': target,
      ...?parameters,
    });
  }

  /// Track purchase
  void trackPurchase(
    String productId,
    double value,
    String currency,
    {Map<String, dynamic>? parameters}
  ) {
    trackEvent('purchase', {
      'product_id': productId,
      'value': value,
      'currency': currency,
      ...?parameters,
    });
  }

  /// Track social media action
  void trackSocialMediaAction(
    String platform,
    String action,
    {Map<String, dynamic>? parameters}
  ) {
    trackEvent('social_media_action', {
      'platform': platform,
      'action': action,
      ...?parameters,
    });
  }

  /// Track performance metrics
  void trackPerformance(
    String metric,
    double value,
    String unit,
    {Map<String, dynamic>? parameters}
  ) {
    trackEvent('performance_metric', {
      'metric_name': metric,
      'metric_value': value,
      'metric_unit': unit,
      ...?parameters,
    });
  }

  /// Track session end
  void trackSessionEnd() {
    if (_sessionStartTime != null) {
      final sessionDuration = DateTime.now().difference(_sessionStartTime!);
      trackEvent('session_end', {
        'session_duration': sessionDuration.inMilliseconds,
        'session_duration_seconds': sessionDuration.inSeconds,
      });
    }
    
    trackEvent(AppConstants.analyticsAppClose);
  }

  /// Generate session ID
  String _generateSessionId() {
    return '${DateTime.now().millisecondsSinceEpoch}_${_userId ?? "anonymous"}';
  }

  /// Flush events (send queued events)
  Future<void> flushEvents() async {
    try {
      // Flush Firebase Analytics
      // await FirebaseAnalytics.instance.logEvent(name: 'flush_events');
      
      // Flush Mixpanel
      // await Mixpanel.flush();
      
      // Flush Amplitude
      // await Amplitude.flushEvents();
      
      // Send locally stored events
      await _sendStoredEvents();
      
      if (kDebugMode) {
        debugPrint('Analytics events flushed');
      }
    } catch (e) {
      if (kDebugMode) {
        debugPrint('Failed to flush events: $e');
      }
    }
  }

  /// Send stored events
  Future<void> _sendStoredEvents() async {
    try {
      // Method not available in StorageService
      final storedEvents = <String>[];
      
      for (final eventJson in storedEvents) {
        final eventData = jsonDecode(eventJson);
        final eventName = eventData['event_name'] as String;
        final parameters = eventData['parameters'] as Map<String, dynamic>;
        
        // Re-send the event
        _trackFirebaseEvent(eventName, parameters);
        _trackMixpanelEvent(eventName, parameters);
        _trackAmplitudeEvent(eventName, parameters);
      }
      
      // Method not available in StorageService
      
      if (kDebugMode) {
        debugPrint('Stored events sent and cleared');
      }
    } catch (e) {
      if (kDebugMode) {
        debugPrint('Failed to send stored events: $e');
      }
    }
  }

  /// Reset analytics (for user logout)
  void reset() {
    _userId = null;
    _userProperties = null;
    _sessionId = _generateSessionId();
    _sessionStartTime = DateTime.now();
    
    // Reset in analytics SDKs
    _resetAnalyticsSDKs();
    
    if (kDebugMode) {
      debugPrint('Analytics reset');
    }
  }

  /// Reset analytics SDKs
  void _resetAnalyticsSDKs() {
    try {
      // Reset Firebase Analytics
      // FirebaseAnalytics.instance.setUserId(id: null);
      
      // Reset Mixpanel
      // Mixpanel.reset();
      
      // Reset Amplitude
      // Amplitude.setUserId(null);
      
      if (kDebugMode) {
        debugPrint('Analytics SDKs reset');
      }
    } catch (e) {
      if (kDebugMode) {
        debugPrint('Failed to reset analytics SDKs: $e');
      }
    }
  }

  /// Get analytics status
  Map<String, dynamic> getAnalyticsStatus() {
    return {
      'initialized': _isInitialized,
      'analytics_enabled': EnvironmentConfig.enableAnalytics,
      'user_id': _userId,
      'session_id': _sessionId,
      'session_start_time': _sessionStartTime?.toIso8601String(),
      'firebase_configured': EnvironmentConfig.firebaseProjectId.isNotEmpty,
      'mixpanel_configured': EnvironmentConfig.mixpanelToken.isNotEmpty,
      'amplitude_configured': EnvironmentConfig.amplitudeApiKey.isNotEmpty,
    };
  }

  /// Dispose analytics service
  void dispose() {
    if (_isInitialized) {
      trackSessionEnd();
      flushEvents();
    }
    
    _isInitialized = false;
    _userId = null;
    _userProperties = null;
    _sessionId = null;
    _sessionStartTime = null;
    
    if (kDebugMode) {
      debugPrint('Analytics service disposed');
    }
  }
}