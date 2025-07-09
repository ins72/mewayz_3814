import 'dart:io';

import '../core/app_export.dart';

/// Service for handling data operations across the application
class DataService {
  static final DataService _instance = DataService._internal();
  factory DataService() => _instance;
  DataService._internal();

  final ApiClient _apiClient = ApiClient();
  final StorageService _storageService = StorageService();

  /// Social Media Data Operations
  Future<Map<String, dynamic>> getSocialMediaStats() async {
    try {
      final response = await _apiClient.get('/social-media/stats');
      return response.data ?? _getMockSocialMediaStats();
    } catch (e) {
      // Return mock data on error
      return _getMockSocialMediaStats();
    }
  }

  Future<List<Map<String, dynamic>>> getSocialMediaPosts() async {
    try {
      final response = await _apiClient.get('/social-media/posts');
      return List<Map<String, dynamic>>.from(response.data ?? []);
    } catch (e) {
      return _getMockSocialMediaPosts();
    }
  }

  Future<bool> createSocialMediaPost(Map<String, dynamic> postData) async {
    try {
      await _apiClient.post('/social-media/posts', data: postData);
      return true;
    } catch (e) {
      ErrorHandler.handleError(e);
      return false;
    }
  }

  Future<bool> updateSocialMediaPost(String postId, Map<String, dynamic> postData) async {
    try {
      await _apiClient.put('/social-media/posts/$postId', data: postData);
      return true;
    } catch (e) {
      ErrorHandler.handleError(e);
      return false;
    }
  }

  Future<bool> deleteSocialMediaPost(String postId) async {
    try {
      await _apiClient.delete('/social-media/posts/$postId');
      return true;
    } catch (e) {
      ErrorHandler.handleError(e);
      return false;
    }
  }

  Future<bool> schedulePost(Map<String, dynamic> postData) async {
    try {
      await _apiClient.post('/social-media/schedule', data: postData);
      return true;
    } catch (e) {
      ErrorHandler.handleError(e);
      return false;
    }
  }

  /// CRM Data Operations
  Future<List<Map<String, dynamic>>> getContacts() async {
    try {
      final response = await _apiClient.get('/crm/contacts');
      return List<Map<String, dynamic>>.from(response.data ?? []);
    } catch (e) {
      return _getMockContacts();
    }
  }

  Future<bool> createContact(Map<String, dynamic> contactData) async {
    try {
      await _apiClient.post('/crm/contacts', data: contactData);
      return true;
    } catch (e) {
      ErrorHandler.handleError(e);
      return false;
    }
  }

  Future<bool> updateContact(String contactId, Map<String, dynamic> contactData) async {
    try {
      await _apiClient.put('/crm/contacts/$contactId', data: contactData);
      return true;
    } catch (e) {
      ErrorHandler.handleError(e);
      return false;
    }
  }

  Future<bool> deleteContact(String contactId) async {
    try {
      await _apiClient.delete('/crm/contacts/$contactId');
      return true;
    } catch (e) {
      ErrorHandler.handleError(e);
      return false;
    }
  }

  Future<List<Map<String, dynamic>>> searchContacts(String query) async {
    try {
      final response = await _apiClient.get('/crm/contacts/search', 
        queryParameters: {'q': query});
      return List<Map<String, dynamic>>.from(response.data ?? []);
    } catch (e) {
      return _getMockContacts().where((contact) =>
        contact['name'].toString().toLowerCase().contains(query.toLowerCase()) ||
        contact['email'].toString().toLowerCase().contains(query.toLowerCase())
      ).toList();
    }
  }

  /// Analytics Data Operations
  Future<Map<String, dynamic>> getAnalyticsData() async {
    try {
      final response = await _apiClient.get('/analytics/dashboard');
      return response.data ?? _getMockAnalyticsData();
    } catch (e) {
      return _getMockAnalyticsData();
    }
  }

  Future<List<Map<String, dynamic>>> getAnalyticsChartData(String chartType) async {
    try {
      final response = await _apiClient.get('/analytics/charts/$chartType');
      return List<Map<String, dynamic>>.from(response.data ?? []);
    } catch (e) {
      return _getMockChartData(chartType);
    }
  }

  /// Marketplace Data Operations
  Future<List<Map<String, dynamic>>> getProducts() async {
    try {
      final response = await _apiClient.get('/marketplace/products');
      return List<Map<String, dynamic>>.from(response.data ?? []);
    } catch (e) {
      return _getMockProducts();
    }
  }

  Future<bool> createProduct(Map<String, dynamic> productData) async {
    try {
      await _apiClient.post('/marketplace/products', data: productData);
      return true;
    } catch (e) {
      ErrorHandler.handleError(e);
      return false;
    }
  }

  Future<bool> updateProduct(String productId, Map<String, dynamic> productData) async {
    try {
      await _apiClient.put('/marketplace/products/$productId', data: productData);
      return true;
    } catch (e) {
      ErrorHandler.handleError(e);
      return false;
    }
  }

  Future<bool> deleteProduct(String productId) async {
    try {
      await _apiClient.delete('/marketplace/products/$productId');
      return true;
    } catch (e) {
      ErrorHandler.handleError(e);
      return false;
    }
  }

  /// Course Data Operations
  Future<List<Map<String, dynamic>>> getCourses() async {
    try {
      final response = await _apiClient.get('/courses');
      return List<Map<String, dynamic>>.from(response.data ?? []);
    } catch (e) {
      return _getMockCourses();
    }
  }

  Future<bool> createCourse(Map<String, dynamic> courseData) async {
    try {
      await _apiClient.post('/courses', data: courseData);
      return true;
    } catch (e) {
      ErrorHandler.handleError(e);
      return false;
    }
  }

  Future<bool> updateCourse(String courseId, Map<String, dynamic> courseData) async {
    try {
      await _apiClient.put('/courses/$courseId', data: courseData);
      return true;
    } catch (e) {
      ErrorHandler.handleError(e);
      return false;
    }
  }

  Future<bool> deleteCourse(String courseId) async {
    try {
      await _apiClient.delete('/courses/$courseId');
      return true;
    } catch (e) {
      ErrorHandler.handleError(e);
      return false;
    }
  }

  /// Hashtag Research Operations
  Future<List<Map<String, dynamic>>> getHashtagSuggestions(String query) async {
    try {
      final response = await _apiClient.get('/hashtags/suggestions', 
        queryParameters: {'q': query});
      return List<Map<String, dynamic>>.from(response.data ?? []);
    } catch (e) {
      return _getMockHashtagSuggestions(query);
    }
  }

  Future<List<Map<String, dynamic>>> getTrendingHashtags() async {
    try {
      final response = await _apiClient.get('/hashtags/trending');
      return List<Map<String, dynamic>>.from(response.data ?? []);
    } catch (e) {
      return _getMockTrendingHashtags();
    }
  }

  /// Template Operations
  Future<List<Map<String, dynamic>>> getTemplates(String category) async {
    try {
      final response = await _apiClient.get('/templates', 
        queryParameters: {'category': category});
      return List<Map<String, dynamic>>.from(response.data ?? []);
    } catch (e) {
      return _getMockTemplates(category);
    }
  }

  Future<bool> saveTemplate(Map<String, dynamic> templateData) async {
    try {
      await _apiClient.post('/templates', data: templateData);
      return true;
    } catch (e) {
      ErrorHandler.handleError(e);
      return false;
    }
  }

  /// Email Marketing Operations
  Future<bool> sendEmailCampaign(Map<String, dynamic> campaignData) async {
    try {
      await _apiClient.post('/email/campaigns', data: campaignData);
      return true;
    } catch (e) {
      ErrorHandler.handleError(e);
      return false;
    }
  }

  Future<List<Map<String, dynamic>>> getEmailCampaigns() async {
    try {
      final response = await _apiClient.get('/email/campaigns');
      return List<Map<String, dynamic>>.from(response.data ?? []);
    } catch (e) {
      return _getMockEmailCampaigns();
    }
  }

  /// File Upload Operations
  Future<String?> uploadFile(String filePath, String fileType) async {
    try {
      final file = File(filePath);
      final response = await _apiClient.uploadFile('/upload', file);
      return response.data?['url'];
    } catch (e) {
      ErrorHandler.handleError(e);
      return null;
    }
  }

  /// Mock Data Methods
  Map<String, dynamic> _getMockSocialMediaStats() {
    return {
      'totalPosts': 1247,
      'totalFollowers': 25640,
      'totalEngagement': 48392,
      'totalReach': 125840,
      'growthRate': 12.5,
      'engagementRate': 4.2,
    };
  }

  List<Map<String, dynamic>> _getMockSocialMediaPosts() {
    return [
      {
        'id': '1',
        'title': 'New Product Launch',
        'content': 'Exciting announcement about our new product!',
        'platform': 'Instagram',
        'status': 'published',
        'publishedAt': DateTime.now().subtract(Duration(hours: 2)).toIso8601String(),
        'engagement': 245,
        'reach': 1250,
      },
      {
        'id': '2',
        'title': 'Behind the Scenes',
        'content': 'Take a look at our team working hard!',
        'platform': 'Facebook',
        'status': 'scheduled',
        'scheduledAt': DateTime.now().add(Duration(hours: 1)).toIso8601String(),
        'engagement': 0,
        'reach': 0,
      },
      {
        'id': '3',
        'title': 'Customer Success Story',
        'content': 'Amazing results from our client!',
        'platform': 'LinkedIn',
        'status': 'draft',
        'engagement': 0,
        'reach': 0,
      },
    ];
  }

  List<Map<String, dynamic>> _getMockContacts() {
    return [
      {
        'id': '1',
        'name': 'John Doe',
        'email': 'john@example.com',
        'phone': '+1234567890',
        'company': 'Tech Corp',
        'status': 'lead',
        'createdAt': DateTime.now().subtract(Duration(days: 5)).toIso8601String(),
        'value': 5000,
      },
      {
        'id': '2',
        'name': 'Jane Smith',
        'email': 'jane@example.com',
        'phone': '+1234567891',
        'company': 'Marketing Inc',
        'status': 'customer',
        'createdAt': DateTime.now().subtract(Duration(days: 10)).toIso8601String(),
        'value': 12000,
      },
      {
        'id': '3',
        'name': 'Bob Johnson',
        'email': 'bob@example.com',
        'phone': '+1234567892',
        'company': 'Sales LLC',
        'status': 'prospect',
        'createdAt': DateTime.now().subtract(Duration(days: 3)).toIso8601String(),
        'value': 8000,
      },
    ];
  }

  Map<String, dynamic> _getMockAnalyticsData() {
    return {
      'totalRevenue': 125000,
      'totalUsers': 2500,
      'conversionRate': 3.5,
      'averageOrderValue': 250,
      'topPerformingContent': [
        {'title': 'Product Launch', 'engagement': 1250, 'reach': 15000},
        {'title': 'Customer Story', 'engagement': 980, 'reach': 12000},
        {'title': 'Tutorial Video', 'engagement': 750, 'reach': 8500},
      ],
      'platformStats': {
        'instagram': {'followers': 12500, 'engagement': 4.2},
        'facebook': {'followers': 8500, 'engagement': 3.8},
        'linkedin': {'followers': 4500, 'engagement': 5.1},
      },
    };
  }

  List<Map<String, dynamic>> _getMockChartData(String chartType) {
    final random = Random();
    return List.generate(30, (index) => {
      'date': DateTime.now().subtract(Duration(days: 29 - index)).toIso8601String(),
      'value': 100 + random.nextInt(200),
      'label': 'Day ${index + 1}',
    });
  }

  List<Map<String, dynamic>> _getMockProducts() {
    return [
      {
        'id': '1',
        'name': 'Social Media Template Pack',
        'description': 'Complete set of social media templates',
        'price': 29.99,
        'category': 'Templates',
        'status': 'active',
        'sales': 245,
        'createdAt': DateTime.now().subtract(Duration(days: 15)).toIso8601String(),
      },
      {
        'id': '2',
        'name': 'Marketing Course',
        'description': 'Comprehensive digital marketing course',
        'price': 99.99,
        'category': 'Courses',
        'status': 'active',
        'sales': 89,
        'createdAt': DateTime.now().subtract(Duration(days: 25)).toIso8601String(),
      },
      {
        'id': '3',
        'name': 'Brand Guidelines Kit',
        'description': 'Professional brand guidelines template',
        'price': 49.99,
        'category': 'Templates',
        'status': 'active',
        'sales': 156,
        'createdAt': DateTime.now().subtract(Duration(days: 8)).toIso8601String(),
      },
    ];
  }

  List<Map<String, dynamic>> _getMockCourses() {
    return [
      {
        'id': '1',
        'title': 'Digital Marketing Fundamentals',
        'description': 'Learn the basics of digital marketing',
        'instructor': 'John Doe',
        'duration': '6 weeks',
        'price': 199.99,
        'students': 1250,
        'rating': 4.8,
        'status': 'published',
        'createdAt': DateTime.now().subtract(Duration(days: 30)).toIso8601String(),
      },
      {
        'id': '2',
        'title': 'Social Media Marketing Mastery',
        'description': 'Advanced social media marketing strategies',
        'instructor': 'Jane Smith',
        'duration': '8 weeks',
        'price': 299.99,
        'students': 890,
        'rating': 4.9,
        'status': 'published',
        'createdAt': DateTime.now().subtract(Duration(days: 45)).toIso8601String(),
      },
      {
        'id': '3',
        'title': 'Content Creation Workshop',
        'description': 'Create engaging content for your audience',
        'instructor': 'Bob Johnson',
        'duration': '4 weeks',
        'price': 149.99,
        'students': 567,
        'rating': 4.7,
        'status': 'draft',
        'createdAt': DateTime.now().subtract(Duration(days: 10)).toIso8601String(),
      },
    ];
  }

  List<Map<String, dynamic>> _getMockHashtagSuggestions(String query) {
    return [
      {'hashtag': '#${query}marketing', 'popularity': 950000, 'difficulty': 'medium'},
      {'hashtag': '#${query}business', 'popularity': 1200000, 'difficulty': 'high'},
      {'hashtag': '#${query}tips', 'popularity': 750000, 'difficulty': 'low'},
      {'hashtag': '#${query}strategy', 'popularity': 650000, 'difficulty': 'medium'},
      {'hashtag': '#${query}growth', 'popularity': 850000, 'difficulty': 'medium'},
    ];
  }

  List<Map<String, dynamic>> _getMockTrendingHashtags() {
    return [
      {'hashtag': '#digitalmarketing', 'popularity': 2500000, 'trend': 'up'},
      {'hashtag': '#socialmedia', 'popularity': 3200000, 'trend': 'up'},
      {'hashtag': '#contentmarketing', 'popularity': 1800000, 'trend': 'stable'},
      {'hashtag': '#entrepreneurship', 'popularity': 2100000, 'trend': 'up'},
      {'hashtag': '#businessgrowth', 'popularity': 1500000, 'trend': 'down'},
    ];
  }

  List<Map<String, dynamic>> _getMockTemplates(String category) {
    return [
      {
        'id': '1',
        'name': 'Instagram Story Template',
        'category': category,
        'description': 'Engaging story template for Instagram',
        'price': 9.99,
        'downloads': 1250,
        'rating': 4.8,
        'thumbnail': 'https://via.placeholder.com/300x300',
      },
      {
        'id': '2',
        'name': 'Facebook Post Template',
        'category': category,
        'description': 'Professional post template for Facebook',
        'price': 12.99,
        'downloads': 890,
        'rating': 4.6,
        'thumbnail': 'https://via.placeholder.com/300x300',
      },
      {
        'id': '3',
        'name': 'LinkedIn Article Template',
        'category': category,
        'description': 'Business article template for LinkedIn',
        'price': 15.99,
        'downloads': 567,
        'rating': 4.9,
        'thumbnail': 'https://via.placeholder.com/300x300',
      },
    ];
  }

  List<Map<String, dynamic>> _getMockEmailCampaigns() {
    return [
      {
        'id': '1',
        'name': 'Welcome Series',
        'subject': 'Welcome to Our Community!',
        'status': 'sent',
        'recipients': 1250,
        'openRate': 45.2,
        'clickRate': 12.8,
        'sentAt': DateTime.now().subtract(Duration(hours: 2)).toIso8601String(),
      },
      {
        'id': '2',
        'name': 'Product Launch',
        'subject': 'Exciting New Product Launch!',
        'status': 'scheduled',
        'recipients': 2500,
        'openRate': 0,
        'clickRate': 0,
        'scheduledAt': DateTime.now().add(Duration(hours: 24)).toIso8601String(),
      },
      {
        'id': '3',
        'name': 'Monthly Newsletter',
        'subject': 'Monthly Updates and Tips',
        'status': 'draft',
        'recipients': 0,
        'openRate': 0,
        'clickRate': 0,
      },
    ];
  }
}