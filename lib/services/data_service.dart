import 'dart:io';

import '../core/app_export.dart';
import './unified_data_service.dart';

/// Service for handling data operations across the application
/// Updated to use UnifiedDataService for all Supabase operations
class DataService {
  static final DataService _instance = DataService._internal();
  factory DataService() => _instance;
  DataService._internal();

  final UnifiedDataService _unifiedDataService = UnifiedDataService();

  /// Initialize the data service
  Future<void> initialize() async {
    await _unifiedDataService.initialize();
  }

  /// Social Media Data Operations - Now using Supabase
  Future<Map<String, dynamic>> getSocialMediaStats() async {
    try {
      final analyticsData = await _unifiedDataService.getAnalyticsData();
      return analyticsData['social_media'] ?? _getEmptySocialMediaStats();
    } catch (e) {
      ErrorHandler.handleError('Failed to get social media stats: $e');
      return _getEmptySocialMediaStats();
    }
  }

  Future<List<Map<String, dynamic>>> getSocialMediaPosts() async {
    try {
      return await _unifiedDataService.getSocialMediaPosts();
    } catch (e) {
      ErrorHandler.handleError('Failed to get social media posts: $e');
      return [];
    }
  }

  Future<bool> createSocialMediaPost(Map<String, dynamic> postData) async {
    try {
      return await _unifiedDataService.createSocialMediaPost(postData);
    } catch (e) {
      ErrorHandler.handleError('Failed to create social media post: $e');
      return false;
    }
  }

  Future<bool> updateSocialMediaPost(String postId, Map<String, dynamic> postData) async {
    try {
      return await _unifiedDataService.updateSocialMediaPost(postId, postData);
    } catch (e) {
      ErrorHandler.handleError('Failed to update social media post: $e');
      return false;
    }
  }

  Future<bool> deleteSocialMediaPost(String postId) async {
    try {
      return await _unifiedDataService.deleteSocialMediaPost(postId);
    } catch (e) {
      ErrorHandler.handleError('Failed to delete social media post: $e');
      return false;
    }
  }

  Future<bool> schedulePost(Map<String, dynamic> postData) async {
    try {
      // Add scheduling information to post data
      postData['status'] = 'scheduled';
      return await _unifiedDataService.createSocialMediaPost(postData);
    } catch (e) {
      ErrorHandler.handleError('Failed to schedule post: $e');
      return false;
    }
  }

  /// CRM Data Operations - Using Supabase (placeholder for future CRM tables)
  Future<List<Map<String, dynamic>>> getContacts() async {
    try {
      // For now, return empty list until CRM tables are added to migration
      // In the future, this will query the contacts table
      return [];
    } catch (e) {
      ErrorHandler.handleError('Failed to get contacts: $e');
      return [];
    }
  }

  Future<bool> createContact(Map<String, dynamic> contactData) async {
    try {
      // Track as analytics event for now
      await _unifiedDataService.trackAnalyticsEvent('contact_created', contactData);
      return true;
    } catch (e) {
      ErrorHandler.handleError('Failed to create contact: $e');
      return false;
    }
  }

  Future<bool> updateContact(String contactId, Map<String, dynamic> contactData) async {
    try {
      // Track as analytics event for now
      await _unifiedDataService.trackAnalyticsEvent('contact_updated', {
        'contact_id': contactId,
        ...contactData,
      });
      return true;
    } catch (e) {
      ErrorHandler.handleError('Failed to update contact: $e');
      return false;
    }
  }

  Future<bool> deleteContact(String contactId) async {
    try {
      // Track as analytics event for now
      await _unifiedDataService.trackAnalyticsEvent('contact_deleted', {
        'contact_id': contactId,
      });
      return true;
    } catch (e) {
      ErrorHandler.handleError('Failed to delete contact: $e');
      return false;
    }
  }

  Future<List<Map<String, dynamic>>> searchContacts(String query) async {
    try {
      // For now, return empty list until CRM tables are added
      return [];
    } catch (e) {
      ErrorHandler.handleError('Failed to search contacts: $e');
      return [];
    }
  }

  /// Analytics Data Operations - Using Supabase
  Future<Map<String, dynamic>> getAnalyticsData() async {
    try {
      return await _unifiedDataService.getAnalyticsData();
    } catch (e) {
      ErrorHandler.handleError('Failed to get analytics data: $e');
      return _getEmptyAnalyticsData();
    }
  }

  Future<List<Map<String, dynamic>>> getAnalyticsChartData(String chartType) async {
    try {
      return await _unifiedDataService.getAnalyticsEvents(
        eventName: chartType,
        limit: 100,
      );
    } catch (e) {
      ErrorHandler.handleError('Failed to get analytics chart data: $e');
      return [];
    }
  }

  /// Marketplace Data Operations - Using Supabase
  Future<List<Map<String, dynamic>>> getProducts() async {
    try {
      return await _unifiedDataService.getProducts();
    } catch (e) {
      ErrorHandler.handleError('Failed to get products: $e');
      return [];
    }
  }

  Future<bool> createProduct(Map<String, dynamic> productData) async {
    try {
      return await _unifiedDataService.createProduct(productData);
    } catch (e) {
      ErrorHandler.handleError('Failed to create product: $e');
      return false;
    }
  }

  Future<bool> updateProduct(String productId, Map<String, dynamic> productData) async {
    try {
      return await _unifiedDataService.updateProduct(productId, productData);
    } catch (e) {
      ErrorHandler.handleError('Failed to update product: $e');
      return false;
    }
  }

  Future<bool> deleteProduct(String productId) async {
    try {
      return await _unifiedDataService.deleteProduct(productId);
    } catch (e) {
      ErrorHandler.handleError('Failed to delete product: $e');
      return false;
    }
  }

  /// Orders Data Operations - Using Supabase
  Future<List<Map<String, dynamic>>> getOrders() async {
    try {
      return await _unifiedDataService.getOrders();
    } catch (e) {
      ErrorHandler.handleError('Failed to get orders: $e');
      return [];
    }
  }

  Future<bool> createOrder(Map<String, dynamic> orderData) async {
    try {
      return await _unifiedDataService.createOrder(orderData);
    } catch (e) {
      ErrorHandler.handleError('Failed to create order: $e');
      return false;
    }
  }

  /// Course Data Operations - Using analytics tracking for now
  Future<List<Map<String, dynamic>>> getCourses() async {
    try {
      // For now, return empty list until course tables are added
      return [];
    } catch (e) {
      ErrorHandler.handleError('Failed to get courses: $e');
      return [];
    }
  }

  Future<bool> createCourse(Map<String, dynamic> courseData) async {
    try {
      // Track as analytics event for now
      await _unifiedDataService.trackAnalyticsEvent('course_created', courseData);
      return true;
    } catch (e) {
      ErrorHandler.handleError('Failed to create course: $e');
      return false;
    }
  }

  Future<bool> updateCourse(String courseId, Map<String, dynamic> courseData) async {
    try {
      // Track as analytics event for now
      await _unifiedDataService.trackAnalyticsEvent('course_updated', {
        'course_id': courseId,
        ...courseData,
      });
      return true;
    } catch (e) {
      ErrorHandler.handleError('Failed to update course: $e');
      return false;
    }
  }

  Future<bool> deleteCourse(String courseId) async {
    try {
      // Track as analytics event for now
      await _unifiedDataService.trackAnalyticsEvent('course_deleted', {
        'course_id': courseId,
      });
      return true;
    } catch (e) {
      ErrorHandler.handleError('Failed to delete course: $e');
      return false;
    }
  }

  /// Hashtag Research Operations - Using analytics tracking
  Future<List<Map<String, dynamic>>> getHashtagSuggestions(String query) async {
    try {
      // Track search query for analytics
      await _unifiedDataService.trackAnalyticsEvent('hashtag_search', {
        'query': query,
      });
      
      // Return empty list for now - this would connect to social media APIs
      return [];
    } catch (e) {
      ErrorHandler.handleError('Failed to get hashtag suggestions: $e');
      return [];
    }
  }

  Future<List<Map<String, dynamic>>> getTrendingHashtags() async {
    try {
      // Track trending hashtags request
      await _unifiedDataService.trackAnalyticsEvent('trending_hashtags_viewed', {});
      
      // Return empty list for now - this would connect to social media APIs
      return [];
    } catch (e) {
      ErrorHandler.handleError('Failed to get trending hashtags: $e');
      return [];
    }
  }

  /// Template Operations - Using analytics tracking
  Future<List<Map<String, dynamic>>> getTemplates(String category) async {
    try {
      // Track template category view
      await _unifiedDataService.trackAnalyticsEvent('templates_viewed', {
        'category': category,
      });
      
      // Return empty list for now - this would connect to template database
      return [];
    } catch (e) {
      ErrorHandler.handleError('Failed to get templates: $e');
      return [];
    }
  }

  Future<bool> saveTemplate(Map<String, dynamic> templateData) async {
    try {
      // Track template save
      await _unifiedDataService.trackAnalyticsEvent('template_saved', templateData);
      return true;
    } catch (e) {
      ErrorHandler.handleError('Failed to save template: $e');
      return false;
    }
  }

  /// Email Marketing Operations - Using analytics tracking
  Future<bool> sendEmailCampaign(Map<String, dynamic> campaignData) async {
    try {
      // Track email campaign
      await _unifiedDataService.trackAnalyticsEvent('email_campaign_sent', campaignData);
      return true;
    } catch (e) {
      ErrorHandler.handleError('Failed to send email campaign: $e');
      return false;
    }
  }

  Future<List<Map<String, dynamic>>> getEmailCampaigns() async {
    try {
      // Track email campaigns view
      await _unifiedDataService.trackAnalyticsEvent('email_campaigns_viewed', {});
      
      // Return empty list for now - this would connect to email service
      return [];
    } catch (e) {
      ErrorHandler.handleError('Failed to get email campaigns: $e');
      return [];
    }
  }

  /// File Upload Operations - Using Supabase Storage
  Future<String?> uploadFile(String filePath, String fileType) async {
    try {
      final supabaseService = SupabaseService();
      final client = await supabaseService.client;
      
      final file = File(filePath);
      final fileName = '${DateTime.now().millisecondsSinceEpoch}_${file.path.split('/').last}';
      
      await client.storage
          .from('uploads')
          .upload(fileName, file);
      
      final url = client.storage
          .from('uploads')
          .getPublicUrl(fileName);
      
      // Track file upload
      await _unifiedDataService.trackAnalyticsEvent('file_uploaded', {
        'file_type': fileType,
        'file_name': fileName,
      });
      
      return url;
    } catch (e) {
      ErrorHandler.handleError('Failed to upload file: $e');
      return null;
    }
  }

  /// Notification Operations - Using Supabase
  Future<List<Map<String, dynamic>>> getNotifications() async {
    try {
      return await _unifiedDataService.getNotifications();
    } catch (e) {
      ErrorHandler.handleError('Failed to get notifications: $e');
      return [];
    }
  }

  Future<bool> markNotificationAsRead(String notificationId) async {
    try {
      return await _unifiedDataService.markNotificationAsRead(notificationId);
    } catch (e) {
      ErrorHandler.handleError('Failed to mark notification as read: $e');
      return false;
    }
  }

  /// Real-time subscriptions
  Future<void> subscribeToRealTimeUpdates({
    Function(Map<String, dynamic>)? onAnalyticsChanged,
    Function(Map<String, dynamic>)? onSocialMediaChanged,
    Function(Map<String, dynamic>)? onProductsChanged,
    Function(Map<String, dynamic>)? onOrdersChanged,
    Function(Map<String, dynamic>)? onNotificationsChanged,
  }) async {
    try {
      if (onAnalyticsChanged != null) {
        await _unifiedDataService.subscribeToAnalyticsChanges(onAnalyticsChanged);
      }
      
      if (onSocialMediaChanged != null) {
        await _unifiedDataService.subscribeToSocialMediaChanges(onSocialMediaChanged);
      }
      
      if (onProductsChanged != null) {
        await _unifiedDataService.subscribeToProductChanges(onProductsChanged);
      }
      
      if (onOrdersChanged != null) {
        await _unifiedDataService.subscribeToOrderChanges(onOrdersChanged);
      }
      
      if (onNotificationsChanged != null) {
        await _unifiedDataService.subscribeToNotificationChanges(onNotificationsChanged);
      }
    } catch (e) {
      ErrorHandler.handleError('Failed to subscribe to real-time updates: $e');
    }
  }

  /// Unsubscribe from real-time updates
  Future<void> unsubscribeFromRealTimeUpdates() async {
    try {
      await _unifiedDataService.unsubscribeFromAll();
    } catch (e) {
      ErrorHandler.handleError('Failed to unsubscribe from real-time updates: $e');
    }
  }

  /// Track custom analytics events
  Future<void> trackEvent(String eventName, Map<String, dynamic> data) async {
    try {
      await _unifiedDataService.trackAnalyticsEvent(eventName, data);
    } catch (e) {
      ErrorHandler.handleError('Failed to track event: $e');
    }
  }

  /// Empty Data Methods (for fallback scenarios)
  Map<String, dynamic> _getEmptySocialMediaStats() {
    return {
      'total_followers': 0,
      'total_engagement': 0,
      'posts_count': 0,
      'reach': 0,
      'engagement_rate': 0.0,
    };
  }

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

  /// Cleanup
  void dispose() {
    _unifiedDataService.dispose();
  }
}