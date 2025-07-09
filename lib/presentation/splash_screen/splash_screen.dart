import '../../core/app_export.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> 
    with TickerProviderStateMixin {
  late AnimationController _logoController;
  late AnimationController _textController;
  late AnimationController _progressController;
  late Animation<double> _logoAnimation;
  late Animation<double> _textAnimation;
  late Animation<double> _progressAnimation;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _navigateToNextScreen();
  }

  void _initializeAnimations() {
    _logoController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );
    
    _textController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _progressController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );

    _logoAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _logoController,
      curve: Curves.elasticOut,
    ));

    _textAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _textController,
      curve: Curves.easeInOut,
    ));

    _progressAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _progressController,
      curve: Curves.easeInOut,
    ));

    _logoController.forward();
    Future.delayed(const Duration(milliseconds: 500), () {
      _textController.forward();
    });
    Future.delayed(const Duration(milliseconds: 1000), () {
      _progressController.forward();
    });
  }

  Future<void> _navigateToNextScreen() async {
    await Future.delayed(const Duration(seconds: 3));
    
    if (!mounted) return;
    
    try {
      final authService = AuthService();
      final storageService = StorageService();
      
      // Check if user is authenticated
      if (authService.isAuthenticated) {
        // Check if onboarding is completed
        final onboardingCompleted = await storageService.getOnboardingCompleted();
        
        if (onboardingCompleted) {
          // Navigate to workspace dashboard
          Navigator.pushReplacementNamed(context, AppRoutes.workspaceDashboard);
        } else {
          // Navigate to onboarding
          Navigator.pushReplacementNamed(context, AppRoutes.onboardingScreen);
        }
      } else {
        // Navigate to login screen
        Navigator.pushReplacementNamed(context, AppRoutes.loginScreen);
      }
    } catch (e) {
      ErrorHandler.handleError(e);
      // Fallback to login screen
      Navigator.pushReplacementNamed(context, AppRoutes.loginScreen);
    }
  }

  @override
  void dispose() {
    _logoController.dispose();
    _textController.dispose();
    _progressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.primaryBackground,
      body: Semantics(
        label: 'Mewayz app is loading',
        liveRegion: true,
        child: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                AppTheme.primaryBackground,
                AppTheme.surface,
              ],
            ),
          ),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Animated Logo
                AnimatedBuilder(
                  animation: _logoAnimation,
                  builder: (context, child) {
                    return Semantics(
                      label: 'Mewayz logo',
                      child: Transform.scale(
                        scale: _logoAnimation.value,
                        child: Container(
                          width: 80,
                          height: 80,
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [
                                AppTheme.accent,
                                AppTheme.accentVariant,
                              ],
                            ),
                            borderRadius: BorderRadius.circular(AppTheme.radiusL),
                            boxShadow: [
                              BoxShadow(
                                color: AppTheme.accent.withAlpha(77),
                                blurRadius: 20,
                                offset: const Offset(0, 10),
                              ),
                            ],
                          ),
                          child: Center(
                            child: Text(
                              'M',
                              style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                                color: AppTheme.primaryAction,
                                fontWeight: FontWeight.bold,
                                fontSize: 32,
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
                
                SizedBox(height: AppTheme.spacingXl),
                
                // Animated Text
                AnimatedBuilder(
                  animation: _textAnimation,
                  builder: (context, child) {
                    return Opacity(
                      opacity: _textAnimation.value,
                      child: Transform.translate(
                        offset: Offset(0, 20 * (1 - _textAnimation.value)),
                        child: Column(
                          children: [
                            Semantics(
                              label: 'Mewayz app name',
                              child: Text(
                                'Mewayz',
                                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                                  color: AppTheme.primaryText,
                                  fontWeight: FontWeight.w600,
                                  letterSpacing: 1.5,
                                ),
                              ),
                            ),
                            SizedBox(height: AppTheme.spacingM),
                            Semantics(
                              label: 'Your Digital Marketing Hub tagline',
                              child: Text(
                                'Your Digital Marketing Hub',
                                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                  color: AppTheme.secondaryText,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
                
                SizedBox(height: AppTheme.spacingXxl),
                
                // Enhanced Loading Indicator
                AnimatedBuilder(
                  animation: _progressAnimation,
                  builder: (context, child) {
                    return Semantics(
                      label: 'Loading progress: ${(_progressAnimation.value * 100).toInt()}%',
                      liveRegion: true,
                      child: Column(
                        children: [
                          Container(
                            width: 120,
                            height: 4,
                            decoration: BoxDecoration(
                              color: AppTheme.border,
                              borderRadius: BorderRadius.circular(2),
                            ),
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: Container(
                                width: 120 * _progressAnimation.value,
                                height: 4,
                                decoration: BoxDecoration(
                                  gradient: const LinearGradient(
                                    colors: [AppTheme.accent, AppTheme.accentVariant],
                                  ),
                                  borderRadius: BorderRadius.circular(2),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: AppTheme.spacingM),
                          Text(
                            'Loading...',
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: AppTheme.secondaryText,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
                
                SizedBox(height: AppTheme.spacingXxl),
                
                // Version and Copyright
                Semantics(
                  label: 'Version and copyright information',
                  child: Column(
                    children: [
                      Text(
                        'Version 1.0.0',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AppTheme.secondaryText.withAlpha(179),
                        ),
                      ),
                      SizedBox(height: AppTheme.spacingS),
                      Text(
                        '© 2024 Mewayz Inc.',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AppTheme.secondaryText.withAlpha(179),
                        ),
                      ),
                    ],
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