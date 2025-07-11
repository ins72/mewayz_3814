import 'dart:async';
import 'dart:io';
import 'dart:convert';

import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter/foundation.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

import './resilient_error_handler.dart';
import './storage_service.dart';

/// Rebuilt Supabase service with comprehensive error handling, connection recovery, and offline capabilities
class RebuiltSupabaseService {
  static RebuiltSupabaseService? _instance;
  static RebuiltSupabaseService get instance => _instance ??= RebuiltSupabaseService._internal();
  
  RebuiltSupabaseService._internal();

  late SupabaseClient _client;
  late StorageService _storageService;
  final ResilientErrorHandler _errorHandler = ResilientErrorHandler();
  final Connectivity _connectivity = Connectivity();
  
  bool _isInitialized = false;
  bool _isHealthy = false;
  bool _isOnline = true;
  Timer? _healthTimer;
  Timer? _reconnectTimer;
  StreamSubscription<ConnectivityResult>? _connectivitySubscription;
  int _healthCheckFailures = 0;
  int _reconnectAttempts = 0;
  
  static const int _maxHealthFailures = 3;
  static const int _maxReconnectAttempts = 5;
  static const Duration _healthInterval = Duration(seconds: 30);
  static const Duration _reconnectDelay = Duration(seconds: 5);

  // Environment variables with validation
  static const String supabaseUrl = String.fromEnvironment('SUPABASE_URL', defaultValue: '');
  static const String supabaseAnonKey = String.fromEnvironment('SUPABASE_ANON_KEY', defaultValue: '');

  /// Comprehensive initialization with offline support
  Future<void> initialize() async {
    if (_isInitialized) return;

    try {
      debugPrint('🚀 Initializing Rebuilt Supabase Service...');
      
      // Initialize storage service first
      _storageService = StorageService();
      await _storageService.initialize();
      
      // Validate environment variables
      _validateEnvironmentVariables();
      
      // Check network connectivity
      await _checkNetworkConnectivity();
      
      // Initialize Supabase with enhanced configuration
      await _initializeSupabaseClient();
      
      // Setup connection monitoring
      _setupConnectionMonitoring();
      
      // Start health monitoring
      _startHealthMonitoring();
      
      _isInitialized = true;
      debugPrint('✅ Rebuilt Supabase Service initialized successfully');
      
    } catch (e) {
      await _errorHandler.handleError(
        e,
        context: 'rebuilt_supabase_initialization',
        shouldRetry: true,
        maxRetries: 2);
      rethrow;
    }
  }

  /// Validate environment variables with detailed error messages
  void _validateEnvironmentVariables() {
    final List<String> issues = [];
    
    if (supabaseUrl.isEmpty) {
      issues.add('SUPABASE_URL is missing');
    } else if (!supabaseUrl.startsWith('https://') || !supabaseUrl.contains('.supabase.co')) {
      issues.add('SUPABASE_URL format is invalid (expected: https://your-project.supabase.co)');
    }
    
    if (supabaseAnonKey.isEmpty) {
      issues.add('SUPABASE_ANON_KEY is missing');
    } else if (supabaseAnonKey.length < 100) {
      issues.add('SUPABASE_ANON_KEY appears to be invalid (too short)');
    }
    
    if (issues.isNotEmpty) {
      throw Exception(
        'Supabase configuration errors:\n${issues.map((e) => '• $e').join('\n')}\n\n'
        'Please configure using --dart-define:\n'
        'flutter run --dart-define=SUPABASE_URL=your_url --dart-define=SUPABASE_ANON_KEY=your_key'
      );
    }
  }

  /// Check network connectivity
  Future<void> _checkNetworkConnectivity() async {
    try {
      final connectivityResult = await _connectivity.checkConnectivity();
      _isOnline = connectivityResult != ConnectivityResult.none;
      
      if (!_isOnline) {
        debugPrint('⚠️ Device is offline - enabling offline mode');
      }
    } catch (e) {
      debugPrint('Failed to check connectivity: $e');
      _isOnline = false;
    }
  }

  /// Initialize Supabase client with enhanced configuration
  Future<void> _initializeSupabaseClient() async {
    try {
      await Supabase.initialize(
        url: supabaseUrl,
        anonKey: supabaseAnonKey,
        debug: kDebugMode,
        realtimeClientOptions: const RealtimeClientOptions(),
        authOptions: const FlutterAuthClientOptions(
          authFlowType: AuthFlowType.pkce),
        storageOptions: const StorageClientOptions(
          retryAttempts: 3)).timeout(const Duration(seconds: 30));

      _client = Supabase.instance.client;
      
      // Test initial connection
      if (_isOnline) {
        _isHealthy = await _performHealthCheck();
      } else {
        _isHealthy = false;
      }
      
    } catch (e) {
      throw Exception('Failed to initialize Supabase client: $e');
    }
  }

  /// Setup connection monitoring
  void _setupConnectionMonitoring() {
    _connectivitySubscription = _connectivity.onConnectivityChanged.listen(
      (ConnectivityResult result) async {
        final wasOnline = _isOnline;
        _isOnline = result != ConnectivityResult.none;
        
        if (!wasOnline && _isOnline) {
          debugPrint('📡 Network restored - attempting reconnection');
          await _attemptReconnection();
        } else if (wasOnline && !_isOnline) {
          debugPrint('📵 Network lost - switching to offline mode');
          _isHealthy = false;
        }
      });
  }

  /// Start health monitoring
  void _startHealthMonitoring() {
    _healthTimer?.cancel();
    _healthTimer = Timer.periodic(_healthInterval, (_) {
      if (_isOnline) {
        _performPeriodicHealthCheck();
      }
    });
  }

  /// Perform periodic health check
  Future<void> _performPeriodicHealthCheck() async {
    try {
      final isHealthy = await _performHealthCheck();
      
      if (isHealthy && !_isHealthy) {
        debugPrint('✅ Supabase connection restored');
        _isHealthy = true;
        _healthCheckFailures = 0;
        _reconnectAttempts = 0;
        _stopReconnectionAttempts();
      } else if (!isHealthy && _isHealthy) {
        debugPrint('⚠️ Supabase connection degraded');
        _isHealthy = false;
        _healthCheckFailures++;
        
        if (_healthCheckFailures >= _maxHealthFailures) {
          await _handleConnectionFailure();
        }
      }
    } catch (e) {
      debugPrint('Health check error: $e');
      _healthCheckFailures++;
      
      if (_healthCheckFailures >= _maxHealthFailures) {
        await _handleConnectionFailure();
      }
    }
  }

  /// Perform comprehensive health check
  Future<bool> _performHealthCheck() async {
    try {
      // Test basic connectivity
      await _client
          .from('system_health_metrics')
          .select('count')
          .limit(1)
          .timeout(const Duration(seconds: 8));
      
      // Test auth state
      final session = _client.auth.currentSession;
      if (session != null && session.isExpired) {
        try {
          await _client.auth.refreshSession();
        } catch (e) {
          debugPrint('Session refresh failed during health check: $e');
        }
      }
      
      return true;
    } on TimeoutException {
      return false;
    } catch (e) {
      // Allow table not found errors (connection is working)
      if (e.toString().contains('relation') && e.toString().contains('does not exist')) {
        return true;
      }
      return false;
    }
  }

  /// Handle connection failure
  Future<void> _handleConnectionFailure() async {
    debugPrint('🔄 Handling Supabase connection failure...');
    _isHealthy = false;
    
    if (_isOnline && _reconnectAttempts < _maxReconnectAttempts) {
      await _startReconnectionAttempts();
    }
  }

  /// Start reconnection attempts
  Future<void> _startReconnectionAttempts() async {
    _reconnectTimer?.cancel();
    
    _reconnectTimer = Timer.periodic(_reconnectDelay, (_) async {
      if (_reconnectAttempts >= _maxReconnectAttempts) {
        _stopReconnectionAttempts();
        return;
      }
      
      await _attemptReconnection();
    });
  }

  /// Attempt reconnection
  Future<void> _attemptReconnection() async {
    if (!_isOnline || _reconnectAttempts >= _maxReconnectAttempts) return;
    
    _reconnectAttempts++;
    debugPrint('🔄 Reconnection attempt $_reconnectAttempts/$_maxReconnectAttempts');
    
    try {
      // Reinitialize client connection
      await _client.auth.refreshSession();
      
      // Test connection
      final isHealthy = await _performHealthCheck();
      
      if (isHealthy) {
        debugPrint('✅ Reconnection successful');
        _isHealthy = true;
        _healthCheckFailures = 0;
        _reconnectAttempts = 0;
        _stopReconnectionAttempts();
      }
    } catch (e) {
      debugPrint('Reconnection attempt failed: $e');
      
      // Use exponential backoff for next attempt
      if (_reconnectAttempts < _maxReconnectAttempts) {
        final delay = Duration(seconds: _reconnectDelay.inSeconds * _reconnectAttempts);
        await Future.delayed(delay);
      }
    }
  }

  /// Stop reconnection attempts
  void _stopReconnectionAttempts() {
    _reconnectTimer?.cancel();
    _reconnectTimer = null;
  }

  /// Execute operation with retry and offline fallback
  Future<T> executeWithRetry<T>(
    Future<T> Function() operation, {
    int maxRetries = 2,
    Duration delay = const Duration(seconds: 1),
    bool requiresConnection = true,
    T? offlineDefault,
  }) async {
    // Check if operation requires connection
    if (requiresConnection && (!_isOnline || !_isHealthy)) {
      if (offlineDefault != null) {
        debugPrint('📵 Returning offline default for operation');
        return offlineDefault;
      }
      throw Exception('Operation requires connection but service is offline');
    }

    Exception? lastException;
    
    for (int attempt = 0; attempt <= maxRetries; attempt++) {
      try {
        final result = await operation().timeout(const Duration(seconds: 25));
        
        // Update health status on successful operation
        if (!_isHealthy && _isOnline) {
          _isHealthy = true;
          _healthCheckFailures = 0;
          debugPrint('✅ Connection restored via successful operation');
        }
        
        return result;
      } on TimeoutException {
        lastException = Exception('Operation timed out after 25 seconds');
        _isHealthy = false;
        _healthCheckFailures++;
      } on SocketException {
        lastException = Exception('Network error: No internet connection');
        _isOnline = false;
        _isHealthy = false;
      } catch (e) {
        lastException = e is Exception ? e : Exception(e.toString());
        
        // Check if it's a connection-related error
        if (e.toString().contains('network') || 
            e.toString().contains('connection') ||
            e.toString().contains('timeout') ||
            e.toString().contains('socket')) {
          _isHealthy = false;
          _healthCheckFailures++;
        }
        
        if (attempt < maxRetries) {
          debugPrint('Operation failed (attempt ${attempt + 1}), retrying: $e');
          await Future.delayed(delay * (attempt + 1));
        }
      }
    }
    
    // If we have offline default and all retries failed, use it
    if (offlineDefault != null) {
      debugPrint('📵 All retries failed, returning offline default');
      return offlineDefault;
    }
    
    await _errorHandler.handleError(
      lastException!,
      context: 'rebuilt_execute_with_retry',
      metadata: {
        'max_retries': maxRetries,
        'requires_connection': requiresConnection,
        'is_online': _isOnline,
        'is_healthy': _isHealthy,
      },
      shouldRetry: false);
    
    throw lastException;
  }

  /// Cache data for offline use
  Future<void> cacheData(String key, dynamic data) async {
    try {
      await _storageService.setValue('cache_$key', jsonEncode(data));
      await _storageService.setValue('cache_${key}_timestamp', DateTime.now().toIso8601String());
    } catch (e) {
      debugPrint('Failed to cache data: $e');
    }
  }

  /// Get cached data
  Future<T?> getCachedData<T>(String key, T Function(Map<String, dynamic>) fromJson) async {
    try {
      final cachedData = await _storageService.getValue('cache_$key');
      final timestamp = await _storageService.getValue('cache_${key}_timestamp');
      
      if (cachedData != null && timestamp != null) {
        final cacheTime = DateTime.parse(timestamp);
        final isValid = DateTime.now().difference(cacheTime).inHours < 24;
        
        if (isValid) {
          final decodedData = jsonDecode(cachedData) as Map<String, dynamic>;
          return fromJson(decodedData);
        }
      }
    } catch (e) {
      debugPrint('Failed to get cached data: $e');
    }
    return null;
  }

  /// Get comprehensive service status
  Map<String, dynamic> getServiceStatus() {
    return {
      'is_initialized': _isInitialized,
      'is_healthy': _isHealthy,
      'is_online': _isOnline,
      'health_check_failures': _healthCheckFailures,
      'reconnect_attempts': _reconnectAttempts,
      'max_health_failures': _maxHealthFailures,
      'max_reconnect_attempts': _maxReconnectAttempts,
      'health_monitoring_active': _healthTimer?.isActive ?? false,
      'reconnection_active': _reconnectTimer?.isActive ?? false,
      'connectivity_monitoring_active': _connectivitySubscription != null,
      'url_configured': supabaseUrl.isNotEmpty,
      'key_configured': supabaseAnonKey.isNotEmpty,
      'service_type': 'rebuilt',
      'last_status_check': DateTime.now().toIso8601String(),
    };
  }

  /// Get connection health score (0-100)
  int getConnectionHealthScore() {
    if (!_isInitialized) return 0;
    if (!_isOnline) return 10;
    if (!_isHealthy) return 25;
    if (_healthCheckFailures > 0) return 75 - (_healthCheckFailures * 15);
    if (_reconnectAttempts > 0) return 85 - (_reconnectAttempts * 5);
    return 100;
  }

  /// Force connection test
  Future<bool> testConnection() async {
    if (!_isOnline) return false;
    return await _performHealthCheck();
  }

  /// Get client (throws if not initialized)
  SupabaseClient get client {
    if (!_isInitialized) {
      throw Exception('RebuiltSupabaseService not initialized. Call initialize() first.');
    }
    return _client;
  }

  /// Getters
  bool get isInitialized => _isInitialized;
  bool get isHealthy => _isHealthy;
  bool get isOnline => _isOnline;
  int get healthCheckFailures => _healthCheckFailures;
  int get reconnectAttempts => _reconnectAttempts;

  /// Dispose resources
  void dispose() {
    _healthTimer?.cancel();
    _reconnectTimer?.cancel();
    _connectivitySubscription?.cancel();
    _errorHandler.dispose();
  }
}