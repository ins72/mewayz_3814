import 'package:supabase_flutter/supabase_flutter.dart';

import '../core/app_export.dart';
import '../core/environment_config.dart';

class LinkInBioService {
  static final LinkInBioService _instance = LinkInBioService._internal();
  factory LinkInBioService() => _instance;
  LinkInBioService._internal();

  late final SupabaseClient _client;
  bool _isInitialized = false;

  Future<void> _ensureInitialized() async {
    if (!_isInitialized) {
      _client = await SupabaseService.instance.client;
      _isInitialized = true;
    }
  }

  // Link Pages Management
  Future<List<Map<String, dynamic>>> getUserLinkPages(String userId) async {
    await _ensureInitialized();
    try {
      final response = await _client
          .from('link_pages')
          .select('*, custom_domains(*)')
          .eq('user_id', userId)
          .order('created_at', ascending: false);
      return List<Map<String, dynamic>>.from(response);
    } catch (error) {
      throw Exception('Failed to fetch link pages: $error');
    }
  }

  Future<Map<String, dynamic>?> getLinkPageBySlug(String slug) async {
    await _ensureInitialized();
    try {
      final response = await _client
          .from('link_pages')
          .select('*, page_components(*), custom_domains(*)')
          .eq('slug', slug)
          .eq('status', 'published')
          .single();
      return response;
    } catch (error) {
      return null;
    }
  }

  Future<Map<String, dynamic>> createLinkPage({
    required String userId,
    required String title,
    required String slug,
    String? description,
    Map<String, dynamic>? themeSettings,
    Map<String, dynamic>? seoSettings,
  }) async {
    await _ensureInitialized();
    try {
      final response = await _client
          .from('link_pages')
          .insert({
            'user_id': userId,
            'title': title,
            'slug': slug,
            'description': description ?? '',
            'theme_settings': themeSettings ?? {},
            'seo_settings': seoSettings ?? {},
            'status': 'draft',
          })
          .select()
          .single();
      return response;
    } catch (error) {
      throw Exception('Failed to create link page: $error');
    }
  }

  Future<Map<String, dynamic>> updateLinkPage({
    required String pageId,
    String? title,
    String? description,
    String? slug,
    String? status,
    Map<String, dynamic>? themeSettings,
    Map<String, dynamic>? seoSettings,
    String? customCss,
    String? customJs,
  }) async {
    await _ensureInitialized();
    try {
      final updateData = <String, dynamic>{};
      if (title != null) updateData['title'] = title;
      if (description != null) updateData['description'] = description;
      if (slug != null) updateData['slug'] = slug;
      if (status != null) updateData['status'] = status;
      if (themeSettings != null) updateData['theme_settings'] = themeSettings;
      if (seoSettings != null) updateData['seo_settings'] = seoSettings;
      if (customCss != null) updateData['custom_css'] = customCss;
      if (customJs != null) updateData['custom_js'] = customJs;

      final response = await _client
          .from('link_pages')
          .update(updateData)
          .eq('id', pageId)
          .select()
          .single();
      return response;
    } catch (error) {
      throw Exception('Failed to update link page: $error');
    }
  }

  Future<void> deleteLinkPage(String pageId) async {
    await _ensureInitialized();
    try {
      await _client.from('link_pages').delete().eq('id', pageId);
    } catch (error) {
      throw Exception('Failed to delete link page: $error');
    }
  }

  // Page Components Management
  Future<List<Map<String, dynamic>>> getPageComponents(String pageId) async {
    await _ensureInitialized();
    try {
      final response = await _client
          .from('page_components')
          .select()
          .eq('link_page_id', pageId)
          .order('position_order', ascending: true);
      return List<Map<String, dynamic>>.from(response);
    } catch (error) {
      throw Exception('Failed to fetch page components: $error');
    }
  }

  Future<Map<String, dynamic>> createPageComponent({
    required String linkPageId,
    required String componentType,
    required Map<String, dynamic> componentData,
    required int positionOrder,
    Map<String, dynamic>? styleSettings,
  }) async {
    await _ensureInitialized();
    try {
      final response = await _client
          .from('page_components')
          .insert({
            'link_page_id': linkPageId,
            'component_type': componentType,
            'component_data': componentData,
            'position_order': positionOrder,
            'style_settings': styleSettings ?? {},
            'is_visible': true,
          })
          .select()
          .single();
      return response;
    } catch (error) {
      throw Exception('Failed to create component: $error');
    }
  }

  Future<Map<String, dynamic>> updatePageComponent({
    required String componentId,
    Map<String, dynamic>? componentData,
    Map<String, dynamic>? styleSettings,
    bool? isVisible,
    int? positionOrder,
  }) async {
    await _ensureInitialized();
    try {
      final updateData = <String, dynamic>{};
      if (componentData != null) updateData['component_data'] = componentData;
      if (styleSettings != null) updateData['style_settings'] = styleSettings;
      if (isVisible != null) updateData['is_visible'] = isVisible;
      if (positionOrder != null) updateData['position_order'] = positionOrder;

      final response = await _client
          .from('page_components')
          .update(updateData)
          .eq('id', componentId)
          .select()
          .single();
      return response;
    } catch (error) {
      throw Exception('Failed to update component: $error');
    }
  }

  Future<void> deletePageComponent(String componentId) async {
    await _ensureInitialized();
    try {
      await _client.from('page_components').delete().eq('id', componentId);
    } catch (error) {
      throw Exception('Failed to delete component: $error');
    }
  }

  Future<void> reorderComponents(String linkPageId, List<Map<String, dynamic>> components) async {
    await _ensureInitialized();
    try {
      final updates = <Future>[];
      for (int i = 0; i < components.length; i++) {
        updates.add(
          _client
              .from('page_components')
              .update({'position_order': i + 1})
              .eq('id', components[i]['id'])
        );
      }
      await Future.wait(updates);
    } catch (error) {
      throw Exception('Failed to reorder components: $error');
    }
  }

  // Custom Domains Management
  Future<List<Map<String, dynamic>>> getUserCustomDomains(String userId) async {
    await _ensureInitialized();
    try {
      final response = await _client
          .from('custom_domains')
          .select('*, link_pages(title, slug)')
          .eq('user_id', userId)
          .order('created_at', ascending: false);
      return List<Map<String, dynamic>>.from(response);
    } catch (error) {
      throw Exception('Failed to fetch custom domains: $error');
    }
  }

  Future<Map<String, dynamic>> addCustomDomain({
    required String userId,
    required String linkPageId,
    required String domainName,
  }) async {
    await _ensureInitialized();
    try {
      final response = await _client
          .from('custom_domains')
          .insert({
            'user_id': userId,
            'link_page_id': linkPageId,
            'domain_name': domainName.toLowerCase(),
            'status': 'pending',
            'verification_token': _generateVerificationToken(),
          })
          .select()
          .single();
      return response;
    } catch (error) {
      throw Exception('Failed to add custom domain: $error');
    }
  }

  Future<Map<String, dynamic>?> verifyCustomDomain(String domainId) async {
    await _ensureInitialized();
    try {
      // In a real implementation, this would perform DNS verification
      final response = await _client
          .from('custom_domains')
          .update({
            'status': 'verified',
            'last_verified_at': DateTime.now().toIso8601String(),
          })
          .eq('id', domainId)
          .select()
          .single();
      return response;
    } catch (error) {
      throw Exception('Failed to verify domain: $error');
    }
  }

  Future<void> deleteCustomDomain(String domainId) async {
    await _ensureInitialized();
    try {
      await _client.from('custom_domains').delete().eq('id', domainId);
    } catch (error) {
      throw Exception('Failed to delete custom domain: $error');
    }
  }

  // Analytics
  Future<void> trackPageView({
    required String linkPageId,
    String? componentId,
    String? visitorIp,
    String? userAgent,
    String? referrer,
    String? countryCode,
    String? city,
    String? deviceType,
    String? sessionId,
  }) async {
    await _ensureInitialized();
    try {
      await _client.from('link_analytics').insert({
        'link_page_id': linkPageId,
        'component_id': componentId,
        'visitor_ip': visitorIp,
        'user_agent': userAgent,
        'referrer': referrer,
        'country_code': countryCode,
        'city': city,
        'device_type': deviceType,
        'session_id': sessionId,
      });
    } catch (error) {
      // Analytics failures should not break the user experience
      debugPrint('Analytics tracking failed: $error');
    }
  }

  Future<Map<String, dynamic>> getPageAnalytics(String linkPageId, {
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    await _ensureInitialized();
    try {
      var query = _client
          .from('link_analytics')
          .select('*, page_components(component_type)')
          .eq('link_page_id', linkPageId);

      if (startDate != null) {
        query = query.gte('click_timestamp', startDate.toIso8601String());
      }
      if (endDate != null) {
        query = query.lte('click_timestamp', endDate.toIso8601String());
      }

      final response = await query.order('click_timestamp', ascending: false);
      
      return {
        'analytics': response,
        'total_clicks': response.length,
        'unique_visitors': _countUniqueVisitors(response),
        'top_countries': _getTopCountries(response),
        'device_breakdown': _getDeviceBreakdown(response),
      };
    } catch (error) {
      throw Exception('Failed to fetch analytics: $error');
    }
  }

  // Domain URL Generation
  String generatePageUrl(String slug, [String? customDomain]) {
    if (customDomain != null && customDomain.isNotEmpty) {
      return 'https://$customDomain';
    }
    // Use a property that exists in EnvironmentConfig
    final globalDomain = EnvironmentConfig.baseUrl;
    return 'https://$globalDomain/$slug';
  }

  String generateQRCodeUrl(String slug, [String? customDomain]) {
    final pageUrl = generatePageUrl(slug, customDomain);
    return 'https://api.qrserver.com/v1/create-qr-code/?size=400x400&data=${Uri.encodeComponent(pageUrl)}';
  }

  // Helper Methods
  String _generateVerificationToken() {
    const chars = 'abcdefghijklmnopqrstuvwxyz0123456789';
    final random = Random();
    return List.generate(32, (index) => chars[random.nextInt(chars.length)]).join();
  }

  int _countUniqueVisitors(List<dynamic> analytics) {
    final uniqueIps = <String>{};
    for (final record in analytics) {
      final ip = record['visitor_ip'] as String?;
      if (ip != null) uniqueIps.add(ip);
    }
    return uniqueIps.length;
  }

  Map<String, int> _getTopCountries(List<dynamic> analytics) {
    final countries = <String, int>{};
    for (final record in analytics) {
      final country = record['country_code'] as String? ?? 'Unknown';
      countries[country] = (countries[country] ?? 0) + 1;
    }
    return Map.fromEntries(
      countries.entries.toList()..sort((a, b) => b.value.compareTo(a.value))
    );
  }

  Map<String, int> _getDeviceBreakdown(List<dynamic> analytics) {
    final devices = <String, int>{};
    for (final record in analytics) {
      final device = record['device_type'] as String? ?? 'Unknown';
      devices[device] = (devices[device] ?? 0) + 1;
    }
    return devices;
  }
}