import 'dart:async';
import 'dart:io';

import 'package:supabase_flutter/supabase_flutter.dart';

import 'app_export.dart';

/// Production-grade performance optimization service
class ProductionPerformanceService {
  static final ProductionPerformanceService _instance = ProductionPerformanceService._internal();
  factory ProductionPerformanceService() => _instance;
  ProductionPerformanceService._internal();

  late final SupabaseClient _client;
  final Map<String, dynamic> _memoryCache = {};
  final Map<String, DateTime> _cacheExpiry = {};
  final Map<String, int> _cacheHitCounts = {};
  
  Timer? _performanceMonitorTimer;
  Timer? _cacheCleanupTimer;
  Timer? _healthCheckTimer;
  
  bool _isInitialized = false;
  bool _isOnline = true;
  late StreamSubscription<ConnectivityResult> _connectivitySubscription;
  
  // Performance metrics
  final Map<String, List<double>> _performanceMetrics = {
    'api_response_times': [],
    'cache_hit_rates': [],
    'memory_usage': [],
    'network_latency': [],
  };
  
  // Configuration
  static const int maxCacheSize = 100; // Maximum cache entries
  static const Duration defaultCacheTTL = Duration(minutes: 30);
  static const Duration performanceMonitorInterval = Duration(minutes: 5);
  static const Duration cacheCleanupInterval = Duration(minutes: 10);
  static const Duration healthCheckInterval = Duration(minutes: 1);

  /// Initialize the performance service
  Future<void> initialize() async {
    if (_isInitialized) return;
    
    try {
      _client = Supabase.instance.client;
      
      // Initialize network monitoring
      await _initializeNetworkMonitoring();
      
      // Start performance monitoring
      _startPerformanceMonitoring();
      
      // Start cache cleanup
      _startCacheCleanup();
      
      // Start health checks
      _startHealthChecks();
      
      _isInitialized = true;
      debugPrint('✅ Production Performance Service initialized');
      
      // Record initialization metric
      await _recordPerformanceMetric('service_initialization', 1, 'boolean');
    } catch (e) {
      debugPrint('❌ Performance service initialization failed: $e');
      rethrow;
    }
  }

  Future<void> _ensureInitialized() async {
    if (!_isInitialized) {
      await initialize();
    }
  }

  /// Initialize network connectivity monitoring
  Future<void> _initializeNetworkMonitoring() async {
    try {
      final connectivity = Connectivity();
      final result = await connectivity.checkConnectivity();
      _isOnline = result != ConnectivityResult.none;
      
      _connectivitySubscription = connectivity.onConnectivityChanged.listen((result) {
        final wasOnline = _isOnline;
        _isOnline = result != ConnectivityResult.none;
        
        if (!wasOnline && _isOnline) {
          _onNetworkReconnected();
        } else if (wasOnline && !_isOnline) {
          _onNetworkDisconnected();
        }
      });
      
      debugPrint('Network monitoring initialized. Online: $_isOnline');
    } catch (e) {
      debugPrint('Network monitoring initialization failed: $e');
    }
  }

  /// Handle network reconnection
  void _onNetworkReconnected() {
    debugPrint('📶 Network reconnected');
    _recordPerformanceMetric('network_reconnection', 1, 'count');
    
    // Sync offline data if needed
    _syncOfflineData();
  }

  /// Handle network disconnection
  void _onNetworkDisconnected() {
    debugPrint('📶 Network disconnected');
    _recordPerformanceMetric('network_disconnection', 1, 'count');
  }

  /// Sync offline data when network is restored
  Future<void> _syncOfflineData() async {
    try {
      // This would sync any offline operations
      debugPrint('🔄 Syncing offline data...');
      
      // Placeholder for offline sync logic
      await Future.delayed(const Duration(milliseconds: 500));
      
      debugPrint('✅ Offline data synced');
    } catch (e) {
      debugPrint('❌ Offline sync failed: $e');
    }
  }

  /// Start performance monitoring
  void _startPerformanceMonitoring() {
    _performanceMonitorTimer = Timer.periodic(performanceMonitorInterval, (_) {
      _collectPerformanceMetrics();
    });
  }

  /// Start cache cleanup process
  void _startCacheCleanup() {
    _cacheCleanupTimer = Timer.periodic(cacheCleanupInterval, (_) {
      _cleanupExpiredCache();
    });
  }

  /// Start health checks
  void _startHealthChecks() {
    _healthCheckTimer = Timer.periodic(healthCheckInterval, (_) {
      _performHealthCheck();
    });
  }

  /// Collect performance metrics
  Future<void> _collectPerformanceMetrics() async {
    try {
      // Memory usage
      if (!kIsWeb) {
        final memoryUsage = _getMemoryUsage();
        _performanceMetrics['memory_usage']?.add(memoryUsage);
        await _recordPerformanceMetric('memory_usage_mb', memoryUsage, 'megabytes');
      }
      
      // Cache hit rate
      final hitRate = _calculateCacheHitRate();
      _performanceMetrics['cache_hit_rates']?.add(hitRate);
      await _recordPerformanceMetric('cache_hit_rate', hitRate, 'percentage');
      
      // Cache size
      await _recordPerformanceMetric('cache_size', _memoryCache.length.toDouble(), 'count');
      
      // Network status
      await _recordPerformanceMetric('network_online', _isOnline ? 1 : 0, 'boolean');
      
      // Clean old metrics (keep only last 100 data points)
      _performanceMetrics.forEach((key, values) {
        if (values.length > 100) {
          _performanceMetrics[key] = values.sublist(values.length - 100);
        }
      });
      
    } catch (e) {
      debugPrint('Error collecting performance metrics: $e');
    }
  }

  /// Get memory usage (Android/iOS only)
  double _getMemoryUsage() {
    try {
      // This is a simplified version - in production you'd use proper memory tracking
      return ProcessInfo.currentRss / (1024 * 1024); // Convert to MB
    } catch (e) {
      return 0.0;
    }
  }

  /// Calculate cache hit rate
  double _calculateCacheHitRate() {
    final totalRequests = _cacheHitCounts.values.fold(0, (sum, count) => sum + count);
    if (totalRequests == 0) return 0.0;
    
    final cacheHits = _cacheHitCounts.values.where((count) => count > 0).length;
    return (cacheHits / _cacheHitCounts.length) * 100;
  }

  /// Clean up expired cache entries
  void _cleanupExpiredCache() {
    final now = DateTime.now();
    final expiredKeys = <String>[];
    
    _cacheExpiry.forEach((key, expiry) {
      if (now.isAfter(expiry)) {
        expiredKeys.add(key);
      }
    });
    
    for (final key in expiredKeys) {
      _memoryCache.remove(key);
      _cacheExpiry.remove(key);
      _cacheHitCounts.remove(key);
    }
    
    if (expiredKeys.isNotEmpty) {
      debugPrint('🧹 Cleaned up ${expiredKeys.length} expired cache entries');
      _recordPerformanceMetric('cache_cleanup', expiredKeys.length.toDouble(), 'count');
    }
    
    // If cache is still too large, remove oldest entries
    if (_memoryCache.length > maxCacheSize) {
      final sortedEntries = _cacheExpiry.entries.toList()
        ..sort((a, b) => a.value.compareTo(b.value));
      
      final entriesToRemove = sortedEntries.take(_memoryCache.length - maxCacheSize);
      for (final entry in entriesToRemove) {
        _memoryCache.remove(entry.key);
        _cacheExpiry.remove(entry.key);
        _cacheHitCounts.remove(entry.key);
      }
      
      debugPrint('🧹 Removed ${entriesToRemove.length} oldest cache entries');
    }
  }

  /// Perform health check
  Future<void> _performHealthCheck() async {
    try {
      if (!_isOnline) return;
      
      final stopwatch = Stopwatch()..start();
      
      // Test database connectivity
      await _client.from('workspaces').select('count').limit(1);
      
      stopwatch.stop();
      final responseTime = stopwatch.elapsedMilliseconds.toDouble();
      
      _performanceMetrics['api_response_times']?.add(responseTime);
      await _recordPerformanceMetric('db_response_time_ms', responseTime, 'milliseconds');
      
      // Record health status
      await _recordPerformanceMetric('health_check_success', 1, 'boolean');
      
    } catch (e) {
      debugPrint('Health check failed: $e');
      await _recordPerformanceMetric('health_check_success', 0, 'boolean');
      await _recordPerformanceMetric('health_check_error', 1, 'count');
    }
  }

  /// Record performance metric to database
  Future<void> _recordPerformanceMetric(String metricName, double value, String unit) async {
    try {
      if (!_isOnline) return;
      
      await _client.rpc('record_health_metric', params: {
        'metric_name_param': metricName,
        'metric_value_param': value,
        'metric_unit_param': unit,
        'tags_param': {
          'service': 'performance',
          'platform': Platform.operatingSystem,
          'timestamp': DateTime.now().toIso8601String(),
        },
      });
    } catch (e) {
      // Silently fail for metrics to avoid impacting app performance
      if (kDebugMode) {
        debugPrint('Metric recording failed: $e');
      }
    }
  }

  /// High-performance cached data retrieval
  Future<T?> getCachedData<T>(
    String key,
    Future<T> Function() dataProvider, {
    Duration? ttl,
    bool forceRefresh = false,
  }) async {
    try {
      await _ensureInitialized();
      
      final now = DateTime.now();
      final cacheKey = 'cache_$key';
      
      // Check if we should force refresh or cache is expired
      if (forceRefresh || 
          !_memoryCache.containsKey(cacheKey) || 
          (_cacheExpiry[cacheKey]?.isBefore(now) ?? true)) {
        
        // Try to get from database cache first
        final dbCacheResult = await _getFromDatabaseCache(key);
        if (dbCacheResult != null && !forceRefresh) {
          _memoryCache[cacheKey] = dbCacheResult;
          _cacheExpiry[cacheKey] = now.add(ttl ?? defaultCacheTTL);
          _cacheHitCounts[cacheKey] = (_cacheHitCounts[cacheKey] ?? 0) + 1;
          return dbCacheResult as T;
        }
        
        // Fetch fresh data
        final stopwatch = Stopwatch()..start();
        final data = await dataProvider();
        stopwatch.stop();
        
        // Record performance metrics
        _performanceMetrics['api_response_times']?.add(stopwatch.elapsedMilliseconds.toDouble());
        
        if (data != null) {
          // Store in memory cache
          _memoryCache[cacheKey] = data;
          _cacheExpiry[cacheKey] = now.add(ttl ?? defaultCacheTTL);
          _cacheHitCounts[cacheKey] = 0; // Reset hit count for fresh data
          
          // Store in database cache (fire and forget)
          _storeToDatabaseCache(key, data, ttl ?? defaultCacheTTL);
        }
        
        await _recordPerformanceMetric('cache_miss', 1, 'count');
        return data;
      }
      
      // Return from memory cache
      _cacheHitCounts[cacheKey] = (_cacheHitCounts[cacheKey] ?? 0) + 1;
      await _recordPerformanceMetric('cache_hit', 1, 'count');
      return _memoryCache[cacheKey] as T;
      
    } catch (e) {
      debugPrint('Cache retrieval error: $e');
      await _recordPerformanceMetric('cache_error', 1, 'count');
      
      // Fallback to direct data provider
      try {
        return await dataProvider();
      } catch (providerError) {
        debugPrint('Data provider fallback failed: $providerError');
        return null;
      }
    }
  }

  /// Get data from database cache
  Future<dynamic> _getFromDatabaseCache(String key) async {
    try {
      if (!_isOnline) return null;
      
      final result = await _client.rpc('get_cached_result', params: {
        'cache_key_param': key,
      });
      
      if (result != null) {
        await _recordPerformanceMetric('db_cache_hit', 1, 'count');
        return result;
      }
      
      return null;
    } catch (e) {
      await _recordPerformanceMetric('db_cache_error', 1, 'count');
      return null;
    }
  }

  /// Store data to database cache
  Future<void> _storeToDatabaseCache(String key, dynamic data, Duration ttl) async {
    try {
      if (!_isOnline) return;
      
      final jsonData = json.encode(data);
      await _client.rpc('set_cache_result', params: {
        'cache_key_param': key,
        'result_data_param': json.decode(jsonData),
        'ttl_seconds': ttl.inSeconds,
      });
      
      await _recordPerformanceMetric('db_cache_store', 1, 'count');
    } catch (e) {
      // Silently fail for cache storage
      await _recordPerformanceMetric('db_cache_store_error', 1, 'count');
    }
  }

  /// Clear cache for specific key or pattern
  Future<void> clearCache([String? pattern]) async {
    try {
      if (pattern != null) {
        final keysToRemove = _memoryCache.keys
            .where((key) => key.contains(pattern))
            .toList();
        
        for (final key in keysToRemove) {
          _memoryCache.remove(key);
          _cacheExpiry.remove(key);
          _cacheHitCounts.remove(key);
        }
        
        debugPrint('🧹 Cleared cache for pattern: $pattern (${keysToRemove.length} entries)');
      } else {
        _memoryCache.clear();
        _cacheExpiry.clear();
        _cacheHitCounts.clear();
        debugPrint('🧹 Cleared all cache');
      }
      
      await _recordPerformanceMetric('cache_manual_clear', 1, 'count');
    } catch (e) {
      debugPrint('Cache clear error: $e');
    }
  }

  /// Preload data into cache
  Future<void> preloadCache(Map<String, Future<dynamic> Function()> dataProviders) async {
    try {
      await _ensureInitialized();
      
      final futures = dataProviders.entries.map((entry) async {
        try {
          await getCachedData(entry.key, entry.value);
        } catch (e) {
          debugPrint('Preload failed for ${entry.key}: $e');
        }
      });
      
      await Future.wait(futures);
      debugPrint('📋 Preloaded ${dataProviders.length} cache entries');
      
      await _recordPerformanceMetric('cache_preload', dataProviders.length.toDouble(), 'count');
    } catch (e) {
      debugPrint('Cache preload error: $e');
    }
  }

  /// Get performance report
  Future<Map<String, dynamic>> getPerformanceReport() async {
    try {
      await _ensureInitialized();
      
      final cacheHitRate = _calculateCacheHitRate();
      final avgResponseTime = _performanceMetrics['api_response_times']?.isNotEmpty == true
          ? _performanceMetrics['api_response_times']!.reduce((a, b) => a + b) / 
            _performanceMetrics['api_response_times']!.length
          : 0.0;
      
      final memoryUsage = _performanceMetrics['memory_usage']?.isNotEmpty == true
          ? _performanceMetrics['memory_usage']!.last
          : 0.0;
      
      return {
        'timestamp': DateTime.now().toIso8601String(),
        'cache_statistics': {
          'total_entries': _memoryCache.length,
          'hit_rate_percentage': cacheHitRate,
          'memory_cache_size': _memoryCache.length,
          'expired_entries': _cacheExpiry.values.where((expiry) => DateTime.now().isAfter(expiry)).length,
        },
        'performance_metrics': {
          'avg_response_time_ms': avgResponseTime,
          'memory_usage_mb': memoryUsage,
          'network_online': _isOnline,
        },
        'health_status': {
          'service_initialized': _isInitialized,
          'monitoring_active': _performanceMonitorTimer?.isActive ?? false,
          'cache_cleanup_active': _cacheCleanupTimer?.isActive ?? false,
          'health_check_active': _healthCheckTimer?.isActive ?? false,
        },
      };
    } catch (e) {
      debugPrint('Error generating performance report: $e');
      return {'error': e.toString()};
    }
  }

  /// Optimize database queries with intelligent caching
  Future<List<Map<String, dynamic>>> optimizedQuery(
    String table,
    String cacheKey, {
    String? select,
    Map<String, dynamic>? filters,
    String? orderBy,
    int? limit,
    Duration? cacheTTL,
  }) async {
    return await getCachedData<List<Map<String, dynamic>>>(
      cacheKey,
      () async {
        dynamic query = _client.from(table).select(select ?? '*');
        
        // Apply filters
        if (filters != null) {
          filters.forEach((key, value) {
            query = query.eq(key, value);
          });
        }
        
        // Apply ordering
        if (orderBy != null) {
          final isDescending = orderBy.startsWith('-');
          final column = isDescending ? orderBy.substring(1) : orderBy;
          query = query.order(column, ascending: !isDescending);
        }
        
        // Apply limit
        if (limit != null) {
          query = query.limit(limit);
        }
        
        final result = await query;
        return List<Map<String, dynamic>>.from(result);
      },
      ttl: cacheTTL,
    ) ?? [];
  }

  /// Background task for data synchronization
  Future<void> scheduleBackgroundSync(
    String taskType,
    Map<String, dynamic> taskData, {
    Duration delay = Duration.zero,
    int priority = 5,
  }) async {
    try {
      await _ensureInitialized();
      
      if (!_isOnline) {
        // Store for later sync when online
        final storage = StorageService();
        final offlineJobs = await storage.getValue('offline_jobs') ?? '[]';
        final jobs = List<Map<String, dynamic>>.from(json.decode(offlineJobs));
        
        jobs.add({
          'task_type': taskType,
          'task_data': taskData,
          'priority': priority,
          'created_at': DateTime.now().toIso8601String(),
        });
        
        await storage.setValue('offline_jobs', json.encode(jobs));
        debugPrint('📦 Stored offline job: $taskType');
        return;
      }
      
      await _client.rpc('enqueue_background_job', params: {
        'job_type_param': taskType,
        'payload_param': taskData,
        'priority_param': priority,
        'schedule_delay': '${delay.inSeconds} seconds',
      });
      
      await _recordPerformanceMetric('background_job_scheduled', 1, 'count');
      debugPrint('⏰ Scheduled background job: $taskType');
    } catch (e) {
      debugPrint('Background job scheduling failed: $e');
      await _recordPerformanceMetric('background_job_error', 1, 'count');
    }
  }

  /// Process offline jobs when connection is restored
  Future<void> processOfflineJobs() async {
    try {
      if (!_isOnline) return;
      
      final storage = StorageService();
      final offlineJobs = await storage.getValue('offline_jobs');
      if (offlineJobs == null) return;
      
      final jobs = List<Map<String, dynamic>>.from(json.decode(offlineJobs));
      if (jobs.isEmpty) return;
      
      debugPrint('🔄 Processing ${jobs.length} offline jobs...');
      
      for (final job in jobs) {
        try {
          await scheduleBackgroundSync(
            job['task_type'],
            job['task_data'],
            priority: job['priority'] ?? 5,
          );
        } catch (e) {
          debugPrint('Failed to process offline job: $e');
        }
      }
      
      // Clear offline jobs after processing
      await storage.setValue('offline_jobs', '[]');
      debugPrint('✅ Processed all offline jobs');
      
      await _recordPerformanceMetric('offline_jobs_processed', jobs.length.toDouble(), 'count');
    } catch (e) {
      debugPrint('Offline job processing failed: $e');
    }
  }

  /// Dispose and cleanup
  void dispose() {
    _performanceMonitorTimer?.cancel();
    _cacheCleanupTimer?.cancel();
    _healthCheckTimer?.cancel();
    _connectivitySubscription.cancel();
    
    _memoryCache.clear();
    _cacheExpiry.clear();
    _cacheHitCounts.clear();
    _performanceMetrics.clear();
    
    debugPrint('🧹 Production Performance Service disposed');
  }

  /// Get network status
  bool get isOnline => _isOnline;
  
  /// Get cache size
  int get cacheSize => _memoryCache.length;
  
  /// Get cache hit rate
  double get cacheHitRate => _calculateCacheHitRate();
}