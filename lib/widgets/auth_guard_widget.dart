
import '../core/app_export.dart';
import '../core/main_navigation.dart';
import '../services/enhanced_auth_service.dart';
import '../services/workspace_service.dart';

class AuthGuardWidget extends StatefulWidget {
  final Widget child;
  final List<UserRole> requiredRoles;
  final String? requiredPermission;
  final Widget? fallbackWidget;
  final VoidCallback? onAccessDenied;

  const AuthGuardWidget({
    Key? key,
    required this.child,
    this.requiredRoles = const [UserRole.workspaceMember],
    this.requiredPermission,
    this.fallbackWidget,
    this.onAccessDenied,
  }) : super(key: key);

  @override
  State<AuthGuardWidget> createState() => _AuthGuardWidgetState();
}

class _AuthGuardWidgetState extends State<AuthGuardWidget> {
  bool _isLoading = true;
  bool _hasAccess = false;
  UserRole _currentUserRole = UserRole.guest;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _checkAccess();
  }

  Future<void> _checkAccess() async {
    try {
      final authService = EnhancedAuthService();
      await authService.initialize();

      if (!authService.isAuthenticated) {
        setState(() {
          _isLoading = false;
          _hasAccess = false;
          _currentUserRole = UserRole.guest;
        });
        return;
      }

      final user = authService.currentUser;
      if (user == null) {
        setState(() {
          _isLoading = false;
          _hasAccess = false;
          _currentUserRole = UserRole.guest;
        });
        return;
      }

      // Check workspace membership and role
      final workspaceService = WorkspaceService();
      final workspaces = await workspaceService.getUserWorkspaces();

      if (workspaces.isEmpty) {
        setState(() {
          _isLoading = false;
          _hasAccess = widget.requiredRoles.contains(UserRole.authenticated);
          _currentUserRole = UserRole.authenticated;
        });
        return;
      }

      // Get user role in primary workspace
      final primaryWorkspace = workspaces.first;
      final userRole = await workspaceService.getUserRoleInWorkspace(
        primaryWorkspace['id'],
      );

      final currentRole = ScreenAccessMatrix.getUserRoleFromString(userRole);
      final hasRequiredRole = widget.requiredRoles.contains(currentRole);

      setState(() {
        _isLoading = false;
        _hasAccess = hasRequiredRole;
        _currentUserRole = currentRole;
      });

      if (!hasRequiredRole && widget.onAccessDenied != null) {
        widget.onAccessDenied!();
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
        _hasAccess = false;
        _errorMessage = e.toString();
      });
    }
  }

  Widget _buildLoadingWidget() {
    return Container(
      width: 100.w,
      height: 100.h,
      color: const Color(0xFF101010),
      child: const Center(
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF007AFF)),
        ),
      ),
    );
  }

  Widget _buildAccessDeniedWidget() {
    if (widget.fallbackWidget != null) {
      return widget.fallbackWidget!;
    }

    return Container(
      width: 100.w,
      height: 100.h,
      color: const Color(0xFF101010),
      child: SafeArea(
        child: Center(
          child: Padding(
            padding: EdgeInsets.all(6.w),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  _currentUserRole == UserRole.guest
                      ? Icons.login_outlined
                      : Icons.lock_outlined,
                  size: 20.w,
                  color: const Color(0xFF8E8E93),
                ),
                SizedBox(height: 3.h),
                Text(
                  _currentUserRole == UserRole.guest
                      ? 'Authentication Required'
                      : 'Access Restricted',
                  style: GoogleFonts.inter(
                    fontSize: 24.sp,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 2.h),
                Text(
                  _currentUserRole == UserRole.guest
                      ? 'Please sign in to access this feature.'
                      : 'You need ${widget.requiredRoles.map((r) => r.name).join(' or ')} permissions to access this feature.',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.inter(
                    fontSize: 16.sp,
                    color: const Color(0xFF8E8E93),
                  ),
                ),
                if (_currentUserRole != UserRole.guest) ...[
                  SizedBox(height: 1.h),
                  Text(
                    'Current role: ${_currentUserRole.name}',
                    style: GoogleFonts.inter(
                      fontSize: 14.sp,
                      color: const Color(0xFF007AFF),
                    ),
                  ),
                ],
                if (_errorMessage != null) ...[
                  SizedBox(height: 2.h),
                  Text(
                    'Error: $_errorMessage',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.inter(
                      fontSize: 12.sp,
                      color: const Color(0xFFFF3B30),
                    ),
                  ),
                ],
                SizedBox(height: 4.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (_currentUserRole == UserRole.guest) ...[
                      ElevatedButton(
                        onPressed: () {
                          Navigator.pushNamed(context, AppRoutes.enhancedLoginScreen);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF007AFF),
                          foregroundColor: Colors.white,
                          padding: EdgeInsets.symmetric(
                            horizontal: 6.w,
                            vertical: 2.h,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: Text(
                          'Sign In',
                          style: GoogleFonts.inter(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ] else ...[
                      OutlinedButton(
                        onPressed: _checkAccess,
                        style: OutlinedButton.styleFrom(
                          foregroundColor: const Color(0xFF007AFF),
                          side: const BorderSide(color: Color(0xFF007AFF)),
                          padding: EdgeInsets.symmetric(
                            horizontal: 4.w,
                            vertical: 1.5.h,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: Text(
                          'Retry',
                          style: GoogleFonts.inter(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      SizedBox(width: 4.w),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.pushNamed(context, AppRoutes.contactUsScreen);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF007AFF),
                          foregroundColor: Colors.white,
                          padding: EdgeInsets.symmetric(
                            horizontal: 4.w,
                            vertical: 1.5.h,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: Text(
                          'Request Access',
                          style: GoogleFonts.inter(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ],
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
    if (_isLoading) {
      return _buildLoadingWidget();
    }

    if (!_hasAccess) {
      return _buildAccessDeniedWidget();
    }

    return widget.child;
  }
}

// Extension for easier access control
extension AccessControlExtensions on Widget {
  Widget requiresAuth({
    List<UserRole> roles = const [UserRole.workspaceMember],
    String? permission,
    Widget? fallback,
    VoidCallback? onAccessDenied,
  }) {
    return AuthGuardWidget(
      requiredRoles: roles,
      requiredPermission: permission,
      fallbackWidget: fallback,
      onAccessDenied: onAccessDenied,
      child: this,
    );
  }

  Widget requiresRole(UserRole role) {
    return AuthGuardWidget(
      requiredRoles: [role],
      child: this,
    );
  }

  Widget requiresOwner() {
    return AuthGuardWidget(
      requiredRoles: [UserRole.owner],
      child: this,
    );
  }

  Widget requiresAdmin() {
    return AuthGuardWidget(
      requiredRoles: [UserRole.admin, UserRole.owner],
      child: this,
    );
  }
}