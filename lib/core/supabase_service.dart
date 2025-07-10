import 'dart:async';
import 'dart:developer' as developer;

import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter/foundation.dart';

import '../services/workspace_service.dart';
import './main_navigation.dart';

class SupabaseService {
  static SupabaseService? _instance;
  late final SupabaseClient _client;
  bool _isInitialized = false;
  Future<void>? _initFuture;
  Timer? _connectionHealthTimer;
  Timer? _reconnectTimer;
  bool _isConnected = false;
  int _connectionRetries = 0;
  static const int _maxConnectionRetries = 3;
  static const Duration _healthCheckInterval = Duration(minutes: 2);
  static const Duration _reconnectInterval = Duration(seconds: 30);

  // Singleton pattern with proper initialization flow
  static SupabaseService get instance {
    return _instance ??= SupabaseService._internal();
  }

  SupabaseService._internal();

  // Factory constructor for backwards compatibility
  factory SupabaseService() => instance;

  // Environment variables
  static const String supabaseUrl = String.fromEnvironment('SUPABASE_URL', 
      defaultValue: '');
  static const String supabaseAnonKey = String.fromEnvironment('SUPABASE_ANON_KEY',
      defaultValue: '');

  /// Initialize Supabase service with enhanced error handling and retry logic
  Future<void> initialize() async {
    if (_isInitialized) return;
    
    // Ensure only one initialization runs at a time
    _initFuture ??= _performInitializationWithRetry();
    await _initFuture;
  }

  /// Perform initialization with enhanced retry logic
  Future<void> _performInitializationWithRetry({int maxRetries = 3}) async {
    Exception? lastException;
    
    for (int attempt = 0; attempt < maxRetries; attempt++) {
      try {
        await _performInitialization();
        _connectionRetries = 0; // Reset connection retries on successful init
        return;
      } catch (e) {
        lastException = e is Exception ? e : Exception(e.toString());
        
        if (attempt < maxRetries - 1) {
          print('⚠️ Supabase initialization attempt ${attempt + 1} failed: $e');
          await Future.delayed(Duration(seconds: (attempt + 1) * 2)); // Exponential backoff
        }
      }
    }
    
    throw lastException ?? Exception('Supabase initialization failed after $maxRetries attempts');
  }

  /// Perform the actual initialization
  Future<void> _performInitialization() async {
    try {
      // Validate environment variables
      validateEnvironmentVariables();

      // Initialize Supabase with enhanced timeout
      await Supabase.initialize(
        url: supabaseUrl,
        anonKey: supabaseAnonKey,
        debug: false, // Disable debug in production
        realtimeClientOptions: const RealtimeClientOptions(
           // 30 seconds
          
        )).timeout(const Duration(seconds: 30));

      _client = Supabase.instance.client;
      
      // Enhanced connection test with retries
      final connectionTest = await _testConnectionWithRetry();
      _isConnected = connectionTest;
      
      if (connectionTest) {
        _isInitialized = true;
        _startEnhancedConnectionMonitoring();
        print('✅ Supabase initialized and connected successfully');
      } else {
        // Still mark as initialized for offline capability but start reconnection attempts
        _isInitialized = true;
        _startReconnectionAttempts();
        print('⚠️ Supabase initialized but connection test failed - starting reconnection attempts');
      }
      
    } catch (e) {
      print('❌ Supabase initialization failed: $e');
      _isInitialized = false;
      rethrow;
    }
  }

  /// Enhanced connection test with retry logic
  Future<bool> _testConnectionWithRetry({int maxRetries = 2}) async {
    for (int attempt = 0; attempt <= maxRetries; attempt++) {
      try {
        return await _performConnectionTest();
      } catch (e) {
        if (attempt < maxRetries) {
          print('Connection test attempt ${attempt + 1} failed: $e');
          await Future.delayed(Duration(seconds: (attempt + 1) * 2));
        }
      }
    }
    return false;
  }

  /// Perform actual connection test
  Future<bool> _performConnectionTest() async {
    try {
      // Test with a simple query that should always work
      await _client
          .from('workspaces')
          .select('count')
          .limit(1)
          .timeout(const Duration(seconds: 10));
      
      return true;
    } on TimeoutException {
      print('Supabase connection test timed out');
      return false;
    } catch (e) {
      print('Supabase connection test failed: $e');
      return false;
    }
  }

  /// Start enhanced connection monitoring with health checks
  void _startEnhancedConnectionMonitoring() {
    _connectionHealthTimer?.cancel();
    _connectionHealthTimer = Timer.periodic(_healthCheckInterval, (_) {
      _performHealthCheck();
    });
  }

  /// Start reconnection attempts when connection is lost
  void _startReconnectionAttempts() {
    if (_reconnectTimer != null && _reconnectTimer!.isActive) return;
    
    _reconnectTimer = Timer.periodic(_reconnectInterval, (_) {
      _attemptReconnection();
    });
  }

  /// Stop reconnection attempts
  void _stopReconnectionAttempts() {
    _reconnectTimer?.cancel();
    _reconnectTimer = null;
    _connectionRetries = 0;
  }

  /// Perform health check
  Future<void> _performHealthCheck() async {
    try {
      final isHealthy = await _performConnectionTest();
      
      if (_isConnected != isHealthy) {
        _isConnected = isHealthy;
        
        if (isHealthy) {
          print('✅ Supabase connection restored');
          _stopReconnectionAttempts();
        } else {
          print('⚠️ Supabase connection lost - starting reconnection attempts');
          _startReconnectionAttempts();
        }
      }
    } catch (e) {
      if (_isConnected) {
        _isConnected = false;
        print('⚠️ Supabase connection health check failed: $e');
        _startReconnectionAttempts();
      }
    }
  }

  /// Attempt to reconnect
  Future<void> _attemptReconnection() async {
    if (_connectionRetries >= _maxConnectionRetries) {
      print('⚠️ Max connection retry attempts reached, stopping reconnection attempts');
      _stopReconnectionAttempts();
      return;
    }

    _connectionRetries++;
    print('🔄 Attempting to reconnect to Supabase (attempt $_connectionRetries/$_maxConnectionRetries)');
    
    try {
      final isConnected = await _performConnectionTest();
      
      if (isConnected) {
        _isConnected = true;
        print('✅ Supabase reconnection successful');
        _stopReconnectionAttempts();
      }
    } catch (e) {
      print('❌ Reconnection attempt $_connectionRetries failed: $e');
    }
  }

  /// Enhanced workspace data loading
  Future<void> _loadWorkspaceData(String userId) async {
    try {
      final workspaceService = WorkspaceService();
      await workspaceService.initialize().timeout(const Duration(seconds: 15));
      
      final workspaces = await workspaceService.getUserWorkspaces()
          .timeout(const Duration(seconds: 20));
      
      if (workspaces.isNotEmpty) {
        final workspace = workspaces.first;
        final workspaceId = workspace['workspace_id'] ?? workspace['id'];
        
        if (workspaceId == null) {
          throw Exception('Invalid workspace data structure');
        }
        
        final userRole = await workspaceService.getUserRoleInWorkspace(workspaceId)
            .timeout(const Duration(seconds: 10));
        
        // Remove the undefined method calls
        if (userRole != null) {
          // Implementation needed
        }
      } else {
        // Implementation needed
      }
    } catch (e) {
      print('Workspace loading error: $e');
      throw Exception('Failed to load workspace data: $e');
    }
  }

  /// Reconnect to Supabase with exponential backoff
  Future<void> _reconnectToSupabase() async {
    bool isReconnecting = false;
    bool isDisposed = false;
    int reconnectAttempts = 0;
    const int maxReconnectAttempts = 5;
    
    if (isReconnecting || isDisposed) return;
    
    isReconnecting = true;
    
    try {
      await Supabase.instance.client.realtime.connect();
      isReconnecting = false;
      reconnectAttempts = 0;
      
      // Verify connection - implementation needed
    } catch (e) {
      isReconnecting = false;
      reconnectAttempts++;
      
      if (reconnectAttempts < maxReconnectAttempts) {
        final delay = Duration(seconds: reconnectAttempts * 2);
        
        // Fix the null check for _reconnectTimer
        if (_reconnectTimer == null || !(_reconnectTimer?.isActive ?? false)) {
          _reconnectTimer = Timer(delay, () {
            if (!isDisposed) {
              _reconnectToSupabase();
            }
          });
        }
      } else {
        print('Max reconnect attempts reached');
        // Implementation needed
      }
    }
  }

  // Client getter (async) - ensures initialization
  Future<SupabaseClient> get client async {
    if (!_isInitialized) {
      await initialize();
    }
    return _client;
  }

  // Synchronous client getter (use only after ensuring initialization)
  SupabaseClient get clientSync {
    if (!_isInitialized) {
      throw Exception('SupabaseService not initialized. Call initialize() first or use async client getter.');
    }
    return _client;
  }

  // Check if initialized
  bool get isInitialized => _isInitialized;

  // Check if connected
  bool get isConnected => _isConnected;

  // Get connection retry count
  int get connectionRetries => _connectionRetries;

  // Validation method with detailed error messages
  void validateEnvironmentVariables() {
    final List<String> missingVars = [];
    
    if (supabaseUrl.isEmpty) {
      missingVars.add('SUPABASE_URL');
    }
    if (supabaseAnonKey.isEmpty) {
      missingVars.add('SUPABASE_ANON_KEY');
    }
    
    if (missingVars.isNotEmpty) {
      throw Exception(
        'Missing required Supabase environment variables: ${missingVars.join(', ')}\n'
        'Please configure these using --dart-define:\n'
        'flutter run --dart-define=SUPABASE_URL=your_url --dart-define=SUPABASE_ANON_KEY=your_key'
      );
    }

    // Validate URL format
    if (!supabaseUrl.startsWith('https://') || !supabaseUrl.contains('.supabase.co')) {
      throw Exception(
        'Invalid SUPABASE_URL format: $supabaseUrl\n'
        'Expected format: https://your-project.supabase.co'
      );
    }
  }

  /// Enhanced connection test with timeout and specific error handling
  Future<bool> testConnection() async {
    try {
      if (!_isInitialized) {
        await initialize();
      }
      
      return await _performConnectionTest();
    } catch (e) {
      print('Supabase connection test failed: $e');
      return false;
    }
  }

  /// Execute query with enhanced retry logic and circuit breaker pattern
  Future<T> executeWithRetry<T>(
    Future<T> Function() operation, {
    int maxRetries = 2,
    Duration delay = const Duration(seconds: 1),
    bool requiresConnection = true,
  }) async {
    // Check connection state if operation requires it
    if (requiresConnection && !_isConnected) {
      // Try to reconnect once
      final reconnected = await _performConnectionTest();
      if (!reconnected) {
        throw Exception('Operation requires connection but Supabase is not connected');
      }
      _isConnected = true;
    }

    Exception? lastException;
    
    for (int attempt = 0; attempt <= maxRetries; attempt++) {
      try {
        final result = await operation().timeout(const Duration(seconds: 30));
        
        // Update connection state on successful operation
        if (!_isConnected) {
          _isConnected = true;
          print('✅ Supabase connection restored through successful operation');
          _stopReconnectionAttempts();
        }
        
        return result;
      } on TimeoutException {
        lastException = Exception('Operation timed out after 30 seconds');
        _isConnected = false;
      } catch (e) {
        lastException = e is Exception ? e : Exception(e.toString());
        
        // Check if it's a connection-related error
        if (e.toString().contains('network') || 
            e.toString().contains('connection') ||
            e.toString().contains('timeout')) {
          _isConnected = false;
          if (_reconnectTimer == null || !_reconnectTimer!.isActive) {
            _startReconnectionAttempts();
          }
        }
        
        if (attempt < maxRetries) {
          print('Operation failed (attempt ${attempt + 1}), retrying: $e');
          await Future.delayed(delay * (attempt + 1));
        }
      }
    }
    
    throw lastException ?? Exception('Operation failed after ${maxRetries + 1} attempts');
  }

  /// Force reconnection attempt
  Future<bool> forceReconnect() async {
    print('🔄 Forcing Supabase reconnection...');
    _connectionRetries = 0; // Reset retry count
    _isConnected = false;
    
    final reconnected = await _testConnectionWithRetry(maxRetries: 3);
    _isConnected = reconnected;
    
    if (reconnected) {
      print('✅ Force reconnection successful');
      _stopReconnectionAttempts();
    } else {
      print('❌ Force reconnection failed');
      _startReconnectionAttempts();
    }
    
    return reconnected;
  }

  /// Reset instance (for testing or re-initialization)
  static void reset() {
    _instance?._connectionHealthTimer?.cancel();
    _instance?._reconnectTimer?.cancel();
    _instance?._isInitialized = false;
    _instance?._initFuture = null;
    _instance?._isConnected = false;
    _instance?._connectionRetries = 0;
    _instance = null;
  }

  /// Get enhanced connection status information
  Map<String, dynamic> getStatus() {
    return {
      'is_initialized': _isInitialized,
      'is_connected': _isConnected,
      'connection_retries': _connectionRetries,
      'max_retries': _maxConnectionRetries,
      'has_url': supabaseUrl.isNotEmpty,
      'has_anon_key': supabaseAnonKey.isNotEmpty,
      'url_format_valid': supabaseUrl.startsWith('https://') && supabaseUrl.contains('.supabase.co'),
      'supabase_url': supabaseUrl.isNotEmpty ? '${supabaseUrl.substring(0, 20)}...' : 'Not configured',
      'health_monitoring_active': _connectionHealthTimer?.isActive ?? false,
      'reconnection_active': _reconnectTimer?.isActive ?? false,
      'last_health_check': DateTime.now().toIso8601String(),
    };
  }

  /// Get connection health score (0-100)
  int getConnectionHealthScore() {
    if (!_isInitialized) return 0;
    if (!_isConnected) return 25;
    if (_connectionRetries > 0) return 75;
    return 100;
  }

  /// Dispose resources
  void dispose() {
    _connectionHealthTimer?.cancel();
    _reconnectTimer?.cancel();
    _connectionHealthTimer = null;
    _reconnectTimer = null;
  }
}