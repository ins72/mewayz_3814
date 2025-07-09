
import '../../core/app_export.dart';
import './widgets/password_strength_indicator_widget.dart';
import './widgets/registration_form_widget.dart';
import './widgets/social_registration_widget.dart';
import './widgets/terms_and_privacy_widget.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  final FocusNode _firstNameFocusNode = FocusNode();
  final FocusNode _lastNameFocusNode = FocusNode();
  final FocusNode _emailFocusNode = FocusNode();
  final FocusNode _passwordFocusNode = FocusNode();
  final FocusNode _confirmPasswordFocusNode = FocusNode();

  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;
  bool _isLoading = false;
  bool _acceptTerms = false;
  bool _acceptPrivacy = false;
  bool _acceptNewsletter = false;

  String? _firstNameError;
  String? _lastNameError;
  String? _emailError;
  String? _passwordError;
  String? _confirmPasswordError;
  String? _generalError;

  late AuthService _authService;

  @override
  void initState() {
    super.initState();
    _authService = AuthService();
    _setupFocusListeners();
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _firstNameFocusNode.dispose();
    _lastNameFocusNode.dispose();
    _emailFocusNode.dispose();
    _passwordFocusNode.dispose();
    _confirmPasswordFocusNode.dispose();
    super.dispose();
  }

  void _setupFocusListeners() {
    _firstNameFocusNode.addListener(() {
      if (!_firstNameFocusNode.hasFocus && _firstNameController.text.isNotEmpty) {
        _validateFirstName();
      }
    });

    _lastNameFocusNode.addListener(() {
      if (!_lastNameFocusNode.hasFocus && _lastNameController.text.isNotEmpty) {
        _validateLastName();
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

  bool _validateFirstName() {
    final firstName = _firstNameController.text.trim();
    if (firstName.isEmpty) {
      setState(() {
        _firstNameError = 'First name is required';
      });
      return false;
    }

    if (firstName.length < 2) {
      setState(() {
        _firstNameError = 'First name must be at least 2 characters';
      });
      return false;
    }

    setState(() {
      _firstNameError = null;
    });
    return true;
  }

  bool _validateLastName() {
    final lastName = _lastNameController.text.trim();
    if (lastName.isEmpty) {
      setState(() {
        _lastNameError = 'Last name is required';
      });
      return false;
    }

    if (lastName.length < 2) {
      setState(() {
        _lastNameError = 'Last name must be at least 2 characters';
      });
      return false;
    }

    setState(() {
      _lastNameError = null;
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

    // Check for at least one uppercase letter
    if (!RegExp(r'[A-Z]').hasMatch(password)) {
      setState(() {
        _passwordError = 'Password must contain at least one uppercase letter';
      });
      return false;
    }

    // Check for at least one lowercase letter
    if (!RegExp(r'[a-z]').hasMatch(password)) {
      setState(() {
        _passwordError = 'Password must contain at least one lowercase letter';
      });
      return false;
    }

    // Check for at least one digit
    if (!RegExp(r'[0-9]').hasMatch(password)) {
      setState(() {
        _passwordError = 'Password must contain at least one number';
      });
      return false;
    }

    // Check for at least one special character
    if (!RegExp(r'[!@#$%^&*(),.?":{}|<>]').hasMatch(password)) {
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
    return _firstNameController.text.isNotEmpty &&
        _lastNameController.text.isNotEmpty &&
        _emailController.text.isNotEmpty &&
        _passwordController.text.isNotEmpty &&
        _confirmPasswordController.text.isNotEmpty &&
        _firstNameError == null &&
        _lastNameError == null &&
        _emailError == null &&
        _passwordError == null &&
        _confirmPasswordError == null &&
        _acceptTerms &&
        _acceptPrivacy;
  }

  Future<void> _handleRegister() async {
    if (!_validateFirstName() || 
        !_validateLastName() || 
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
      final fullName = '${_firstNameController.text.trim()} ${_lastNameController.text.trim()}';
      
      final response = await _authService.signUp(
        email: _emailController.text.trim(),
        password: _passwordController.text,
        fullName: fullName,
      );

      if (response?.user != null) {
        // Trigger haptic feedback
        HapticFeedback.lightImpact();

        // Show success message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                CustomIconWidget(
                  iconName: 'check_circle',
                  color: Colors.green,
                  size: 20),
                SizedBox(width: 2.w),
                Expanded(
                  child: Text(
                    'Registration successful! Please check your email to verify your account.',
                    style: AppTheme.darkTheme.textTheme.bodyMedium?.copyWith(
                      color: Colors.white,
                    ),
                  ),
                ),
              ]),
            backgroundColor: Colors.green,
            duration: const Duration(seconds: 5),
            action: SnackBarAction(
              label: 'OK',
              textColor: Colors.white,
              onPressed: () {
                ScaffoldMessenger.of(context).hideCurrentSnackBar();
              })));

        // Navigate to email verification screen
        Navigator.pushReplacementNamed(
          context, 
          AppRoutes.emailVerificationScreen,
          arguments: {
            'email': _emailController.text.trim(),
            'fullName': fullName,
          });
      } else {
        setState(() {
          _generalError = 'Registration failed. Please try again.';
        });
      }
    } catch (e) {
      setState(() {
        _generalError = 'Registration failed: ${e.toString()}';
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
        Navigator.pushReplacementNamed(context, AppRoutes.workspaceDashboard);
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
        Navigator.pushReplacementNamed(context, AppRoutes.workspaceDashboard);
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
    if (RegExp(r'[!@#$%^&*(),.?":{}|<>]').hasMatch(password)) strength++;
    
    return strength;
  }

  String _getPasswordStrengthText() {
    final strength = _getPasswordStrength();
    switch (strength) {
      case 0:
      case 1:
        return 'Weak';
      case 2:
      case 3:
        return 'Medium';
      case 4:
      case 5:
        return 'Strong';
      default:
        return 'Weak';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.primaryBackground,
      body: SafeArea(
        child: GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
          },
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
                          color: AppTheme.accent,
                          borderRadius: BorderRadius.circular(3.w)),
                        child: Center(
                          child: Text(
                            'M',
                            style: AppTheme.darkTheme.textTheme.headlineLarge?.copyWith(
                              color: AppTheme.primaryAction,
                              fontWeight: FontWeight.bold)))),
                      SizedBox(height: 2.h),
                      Text(
                        'Create Account',
                        style: AppTheme.darkTheme.textTheme.headlineMedium?.copyWith(
                          fontWeight: FontWeight.w600)),
                      SizedBox(height: 1.h),
                      Text(
                        'Join thousands of businesses using Mewayz',
                        style: AppTheme.darkTheme.textTheme.bodyMedium?.copyWith(
                          color: AppTheme.secondaryText),
                        textAlign: TextAlign.center),
                    ])),

                SizedBox(height: 6.h),

                // Registration Form
                RegistrationFormWidget(
                  formKey: _formKey,
                  fullNameController: _firstNameController,
                  fullNameFocusNode: _firstNameFocusNode,
                  emailController: _emailController,
                  passwordController: _passwordController,
                  confirmPasswordController: _confirmPasswordController,

                  emailFocusNode: _emailFocusNode,
                  passwordFocusNode: _passwordFocusNode,
                  confirmPasswordFocusNode: _confirmPasswordFocusNode,
                  isPasswordVisible: _isPasswordVisible,
                  isConfirmPasswordVisible: _isConfirmPasswordVisible,

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
                  onRegister: _handleRegister),

                SizedBox(height: 2.h),

                // Password Strength Indicator
                PasswordStrengthIndicatorWidget(
                  strength: _getPasswordStrength(),
                  strengthText: _getPasswordStrengthText(),
                ),

                SizedBox(height: 4.h),

                // Terms and Privacy
                TermsAndPrivacyWidget(
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

                // Social Registration
                SocialRegistrationWidget(
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
                        style: AppTheme.darkTheme.textTheme.bodyMedium?.copyWith(
                          color: AppTheme.secondaryText),
                        children: [
                          TextSpan(
                            text: 'Sign In',
                            style: AppTheme.darkTheme.textTheme.bodyMedium?.copyWith(
                              color: AppTheme.accent,
                              fontWeight: FontWeight.w500)),
                        ])))),

                SizedBox(height: 4.h),
              ])))));
  }
}