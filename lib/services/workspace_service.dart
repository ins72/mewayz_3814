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
  
  // Enhanced retry and timeout configurations
  static const int _maxRetries = 3;
  static const Duration _defaultTimeout = Duration(seconds: 20);
  static const Duration _shortTimeout = Duration(seconds: 10);

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

  /// Enhanced operation execution with timeout, retry, and circuit breaker
  Future<T> _executeWithRetry<T>(
    String operationName,
    Future<T> Function() operation, {
    int maxRetries = _maxRetries,
    Duration timeout = _defaultTimeout,
    bool useCircuitBreaker = true,
  }) async {
    Exception? lastException;
    
    for (int attempt = 0; attempt <= maxRetries; attempt++) {
      try {
        // Check Supabase connection if using circuit breaker
        if (useCircuitBreaker && !SupabaseService.instance.isConnected) {
          final reconnected = await SupabaseService.instance.forceReconnect();
          if (!reconnected) {
            throw Exception('$operationName failed: Database connection unavailable');
          }
        }

        final result = await operation().timeout(timeout);
        
        // Log successful operation after retries
        if (attempt > 0) {
          debugPrint('✅ $operationName succeeded on attempt ${attempt + 1}');
        }
        
        return result;
      } on TimeoutException {
        lastException = Exception('$operationName timed out after ${timeout.inSeconds} seconds');
        debugPrint('⏱️ $operationName timeout on attempt ${attempt + 1}');
      } catch (e) {
        lastException = e is Exception ? e : Exception(e.toString());
        
        if (attempt < maxRetries) {
          final delaySeconds = (attempt + 1) * 2; // Exponential backoff
          debugPrint('🔄 $operationName attempt ${attempt + 1} failed: $e, retrying in ${delaySeconds}s...');
          await Future.delayed(Duration(seconds: delaySeconds));
        }
      }
    }
    
    final finalError = '$operationName failed after ${maxRetries + 1} attempts. Last error: ${lastException.toString()}';
    debugPrint('❌ $finalError');
    throw Exception(finalError);
  }

  /// Check if user has any workspace with enhanced validation
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
        timeout: _shortTimeout,
      );

      _setCachedData(cacheKey, result);
      return result;
    } catch (e) {
      ErrorHandler.handleError('Failed to check user workspace: $e');
      return false;
    }
  }

  /// Get user's workspaces with enhanced error handling and validation
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

          // Enhanced data validation and processing
          final processedWorkspaces = <Map<String, dynamic>>[];
          
          for (final item in response) {
            final workspaceData = item['workspaces'];
            
            // Validate workspace data integrity
            if (workspaceData == null || item['workspace_id'] == null) {
              debugPrint('⚠️ Skipping invalid workspace data: $item');
              continue;
            }
            
            processedWorkspaces.add({
              'workspace_id': item['workspace_id'],
              'id': item['workspace_id'], // Add id field for compatibility
              'role': item['role'] ?? 'member',
              'joined_at': item['joined_at'],
              'workspace': workspaceData,
              // Flatten workspace data for easier access
              'name': workspaceData['name'] ?? 'Unnamed Workspace',
              'description': workspaceData['description'] ?? '',
              'goal': workspaceData['goal'] ?? '',
              'status': workspaceData['status'] ?? 'active',
              'logo_url': workspaceData['logo_url'],
              'owner_info': workspaceData['user_profiles'],
            });
          }

          return processedWorkspaces;
        },
      );

      _setCachedData(cacheKey, result);
      return result;
    } catch (e) {
      ErrorHandler.handleError('Failed to get user workspaces: $e');
      return [];
    }
  }

  /// Create a new workspace with enhanced validation
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

      // Validate input data
      if (name.trim().isEmpty) {
        throw Exception('Workspace name cannot be empty');
      }
      
      if (description.trim().isEmpty) {
        throw Exception('Workspace description cannot be empty');
      }

      final result = await _executeWithRetry(
        'create workspace',
        () async {
          final response = await _client.rpc('create_workspace', params: {
            'workspace_name': name.trim(),
            'workspace_description': description.trim(),
            'workspace_goal': goal,
            'custom_goal_desc': customGoalDescription?.trim(),
            'owner_uuid': userId,
          });

          if (response != null) {
            // Clear cache
            _cache.removeWhere((key, _) => key.contains('workspace') || key.contains(userId));
            
            // Get the created workspace details with validation
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

  /// Get workspace by ID with enhanced validation
  Future<Map<String, dynamic>?> getWorkspaceById(String workspaceId) async {
    try {
      await _ensureInitialized();

      // Validate input
      if (workspaceId.trim().isEmpty) {
        throw Exception('Invalid workspace ID');
      }

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
              .eq('id', workspaceId.trim())
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

  /// Get workspace members with enhanced validation
  Future<List<Map<String, dynamic>>> getWorkspaceMembers(String workspaceId) async {
    try {
      await _ensureInitialized();

      // Validate input
      if (workspaceId.trim().isEmpty) {
        throw Exception('Invalid workspace ID');
      }

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
              .eq('workspace_id', workspaceId.trim())
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

  /// Invite member to workspace with enhanced validation
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

      // Enhanced input validation
      if (workspaceId.trim().isEmpty) {
        throw Exception('Invalid workspace ID');
      }
      
      if (email.trim().isEmpty || !RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email)) {
        throw Exception('Invalid email address');
      }
      
      if (!['owner', 'admin', 'member'].contains(role)) {
        throw Exception('Invalid role: $role');
      }

      final result = await _executeWithRetry(
        'invite workspace member',
        () async {
          final response = await _client.rpc('invite_workspace_member', params: {
            'workspace_uuid': workspaceId.trim(),
            'member_email': email.trim().toLowerCase(),
            'member_role': role,
            'invitation_message': message?.trim(),
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

  /// Get workspace analytics/metrics with enhanced error handling
  Future<Map<String, dynamic>> getWorkspaceMetrics(String workspaceId) async {
    try {
      await _ensureInitialized();

      // Validate input
      if (workspaceId.trim().isEmpty) {
        throw Exception('Invalid workspace ID');
      }

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
            'workspace_uuid': workspaceId.trim(),
          });

          // Ensure we return a valid map even if response is null
          final metricsData = (response ?? {}) as Map<String, dynamic>;
          
          // Add default values for common metrics if missing
          return {
            'total_members': metricsData['total_members'] ?? 0,
            'active_projects': metricsData['active_projects'] ?? 0,
            'total_tasks': metricsData['total_tasks'] ?? 0,
            'completed_tasks': metricsData['completed_tasks'] ?? 0,
            'workspace_age_days': metricsData['workspace_age_days'] ?? 0,
            'last_activity': metricsData['last_activity'],
            ...metricsData,
          };
        },
        timeout: _shortTimeout,
      );

      _setCachedData(cacheKey, result);
      return result;
    } catch (e) {
      ErrorHandler.handleError('Failed to get workspace metrics: $e');
      // Return default metrics on error
      return {
        'total_members': 0,
        'active_projects': 0,
        'total_tasks': 0,
        'completed_tasks': 0,
        'workspace_age_days': 0,
        'error': true,
        'error_message': e.toString(),
      };
    }
  }

  /// Update workspace with enhanced validation
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

      // Validate input
      if (workspaceId.trim().isEmpty) {
        throw Exception('Invalid workspace ID');
      }

      final result = await _executeWithRetry(
        'update workspace',
        () async {
          final updateData = <String, dynamic>{};
          
          if (name != null && name.trim().isNotEmpty) {
            updateData['name'] = name.trim();
          }
          
          if (description != null) {
            updateData['description'] = description.trim();
          }
          
          if (logoUrl != null) updateData['logo_url'] = logoUrl.trim();
          if (themeSettings != null) updateData['theme_settings'] = themeSettings;
          if (featuresEnabled != null) updateData['features_enabled'] = featuresEnabled;
          
          updateData['updated_at'] = DateTime.now().toIso8601String();

          await _client
              .from('workspaces')
              .update(updateData)
              .eq('id', workspaceId.trim());

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

  /// Delete workspace with enhanced validation and cleanup
  Future<bool> deleteWorkspace(String workspaceId) async {
    try {
      await _ensureInitialized();

      // Validate input
      if (workspaceId.trim().isEmpty) {
        throw Exception('Invalid workspace ID');
      }

      final result = await _executeWithRetry(
        'delete workspace',
        () async {
          await _client
              .from('workspaces')
              .delete()
              .eq('id', workspaceId.trim());

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

  /// Leave workspace with enhanced validation
  Future<bool> leaveWorkspace(String workspaceId) async {
    try {
      await _ensureInitialized();
      
      final authService = AuthService();
      final userId = authService.currentUser?.id;
      
      if (userId == null) {
        throw Exception('User not authenticated');
      }

      // Validate input
      if (workspaceId.trim().isEmpty) {
        throw Exception('Invalid workspace ID');
      }

      final result = await _executeWithRetry(
        'leave workspace',
        () async {
          await _client
              .from('workspace_members')
              .update({'is_active': false})
              .eq('workspace_id', workspaceId.trim())
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

  /// Get workspace invitations with enhanced error handling
  Future<List<Map<String, dynamic>>> getWorkspaceInvitations(String workspaceId) async {
    try {
      await _ensureInitialized();

      // Validate input
      if (workspaceId.trim().isEmpty) {
        throw Exception('Invalid workspace ID');
      }

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
              .eq('workspace_id', workspaceId.trim())
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

  /// Accept workspace invitation with enhanced validation
  Future<bool> acceptInvitation(String invitationToken) async {
    try {
      await _ensureInitialized();
      
      final authService = AuthService();
      final userId = authService.currentUser?.id;
      
      if (userId == null) {
        throw Exception('User not authenticated');
      }

      // Validate input
      if (invitationToken.trim().isEmpty) {
        throw Exception('Invalid invitation token');
      }

      final result = await _executeWithRetry(
        'accept workspace invitation',
        () async {
          final response = await _client.rpc('accept_workspace_invitation', params: {
            'invitation_token': invitationToken.trim(),
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

  /// Check if user can manage workspace with enhanced caching
  Future<bool> canManageWorkspace(String workspaceId) async {
    try {
      await _ensureInitialized();
      
      final authService = AuthService();
      final userId = authService.currentUser?.id;
      
      if (userId == null) {
        return false;
      }

      // Validate input
      if (workspaceId.trim().isEmpty) {
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
              .eq('workspace_id', workspaceId.trim())
              .eq('user_id', userId)
              .eq('is_active', true)
              .single();

          final role = response['role'];
          final canManage = role == 'owner' || role == 'admin';
          
          return canManage;
        },
        timeout: _shortTimeout,
      );

      _setCachedData(cacheKey, result);
      return result;
    } catch (e) {
      debugPrint('Failed to check workspace management permission: $e');
      return false;
    }
  }

  /// Get user's role in workspace with enhanced error handling and validation
  Future<String?> getUserRoleInWorkspace(String workspaceId) async {
    try {
      await _ensureInitialized();
      
      final authService = AuthService();
      final userId = authService.currentUser?.id;
      
      if (userId == null) {
        return null;
      }

      // Validate input
      if (workspaceId.trim().isEmpty) {
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
              .eq('workspace_id', workspaceId.trim())
              .eq('user_id', userId)
              .eq('is_active', true)
              .single();

          final role = response['role'] as String?;
          
          // Validate role value
          if (role != null && !['owner', 'admin', 'member'].contains(role)) {
            debugPrint('⚠️ Invalid role value from database: $role');
            return 'member'; // Default to member for invalid roles
          }
          
          return role;
        },
        timeout: _shortTimeout,
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
    debugPrint('WorkspaceService cache cleared');
  }

  /// Clear specific user cache
  void clearUserCache(String userId) {
    _cache.removeWhere((key, _) => key.contains(userId));
    debugPrint('WorkspaceService cache cleared for user: $userId');
  }

  /// Get cache statistics
  Map<String, dynamic> getCacheStats() {
    return {
      'total_entries': _cache.length,
      'cache_keys': _cache.keys.toList(),
      'cache_expiry_minutes': _cacheExpiry.inMinutes,
      'cleanup_timer_active': _cacheTimer?.isActive ?? false,
    };
  }

  /// Dispose resources
  void dispose() {
    _cacheTimer?.cancel();
    _cache.clear();
    debugPrint('WorkspaceService disposed');
  }
}