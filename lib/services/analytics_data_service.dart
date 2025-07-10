import 'dart:developer' as developer;

import 'package:supabase_flutter/supabase_flutter.dart';

import '../core/app_export.dart';

class AnalyticsDataService {
  final SupabaseService _supabaseService = SupabaseService.instance;
  
  late SupabaseClient _client;
  bool _isInitialized = false;

  Future<void> initialize() async {
    try {
      developer.log('Initializing Analytics Data Service...', name: 'AnalyticsDataService');
      
      _client = await _supabaseService.client;
      
      _isInitialized = true;
      developer.log('Analytics Data Service initialized successfully', name: 'AnalyticsDataService');
      
    } catch (e) {
      developer.log('Analytics Data Service initialization failed: $e', name: 'AnalyticsDataService');
      rethrow;
    }
  }

  /// Track analytics event
  Future<bool> trackEvent(String eventName, Map<String, dynamic> eventData, {String? workspaceId}) async {
    try {
      final client = await _supabaseService.client;
      
      final response = await client.rpc('track_analytics_event', params: {
        'event_name': eventName,
        'event_data': eventData,
        'workspace_uuid': workspaceId,
      });
      
      if (kDebugMode) {
        debugPrint('Analytics event tracked: $eventName');
      }
      
      return true;
    } catch (e) {
      if (kDebugMode) {
        debugPrint('Failed to track analytics event: $e');
      }
      return false;
    }
  }

  /// Update analytics metric
  Future<bool> updateMetric(
    String workspaceId,
    String metricType,
    String metricName,
    double metricValue,
    {Map<String, dynamic>? metadata}
  ) async {
    try {
      final client = await _supabaseService.client;
      
      await client.rpc('update_analytics_metric', params: {
        'workspace_uuid': workspaceId,
        'metric_type_param': metricType,
        'metric_name_param': metricName,
        'metric_value_param': metricValue,
        'metric_metadata_param': metadata ?? {},
      });
      
      if (kDebugMode) {
        debugPrint('Analytics metric updated: $metricName = $metricValue');
      }
      
      return true;
    } catch (e) {
      if (kDebugMode) {
        debugPrint('Failed to update analytics metric: $e');
      }
      return false;
    }
  }

  /// Get dashboard data
  Future<Map<String, dynamic>> getDashboardData(String workspaceId) async {
    try {
      final client = await _supabaseService.client;
      
      final response = await client.rpc('get_analytics_dashboard_data', params: {
        'workspace_uuid': workspaceId,
      });
      
      if (response != null) {
        return Map<String, dynamic>.from(response);
      }
      
      return _getEmptyDashboardData();
    } catch (e) {
      if (kDebugMode) {
        debugPrint('Failed to get dashboard data: $e');
      }
      return _getEmptyDashboardData();
    }
  }

  /// Get analytics metrics
  Future<List<Map<String, dynamic>>> getAnalyticsMetrics(
    String workspaceId,
    {String? metricType, DateTime? startDate, DateTime? endDate}
  ) async {
    try {
      final client = await _supabaseService.client;
      
      var query = client
          .from('analytics_metrics')
          .select()
          .eq('workspace_id', workspaceId);
      
      if (metricType != null) {
        query = query.eq('metric_type', metricType);
      }
      
      if (startDate != null) {
        query = query.gte('date_bucket', startDate.toIso8601String().split('T')[0]);
      }
      
      if (endDate != null) {
        query = query.lte('date_bucket', endDate.toIso8601String().split('T')[0]);
      }
      
      final response = await query.order('date_bucket', ascending: false).limit(100);
      
      return List<Map<String, dynamic>>.from(response);
    } catch (e) {
      if (kDebugMode) {
        debugPrint('Failed to get analytics metrics: $e');
      }
      return [];
    }
  }

  /// Get analytics events
  Future<List<Map<String, dynamic>>> getAnalyticsEvents(
    String workspaceId,
    {String? eventName, DateTime? startDate, DateTime? endDate}
  ) async {
    try {
      final client = await _supabaseService.client;
      
      var query = client
          .from('analytics_events')
          .select()
          .eq('workspace_id', workspaceId);
      
      if (eventName != null) {
        query = query.eq('event_name', eventName);
      }
      
      if (startDate != null) {
        query = query.gte('created_at', startDate.toIso8601String());
      }
      
      if (endDate != null) {
        query = query.lte('created_at', endDate.toIso8601String());
      }
      
      final response = await query.order('created_at', ascending: false).limit(1000);
      
      return List<Map<String, dynamic>>.from(response);
    } catch (e) {
      if (kDebugMode) {
        debugPrint('Failed to get analytics events: $e');
      }
      return [];
    }
  }

  /// Get revenue analytics
  Future<List<Map<String, dynamic>>> getRevenueAnalytics(
    String workspaceId,
    {DateTime? startDate, DateTime? endDate}
  ) async {
    try {
      final client = await _supabaseService.client;
      
      var query = client
          .from('analytics_metrics')
          .select()
          .eq('workspace_id', workspaceId)
          .eq('metric_type', 'revenue');
      
      if (startDate != null) {
        query = query.gte('date_bucket', startDate.toIso8601String().split('T')[0]);
      }
      
      if (endDate != null) {
        query = query.lte('date_bucket', endDate.toIso8601String().split('T')[0]);
      }
      
      final response = await query.order('date_bucket', ascending: true);
      
      return List<Map<String, dynamic>>.from(response);
    } catch (e) {
      if (kDebugMode) {
        debugPrint('Failed to get revenue analytics: $e');
      }
      return [];
    }
  }

  /// Get social media analytics
  Future<List<Map<String, dynamic>>> getSocialMediaAnalytics(
    String workspaceId,
    {String? platform, DateTime? startDate, DateTime? endDate}
  ) async {
    try {
      final client = await _supabaseService.client;
      
      var query = client
          .from('social_media_metrics')
          .select('*, social_media_accounts(*)')
          .eq('workspace_id', workspaceId);
      
      if (platform != null) {
        query = query.eq('social_media_accounts.platform', platform);
      }
      
      if (startDate != null) {
        query = query.gte('date_bucket', startDate.toIso8601String().split('T')[0]);
      }
      
      if (endDate != null) {
        query = query.lte('date_bucket', endDate.toIso8601String().split('T')[0]);
      }
      
      final response = await query.order('date_bucket', ascending: true);
      
      return List<Map<String, dynamic>>.from(response);
    } catch (e) {
      if (kDebugMode) {
        debugPrint('Failed to get social media analytics: $e');
      }
      return [];
    }
  }

  /// Get products analytics
  Future<Map<String, dynamic>> getProductsAnalytics(String workspaceId) async {
    try {
      final client = await _supabaseService.client;
      
      final response = await client
          .from('products')
          .select('id, name, price, stock_quantity, status, category, created_at')
          .eq('workspace_id', workspaceId);
      
      final products = List<Map<String, dynamic>>.from(response);
      
      return {
        'total_products': products.length,
        'active_products': products.where((p) => p['status'] == 'active').length,
        'out_of_stock': products.where((p) => p['stock_quantity'] == 0).length,
        'low_stock': products.where((p) => p['stock_quantity'] <= 5).length,
        'categories': products.map((p) => p['category']).toSet().toList(),
        'products': products,
      };
    } catch (e) {
      if (kDebugMode) {
        debugPrint('Failed to get products analytics: $e');
      }
      return {
        'total_products': 0,
        'active_products': 0,
        'out_of_stock': 0,
        'low_stock': 0,
        'categories': [],
        'products': [],
      };
    }
  }

  /// Get orders analytics
  Future<Map<String, dynamic>> getOrdersAnalytics(
    String workspaceId,
    {DateTime? startDate, DateTime? endDate}
  ) async {
    try {
      final client = await _supabaseService.client;
      
      var query = client
          .from('orders')
          .select('id, order_number, total_amount, status, created_at')
          .eq('workspace_id', workspaceId);
      
      if (startDate != null) {
        query = query.gte('created_at', startDate.toIso8601String());
      }
      
      if (endDate != null) {
        query = query.lte('created_at', endDate.toIso8601String());
      }
      
      final response = await query.order('created_at', ascending: false);
      
      final orders = List<Map<String, dynamic>>.from(response);
      
      double totalRevenue = 0;
      final ordersByStatus = <String, int>{};
      
      for (final order in orders) {
        totalRevenue += (order['total_amount'] as num).toDouble();
        final status = order['status'] as String;
        ordersByStatus[status] = (ordersByStatus[status] ?? 0) + 1;
      }
      
      return {
        'total_orders': orders.length,
        'total_revenue': totalRevenue,
        'orders_by_status': ordersByStatus,
        'recent_orders': orders.take(10).toList(),
      };
    } catch (e) {
      if (kDebugMode) {
        debugPrint('Failed to get orders analytics: $e');
      }
      return {
        'total_orders': 0,
        'total_revenue': 0.0,
        'orders_by_status': {},
        'recent_orders': [],
      };
    }
  }

  /// Create custom analytics dashboard
  Future<bool> createDashboard(
    String workspaceId,
    String dashboardName,
    Map<String, dynamic> dashboardConfig
  ) async {
    try {
      final client = await _supabaseService.client;
      
      await client.from('analytics_dashboards').insert({
        'workspace_id': workspaceId,
        'dashboard_name': dashboardName,
        'dashboard_config': dashboardConfig,
      });
      
      if (kDebugMode) {
        debugPrint('Custom dashboard created: $dashboardName');
      }
      
      return true;
    } catch (e) {
      if (kDebugMode) {
        debugPrint('Failed to create custom dashboard: $e');
      }
      return false;
    }
  }

  /// Get analytics dashboards
  Future<List<Map<String, dynamic>>> getDashboards(String workspaceId) async {
    try {
      final client = await _supabaseService.client;
      
      final response = await client
          .from('analytics_dashboards')
          .select('*, user_profiles(full_name)')
          .eq('workspace_id', workspaceId)
          .order('created_at', ascending: false);
      
      return List<Map<String, dynamic>>.from(response);
    } catch (e) {
      if (kDebugMode) {
        debugPrint('Failed to get analytics dashboards: $e');
      }
      return [];
    }
  }

  /// Export analytics data
  Future<Map<String, dynamic>> exportAnalyticsData(
    String workspaceId,
    String exportType,
    {DateTime? startDate, DateTime? endDate}
  ) async {
    try {
      final client = await _supabaseService.client;
      
      // Get all analytics data for export
      final metrics = await getAnalyticsMetrics(workspaceId, startDate: startDate, endDate: endDate);
      final events = await getAnalyticsEvents(workspaceId, startDate: startDate, endDate: endDate);
      final socialMedia = await getSocialMediaAnalytics(workspaceId, startDate: startDate, endDate: endDate);
      final products = await getProductsAnalytics(workspaceId);
      final orders = await getOrdersAnalytics(workspaceId, startDate: startDate, endDate: endDate);
      
      final exportData = {
        'export_type': exportType,
        'workspace_id': workspaceId,
        'date_range': {
          'start': startDate?.toIso8601String(),
          'end': endDate?.toIso8601String(),
        },
        'metrics': metrics,
        'events': events,
        'social_media': socialMedia,
        'products': products,
        'orders': orders,
        'exported_at': DateTime.now().toIso8601String(),
      };
      
      if (kDebugMode) {
        debugPrint('Analytics data exported: $exportType');
      }
      
      return exportData;
    } catch (e) {
      if (kDebugMode) {
        debugPrint('Failed to export analytics data: $e');
      }
      return {};
    }
  }

  /// Get real-time analytics updates
  Stream<Map<String, dynamic>> getRealtimeAnalytics(String workspaceId) async* {
    try {
      final client = await _supabaseService.client;
      
      // Listen for real-time changes in analytics metrics
      await for (final data in client
          .from('analytics_metrics')
          .stream(primaryKey: ['id'])
          .eq('workspace_id', workspaceId)) {
        
        // Process the real-time data
        final processedData = await getDashboardData(workspaceId);
        yield processedData;
      }
    } catch (e) {
      if (kDebugMode) {
        debugPrint('Failed to get real-time analytics: $e');
      }
      yield _getEmptyDashboardData();
    }
  }

  /// Track user activity
  Future<void> trackUserActivity(String action, Map<String, dynamic> context) async {
    try {
      await trackEvent('user_activity', {
        'action': action,
        'context': context,
        'timestamp': DateTime.now().toIso8601String(),
      });
    } catch (e) {
      if (kDebugMode) {
        debugPrint('Failed to track user activity: $e');
      }
    }
  }

  /// Get empty dashboard data
  Map<String, dynamic> _getEmptyDashboardData() {
    return {
      'revenue': {
        'total_revenue': 0,
        'total_orders': 0,
        'conversion_rate': 0,
      },
      'social_media': {
        'total_followers': 0,
        'total_engagement': 0,
        'posts_count': 0,
      },
      'products': {
        'total_products': 0,
        'active_products': 0,
        'low_stock_products': 0,
      },
      'notifications': {
        'unread_notifications': 0,
        'total_notifications': 0,
      },
      'updated_at': DateTime.now().toIso8601String(),
    };
  }
}