import '../core/supabase_service.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class DynamicDataService {
  static final DynamicDataService _instance = DynamicDataService._internal();
  
  factory DynamicDataService() {
    return _instance;
  }
  
  DynamicDataService._internal();

  Future<SupabaseClient> get _client async {
    return await SupabaseService.instance.client;
  }

  // Fetch Workspaces - Method to get user's workspaces
  Future<List<Map<String, dynamic>>> fetchWorkspaces() async {
    try {
      final client = await _client;
      final response = await client
          .from('workspaces')
          .select('id, name, description, created_at, workspace_members!inner(user_id, role)')
          .eq('workspace_members.user_id', client.auth.currentUser?.id ?? '')
          .order('created_at', ascending: false);
      
      return List<Map<String, dynamic>>.from(response ?? []);
    } catch (error) {
      print('Error fetching workspaces: $error');
      return _getDefaultWorkspacesList();
    }
  }

  // Fetch Workspace Dashboard Analytics - Method to get dashboard analytics for a workspace
  Future<Map<String, dynamic>> fetchWorkspaceDashboardAnalytics(String workspaceId) async {
    try {
      final client = await _client;
      final response = await client.rpc('get_workspace_dashboard_analytics', 
        params: {'workspace_uuid': workspaceId});
      
      if (response != null) {
        return Map<String, dynamic>.from(response);
      }
      return _getDefaultAnalyticsData();
    } catch (error) {
      print('Error fetching workspace dashboard analytics: $error');
      return _getDefaultAnalyticsData();
    }
  }

  // Premium Social Media Hub Data
  Future<Map<String, dynamic>> getSocialMediaHubData(String workspaceId) async {
    try {
      final client = await _client;
      final response = await client.rpc('get_social_media_hub_data', 
        params: {'workspace_uuid': workspaceId});
      
      if (response != null) {
        return Map<String, dynamic>.from(response);
      }
      return _getDefaultSocialMediaData();
    } catch (error) {
      print('Error fetching social media hub data: $error');
      return _getDefaultSocialMediaData();
    }
  }

  // Default fallback data methods
  List<Map<String, dynamic>> _getDefaultWorkspacesList() {
    return [
      {
        'id': 'default-workspace-id',
        'name': 'Default Workspace',
        'description': 'Your default workspace',
        'created_at': DateTime.now().toIso8601String(),
      }
    ];
  }

  Map<String, dynamic> _getDefaultSocialMediaData() {
    return {
      'posts': [],
      'analytics': {
        'total_posts': 0,
        'total_engagement': 0,
        'total_reach': 0,
        'avg_engagement_rate': 0
      },
      'trending_hashtags': [],
      'generated_at': DateTime.now().toIso8601String(),
    };
  }

  Map<String, dynamic> _getDefaultAnalyticsData() {
    return {
      'hero_metrics': {
        'total_leads': 0,
        'revenue': 0,
        'social_followers': 0,
        'course_enrollments': 0,
        'conversion_rate': 0
      },
      'recent_activities': [],
      'team_stats': {
        'total_members': 0,
        'active_members': 0,
        'pending_invitations': 0
      },
      'generated_at': DateTime.now().toIso8601String(),
    };
  }
}