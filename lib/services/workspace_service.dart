import 'dart:async';

import 'package:supabase_flutter/supabase_flutter.dart';

import '../core/app_export.dart';

class WorkspaceService {
  static final WorkspaceService _instance = WorkspaceService._internal();
  late final SupabaseClient _client;
  bool _isInitialized = false;
  Timer? _cacheTimer;
  final Map<String, dynamic> _cache = {};
  static const Duration _cacheExpiry = Duration(minutes: 5);

  factory WorkspaceService() {
    return _instance;
  }

  WorkspaceService._internal();

  Future<void> initialize() async {
    if (_isInitialized) return;
    
    try {
      final supabaseService = SupabaseService.instance;
      _client = await supabaseService.client;
      _isInitialized = true;
      _startCacheCleanup();
      debugPrint('WorkspaceService initialized successfully');
    } catch (e) {
      ErrorHandler.handleError('Failed to initialize WorkspaceService: $e');
      rethrow;
    }
  }

  void _startCacheCleanup() {
    _cacheTimer?.cancel();
    _cacheTimer = Timer.periodic(_cacheExpiry, (_) {
      _clearExpiredCache();
    });
  }

  void _clearExpiredCache() {
    final now = DateTime.now();
    final keysToRemove = <String>[];
    
    for (final entry in _cache.entries) {
      if (entry.value is Map && entry.value['timestamp'] != null) {
        final timestamp = DateTime.parse(entry.value['timestamp']);
        if (now.difference(timestamp) > _cacheExpiry) {
          keysToRemove.add(entry.key);
        }
      }
    }
    
    for (final key in keysToRemove) {
      _cache.remove(key);
    }
  }

  Future<void> _ensureInitialized() async {
    if (!_isInitialized) {
      await initialize();
    }
  }

  T? _getCachedData<T>(String key) {
    final cached = _cache[key];
    if (cached != null && cached is Map && cached['data'] != null) {
      final timestamp = DateTime.parse(cached['timestamp']);
      if (DateTime.now().difference(timestamp) < _cacheExpiry) {
        return cached['data'] as T;
      }
    }
    return null;
  }

  void _setCachedData<T>(String key, T data) {
    _cache[key] = {
      'data': data,
      'timestamp': DateTime.now().toIso8601String(),
    };
  }

  /// Enhanced operation execution with timeout and retry
  Future<T> _executeWithRetry<T>(
    String operationName,
    Future<T> Function() operation, {
    int maxRetries = 2,
    Duration timeout = const Duration(seconds: 15),
  }) async {
    Exception? lastException;
    
    for (int attempt = 0; attempt <= maxRetries; attempt++) {
      try {
        return await operation().timeout(timeout);
      } on TimeoutException {
        lastException = Exception('$operationName timed out after ${timeout.inSeconds} seconds');
      } catch (e) {
        lastException = e is Exception ? e : Exception(e.toString());
        
        if (attempt < maxRetries) {
          debugPrint('$operationName attempt ${attempt + 1} failed: $e, retrying...');
          await Future.delayed(Duration(seconds: attempt + 1));
        }
      }
    }
    
    throw lastException ?? Exception('$operationName failed after ${maxRetries + 1} attempts');
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

      // Check cache first
      final cacheKey = 'has_workspace_$userId';
      final cached = _getCachedData<bool>(cacheKey);
      if (cached != null) {
        return cached;
      }

      final result = await _executeWithRetry(
        'check user workspace',
        () async {
          final response = await _client
              .from('workspace_members')
              .select('id')
              .eq('user_id', userId)
              .eq('is_active', true)
              .limit(1);

          return response.isNotEmpty;
        },
      );

      _setCachedData(cacheKey, result);
      return result;
    } catch (e) {
      ErrorHandler.handleError('Failed to check user workspace: $e');
      return false;
    }
  }

  /// Get user's workspaces with enhanced error handling
  Future<List<Map<String, dynamic>>> getUserWorkspaces() async {
    try {
      await _ensureInitialized();
      
      final authService = AuthService();
      final userId = authService.currentUser?.id;
      
      if (userId == null) {
        throw Exception('User not authenticated');
      }

      // Check cache first
      final cacheKey = 'user_workspaces_$userId';
      final cached = _getCachedData<List<Map<String, dynamic>>>(cacheKey);
      if (cached != null) {
        return cached;
      }

      final result = await _executeWithRetry(
        'get user workspaces',
        () async {
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
            'id': item['workspace_id'], // Add id field for compatibility
            'role': item['role'],
            'joined_at': item['joined_at'],
            'workspace': item['workspaces'],
            // Flatten workspace data for easier access
            'name': item['workspaces']?['name'],
            'description': item['workspaces']?['description'],
            'goal': item['workspaces']?['goal'],
            'status': item['workspaces']?['status'],
            'logo_url': item['workspaces']?['logo_url'],
          }).toList().cast<Map<String, dynamic>>();
        },
      );

      _setCachedData(cacheKey, result);
      return result;
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

      final result = await _executeWithRetry(
        'create workspace',
        () async {
          final response = await _client.rpc('create_workspace', params: {
            'workspace_name': name,
            'workspace_description': description,
            'workspace_goal': goal,
            'custom_goal_desc': customGoalDescription,
            'owner_uuid': userId,
          });

          if (response != null) {
            // Clear cache
            _cache.removeWhere((key, _) => key.contains('workspace') || key.contains(userId));
            
            // Get the created workspace details
            final workspaceDetails = await _client
                .from('workspaces')
                .select('*')
                .eq('id', response)
                .single();

            return workspaceDetails;
          }
          
          return null;
        },
      );

      return result;
    } catch (e) {
      ErrorHandler.handleError('Failed to create workspace: $e');
      return null;
    }
  }

  /// Get workspace by ID
  Future<Map<String, dynamic>?> getWorkspaceById(String workspaceId) async {
    try {
      await _ensureInitialized();

      // Check cache first
      final cacheKey = 'workspace_$workspaceId';
      final cached = _getCachedData<Map<String, dynamic>>(cacheKey);
      if (cached != null) {
        return cached;
      }

      final result = await _executeWithRetry(
        'get workspace by id',
        () async {
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
        },
      );

      _setCachedData(cacheKey, result);
      return result;
    } catch (e) {
      ErrorHandler.handleError('Failed to get workspace: $e');
      return null;
    }
  }

  /// Get workspace members
  Future<List<Map<String, dynamic>>> getWorkspaceMembers(String workspaceId) async {
    try {
      await _ensureInitialized();

      // Check cache first
      final cacheKey = 'workspace_members_$workspaceId';
      final cached = _getCachedData<List<Map<String, dynamic>>>(cacheKey);
      if (cached != null) {
        return cached;
      }

      final result = await _executeWithRetry(
        'get workspace members',
        () async {
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

          return response.cast<Map<String, dynamic>>();
        },
      );

      _setCachedData(cacheKey, result);
      return result;
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

      final result = await _executeWithRetry(
        'invite workspace member',
        () async {
          final response = await _client.rpc('invite_workspace_member', params: {
            'workspace_uuid': workspaceId,
            'member_email': email,
            'member_role': role,
            'invitation_message': message,
            'inviter_uuid': userId,
          });

          // Clear relevant cache
          _cache.removeWhere((key, _) => key.contains('workspace_members_$workspaceId'));

          return response != null;
        },
      );

      return result;
    } catch (e) {
      ErrorHandler.handleError('Failed to invite member: $e');
      return false;
    }
  }

  /// Get workspace analytics/metrics
  Future<Map<String, dynamic>> getWorkspaceMetrics(String workspaceId) async {
    try {
      await _ensureInitialized();

      // Check cache first
      final cacheKey = 'workspace_metrics_$workspaceId';
      final cached = _getCachedData<Map<String, dynamic>>(cacheKey);
      if (cached != null) {
        return cached;
      }

      final result = await _executeWithRetry(
        'get workspace metrics',
        () async {
          final response = await _client.rpc('get_workspace_dashboard_metrics', params: {
            'workspace_uuid': workspaceId,
          });

          return (response ?? {}) as Map<String, dynamic>;
        },
      );

      _setCachedData(cacheKey, result);
      return result;
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

      final result = await _executeWithRetry(
        'update workspace',
        () async {
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

          // Clear relevant cache
          _cache.removeWhere((key, _) => key.contains('workspace_$workspaceId'));

          return true;
        },
      );

      return result;
    } catch (e) {
      ErrorHandler.handleError('Failed to update workspace: $e');
      return false;
    }
  }

  /// Delete workspace
  Future<bool> deleteWorkspace(String workspaceId) async {
    try {
      await _ensureInitialized();

      final result = await _executeWithRetry(
        'delete workspace',
        () async {
          await _client
              .from('workspaces')
              .delete()
              .eq('id', workspaceId);

          // Clear all related cache
          _cache.removeWhere((key, _) => key.contains(workspaceId));

          return true;
        },
      );

      return result;
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

      final result = await _executeWithRetry(
        'leave workspace',
        () async {
          await _client
              .from('workspace_members')
              .update({'is_active': false})
              .eq('workspace_id', workspaceId)
              .eq('user_id', userId);

          // Clear user workspace cache
          _cache.removeWhere((key, _) => key.contains('user_workspaces_$userId'));

          return true;
        },
      );

      return result;
    } catch (e) {
      ErrorHandler.handleError('Failed to leave workspace: $e');
      return false;
    }
  }

  /// Get workspace invitations
  Future<List<Map<String, dynamic>>> getWorkspaceInvitations(String workspaceId) async {
    try {
      await _ensureInitialized();

      final result = await _executeWithRetry(
        'get workspace invitations',
        () async {
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

          return response.cast<Map<String, dynamic>>();
        },
      );

      return result;
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

      final result = await _executeWithRetry(
        'accept workspace invitation',
        () async {
          final response = await _client.rpc('accept_workspace_invitation', params: {
            'invitation_token': invitationToken,
            'accepting_user_uuid': userId,
          });

          // Clear user workspace cache
          _cache.removeWhere((key, _) => key.contains('user_workspaces_$userId'));

          return response == true;
        },
      );

      return result;
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

      // Check cache first
      final cacheKey = 'can_manage_${workspaceId}_$userId';
      final cached = _getCachedData<bool>(cacheKey);
      if (cached != null) {
        return cached;
      }

      final result = await _executeWithRetry(
        'check workspace management permission',
        () async {
          final response = await _client
              .from('workspace_members')
              .select('role')
              .eq('workspace_id', workspaceId)
              .eq('user_id', userId)
              .eq('is_active', true)
              .single();

          final role = response['role'];
          final canManage = role == 'owner' || role == 'admin';
          
          return canManage;
        },
      );

      _setCachedData(cacheKey, result);
      return result;
    } catch (e) {
      return false;
    }
  }

  /// Get user's role in workspace with enhanced error handling
  Future<String?> getUserRoleInWorkspace(String workspaceId) async {
    try {
      await _ensureInitialized();
      
      final authService = AuthService();
      final userId = authService.currentUser?.id;
      
      if (userId == null) {
        return null;
      }

      // Check cache first
      final cacheKey = 'user_role_${workspaceId}_$userId';
      final cached = _getCachedData<String>(cacheKey);
      if (cached != null) {
        return cached;
      }

      final result = await _executeWithRetry(
        'get user role in workspace',
        () async {
          final response = await _client
              .from('workspace_members')
              .select('role')
              .eq('workspace_id', workspaceId)
              .eq('user_id', userId)
              .eq('is_active', true)
              .single();

          return response['role'] as String?;
        },
      );

      if (result != null) {
        _setCachedData(cacheKey, result);
      }
      
      return result;
    } catch (e) {
      debugPrint('Failed to get user role in workspace: $e');
      return null;
    }
  }

  /// Clear all cache
  void clearCache() {
    _cache.clear();
  }

  /// Dispose resources
  void dispose() {
    _cacheTimer?.cancel();
    _cache.clear();
  }
}