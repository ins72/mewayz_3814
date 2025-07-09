import 'package:supabase_flutter/supabase_flutter.dart';

import '../core/app_export.dart';

enum WorkspaceGoal {
  socialMediaManagement,
  ecommerceBusiness,
  courseCreation,
  leadGeneration,
  allInOneBusiness,
}

enum MemberRole {
  owner,
  admin,
  manager,
  member,
  viewer,
}

enum InvitationStatus {
  pending,
  accepted,
  declined,
  expired,
}

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

  // Create workspace with goal-based features
  Future<Map<String, dynamic>?> createWorkspace({
    required String name,
    required String description,
    required WorkspaceGoal goal,
    String? logoUrl,
    Map<String, dynamic>? settings,
  }) async {
    try {
      await _ensureInitialized();
      
      final currentUser = _client.auth.currentUser;
      if (currentUser == null) {
        throw Exception('User must be authenticated to create workspace');
      }

      final goalString = _workspaceGoalToString(goal);
      
      final workspaceId = await _client.rpc('create_workspace_with_owner', params: {
        'workspace_name': name,
        'workspace_description': description,
        'workspace_goal': goalString,
        'owner_user_id': currentUser.id,
      });

      if (workspaceId != null) {
        // Update logo if provided
        if (logoUrl != null) {
          await _client.from('workspaces').update({
            'logo_url': logoUrl,
            'updated_at': DateTime.now().toIso8601String(),
          }).eq('id', workspaceId);
        }

        // Update settings if provided
        if (settings != null) {
          await _client.from('workspaces').update({
            'settings': settings,
            'updated_at': DateTime.now().toIso8601String(),
          }).eq('id', workspaceId);
        }

        // Get the created workspace
        final workspace = await getWorkspace(workspaceId);
        debugPrint('Workspace created successfully: $workspaceId');
        return workspace;
      }

      return null;
    } catch (e) {
      ErrorHandler.handleError('Failed to create workspace: $e');
      rethrow;
    }
  }

  // Get workspace by ID
  Future<Map<String, dynamic>?> getWorkspace(String workspaceId) async {
    try {
      await _ensureInitialized();
      
      final response = await _client
          .from('workspaces')
          .select('*, workspace_members!inner(*), workspace_features(*)')
          .eq('id', workspaceId)
          .single();

      return response;
    } catch (e) {
      ErrorHandler.handleError('Failed to get workspace: $e');
      return null;
    }
  }

  // Get user's workspaces
  Future<List<Map<String, dynamic>>> getUserWorkspaces() async {
    try {
      await _ensureInitialized();
      
      final currentUser = _client.auth.currentUser;
      if (currentUser == null) {
        throw Exception('User must be authenticated');
      }

      final response = await _client
          .from('workspaces')
          .select('*, workspace_members!inner(*)')
          .eq('workspace_members.user_id', currentUser.id)
          .eq('workspace_members.is_active', true)
          .order('created_at', ascending: false);

      return List<Map<String, dynamic>>.from(response);
    } catch (e) {
      ErrorHandler.handleError('Failed to get user workspaces: $e');
      return [];
    }
  }

  // Get workspace features
  Future<List<Map<String, dynamic>>> getWorkspaceFeatures(String workspaceId) async {
    try {
      await _ensureInitialized();
      
      final response = await _client
          .from('workspace_features')
          .select('*')
          .eq('workspace_id', workspaceId)
          .order('feature_key');

      return List<Map<String, dynamic>>.from(response);
    } catch (e) {
      ErrorHandler.handleError('Failed to get workspace features: $e');
      return [];
    }
  }

  // Send team invitation
  Future<String?> sendTeamInvitation({
    required String workspaceId,
    required String email,
    required MemberRole role,
    String? customMessage,
  }) async {
    try {
      await _ensureInitialized();
      
      final currentUser = _client.auth.currentUser;
      if (currentUser == null) {
        throw Exception('User must be authenticated');
      }

      final roleString = _memberRoleToString(role);
      
      final invitationId = await _client.rpc('send_team_invitation', params: {
        'workspace_uuid': workspaceId,
        'invitee_email': email,
        'invitee_role': roleString,
        'inviter_user_id': currentUser.id,
        'custom_message_text': customMessage,
      });

      debugPrint('Team invitation sent successfully: $invitationId');
      return invitationId;
    } catch (e) {
      ErrorHandler.handleError('Failed to send team invitation: $e');
      rethrow;
    }
  }

  // Send bulk team invitations
  Future<List<String>> sendBulkInvitations({
    required String workspaceId,
    required List<String> emails,
    required MemberRole role,
    String? customMessage,
  }) async {
    try {
      await _ensureInitialized();
      
      final invitationIds = <String>[];
      
      for (final email in emails) {
        try {
          final invitationId = await sendTeamInvitation(
            workspaceId: workspaceId,
            email: email,
            role: role,
            customMessage: customMessage,
          );
          if (invitationId != null) {
            invitationIds.add(invitationId);
          }
        } catch (e) {
          debugPrint('Failed to send invitation to $email: $e');
          // Continue with other invitations
        }
      }

      return invitationIds;
    } catch (e) {
      ErrorHandler.handleError('Failed to send bulk invitations: $e');
      return [];
    }
  }

  // Get workspace invitations
  Future<List<Map<String, dynamic>>> getWorkspaceInvitations(String workspaceId) async {
    try {
      await _ensureInitialized();
      
      final response = await _client
          .from('team_invitations')
          .select('*, workspace:workspaces(*), inviter:invited_by(*)')
          .eq('workspace_id', workspaceId)
          .order('created_at', ascending: false);

      return List<Map<String, dynamic>>.from(response);
    } catch (e) {
      ErrorHandler.handleError('Failed to get workspace invitations: $e');
      return [];
    }
  }

  // Accept team invitation
  Future<bool> acceptTeamInvitation(String invitationToken) async {
    try {
      await _ensureInitialized();
      
      final result = await _client.rpc('accept_team_invitation', params: {
        'invitation_token_param': invitationToken,
      });

      return result == true;
    } catch (e) {
      ErrorHandler.handleError('Failed to accept team invitation: $e');
      return false;
    }
  }

  // Get workspace members
  Future<List<Map<String, dynamic>>> getWorkspaceMembers(String workspaceId) async {
    try {
      await _ensureInitialized();
      
      final response = await _client
          .from('workspace_members')
          .select('*, user:user_profiles(*)')
          .eq('workspace_id', workspaceId)
          .eq('is_active', true)
          .order('joined_at', ascending: false);

      return List<Map<String, dynamic>>.from(response);
    } catch (e) {
      ErrorHandler.handleError('Failed to get workspace members: $e');
      return [];
    }
  }

  // Update workspace
  Future<bool> updateWorkspace(
    String workspaceId,
    Map<String, dynamic> updates,
  ) async {
    try {
      await _ensureInitialized();
      
      updates['updated_at'] = DateTime.now().toIso8601String();
      
      await _client
          .from('workspaces')
          .update(updates)
          .eq('id', workspaceId);

      return true;
    } catch (e) {
      ErrorHandler.handleError('Failed to update workspace: $e');
      return false;
    }
  }

  // Toggle workspace feature
  Future<bool> toggleWorkspaceFeature(
    String workspaceId,
    String featureKey,
    bool isEnabled,
  ) async {
    try {
      await _ensureInitialized();
      
      await _client
          .from('workspace_features')
          .update({
            'is_enabled': isEnabled,
            'enabled_at': isEnabled ? DateTime.now().toIso8601String() : null,
          })
          .eq('workspace_id', workspaceId)
          .eq('feature_key', featureKey);

      return true;
    } catch (e) {
      ErrorHandler.handleError('Failed to toggle workspace feature: $e');
      return false;
    }
  }

  // Get goal-specific role suggestions
  List<Map<String, dynamic>> getGoalBasedRoleSuggestions(WorkspaceGoal goal) {
    switch (goal) {
      case WorkspaceGoal.socialMediaManagement:
        return [
          {
            'role': MemberRole.manager,
            'title': 'Social Media Manager',
            'description': 'Manages overall social media strategy and content calendar',
            'permissions': ['can_view', 'can_edit', 'can_invite'],
          },
          {
            'role': MemberRole.member,
            'title': 'Content Creator',
            'description': 'Creates and schedules social media content',
            'permissions': ['can_view', 'can_edit'],
          },
          {
            'role': MemberRole.member,
            'title': 'Analytics Specialist',
            'description': 'Analyzes social media performance and provides insights',
            'permissions': ['can_view'],
          },
        ];
      case WorkspaceGoal.ecommerceBusiness:
        return [
          {
            'role': MemberRole.manager,
            'title': 'Store Manager',
            'description': 'Manages product catalog and inventory',
            'permissions': ['can_view', 'can_edit', 'can_invite'],
          },
          {
            'role': MemberRole.member,
            'title': 'Customer Service',
            'description': 'Handles customer inquiries and support',
            'permissions': ['can_view', 'can_edit'],
          },
          {
            'role': MemberRole.member,
            'title': 'Marketing Specialist',
            'description': 'Manages marketing campaigns and promotions',
            'permissions': ['can_view', 'can_edit'],
          },
        ];
      case WorkspaceGoal.courseCreation:
        return [
          {
            'role': MemberRole.admin,
            'title': 'Lead Instructor',
            'description': 'Creates and manages course content',
            'permissions': ['can_view', 'can_edit', 'can_invite', 'can_manage'],
          },
          {
            'role': MemberRole.member,
            'title': 'Course Designer',
            'description': 'Designs course structure and learning materials',
            'permissions': ['can_view', 'can_edit'],
          },
          {
            'role': MemberRole.member,
            'title': 'Student Success Manager',
            'description': 'Supports students and tracks their progress',
            'permissions': ['can_view'],
          },
        ];
      case WorkspaceGoal.leadGeneration:
        return [
          {
            'role': MemberRole.manager,
            'title': 'Lead Generation Manager',
            'description': 'Oversees lead generation campaigns and strategies',
            'permissions': ['can_view', 'can_edit', 'can_invite'],
          },
          {
            'role': MemberRole.member,
            'title': 'Sales Representative',
            'description': 'Follows up with leads and converts them to customers',
            'permissions': ['can_view', 'can_edit'],
          },
          {
            'role': MemberRole.member,
            'title': 'Marketing Specialist',
            'description': 'Creates and manages lead generation campaigns',
            'permissions': ['can_view', 'can_edit'],
          },
        ];
      case WorkspaceGoal.allInOneBusiness:
        return [
          {
            'role': MemberRole.admin,
            'title': 'Business Manager',
            'description': 'Oversees all business operations and strategy',
            'permissions': ['can_view', 'can_edit', 'can_invite', 'can_manage'],
          },
          {
            'role': MemberRole.manager,
            'title': 'Operations Manager',
            'description': 'Manages day-to-day business operations',
            'permissions': ['can_view', 'can_edit', 'can_invite'],
          },
          {
            'role': MemberRole.member,
            'title': 'Marketing Specialist',
            'description': 'Handles marketing and customer outreach',
            'permissions': ['can_view', 'can_edit'],
          },
        ];
    }
  }

  // Helper methods
  Future<void> _ensureInitialized() async {
    if (!_isInitialized) {
      await initialize();
    }
  }

  String _workspaceGoalToString(WorkspaceGoal goal) {
    switch (goal) {
      case WorkspaceGoal.socialMediaManagement:
        return 'social_media_management';
      case WorkspaceGoal.ecommerceBusiness:
        return 'ecommerce_business';
      case WorkspaceGoal.courseCreation:
        return 'course_creation';
      case WorkspaceGoal.leadGeneration:
        return 'lead_generation';
      case WorkspaceGoal.allInOneBusiness:
        return 'all_in_one_business';
    }
  }

  String _memberRoleToString(MemberRole role) {
    switch (role) {
      case MemberRole.owner:
        return 'owner';
      case MemberRole.admin:
        return 'admin';
      case MemberRole.manager:
        return 'manager';
      case MemberRole.member:
        return 'member';
      case MemberRole.viewer:
        return 'viewer';
    }
  }

  WorkspaceGoal _stringToWorkspaceGoal(String goalString) {
    switch (goalString) {
      case 'social_media_management':
        return WorkspaceGoal.socialMediaManagement;
      case 'ecommerce_business':
        return WorkspaceGoal.ecommerceBusiness;
      case 'course_creation':
        return WorkspaceGoal.courseCreation;
      case 'lead_generation':
        return WorkspaceGoal.leadGeneration;
      case 'all_in_one_business':
        return WorkspaceGoal.allInOneBusiness;
      default:
        return WorkspaceGoal.allInOneBusiness;
    }
  }

  MemberRole _stringToMemberRole(String roleString) {
    switch (roleString) {
      case 'owner':
        return MemberRole.owner;
      case 'admin':
        return MemberRole.admin;
      case 'manager':
        return MemberRole.manager;
      case 'member':
        return MemberRole.member;
      case 'viewer':
        return MemberRole.viewer;
      default:
        return MemberRole.member;
    }
  }
}