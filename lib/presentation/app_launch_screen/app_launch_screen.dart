import 'dart:async';


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
  int _retryCount = 0;
  static const int _maxRetries = 3;
  Timer? _timeoutTimer;
  bool _isNavigating = false;

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
    if (_isNavigating) return;

    try {
      // Reset state for retry
      setState(() {
        _isLoading = true;
        _hasError = false;
      });

      // Set overall timeout for the entire launch sequence
      _timeoutTimer = Timer(const Duration(seconds: 30), () {
        if (mounted && !_isNavigating) {
          _handleLaunchError('Launch sequence timed out');
        }
      });

      // Step 1: Initialize core services with enhanced timeout handling
      _updateStatus('Initializing core services...');
      await Future.delayed(const Duration(milliseconds: 300));
      
      // Step 2: Enhanced authentication check with proper error handling
      _updateStatus('Checking authentication...');
      final authService = EnhancedAuthService();
      
      // Initialize with enhanced timeout and retry logic
      await _initializeServiceWithRetry(() async {
        await authService.initialize();
      }, 'Enhanced Auth Service');
      
      // Enhanced session validation
      await _validateAuthSession(authService);

      final isAuthenticated = authService.isAuthenticated;
      
      if (!isAuthenticated) {
        // Clear any stale session data before navigating
        await _clearStaleSessionData();
        await Future.delayed(const Duration(milliseconds: 500));
        _navigateToLogin();
        return;
      }

      // Step 3: Enhanced user session validation
      _updateStatus('Validating session...');
      await Future.delayed(const Duration(milliseconds: 300));
      
      final currentUser = authService.currentUser;
      
      if (currentUser == null) {
        debugPrint('No current user found, redirecting to login');
        await _clearStaleSessionData();
        _navigateToLogin();
        return;
      }

      // Step 4: Enhanced workspace membership check with improved error handling
      _updateStatus('Loading workspace data...');
      final workspaceService = WorkspaceService();
      
      await _initializeServiceWithRetry(() async {
        await workspaceService.initialize();
      }, 'Workspace Service');

      final userWorkspaces = await _executeWithTimeout(
        () => workspaceService.getUserWorkspaces(),
        const Duration(seconds: 15),
        'workspace data loading'
      );

      if (userWorkspaces.isEmpty) {
        // User is authenticated but has no workspace
        await Future.delayed(const Duration(milliseconds: 500));
        _navigateToGoalSelection();
        return;
      }

      // Step 5: Enhanced workspace configuration with validation
      _updateStatus('Configuring workspace...');
      await Future.delayed(const Duration(milliseconds: 300));
      
      final primaryWorkspace = userWorkspaces.first;
      final workspaceId = primaryWorkspace['workspace_id'] ?? primaryWorkspace['id'];
      
      if (workspaceId == null) {
        throw Exception('Invalid workspace data structure');
      }
      
      // Enhanced role verification with caching
      final userRole = await _executeWithTimeout(
        () => workspaceService.getUserRoleInWorkspace(workspaceId),
        const Duration(seconds: 10),
        'user role verification'
      );

      if (userRole == null) {
        throw Exception('Unable to determine user role in workspace');
      }

      // Step 6: Enhanced navigation with proper state management
      _updateStatus('Loading dashboard...');
      await Future.delayed(const Duration(milliseconds: 500));
      
      // Cache workspace data for faster subsequent loads
      await _cacheWorkspaceData(workspaceId);
      
      if (userWorkspaces.length > 1) {
        // User has multiple workspaces, show workspace selector
        _navigateToWorkspaceSelection();
      } else {
        // Navigate to main navigation with role-based access
        _navigateToMainNavigation();
      }

    } catch (e) {
      debugPrint('App launch error: $e');
      await _handleLaunchError(e.toString());
    } finally {
      _timeoutTimer?.cancel();
    }
  }

  /// Enhanced service initialization with improved retry logic
  Future<void> _initializeServiceWithRetry(
    Future<void> Function() serviceInit,
    String serviceName, {
    int maxRetries = 3,
  }) async {
    for (int attempt = 0; attempt <= maxRetries; attempt++) {
      try {
        await serviceInit().timeout(const Duration(seconds: 15));
        return;
      } catch (e) {
        if (attempt == maxRetries) {
          throw Exception('Failed to initialize $serviceName after ${maxRetries + 1} attempts: $e');
        }
        
        debugPrint('$serviceName initialization attempt ${attempt + 1} failed: $e');
        await Future.delayed(Duration(milliseconds: 1000 * (attempt + 1)));
      }
    }
  }

  /// Enhanced operation execution with better timeout handling
  Future<T> _executeWithTimeout<T>(
    Future<T> Function() operation,
    Duration timeout,
    String operationName,
  ) async {
    try {
      return await operation().timeout(timeout);
    } on TimeoutException {
      throw Exception('$operationName timed out after ${timeout.inSeconds} seconds');
    } catch (e) {
      throw Exception('$operationName failed: $e');
    }
  }

  /// Enhanced authentication session validation
  Future<void> _validateAuthSession(EnhancedAuthService authService) async {
    try {
      // Verify session is still valid and not expired
      final isValidSession = await authService.isUserLoggedIn();
      if (!isValidSession && authService.currentUser != null) {
        // Session expired, clear it
        await authService.signOut();
        throw Exception('Session expired');
      }
    } catch (e) {
      debugPrint('Session validation failed: $e');
      throw Exception('Session validation failed: $e');
    }
  }

  /// Clear stale session data
  Future<void> _clearStaleSessionData() async {
    try {
      final storage = StorageService();
      await storage.remove('cached_workspace_data');
      await storage.remove('last_workspace_id');
    } catch (e) {
      debugPrint('Failed to clear stale session data: $e');
    }
  }

  /// Cache workspace data for offline access
  Future<void> _cacheWorkspaceData(Map<String, dynamic> workspaceData) async {
    try {
      final storage = StorageService();
      await storage.initialize();
      
      // Create cache data structure
      final cacheData = {
        'workspace_data': workspaceData,
        'cached_at': DateTime.now().toIso8601String(),
        'cache_version': '1.0',
      };
      
      await storage.setValue('cached_workspace_data', jsonEncode(cacheData));
      debugPrint('Workspace data cached successfully');
    } catch (e) {
      debugPrint('Failed to cache workspace data: $e');
    }
  }

  void _updateStatus(String message) {
    if (mounted) {
      setState(() {
        _statusMessage = message;
      });
    }
  }

  Future<void> _handleLaunchError(String error) async {
    if (_retryCount < _maxRetries) {
      _retryCount++;
      debugPrint('Retrying app launch (attempt $_retryCount/$_maxRetries) due to: $error');
      
      // Wait before retry with exponential backoff
      await Future.delayed(Duration(seconds: _retryCount * 2));
      
      // Reset and retry
      _performAppLaunchSequence();
      return;
    }
    
    // Max retries reached, show error state
    if (mounted) {
      setState(() {
        _hasError = true;
        _statusMessage = 'Failed to initialize app';
        _isLoading = false;
      });
    }
  }

  void _navigateToLogin() {
    if (mounted && !_isNavigating) {
      _isNavigating = true;
      Navigator.pushReplacementNamed(
        context,
        AppRoutes.enhancedLoginScreen,
      );
    }
  }

  void _navigateToGoalSelection() {
    if (mounted && !_isNavigating) {
      _isNavigating = true;
      Navigator.pushReplacementNamed(
        context,
        AppRoutes.goalSelectionScreen,
      );
    }
  }

  void _navigateToWorkspaceSelection() {
    if (mounted && !_isNavigating) {
      _isNavigating = true;
      Navigator.pushReplacementNamed(
        context,
        AppRoutes.workspaceSelectorScreen,
      );
    }
  }

  void _navigateToMainNavigation() {
    if (mounted && !_isNavigating) {
      _isNavigating = true;
      Navigator.pushReplacementNamed(
        context,
        AppRoutes.mainNavigation,
      );
    }
  }

  void _retryLaunch() {
    _retryCount = 0; // Reset retry count for manual retry
    _isNavigating = false; // Reset navigation flag
    _performAppLaunchSequence();
  }

  @override
  void dispose() {
    _timeoutTimer?.cancel();
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
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8.w),
                    child: Text(
                      _statusMessage,
                      textAlign: TextAlign.center,
                      style: GoogleFonts.inter(
                        fontSize: 14.sp,
                        color: const Color(0xFF8E8E93),
                      ),
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      TextButton(
                        onPressed: _navigateToLogin,
                        child: Text(
                          'Go to Login',
                          style: GoogleFonts.inter(
                            fontSize: 16.sp,
                            color: const Color(0xFF8E8E93),
                          ),
                        ),
                      ),
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