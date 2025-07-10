
import '../../core/app_export.dart';
import '../../services/enhanced_auth_service.dart';
import '../../services/workspace_service.dart';

class AppLaunchScreen extends StatefulWidget {
  const AppLaunchScreen({Key? key}) : super(key: key);

  @override
  State<AppLaunchScreen> createState() => _AppLaunchScreenState();
}

class _AppLaunchScreenState extends State<AppLaunchScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;

  bool _isLoading = true;
  bool _hasError = false;
  String _statusMessage = 'Initializing...';

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _performAppLaunchSequence();
  }

  void _initializeAnimations() {
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: const Interval(0.0, 0.6, curve: Curves.easeOut),
    ));

    _scaleAnimation = Tween<double>(
      begin: 0.8,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: const Interval(0.2, 0.8, curve: Curves.elasticOut),
    ));

    _animationController.forward();
  }

  Future<void> _performAppLaunchSequence() async {
    try {
      // Step 1: Initialize core services
      _updateStatus('Initializing core services...');
      await Future.delayed(const Duration(milliseconds: 500));
      
      // Step 2: Check authentication state
      _updateStatus('Checking authentication...');
      final authService = EnhancedAuthService();
      await authService.initialize();
      
      final isAuthenticated = authService.isAuthenticated;
      
      if (!isAuthenticated) {
        // Route to enhanced login screen
        _navigateToLogin();
        return;
      }

      // Step 3: Validate user session
      _updateStatus('Validating session...');
      final currentUser = authService.currentUser;
      
      if (currentUser == null) {
        _navigateToLogin();
        return;
      }

      // Step 4: Check workspace membership
      _updateStatus('Loading workspace...');
      final workspaceService = WorkspaceService();
      final userWorkspaces = await workspaceService.getUserWorkspaces();

      if (userWorkspaces.isEmpty) {
        // User is authenticated but has no workspace
        // Route to goal selection for new users
        _navigateToGoalSelection();
        return;
      }

      // Step 5: Load primary workspace
      final primaryWorkspace = userWorkspaces.first;
      final userRole = await workspaceService.getUserRoleInWorkspace(
        primaryWorkspace['id'],
      );

      // Step 6: Navigate to appropriate dashboard
      _updateStatus('Loading dashboard...');
      await Future.delayed(const Duration(milliseconds: 500));
      
      _navigateToWorkspaceDashboard();

    } catch (e) {
      debugPrint('App launch error: $e');
      _handleLaunchError(e.toString());
    }
  }

  void _updateStatus(String message) {
    setState(() {
      _statusMessage = message;
    });
  }

  void _handleLaunchError(String error) {
    setState(() {
      _hasError = true;
      _statusMessage = 'Failed to launch app';
      _isLoading = false;
    });
  }

  void _navigateToLogin() {
    Navigator.pushReplacementNamed(
      context,
      AppRoutes.enhancedLoginScreen,
    );
  }

  void _navigateToGoalSelection() {
    Navigator.pushReplacementNamed(
      context,
      AppRoutes.goalSelectionScreen,
    );
  }

  void _navigateToWorkspaceDashboard() {
    Navigator.pushReplacementNamed(
      context,
      AppRoutes.enhancedWorkspaceDashboard,
    );
  }

  void _navigateToWorkspaceSelection() {
    Navigator.pushReplacementNamed(
      context,
      AppRoutes.workspaceSelectorScreen,
    );
  }

  void _retryLaunch() {
    setState(() {
      _hasError = false;
      _isLoading = true;
      _statusMessage = 'Retrying...';
    });
    _performAppLaunchSequence();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF101010),
      body: Container(
        width: 100.w,
        height: 100.h,
        decoration: const BoxDecoration(
          gradient: RadialGradient(
            center: Alignment.center,
            radius: 1.0,
            colors: [
              Color(0xFF1A1A1A),
              Color(0xFF101010),
            ],
          ),
        ),
        child: SafeArea(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Animated logo
                AnimatedBuilder(
                  animation: _animationController,
                  builder: (context, child) {
                    return FadeTransition(
                      opacity: _fadeAnimation,
                      child: ScaleTransition(
                        scale: _scaleAnimation,
                        child: Container(
                          width: 24.w,
                          height: 24.w,
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [
                                Color(0xFF007AFF),
                                Color(0xFF5856D6),
                              ],
                            ),
                            borderRadius: BorderRadius.circular(12.w),
                            boxShadow: [
                              BoxShadow(
                                color: const Color(0xFF007AFF).withAlpha(77),
                                blurRadius: 20,
                                offset: const Offset(0, 10),
                              ),
                            ],
                          ),
                          child: Center(
                            child: Text(
                              'M',
                              style: GoogleFonts.inter(
                                fontSize: 12.w,
                                fontWeight: FontWeight.w700,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),

                SizedBox(height: 6.h),

                // App name
                FadeTransition(
                  opacity: _fadeAnimation,
                  child: Text(
                    'Mewayz',
                    style: GoogleFonts.inter(
                      fontSize: 32.sp,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                      letterSpacing: -0.5,
                    ),
                  ),
                ),

                SizedBox(height: 2.h),

                // Tagline
                FadeTransition(
                  opacity: _fadeAnimation,
                  child: Text(
                    'All-in-One Business Platform',
                    style: GoogleFonts.inter(
                      fontSize: 16.sp,
                      color: const Color(0xFF8E8E93),
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),

                SizedBox(height: 8.h),

                // Status indicator
                if (_isLoading && !_hasError) ...[
                  const SizedBox(
                    width: 32,
                    height: 32,
                    child: CircularProgressIndicator(
                      strokeWidth: 3,
                      valueColor: AlwaysStoppedAnimation<Color>(
                        Color(0xFF007AFF),
                      ),
                    ),
                  ),
                  SizedBox(height: 3.h),
                  Text(
                    _statusMessage,
                    style: GoogleFonts.inter(
                      fontSize: 14.sp,
                      color: const Color(0xFF8E8E93),
                    ),
                  ),
                ],

                // Error state
                if (_hasError) ...[
                  Icon(
                    Icons.error_outline,
                    size: 8.w,
                    color: const Color(0xFFFF3B30),
                  ),
                  SizedBox(height: 2.h),
                  Text(
                    'Launch Failed',
                    style: GoogleFonts.inter(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFFFF3B30),
                    ),
                  ),
                  SizedBox(height: 1.h),
                  Text(
                    _statusMessage,
                    textAlign: TextAlign.center,
                    style: GoogleFonts.inter(
                      fontSize: 14.sp,
                      color: const Color(0xFF8E8E93),
                    ),
                  ),
                  SizedBox(height: 4.h),
                  ElevatedButton(
                    onPressed: _retryLaunch,
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

                const Spacer(),

                // Bottom text
                Padding(
                  padding: EdgeInsets.only(bottom: 4.h),
                  child: Text(
                    '© 2025 Mewayz. All rights reserved.',
                    style: GoogleFonts.inter(
                      fontSize: 12.sp,
                      color: const Color(0xFF636366),
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
}