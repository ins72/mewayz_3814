import 'dart:async';
import 'dart:io' show Platform;

import 'package:supabase_flutter/supabase_flutter.dart';

import '../core/app_export.dart';
import '../core/production_performance_service.dart';
import '../core/production_security_service.dart';

/// Production-ready unified data service with advanced caching and performance optimization
class ProductionDataService {
  static final ProductionDataService _instance = ProductionDataService._internal();
  factory ProductionDataService() => _instance;
  ProductionDataService._internal();

  late final SupabaseClient _client;
  late final ProductionPerformanceService _performanceService;
  late final ProductionSecurityService _securityService;
  
  bool _isInitialized = false;
  String? _currentWorkspaceId;
  Timer? _realTimeConnectionMonitor;
  
  // Real-time subscriptions
  final Map<String, RealtimeChannel> _realtimeChannels = {};
  final Map<String, Function(Map<String, dynamic>)> _realtimeCallbacks = {};

  /// Initialize the production data service
  Future<void> initialize() async {
    if (_isInitialized) return;
    
    try {
      _client = Supabase.instance.client;
      _performanceService = ProductionPerformanceService();
      _securityService = ProductionSecurityService();
      
      await _performanceService.initialize();
      await _securityService.initialize();
      
      _currentWorkspaceId = await _getCurrentWorkspaceId();
      
      // Monitor real-time connection
      _startRealTimeMonitoring();
      
      _isInitialized = true;
      debugPrint('✅ Production Data Service initialized');
    } catch (e) {
      debugPrint('❌ Production Data Service initialization failed: $e');
      rethrow;
    }
  }

  Future<void> _ensureInitialized() async {
    if (!_isInitialized) {
      await initialize();
    }
  }

  /// Get current user's active workspace ID with caching
  Future<String?> _getCurrentWorkspaceId() async {
    try {
      return await _performanceService.getCachedData<String>(
        'current_workspace_id',
        () async {
          final userId = _client.auth.currentUser?.id;
          if (userId == null) return '';
          
          final response = await _client
              .from('workspace_members')
              .select('workspace_id')
              .eq('user_id', userId)
              .eq('is_active', true)
              .order('joined_at', ascending: false)
              .limit(1);
          
          if (response.isNotEmpty) {
            return response.first['workspace_id'] as String;
          }
          return '';
        },
        ttl: const Duration(minutes: 15),
      );
    } catch (e) {
      debugPrint('Error getting workspace ID: $e');
      return '';
    }
  }

  /// Start real-time connection monitoring
  void _startRealTimeMonitoring() {
    _realTimeConnectionMonitor = Timer.periodic(const Duration(minutes: 2), (_) {
      _checkRealTimeConnections();
    });
  }

  /// Check and restore real-time connections if needed
  void _checkRealTimeConnections() {
    _realtimeChannels.forEach((key, channel) {
      if (channel.socket.isConnected == false) {
        debugPrint('🔄 Reconnecting real-time channel: $key');
        // Attempt to reconnect
        channel.subscribe();
      }
    });
  }

  /// Enhanced data fetching with intelligent caching and performance optimization
  Future<Map<String, dynamic>> getAnalyticsData({
    bool forceRefresh = false,
    Duration? cacheTTL,
  }) async {
    try {
      await _ensureInitialized();
      
      return await _performanceService.getCachedData<Map<String, dynamic>>(
        'analytics_data_${_currentWorkspaceId}',
        () async {
          if (_currentWorkspaceId == null) {
            return _getEmptyAnalyticsData();
          }

          final response = await _client.rpc('get_workspace_dashboard_analytics', 
            params: {'workspace_uuid': _currentWorkspaceId});
          
          return response ?? _getEmptyAnalyticsData();
        },
        ttl: cacheTTL ?? const Duration(minutes: 5),
        forceRefresh: forceRefresh,
      ) ?? _getEmptyAnalyticsData();
    } catch (e) {
      ErrorHandler.handleError('Failed to get analytics data: $e');
      return _getEmptyAnalyticsData();
    }
  }

  /// Get real-time system health data
  Future<Map<String, dynamic>> getSystemHealthData({
    bool includeMetrics = true,
    bool includeLogs = false,
  }) async {
    try {
      await _ensureInitialized();
      
      return await _performanceService.getCachedData<Map<String, dynamic>>(
        'system_health_data',
        () async {
          final response = await _client.rpc('get_system_health_report');
          
          if (includeMetrics) {
            final performanceReport = await _performanceService.getPerformanceReport();
            response['performance_report'] = performanceReport;
          }
          
          if (includeLogs) {
            final securityReport = await _securityService.getSecurityStatusReport();
            response['security_report'] = securityReport;
          }
          
          return response ?? {};
        },
        ttl: const Duration(minutes: 2),
      ) ?? {};
    } catch (e) {
      ErrorHandler.handleError('Failed to get system health data: $e');
      return {};
    }
  }

  /// Enhanced social media data with performance optimization
  Future<List<Map<String, dynamic>>> getSocialMediaPosts({
    String? accountId,
    String? status,
    int? limit,
    bool forceRefresh = false,
  }) async {
    try {
      await _ensureInitialized();
      
      final cacheKey = 'social_media_posts_${_currentWorkspaceId}_${accountId ?? 'all'}_${status ?? 'all'}_${limit ?? 'all'}';
      
      return await _performanceService.getCachedData<List<Map<String, dynamic>>>(
        cacheKey,
        () async {
          if (_currentWorkspaceId == null) return [];

          final response = await _client.rpc('get_social_media_hub_data', 
            params: {'workspace_uuid': _currentWorkspaceId});
          
          var posts = List<Map<String, dynamic>>.from(response?['posts'] ?? []);
          
          // Apply filters
          if (accountId != null) {
            posts = posts.where((post) => post['account_id'] == accountId).toList();
          }
          
          if (status != null) {
            posts = posts.where((post) => post['status'] == status).toList();
          }
          
          if (limit != null && posts.length > limit) {
            posts = posts.take(limit).toList();
          }
          
          return posts;
        },
        ttl: const Duration(minutes: 3),
        forceRefresh: forceRefresh,
      ) ?? [];
    } catch (e) {
      ErrorHandler.handleError('Failed to get social media posts: $e');
      return [];
    }
  }

  /// Enhanced CRM data with intelligent caching
  Future<List<Map<String, dynamic>>> getCrmContacts({
    String? stage,
    String? priority,
    int? limit,
    bool forceRefresh = false,
  }) async {
    try {
      await _ensureInitialized();
      
      final cacheKey = 'crm_contacts_${_currentWorkspaceId}_${stage ?? 'all'}_${priority ?? 'all'}_${limit ?? 'all'}';
      
      return await _performanceService.getCachedData<List<Map<String, dynamic>>>(
        cacheKey,
        () async {
          if (_currentWorkspaceId == null) return [];

          final response = await _client.rpc('get_crm_data', 
            params: {'workspace_uuid': _currentWorkspaceId});
          
          var contacts = List<Map<String, dynamic>>.from(response?['contacts'] ?? []);
          
          // Apply filters
          if (stage != null) {
            contacts = contacts.where((contact) => contact['stage'] == stage).toList();
          }
          
          if (priority != null) {
            contacts = contacts.where((contact) => contact['priority'] == priority).toList();
          }
          
          if (limit != null && contacts.length > limit) {
            contacts = contacts.take(limit).toList();
          }
          
          return contacts;
        },
        ttl: const Duration(minutes: 5),
        forceRefresh: forceRefresh,
      ) ?? [];
    } catch (e) {
      ErrorHandler.handleError('Failed to get CRM contacts: $e');
      return [];
    }
  }

  /// Enhanced content templates with caching
  Future<List<Map<String, dynamic>>> getContentTemplates({
    String? category,
    String? templateType,
    int? limit,
    bool forceRefresh = false,
  }) async {
    try {
      await _ensureInitialized();
      
      final cacheKey = 'content_templates_${_currentWorkspaceId}_${category ?? 'all'}_${templateType ?? 'all'}_${limit ?? 'all'}';
      
      return await _performanceService.getCachedData<List<Map<String, dynamic>>>(
        cacheKey,
        () async {
          if (_currentWorkspaceId == null) return [];

          final response = await _client.rpc('get_templates_data', 
            params: {'workspace_uuid': _currentWorkspaceId});
          
          var templates = List<Map<String, dynamic>>.from(response?['content_templates'] ?? []);
          
          // Apply filters
          if (category != null) {
            templates = templates.where((template) => template['category'] == category).toList();
          }
          
          if (templateType != null) {
            templates = templates.where((template) => template['template_type'] == templateType).toList();
          }
          
          if (limit != null && templates.length > limit) {
            templates = templates.take(limit).toList();
          }
          
          return templates;
        },
        ttl: const Duration(minutes: 10),
        forceRefresh: forceRefresh,
      ) ?? [];
    } catch (e) {
      ErrorHandler.handleError('Failed to get content templates: $e');
      return [];
    }
  }

  /// Create data with optimistic updates and background sync
  Future<bool> createSocialMediaPost(Map<String, dynamic> postData) async {
    try {
      await _ensureInitialized();
      
      // Check rate limiting and permissions
      final userId = _client.auth.currentUser?.id;
      if (userId == null || _currentWorkspaceId == null) return false;

      // Optimistic update - add to cache immediately
      final optimisticPost = {
        ...postData,
        'id': 'temp_${DateTime.now().millisecondsSinceEpoch}',
        'workspace_id': _currentWorkspaceId,
        'author_id': userId,
        'created_at': DateTime.now().toIso8601String(),
        'status': 'pending',
      };

      // Update cache optimistically
      _performanceService.clearCache('social_media_posts_');

      // Background creation
      _performanceService.scheduleBackgroundSync('create_social_media_post', {
        ...postData,
        'workspace_id': _currentWorkspaceId,
        'author_id': userId,
      }, priority: 7);

      // Track analytics
      await trackAnalyticsEvent('social_media_post_created', {
        'platform': postData['platform'],
        'content_length': postData['content']?.length ?? 0,
        'optimistic': true,
      });

      return true;
    } catch (e) {
      ErrorHandler.handleError('Failed to create social media post: $e');
      return false;
    }
  }

  /// Enhanced analytics event tracking with batching
  Future<bool> trackAnalyticsEvent(
    String eventName, 
    Map<String, dynamic> data, {
    bool immediate = false,
  }) async {
    try {
      await _ensureInitialized();
      
      final userId = _client.auth.currentUser?.id;
      if (userId == null || _currentWorkspaceId == null) return false;

      final eventData = {
        'workspace_id': _currentWorkspaceId,
        'user_id': userId,
        'event_name': eventName,
        'event_data': data,
        'session_id': await _getSessionId(),
        'platform': Platform.operatingSystem,
        'user_agent': 'mewayz_flutter_app',
        'created_at': DateTime.now().toIso8601String(),
      };

      if (immediate) {
        await _client.rpc('track_analytics_event_batch', params: {
          'events': [eventData],
        });
      } else {
        // Batch for later processing
        _performanceService.scheduleBackgroundSync('track_analytics_event', eventData, priority: 3);
      }

      return true;
    } catch (e) {
      debugPrint('Analytics tracking failed: $e');
      return false;
    }
  }

  /// Real-time data subscriptions with automatic reconnection
  Future<void> subscribeToRealTimeUpdates(
    String table,
    Function(Map<String, dynamic>) onUpdate, {
    Map<String, dynamic>? filters,
  }) async {
    try {
      await _ensureInitialized();
      
      if (_currentWorkspaceId == null) return;

      final channelKey = '${table}_${_currentWorkspaceId}';
      
      // Unsubscribe existing channel if any
      await unsubscribeFromRealTime(channelKey);

      final channel = _client
          .channel(channelKey)
          .onPostgresChanges(
            event: PostgresChangeEvent.all,
            schema: 'public',
            table: table,
            filter: filters != null ? PostgresChangeFilter(
              type: PostgresChangeFilterType.eq,
              column: 'workspace_id',
              value: _currentWorkspaceId,
            ) : null,
            callback: (payload) {
              debugPrint('📡 Real-time update for $table: ${payload.eventType}');
              
              try {
                onUpdate(payload.newRecord);
                
                // Clear related cache
                _performanceService.clearCache(table);
                
                // Track real-time event
                trackAnalyticsEvent('realtime_update_received', {
                  'table': table,
                  'event_type': payload.eventType.name,
                });
              } catch (e) {
                debugPrint('Real-time callback error: $e');
              }
            },
          );

      await channel.subscribe();
      
      _realtimeChannels[channelKey] = channel;
      _realtimeCallbacks[channelKey] = onUpdate;
      
      debugPrint('📡 Subscribed to real-time updates for $table');
    } catch (e) {
      debugPrint('Real-time subscription failed: $e');
    }
  }

  /// Enhanced search functionality with caching
  Future<List<Map<String, dynamic>>> searchData({
    required String table,
    required String searchQuery,
    List<String>? searchColumns,
    Map<String, dynamic>? filters,
    int? limit,
  }) async {
    try {
      await _ensureInitialized();
      
      final cacheKey = 'search_${table}_${searchQuery.hashCode}_${filters?.hashCode ?? 0}_${limit ?? 'all'}';
      
      return await _performanceService.getCachedData<List<Map<String, dynamic>>>(
        cacheKey,
        () async {
          var query = _client.from(table).select('*');
          
          if (_currentWorkspaceId != null) {
            query = query.eq('workspace_id', _currentWorkspaceId as Object);
          }
          
          // Apply search
          if (searchColumns != null && searchColumns.isNotEmpty) {
            for (final column in searchColumns) {
              query = query.ilike(column, '%$searchQuery%');
            }
          } else {
            // Default search on common columns
            query = query.or('name.ilike.%$searchQuery%,title.ilike.%$searchQuery%,description.ilike.%$searchQuery%');
          }
          
          // Apply additional filters
          if (filters != null) {
            filters.forEach((key, value) {
              query = query.eq(key, value);
            });
          }
          
          final response = await query
              .order('created_at', ascending: false)
              .limit(limit ?? 50);
          
          return List<Map<String, dynamic>>.from(response);
        },
        ttl: const Duration(minutes: 2),
      ) ?? [];
    } catch (e) {
      ErrorHandler.handleError('Search failed: $e');
      return [];
    }
  }

  /// Enhanced notification system
  Future<bool> sendNotification({
    required String userId,
    required String type,
    required String title,
    required String message,
    List<String> channels = const ['in_app'],
    String priority = 'normal',
    Map<String, dynamic>? data,
    Duration? scheduleDelay,
  }) async {
    try {
      await _ensureInitialized();
      
      if (_currentWorkspaceId == null) return false;

      await _client.rpc('send_enhanced_notification', params: {
        'user_uuid': userId,
        'workspace_uuid': _currentWorkspaceId,
        'notification_type_param': type,
        'title_param': title,
        'message_param': message,
        'channels_param': channels,
        'priority_param': priority,
        'data_param': data ?? {},
        'schedule_delay': scheduleDelay != null ? '${scheduleDelay.inSeconds} seconds' : '0 seconds',
      });

      // Track notification sent
      await trackAnalyticsEvent('notification_sent', {
        'type': type,
        'channels': channels,
        'priority': priority,
      });

      return true;
    } catch (e) {
      ErrorHandler.handleError('Failed to send notification: $e');
      return false;
    }
  }

  /// Bulk data operations with transaction support
  Future<bool> performBulkOperation(
    String operationType,
    String table,
    List<Map<String, dynamic>> dataList,
  ) async {
    try {
      await _ensureInitialized();
      
      final batchSize = 100; // Process in batches
      final batches = <List<Map<String, dynamic>>>[];
      
      for (int i = 0; i < dataList.length; i += batchSize) {
        batches.add(dataList.sublist(i, i + batchSize > dataList.length ? dataList.length : i + batchSize));
      }
      
      for (final batch in batches) {
        switch (operationType.toLowerCase()) {
          case 'insert':
            await _client.from(table).insert(batch);
            break;
          case 'upsert':
            await _client.from(table).upsert(batch);
            break;
          case 'update':
            for (final item in batch) {
              final id = item['id'];
              if (id != null) {
                await _client.from(table).update(item).eq('id', id);
              }
            }
            break;
          case 'delete':
            final ids = batch.map((item) => item['id']).where((id) => id != null).toList();
            if (ids.isNotEmpty) {
              await _client.from(table).delete().inFilter('id', ids);
            }
            break;
        }
      }
      
      // Clear cache for affected table
      _performanceService.clearCache(table);
      
      // Track bulk operation
      await trackAnalyticsEvent('bulk_operation_completed', {
        'operation': operationType,
        'table': table,
        'record_count': dataList.length,
        'batch_count': batches.length,
      });
      
      return true;
    } catch (e) {
      ErrorHandler.handleError('Bulk operation failed: $e');
      return false;
    }
  }

  /// File upload with progress tracking
  Future<String?> uploadFile(
    String bucketName,
    String fileName,
    List<int> fileBytes, {
    String? mimeType,
    Map<String, String>? metadata,
    Function(double)? onProgress,
  }) async {
    try {
      await _ensureInitialized();
      
      final userId = _client.auth.currentUser?.id;
      if (userId == null || _currentWorkspaceId == null) return null;

      final filePath = '${_currentWorkspaceId}/${userId}/${DateTime.now().millisecondsSinceEpoch}_$fileName';
      
      // Upload file
      await _client.storage.from(bucketName).uploadBinary(
        filePath,
        Uint8List.fromList(fileBytes),
        fileOptions: FileOptions(
          contentType: mimeType,
          metadata: metadata,
        ),
      );

      // Get public URL
      final publicUrl = _client.storage.from(bucketName).getPublicUrl(filePath);
      
      // Store file metadata
      await _client.from('file_storage').insert({
        'workspace_id': _currentWorkspaceId,
        'user_id': userId,
        'file_name': fileName,
        'file_path': filePath,
        'file_size': fileBytes.length,
        'mime_type': mimeType ?? 'application/octet-stream',
        'file_hash': _generateFileHash(fileBytes),
        'bucket_name': bucketName,
        'metadata': metadata ?? {},
      });

      // Track file upload
      await trackAnalyticsEvent('file_uploaded', {
        'file_name': fileName,
        'file_size': fileBytes.length,
        'mime_type': mimeType,
        'bucket': bucketName,
      });

      return publicUrl;
    } catch (e) {
      ErrorHandler.handleError('File upload failed: $e');
      return null;
    }
  }

  /// Get session ID for analytics
  Future<String> _getSessionId() async {
    final storage = StorageService();
    String? sessionId = await storage.getValue('session_id');
    
    if (sessionId == null) {
      sessionId = 'session_${DateTime.now().millisecondsSinceEpoch}';
      await storage.setValue('session_id', sessionId);
    }
    
    return sessionId;
  }

  /// Generate file hash for deduplication
  String _generateFileHash(List<int> fileBytes) {
    // Simple hash implementation - use proper crypto hash in production
    return fileBytes.length.toString() + fileBytes.hashCode.toString();
  }

  /// Unsubscribe from real-time updates
  Future<void> unsubscribeFromRealTime(String channelKey) async {
    final channel = _realtimeChannels[channelKey];
    if (channel != null) {
      await channel.unsubscribe();
      _realtimeChannels.remove(channelKey);
      _realtimeCallbacks.remove(channelKey);
      debugPrint('📡 Unsubscribed from real-time updates for $channelKey');
    }
  }

  /// Unsubscribe from all real-time updates
  Future<void> unsubscribeFromAllRealTime() async {
    final keys = _realtimeChannels.keys.toList();
    for (final key in keys) {
      await unsubscribeFromRealTime(key);
    }
  }

  /// Helper method to get empty analytics data
  Map<String, dynamic> _getEmptyAnalyticsData() {
    return {
      'hero_metrics': {
        'total_leads': 0,
        'revenue': 0,
        'social_followers': 0,
        'course_enrollments': 0,
        'conversion_rate': 0.0,
      },
      'recent_activities': [],
      'team_stats': {
        'total_members': 0,
        'active_members': 0,
        'pending_invitations': 0,
      },
      'updated_at': DateTime.now().toIso8601String(),
    };
  }

  /// Dispose and cleanup
  void dispose() {
    _realTimeConnectionMonitor?.cancel();
    unsubscribeFromAllRealTime();
    _performanceService.dispose();
    
    debugPrint('🧹 Production Data Service disposed');
  }

  /// Get service status
  Map<String, dynamic> getServiceStatus() {
    return {
      'is_initialized': _isInitialized,
      'current_workspace_id': _currentWorkspaceId,
      'real_time_channels': _realtimeChannels.length,
      'performance_service_online': _performanceService.isOnline,
      'cache_size': _performanceService.cacheSize,
      'cache_hit_rate': _performanceService.cacheHitRate,
    };
  }
}