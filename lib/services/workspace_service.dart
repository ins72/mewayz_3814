import 'package:supabase_flutter/supabase_flutter.dart';

import '../core/app_export.dart';

class WorkspaceService {
  static final WorkspaceService _instance = WorkspaceService._internal();
  late final SupabaseClient _client;
  bool _isInitialized = false;

  factory WorkspaceService() {
    return _instance;
  }

  WorkspaceService._internal();

  Future<void> initialize() async {
    if (_isInitialized) return;
    
    try {
      final supabaseService = SupabaseService();
      _client = await supabaseService.client;
      _isInitialized = true;
      debugPrint('WorkspaceService initialized successfully');
    } catch (e) {
      ErrorHandler.handleError('Failed to initialize WorkspaceService: $e');
      rethrow;
    }
  }

  Future<void> _ensureInitialized() async {
    if (!_isInitialized) {
      await initialize();
    }
  }

  /// Check if user has any workspace
  Future<bool> hasUserWorkspace() async {
    try {
      await _ensureInitialized();
      
      final authService = AuthService();
      final userId = authService.currentUser?.id;
      
      if (userId == null) {
        return false;
      }

      final response = await _client
          .from('workspace_members')
          .select('id')
          .eq('user_id', userId)
          .eq('is_active', true)
          .limit(1);

      return response.isNotEmpty;
    } catch (e) {
      ErrorHandler.handleError('Failed to check user workspace: $e');
      return false;
    }
  }

  /// Get user's workspaces
  Future<List<Map<String, dynamic>>> getUserWorkspaces() async {
    try {
      await _ensureInitialized();
      
      final authService = AuthService();
      final userId = authService.currentUser?.id;
      
      if (userId == null) {
        throw Exception('User not authenticated');
      }

      final response = await _client
          .from('workspace_members')
          .select('''
            workspace_id,
            role,
            joined_at,
            workspaces (
              id,
              name,
              description,
              goal,
              status,
              logo_url,
              created_at,
              owner_id,
              user_profiles!workspaces_owner_id_fkey (
                full_name,
                email
              )
            )
          ''')
          .eq('user_id', userId)
          .eq('is_active', true)
          .order('joined_at', ascending: false);

      return response.map((item) => {
        'workspace_id': item['workspace_id'],
        'role': item['role'],
        'joined_at': item['joined_at'],
        'workspace': item['workspaces'],
      }).toList();
    } catch (e) {
      ErrorHandler.handleError('Failed to get user workspaces: $e');
      return [];
    }
  }

  /// Create a new workspace
  Future<Map<String, dynamic>?> createWorkspace({
    required String name,
    required String description,
    required String goal,
    String? customGoalDescription,
  }) async {
    try {
      await _ensureInitialized();
      
      final authService = AuthService();
      final userId = authService.currentUser?.id;
      
      if (userId == null) {
        throw Exception('User not authenticated');
      }

      final response = await _client.rpc('create_workspace', params: {
        'workspace_name': name,
        'workspace_description': description,
        'workspace_goal': goal,
        'custom_goal_desc': customGoalDescription,
        'owner_uuid': userId,
      });

      if (response != null) {
        // Get the created workspace details
        final workspaceDetails = await _client
            .from('workspaces')
            .select('*')
            .eq('id', response)
            .single();

        return workspaceDetails;
      }
      
      return null;
    } catch (e) {
      ErrorHandler.handleError('Failed to create workspace: $e');
      return null;
    }
  }

  /// Get workspace by ID
  Future<Map<String, dynamic>?> getWorkspaceById(String workspaceId) async {
    try {
      await _ensureInitialized();

      final response = await _client
          .from('workspaces')
          .select('''
            *,
            user_profiles!workspaces_owner_id_fkey (
              full_name,
              email,
              avatar_url
            )
          ''')
          .eq('id', workspaceId)
          .single();

      return response;
    } catch (e) {
      ErrorHandler.handleError('Failed to get workspace: $e');
      return null;
    }
  }

  /// Get workspace members
  Future<List<Map<String, dynamic>>> getWorkspaceMembers(String workspaceId) async {
    try {
      await _ensureInitialized();

      final response = await _client
          .from('workspace_members')
          .select('''
            *,
            user_profiles!workspace_members_user_id_fkey (
              full_name,
              email,
              avatar_url
            ),
            invited_by_profile:user_profiles!workspace_members_invited_by_fkey (
              full_name,
              email
            )
          ''')
          .eq('workspace_id', workspaceId)
          .eq('is_active', true)
          .order('joined_at', ascending: false);

      return response;
    } catch (e) {
      ErrorHandler.handleError('Failed to get workspace members: $e');
      return [];
    }
  }

  /// Invite member to workspace
  Future<bool> inviteMemberToWorkspace({
    required String workspaceId,
    required String email,
    required String role,
    String? message,
  }) async {
    try {
      await _ensureInitialized();
      
      final authService = AuthService();
      final userId = authService.currentUser?.id;
      
      if (userId == null) {
        throw Exception('User not authenticated');
      }

      final response = await _client.rpc('invite_workspace_member', params: {
        'workspace_uuid': workspaceId,
        'member_email': email,
        'member_role': role,
        'invitation_message': message,
        'inviter_uuid': userId,
      });

      return response != null;
    } catch (e) {
      ErrorHandler.handleError('Failed to invite member: $e');
      return false;
    }
  }

  /// Get workspace analytics/metrics
  Future<Map<String, dynamic>> getWorkspaceMetrics(String workspaceId) async {
    try {
      await _ensureInitialized();

      final response = await _client.rpc('get_workspace_dashboard_metrics', params: {
        'workspace_uuid': workspaceId,
      });

      return response ?? {};
    } catch (e) {
      ErrorHandler.handleError('Failed to get workspace metrics: $e');
      return {};
    }
  }

  /// Update workspace
  Future<bool> updateWorkspace({
    required String workspaceId,
    String? name,
    String? description,
    String? logoUrl,
    Map<String, dynamic>? themeSettings,
    Map<String, dynamic>? featuresEnabled,
  }) async {
    try {
      await _ensureInitialized();

      final updateData = <String, dynamic>{};
      if (name != null) updateData['name'] = name;
      if (description != null) updateData['description'] = description;
      if (logoUrl != null) updateData['logo_url'] = logoUrl;
      if (themeSettings != null) updateData['theme_settings'] = themeSettings;
      if (featuresEnabled != null) updateData['features_enabled'] = featuresEnabled;
      
      updateData['updated_at'] = DateTime.now().toIso8601String();

      await _client
          .from('workspaces')
          .update(updateData)
          .eq('id', workspaceId);

      return true;
    } catch (e) {
      ErrorHandler.handleError('Failed to update workspace: $e');
      return false;
    }
  }

  /// Delete workspace
  Future<bool> deleteWorkspace(String workspaceId) async {
    try {
      await _ensureInitialized();

      await _client
          .from('workspaces')
          .delete()
          .eq('id', workspaceId);

      return true;
    } catch (e) {
      ErrorHandler.handleError('Failed to delete workspace: $e');
      return false;
    }
  }

  /// Leave workspace
  Future<bool> leaveWorkspace(String workspaceId) async {
    try {
      await _ensureInitialized();
      
      final authService = AuthService();
      final userId = authService.currentUser?.id;
      
      if (userId == null) {
        throw Exception('User not authenticated');
      }

      await _client
          .from('workspace_members')
          .update({'is_active': false})
          .eq('workspace_id', workspaceId)
          .eq('user_id', userId);

      return true;
    } catch (e) {
      ErrorHandler.handleError('Failed to leave workspace: $e');
      return false;
    }
  }

  /// Get workspace invitations
  Future<List<Map<String, dynamic>>> getWorkspaceInvitations(String workspaceId) async {
    try {
      await _ensureInitialized();

      final response = await _client
          .from('workspace_invitations')
          .select('''
            *,
            invited_by_profile:user_profiles!workspace_invitations_invited_by_fkey (
              full_name,
              email
            )
          ''')
          .eq('workspace_id', workspaceId)
          .order('created_at', ascending: false);

      return response;
    } catch (e) {
      ErrorHandler.handleError('Failed to get workspace invitations: $e');
      return [];
    }
  }

  /// Accept workspace invitation
  Future<bool> acceptInvitation(String invitationToken) async {
    try {
      await _ensureInitialized();
      
      final authService = AuthService();
      final userId = authService.currentUser?.id;
      
      if (userId == null) {
        throw Exception('User not authenticated');
      }

      final response = await _client.rpc('accept_workspace_invitation', params: {
        'invitation_token': invitationToken,
        'accepting_user_uuid': userId,
      });

      return response == true;
    } catch (e) {
      ErrorHandler.handleError('Failed to accept invitation: $e');
      return false;
    }
  }

  /// Check if user can manage workspace
  Future<bool> canManageWorkspace(String workspaceId) async {
    try {
      await _ensureInitialized();
      
      final authService = AuthService();
      final userId = authService.currentUser?.id;
      
      if (userId == null) {
        return false;
      }

      final response = await _client
          .from('workspace_members')
          .select('role')
          .eq('workspace_id', workspaceId)
          .eq('user_id', userId)
          .eq('is_active', true)
          .single();

      final role = response['role'];
      return role == 'owner' || role == 'admin';
    } catch (e) {
      return false;
    }
  }

  /// Get user's role in workspace
  Future<String?> getUserRoleInWorkspace(String workspaceId) async {
    try {
      await _ensureInitialized();
      
      final authService = AuthService();
      final userId = authService.currentUser?.id;
      
      if (userId == null) {
        return null;
      }

      final response = await _client
          .from('workspace_members')
          .select('role')
          .eq('workspace_id', workspaceId)
          .eq('user_id', userId)
          .eq('is_active', true)
          .single();

      return response['role'];
    } catch (e) {
      return null;
    }
  }
}