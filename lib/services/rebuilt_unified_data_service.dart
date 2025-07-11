import 'dart:async';
import 'package:flutter/foundation.dart';

import '../core/rebuilt_supabase_service.dart';
import '../core/resilient_error_handler.dart';
import '../services/rebuilt_auth_service.dart';

/// Rebuilt unified data service with comprehensive offline support and real-time capabilities
class RebuiltUnifiedDataService {
  static RebuiltUnifiedDataService? _instance;
  static RebuiltUnifiedDataService get instance => _instance ??= RebuiltUnifiedDataService._internal();
  
  RebuiltUnifiedDataService._internal();

  late RebuiltSupabaseService _supabaseService;
  late RebuiltAuthService _authService;
  final ResilientErrorHandler _errorHandler = ResilientErrorHandler();
  
  bool _isInitialized = false;
  final Map<String, StreamSubscription> _realtimeSubscriptions = {};
  final Map<String, StreamController<List<Map<String, dynamic>>>> _dataStreams = {};
  
  /// Initialize the rebuilt unified data service
  Future<void> initialize() async {
    if (_isInitialized) return;

    try {
      debugPrint('📊 Initializing Rebuilt Unified Data Service...');
      
      _supabaseService = RebuiltSupabaseService.instance;
      _authService = RebuiltAuthService.instance;
      
      // Ensure dependencies are initialized
      await _supabaseService.initialize();
      await _authService.initialize();
      
      _isInitialized = true;
      debugPrint('✅ Rebuilt Unified Data Service initialized successfully');
      
    } catch (e) {
      await _errorHandler.handleError(
        e,
        context: 'rebuilt_unified_data_service_initialization',
        shouldRetry: true,
        maxRetries: 2,
      );
      rethrow;
    }
  }

  /// Get workspace dashboard analytics with offline support
  Future<Map<String, dynamic>> getWorkspaceDashboardAnalytics(String workspaceId) async {
    try {
      final cacheKey = 'workspace_dashboard_$workspaceId';
      
      return await _supabaseService.executeWithRetry(
        () async {
          final response = await _supabaseService.client
              .rpc('get_workspace_dashboard_analytics', params: {'workspace_uuid': workspaceId});
          
          // Cache the result
          await _supabaseService.cacheData(cacheKey, response);
          
          return response as Map<String, dynamic>;
        },
        offlineDefault: await _supabaseService.getCachedData(
          cacheKey,
          (data) => data,
        ) ?? _getDefaultDashboardAnalytics(),
      );
      
    } catch (e) {
      await _errorHandler.handleError(
        e,
        context: 'get_workspace_dashboard_analytics',
        metadata: {'workspace_id': workspaceId},
        shouldRetry: false,
      );
      
      // Return cached data or default on error
      return await _supabaseService.getCachedData(
        'workspace_dashboard_$workspaceId',
        (data) => data,
      ) ?? _getDefaultDashboardAnalytics();
    }
  }

  /// Get CRM data with real-time updates
  Future<Map<String, dynamic>> getCRMData(String workspaceId) async {
    try {
      final cacheKey = 'crm_data_$workspaceId';
      
      final result = await _supabaseService.executeWithRetry(
        () async {
          final response = await _supabaseService.client
              .rpc('get_crm_data', params: {'workspace_uuid': workspaceId});
          
          // Cache the result
          await _supabaseService.cacheData(cacheKey, response);
          
          return response as Map<String, dynamic>;
        },
        offlineDefault: await _supabaseService.getCachedData(
          cacheKey,
          (data) => data,
        ) ?? _getDefaultCRMData(),
      );
      
      // Setup real-time subscription if online
      if (_supabaseService.isOnline && _supabaseService.isHealthy) {
        _setupCRMRealtimeSubscription(workspaceId);
      }
      
      return result;
      
    } catch (e) {
      await _errorHandler.handleError(
        e,
        context: 'get_crm_data',
        metadata: {'workspace_id': workspaceId},
        shouldRetry: false,
      );
      
      return await _supabaseService.getCachedData(
        'crm_data_$workspaceId',
        (data) => data,
      ) ?? _getDefaultCRMData();
    }
  }

  /// Get social media hub data
  Future<Map<String, dynamic>> getSocialMediaHubData(String workspaceId) async {
    try {
      final cacheKey = 'social_media_$workspaceId';
      
      return await _supabaseService.executeWithRetry(
        () async {
          final response = await _supabaseService.client
              .rpc('get_social_media_hub_data', params: {'workspace_uuid': workspaceId});
          
          // Cache the result
          await _supabaseService.cacheData(cacheKey, response);
          
          return response as Map<String, dynamic>;
        },
        offlineDefault: await _supabaseService.getCachedData(
          cacheKey,
          (data) => data,
        ) ?? _getDefaultSocialMediaData(),
      );
      
    } catch (e) {
      await _errorHandler.handleError(
        e,
        context: 'get_social_media_hub_data',
        metadata: {'workspace_id': workspaceId},
        shouldRetry: false,
      );
      
      return await _supabaseService.getCachedData(
        'social_media_$workspaceId',
        (data) => data,
      ) ?? _getDefaultSocialMediaData();
    }
  }

  /// Get course analytics data
  Future<Map<String, dynamic>> getCourseAnalyticsData(String workspaceId) async {
    try {
      final cacheKey = 'course_analytics_$workspaceId';
      
      return await _supabaseService.executeWithRetry(
        () async {
          final response = await _supabaseService.client
              .rpc('get_course_analytics_data', params: {'workspace_uuid': workspaceId});
          
          // Cache the result
          await _supabaseService.cacheData(cacheKey, response);
          
          return response as Map<String, dynamic>;
        },
        offlineDefault: await _supabaseService.getCachedData(
          cacheKey,
          (data) => data,
        ) ?? _getDefaultCourseData(),
      );
      
    } catch (e) {
      await _errorHandler.handleError(
        e,
        context: 'get_course_analytics_data',
        metadata: {'workspace_id': workspaceId},
        shouldRetry: false,
      );
      
      return await _supabaseService.getCachedData(
        'course_analytics_$workspaceId',
        (data) => data,
      ) ?? _getDefaultCourseData();
    }
  }

  /// Get templates data
  Future<Map<String, dynamic>> getTemplatesData(String workspaceId) async {
    try {
      final cacheKey = 'templates_$workspaceId';
      
      return await _supabaseService.executeWithRetry(
        () async {
          final response = await _supabaseService.client
              .rpc('get_templates_data', params: {'workspace_uuid': workspaceId});
          
          // Cache the result
          await _supabaseService.cacheData(cacheKey, response);
          
          return response as Map<String, dynamic>;
        },
        offlineDefault: await _supabaseService.getCachedData(
          cacheKey,
          (data) => data,
        ) ?? _getDefaultTemplatesData(),
      );
      
    } catch (e) {
      await _errorHandler.handleError(
        e,
        context: 'get_templates_data',
        metadata: {'workspace_id': workspaceId},
        shouldRetry: false,
      );
      
      return await _supabaseService.getCachedData(
        'templates_$workspaceId',
        (data) => data,
      ) ?? _getDefaultTemplatesData();
    }
  }

  /// Get user workspaces
  Future<List<Map<String, dynamic>>> getUserWorkspaces() async {
    try {
      if (!_authService.isAuthenticated) {
        return [];
      }
      
      final userId = _authService.currentUser!.id;
      final cacheKey = 'user_workspaces_$userId';
      
      return await _supabaseService.executeWithRetry(
        () async {
          final response = await _supabaseService.client
              .from('workspace_members')
              .select('''
                workspace_id,
                role,
                is_active,
                workspaces!inner(
                  id,
                  name,
                  description,
                  industry,
                  logo_url,
                  created_at
                )
              ''')
              .eq('user_id', userId)
              .eq('is_active', true);
          
          final workspaces = (response as List).map((item) {
            final workspace = item['workspaces'] as Map<String, dynamic>;
            return {
              'workspace_id': item['workspace_id'],
              'user_role': item['role'],
              'id': workspace['id'],
              'name': workspace['name'],
              'description': workspace['description'],
              'industry': workspace['industry'],
              'logo_url': workspace['logo_url'],
              'created_at': workspace['created_at'],
            };
          }).toList();
          
          // Cache the result
          await _supabaseService.cacheData(cacheKey, workspaces);
          
          return workspaces;
        },
        offlineDefault: await _supabaseService.getCachedData(
          cacheKey,
          (data) => List<Map<String, dynamic>>.from(data['workspaces'] ?? []),
        ) ?? [],
      );
      
    } catch (e) {
      await _errorHandler.handleError(
        e,
        context: 'get_user_workspaces',
        shouldRetry: false,
      );
      
      // Return cached data on error
      if (_authService.isAuthenticated) {
        final userId = _authService.currentUser!.id;
        return await _supabaseService.getCachedData(
          'user_workspaces_$userId',
          (data) => List<Map<String, dynamic>>.from(data['workspaces'] ?? []),
        ) ?? [];
      }
      
      return [];
    }
  }

  /// Get user role in workspace
  Future<String?> getUserRoleInWorkspace(String workspaceId) async {
    try {
      if (!_authService.isAuthenticated) {
        return null;
      }
      
      final userId = _authService.currentUser!.id;
      
      return await _supabaseService.executeWithRetry(
        () async {
          final response = await _supabaseService.client
              .from('workspace_members')
              .select('role')
              .eq('workspace_id', workspaceId)
              .eq('user_id', userId)
              .eq('is_active', true)
              .maybeSingle();
          
          return response?['role'] as String?;
        },
        offlineDefault: null,
      );
      
    } catch (e) {
      await _errorHandler.handleError(
        e,
        context: 'get_user_role_in_workspace',
        metadata: {'workspace_id': workspaceId},
        shouldRetry: false,
      );
      return null;
    }
  }

  /// Setup real-time subscription for CRM data
  void _setupCRMRealtimeSubscription(String workspaceId) {
    final subscriptionKey = 'crm_$workspaceId';
    
    // Cancel existing subscription if any
    _realtimeSubscriptions[subscriptionKey]?.cancel();
    
    try {
      final subscription = _supabaseService.client
          .from('crm_contacts')
          .stream(primaryKey: ['id'])
          .eq('workspace_id', workspaceId)
          .listen((data) {
            // Update cached data
            _supabaseService.cacheData('crm_contacts_$workspaceId', data);
            
            // Notify listeners
            _notifyDataStreamListeners('crm_contacts', data);
          });
      
      _realtimeSubscriptions[subscriptionKey] = subscription;
      
    } catch (e) {
      debugPrint('Failed to setup CRM real-time subscription: $e');
    }
  }

  /// Notify data stream listeners
  void _notifyDataStreamListeners(String streamKey, List<Map<String, dynamic>> data) {
    final stream = _dataStreams[streamKey];
    if (stream != null && !stream.isClosed) {
      stream.add(data);
    }
  }

  /// Get data stream for real-time updates
  Stream<List<Map<String, dynamic>>> getDataStream(String streamKey) {
    if (!_dataStreams.containsKey(streamKey)) {
      _dataStreams[streamKey] = StreamController<List<Map<String, dynamic>>>.broadcast();
    }
    return _dataStreams[streamKey]!.stream;
  }

  /// Default data generators for offline mode
  Map<String, dynamic> _getDefaultDashboardAnalytics() {
    return {
      'hero_metrics': {
        'total_leads': 0,
        'revenue': 0,
        'social_followers': 0,
        'course_enrollments': 0,
        'conversion_rate': 0,
      },
      'recent_activities': [],
      'team_stats': {
        'total_members': 0,
        'active_members': 0,
        'pending_invitations': 0,
      },
      'generated_at': DateTime.now().toIso8601String(),
      'offline_mode': true,
    };
  }

  Map<String, dynamic> _getDefaultCRMData() {
    return {
      'contacts': [],
      'pipeline': [],
      'generated_at': DateTime.now().toIso8601String(),
      'offline_mode': true,
    };
  }

  Map<String, dynamic> _getDefaultSocialMediaData() {
    return {
      'posts': [],
      'analytics': {
        'total_posts': 0,
        'published_posts': 0,
        'scheduled_posts': 0,
        'total_engagement': 0,
        'total_reach': 0,
        'avg_engagement_rate': 0,
      },
      'trending_hashtags': [],
      'generated_at': DateTime.now().toIso8601String(),
      'offline_mode': true,
    };
  }

  Map<String, dynamic> _getDefaultCourseData() {
    return {
      'courses': [],
      'revenue_analytics': {
        'total_revenue': 0,
        'monthly_revenue': 0,
        'transaction_count': 0,
        'avg_transaction_value': 0,
      },
      'generated_at': DateTime.now().toIso8601String(),
      'offline_mode': true,
    };
  }

  Map<String, dynamic> _getDefaultTemplatesData() {
    return {
      'content_templates': [],
      'link_in_bio_templates': [],
      'generated_at': DateTime.now().toIso8601String(),
      'offline_mode': true,
    };
  }

  /// Get service status
  Map<String, dynamic> getServiceStatus() {
    return {
      'is_initialized': _isInitialized,
      'active_subscriptions': _realtimeSubscriptions.length,
      'active_streams': _dataStreams.length,
      'supabase_health': _supabaseService.getConnectionHealthScore(),
      'auth_status': _authService.isAuthenticated,
      'last_status_check': DateTime.now().toIso8601String(),
    };
  }

  /// Dispose resources
  void dispose() {
    // Cancel all real-time subscriptions
    for (final subscription in _realtimeSubscriptions.values) {
      subscription.cancel();
    }
    _realtimeSubscriptions.clear();
    
    // Close all data streams
    for (final stream in _dataStreams.values) {
      stream.close();
    }
    _dataStreams.clear();
    
    _errorHandler.dispose();
  }

  /// Getters
  bool get isInitialized => _isInitialized;
}