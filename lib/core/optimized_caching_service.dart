import 'dart:async';

import '../core/app_export.dart';

/// Optimized caching service with intelligent cache management and performance optimization
class OptimizedCachingService {
  static final OptimizedCachingService _instance = OptimizedCachingService._internal();
  factory OptimizedCachingService() => _instance;
  OptimizedCachingService._internal();

  // Multi-tier caching system
  final Map<String, dynamic> _memoryCache = {}; // L1 - Fast memory cache
  final Map<String, dynamic> _persistentCache = {}; // L2 - Persistent cache
  final Map<String, DateTime> _cacheExpiry = {};
  final Map<String, int> _accessCount = {};
  final Map<String, double> _performanceScore = {};
  
  // Cache statistics
  int _totalRequests = 0;
  int _cacheHits = 0;
  int _cacheMisses = 0;
  
  // Configuration
  static const int maxMemoryCacheSize = 1000;
  static const int maxPersistentCacheSize = 5000;
  static const Duration defaultCacheDuration = Duration(minutes: 30);
  static const Duration maxCacheDuration = Duration(hours: 24);
  
  // Cleanup timer
  Timer? _cleanupTimer;
  bool _isInitialized = false;

  /// Initialize the caching service
  Future<void> initialize() async {
    if (_isInitialized) return;
    
    try {
      // Load persistent cache from storage
      await _loadPersistentCache();
      
      // Setup periodic cleanup
      _setupPeriodicCleanup();
      
      _isInitialized = true;
      debugPrint('✅ Optimized Caching Service initialized');
    } catch (e) {
      debugPrint('Caching service initialization error: $e');
    }
  }

  /// Get cached data with intelligent fallback
  Future<T?> get<T>(
    String key, {
    T? Function()? defaultValue,
    bool updateAccessStats = true,
  }) async {
    _totalRequests++;
    
    try {
      // Check L1 cache (memory) first
      if (_memoryCache.containsKey(key) && !_isExpired(key)) {
        if (updateAccessStats) {
          _recordCacheHit(key);
        }
        _cacheHits++;
        return _memoryCache[key] as T?;
      }
      
      // Check L2 cache (persistent)
      if (_persistentCache.containsKey(key) && !_isExpired(key)) {
        final value = _persistentCache[key];
        
        // Promote to L1 cache
        _memoryCache[key] = value;
        
        if (updateAccessStats) {
          _recordCacheHit(key);
        }
        _cacheHits++;
        return value as T?;
      }
      
      // Cache miss
      _cacheMisses++;
      
      // Return default value if provided
      if (defaultValue != null) {
        return defaultValue();
      }
      
      return null;
    } catch (e) {
      debugPrint('Cache get error for key $key: $e');
      return defaultValue?.call();
    }
  }

  /// Set cached data with intelligent storage strategy
  Future<void> set<T>(
    String key,
    T value, {
    Duration? duration,
    int priority = 5, // 1-10, higher means more important
    bool persistToDisk = false,
  }) async {
    try {
      final expiry = DateTime.now().add(duration ?? defaultCacheDuration);
      
      // Store in memory cache
      _memoryCache[key] = value;
      _cacheExpiry[key] = expiry;
      _performanceScore[key] = priority.toDouble();
      _accessCount[key] = 0;
      
      // Store in persistent cache if requested or high priority
      if (persistToDisk || priority >= 7) {
        _persistentCache[key] = value;
        await _savePersistentCache();
      }
      
      // Manage cache size
      await _manageCacheSize();
      
    } catch (e) {
      debugPrint('Cache set error for key $key: $e');
    }
  }

  /// Enhanced cache with data provider function
  Future<T?> getOrSet<T>(
    String key,
    Future<T?> Function() dataProvider, {
    Duration? duration,
    int priority = 5,
    bool persistToDisk = false,
    bool forceRefresh = false,
  }) async {
    // Check cache first unless force refresh
    if (!forceRefresh) {
      final cachedValue = await get<T>(key);
      if (cachedValue != null) {
        return cachedValue;
      }
    }
    
    try {
      // Fetch new data
      final data = await dataProvider();
      
      if (data != null) {
        // Cache the new data
        await set(key, data, 
          duration: duration, 
          priority: priority, 
          persistToDisk: persistToDisk
        );
      }
      
      return data;
    } catch (e) {
      debugPrint('Cache getOrSet error for key $key: $e');
      
      // Try to return stale cache data as fallback
      return await get<T>(key, updateAccessStats: false);
    }
  }

  /// Remove specific cache entry
  Future<void> remove(String key) async {
    try {
      _memoryCache.remove(key);
      _persistentCache.remove(key);
      _cacheExpiry.remove(key);
      _accessCount.remove(key);
      _performanceScore.remove(key);
      
      await _savePersistentCache();
    } catch (e) {
      debugPrint('Cache remove error for key $key: $e');
    }
  }

  /// Clear cache by pattern
  Future<void> clearPattern(String pattern) async {
    try {
      final keysToRemove = [
        ..._memoryCache.keys,
        ..._persistentCache.keys,
      ].where((key) => key.contains(pattern)).toSet();
      
      for (final key in keysToRemove) {
        await remove(key);
      }
      
      debugPrint('Cleared ${keysToRemove.length} cache entries matching pattern: $pattern');
    } catch (e) {
      debugPrint('Cache clear pattern error: $e');
    }
  }

  /// Clear all cache
  Future<void> clearAll() async {
    try {
      _memoryCache.clear();
      _persistentCache.clear();
      _cacheExpiry.clear();
      _accessCount.clear();
      _performanceScore.clear();
      
      await _savePersistentCache();
      
      debugPrint('All cache cleared');
    } catch (e) {
      debugPrint('Cache clear all error: $e');
    }
  }

  /// Check if cache key exists and is not expired
  bool exists(String key) {
    return (_memoryCache.containsKey(key) || _persistentCache.containsKey(key)) 
           && !_isExpired(key);
  }

  /// Get cache statistics
  Map<String, dynamic> getStatistics() {
    final hitRate = _totalRequests > 0 ? (_cacheHits / _totalRequests) * 100 : 0.0;
    
    return {
      'memory_cache_size': _memoryCache.length,
      'persistent_cache_size': _persistentCache.length,
      'total_requests': _totalRequests,
      'cache_hits': _cacheHits,
      'cache_misses': _cacheMisses,
      'hit_rate_percent': hitRate.toStringAsFixed(2),
      'most_accessed_keys': _getMostAccessedKeys(),
      'cache_efficiency_score': _calculateEfficiencyScore(),
    };
  }

  /// Preload cache with multiple keys
  Future<void> preloadCache(Map<String, Future<dynamic> Function()> loaders) async {
    final futures = loaders.entries.map((entry) async {
      try {
        final data = await entry.value();
        if (data != null) {
          await set(entry.key, data, priority: 8, persistToDisk: true);
        }
      } catch (e) {
        debugPrint('Preload error for ${entry.key}: $e');
      }
    });
    
    await Future.wait(futures);
    debugPrint('Preloaded ${loaders.length} cache entries');
  }

  /// Warm up cache with frequently accessed data
  Future<void> warmUpCache() async {
    try {
      // This could load frequently accessed data patterns
      final commonKeys = _getMostAccessedKeys().take(20);
      
      debugPrint('Warming up cache with ${commonKeys.length} frequently accessed keys');
    } catch (e) {
      debugPrint('Cache warm up error: $e');
    }
  }

  /// Private helper methods
  
  bool _isExpired(String key) {
    final expiry = _cacheExpiry[key];
    return expiry == null || DateTime.now().isAfter(expiry);
  }

  void _recordCacheHit(String key) {
    _accessCount[key] = (_accessCount[key] ?? 0) + 1;
    
    // Boost performance score for frequently accessed items
    final currentScore = _performanceScore[key] ?? 5.0;
    _performanceScore[key] = (currentScore + 0.1).clamp(0.0, 10.0);
  }

  Future<void> _manageCacheSize() async {
    try {
      // Manage memory cache size
      if (_memoryCache.length > maxMemoryCacheSize) {
        await _evictLeastUsed(_memoryCache, maxMemoryCacheSize ~/ 2);
      }
      
      // Manage persistent cache size
      if (_persistentCache.length > maxPersistentCacheSize) {
        await _evictLeastUsed(_persistentCache, maxPersistentCacheSize ~/ 2);
        await _savePersistentCache();
      }
    } catch (e) {
      debugPrint('Cache size management error: $e');
    }
  }

  Future<void> _evictLeastUsed(Map<String, dynamic> cache, int targetSize) async {
    final entries = cache.keys.toList();
    
    // Sort by performance score and access count (lowest first)
    entries.sort((a, b) {
      final scoreA = _performanceScore[a] ?? 0.0;
      final scoreB = _performanceScore[b] ?? 0.0;
      final accessA = _accessCount[a] ?? 0;
      final accessB = _accessCount[b] ?? 0;
      
      // Combined score: performance score + access frequency
      final combinedA = scoreA + (accessA * 0.1);
      final combinedB = scoreB + (accessB * 0.1);
      
      return combinedA.compareTo(combinedB);
    });
    
    // Remove least used entries
    final toRemove = entries.take(entries.length - targetSize);
    for (final key in toRemove) {
      cache.remove(key);
      _cacheExpiry.remove(key);
      _accessCount.remove(key);
      _performanceScore.remove(key);
    }
    
    debugPrint('Evicted ${toRemove.length} cache entries');
  }

  void _setupPeriodicCleanup() {
    _cleanupTimer = Timer.periodic(const Duration(minutes: 10), (_) {
      _cleanupExpiredEntries();
    });
  }

  Future<void> _cleanupExpiredEntries() async {
    try {
      final now = DateTime.now();
      final expiredKeys = _cacheExpiry.entries
          .where((entry) => now.isAfter(entry.value))
          .map((entry) => entry.key)
          .toList();
      
      for (final key in expiredKeys) {
        _memoryCache.remove(key);
        _persistentCache.remove(key);
        _cacheExpiry.remove(key);
        _accessCount.remove(key);
        _performanceScore.remove(key);
      }
      
      if (expiredKeys.isNotEmpty) {
        await _savePersistentCache();
        debugPrint('Cleaned up ${expiredKeys.length} expired cache entries');
      }
    } catch (e) {
      debugPrint('Cache cleanup error: $e');
    }
  }

  Future<void> _loadPersistentCache() async {
    try {
      final storage = StorageService();
      final cacheData = await storage.getValue('optimized_cache');
      
      if (cacheData != null) {
        final decoded = json.decode(cacheData) as Map<String, dynamic>;
        
        // Load cache entries
        final entries = decoded['entries'] as Map<String, dynamic>? ?? {};
        final expiry = decoded['expiry'] as Map<String, dynamic>? ?? {};
        final access = decoded['access'] as Map<String, dynamic>? ?? {};
        final scores = decoded['scores'] as Map<String, dynamic>? ?? {};
        
        _persistentCache.addAll(entries);
        
        // Restore metadata
        expiry.forEach((key, value) {
          _cacheExpiry[key] = DateTime.parse(value as String);
        });
        
        access.forEach((key, value) {
          _accessCount[key] = value as int;
        });
        
        scores.forEach((key, value) {
          _performanceScore[key] = (value as num).toDouble();
        });
        
        debugPrint('Loaded ${_persistentCache.length} cache entries from storage');
      }
    } catch (e) {
      debugPrint('Failed to load persistent cache: $e');
    }
  }

  Future<void> _savePersistentCache() async {
    try {
      final storage = StorageService();
      
      // Prepare cache data for storage
      final expiryData = <String, String>{};
      _cacheExpiry.forEach((key, value) {
        expiryData[key] = value.toIso8601String();
      });
      
      final cacheData = {
        'entries': _persistentCache,
        'expiry': expiryData,
        'access': _accessCount,
        'scores': _performanceScore,
        'saved_at': DateTime.now().toIso8601String(),
      };
      
      await storage.setValue('optimized_cache', json.encode(cacheData));
    } catch (e) {
      debugPrint('Failed to save persistent cache: $e');
    }
  }

  List<String> _getMostAccessedKeys() {
    final entries = _accessCount.entries.toList();
    entries.sort((a, b) => b.value.compareTo(a.value));
    return entries.map((e) => e.key).toList();
  }

  double _calculateEfficiencyScore() {
    if (_totalRequests == 0) return 0.0;
    
    final hitRate = (_cacheHits / _totalRequests) * 100;
    final cacheUtilization = (_memoryCache.length / maxMemoryCacheSize) * 100;
    
    // Efficiency score based on hit rate and optimal cache utilization
    final optimalUtilization = cacheUtilization <= 80 ? cacheUtilization : (160 - cacheUtilization);
    return ((hitRate * 0.7) + (optimalUtilization * 0.3)).clamp(0.0, 100.0);
  }

  /// Advanced caching strategies
  
  /// Cache with dependency tracking
  Future<void> setWithDependencies(
    String key,
    dynamic value, {
    Duration? duration,
    List<String> dependencies = const [],
  }) async {
    await set(key, value, duration: duration);
    
    // Store dependency information
    final depKey = '${key}_deps';
    await set(depKey, dependencies, duration: maxCacheDuration);
  }

  /// Invalidate cache and all dependent caches
  Future<void> invalidateWithDependencies(String key) async {
    try {
      // Get dependencies
      final depKey = '${key}_deps';
      final dependencies = await get<List<String>>(depKey) ?? [];
      
      // Remove main key
      await remove(key);
      await remove(depKey);
      
      // Remove all dependent keys
      for (final dep in dependencies) {
        await invalidateWithDependencies(dep);
      }
      
      debugPrint('Invalidated $key and ${dependencies.length} dependencies');
    } catch (e) {
      debugPrint('Dependency invalidation error: $e');
    }
  }

  /// Cache with versioning
  Future<void> setVersioned(
    String key,
    dynamic value,
    String version, {
    Duration? duration,
  }) async {
    final versionedKey = '${key}_v$version';
    await set(versionedKey, value, duration: duration);
    
    // Store current version
    await set('${key}_current_version', version, duration: maxCacheDuration);
  }

  /// Get versioned cache
  Future<T?> getVersioned<T>(String key, {String? version}) async {
    try {
      // Use provided version or get current version
      final targetVersion = version ?? await get<String>('${key}_current_version');
      
      if (targetVersion == null) return null;
      
      final versionedKey = '${key}_v$targetVersion';
      return await get<T>(versionedKey);
    } catch (e) {
      debugPrint('Versioned cache get error: $e');
      return null;
    }
  }

  /// Get cache health report
  Map<String, dynamic> getHealthReport() {
    final stats = getStatistics();
    final memoryUsage = (_memoryCache.length / maxMemoryCacheSize) * 100;
    final persistentUsage = (_persistentCache.length / maxPersistentCacheSize) * 100;
    
    return {
      ...stats,
      'memory_usage_percent': memoryUsage.toStringAsFixed(1),
      'persistent_usage_percent': persistentUsage.toStringAsFixed(1),
      'health_status': _getHealthStatus(stats['hit_rate_percent']),
      'recommendations': _getHealthRecommendations(memoryUsage, persistentUsage),
      'expired_entries': _countExpiredEntries(),
    };
  }

  String _getHealthStatus(String hitRateString) {
    final hitRate = double.tryParse(hitRateString) ?? 0.0;
    
    if (hitRate >= 80) return 'excellent';
    if (hitRate >= 60) return 'good';
    if (hitRate >= 40) return 'fair';
    return 'poor';
  }

  List<String> _getHealthRecommendations(double memoryUsage, double persistentUsage) {
    final recommendations = <String>[];
    
    if (memoryUsage > 90) {
      recommendations.add('Memory cache is near capacity - consider increasing eviction frequency');
    }
    
    if (persistentUsage > 90) {
      recommendations.add('Persistent cache is near capacity - consider cleanup');
    }
    
    final hitRate = _totalRequests > 0 ? (_cacheHits / _totalRequests) * 100 : 0.0;
    if (hitRate < 50) {
      recommendations.add('Low cache hit rate - review caching strategy');
    }
    
    return recommendations;
  }

  int _countExpiredEntries() {
    final now = DateTime.now();
    return _cacheExpiry.values.where((expiry) => now.isAfter(expiry)).length;
  }

  /// Dispose and cleanup
  Future<void> dispose() async {
    _cleanupTimer?.cancel();
    await _savePersistentCache();
    
    _memoryCache.clear();
    _persistentCache.clear();
    _cacheExpiry.clear();
    _accessCount.clear();
    _performanceScore.clear();
    
    debugPrint('🧹 Optimized Caching Service disposed');
  }

  /// Check if initialized
  bool get isInitialized => _isInitialized;
  
  /// Get cache sizes
  int get memoryCacheSize => _memoryCache.length;
  int get persistentCacheSize => _persistentCache.length;
}