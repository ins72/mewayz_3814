
import '../../core/app_export.dart';
import './widgets/enhanced_password_strength_indicator_widget.dart';
import './widgets/enhanced_registration_form_widget.dart';
import './widgets/enhanced_social_registration_widget.dart';
import './widgets/enhanced_terms_and_privacy_widget.dart';

class EnhancedRegistrationScreen extends StatefulWidget {
  const EnhancedRegistrationScreen({Key? key}) : super(key: key);

  @override
  State<EnhancedRegistrationScreen> createState() => _EnhancedRegistrationScreenState();
}

class _EnhancedRegistrationScreenState extends State<EnhancedRegistrationScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  final FocusNode _fullNameFocusNode = FocusNode();
  final FocusNode _emailFocusNode = FocusNode();
  final FocusNode _passwordFocusNode = FocusNode();
  final FocusNode _confirmPasswordFocusNode = FocusNode();

  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;
  bool _isLoading = false;
  bool _acceptTerms = false;
  bool _acceptPrivacy = false;

  String? _fullNameError;
  String? _emailError;
  String? _passwordError;
  String? _confirmPasswordError;
  String? _generalError;

  int _passwordStrength = 0;
  String _passwordStrengthText = '';

  late AuthService _authService;

  @override
  void initState() {
    super.initState();
    _authService = AuthService();
    _setupFocusListeners();
    _setupPasswordListener();
  }

  @override
  void dispose() {
    _fullNameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _fullNameFocusNode.dispose();
    _emailFocusNode.dispose();
    _passwordFocusNode.dispose();
    _confirmPasswordFocusNode.dispose();
    super.dispose();
  }

  void _setupPasswordListener() {
    _passwordController.addListener(() {
      setState(() {
        _passwordStrength = _getPasswordStrength();
        _passwordStrengthText = _getPasswordStrengthText();
      });
    });
  }

  void _setupFocusListeners() {
    _fullNameFocusNode.addListener(() {
      if (!_fullNameFocusNode.hasFocus && _fullNameController.text.isNotEmpty) {
        _validateFullName();
      }
    });

    _emailFocusNode.addListener(() {
      if (!_emailFocusNode.hasFocus && _emailController.text.isNotEmpty) {
        _validateEmail();
      }
    });

    _passwordFocusNode.addListener(() {
      if (!_passwordFocusNode.hasFocus && _passwordController.text.isNotEmpty) {
        _validatePassword();
      }
    });

    _confirmPasswordFocusNode.addListener(() {
      if (!_confirmPasswordFocusNode.hasFocus && _confirmPasswordController.text.isNotEmpty) {
        _validateConfirmPassword();
      }
    });
  }

  bool _validateFullName() {
    final fullName = _fullNameController.text.trim();
    if (fullName.isEmpty) {
      setState(() {
        _fullNameError = 'Full name is required';
      });
      return false;
    }

    if (fullName.length < 2) {
      setState(() {
        _fullNameError = 'Full name must be at least 2 characters';
      });
      return false;
    }

    final nameParts = fullName.split(' ').where((part) => part.isNotEmpty).toList();
    if (nameParts.length < 2) {
      setState(() {
        _fullNameError = 'Please enter both first and last name';
      });
      return false;
    }

    setState(() {
      _fullNameError = null;
    });
    return true;
  }

  bool _validateEmail() {
    final email = _emailController.text.trim();
    if (email.isEmpty) {
      setState(() {
        _emailError = 'Email is required';
      });
      return false;
    }

    final emailRegex = RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]+$');
    if (!emailRegex.hasMatch(email)) {
      setState(() {
        _emailError = 'Please enter a valid email address';
      });
      return false;
    }

    setState(() {
      _emailError = null;
    });
    return true;
  }

  bool _validatePassword() {
    final password = _passwordController.text;
    if (password.isEmpty) {
      setState(() {
        _passwordError = 'Password is required';
      });
      return false;
    }

    if (password.length < 8) {
      setState(() {
        _passwordError = 'Password must be at least 8 characters';
      });
      return false;
    }

    if (!RegExp(r'[A-Z]').hasMatch(password)) {
      setState(() {
        _passwordError = 'Password must contain at least one uppercase letter';
      });
      return false;
    }

    if (!RegExp(r'[a-z]').hasMatch(password)) {
      setState(() {
        _passwordError = 'Password must contain at least one lowercase letter';
      });
      return false;
    }

    if (!RegExp(r'[0-9]').hasMatch(password)) {
      setState(() {
        _passwordError = 'Password must contain at least one number';
      });
      return false;
    }

    if (!RegExp(r'[!@#$%^&*(),.?":{}|<>_\-+=\[\]\\\/~`]').hasMatch(password)) {
      setState(() {
        _passwordError = 'Password must contain at least one special character';
      });
      return false;
    }

    setState(() {
      _passwordError = null;
    });
    return true;
  }

  bool _validateConfirmPassword() {
    final confirmPassword = _confirmPasswordController.text;
    if (confirmPassword.isEmpty) {
      setState(() {
        _confirmPasswordError = 'Please confirm your password';
      });
      return false;
    }

    if (confirmPassword != _passwordController.text) {
      setState(() {
        _confirmPasswordError = 'Passwords do not match';
      });
      return false;
    }

    setState(() {
      _confirmPasswordError = null;
    });
    return true;
  }

  bool get _isFormValid {
    return _fullNameController.text.isNotEmpty &&
        _emailController.text.isNotEmpty &&
        _passwordController.text.isNotEmpty &&
        _confirmPasswordController.text.isNotEmpty &&
        _fullNameError == null &&
        _emailError == null &&
        _passwordError == null &&
        _confirmPasswordError == null &&
        _acceptTerms &&
        _acceptPrivacy;
  }

  Future<void> _handleRegister() async {
    if (!_validateFullName() || 
        !_validateEmail() || 
        !_validatePassword() || 
        !_validateConfirmPassword()) {
      return;
    }

    if (!_acceptTerms || !_acceptPrivacy) {
      setState(() {
        _generalError = 'Please accept both Terms of Service and Privacy Policy to continue';
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _generalError = null;
    });

    try {
      final fullName = _fullNameController.text.trim();
      
      final response = await _authService.signUp(
        email: _emailController.text.trim(),
        password: _passwordController.text,
        fullName: fullName,
      );

      if (response?.user != null) {
        HapticFeedback.lightImpact();

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                CustomIconWidget(
                  iconName: 'check_circle',
                  color: Colors.green,
                  size: 20,
                ),
                SizedBox(width: 2.w),
                Expanded(
                  child: Text(
                    'Registration successful! Please check your email to verify your account.',
                    style: AppTheme.darkTheme.textTheme.bodyMedium?.copyWith(
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
            backgroundColor: Colors.green,
            duration: const Duration(seconds: 5),
            action: SnackBarAction(
              label: 'OK',
              textColor: Colors.white,
              onPressed: () {
                ScaffoldMessenger.of(context).hideCurrentSnackBar();
              },
            ),
          ),
        );

        // Navigate to email verification screen instead of directly to onboarding
        Navigator.pushReplacementNamed(
          context, 
          AppRoutes.emailVerificationScreen,
          arguments: {
            'email': _emailController.text.trim(),
            'fullName': fullName,
          },
        );
      } else {
        setState(() {
          _generalError = 'Registration failed. Please try again.';
        });
      }
    } on Exception catch (e) {
      String errorMessage = 'Registration failed';
      
      if (e.toString().contains('already registered')) {
        errorMessage = 'An account with this email already exists. Please try logging in instead.';
      } else if (e.toString().contains('weak password')) {
        errorMessage = 'Password is too weak. Please use a stronger password.';
      } else if (e.toString().contains('invalid email')) {
        errorMessage = 'Please enter a valid email address.';
      } else {
        errorMessage = e.toString();
      }
      
      setState(() {
        _generalError = errorMessage;
      });
    } catch (e) {
      String errorMessage = 'Registration failed. Please try again.';
      
      // Enhanced error handling for specific error types
      if (e.toString().contains('already registered') || e.toString().contains('already exists')) {
        errorMessage = 'An account with this email already exists. Please try logging in instead.';
      } else if (e.toString().contains('JSON') || e.toString().contains('SyntaxError')) {
        errorMessage = 'Server response error. Please try again.';
      } else if (e.toString().contains('<!DOCTYPE')) {
        errorMessage = 'Server configuration error. Please try again later.';
      } else if (e.toString().contains('Network') || e.toString().contains('Connection')) {
        errorMessage = 'Network error. Please check your connection.';
      } else if (e.toString().contains('Timeout')) {
        errorMessage = 'Request timeout. Please try again.';
      } else if (e.toString().contains('weak password')) {
        errorMessage = 'Password is too weak. Please use a stronger password.';
      } else if (e.toString().contains('invalid email')) {
        errorMessage = 'Please enter a valid email address.';
      }
      
      setState(() {
        _generalError = errorMessage;
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _handleGoogleSignUp() async {
    if (!_acceptTerms || !_acceptPrivacy) {
      setState(() {
        _generalError = 'Please accept both Terms of Service and Privacy Policy to continue';
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _generalError = null;
    });

    try {
      final response = await _authService.signInWithGoogle();
      
      if (response?.user != null) {
        HapticFeedback.lightImpact();
        Navigator.pushReplacementNamed(context, AppRoutes.enhancedWorkspaceDashboard);
      } else {
        setState(() {
          _generalError = 'Google sign up was cancelled';
        });
      }
    } catch (e) {
      setState(() {
        _generalError = 'Google sign up failed: ${e.toString()}';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _handleAppleSignUp() async {
    if (!_acceptTerms || !_acceptPrivacy) {
      setState(() {
        _generalError = 'Please accept both Terms of Service and Privacy Policy to continue';
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _generalError = null;
    });

    try {
      final response = await _authService.signInWithApple();
      
      if (response?.user != null) {
        HapticFeedback.lightImpact();
        Navigator.pushReplacementNamed(context, AppRoutes.enhancedWorkspaceDashboard);
      } else {
        setState(() {
          _generalError = 'Apple sign up was cancelled';
        });
      }
    } catch (e) {
      setState(() {
        _generalError = 'Apple sign up failed: ${e.toString()}';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _handleTermsOfServiceTap() async {
    final result = await Navigator.pushNamed(
      context,
      AppRoutes.termsOfServiceScreen,
    );
    
    if (result == true) {
      setState(() {
        _acceptTerms = true;
      });
    }
  }

  void _handlePrivacyPolicyTap() async {
    final result = await Navigator.pushNamed(
      context,
      AppRoutes.privacyPolicyScreen,
    );
    
    if (result == true) {
      setState(() {
        _acceptPrivacy = true;
      });
    }
  }

  void _handleSignIn() {
    Navigator.pushReplacementNamed(context, AppRoutes.loginScreen);
  }

  int _getPasswordStrength() {
    final password = _passwordController.text;
    if (password.isEmpty) return 0;
    
    int strength = 0;
    
    if (password.length >= 8) strength++;
    if (RegExp(r'[A-Z]').hasMatch(password)) strength++;
    if (RegExp(r'[a-z]').hasMatch(password)) strength++;
    if (RegExp(r'[0-9]').hasMatch(password)) strength++;
    if (RegExp(r'[!@#$%^&*(),.?":{}|<>_\-+=\[\]\\\/~`]').hasMatch(password)) strength++;
    
    return strength;
  }

  String _getPasswordStrengthText() {
    final strength = _getPasswordStrength();
    switch (strength) {
      case 0:
        return '';
      case 1:
        return 'Very Weak';
      case 2:
        return 'Weak';
      case 3:
        return 'Fair';
      case 4:
        return 'Good';
      case 5:
        return 'Strong';
      default:
        return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF101010),
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Color(0xFF101010),
                Color(0xFF0A0A0A),
              ],
            ),
          ),
          child: SafeArea(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 4.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  SizedBox(height: 4.h),

                  // Mewayz Logo
                  Center(
                    child: Column(
                      children: [
                        Container(
                          width: 16.w,
                          height: 16.w,
                          decoration: BoxDecoration(
                            color: const Color(0xFF007AFF),
                            borderRadius: BorderRadius.circular(3.w),
                          ),
                          child: Center(
                            child: Text(
                              'M',
                              style: GoogleFonts.inter(
                                fontSize: 24.sp,
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 2.h),
                        Text(
                          'Create Account',
                          style: GoogleFonts.inter(
                            fontSize: 24.sp,
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        SizedBox(height: 1.h),
                        Text(
                          'Join thousands of businesses using Mewayz',
                          style: GoogleFonts.inter(
                            fontSize: 14.sp,
                            color: const Color(0xFF8E8E93),
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: 6.h),

                  // Registration Form
                  EnhancedRegistrationFormWidget(
                    formKey: _formKey,
                    fullNameController: _fullNameController,
                    fullNameFocusNode: _fullNameFocusNode,
                    emailController: _emailController,
                    passwordController: _passwordController,
                    confirmPasswordController: _confirmPasswordController,
                    emailFocusNode: _emailFocusNode,
                    passwordFocusNode: _passwordFocusNode,
                    confirmPasswordFocusNode: _confirmPasswordFocusNode,
                    isPasswordVisible: _isPasswordVisible,
                    isConfirmPasswordVisible: _isConfirmPasswordVisible,
                    fullNameError: _fullNameError,
                    emailError: _emailError,
                    passwordError: _passwordError,
                    confirmPasswordError: _confirmPasswordError,
                    generalError: _generalError,
                    isLoading: _isLoading,
                    isFormValid: _isFormValid,
                    onPasswordVisibilityToggle: () {
                      setState(() {
                        _isPasswordVisible = !_isPasswordVisible;
                      });
                    },
                    onConfirmPasswordVisibilityToggle: () {
                      setState(() {
                        _isConfirmPasswordVisible = !_isConfirmPasswordVisible;
                      });
                    },
                    onRegister: _handleRegister,
                  ),

                  SizedBox(height: 2.h),

                  // Enhanced Password Strength Indicator
                  EnhancedPasswordStrengthIndicatorWidget(
                    strength: _passwordStrength,
                    strengthText: _passwordStrengthText,
                  ),

                  SizedBox(height: 4.h),

                  // Enhanced Terms and Privacy
                  EnhancedTermsAndPrivacyWidget(
                    acceptTerms: _acceptTerms,
                    acceptPrivacy: _acceptPrivacy,
                    onTermsChanged: (value) {
                      setState(() {
                        _acceptTerms = value ?? false;
                        _generalError = null;
                      });
                    },
                    onPrivacyChanged: (value) {
                      setState(() {
                        _acceptPrivacy = value ?? false;
                        _generalError = null;
                      });
                    },
                    onTermsOfServiceTap: _handleTermsOfServiceTap,
                    onPrivacyPolicyTap: _handlePrivacyPolicyTap,
                  ),

                  SizedBox(height: 4.h),

                  // Enhanced Social Registration
                  EnhancedSocialRegistrationWidget(
                    onGoogleSignUp: _handleGoogleSignUp,
                    onAppleSignUp: _handleAppleSignUp,
                  ),

                  SizedBox(height: 4.h),

                  // Sign In Link
                  Center(
                    child: GestureDetector(
                      onTap: _handleSignIn,
                      child: RichText(
                        text: TextSpan(
                          text: 'Already have an account? ',
                          style: GoogleFonts.inter(
                            fontSize: 14.sp,
                            color: const Color(0xFF7B7B7B),
                          ),
                          children: [
                            TextSpan(
                              text: 'Login',
                              style: GoogleFonts.inter(
                                fontSize: 14.sp,
                                color: const Color(0xFF007AFF),
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                  SizedBox(height: 4.h),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}