import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

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
  late Animation<double> _logoScaleAnimation;
  late Animation<double> _logoFadeAnimation;
  late Animation<double> _loadingFadeAnimation;

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
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    // Loading animation controller
    _loadingAnimationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    // Logo scale animation
    _logoScaleAnimation = Tween<double>(
      begin: 0.8,
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

    // Start animations
    _logoAnimationController.forward();
    Future.delayed(const Duration(milliseconds: 800), () {
      if (mounted) {
        _loadingAnimationController.forward();
      }
    });
  }

  Future<void> _initializeApp() async {
    try {
      // Simulate initialization steps
      await _performInitializationSteps();

      if (mounted) {
        _navigateToNextScreen();
      }
    } catch (e) {
      if (mounted) {
        _handleInitializationError();
      }
    }
  }

  Future<void> _performInitializationSteps() async {
    final List<Map<String, dynamic>> initSteps = [
      {'status': 'Checking authentication...', 'duration': 600},
      {'status': 'Loading workspace preferences...', 'duration': 500},
      {'status': 'Fetching configuration...', 'duration': 700},
      {'status': 'Preparing cached data...', 'duration': 400},
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

  void _handleInitializationError() {
    setState(() {
      _isInitializing = false;
      _showRetryOption = true;
      _initializationStatus = 'Failed to initialize. Please try again.';
    });

    // Auto-hide retry option after 5 seconds
    Future.delayed(const Duration(seconds: 5), () {
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
    _initializeApp();
  }

  void _navigateToNextScreen() {
    // Simulate authentication check
    final bool isAuthenticated = _checkAuthenticationStatus();
    final bool isFirstTime = _checkFirstTimeUser();

    Future.delayed(const Duration(milliseconds: 500), () {
      if (mounted) {
        if (isAuthenticated) {
          Navigator.pushReplacementNamed(context, '/workspace-dashboard');
        } else if (isFirstTime) {
          // For now, navigate to login as onboarding is not implemented
          Navigator.pushReplacementNamed(context, '/login-screen');
        } else {
          Navigator.pushReplacementNamed(context, '/login-screen');
        }
      }
    });
  }

  bool _checkAuthenticationStatus() {
    // Mock authentication check
    // In real implementation, check stored tokens/credentials
    return false;
  }

  bool _checkFirstTimeUser() {
    // Mock first-time user check
    // In real implementation, check user preferences
    return true;
  }

  @override
  void dispose() {
    _logoAnimationController.dispose();
    _loadingAnimationController.dispose();
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
        backgroundColor: AppTheme.primaryBackground,
        body: SafeArea(
          child: SizedBox(
            width: 100.w,
            height: 100.h,
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
        ),
      ),
    );
  }

  Widget _buildLogo() {
    return Container(
      width: 40.w,
      height: 40.w,
      decoration: BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.circular(20.w),
        border: Border.all(
          color: AppTheme.accent.withValues(alpha: 0.3),
          width: 2,
        ),
        boxShadow: [
          BoxShadow(
            color: AppTheme.accent.withValues(alpha: 0.2),
            blurRadius: 20,
            spreadRadius: 5,
          ),
        ],
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'M',
              style: AppTheme.darkTheme.textTheme.displayMedium?.copyWith(
                color: AppTheme.accent,
                fontWeight: FontWeight.bold,
                fontSize: 24.sp,
              ),
            ),
            Text(
              'MEWAYZ',
              style: AppTheme.darkTheme.textTheme.labelMedium?.copyWith(
                color: AppTheme.primaryText,
                fontWeight: FontWeight.w600,
                fontSize: 8.sp,
                letterSpacing: 2,
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
            ? SizedBox(
                width: 6.w,
                height: 6.w,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    AppTheme.primaryText,
                  ),
                ),
              )
            : _showRetryOption
                ? CustomIconWidget(
                    iconName: 'error_outline',
                    color: AppTheme.error,
                    size: 6.w,
                  )
                : CustomIconWidget(
                    iconName: 'check_circle',
                    color: AppTheme.success,
                    size: 6.w,
                  ),

        SizedBox(height: 3.h),

        // Status Text
        Text(
          _initializationStatus,
          style: AppTheme.darkTheme.textTheme.bodyMedium?.copyWith(
            color: AppTheme.primaryText,
            fontSize: 12.sp,
          ),
          textAlign: TextAlign.center,
        ),

        // Retry Button
        if (_showRetryOption) ...[
          SizedBox(height: 3.h),
          TextButton(
            onPressed: _retryInitialization,
            style: TextButton.styleFrom(
              foregroundColor: AppTheme.accent,
              padding: EdgeInsets.symmetric(
                horizontal: 6.w,
                vertical: 1.5.h,
              ),
            ),
            child: Text(
              'Retry',
              style: AppTheme.darkTheme.textTheme.labelLarge?.copyWith(
                color: AppTheme.accent,
                fontSize: 12.sp,
              ),
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildBottomSection() {
    return Padding(
      padding: EdgeInsets.only(bottom: 4.h),
      child: Column(
        children: [
          Text(
            'All-in-One Business Platform',
            style: AppTheme.darkTheme.textTheme.bodySmall?.copyWith(
              color: AppTheme.secondaryText,
              fontSize: 10.sp,
            ),
          ),
          SizedBox(height: 1.h),
          Text(
            'Version 1.0.0',
            style: AppTheme.darkTheme.textTheme.bodySmall?.copyWith(
              color: AppTheme.secondaryText.withValues(alpha: 0.6),
              fontSize: 9.sp,
            ),
          ),
        ],
      ),
    );
  }
}
