
import '../../core/app_export.dart';

class EnhancedSplashScreen extends StatefulWidget {
  const EnhancedSplashScreen({super.key});

  @override
  State<EnhancedSplashScreen> createState() => _EnhancedSplashScreenState();
}

class _EnhancedSplashScreenState extends State<EnhancedSplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _scaleController;
  late AnimationController _fadeController;
  late AnimationController _pulseController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;
  late Animation<double> _pulseAnimation;

  bool _hasError = false;
  bool _showRetryButton = false;
  String _errorMessage = '';

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _startInitialization();
  }

  void _initializeAnimations() {
    _scaleController = AnimationController(
      duration: const Duration(milliseconds: 2500),
      vsync: this,
    );
    
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 2500),
      vsync: this,
    );
    
    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(
      begin: 0.5,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _scaleController,
      curve: Curves.easeInOut,
    ));

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeInOut,
    ));

    _pulseAnimation = Tween<double>(
      begin: 1.0,
      end: 1.1,
    ).animate(CurvedAnimation(
      parent: _pulseController,
      curve: Curves.easeInOut,
    ));
  }

  void _startInitialization() async {
    try {
      // Start animations
      _scaleController.forward();
      _fadeController.forward();
      
      // Wait for logo animation to complete
      await Future.delayed(const Duration(milliseconds: 2500));
      
      // Start pulsing animation
      _pulseController.repeat(reverse: true);
      
      // Perform initialization tasks
      await _performInitializationTasks();
      
      // Navigate based on authentication state
      _navigateToNextScreen();
    } catch (e) {
      _handleError(e.toString());
    }
  }

  Future<void> _performInitializationTasks() async {
    try {
      // Simulate initialization tasks
      await Future.wait([
        _validateAuthToken(),
        _loadWorkspacePreferences(),
        _fetchEssentialConfiguration(),
        _initializeCaching(),
      ]);
    } catch (e) {
      throw Exception('Initialization failed: $e');
    }
  }

  Future<void> _validateAuthToken() async {
    await Future.delayed(const Duration(milliseconds: 800));
    // Simulate token validation
  }

  Future<void> _loadWorkspacePreferences() async {
    await Future.delayed(const Duration(milliseconds: 600));
    // Simulate workspace loading
  }

  Future<void> _fetchEssentialConfiguration() async {
    await Future.delayed(const Duration(milliseconds: 1000));
    // Simulate config fetching
  }

  Future<void> _initializeCaching() async {
    await Future.delayed(const Duration(milliseconds: 700));
    // Simulate cache initialization
  }

  void _navigateToNextScreen() {
    if (!mounted) return;
    
    // Add haptic feedback
    HapticFeedback.lightImpact();
    
    // Navigate to appropriate screen
    Navigator.pushReplacementNamed(
      context,
      AppRoutes.enhancedLoginScreen,
    );
  }

  void _handleError(String error) {
    setState(() {
      _hasError = true;
      _errorMessage = error;
    });
    
    // Show retry button after 5 seconds
    Future.delayed(const Duration(seconds: 5), () {
      if (mounted) {
        setState(() {
          _showRetryButton = true;
        });
      }
    });
  }

  void _retry() {
    setState(() {
      _hasError = false;
      _showRetryButton = false;
      _errorMessage = '';
    });
    
    // Reset animations
    _scaleController.reset();
    _fadeController.reset();
    _pulseController.reset();
    
    // Restart initialization
    _startInitialization();
  }

  @override
  void dispose() {
    _scaleController.dispose();
    _fadeController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF101010),
      body: SafeArea(
        child: Container(
          width: 100.w,
          height: 100.h,
          decoration: const BoxDecoration(
            color: Color(0xFF101010),
          ),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Logo with animations
                AnimatedBuilder(
                  animation: Listenable.merge([
                    _scaleAnimation,
                    _fadeAnimation,
                    _pulseAnimation,
                  ]),
                  builder: (context, child) {
                    return Transform.scale(
                      scale: _scaleAnimation.value * 
                             (_pulseController.isAnimating ? _pulseAnimation.value : 1.0),
                      child: Opacity(
                        opacity: _fadeAnimation.value,
                        child: SvgPicture.asset(
                          'assets/images/img_app_logo.svg',
                          width: 80.w,
                          height: 15.h,
                          colorFilter: const ColorFilter.mode(
                            Color(0xFFF1F1F1),
                            BlendMode.srcIn,
                          ),
                        ),
                      ),
                    );
                  },
                ),
                
                SizedBox(height: 8.h),
                
                // Loading indicator or error state
                if (_hasError) ...[
                  Icon(
                    Icons.error_outline,
                    color: const Color(0xFFFF6B6B),
                    size: 6.w,
                  ),
                  SizedBox(height: 2.h),
                  Text(
                    'Connection failed',
                    style: GoogleFonts.inter(
                      color: const Color(0xFFFF6B6B),
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(height: 1.h),
                  Text(
                    'Please check your internet connection',
                    style: GoogleFonts.inter(
                      color: const Color(0xFF7B7B7B),
                      fontSize: 12.sp,
                    ),
                  ),
                  if (_showRetryButton) ...[
                    SizedBox(height: 4.h),
                    ElevatedButton(
                      onPressed: _retry,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFF1F1F1),
                        foregroundColor: const Color(0xFF101010),
                        padding: EdgeInsets.symmetric(
                          horizontal: 8.w,
                          vertical: 1.5.h,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
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
                  ],
                ] else ...[
                  // Loading indicator
                  SizedBox(
                    width: 6.w,
                    height: 6.w,
                    child: CircularProgressIndicator(
                      strokeWidth: 2.0,
                      valueColor: const AlwaysStoppedAnimation<Color>(
                        Color(0xFFF1F1F1),
                      ),
                    ),
                  ),
                  SizedBox(height: 3.h),
                  Text(
                    'Loading...',
                    style: GoogleFonts.inter(
                      color: const Color(0xFFF1F1F1),
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}