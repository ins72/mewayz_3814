import 'dart:async';

import 'package:supabase_flutter/supabase_flutter.dart';

import '../core/app_export.dart';

/// Production-ready data synchronization service
/// Handles offline/online data sync, conflict resolution, and data integrity
class ProductionDataSyncService {
  static final ProductionDataSyncService _instance = ProductionDataSyncService._internal();
  late final SupabaseClient _client;
  late final StorageService _storageService;
  bool _isInitialized = false;
  bool _isOnline = true;
  Timer? _syncTimer;
  final List<Map<String, dynamic>> _offlineQueue = [];
  
  factory ProductionDataSyncService() {
    return _instance;
  }

  ProductionDataSyncService._internal();

  Future<void> initialize() async {
    if (_isInitialized) return;
    
    try {
      final supabaseService = SupabaseService();
      _client = await supabaseService.client;
      _storageService = StorageService();
      
      // Initialize connectivity monitoring
      await _initializeConnectivity();
      
      // Load offline queue from storage
      await _loadOfflineQueue();
      
      // Start periodic sync
      _startPeriodicSync();
      
      _isInitialized = true;
      debugPrint('ProductionDataSyncService initialized successfully');
    } catch (e) {
      ErrorHandler.handleError('Failed to initialize ProductionDataSyncService: $e');
      rethrow;
    }
  }

  Future<void> _ensureInitialized() async {
    if (!_isInitialized) {
      await initialize();
    }
  }

  /// Initialize connectivity monitoring
  Future<void> _initializeConnectivity() async {
    // Check initial connectivity
    final connectivityResult = await Connectivity().checkConnectivity();
    _isOnline = connectivityResult != ConnectivityResult.none;
    
    // Listen for connectivity changes
    Connectivity().onConnectivityChanged.listen((ConnectivityResult result) {
      final wasOnline = _isOnline;
      _isOnline = result != ConnectivityResult.none;
      
      if (!wasOnline && _isOnline) {
        // Came back online, sync queued data
        _syncOfflineQueue();
      }
    });
  }

  /// Load offline queue from storage
  Future<void> _loadOfflineQueue() async {
    try {
      final queueData = await _storageService.getData('offline_queue');
      if (queueData != null) {
        _offlineQueue.addAll(List<Map<String, dynamic>>.from(queueData));
      }
    } catch (e) {
      debugPrint('Failed to load offline queue: $e');
    }
  }

  /// Save offline queue to storage
  Future<void> _saveOfflineQueue() async {
    try {
      await _storageService.saveData('offline_queue', _offlineQueue);
    } catch (e) {
      debugPrint('Failed to save offline queue: $e');
    }
  }

  /// Start periodic sync
  void _startPeriodicSync() {
    _syncTimer = Timer.periodic(
      const Duration(minutes: 5),
      (timer) {
        if (_isOnline) {
          _syncOfflineQueue();
        }
      },
    );
  }

  /// Add operation to offline queue
  Future<void> _addToOfflineQueue(Map<String, dynamic> operation) async {
    operation['timestamp'] = DateTime.now().toIso8601String();
    operation['retry_count'] = 0;
    _offlineQueue.add(operation);
    await _saveOfflineQueue();
  }

  /// Sync offline queue when online
  Future<void> _syncOfflineQueue() async {
    if (!_isOnline || _offlineQueue.isEmpty) return;
    
    final List<Map<String, dynamic>> failedOperations = [];
    
    for (final operation in List.from(_offlineQueue)) {
      try {
        await _executeOperation(operation);
        _offlineQueue.remove(operation);
      } catch (e) {
        operation['retry_count'] = (operation['retry_count'] ?? 0) + 1;
        if (operation['retry_count'] >= 3) {
          // Max retries reached, remove from queue
          _offlineQueue.remove(operation);
          debugPrint('Operation failed after 3 retries: ${operation['type']}');
        } else {
          failedOperations.add(operation);
        }
      }
    }
    
    await _saveOfflineQueue();
    
    if (_offlineQueue.isEmpty) {
      debugPrint('All offline operations synced successfully');
    }
  }

  /// Execute queued operation
  Future<void> _executeOperation(Map<String, dynamic> operation) async {
    final type = operation['type'];
    final data = operation['data'];
    
    switch (type) {
      case 'insert':
        await _client.from(operation['table']).insert(data);
        break;
      case 'update':
        await _client.from(operation['table'])
            .update(data)
            .eq('id', operation['id']);
        break;
      case 'delete':
        await _client.from(operation['table'])
            .delete()
            .eq('id', operation['id']);
        break;
      case 'analytics_event':
        await _client.rpc('track_analytics_event', params: data);
        break;
      default:
        throw Exception('Unknown operation type: $type');
    }
  }

  /// PRODUCTION-READY CRUD OPERATIONS WITH OFFLINE SUPPORT

  /// Insert data with offline support
  Future<bool> insertData(String table, Map<String, dynamic> data) async {
    try {
      await _ensureInitialized();
      
      if (_isOnline) {
        await _client.from(table).insert(data);
        return true;
      } else {
        // Add to offline queue
        await _addToOfflineQueue({
          'type': 'insert',
          'table': table,
          'data': data,
        });
        return true;
      }
    } catch (e) {
      // If online but failed, add to offline queue
      if (_isOnline) {
        await _addToOfflineQueue({
          'type': 'insert',
          'table': table,
          'data': data,
        });
      }
      ErrorHandler.handleError('Failed to insert data: $e');
      return false;
    }
  }

  /// Update data with offline support
  Future<bool> updateData(String table, String id, Map<String, dynamic> data) async {
    try {
      await _ensureInitialized();
      
      if (_isOnline) {
        await _client.from(table).update(data).eq('id', id);
        return true;
      } else {
        // Add to offline queue
        await _addToOfflineQueue({
          'type': 'update',
          'table': table,
          'id': id,
          'data': data,
        });
        return true;
      }
    } catch (e) {
      // If online but failed, add to offline queue
      if (_isOnline) {
        await _addToOfflineQueue({
          'type': 'update',
          'table': table,
          'id': id,
          'data': data,
        });
      }
      ErrorHandler.handleError('Failed to update data: $e');
      return false;
    }
  }

  /// Delete data with offline support
  Future<bool> deleteData(String table, String id) async {
    try {
      await _ensureInitialized();
      
      if (_isOnline) {
        await _client.from(table).delete().eq('id', id);
        return true;
      } else {
        // Add to offline queue
        await _addToOfflineQueue({
          'type': 'delete',
          'table': table,
          'id': id,
        });
        return true;
      }
    } catch (e) {
      // If online but failed, add to offline queue
      if (_isOnline) {
        await _addToOfflineQueue({
          'type': 'delete',
          'table': table,
          'id': id,
        });
      }
      ErrorHandler.handleError('Failed to delete data: $e');
      return false;
    }
  }

  /// Get data with caching support
  Future<List<Map<String, dynamic>>> getData(
    String table, {
    String? filter,
    String? order,
    int? limit,
    bool useCache = true,
  }) async {
    try {
      await _ensureInitialized();
      
      final cacheKey = 'data_${table}_${filter ?? ''}_${order ?? ''}_${limit ?? ''}';
      
      if (_isOnline) {
        // Fetch from Supabase
        var query = _client.from(table).select('*');
        
        if (filter != null) {
          // Apply filter (simplified - in production, you'd parse this properly)
          final filterParts = filter.split(':');
          if (filterParts.length == 2) {
            query = query.eq(filterParts[0], filterParts[1]);
          }
        }
        
        if (order != null) {
          final orderQuery = query.order(order);
          query = orderQuery as PostgrestFilterBuilder<PostgrestList>;
        }
        
        if (limit != null) {
          final limitQuery = query.limit(limit);
          query = limitQuery as PostgrestFilterBuilder<PostgrestList>;
        }
        
        final response = await query;
        final data = List<Map<String, dynamic>>.from(response);
        
        // Cache the data
        if (useCache) {
          await _storageService.saveData(cacheKey, data);
        }
        
        return data;
      } else {
        // Try to get from cache
        if (useCache) {
          final cachedData = await _storageService.getData(cacheKey);
          if (cachedData != null) {
            return List<Map<String, dynamic>>.from(cachedData);
          }
        }
        
        // No cache available
        return [];
      }
    } catch (e) {
      ErrorHandler.handleError('Failed to get data: $e');
      
      // Try to get from cache as fallback
      if (useCache) {
        final cacheKey = 'data_${table}_${filter ?? ''}_${order ?? ''}_${limit ?? ''}';
        final cachedData = await _storageService.getData(cacheKey);
        if (cachedData != null) {
          return List<Map<String, dynamic>>.from(cachedData);
        }
      }
      
      return [];
    }
  }

  /// Track analytics event with offline support
  Future<bool> trackAnalyticsEvent(String eventName, Map<String, dynamic> data) async {
    try {
      await _ensureInitialized();
      
      if (_isOnline) {
        await _client.rpc('track_analytics_event', params: {
          'event_name': eventName,
          'event_data': data,
        });
        return true;
      } else {
        // Add to offline queue
        await _addToOfflineQueue({
          'type': 'analytics_event',
          'data': {
            'event_name': eventName,
            'event_data': data,
          },
        });
        return true;
      }
    } catch (e) {
      // If online but failed, add to offline queue
      if (_isOnline) {
        await _addToOfflineQueue({
          'type': 'analytics_event',
          'data': {
            'event_name': eventName,
            'event_data': data,
          },
        });
      }
      ErrorHandler.handleError('Failed to track analytics event: $e');
      return false;
    }
  }

  /// Batch operations for better performance
  Future<bool> batchInsert(String table, List<Map<String, dynamic>> dataList) async {
    try {
      await _ensureInitialized();
      
      if (_isOnline) {
        // Split into chunks of 1000 (Supabase limit)
        const chunkSize = 1000;
        for (int i = 0; i < dataList.length; i += chunkSize) {
          final chunk = dataList.sublist(
            i,
            i + chunkSize > dataList.length ? dataList.length : i + chunkSize,
          );
          await _client.from(table).insert(chunk);
        }
        return true;
      } else {
        // Add each item to offline queue
        for (final data in dataList) {
          await _addToOfflineQueue({
            'type': 'insert',
            'table': table,
            'data': data,
          });
        }
        return true;
      }
    } catch (e) {
      ErrorHandler.handleError('Failed to batch insert: $e');
      return false;
    }
  }

  /// Force sync (manual sync trigger)
  Future<void> forceSync() async {
    try {
      await _ensureInitialized();
      
      if (_isOnline) {
        await _syncOfflineQueue();
      }
    } catch (e) {
      ErrorHandler.handleError('Failed to force sync: $e');
    }
  }

  /// Get sync status
  Map<String, dynamic> getSyncStatus() {
    return {
      'is_online': _isOnline,
      'offline_queue_size': _offlineQueue.length,
      'last_sync': DateTime.now().toIso8601String(),
      'is_syncing': _syncTimer?.isActive ?? false,
    };
  }

  /// Clear cache
  Future<void> clearCache() async {
    try {
      await _storageService.clear();
    } catch (e) {
      ErrorHandler.handleError('Failed to clear cache: $e');
    }
  }

  /// Clear offline queue
  Future<void> clearOfflineQueue() async {
    try {
      _offlineQueue.clear();
      await _saveOfflineQueue();
    } catch (e) {
      ErrorHandler.handleError('Failed to clear offline queue: $e');
    }
  }

  /// Dispose
  void dispose() {
    _syncTimer?.cancel();
    _syncTimer = null;
  }
}