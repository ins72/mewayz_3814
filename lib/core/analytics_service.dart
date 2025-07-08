
import 'package:flutter/foundation.dart';

import './api_client.dart';
import './error_handler.dart';
import './production_config.dart';

/// Service for analytics and tracking
class AnalyticsService {
  static final AnalyticsService _instance = AnalyticsService._internal();
  factory AnalyticsService() => _instance;
  AnalyticsService._internal();
  
  final ApiClient _apiClient = ApiClient();
  bool _isInitialized = false;
  
  Future<void> initialize() async {
    if (ProductionConfig.enableAdvancedAnalytics) {
      _isInitialized = true;
      
      // Initialize analytics SDKs
      await _initializeFirebaseAnalytics();
      await _initializeMixpanel();
      
      // Track app launch
      await trackEvent('app_launched', {
        'app_version': ProductionConfig.appVersion,
        'build_number': ProductionConfig.buildNumber,
        'platform': defaultTargetPlatform.name,
        'is_production': ProductionConfig.isProduction,
      });
    }
  }
  
  Future<void> _initializeFirebaseAnalytics() async {
    try {
      // Initialize Firebase Analytics
      if (ProductionConfig.firebaseProjectId.isNotEmpty) {
        // Firebase Analytics initialization would go here
        debugPrint('Firebase Analytics initialized');
      }
    } catch (e) {
      ErrorHandler.handleError('Failed to initialize Firebase Analytics: $e');
    }
  }
  
  Future<void> _initializeMixpanel() async {
    try {
      // Initialize Mixpanel
      if (ProductionConfig.mixpanelToken.isNotEmpty) {
        // Mixpanel initialization would go here
        debugPrint('Mixpanel initialized');
      }
    } catch (e) {
      ErrorHandler.handleError('Failed to initialize Mixpanel: $e');
    }
  }
  
  /// Track an event with optional properties
  Future<void> trackEvent(String eventName, [Map<String, dynamic>? properties]) async {
    if (!_isInitialized || !ProductionConfig.enableAdvancedAnalytics) return;
    
    try {
      final eventData = {
        'event_name': eventName,
        'properties': properties ?? {},
        'timestamp': DateTime.now().toIso8601String(),
        'platform': defaultTargetPlatform.name,
        'app_version': ProductionConfig.appVersion,
      };
      
      // Send to Firebase Analytics
      await _sendToFirebaseAnalytics(eventName, properties);
      
      // Send to Mixpanel
      await _sendToMixpanel(eventName, properties);
      
      // Send to custom analytics endpoint
      await _sendToCustomAnalytics(eventData);
      
      if (ProductionConfig.enableLogging) {
        debugPrint('Analytics event tracked: $eventName');
        debugPrint('Properties: $properties');
      }
    } catch (e) {
      ErrorHandler.handleError('Failed to track event: $e');
    }
  }
  
  /// Track screen view
  Future<void> trackScreenView(String screenName, {Map<String, dynamic>? properties}) async {
    await trackEvent('screen_view', {
      'screen_name': screenName,
      ...?properties,
    });
  }
  
  /// Track user action
  Future<void> trackUserAction(String action, {Map<String, dynamic>? properties}) async {
    await trackEvent('user_action', {
      'action': action,
      ...?properties,
    });
  }
  
  /// Track performance metrics
  Future<void> trackPerformance(String metric, double value, {Map<String, dynamic>? properties}) async {
    await trackEvent('performance_metric', {
      'metric': metric,
      'value': value,
      ...?properties,
    });
  }
  
  /// Track error occurrence
  Future<void> trackError(String errorType, String errorMessage, {Map<String, dynamic>? properties}) async {
    await trackEvent('error_occurred', {
      'error_type': errorType,
      'error_message': errorMessage,
      ...?properties,
    });
  }
  
  /// Track business metrics
  Future<void> trackBusinessMetric(String metric, dynamic value, {Map<String, dynamic>? properties}) async {
    await trackEvent('business_metric', {
      'metric': metric,
      'value': value,
      ...?properties,
    });
  }
  
  /// Track user engagement
  Future<void> trackEngagement(String engagementType, {Map<String, dynamic>? properties}) async {
    await trackEvent('user_engagement', {
      'engagement_type': engagementType,
      ...?properties,
    });
  }
  
  /// Track social media activity
  Future<void> trackSocialMediaActivity(String platform, String action, {Map<String, dynamic>? properties}) async {
    await trackEvent('social_media_activity', {
      'platform': platform,
      'action': action,
      ...?properties,
    });
  }
  
  /// Track conversion events
  Future<void> trackConversion(String conversionType, double value, {Map<String, dynamic>? properties}) async {
    await trackEvent('conversion', {
      'conversion_type': conversionType,
      'value': value,
      ...?properties,
    });
  }
  
  /// Set user properties
  Future<void> setUserProperties(Map<String, dynamic> properties) async {
    if (!_isInitialized || !ProductionConfig.enableAdvancedAnalytics) return;
    
    try {
      await _setFirebaseUserProperties(properties);
      await _setMixpanelUserProperties(properties);
      
      if (ProductionConfig.enableLogging) {
        debugPrint('User properties set: $properties');
      }
    } catch (e) {
      ErrorHandler.handleError('Failed to set user properties: $e');
    }
  }
  
  /// Identify user
  Future<void> identifyUser(String userId, {Map<String, dynamic>? properties}) async {
    if (!_isInitialized || !ProductionConfig.enableAdvancedAnalytics) return;
    
    try {
      await _identifyFirebaseUser(userId);
      await _identifyMixpanelUser(userId, properties);
      
      if (ProductionConfig.enableLogging) {
        debugPrint('User identified: $userId');
      }
    } catch (e) {
      ErrorHandler.handleError('Failed to identify user: $e');
    }
  }
  
  /// Reset user identity
  Future<void> resetUserIdentity() async {
    if (!_isInitialized || !ProductionConfig.enableAdvancedAnalytics) return;
    
    try {
      await _resetFirebaseUser();
      await _resetMixpanelUser();
      
      if (ProductionConfig.enableLogging) {
        debugPrint('User identity reset');
      }
    } catch (e) {
      ErrorHandler.handleError('Failed to reset user identity: $e');
    }
  }
  
  // Firebase Analytics methods
  Future<void> _sendToFirebaseAnalytics(String eventName, Map<String, dynamic>? properties) async {
    if (ProductionConfig.firebaseProjectId.isEmpty) return;
    
    try {
      // Implementation for Firebase Analytics
      // FirebaseAnalytics.instance.logEvent(name: eventName, parameters: properties);
    } catch (e) {
      ErrorHandler.handleError('Failed to send to Firebase Analytics: $e');
    }
  }
  
  Future<void> _setFirebaseUserProperties(Map<String, dynamic> properties) async {
    if (ProductionConfig.firebaseProjectId.isEmpty) return;
    
    try {
      // Implementation for Firebase Analytics user properties
      // for (final entry in properties.entries) {
      //   await FirebaseAnalytics.instance.setUserProperty(name: entry.key, value: entry.value?.toString());
      // }
    } catch (e) {
      ErrorHandler.handleError('Failed to set Firebase user properties: $e');
    }
  }
  
  Future<void> _identifyFirebaseUser(String userId) async {
    if (ProductionConfig.firebaseProjectId.isEmpty) return;
    
    try {
      // Implementation for Firebase Analytics user identification
      // await FirebaseAnalytics.instance.setUserId(id: userId);
    } catch (e) {
      ErrorHandler.handleError('Failed to identify Firebase user: $e');
    }
  }
  
  Future<void> _resetFirebaseUser() async {
    if (ProductionConfig.firebaseProjectId.isEmpty) return;
    
    try {
      // Implementation for Firebase Analytics reset
      // await FirebaseAnalytics.instance.resetAnalyticsData();
    } catch (e) {
      ErrorHandler.handleError('Failed to reset Firebase user: $e');
    }
  }
  
  // Mixpanel methods
  Future<void> _sendToMixpanel(String eventName, Map<String, dynamic>? properties) async {
    if (ProductionConfig.mixpanelToken.isEmpty) return;
    
    try {
      // Implementation for Mixpanel
      // await Mixpanel.track(eventName, properties);
    } catch (e) {
      ErrorHandler.handleError('Failed to send to Mixpanel: $e');
    }
  }
  
  Future<void> _setMixpanelUserProperties(Map<String, dynamic> properties) async {
    if (ProductionConfig.mixpanelToken.isEmpty) return;
    
    try {
      // Implementation for Mixpanel user properties
      // await Mixpanel.getPeople().set(properties);
    } catch (e) {
      ErrorHandler.handleError('Failed to set Mixpanel user properties: $e');
    }
  }
  
  Future<void> _identifyMixpanelUser(String userId, Map<String, dynamic>? properties) async {
    if (ProductionConfig.mixpanelToken.isEmpty) return;
    
    try {
      // Implementation for Mixpanel user identification
      // await Mixpanel.identify(userId);
      // if (properties != null) {
      //   await Mixpanel.getPeople().set(properties);
      // }
    } catch (e) {
      ErrorHandler.handleError('Failed to identify Mixpanel user: $e');
    }
  }
  
  Future<void> _resetMixpanelUser() async {
    if (ProductionConfig.mixpanelToken.isEmpty) return;
    
    try {
      // Implementation for Mixpanel reset
      // await Mixpanel.reset();
    } catch (e) {
      ErrorHandler.handleError('Failed to reset Mixpanel user: $e');
    }
  }
  
  // Custom analytics endpoint
  Future<void> _sendToCustomAnalytics(Map<String, dynamic> eventData) async {
    try {
      await _apiClient.post('/analytics/events', data: eventData);
    } catch (e) {
      // Don't throw error for analytics failure
      if (ProductionConfig.enableLogging) {
        debugPrint('Failed to send to custom analytics: $e');
      }
    }
  }
}