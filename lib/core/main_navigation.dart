import 'dart:async';

import 'package:supabase_flutter/supabase_flutter.dart';

import '../core/app_export.dart' hide BottomNavigationItem;
import '../presentation/advanced_crm_management_hub/advanced_crm_management_hub.dart';
import '../presentation/enhanced_login_screen/enhanced_login_screen.dart';
import '../presentation/enhanced_workspace_dashboard/enhanced_workspace_dashboard.dart';
import '../presentation/premium_social_media_hub/premium_social_media_hub.dart';
import '../presentation/unified_analytics_screen/unified_analytics_screen.dart';
import '../presentation/unified_settings_screen/unified_settings_screen.dart';
import '../presentation/workspace_selector_screen/workspace_selector_screen.dart';
import '../services/enhanced_auth_service.dart';
import '../services/workspace_service.dart';
import '../widgets/auth_guard_widget.dart';
import '../widgets/custom_bottom_navigation_widget.dart';

// Main navigation tabs enum
enum MainNavigationTab {
  dashboard,    // Enhanced Workspace Dashboard
  social,       // Premium Social Media Hub
  analytics,    // Unified Analytics
  crm,          // Advanced CRM Management
  more,         // Settings and additional features
}

// User roles for access control
enum UserRole {
  guest,
  authenticated,
  workspaceMember,
  admin,
  owner,
}

// Screen access matrix implementation
class ScreenAccessMatrix {
  static const Map<String, Map<UserRole, bool>> _accessMatrix = {
    // Authentication screens
    'authentication': {
      UserRole.guest: true,
      UserRole.authenticated: false,
      UserRole.workspaceMember: false,
      UserRole.admin: false,
      UserRole.owner: false,
    },
    
    // Onboarding screens
    'onboarding': {
      UserRole.guest: false,
      UserRole.authenticated: true,
      UserRole.workspaceMember: false,
      UserRole.admin: false,
      UserRole.owner: false,
    },
    
    // Workspace creation
    'workspace_creation': {
      UserRole.guest: false,
      UserRole.authenticated: true,
      UserRole.workspaceMember: false,
      UserRole.admin: false,
      UserRole.owner: false,
    },
    
    // Main dashboard
    'main_dashboard': {
      UserRole.guest: false,
      UserRole.authenticated: false,
      UserRole.workspaceMember: true,
      UserRole.admin: true,
      UserRole.owner: true,
    },
    
    // Social media tools
    'social_media_tools': {
      UserRole.guest: false,
      UserRole.authenticated: false,
      UserRole.workspaceMember: true,
      UserRole.admin: true,
      UserRole.owner: true,
    },
    
    // CRM & Analytics
    'crm_analytics': {
      UserRole.guest: false,
      UserRole.authenticated: false,
      UserRole.workspaceMember: true,
      UserRole.admin: true,
      UserRole.owner: true,
    },
    
    // Content creation
    'content_creation': {
      UserRole.guest: false,
      UserRole.authenticated: false,
      UserRole.workspaceMember: true,
      UserRole.admin: true,
      UserRole.owner: true,
    },
    
    // Team management
    'team_management': {
      UserRole.guest: false,
      UserRole.authenticated: false,
      UserRole.workspaceMember: false,
      UserRole.admin: true,
      UserRole.owner: true,
    },
    
    // Workspace settings
    'workspace_settings': {
      UserRole.guest: false,
      UserRole.authenticated: false,
      UserRole.workspaceMember: false,
      UserRole.admin: true,
      UserRole.owner: true,
    },
    
    // Billing & Subscription
    'billing_subscription': {
      UserRole.guest: false,
      UserRole.authenticated: false,
      UserRole.workspaceMember: false,
      UserRole.admin: false,
      UserRole.owner: true,
    },
  };

  static bool hasAccess(String screenCategory, UserRole userRole) {
    return _accessMatrix[screenCategory]?[userRole] ?? false;
  }

  static UserRole getUserRoleFromString(String? role) {
    switch (role?.toLowerCase()) {
      case 'owner':
        return UserRole.owner;
      case 'admin':
        return UserRole.admin;
      case 'member':
        return UserRole.workspaceMember;
      case 'authenticated':
        return UserRole.authenticated;
      default:
        return UserRole.guest;
    }
  }
}

class MainNavigationWrapper extends StatefulWidget {
  const MainNavigationWrapper({Key? key}) : super(key: key);

  @override
  State<MainNavigationWrapper> createState() => _MainNavigationWrapperState();
}

class _MainNavigationWrapperState extends State<MainNavigationWrapper> 
    with WidgetsBindingObserver, AutomaticKeepAliveClientMixin {
  int _currentIndex = 0;
  UserRole _userRole = UserRole.guest;
  bool _isAuthenticated = false;
  bool _hasWorkspace = false;
  String? _workspaceId;
  String? _userWorkspaceRole;
  bool _isLoading = true;
  bool _hasError = false;
  String? _errorMessage;
  int _retryCount = 0;
  static const int _maxRetries = 3;
  
  Timer? _authRefreshTimer;
  Timer? _retryTimer;
  StreamSubscription<AuthState>? _authStateSubscription;
  bool _isDisposed = false;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _initializeWithRetry();
    _setupAuthStateListener();
    _startPeriodicAuthRefresh();
  }

  @override
  void dispose() {
    _isDisposed = true;
    WidgetsBinding.instance.removeObserver(this);
    _authRefreshTimer?.cancel();
    _retryTimer?.cancel();
    _authStateSubscription?.cancel();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    
    // Enhanced app state management
    switch (state) {
      case AppLifecycleState.resumed:
        if (_isAuthenticated && !_isDisposed) {
          _refreshAuthStateBackground();
        }
        break;
      case AppLifecycleState.paused:
        // Optionally clear sensitive data
        break;
      case AppLifecycleState.detached:
        // Cleanup resources
        break;
      default:
        break;
    }
  }

  /// Setup enhanced auth state listener
  void _setupAuthStateListener() {
    try {
      final authService = EnhancedAuthService();
      final authStream = authService.onAuthStateChanged;
      
      _authStateSubscription = authStream.listen((AuthState authState) {
        if (!_isDisposed && mounted) {
          final event = authState.event;
          debugPrint('Auth state changed: $event');
          
          switch (event) {
            case AuthChangeEvent.signedOut:
              _handleAuthSignOut();
              break;
            case AuthChangeEvent.signedIn:
              _handleAuthSignIn();
              break;
            case AuthChangeEvent.tokenRefreshed:
              // Token refreshed, verify workspace access
              _refreshWorkspaceData();
              break;
            default:
              break;
          }
        }
      });
    } catch (e) {
      debugPrint('Failed to setup auth state listener: $e');
    }
  }

  /// Handle auth sign out
  void _handleAuthSignOut() {
    if (mounted && !_isDisposed) {
      setState(() {
        _isAuthenticated = false;
        _hasWorkspace = false;
        _userRole = UserRole.guest;
        _workspaceId = null;
        _userWorkspaceRole = null;
      });
      
      // Navigate to login
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          Navigator.pushReplacementNamed(context, AppRoutes.enhancedLoginScreen);
        }
      });
    }
  }

  /// Handle auth sign in
  void _handleAuthSignIn() {
    if (mounted && !_isDisposed) {
      // Refresh auth state to load workspace data
      _refreshAuthStateBackground();
    }
  }

  /// Start periodic auth refresh
  void _startPeriodicAuthRefresh() {
    _authRefreshTimer?.cancel();
    _authRefreshTimer = Timer.periodic(const Duration(minutes: 5), (_) {
      if (_isAuthenticated && !_isDisposed) {
        _refreshAuthStateBackground();
      }
    });
  }

  /// Initialize with enhanced retry logic
  Future<void> _initializeWithRetry() async {
    while (_retryCount < _maxRetries && !_isAuthenticated && mounted && !_isDisposed) {
      try {
        await _checkAuthState();
        break; // Success, exit retry loop
      } catch (e) {
        _retryCount++;
        
        if (_retryCount >= _maxRetries) {
          if (mounted && !_isDisposed) {
            setState(() {
              _hasError = true;
              _errorMessage = 'Failed to initialize authentication after $_maxRetries attempts';
              _isLoading = false;
            });
          }
          break;
        }
        
        debugPrint('Auth check attempt $_retryCount failed: $e');
        
        // Wait before retry with exponential backoff
        final delaySeconds = _retryCount * 2;
        _retryTimer = Timer(Duration(seconds: delaySeconds), () {
          if (mounted && !_isDisposed) {
            _initializeWithRetry();
          }
        });
        break;
      }
    }
  }

  /// Enhanced auth state check with better error handling
  Future<void> _checkAuthState() async {
    if (!mounted || _isDisposed) return;
    
    setState(() {
      _isLoading = true;
      _hasError = false;
    });

    try {
      // Enhanced authentication service initialization
      final authService = EnhancedAuthService();
      await authService.initialize().timeout(const Duration(seconds: 15));
      
      final isAuth = authService.isAuthenticated;
      
      if (isAuth) {
        final user = authService.currentUser;
        if (user != null) {
          // Enhanced workspace loading with improved error handling
          await _loadWorkspaceData(user.id);
        } else {
          _setAuthState(false, false, UserRole.guest);
        }
      } else {
        _setAuthState(false, false, UserRole.guest);
      }
    } catch (e) {
      debugPrint('Enhanced auth check error: $e');
      
      if (mounted && !_isDisposed) {
        // Don't immediately set error state, let retry logic handle it
        if (_retryCount >= _maxRetries - 1) {
          setState(() {
            _isAuthenticated = false;
            _hasWorkspace = false;
            _userRole = UserRole.guest;
            _hasError = true;
            _errorMessage = e.toString();
            _isLoading = false;
          });
        }
      }
      
      rethrow; // Let retry logic handle this
    }
  }

  /// Enhanced workspace data loading
  Future<void> _loadWorkspaceData(String userId) async {
    try {
      final workspaceService = WorkspaceService();
      await workspaceService.initialize().timeout(const Duration(seconds: 15));
      
      final workspaces = await workspaceService.getUserWorkspaces()
          .timeout(const Duration(seconds: 20));
      
      if (workspaces.isNotEmpty) {
        final workspace = workspaces.first;
        final workspaceId = workspace['workspace_id'] ?? workspace['id'];
        
        if (workspaceId == null) {
          throw Exception('Invalid workspace data structure');
        }
        
        final userRole = await workspaceService.getUserRoleInWorkspace(workspaceId)
            .timeout(const Duration(seconds: 10));
        
        if (userRole != null) {
          _setWorkspaceState(true, true, workspaceId, userRole);
        } else {
          throw Exception('Unable to determine user role in workspace');
        }
      } else {
        _setAuthState(true, false, UserRole.authenticated);
      }
    } catch (e) {
      debugPrint('Workspace loading error: $e');
      throw Exception('Failed to load workspace data: $e');
    }
  }

  /// Set authentication state
  void _setAuthState(bool isAuth, bool hasWorkspace, UserRole role) {
    if (mounted && !_isDisposed) {
      setState(() {
        _isAuthenticated = isAuth;
        _hasWorkspace = hasWorkspace;
        _userRole = role;
        _isLoading = false;
        _retryCount = 0;
        _hasError = false;
      });
    }
  }

  /// Set workspace state
  void _setWorkspaceState(bool isAuth, bool hasWorkspace, String workspaceId, String userRole) {
    if (mounted && !_isDisposed) {
      setState(() {
        _isAuthenticated = isAuth;
        _hasWorkspace = hasWorkspace;
        _workspaceId = workspaceId;
        _userWorkspaceRole = userRole;
        _userRole = ScreenAccessMatrix.getUserRoleFromString(userRole);
        _isLoading = false;
        _retryCount = 0;
        _hasError = false;
      });
    }
  }

  /// Background auth refresh (doesn't show loading)
  Future<void> _refreshAuthStateBackground() async {
    if (_isDisposed) return;
    
    try {
      final authService = EnhancedAuthService();
      await authService.initialize();
      
      final isAuth = authService.isAuthenticated;
      
      if (isAuth) {
        final user = authService.currentUser;
        if (user != null) {
          await _refreshWorkspaceData();
        } else {
          _handleAuthSignOut();
        }
      } else {
        _handleAuthSignOut();
      }
    } catch (e) {
      debugPrint('Background auth refresh error: $e');
      // Don't show error for background refresh
    }
  }

  /// Refresh workspace data
  Future<void> _refreshWorkspaceData() async {
    if (_isDisposed || !_isAuthenticated) return;
    
    try {
      final workspaceService = WorkspaceService();
      await workspaceService.initialize();
      
      final workspaces = await workspaceService.getUserWorkspaces();
      
      if (workspaces.isNotEmpty && _workspaceId != null) {
        final userRole = await workspaceService.getUserRoleInWorkspace(_workspaceId!);
        
        if (userRole != null && mounted && !_isDisposed) {
          setState(() {
            _userWorkspaceRole = userRole;
            _userRole = ScreenAccessMatrix.getUserRoleFromString(userRole);
          });
        }
      }
    } catch (e) {
      debugPrint('Workspace data refresh error: $e');
    }
  }

  /// Manual refresh with loading state
  Future<void> _refreshAuthState() async {
    _retryCount = 0; // Reset retry count for manual refresh
    await _initializeWithRetry();
  }

  void _onTabTapped(int index) {
    if (mounted && !_isDisposed) {
      setState(() {
        _currentIndex = index;
      });
      HapticFeedback.lightImpact();
    }
  }

  Widget _getCurrentScreen() {
    if (_isLoading) {
      return _buildLoadingScreen();
    }

    if (_hasError) {
      return _buildErrorScreen();
    }

    if (!_isAuthenticated) {
      return const EnhancedLoginScreen();
    }

    if (!_hasWorkspace) {
      return const WorkspaceSelectorScreen();
    }

    switch (MainNavigationTab.values[_currentIndex]) {
      case MainNavigationTab.dashboard:
        if (ScreenAccessMatrix.hasAccess('main_dashboard', _userRole)) {
          return const EnhancedWorkspaceDashboard();
        }
        return _buildAccessDeniedScreen('Dashboard');
        
      case MainNavigationTab.social:
        if (ScreenAccessMatrix.hasAccess('social_media_tools', _userRole)) {
          return const PremiumSocialMediaHub();
        }
        return _buildAccessDeniedScreen('Social Media Hub');
        
      case MainNavigationTab.analytics:
        if (ScreenAccessMatrix.hasAccess('crm_analytics', _userRole)) {
          return const UnifiedAnalyticsScreen();
        }
        return _buildAccessDeniedScreen('Analytics');
        
      case MainNavigationTab.crm:
        if (ScreenAccessMatrix.hasAccess('crm_analytics', _userRole)) {
          return const AdvancedCrmManagementHub();
        }
        return _buildAccessDeniedScreen('CRM');
        
      case MainNavigationTab.more:
        return const UnifiedSettingsScreen();
        
      default:
        return const EnhancedWorkspaceDashboard();
    }
  }

  Widget _buildLoadingScreen() {
    return Scaffold(
      backgroundColor: const Color(0xFF101010),
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(
                width: 48,
                height: 48,
                child: CircularProgressIndicator(
                  strokeWidth: 3,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    Color(0xFF007AFF),
                  ),
                ),
              ),
              SizedBox(height: 3.h),
              Text(
                'Loading workspace...',
                style: GoogleFonts.inter(
                  fontSize: 16.sp,
                  color: const Color(0xFF8E8E93),
                ),
              ),
              if (_retryCount > 0) ...[
                SizedBox(height: 1.h),
                Text(
                  'Retry attempt $_retryCount/$_maxRetries',
                  style: GoogleFonts.inter(
                    fontSize: 12.sp,
                    color: const Color(0xFF636366),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildErrorScreen() {
    return Scaffold(
      backgroundColor: const Color(0xFF101010),
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: EdgeInsets.all(6.w),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.error_outline,
                  size: 20.w,
                  color: const Color(0xFFFF3B30),
                ),
                SizedBox(height: 3.h),
                Text(
                  'Connection Error',
                  style: GoogleFonts.inter(
                    fontSize: 24.sp,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 2.h),
                Text(
                  _errorMessage ?? 'Failed to load workspace data',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.inter(
                    fontSize: 16.sp,
                    color: const Color(0xFF8E8E93),
                  ),
                ),
                SizedBox(height: 4.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    TextButton(
                      onPressed: () {
                        Navigator.pushReplacementNamed(context, AppRoutes.enhancedLoginScreen);
                      },
                      child: Text(
                        'Go to Login',
                        style: GoogleFonts.inter(
                          fontSize: 16.sp,
                          color: const Color(0xFF8E8E93),
                        ),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: _refreshAuthState,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF007AFF),
                        foregroundColor: Colors.white,
                        padding: EdgeInsets.symmetric(
                          horizontal: 8.w,
                          vertical: 2.h,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Text(
                        'Retry',
                        style: GoogleFonts.inter(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAccessDeniedScreen(String featureName) {
    return Scaffold(
      backgroundColor: const Color(0xFF101010),
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: EdgeInsets.all(6.w),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.lock_outlined,
                  size: 20.w,
                  color: const Color(0xFF8E8E93),
                ),
                SizedBox(height: 3.h),
                Text(
                  'Access Restricted',
                  style: GoogleFonts.inter(
                    fontSize: 24.sp,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 2.h),
                Text(
                  'You need admin or owner permissions to access $featureName.',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.inter(
                    fontSize: 16.sp,
                    color: const Color(0xFF8E8E93),
                  ),
                ),
                SizedBox(height: 1.h),
                Text(
                  'Current role: ${_userWorkspaceRole ?? 'Unknown'}',
                  style: GoogleFonts.inter(
                    fontSize: 14.sp,
                    color: const Color(0xFF007AFF),
                  ),
                ),
                SizedBox(height: 4.h),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pushNamed(context, AppRoutes.contactUsScreen);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF007AFF),
                    foregroundColor: Colors.white,
                    padding: EdgeInsets.symmetric(
                      horizontal: 8.w,
                      vertical: 2.h,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    'Request Access',
                    style: GoogleFonts.inter(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    super.build(context); // Required for AutomaticKeepAliveClientMixin
    
    // Use AuthGuardWidget for proper auth state management
    return AuthGuardWidget(
      requireAuth: false, // Handle auth manually in this wrapper
      child: Builder(
        builder: (context) {
          // If not authenticated or no workspace, show full screen
          if (!_isAuthenticated || !_hasWorkspace || _isLoading || _hasError) {
            return _getCurrentScreen();
          }

          return Scaffold(
            body: IndexedStack(
              index: _currentIndex,
              children: [
                // Dashboard
                ScreenAccessMatrix.hasAccess('main_dashboard', _userRole)
                    ? const EnhancedWorkspaceDashboard()
                    : _buildAccessDeniedScreen('Dashboard'),
                
                // Social Media Hub
                ScreenAccessMatrix.hasAccess('social_media_tools', _userRole)
                    ? const PremiumSocialMediaHub()
                    : _buildAccessDeniedScreen('Social Media Hub'),
                
                // Analytics
                ScreenAccessMatrix.hasAccess('crm_analytics', _userRole)
                    ? const UnifiedAnalyticsScreen()
                    : _buildAccessDeniedScreen('Analytics'),
                
                // CRM
                ScreenAccessMatrix.hasAccess('crm_analytics', _userRole)
                    ? const AdvancedCrmManagementHub()
                    : _buildAccessDeniedScreen('CRM'),
                
                // Settings (Always accessible to workspace members)
                const UnifiedSettingsScreen(),
              ],
            ),
            bottomNavigationBar: CustomBottomNavigationWidget(
              currentIndex: _currentIndex,
              onTap: _onTabTapped,
              backgroundColor: const Color(0xFF191919),
              selectedItemColor: const Color(0xFF007AFF),
              unselectedItemColor: const Color(0xFF8E8E93),
              items: [
                const BottomNavigationItem(
                  label: 'Dashboard',
                  iconName: 'dashboard',
                  tooltip: 'Enhanced Workspace Dashboard',
                ),
                const BottomNavigationItem(
                  label: 'Social',
                  iconName: 'groups',
                  tooltip: 'Premium Social Media Hub',
                ),
                const BottomNavigationItem(
                  label: 'Analytics',
                  iconName: 'analytics',
                  tooltip: 'Unified Analytics',
                ),
                const BottomNavigationItem(
                  label: 'CRM',
                  iconName: 'business',
                  tooltip: 'Advanced CRM Management',
                ),
                const BottomNavigationItem(
                  label: 'More',
                  iconName: 'more_horiz',
                  tooltip: 'Settings and more features',
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}