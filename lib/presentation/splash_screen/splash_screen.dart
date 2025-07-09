
import '../../core/app_export.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _logoAnimationController;
  late AnimationController _loadingAnimationController;
  late AnimationController _backgroundAnimationController;
  late Animation<double> _logoScaleAnimation;
  late Animation<double> _logoFadeAnimation;
  late Animation<double> _loadingFadeAnimation;
  late Animation<double> _backgroundAnimation;

  bool _showRetryOption = false;
  bool _isInitializing = true;
  String _initializationStatus = 'Initializing Mewayz...';

  @override
  void initState() {
    super.initState();
    _setupAnimations();
    _initializeApp();
  }

  void _setupAnimations() {
    // Logo animation controller
    _logoAnimationController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );

    // Loading animation controller
    _loadingAnimationController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );

    // Background animation controller
    _backgroundAnimationController = AnimationController(
      duration: const Duration(milliseconds: 3000),
      vsync: this,
    );

    // Logo scale animation with bounce effect
    _logoScaleAnimation = Tween<double>(
      begin: 0.5,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _logoAnimationController,
      curve: Curves.elasticOut,
    ));

    // Logo fade animation
    _logoFadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _logoAnimationController,
      curve: const Interval(0.0, 0.6, curve: Curves.easeIn),
    ));

    // Loading fade animation
    _loadingFadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _loadingAnimationController,
      curve: Curves.easeIn,
    ));

    // Background gradient animation
    _backgroundAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _backgroundAnimationController,
      curve: Curves.easeInOut,
    ));

    // Start animations
    _backgroundAnimationController.forward();
    _logoAnimationController.forward();
    
    Future.delayed(const Duration(milliseconds: 1000), () {
      if (mounted) {
        _loadingAnimationController.forward();
      }
    });
  }

  Future<void> _initializeApp() async {
    try {
      // Perform initialization steps with better error handling
      await _performInitializationSteps();

      if (mounted) {
        _navigateToNextScreen();
      }
    } catch (e) {
      if (mounted) {
        _handleInitializationError(e);
      }
    }
  }

  Future<void> _performInitializationSteps() async {
    final List<Map<String, dynamic>> initSteps = [
{'status': 'Checking system requirements...', 'duration': 400},
{'status': 'Verifying authentication...', 'duration': 600},
{'status': 'Loading workspace preferences...', 'duration': 500},
{'status': 'Fetching user configuration...', 'duration': 700},
{'status': 'Preparing cached data...', 'duration': 400},
{'status': 'Initializing services...', 'duration': 500},
{'status': 'Finalizing setup...', 'duration': 300},
];

    for (final step in initSteps) {
      if (mounted) {
        setState(() {
          _initializationStatus = step['status'] as String;
        });
        await Future.delayed(Duration(milliseconds: step['duration'] as int));
      }
    }
  }

  void _handleInitializationError(dynamic error) {
    setState(() {
      _isInitializing = false;
      _showRetryOption = true;
      _initializationStatus = 'Initialization failed. Please try again.';
    });

    // Auto-retry after 8 seconds
    Future.delayed(const Duration(seconds: 8), () {
      if (mounted && _showRetryOption) {
        _retryInitialization();
      }
    });
  }

  void _retryInitialization() {
    setState(() {
      _showRetryOption = false;
      _isInitializing = true;
      _initializationStatus = 'Retrying initialization...';
    });
    
    // Reset and restart animations
    _loadingAnimationController.reset();
    _loadingAnimationController.forward();
    
    _initializeApp();
  }

  void _navigateToNextScreen() {
    // Enhanced navigation logic with better user experience
    final bool isAuthenticated = _checkAuthenticationStatus();
    final bool isFirstTime = _checkFirstTimeUser();
    final bool hasCompletedOnboarding = _checkOnboardingStatus();

    Future.delayed(const Duration(milliseconds: 800), () {
      if (mounted) {
        if (isAuthenticated && hasCompletedOnboarding) {
          Navigator.pushReplacementNamed(context, AppRoutes.workspaceDashboard);
        } else if (isAuthenticated && !hasCompletedOnboarding) {
          Navigator.pushReplacementNamed(context, AppRoutes.goalSelectionScreen);
        } else if (isFirstTime) {
          Navigator.pushReplacementNamed(context, AppRoutes.userOnboardingScreen);
        } else {
          Navigator.pushReplacementNamed(context, AppRoutes.loginScreen);
        }
      }
    });
  }

  bool _checkAuthenticationStatus() {
    // Enhanced authentication check with proper error handling
    try {
      // In real implementation, check stored tokens/credentials
      // Return AuthService.isAuthenticated();
      return false;
    } catch (e) {
      return false;
    }
  }

  bool _checkFirstTimeUser() {
    // Enhanced first-time user check
    try {
      // In real implementation, check user preferences
      // Return StorageService.isFirstTimeUser();
      return true;
    } catch (e) {
      return true;
    }
  }

  bool _checkOnboardingStatus() {
    // Check if user has completed onboarding
    try {
      // In real implementation, check onboarding completion
      // Return OnboardingService.isCompleted();
      return false;
    } catch (e) {
      return false;
    }
  }

  @override
  void dispose() {
    _logoAnimationController.dispose();
    _loadingAnimationController.dispose();
    _backgroundAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
        systemNavigationBarColor: AppTheme.primaryBackground,
        systemNavigationBarIconBrightness: Brightness.light,
      ),
      child: Scaffold(
        body: AnimatedBuilder(
          animation: _backgroundAnimation,
          builder: (context, child) {
            return Container(
              width: 100.w,
              height: 100.h,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    AppTheme.primaryBackground,
                    AppTheme.surface,
                    AppTheme.primaryBackground,
                  ],
                  stops: [
                    0.0,
                    _backgroundAnimation.value,
                    1.0,
                  ],
                ),
              ),
              child: SafeArea(
                child: Column(
                  children: [
                    Expanded(
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            // Logo Section
                            AnimatedBuilder(
                              animation: _logoAnimationController,
                              builder: (context, child) {
                                return Transform.scale(
                                  scale: _logoScaleAnimation.value,
                                  child: Opacity(
                                    opacity: _logoFadeAnimation.value,
                                    child: _buildLogo(),
                                  ),
                                );
                              },
                            ),

                            SizedBox(height: 8.h),

                            // Loading Section
                            AnimatedBuilder(
                              animation: _loadingAnimationController,
                              builder: (context, child) {
                                return Opacity(
                                  opacity: _loadingFadeAnimation.value,
                                  child: _buildLoadingSection(),
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                    ),

                    // Bottom Section
                    _buildBottomSection(),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildLogo() {
    return Container(
      width: 45.w,
      height: 45.w,
      decoration: BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.circular(22.5.w),
        border: Border.all(
          color: AppTheme.accent.withAlpha(77),
          width: 2,
        ),
        boxShadow: [
          BoxShadow(
            color: AppTheme.accent.withAlpha(51),
            blurRadius: 30,
            spreadRadius: 5,
          ),
          BoxShadow(
            color: AppTheme.shadowDark,
            blurRadius: 10,
            spreadRadius: 1,
          ),
        ],
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 20.w,
              height: 20.w,
              decoration: BoxDecoration(
                gradient: AppTheme.primaryGradient,
                borderRadius: BorderRadius.circular(10.w),
              ),
              child: Center(
                child: Text(
                  'M',
                  style: AppTheme.darkTheme.textTheme.displayMedium?.copyWith(
                    color: AppTheme.primaryAction,
                    fontWeight: FontWeight.bold,
                    fontSize: 28.sp,
                  ),
                ),
              ),
            ),
            SizedBox(height: 2.h),
            Text(
              'MEWAYZ',
              style: AppTheme.darkTheme.textTheme.titleMedium?.copyWith(
                color: AppTheme.primaryText,
                fontWeight: FontWeight.w700,
                fontSize: 12.sp,
                letterSpacing: 3,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLoadingSection() {
    return Column(
      children: [
        // Loading Indicator
        _isInitializing
            ? CustomLoadingWidget(
                size: 8.w,
                color: AppTheme.accent,
              )
            : _showRetryOption
                ? CustomIconWidget(
                    iconName: 'error_outline',
                    color: AppTheme.error,
                    size: 32,
                  )
                : CustomIconWidget(
                    iconName: 'check_circle',
                    color: AppTheme.success,
                    size: 32,
                  ),

        SizedBox(height: 3.h),

        // Status Text
        Container(
          constraints: BoxConstraints(maxWidth: 70.w),
          child: Text(
            _initializationStatus,
            style: AppTheme.darkTheme.textTheme.bodyMedium?.copyWith(
              color: AppTheme.primaryText,
              fontSize: 14.sp,
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
          ),
        ),

        // Retry Button
        if (_showRetryOption) ...[
          SizedBox(height: 4.h),
          ElevatedButton(
            onPressed: _retryInitialization,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.accent,
              foregroundColor: AppTheme.primaryAction,
              padding: EdgeInsets.symmetric(
                horizontal: 8.w,
                vertical: 2.h,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppTheme.radiusM),
              ),
            ),
            child: Text(
              'Retry',
              style: AppTheme.darkTheme.textTheme.labelLarge?.copyWith(
                color: AppTheme.primaryAction,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildBottomSection() {
    return Container(
      padding: EdgeInsets.only(bottom: 6.h),
      child: Column(
        children: [
          Text(
            'All-in-One Business Platform',
            style: AppTheme.darkTheme.textTheme.bodyMedium?.copyWith(
              color: AppTheme.secondaryText,
              fontSize: 12.sp,
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: 1.h),
          Text(
            'Version 1.0.0',
            style: AppTheme.darkTheme.textTheme.bodySmall?.copyWith(
              color: AppTheme.secondaryText.withAlpha(153),
              fontSize: 10.sp,
            ),
          ),
        ],
      ),
    );
  }
}