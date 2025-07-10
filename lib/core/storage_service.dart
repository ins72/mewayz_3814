import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class StorageService {
  static final StorageService _instance = StorageService._internal();
  factory StorageService() => _instance;
  StorageService._internal();

  SharedPreferences? _prefs;

  Future<void> initialize() async {
    _prefs ??= await SharedPreferences.getInstance();
  }

  Future<void> init() async {
    await initialize();
  }

  // Add missing write method
  Future<void> write({required String key, required String value}) async {
    await initialize();
    await _prefs?.setString(key, value);
  }

  // Add missing read method
  Future<String?> read({required String key}) async {
    await initialize();
    return _prefs?.getString(key);
  }

  Future<void> setValue(String key, String value) async {
    await initialize();
    await _prefs?.setString(key, value);
  }

  Future<String?> getValue(String key) async {
    await initialize();
    return _prefs?.getString(key);
  }

  Future<void> setBool(String key, bool value) async {
    await initialize();
    await _prefs?.setBool(key, value);
  }

  Future<bool?> getBool(String key) async {
    await initialize();
    return _prefs?.getBool(key);
  }

  Future<void> remove(String key) async {
    await initialize();
    await _prefs?.remove(key);
  }

  Future<void> clear() async {
    await initialize();
    await _prefs?.clear();
  }

  // Save generic data
  Future<void> save(String key, String value) async {
    await setValue(key, value);
  }

  // Get generic data
  Future<String?> get(String key) async {
    return await getValue(key);
  }

  // Generic data storage methods
  Future<void> saveData(String key, dynamic data) async {
    await setValue(key, jsonEncode(data));
  }

  Future<dynamic> getData(String key) async {
    final dataString = await getValue(key);
    if (dataString != null) {
      try {
        return jsonDecode(dataString);
      } catch (e) {
        return null;
      }
    }
    return null;
  }

  // Store method for compatibility
  Future<void> store(String key, String value) async {
    await setValue(key, value);
  }

  // Token management methods
  Future<void> saveToken(String token) async {
    await setValue('auth_token', token);
  }

  Future<String?> getToken() async {
    return await getValue('auth_token');
  }

  Future<void> saveRefreshToken(String? refreshToken) async {
    if (refreshToken != null) {
      await setValue('refresh_token', refreshToken);
    } else {
      await remove('refresh_token');
    }
  }

  Future<String?> getRefreshToken() async {
    return await getValue('refresh_token');
  }

  Future<void> clearTokens() async {
    await remove('auth_token');
    await remove('refresh_token');
  }

  // Clear all data method
  Future<void> clearAllData() async {
    await initialize();
    await _prefs?.clear();
  }

  // User data management
  Future<void> saveUser(Map<String, dynamic> userData) async {
    await setValue('user_data', jsonEncode(userData));
  }

  Future<Map<String, dynamic>?> getUser() async {
    final userDataString = await getValue('user_data');
    if (userDataString != null) {
      try {
        return jsonDecode(userDataString);
      } catch (e) {
        return null;
      }
    }
    return null;
  }

  Future<void> clearUser() async {
    await remove('user_data');
  }

  // Auth token management
  Future<void> saveAuthToken(String? token) async {
    if (token != null) {
      await setValue('auth_token', token);
    } else {
      await remove('auth_token');
    }
  }

  Future<String?> getAuthToken() async {
    return await getValue('auth_token');
  }

  Future<void> clearAuthData() async {
    await remove('auth_token');
    await remove('refresh_token');
    await remove('user_data');
  }
}