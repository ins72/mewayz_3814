import '../core/app_export.dart';
import './analytics_data_service.dart';

/// Service for handling store/marketplace data operations with Supabase
class StoreDataService {
  static final StoreDataService _instance = StoreDataService._internal();
  factory StoreDataService() => _instance;
  StoreDataService._internal();

  final SupabaseService _supabaseService = SupabaseService();
  final AnalyticsDataService _analyticsService = AnalyticsDataService();

  /// Get store data for workspace
  Future<Map<String, dynamic>> getStoreData(String workspaceId) async {
    try {
      final client = await _supabaseService.client;
      
      // Get workspace info
      final workspaceResponse = await client
          .from('workspaces')
          .select('name, description, logo_url')
          .eq('id', workspaceId)
          .single();
      
      // Get products count
      final productsResponse = await client
          .from('products')
          .select('id')
          .eq('workspace_id', workspaceId);
      
      // Get orders count
      final ordersResponse = await client
          .from('orders')
          .select('id')
          .eq('workspace_id', workspaceId);
      
      // Get revenue
      final revenueResponse = await client
          .from('orders')
          .select('total_amount')
          .eq('workspace_id', workspaceId)
          .eq('status', 'completed');
      
      final revenue = revenueResponse.fold(0.0, (sum, order) => sum + (order['total_amount'] as num).toDouble());
      
      return {
        'storeName': workspaceResponse['name'] ?? 'My Store',
        'description': workspaceResponse['description'] ?? 'Online store for digital products',
        'logo_url': workspaceResponse['logo_url'],
        'totalProducts': productsResponse.length ?? 0,
        'totalOrders': ordersResponse.length ?? 0,
        'revenue': '\$${revenue.toStringAsFixed(2)}',
        'rating': 4.8, // This could be calculated from reviews
        'isVerified': true,
      };
    } catch (e) {
      if (kDebugMode) {
        debugPrint('Failed to get store data: $e');
      }
      return _getEmptyStoreData();
    }
  }

  /// Get products
  Future<List<Map<String, dynamic>>> getProducts(String workspaceId) async {
    try {
      final client = await _supabaseService.client;
      
      final response = await client
          .from('products')
          .select('*, user_profiles(full_name)')
          .eq('workspace_id', workspaceId)
          .order('created_at', ascending: false);
      
      final products = List<Map<String, dynamic>>.from(response);
      
      // Convert to format expected by UI
      return products.map((product) {
        return {
          'id': product['id'],
          'name': product['name'],
          'description': product['description'],
          'price': '\$${(product['price'] as num).toStringAsFixed(2)}',
          'stock': product['stock_quantity'],
          'status': _getProductStatus(product['stock_quantity'] as int, product['status'] as String),
          'category': product['category'],
          'images': product['images'] ?? [],
          'isBestseller': product['is_featured'] ?? false,
          'created_at': product['created_at'],
          'created_by': product['user_profiles']?['full_name'] ?? 'Unknown',
        };
      }).toList();
    } catch (e) {
      if (kDebugMode) {
        debugPrint('Failed to get products: $e');
      }
      return [];
    }
  }

  /// Create product
  Future<bool> createProduct(String workspaceId, Map<String, dynamic> productData) async {
    try {
      final client = await _supabaseService.client;
      
      final response = await client.from('products').insert({
        'workspace_id': workspaceId,
        'name': productData['name'],
        'description': productData['description'],
        'price': productData['price'],
        'cost_price': productData['cost_price'],
        'sku': productData['sku'],
        'category': productData['category'],
        'tags': productData['tags'],
        'images': productData['images'] ?? [],
        'stock_quantity': productData['stock_quantity'] ?? 0,
        'stock_threshold': productData['stock_threshold'] ?? 5,
        'status': productData['status'] ?? 'active',
        'is_featured': productData['is_featured'] ?? false,
        'metadata': productData['metadata'] ?? {},
        'created_by': _supabaseService.currentUser?.id,
      }).select();
      
      if (response.isNotEmpty) {
        // Track analytics
        await _analyticsService.trackEvent('product_created', {
          'product_id': response.first['id'],
          'product_name': productData['name'],
          'category': productData['category'],
        }, workspaceId: workspaceId);
        
        await _analyticsService.updateMetric(
          workspaceId,
          'marketplace_activity',
          'products_created',
          1,
          metadata: {'product_id': response.first['id']});
        
        if (kDebugMode) {
          debugPrint('Product created: ${productData['name']}');
        }
        
        return true;
      }
      
      return false;
    } catch (e) {
      if (kDebugMode) {
        debugPrint('Failed to create product: $e');
      }
      return false;
    }
  }

  /// Update product
  Future<bool> updateProduct(String workspaceId, String productId, Map<String, dynamic> productData) async {
    try {
      final client = await _supabaseService.client;
      
      final updateData = Map<String, dynamic>.from(productData);
      updateData['updated_at'] = DateTime.now().toIso8601String();
      
      await client
          .from('products')
          .update(updateData)
          .eq('id', productId)
          .eq('workspace_id', workspaceId);
      
      // Track analytics
      await _analyticsService.trackEvent('product_updated', {
        'product_id': productId,
        'updated_fields': updateData.keys.toList(),
      }, workspaceId: workspaceId);
      
      if (kDebugMode) {
        debugPrint('Product updated: $productId');
      }
      
      return true;
    } catch (e) {
      if (kDebugMode) {
        debugPrint('Failed to update product: $e');
      }
      return false;
    }
  }

  /// Delete product
  Future<bool> deleteProduct(String workspaceId, String productId) async {
    try {
      final client = await _supabaseService.client;
      
      await client
          .from('products')
          .delete()
          .eq('id', productId)
          .eq('workspace_id', workspaceId);
      
      // Track analytics
      await _analyticsService.trackEvent('product_deleted', {
        'product_id': productId,
      }, workspaceId: workspaceId);
      
      if (kDebugMode) {
        debugPrint('Product deleted: $productId');
      }
      
      return true;
    } catch (e) {
      if (kDebugMode) {
        debugPrint('Failed to delete product: $e');
      }
      return false;
    }
  }

  /// Get orders
  Future<List<Map<String, dynamic>>> getOrders(String workspaceId) async {
    try {
      final client = await _supabaseService.client;
      
      final response = await client
          .from('orders')
          .select('*, order_items(*)')
          .eq('workspace_id', workspaceId)
          .order('created_at', ascending: false);
      
      final orders = List<Map<String, dynamic>>.from(response);
      
      // Convert to format expected by UI
      return orders.map((order) {
        final orderItems = order['order_items'] as List<dynamic>;
        
        return {
          'id': order['order_number'],
          'customerName': order['customer_name'],
          'customerEmail': order['customer_email'],
          'items': orderItems.length,
          'total': '\$${(order['total_amount'] as num).toStringAsFixed(2)}',
          'status': order['status'],
          'date': DateTime.parse(order['created_at'] as String).toIso8601String().split('T')[0],
          'shippingAddress': order['shipping_address'],
          'billingAddress': order['billing_address'],
          'payment_status': order['payment_status'],
          'payment_method': order['payment_method'],
          'notes': order['notes'],
          'order_items': orderItems,
        };
      }).toList();
    } catch (e) {
      if (kDebugMode) {
        debugPrint('Failed to get orders: $e');
      }
      return [];
    }
  }

  /// Create order
  Future<bool> createOrder(String workspaceId, Map<String, dynamic> orderData) async {
    try {
      final client = await _supabaseService.client;
      
      // Generate order number
      final orderNumber = 'ORD-${DateTime.now().millisecondsSinceEpoch}';
      
      final response = await client.from('orders').insert({
        'workspace_id': workspaceId,
        'order_number': orderNumber,
        'customer_email': orderData['customer_email'],
        'customer_name': orderData['customer_name'],
        'customer_phone': orderData['customer_phone'],
        'shipping_address': orderData['shipping_address'] ?? {},
        'billing_address': orderData['billing_address'] ?? {},
        'subtotal': orderData['subtotal'],
        'tax_amount': orderData['tax_amount'] ?? 0,
        'shipping_amount': orderData['shipping_amount'] ?? 0,
        'total_amount': orderData['total_amount'],
        'currency': orderData['currency'] ?? 'USD',
        'payment_method': orderData['payment_method'],
        'payment_data': orderData['payment_data'] ?? {},
        'notes': orderData['notes'],
      }).select();
      
      if (response.isNotEmpty) {
        final orderId = response.first['id'];
        
        // Add order items
        if (orderData['items'] != null) {
          final orderItems = (orderData['items'] as List<dynamic>).map((item) => {
            'order_id': orderId,
            'product_id': item['product_id'],
            'quantity': item['quantity'],
            'unit_price': item['unit_price'],
            'total_price': item['total_price'],
            'product_snapshot': item['product_snapshot'] ?? {},
          }).toList();
          
          await client.from('order_items').insert(orderItems);
        }
        
        // Track analytics
        await _analyticsService.trackEvent('order_created', {
          'order_id': orderId,
          'order_number': orderNumber,
          'total_amount': orderData['total_amount'],
          'customer_email': orderData['customer_email'],
        }, workspaceId: workspaceId);
        
        await _analyticsService.updateMetric(
          workspaceId,
          'revenue',
          'total_revenue',
          orderData['total_amount']);
        
        await _analyticsService.updateMetric(
          workspaceId,
          'revenue',
          'total_orders',
          1);
        
        if (kDebugMode) {
          debugPrint('Order created: $orderNumber');
        }
        
        return true;
      }
      
      return false;
    } catch (e) {
      if (kDebugMode) {
        debugPrint('Failed to create order: $e');
      }
      return false;
    }
  }

  /// Update order status
  Future<bool> updateOrderStatus(String workspaceId, String orderId, String status) async {
    try {
      final client = await _supabaseService.client;
      
      await client
          .from('orders')
          .update({'status': status, 'updated_at': DateTime.now().toIso8601String()})
          .eq('id', orderId)
          .eq('workspace_id', workspaceId);
      
      // Track analytics
      await _analyticsService.trackEvent('order_status_updated', {
        'order_id': orderId,
        'new_status': status,
      }, workspaceId: workspaceId);
      
      if (kDebugMode) {
        debugPrint('Order status updated: $orderId -> $status');
      }
      
      return true;
    } catch (e) {
      if (kDebugMode) {
        debugPrint('Failed to update order status: $e');
      }
      return false;
    }
  }

  /// Get store analytics
  Future<Map<String, dynamic>> getStoreAnalytics(String workspaceId) async {
    try {
      final client = await _supabaseService.client;
      
      // Get product analytics
      final productsAnalytics = await _analyticsService.getProductsAnalytics(workspaceId);
      
      // Get order analytics
      final ordersAnalytics = await _analyticsService.getOrdersAnalytics(workspaceId);
      
      // Get top selling products
      final topProducts = await client
          .from('order_items')
          .select('product_id, quantity, products(name, price)')
          .eq('products.workspace_id', workspaceId)
          .order('quantity', ascending: false)
          .limit(5);
      
      // Get recent activity
      final recentActivity = await client
          .from('analytics_events')
          .select('event_name, event_data, created_at')
          .eq('workspace_id', workspaceId)
          .inFilter('event_name', ['product_created', 'order_created', 'product_updated'])
          .order('created_at', ascending: false)
          .limit(10);
      
      return {
        'products': productsAnalytics,
        'orders': ordersAnalytics,
        'top_products': List<Map<String, dynamic>>.from(topProducts),
        'recent_activity': List<Map<String, dynamic>>.from(recentActivity),
      };
    } catch (e) {
      if (kDebugMode) {
        debugPrint('Failed to get store analytics: $e');
      }
      return {
        'products': {'total_products': 0, 'active_products': 0},
        'orders': {'total_orders': 0, 'total_revenue': 0},
        'top_products': [],
        'recent_activity': [],
      };
    }
  }

  /// Search products
  Future<List<Map<String, dynamic>>> searchProducts(String workspaceId, String query) async {
    try {
      final client = await _supabaseService.client;
      
      final response = await client
          .from('products')
          .select()
          .eq('workspace_id', workspaceId)
          .or('name.ilike.%$query%,description.ilike.%$query%,category.ilike.%$query%')
          .order('created_at', ascending: false);
      
      return List<Map<String, dynamic>>.from(response);
    } catch (e) {
      if (kDebugMode) {
        debugPrint('Failed to search products: $e');
      }
      return [];
    }
  }

  /// Get low stock products
  Future<List<Map<String, dynamic>>> getLowStockProducts(String workspaceId) async {
    try {
      final client = await _supabaseService.client;
      
      final response = await client
          .from('products')
          .select()
          .eq('workspace_id', workspaceId)
          .lte('stock_quantity', 5)
          .order('stock_quantity', ascending: true);
      
      return List<Map<String, dynamic>>.from(response);
    } catch (e) {
      if (kDebugMode) {
        debugPrint('Failed to get low stock products: $e');
      }
      return [];
    }
  }

  /// Get product status based on stock and status
  String _getProductStatus(int stockQuantity, String status) {
    if (status == 'inactive') return 'inactive';
    if (stockQuantity == 0) return 'out_of_stock';
    if (stockQuantity <= 5) return 'low_stock';
    return 'active';
  }

  /// Get empty store data
  Map<String, dynamic> _getEmptyStoreData() {
    return {
      'storeName': 'My Store',
      'description': 'Online store for digital products',
      'logo_url': null,
      'totalProducts': 0,
      'totalOrders': 0,
      'revenue': '\$0.00',
      'rating': 0.0,
      'isVerified': false,
    };
  }
}