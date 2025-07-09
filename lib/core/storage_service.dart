import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/foundation.dart';
import './production_config.dart';

/// Enhanced storage service with production-ready features
/// Handles authentication, caching, and offline data storage
class StorageService {
  static final StorageService _instance = StorageService._internal();
  factory StorageService() => _instance;
  StorageService._internal();

  late SharedPreferences _prefs;
  bool _isInitialized = false;

  /// Initialize storage service
  Future<void> initialize() async {
    if (_isInitialized) return;
    
    try {
      _prefs = await SharedPreferences.getInstance();
      _isInitialized = true;
      debugPrint('StorageService initialized successfully');
    } catch (e) {
      throw Exception('Failed to initialize StorageService: $e');
    }
  }

  /// Ensure storage service is initialized
  Future<void> _ensureInitialized() async {
    if (!_isInitialized) {
      await initialize();
    }
  }

  /// AUTH TOKEN MANAGEMENT
  
  /// Save authentication token
  Future<void> saveAuthToken(String token) async {
    await _ensureInitialized();
    await _prefs.setString('auth_token', token);
  }

  /// Get authentication token
  Future<String?> getAuthToken() async {
    await _ensureInitialized();
    return _prefs.getString('auth_token');
  }

  /// Save refresh token
  Future<void> saveRefreshToken(String refreshToken) async {
    await _ensureInitialized();
    await _prefs.setString('refresh_token', refreshToken);
  }

  /// Get refresh token
  Future<String?> getRefreshToken() async {
    await _ensureInitialized();
    return _prefs.getString('refresh_token');
  }

  /// Clear authentication data
  Future<void> clearAuthData() async {
    await _ensureInitialized();
    await _prefs.remove('auth_token');
    await _prefs.remove('refresh_token');
    await _prefs.remove('user_data');
    await _prefs.remove('session_data');
  }

  /// USER DATA MANAGEMENT
  
  /// Save user data
  Future<void> saveUserData(Map<String, dynamic> userData) async {
    await _ensureInitialized();
    final jsonString = jsonEncode(userData);
    await _prefs.setString('user_data', jsonString);
  }

  /// Get user data
  Future<Map<String, dynamic>?> getUserData() async {
    await _ensureInitialized();
    final jsonString = _prefs.getString('user_data');
    if (jsonString != null) {
      return Map<String, dynamic>.from(jsonDecode(jsonString));
    }
    return null;
  }

  /// SESSION MANAGEMENT
  
  /// Save session data
  Future<void> saveSessionData(Map<String, dynamic> sessionData) async {
    await _ensureInitialized();
    final jsonString = jsonEncode(sessionData);
    await _prefs.setString('session_data', jsonString);
  }

  /// Get session data
  Future<Map<String, dynamic>?> getSessionData() async {
    await _ensureInitialized();
    final jsonString = _prefs.getString('session_data');
    if (jsonString != null) {
      return Map<String, dynamic>.from(jsonDecode(jsonString));
    }
    return null;
  }

  /// WORKSPACE MANAGEMENT
  
  /// Save current workspace
  Future<void> saveCurrentWorkspace(String workspaceId) async {
    await _ensureInitialized();
    await _prefs.setString('current_workspace', workspaceId);
  }

  /// Get current workspace
  Future<String?> getCurrentWorkspace() async {
    await _ensureInitialized();
    return _prefs.getString('current_workspace');
  }

  /// Save workspace data
  Future<void> saveWorkspaceData(Map<String, dynamic> workspaceData) async {
    await _ensureInitialized();
    final jsonString = jsonEncode(workspaceData);
    await _prefs.setString('workspace_data', jsonString);
  }

  /// Get workspace data
  Future<Map<String, dynamic>?> getWorkspaceData() async {
    await _ensureInitialized();
    final jsonString = _prefs.getString('workspace_data');
    if (jsonString != null) {
      return Map<String, dynamic>.from(jsonDecode(jsonString));
    }
    return null;
  }

  /// CACHING SYSTEM
  
  /// Cache data with expiration
  Future<void> cacheData(String key, dynamic data, {Duration? expiration}) async {
    await _ensureInitialized();
    
    final cacheEntry = {
      'data': data,
      'timestamp': DateTime.now().millisecondsSinceEpoch,
      'expiration': expiration?.inMilliseconds ?? ProductionConfig.cacheExpiration.inMilliseconds,
    };
    
    final jsonString = jsonEncode(cacheEntry);
    await _prefs.setString('cache_$key', jsonString);
  }

  /// Get cached data
  Future<dynamic> getCachedData(String key) async {
    await _ensureInitialized();
    
    final jsonString = _prefs.getString('cache_$key');
    if (jsonString == null) return null;
    
    try {
      final cacheEntry = jsonDecode(jsonString);
      final timestamp = cacheEntry['timestamp'] as int;
      final expiration = cacheEntry['expiration'] as int;
      
      // Check if cache is expired
      if (DateTime.now().millisecondsSinceEpoch - timestamp > expiration) {
        // Remove expired cache
        await _prefs.remove('cache_$key');
        return null;
      }
      
      return cacheEntry['data'];
    } catch (e) {
      // Remove corrupted cache
      await _prefs.remove('cache_$key');
      return null;
    }
  }

  /// Clear all cached data
  Future<void> clearCache() async {
    await _ensureInitialized();
    
    final keys = _prefs.getKeys();
    final cacheKeys = keys.where((key) => key.startsWith('cache_'));
    
    for (final key in cacheKeys) {
      await _prefs.remove(key);
    }
  }

  /// Clear expired cache entries
  Future<void> clearExpiredCache() async {
    await _ensureInitialized();
    
    final keys = _prefs.getKeys();
    final cacheKeys = keys.where((key) => key.startsWith('cache_'));
    
    for (final key in cacheKeys) {
      final jsonString = _prefs.getString(key);
      if (jsonString != null) {
        try {
          final cacheEntry = jsonDecode(jsonString);
          final timestamp = cacheEntry['timestamp'] as int;
          final expiration = cacheEntry['expiration'] as int;
          
          // Check if cache is expired
          if (DateTime.now().millisecondsSinceEpoch - timestamp > expiration) {
            await _prefs.remove(key);
          }
        } catch (e) {
          // Remove corrupted cache
          await _prefs.remove(key);
        }
      }
    }
  }

  /// OFFLINE QUEUE MANAGEMENT
  
  /// Save offline queue
  Future<void> saveOfflineQueue(List<Map<String, dynamic>> queue) async {
    await _ensureInitialized();
    final jsonString = jsonEncode(queue);
    await _prefs.setString('offline_queue', jsonString);
  }

  /// Get offline queue
  Future<List<Map<String, dynamic>>?> getOfflineQueue() async {
    try {
      final jsonString = _prefs.getString('offline_queue');
      if (jsonString != null) {
        final List<dynamic> decoded = jsonDecode(jsonString);
        return decoded.map((item) => Map<String, dynamic>.from(item)).toList();
      }
      return null;
    } catch (e) {
      debugPrint('Failed to get offline queue: $e');
      return null;
    }
  }

  /// Clear offline queue
  Future<void> clearOfflineQueue() async {
    await _ensureInitialized();
    await _prefs.remove('offline_queue');
  }

  /// SETTINGS MANAGEMENT
  
  /// Save app settings
  Future<void> saveSettings(Map<String, dynamic> settings) async {
    await _ensureInitialized();
    final jsonString = jsonEncode(settings);
    await _prefs.setString('app_settings', jsonString);
  }

  /// Get app settings
  Future<Map<String, dynamic>?> getSettings() async {
    await _ensureInitialized();
    final jsonString = _prefs.getString('app_settings');
    if (jsonString != null) {
      return Map<String, dynamic>.from(jsonDecode(jsonString));
    }
    return null;
  }

  /// Save individual setting
  Future<void> saveSetting(String key, dynamic value) async {
    await _ensureInitialized();
    
    final settings = await getSettings() ?? {};
    settings[key] = value;
    await saveSettings(settings);
  }

  /// Get individual setting
  Future<T?> getSetting<T>(String key) async {
    await _ensureInitialized();
    
    final settings = await getSettings();
    return settings?[key] as T?;
  }

  /// ANALYTICS AND TRACKING
  
  /// Save analytics data
  Future<void> saveAnalyticsData(Map<String, dynamic> analyticsData) async {
    await _ensureInitialized();
    final jsonString = jsonEncode(analyticsData);
    await _prefs.setString('analytics_data', jsonString);
  }

  /// Get analytics data
  Future<Map<String, dynamic>?> getAnalyticsData() async {
    await _ensureInitialized();
    final jsonString = _prefs.getString('analytics_data');
    if (jsonString != null) {
      return Map<String, dynamic>.from(jsonDecode(jsonString));
    }
    return null;
  }

  /// ONBOARDING AND FIRST-TIME SETUP
  
  /// Mark onboarding as completed
  Future<void> markOnboardingCompleted() async {
    await _ensureInitialized();
    await _prefs.setBool('onboarding_completed', true);
  }

  /// Check if onboarding is completed
  Future<bool> isOnboardingCompleted() async {
    await _ensureInitialized();
    return _prefs.getBool('onboarding_completed') ?? false;
  }

  /// Mark first launch
  Future<void> markFirstLaunch() async {
    await _ensureInitialized();
    await _prefs.setBool('first_launch', true);
  }

  /// Check if this is first launch
  Future<bool> isFirstLaunch() async {
    await _ensureInitialized();
    return _prefs.getBool('first_launch') ?? true;
  }

  /// UTILITY METHODS
  
  /// Get storage size (approximate)
  Future<int> getStorageSize() async {
    await _ensureInitialized();
    
    int totalSize = 0;
    final keys = _prefs.getKeys();
    
    for (final key in keys) {
      final value = _prefs.get(key);
      if (value is String) {
        totalSize += value.length;
      }
    }
    
    return totalSize;
  }

  /// Clear all data
  Future<void> clearAll() async {
    await _ensureInitialized();
    await _prefs.clear();
  }

  /// Get all keys
  Future<Set<String>> getAllKeys() async {
    await _ensureInitialized();
    return _prefs.getKeys();
  }

  /// Export data for backup
  Future<Map<String, dynamic>> exportData() async {
    await _ensureInitialized();
    
    final data = <String, dynamic>{};
    final keys = _prefs.getKeys();
    
    for (final key in keys) {
      // Skip sensitive data
      if (key.contains('auth_token') || key.contains('refresh_token')) {
        continue;
      }
      
      data[key] = _prefs.get(key);
    }
    
    return data;
  }

  /// Import data from backup
  Future<void> importData(Map<String, dynamic> data) async {
    await _ensureInitialized();
    
    for (final entry in data.entries) {
      final key = entry.key;
      final value = entry.value;
      
      // Skip sensitive data
      if (key.contains('auth_token') || key.contains('refresh_token')) {
        continue;
      }
      
      if (value is String) {
        await _prefs.setString(key, value);
      } else if (value is bool) {
        await _prefs.setBool(key, value);
      } else if (value is int) {
        await _prefs.setInt(key, value);
      } else if (value is double) {
        await _prefs.setDouble(key, value);
      } else if (value is List<String>) {
        await _prefs.setStringList(key, value);
      }
    }
  }

  /// Check if key exists
  Future<bool> hasKey(String key) async {
    await _ensureInitialized();
    return _prefs.containsKey(key);
  }

  /// Remove specific key
  Future<void> removeKey(String key) async {
    await _ensureInitialized();
    await _prefs.remove(key);
  }

  /// Set string value
  Future<bool> setString(String key, String value) async {
    try {
      await _prefs.setString(key, value);
      return true;
    } catch (e) {
      debugPrint('Failed to set string: $e');
      return false;
    }
  }

  /// Get string value
  Future<String?> getValue(String key) async {
    try {
      return _prefs.getString(key);
    } catch (e) {
      debugPrint('Failed to get value: $e');
      return null;
    }
  }

  /// Save value (generic method)
  Future<bool> saveValue(String key, String value) async {
    return await setString(key, value);
  }

  /// Delete all stored data
  Future<bool> deleteAll() async {
    try {
      await _prefs.clear();
      return true;
    } catch (e) {
      debugPrint('Failed to delete all: $e');
      return false;
    }
  }

  /// Get offline queue
  Future<List<Map<String, dynamic>>?> getOfflineQueue() async {
    try {
      final jsonString = _prefs.getString('offline_queue');
      if (jsonString != null) {
        final List<dynamic> decoded = jsonDecode(jsonString);
        return decoded.map((item) => Map<String, dynamic>.from(item)).toList();
      }
      return null;
    } catch (e) {
      debugPrint('Failed to get offline queue: $e');
      return null;
    }
  }

  /// Save offline queue
  Future<bool> saveOfflineQueue(List<Map<String, dynamic>> queue) async {
    try {
      final jsonString = jsonEncode(queue);
      await _prefs.setString('offline_queue', jsonString);
      return true;
    } catch (e) {
      debugPrint('Failed to save offline queue: $e');
      return false;
    }
  }

  /// Cache data
  Future<bool> cacheData(String key, List<Map<String, dynamic>> data) async {
    try {
      final jsonString = jsonEncode(data);
      await _prefs.setString('cache_$key', jsonString);
      return true;
    } catch (e) {
      debugPrint('Failed to cache data: $e');
      return false;
    }
  }

  /// Get cached data
  Future<List<Map<String, dynamic>>?> getCachedData(String key) async {
    try {
      final jsonString = _prefs.getString('cache_$key');
      if (jsonString != null) {
        final List<dynamic> decoded = jsonDecode(jsonString);
        return decoded.map((item) => Map<String, dynamic>.from(item)).toList();
      }
      return null;
    } catch (e) {
      debugPrint('Failed to get cached data: $e');
      return null;
    }
  }

  /// Clear cache
  Future<bool> clearCache() async {
    try {
      final keys = _prefs.getKeys();
      for (final key in keys) {
        if (key.startsWith('cache_')) {
          await _prefs.remove(key);
        }
      }
      return true;
    } catch (e) {
      debugPrint('Failed to clear cache: $e');
      return false;
    }
  }
}