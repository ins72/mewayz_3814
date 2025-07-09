import 'package:supabase_flutter/supabase_flutter.dart';

import '../core/app_export.dart';

/// Unified service for all data operations with Supabase integration
/// Ensures all data is synced to Supabase and removes any mock data usage
class UnifiedDataService {
  static final UnifiedDataService _instance = UnifiedDataService._internal();
  late final SupabaseClient _client;
  bool _isInitialized = false;
  
  factory UnifiedDataService() {
    return _instance;
  }

  UnifiedDataService._internal();

  Future<void> initialize() async {
    if (_isInitialized) return;
    
    try {
      final supabaseService = SupabaseService();
      _client = await supabaseService.client;
      _isInitialized = true;
      debugPrint('UnifiedDataService initialized successfully');
    } catch (e) {
      ErrorHandler.handleError('Failed to initialize UnifiedDataService: $e');
      rethrow;
    }
  }

  Future<void> _ensureInitialized() async {
    if (!_isInitialized) {
      await initialize();
    }
  }

  /// Get current user's workspace ID
  Future<String?> _getCurrentWorkspaceId() async {
    try {
      final userId = _client.auth.currentUser?.id;
      if (userId == null) return null;
      
      final response = await _client
          .from('workspace_members')
          .select('workspace_id')
          .eq('user_id', userId)
          .eq('is_active', true)
          .order('joined_at', ascending: false)
          .limit(1);
      
      if (response.isNotEmpty) {
        return response.first['workspace_id'];
      }
      return null;
    } catch (e) {
      debugPrint('Error getting workspace ID: $e');
      return null;
    }
  }

  /// ANALYTICS DATA OPERATIONS
  Future<Map<String, dynamic>> getAnalyticsData() async {
    try {
      await _ensureInitialized();
      final workspaceId = await _getCurrentWorkspaceId();
      
      if (workspaceId == null) {
        return _getEmptyAnalyticsData();
      }

      final response = await _client.rpc('get_analytics_dashboard_data', 
        params: {'workspace_uuid': workspaceId});
      
      return response ?? _getEmptyAnalyticsData();
    } catch (e) {
      ErrorHandler.handleError('Failed to get analytics data: $e');
      return _getEmptyAnalyticsData();
    }
  }

  Future<List<Map<String, dynamic>>> getAnalyticsEvents({
    String? eventName,
    DateTime? startDate,
    DateTime? endDate,
    int? limit,
  }) async {
    try {
      await _ensureInitialized();
      final workspaceId = await _getCurrentWorkspaceId();
      
      if (workspaceId == null) return [];

      var query = _client
          .from('analytics_events')
          .select('*')
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

      final response = await query
          .order('created_at', ascending: false)
          .limit(limit ?? 100);

      return List<Map<String, dynamic>>.from(response);
    } catch (e) {
      ErrorHandler.handleError('Failed to get analytics events: $e');
      return [];
    }
  }

  Future<bool> trackAnalyticsEvent(String eventName, Map<String, dynamic> data) async {
    try {
      await _ensureInitialized();
      final workspaceId = await _getCurrentWorkspaceId();
      
      if (workspaceId == null) return false;

      await _client.rpc('track_analytics_event', params: {
        'event_name': eventName,
        'event_data': data,
        'workspace_uuid': workspaceId,
      });

      return true;
    } catch (e) {
      ErrorHandler.handleError('Failed to track analytics event: $e');
      return false;
    }
  }

  /// SOCIAL MEDIA DATA OPERATIONS
  Future<List<Map<String, dynamic>>> getSocialMediaAccounts() async {
    try {
      await _ensureInitialized();
      final workspaceId = await _getCurrentWorkspaceId();
      
      if (workspaceId == null) return [];

      final response = await _client
          .from('social_media_accounts')
          .select('*')
          .eq('workspace_id', workspaceId)
          .eq('is_active', true)
          .order('created_at', ascending: false);

      return List<Map<String, dynamic>>.from(response);
    } catch (e) {
      ErrorHandler.handleError('Failed to get social media accounts: $e');
      return [];
    }
  }

  Future<List<Map<String, dynamic>>> getSocialMediaPosts({
    String? accountId,
    String? status,
    int? limit,
  }) async {
    try {
      await _ensureInitialized();
      final workspaceId = await _getCurrentWorkspaceId();
      
      if (workspaceId == null) return [];

      var query = _client
          .from('social_media_posts')
          .select('*, social_media_accounts(platform, account_name)')
          .eq('workspace_id', workspaceId);

      if (accountId != null) {
        query = query.eq('account_id', accountId);
      }

      if (status != null) {
        query = query.eq('status', status);
      }

      final response = await query
          .order('created_at', ascending: false)
          .limit(limit ?? 50);

      return List<Map<String, dynamic>>.from(response);
    } catch (e) {
      ErrorHandler.handleError('Failed to get social media posts: $e');
      return [];
    }
  }

  Future<bool> createSocialMediaPost(Map<String, dynamic> postData) async {
    try {
      await _ensureInitialized();
      final workspaceId = await _getCurrentWorkspaceId();
      final userId = _client.auth.currentUser?.id;
      
      if (workspaceId == null || userId == null) return false;

      final data = {
        ...postData,
        'workspace_id': workspaceId,
        'created_by': userId,
        'created_at': DateTime.now().toIso8601String(),
      };

      await _client.from('social_media_posts').insert(data);

      // Track analytics event
      await trackAnalyticsEvent('social_media_post_created', {
        'platform': postData['platform'],
        'content_length': postData['content']?.length ?? 0,
      });

      return true;
    } catch (e) {
      ErrorHandler.handleError('Failed to create social media post: $e');
      return false;
    }
  }

  Future<bool> updateSocialMediaPost(String postId, Map<String, dynamic> updateData) async {
    try {
      await _ensureInitialized();
      
      final data = {
        ...updateData,
        'updated_at': DateTime.now().toIso8601String(),
      };

      await _client
          .from('social_media_posts')
          .update(data)
          .eq('id', postId);

      return true;
    } catch (e) {
      ErrorHandler.handleError('Failed to update social media post: $e');
      return false;
    }
  }

  Future<bool> deleteSocialMediaPost(String postId) async {
    try {
      await _ensureInitialized();

      await _client
          .from('social_media_posts')
          .delete()
          .eq('id', postId);

      return true;
    } catch (e) {
      ErrorHandler.handleError('Failed to delete social media post: $e');
      return false;
    }
  }

  /// MARKETPLACE/STORE DATA OPERATIONS
  Future<List<Map<String, dynamic>>> getProducts({
    String? category,
    String? status,
    int? limit,
  }) async {
    try {
      await _ensureInitialized();
      final workspaceId = await _getCurrentWorkspaceId();
      
      if (workspaceId == null) return [];

      var query = _client
          .from('products')
          .select('*')
          .eq('workspace_id', workspaceId);

      if (category != null) {
        query = query.eq('category', category);
      }

      if (status != null) {
        query = query.eq('status', status);
      }

      final response = await query
          .order('created_at', ascending: false)
          .limit(limit ?? 50);

      return List<Map<String, dynamic>>.from(response);
    } catch (e) {
      ErrorHandler.handleError('Failed to get products: $e');
      return [];
    }
  }

  Future<bool> createProduct(Map<String, dynamic> productData) async {
    try {
      await _ensureInitialized();
      final workspaceId = await _getCurrentWorkspaceId();
      final userId = _client.auth.currentUser?.id;
      
      if (workspaceId == null || userId == null) return false;

      final data = {
        ...productData,
        'workspace_id': workspaceId,
        'created_by': userId,
        'created_at': DateTime.now().toIso8601String(),
      };

      await _client.from('products').insert(data);

      // Track analytics event
      await trackAnalyticsEvent('product_created', {
        'category': productData['category'],
        'price': productData['price'],
      });

      return true;
    } catch (e) {
      ErrorHandler.handleError('Failed to create product: $e');
      return false;
    }
  }

  Future<bool> updateProduct(String productId, Map<String, dynamic> updateData) async {
    try {
      await _ensureInitialized();
      
      final data = {
        ...updateData,
        'updated_at': DateTime.now().toIso8601String(),
      };

      await _client
          .from('products')
          .update(data)
          .eq('id', productId);

      return true;
    } catch (e) {
      ErrorHandler.handleError('Failed to update product: $e');
      return false;
    }
  }

  Future<bool> deleteProduct(String productId) async {
    try {
      await _ensureInitialized();

      await _client
          .from('products')
          .delete()
          .eq('id', productId);

      return true;
    } catch (e) {
      ErrorHandler.handleError('Failed to delete product: $e');
      return false;
    }
  }

  /// ORDERS DATA OPERATIONS
  Future<List<Map<String, dynamic>>> getOrders({
    String? status,
    DateTime? startDate,
    DateTime? endDate,
    int? limit,
  }) async {
    try {
      await _ensureInitialized();
      final workspaceId = await _getCurrentWorkspaceId();
      
      if (workspaceId == null) return [];

      var query = _client
          .from('orders')
          .select('*, order_items(*, products(name, price))')
          .eq('workspace_id', workspaceId);

      if (status != null) {
        query = query.eq('status', status);
      }

      if (startDate != null) {
        query = query.gte('created_at', startDate.toIso8601String());
      }

      if (endDate != null) {
        query = query.lte('created_at', endDate.toIso8601String());
      }

      final response = await query
          .order('created_at', ascending: false)
          .limit(limit ?? 50);

      return List<Map<String, dynamic>>.from(response);
    } catch (e) {
      ErrorHandler.handleError('Failed to get orders: $e');
      return [];
    }
  }

  Future<bool> createOrder(Map<String, dynamic> orderData) async {
    try {
      await _ensureInitialized();
      final workspaceId = await _getCurrentWorkspaceId();
      
      if (workspaceId == null) return false;

      final data = {
        ...orderData,
        'workspace_id': workspaceId,
        'created_at': DateTime.now().toIso8601String(),
      };

      await _client.from('orders').insert(data);

      // Track analytics event
      await trackAnalyticsEvent('order_created', {
        'total_amount': orderData['total_amount'],
        'customer_email': orderData['customer_email'],
      });

      return true;
    } catch (e) {
      ErrorHandler.handleError('Failed to create order: $e');
      return false;
    }
  }

  /// NOTIFICATIONS DATA OPERATIONS
  Future<List<Map<String, dynamic>>> getNotifications({
    String? type,
    bool? unreadOnly,
    int? limit,
  }) async {
    try {
      await _ensureInitialized();
      final workspaceId = await _getCurrentWorkspaceId();
      final userId = _client.auth.currentUser?.id;
      
      if (workspaceId == null || userId == null) return [];

      var query = _client
          .from('notifications')
          .select('*')
          .eq('workspace_id', workspaceId)
          .eq('user_id', userId);

      if (type != null) {
        query = query.eq('notification_type', type);
      }

      if (unreadOnly == true) {
        query = query.is_('read_at', null);
      }

      final response = await query
          .order('created_at', ascending: false)
          .limit(limit ?? 50);

      return List<Map<String, dynamic>>.from(response);
    } catch (e) {
      ErrorHandler.handleError('Failed to get notifications: $e');
      return [];
    }
  }

  Future<bool> markNotificationAsRead(String notificationId) async {
    try {
      await _ensureInitialized();

      await _client
          .from('notifications')
          .update({'read_at': DateTime.now().toIso8601String()})
          .eq('id', notificationId);

      return true;
    } catch (e) {
      ErrorHandler.handleError('Failed to mark notification as read: $e');
      return false;
    }
  }

  Future<bool> sendNotification({
    required String userId,
    required String type,
    required String title,
    required String message,
    Map<String, dynamic>? data,
    String priority = 'medium',
  }) async {
    try {
      await _ensureInitialized();
      final workspaceId = await _getCurrentWorkspaceId();
      
      if (workspaceId == null) return false;

      await _client.rpc('send_notification', params: {
        'user_uuid': userId,
        'workspace_uuid': workspaceId,
        'notification_type_param': type,
        'title_param': title,
        'message_param': message,
        'data_param': data ?? {},
        'priority_param': priority,
      });

      return true;
    } catch (e) {
      ErrorHandler.handleError('Failed to send notification: $e');
      return false;
    }
  }

  /// REAL-TIME SUBSCRIPTIONS
  RealtimeChannel? _analyticsChannel;
  RealtimeChannel? _socialMediaChannel;
  RealtimeChannel? _productsChannel;
  RealtimeChannel? _ordersChannel;
  RealtimeChannel? _notificationsChannel;

  /// Subscribe to analytics data changes
  Future<void> subscribeToAnalyticsChanges(Function(Map<String, dynamic>) onChanged) async {
    try {
      await _ensureInitialized();
      final workspaceId = await _getCurrentWorkspaceId();
      
      if (workspaceId == null) return;

      _analyticsChannel = _client
          .channel('analytics_$workspaceId')
          .onPostgresChanges(
            event: PostgresChangeEvent.all,
            schema: 'public',
            table: 'analytics_events',
            filter: PostgresChangeFilter(
              type: PostgresChangeFilterType.eq,
              column: 'workspace_id',
              value: workspaceId,
            ),
            callback: (payload) => onChanged(payload.newRecord),
          )
          .subscribe();
    } catch (e) {
      ErrorHandler.handleError('Failed to subscribe to analytics changes: $e');
    }
  }

  /// Subscribe to social media data changes
  Future<void> subscribeToSocialMediaChanges(Function(Map<String, dynamic>) onChanged) async {
    try {
      await _ensureInitialized();
      final workspaceId = await _getCurrentWorkspaceId();
      
      if (workspaceId == null) return;

      _socialMediaChannel = _client
          .channel('social_media_$workspaceId')
          .onPostgresChanges(
            event: PostgresChangeEvent.all,
            schema: 'public',
            table: 'social_media_posts',
            filter: PostgresChangeFilter(
              type: PostgresChangeFilterType.eq,
              column: 'workspace_id',
              value: workspaceId,
            ),
            callback: (payload) => onChanged(payload.newRecord),
          )
          .subscribe();
    } catch (e) {
      ErrorHandler.handleError('Failed to subscribe to social media changes: $e');
    }
  }

  /// Subscribe to product changes
  Future<void> subscribeToProductChanges(Function(Map<String, dynamic>) onChanged) async {
    try {
      await _ensureInitialized();
      final workspaceId = await _getCurrentWorkspaceId();
      
      if (workspaceId == null) return;

      _productsChannel = _client
          .channel('products_$workspaceId')
          .onPostgresChanges(
            event: PostgresChangeEvent.all,
            schema: 'public',
            table: 'products',
            filter: PostgresChangeFilter(
              type: PostgresChangeFilterType.eq,
              column: 'workspace_id',
              value: workspaceId,
            ),
            callback: (payload) => onChanged(payload.newRecord),
          )
          .subscribe();
    } catch (e) {
      ErrorHandler.handleError('Failed to subscribe to product changes: $e');
    }
  }

  /// Subscribe to order changes
  Future<void> subscribeToOrderChanges(Function(Map<String, dynamic>) onChanged) async {
    try {
      await _ensureInitialized();
      final workspaceId = await _getCurrentWorkspaceId();
      
      if (workspaceId == null) return;

      _ordersChannel = _client
          .channel('orders_$workspaceId')
          .onPostgresChanges(
            event: PostgresChangeEvent.all,
            schema: 'public',
            table: 'orders',
            filter: PostgresChangeFilter(
              type: PostgresChangeFilterType.eq,
              column: 'workspace_id',
              value: workspaceId,
            ),
            callback: (payload) => onChanged(payload.newRecord),
          )
          .subscribe();
    } catch (e) {
      ErrorHandler.handleError('Failed to subscribe to order changes: $e');
    }
  }

  /// Subscribe to notification changes
  Future<void> subscribeToNotificationChanges(Function(Map<String, dynamic>) onChanged) async {
    try {
      await _ensureInitialized();
      final workspaceId = await _getCurrentWorkspaceId();
      final userId = _client.auth.currentUser?.id;
      
      if (workspaceId == null || userId == null) return;

      _notificationsChannel = _client
          .channel('notifications_${workspaceId}_$userId')
          .onPostgresChanges(
            event: PostgresChangeEvent.all,
            schema: 'public',
            table: 'notifications',
            filter: PostgresChangeFilter(
              type: PostgresChangeFilterType.eq,
              column: 'user_id',
              value: userId,
            ),
            callback: (payload) => onChanged(payload.newRecord),
          )
          .subscribe();
    } catch (e) {
      ErrorHandler.handleError('Failed to subscribe to notification changes: $e');
    }
  }

  /// Unsubscribe from all channels
  Future<void> unsubscribeFromAll() async {
    try {
      await _analyticsChannel?.unsubscribe();
      await _socialMediaChannel?.unsubscribe();
      await _productsChannel?.unsubscribe();
      await _ordersChannel?.unsubscribe();
      await _notificationsChannel?.unsubscribe();
      
      _analyticsChannel = null;
      _socialMediaChannel = null;
      _productsChannel = null;
      _ordersChannel = null;
      _notificationsChannel = null;
    } catch (e) {
      ErrorHandler.handleError('Failed to unsubscribe from channels: $e');
    }
  }

  /// Helper method to get empty analytics data
  Map<String, dynamic> _getEmptyAnalyticsData() {
    return {
      'revenue': {
        'total_revenue': 0,
        'total_orders': 0,
        'conversion_rate': 0.0,
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

  /// Dispose method for cleanup
  void dispose() {
    unsubscribeFromAll();
  }
}