import 'dart:async';

import 'package:supabase_flutter/supabase_flutter.dart';

import './environment_config.dart';
import 'app_export.dart';

/// Enhanced Supabase service with optimized performance and error handling
class EnhancedSupabaseService {
  static EnhancedSupabaseService? _instance;
  late final SupabaseClient _client;
  bool _isInitialized = false;
  Future<void>? _initFuture;

  // Performance optimization features
  final Map<String, dynamic> _queryCache = {};
  final Map<String, DateTime> _cacheExpiry = {};
  Timer? _cacheCleanupTimer;
  
  // Connection monitoring
  bool _isOnline = true;
  StreamSubscription<ConnectivityResult>? _connectivitySubscription;
  final List<String> _offlineQueue = [];
  
  // Retry mechanism
  final Map<String, int> _retryAttempts = {};
  static const int maxRetryAttempts = 3;
  static const Duration retryDelay = Duration(seconds: 2);

  // Singleton pattern with enhanced initialization
  static EnhancedSupabaseService get instance {
    return _instance ??= EnhancedSupabaseService._internal();
  }

  EnhancedSupabaseService._internal() {
    _setupConnectivityMonitoring();
    _setupCacheCleanup();
  }

  // Factory constructor for backwards compatibility
  factory EnhancedSupabaseService() => instance;

  // Environment variables with validation
  static const String supabaseUrl = String.fromEnvironment('SUPABASE_URL', 
      defaultValue: '');
  static const String supabaseAnonKey = String.fromEnvironment('SUPABASE_ANON_KEY',
      defaultValue: '');

  /// Initialize Enhanced Supabase service with performance optimizations
  Future<void> initialize() async {
    if (_isInitialized) return;
    
    // Ensure only one initialization runs at a time
    _initFuture ??= _performEnhancedInitialization();
    await _initFuture;
  }

  /// Perform the enhanced initialization with optimizations
  Future<void> _performEnhancedInitialization() async {
    try {
      // Validate environment variables
      _validateEnvironmentVariables();

      // Initialize Supabase with optimized configuration
      await Supabase.initialize(
        url: supabaseUrl,
        anonKey: supabaseAnonKey,
        debug: !EnvironmentConfig.isProduction,
        realtimeClientOptions: const RealtimeClientOptions(
          logLevel: RealtimeLogLevel.info,
          timeout: Duration(seconds: 30),
        ),
      );

      _client = Supabase.instance.client;
      _isInitialized = true;
      
      // Setup enhanced monitoring
      await _setupEnhancedMonitoring();
      
      debugPrint('✅ Enhanced Supabase initialized successfully');
    } catch (e) {
      debugPrint('❌ Enhanced Supabase initialization failed: $e');
      _isInitialized = false;
      
      // Log error for monitoring
      await _logInitializationError(e);
      rethrow;
    }
  }

  /// Setup enhanced monitoring and health checks
  Future<void> _setupEnhancedMonitoring() async {
    try {
      // Test connection and log performance metrics
      final stopwatch = Stopwatch()..start();
      await _client.from('workspaces').select('count').limit(1);
      stopwatch.stop();
      
      // Log connection performance
      await _recordPerformanceMetric('connection_test', stopwatch.elapsedMilliseconds);
      
      // Setup periodic health checks
      Timer.periodic(const Duration(minutes: 5), (_) {
        _performHealthCheck();
      });
    } catch (e) {
      debugPrint('Enhanced monitoring setup failed: $e');
    }
  }

  /// Setup connectivity monitoring
  void _setupConnectivityMonitoring() {
    try {
      final connectivity = Connectivity();
      _connectivitySubscription = connectivity.onConnectivityChanged.listen((result) {
        final wasOnline = _isOnline;
        _isOnline = result != ConnectivityResult.none;
        
        if (!wasOnline && _isOnline) {
          _onNetworkReconnection();
        } else if (wasOnline && !_isOnline) {
          _onNetworkDisconnection();
        }
      });
    } catch (e) {
      debugPrint('Connectivity monitoring setup failed: $e');
    }
  }

  /// Setup cache cleanup
  void _setupCacheCleanup() {
    _cacheCleanupTimer = Timer.periodic(const Duration(minutes: 15), (_) {
      _cleanupExpiredCache();
    });
  }

  /// Enhanced query method with caching and retry logic
  Future<PostgrestResponse<T>> enhancedQuery<T>(
    String table,
    String Function(PostgrestQueryBuilder) queryBuilder, {
    bool useCache = true,
    Duration? cacheDuration,
    int? maxRetries,
  }) async {
    await _ensureInitialized();
    
    final cacheKey = _generateCacheKey(table, queryBuilder.toString());
    final retries = maxRetries ?? maxRetryAttempts;
    
    // Check cache first
    if (useCache && _queryCache.containsKey(cacheKey)) {
      final expiry = _cacheExpiry[cacheKey];
      if (expiry != null && DateTime.now().isBefore(expiry)) {
        await _recordPerformanceMetric('cache_hit', 0);
        return _queryCache[cacheKey] as PostgrestResponse<T>;
      }
    }
    
    // Execute query with retry logic
    for (int attempt = 0; attempt < retries; attempt++) {
      try {
        final stopwatch = Stopwatch()..start();
        
        final query = _client.from(table);
        final response = await queryBuilder(query) as PostgrestResponse<T>;
        
        stopwatch.stop();
        
        // Cache successful response
        if (useCache) {
          _cacheResponse(cacheKey, response, cacheDuration);
        }
        
        // Record performance metrics
        await _recordPerformanceMetric('query_success', stopwatch.elapsedMilliseconds);
        
        // Reset retry count on success
        _retryAttempts.remove(cacheKey);
        
        return response;
      } catch (e) {
        _retryAttempts[cacheKey] = attempt + 1;
        
        if (attempt == retries - 1) {
          await _recordPerformanceMetric('query_error', 0);
          
          // If offline, queue for later
          if (!_isOnline) {
            _offlineQueue.add(cacheKey);
          }
          
          rethrow;
        } else {
          // Exponential backoff
          await Future.delayed(retryDelay * (attempt + 1));
        }
      }
    }
    
    throw Exception('Query failed after $retries attempts');
  }

  /// Enhanced insert/update/delete with optimistic updates
  Future<PostgrestResponse<T>> enhancedMutation<T>(
    String table,
    Future<PostgrestResponse<T>> Function() mutationFunction, {
    Function()? optimisticUpdate,
    Function()? rollback,
  }) async {
    await _ensureInitialized();
    
    // Apply optimistic update
    optimisticUpdate?.call();
    
    try {
      final stopwatch = Stopwatch()..start();
      final response = await mutationFunction();
      stopwatch.stop();
      
      // Clear related cache entries
      _invalidateRelatedCache(table);
      await _recordPerformanceMetric('mutation_success', stopwatch.elapsedMilliseconds);
      
      return response;
    } catch (e) {
      // Rollback optimistic update
      rollback?.call();
      await _recordPerformanceMetric('mutation_error', 0);
      rethrow;
    }
  }

  /// Enhanced real-time subscription with auto-reconnection
  RealtimeChannel enhancedSubscription(
    String channelName,
    String table, {
    String? filter,
    Function(Map<String, dynamic>)? onInsert,
    Function(Map<String, dynamic>)? onUpdate,
    Function(Map<String, dynamic>)? onDelete,
    Function()? onError,
    bool autoReconnect = true,
  }) {
    final channel = _client.channel(channelName);
    
    PostgresChangeFilter? changeFilter;
    if (filter != null) {
      final parts = filter.split('=');
      if (parts.length == 2) {
        changeFilter = PostgresChangeFilter(
          type: PostgresChangeFilterType.eq,
          column: parts[0].trim(),
          value: parts[1].trim(),
        );
      }
    }
    
    channel.onPostgresChanges(
      event: PostgresChangeEvent.all,
      schema: 'public',
      table: table,
      filter: changeFilter,
      callback: (payload) {
        try {
          switch (payload.eventType) {
            case PostgresChangeEvent.insert:
              onInsert?.call(payload.newRecord);
              break;
            case PostgresChangeEvent.update:
              onUpdate?.call(payload.newRecord);
              break;
            case PostgresChangeEvent.delete:
              onDelete?.call(payload.oldRecord);
              break;
            default:
              break;
          }
          
          // Invalidate related cache
          _invalidateRelatedCache(table);
        } catch (e) {
          debugPrint('Real-time callback error: $e');
          onError?.call();
        }
      },
    );
    
    channel.subscribe((status, error) {
      if (status == RealtimeSubscribeStatus.subscribed) {
        debugPrint('✅ Subscribed to $channelName');
      } else if (status == RealtimeSubscribeStatus.channelError) {
        debugPrint('❌ Subscription error for $channelName: $error');
        
        if (autoReconnect) {
          Timer(const Duration(seconds: 5), () {
            channel.subscribe();
          });
        }
      }
    });
    
    return channel;
  }

  /// Enhanced RPC call with caching and error handling
  Future<T?> enhancedRpc<T>(
    String functionName,
    Map<String, dynamic>? params, {
    bool useCache = false,
    Duration? cacheDuration,
  }) async {
    await _ensureInitialized();
    
    final cacheKey = _generateCacheKey(functionName, params?.toString() ?? '');
    
    // Check cache first
    if (useCache && _queryCache.containsKey(cacheKey)) {
      final expiry = _cacheExpiry[cacheKey];
      if (expiry != null && DateTime.now().isBefore(expiry)) {
        await _recordPerformanceMetric('rpc_cache_hit', 0);
        return _queryCache[cacheKey] as T;
      }
    }
    
    try {
      final stopwatch = Stopwatch()..start();
      final result = await _client.rpc<T>(functionName, params: params);
      stopwatch.stop();
      
      // Cache successful response
      if (useCache && result != null) {
        _cacheResponse(cacheKey, result, cacheDuration);
      }
      
      await _recordPerformanceMetric('rpc_success', stopwatch.elapsedMilliseconds);
      return result;
    } catch (e) {
      await _recordPerformanceMetric('rpc_error', 0);
      debugPrint('RPC call failed: $e');
      rethrow;
    }
  }

  /// Enhanced batch operations
  Future<List<PostgrestResponse>> enhancedBatch(
    List<Future<PostgrestResponse> Function()> operations, {
    bool stopOnError = false,
  }) async {
    await _ensureInitialized();
    
    final results = <PostgrestResponse>[];
    final stopwatch = Stopwatch()..start();
    
    try {
      for (final operation in operations) {
        try {
          final result = await operation();
          results.add(result);
          
          if (stopOnError) {
            break;
          }
        } catch (e) {
          if (stopOnError) {
            rethrow;
          }
          // Continue with next operation
        }
      }
      
      stopwatch.stop();
      await _recordPerformanceMetric('batch_operation', stopwatch.elapsedMilliseconds);
      
      return results;
    } catch (e) {
      stopwatch.stop();
      await _recordPerformanceMetric('batch_error', stopwatch.elapsedMilliseconds);
      rethrow;
    }
  }

  /// Network status handling
  void _onNetworkReconnection() {
    debugPrint('📶 Network reconnected - processing offline queue');
    
    // Process offline queue
    _processOfflineQueue();
    
    // Resume real-time subscriptions
    _resumeSubscriptions();
  }

  void _onNetworkDisconnection() {
    debugPrint('📶 Network disconnected - enabling offline mode');
    
    // Switch to cached data
    // Real-time subscriptions will automatically try to reconnect
  }

  /// Process queued operations after reconnection
  Future<void> _processOfflineQueue() async {
    final queueCopy = List<String>.from(_offlineQueue);
    _offlineQueue.clear();
    
    for (final operation in queueCopy) {
      try {
        // Re-execute queued operations
        // This would need to be implemented based on the specific operation type
        debugPrint('Processing queued operation: $operation');
      } catch (e) {
        debugPrint('Failed to process queued operation: $e');
      }
    }
  }

  /// Resume real-time subscriptions
  void _resumeSubscriptions() {
    // Real-time subscriptions automatically reconnect in Supabase
    debugPrint('📡 Resuming real-time subscriptions');
  }

  /// Cache management
  void _cacheResponse(String key, dynamic response, Duration? duration) {
    _queryCache[key] = response;
    _cacheExpiry[key] = DateTime.now().add(duration ?? const Duration(minutes: 5));
  }

  void _invalidateRelatedCache(String table) {
    final keysToRemove = _queryCache.keys
        .where((key) => key.contains(table))
        .toList();
    
    for (final key in keysToRemove) {
      _queryCache.remove(key);
      _cacheExpiry.remove(key);
    }
  }

  void _cleanupExpiredCache() {
    final now = DateTime.now();
    final expiredKeys = _cacheExpiry.entries
        .where((entry) => now.isAfter(entry.value))
        .map((entry) => entry.key)
        .toList();
    
    for (final key in expiredKeys) {
      _queryCache.remove(key);
      _cacheExpiry.remove(key);
    }
    
    if (expiredKeys.isNotEmpty) {
      debugPrint('🧹 Cleaned up ${expiredKeys.length} expired cache entries');
    }
  }

  String _generateCacheKey(String operation, String params) {
    return '${operation}_${params.hashCode}';
  }

  /// Performance monitoring
  Future<void> _recordPerformanceMetric(String metricName, int duration) async {
    try {
      if (_isInitialized) {
        await _client.rpc('record_health_metric', params: {
          'metric_name_param': 'supabase_$metricName',
          'metric_value_param': duration.toDouble(),
          'metric_unit_param': duration == 0 ? 'count' : 'milliseconds',
          'tags_param': {
            'service': 'enhanced_supabase',
            'timestamp': DateTime.now().toIso8601String(),
          },
        });
      }
    } catch (e) {
      // Silently fail for metrics to avoid affecting app performance
    }
  }

  /// Health check
  Future<void> _performHealthCheck() async {
    try {
      final stopwatch = Stopwatch()..start();
      await _client.from('workspaces').select('count').limit(1);
      stopwatch.stop();
      
      await _recordPerformanceMetric('health_check', stopwatch.elapsedMilliseconds);
    } catch (e) {
      await _recordPerformanceMetric('health_check_error', 0);
      debugPrint('Health check failed: $e');
    }
  }

  /// Log initialization error
  Future<void> _logInitializationError(dynamic error) async {
    try {
      // This would log to an external monitoring service in production
      debugPrint('Initialization error logged: $error');
    } catch (e) {
      // Silently fail
    }
  }

  /// Ensure initialization
  Future<void> _ensureInitialized() async {
    if (!_isInitialized) {
      await initialize();
    }
  }

  // Client getter (async) - ensures initialization
  Future<SupabaseClient> get client async {
    await _ensureInitialized();
    return _client;
  }

  // Synchronous client getter (use only after ensuring initialization)
  SupabaseClient get clientSync {
    if (!_isInitialized) {
      throw Exception('Enhanced Supabase service not initialized. Call initialize() first or use async client getter.');
    }
    return _client;
  }

  // Check if initialized
  bool get isInitialized => _isInitialized;

  // Check if online
  bool get isOnline => _isOnline;

  // Validation method with detailed error messages
  void _validateEnvironmentVariables() {
    final List<String> missingVars = [];
    
    if (supabaseUrl.isEmpty) {
      missingVars.add('SUPABASE_URL');
    }
    if (supabaseAnonKey.isEmpty) {
      missingVars.add('SUPABASE_ANON_KEY');
    }
    
    if (missingVars.isNotEmpty) {
      throw Exception(
        'Missing required Enhanced Supabase environment variables: ${missingVars.join(', ')}\n'
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

  /// Test connection to Supabase with enhanced metrics
  Future<bool> testConnection() async {
    try {
      await _ensureInitialized();
      
      final stopwatch = Stopwatch()..start();
      await _client.from('workspaces').select('count').limit(1);
      stopwatch.stop();
      
      await _recordPerformanceMetric('connection_test', stopwatch.elapsedMilliseconds);
      return true;
    } catch (e) {
      await _recordPerformanceMetric('connection_test_error', 0);
      debugPrint('Enhanced Supabase connection test failed: $e');
      return false;
    }
  }

  /// Reset instance (for testing or re-initialization)
  static void reset() {
    _instance?._cacheCleanupTimer?.cancel();
    _instance?._connectivitySubscription?.cancel();
    _instance?._isInitialized = false;
    _instance?._initFuture = null;
    _instance?._queryCache.clear();
    _instance?._cacheExpiry.clear();
    _instance?._offlineQueue.clear();
    _instance?._retryAttempts.clear();
    _instance = null;
  }

  /// Get enhanced connection status information
  Map<String, dynamic> getEnhancedStatus() {
    return {
      'is_initialized': _isInitialized,
      'is_online': _isOnline,
      'has_url': supabaseUrl.isNotEmpty,
      'has_anon_key': supabaseAnonKey.isNotEmpty,
      'url_format_valid': supabaseUrl.startsWith('https://') && supabaseUrl.contains('.supabase.co'),
      'supabase_url': supabaseUrl.isNotEmpty ? '${supabaseUrl.substring(0, 20)}...' : 'Not configured',
      'cache_size': _queryCache.length,
      'offline_queue_size': _offlineQueue.length,
      'active_retries': _retryAttempts.length,
    };
  }

  /// Get performance statistics
  Map<String, dynamic> getPerformanceStats() {
    return {
      'cache_entries': _queryCache.length,
      'cache_hit_rate': 'Not calculated', // Would need to track hits vs misses
      'offline_operations': _offlineQueue.length,
      'failed_retries': _retryAttempts.length,
      'connection_status': _isOnline ? 'online' : 'offline',
    };
  }

  /// Clear all caches
  void clearCache() {
    _queryCache.clear();
    _cacheExpiry.clear();
    debugPrint('🧹 Enhanced Supabase cache cleared');
  }

  /// Dispose and cleanup
  Future<void> dispose() async {
    _cacheCleanupTimer?.cancel();
    await _connectivitySubscription?.cancel();
    
    _queryCache.clear();
    _cacheExpiry.clear();
    _offlineQueue.clear();
    _retryAttempts.clear();
    
    debugPrint('🧹 Enhanced Supabase Service disposed');
  }
}

// Export for backward compatibility
typedef SupabaseService = EnhancedSupabaseService;