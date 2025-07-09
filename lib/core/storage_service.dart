import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import './error_handler.dart';
import './production_config.dart';

/// Custom exception for storage-related errors
class StorageException implements Exception {
  final String message;
  StorageException(this.message);
}

/// Service for managing local storage
class StorageService {
  static final StorageService _instance = StorageService._internal();
  factory StorageService() => _instance;
  StorageService._internal();
  
  SharedPreferences? _prefs;
  
  Future<void> initialize() async {
    try {
      _prefs = await SharedPreferences.getInstance();
    } catch (e) {
      ErrorHandler.handleError(StorageException('Failed to initialize storage: $e'));
    }
  }
  
  SharedPreferences get prefs {
    if (_prefs == null) {
      throw StorageException('Storage not initialized. Call initialize() first.');
    }
    return _prefs!;
  }
  
  // Auth token management
  Future<void> saveAuthToken(String token) async {
    try {
      await prefs.setString('auth_token', token);
      await prefs.setInt('auth_token_timestamp', DateTime.now().millisecondsSinceEpoch);
    } catch (e) {
      ErrorHandler.handleError(StorageException('Failed to save auth token: $e'));
    }
  }
  
  Future<String?> getAuthToken() async {
    try {
      final token = prefs.getString('auth_token');
      final timestamp = prefs.getInt('auth_token_timestamp');
      
      if (token != null && timestamp != null) {
        final tokenDate = DateTime.fromMillisecondsSinceEpoch(timestamp);
        final now = DateTime.now();
        
        if (now.difference(tokenDate) > ProductionConfig.sessionTimeout) {
          await clearAuthData();
          return null;
        }
        
        return token;
      }
      
      return null;
    } catch (e) {
      ErrorHandler.handleError(StorageException('Failed to get auth token: $e'));
      return null;
    }
  }
  
  Future<void> saveRefreshToken(String refreshToken) async {
    try {
      await prefs.setString('refresh_token', refreshToken);
      await prefs.setInt('refresh_token_timestamp', DateTime.now().millisecondsSinceEpoch);
    } catch (e) {
      ErrorHandler.handleError(StorageException('Failed to save refresh token: $e'));
    }
  }
  
  Future<String?> getRefreshToken() async {
    try {
      final token = prefs.getString('refresh_token');
      final timestamp = prefs.getInt('refresh_token_timestamp');
      
      if (token != null && timestamp != null) {
        final tokenDate = DateTime.fromMillisecondsSinceEpoch(timestamp);
        final now = DateTime.now();
        
        if (now.difference(tokenDate) > ProductionConfig.refreshTokenTimeout) {
          await clearAuthData();
          return null;
        }
        
        return token;
      }
      
      return null;
    } catch (e) {
      ErrorHandler.handleError(StorageException('Failed to get refresh token: $e'));
      return null;
    }
  }
  
  Future<void> clearAuthData() async {
    try {
      await prefs.remove('auth_token');
      await prefs.remove('auth_token_timestamp');
      await prefs.remove('refresh_token');
      await prefs.remove('refresh_token_timestamp');
      await prefs.remove('user_data');
    } catch (e) {
      ErrorHandler.handleError(StorageException('Failed to clear auth data: $e'));
    }
  }
  
  // User data management
  Future<void> saveUserData(Map<String, dynamic> userData) async {
    try {
      await prefs.setString('user_data', jsonEncode(userData));
    } catch (e) {
      ErrorHandler.handleError(StorageException('Failed to save user data: $e'));
    }
  }
  
  Future<Map<String, dynamic>?> getUserData() async {
    try {
      final userData = prefs.getString('user_data');
      if (userData != null) {
        return jsonDecode(userData);
      }
      return null;
    } catch (e) {
      ErrorHandler.handleError(StorageException('Failed to get user data: $e'));
      return null;
    }
  }
  
  // App settings
  Future<void> saveAppSettings(Map<String, dynamic> settings) async {
    try {
      await prefs.setString('app_settings', jsonEncode(settings));
    } catch (e) {
      ErrorHandler.handleError(StorageException('Failed to save app settings: $e'));
    }
  }
  
  Future<Map<String, dynamic>?> getAppSettings() async {
    try {
      final settings = prefs.getString('app_settings');
      if (settings != null) {
        return jsonDecode(settings);
      }
      return null;
    } catch (e) {
      ErrorHandler.handleError(StorageException('Failed to get app settings: $e'));
      return null;
    }
  }
  
  // Theme preferences
  Future<void> saveThemeMode(String themeMode) async {
    try {
      await prefs.setString('theme_mode', themeMode);
    } catch (e) {
      ErrorHandler.handleError(StorageException('Failed to save theme mode: $e'));
    }
  }
  
  Future<String?> getThemeMode() async {
    try {
      return prefs.getString('theme_mode');
    } catch (e) {
      ErrorHandler.handleError(StorageException('Failed to get theme mode: $e'));
      return null;
    }
  }
  
  // Notification preferences
  Future<void> saveNotificationSettings(Map<String, bool> settings) async {
    try {
      await prefs.setString('notification_settings', jsonEncode(settings));
    } catch (e) {
      ErrorHandler.handleError(StorageException('Failed to save notification settings: $e'));
    }
  }
  
  Future<Map<String, bool>?> getNotificationSettings() async {
    try {
      final settings = prefs.getString('notification_settings');
      if (settings != null) {
        final decoded = jsonDecode(settings) as Map<String, dynamic>;
        return decoded.cast<String, bool>();
      }
      return null;
    } catch (e) {
      ErrorHandler.handleError(StorageException('Failed to get notification settings: $e'));
      return null;
    }
  }
  
  // Cache management
  Future<void> saveCacheData(String key, dynamic data, {Duration? expiry}) async {
    try {
      final cacheItem = {
        'data': data,
        'timestamp': DateTime.now().millisecondsSinceEpoch,
        'expiry': expiry?.inMilliseconds,
      };
      await prefs.setString('cache_$key', jsonEncode(cacheItem));
    } catch (e) {
      ErrorHandler.handleError(StorageException('Failed to save cache data: $e'));
    }
  }
  
  Future<T?> getCacheData<T>(String key) async {
    try {
      final cached = prefs.getString('cache_$key');
      if (cached != null) {
        final cacheItem = jsonDecode(cached);
        final timestamp = cacheItem['timestamp'] as int;
        final expiry = cacheItem['expiry'] as int?;
        
        if (expiry != null) {
          final expiryDate = DateTime.fromMillisecondsSinceEpoch(timestamp + expiry);
          if (DateTime.now().isAfter(expiryDate)) {
            await clearCacheData(key);
            return null;
          }
        }
        
        return cacheItem['data'] as T?;
      }
      return null;
    } catch (e) {
      ErrorHandler.handleError(StorageException('Failed to get cache data: $e'));
      return null;
    }
  }
  
  Future<void> clearCacheData(String key) async {
    try {
      await prefs.remove('cache_$key');
    } catch (e) {
      ErrorHandler.handleError(StorageException('Failed to clear cache data: $e'));
    }
  }
  
  Future<void> clearAllCache() async {
    try {
      final keys = prefs.getKeys().where((key) => key.startsWith('cache_'));
      for (final key in keys) {
        await prefs.remove(key);
      }
    } catch (e) {
      ErrorHandler.handleError(StorageException('Failed to clear all cache: $e'));
    }
  }
  
  // Generic storage methods
  Future<void> saveString(String key, String value) async {
    try {
      await prefs.setString(key, value);
    } catch (e) {
      ErrorHandler.handleError(StorageException('Failed to save string: $e'));
    }
  }

  // Generic write method (alias for saveString)
  Future<void> write(String key, String value) async {
    try {
      await prefs.setString(key, value);
    } catch (e) {
      ErrorHandler.handleError(StorageException('Failed to write data: $e'));
    }
  }

  // Onboarding completion tracking
  Future<void> saveOnboardingCompleted(bool completed) async {
    try {
      await prefs.setBool('onboarding_completed', completed);
    } catch (e) {
      ErrorHandler.handleError(StorageException('Failed to save onboarding completion: $e'));
    }
  }
  
  Future<bool> getOnboardingCompleted() async {
    try {
      return prefs.getBool('onboarding_completed') ?? false;
    } catch (e) {
      ErrorHandler.handleError(StorageException('Failed to get onboarding completion: $e'));
      return false;
    }
  }
  
  // Workspace management
  Future<void> saveCurrentWorkspace(String workspaceId) async {
    try {
      await prefs.setString('current_workspace', workspaceId);
    } catch (e) {
      ErrorHandler.handleError(StorageException('Failed to save current workspace: $e'));
    }
  }
  
  Future<String?> getCurrentWorkspace() async {
    try {
      return prefs.getString('current_workspace');
    } catch (e) {
      ErrorHandler.handleError(StorageException('Failed to get current workspace: $e'));
      return null;
    }
  }
  
  Future<void> saveWorkspacesData(List<Map<String, dynamic>> workspaces) async {
    try {
      await prefs.setString('workspaces_data', jsonEncode(workspaces));
    } catch (e) {
      ErrorHandler.handleError(StorageException('Failed to save workspaces data: $e'));
    }
  }
  
  Future<List<Map<String, dynamic>>?> getWorkspacesData() async {
    try {
      final data = prefs.getString('workspaces_data');
      if (data != null) {
        final List<dynamic> decoded = jsonDecode(data);
        return decoded.cast<Map<String, dynamic>>();
      }
      return null;
    } catch (e) {
      ErrorHandler.handleError(StorageException('Failed to get workspaces data: $e'));
      return null;
    }
  }

  Future<String?> getString(String key) async {
    try {
      return prefs.getString(key);
    } catch (e) {
      ErrorHandler.handleError(StorageException('Failed to get string: $e'));
      return null;
    }
  }
  
  Future<void> saveInt(String key, int value) async {
    try {
      await prefs.setInt(key, value);
    } catch (e) {
      ErrorHandler.handleError(StorageException('Failed to save int: $e'));
    }
  }
  
  Future<int?> getInt(String key) async {
    try {
      return prefs.getInt(key);
    } catch (e) {
      ErrorHandler.handleError(StorageException('Failed to get int: $e'));
      return null;
    }
  }
  
  Future<void> saveBool(String key, bool value) async {
    try {
      await prefs.setBool(key, value);
    } catch (e) {
      ErrorHandler.handleError(StorageException('Failed to save bool: $e'));
    }
  }
  
  Future<bool?> getBool(String key) async {
    try {
      return prefs.getBool(key);
    } catch (e) {
      ErrorHandler.handleError(StorageException('Failed to get bool: $e'));
      return null;
    }
  }
  
  Future<void> remove(String key) async {
    try {
      await prefs.remove(key);
    } catch (e) {
      ErrorHandler.handleError(StorageException('Failed to remove key: $e'));
    }
  }
  
  Future<void> clear() async {
    try {
      await prefs.clear();
    } catch (e) {
      ErrorHandler.handleError(StorageException('Failed to clear storage: $e'));
    }
  }
}