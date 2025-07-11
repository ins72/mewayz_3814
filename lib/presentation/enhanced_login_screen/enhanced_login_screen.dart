import '../../core/app_export.dart';
import '../../services/enhanced_auth_service.dart';
import './widgets/enhanced_biometric_auth_widget.dart';
import './widgets/enhanced_login_form_widget.dart';
import './widgets/enhanced_two_factor_modal_widget';

class EnhancedLoginScreen extends StatefulWidget {
  const EnhancedLoginScreen({super.key});

  @override
  State<EnhancedLoginScreen> createState() => _EnhancedLoginScreenState();
}

class _EnhancedLoginScreenState extends State<EnhancedLoginScreen>
    with TickerProviderStateMixin {
  late AnimationController _fadeController;
  late AnimationController _slideController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  bool _showTwoFactorModal = false;
  bool _isLoading = false;
  String _errorMessage = '';
  final EnhancedAuthService _authService = EnhancedAuthService();

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _startEntryAnimation();
    _initializeAuthService();
  }

  void _initializeAnimations() {
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );
    
    _slideController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeInOut,
    ));

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _slideController,
      curve: Curves.easeOutCubic,
    ));
  }

  void _initializeAuthService() async {
    try {
      await _authService.initialize();
      
      // Check if user is already authenticated
      if (_authService.isAuthenticated) {
        _navigateToWorkspace();
      }
    } catch (e) {
      debugPrint('Auth service initialization error: $e');
    }
  }

  void _startEntryAnimation() {
    Future.delayed(const Duration(milliseconds: 300), () {
      if (mounted) {
        _fadeController.forward();
        _slideController.forward();
      }
    });
  }

  void _handleLogin(String email, String password) async {
    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });

    try {
      final response = await _authService.signInWithPassword(
        email: email,
        password: password,
      );
      
      if (response != null) {
        // Success - add haptic feedback
        HapticFeedback.lightImpact();
        _navigateToWorkspace();
      } else {
        throw Exception('Sign in failed');
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Login failed. Please check your credentials.';
        _isLoading = false;
      });
      
      // Error haptic feedback
      HapticFeedback.heavyImpact();
    }
  }

  void _handleBiometricAuth() async {
    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });

    try {
      // Success haptic feedback
      HapticFeedback.lightImpact();
      _navigateToWorkspace();
    } catch (e) {
      setState(() {
        _errorMessage = 'Biometric authentication failed.';
        _isLoading = false;
      });
      
      HapticFeedback.heavyImpact();
    }
  }

  void _handleTwoFactorComplete() {
    setState(() {
      _showTwoFactorModal = false;
    });
    
    // Success haptic feedback
    HapticFeedback.lightImpact();
    _navigateToWorkspace();
  }

  void _navigateToWorkspace() {
    if (mounted) {
      Navigator.pushReplacementNamed(
        context,
        AppRoutes.enhancedWorkspaceDashboard,
      );
    }
  }

  void _handleForgotPassword() {
    Navigator.pushNamed(context, AppRoutes.forgotPasswordScreen);
  }

  void _handleSignUp() {
    Navigator.pushNamed(context, AppRoutes.enhancedRegistrationScreen);
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _slideController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF101010),
      body: SafeArea(
        child: Stack(
          children: [
            // Main content
            AnimatedBuilder(
              animation: Listenable.merge([_fadeAnimation, _slideAnimation]),
              builder: (context, child) {
                return Opacity(
                  opacity: _fadeAnimation.value,
                  child: SlideTransition(
                    position: _slideAnimation,
                    child: _buildMainContent(),
                  ),
                );
              },
            ),
            
            // Two Factor Modal
            if (_showTwoFactorModal)
              EnhancedTwoFactorModalWidget(
                onComplete: _handleTwoFactorComplete,
                onCancel: () {
                  setState(() {
                    _showTwoFactorModal = false;
                  });
                },
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildMainContent() {
    return SingleChildScrollView(
      physics: const ClampingScrollPhysics(),
      child: Container(
        width: 100.w,
        constraints: BoxConstraints(
          minHeight: 100.h,
        ),
        padding: EdgeInsets.symmetric(horizontal: 6.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 8.h),
            
            // Logo with subtle animation
            Transform.scale(
              scale: 0.8,
              child: SvgPicture.asset(
                'assets/images/img_app_logo.svg',
                width: 60.w,
                height: 12.h,
                colorFilter: const ColorFilter.mode(
                  Color(0xFFF1F1F1),
                  BlendMode.srcIn,
                ),
              ),
            ),
            
            SizedBox(height: 6.h),
            
            // Welcome text
            Text(
              'Welcome Back',
              style: GoogleFonts.inter(
                color: const Color(0xFFF1F1F1),
                fontSize: 24.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
            
            SizedBox(height: 1.h),
            
            Text(
              'Sign in to continue to your workspace',
              style: GoogleFonts.inter(
                color: const Color(0xFF7B7B7B),
                fontSize: 14.sp,
                fontWeight: FontWeight.w400,
              ),
            ),
            
            SizedBox(height: 4.h),
            
            // Error message
            if (_errorMessage.isNotEmpty) ...[
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(3.w),
                decoration: BoxDecoration(
                  color: const Color(0xFFFF6B6B).withAlpha(26),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: const Color(0xFFFF6B6B).withAlpha(77),
                  ),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.error_outline,
                      color: const Color(0xFFFF6B6B),
                      size: 5.w,
                    ),
                    SizedBox(width: 3.w),
                    Expanded(
                      child: Text(
                        _errorMessage,
                        style: GoogleFonts.inter(
                          color: const Color(0xFFFF6B6B),
                          fontSize: 13.sp,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 3.h),
            ],
            
            // Login Form
            EnhancedLoginFormWidget(
              onLogin: _handleLogin,
              onForgotPassword: _handleForgotPassword,
              isLoading: _isLoading,
            ),
            
            SizedBox(height: 4.h),
            
            // Biometric Authentication
            EnhancedBiometricAuthWidget(
              onBiometricAuth: _handleBiometricAuth,
              isLoading: _isLoading,
            ),
            
            SizedBox(height: 6.h),
            
            // Sign up link
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'New user? ',
                  style: GoogleFonts.inter(
                    color: const Color(0xFF7B7B7B),
                    fontSize: 14.sp,
                  ),
                ),
                GestureDetector(
                  onTap: _handleSignUp,
                  child: Text(
                    'Sign Up',
                    style: GoogleFonts.inter(
                      color: const Color(0xFFF1F1F1),
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w600,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ),
              ],
            ),
            
            SizedBox(height: 4.h),
          ],
        ),
      ),
    );
  }
}