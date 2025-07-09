
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
  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
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

  @override
  void initState() {
    super.initState();
    _fullNameFocusNode.addListener(_onFullNameFocusChange);
    _emailFocusNode.addListener(_onEmailFocusChange);
    _passwordFocusNode.addListener(_onPasswordFocusChange);
    _confirmPasswordFocusNode.addListener(_onConfirmPasswordFocusChange);
    _passwordController.addListener(_onPasswordChange);
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

  void _onFullNameFocusChange() {
    if (!_fullNameFocusNode.hasFocus && _fullNameController.text.isNotEmpty) {
      _validateFullName();
    }
  }

  void _onEmailFocusChange() {
    if (!_emailFocusNode.hasFocus && _emailController.text.isNotEmpty) {
      _validateEmail();
    }
  }

  void _onPasswordFocusChange() {
    if (!_passwordFocusNode.hasFocus && _passwordController.text.isNotEmpty) {
      _validatePassword();
    }
  }

  void _onConfirmPasswordFocusChange() {
    if (!_confirmPasswordFocusNode.hasFocus &&
        _confirmPasswordController.text.isNotEmpty) {
      _validateConfirmPassword();
    }
  }

  void _onPasswordChange() {
    _calculatePasswordStrength();
    if (_passwordController.text.isNotEmpty) {
      _validatePassword();
    }
    if (_confirmPasswordController.text.isNotEmpty) {
      _validateConfirmPassword();
    }
  }

  void _calculatePasswordStrength() {
    final password = _passwordController.text;
    int strength = 0;
    String strengthText = '';

    if (password.isEmpty) {
      strength = 0;
      strengthText = '';
    } else if (password.length < 6) {
      strength = 1;
      strengthText = 'Weak';
    } else {
      strength = 2;
      strengthText = 'Fair';

      if (password.length >= 8) {
        strength = 3;
        strengthText = 'Good';
      }

      if (password.length >= 12 &&
          password.contains(RegExp(r'[A-Z]')) &&
          password.contains(RegExp(r'[a-z]')) &&
          password.contains(RegExp(r'[0-9]')) &&
          password.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'))) {
        strength = 4;
        strengthText = 'Strong';
      }
    }

    setState(() {
      _passwordStrength = strength;
      _passwordStrengthText = strengthText;
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

    if (password.length < 6) {
      setState(() {
        _passwordError = 'Password must be at least 6 characters';
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
    final password = _passwordController.text;

    if (confirmPassword.isEmpty) {
      setState(() {
        _confirmPasswordError = 'Please confirm your password';
      });
      return false;
    }

    if (confirmPassword != password) {
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
        _generalError = 'Please accept the terms of service and privacy policy';
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _generalError = null;
    });

    try {
      // Simulate network delay
      await Future.delayed(const Duration(seconds: 2));

      final email = _emailController.text.trim();

      // Simulate email already exists check
      if (email == 'admin@mewayz.com' || email == 'user@mewayz.com') {
        setState(() {
          _generalError = 'An account with this email already exists';
        });
        return;
      }

      // Success - trigger haptic feedback
      HapticFeedback.lightImpact();

      // Show success message and navigate to email verification
      _showSuccessMessage();
    } catch (e) {
      setState(() {
        _generalError =
            'Network error. Please check your connection and try again.';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _showSuccessMessage() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        backgroundColor: AppTheme.surface,
        title: Text(
          'Account Created Successfully!',
          style: AppTheme.darkTheme.textTheme.titleLarge?.copyWith(
            color: AppTheme.success,
          ),
        ),
        content: Text(
          'A verification email has been sent to ${_emailController.text.trim()}. Please check your inbox and click the verification link to activate your account.',
          style: AppTheme.darkTheme.textTheme.bodyMedium,
        ),
        actions: [
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pushReplacementNamed(context, AppRoutes.loginScreen);
            },
            child: const Text('Continue to Login'),
          ),
        ],
      ),
    );
  }

  void _handleGoogleSignUp() {
    // Simulate Google sign up
    HapticFeedback.lightImpact();
    _showComingSoonDialog('Google Sign Up');
  }

  void _handleAppleSignUp() {
    // Simulate Apple sign up
    HapticFeedback.lightImpact();
    _showComingSoonDialog('Apple Sign Up');
  }

  void _showComingSoonDialog(String feature) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppTheme.surface,
        title: Text(
          feature,
          style: AppTheme.darkTheme.textTheme.titleLarge,
        ),
        content: Text(
          '$feature functionality will be available in the next update.',
          style: AppTheme.darkTheme.textTheme.bodyMedium,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void _handleTermsOfService() {
    // Open terms of service in in-app browser
    _showComingSoonDialog('Terms of Service');
  }

  void _handlePrivacyPolicy() {
    // Open privacy policy in in-app browser
    _showComingSoonDialog('Privacy Policy');
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
            padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: MediaQuery.of(context).size.height -
                    MediaQuery.of(context).padding.top -
                    MediaQuery.of(context).padding.bottom,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  SizedBox(height: 4.h),

                  // Back button
                  Align(
                    alignment: Alignment.centerLeft,
                    child: IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(Icons.arrow_back,
                          color: AppTheme.primaryText),
                      style: IconButton.styleFrom(
                        backgroundColor: AppTheme.surface,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),

                  SizedBox(height: 2.h),

                  // Mewayz Logo
                  Center(
                    child: Column(
                      children: [
                        Container(
                          width: 16.w,
                          height: 16.w,
                          decoration: BoxDecoration(
                            color: AppTheme.accent,
                            borderRadius: BorderRadius.circular(3.w),
                          ),
                          child: Center(
                            child: Text(
                              'M',
                              style: AppTheme.darkTheme.textTheme.headlineMedium
                                  ?.copyWith(
                                color: AppTheme.primaryAction,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 2.h),
                        Text(
                          'Create Account',
                          style: AppTheme.darkTheme.textTheme.headlineMedium
                              ?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        SizedBox(height: 1.h),
                        Text(
                          'Join Mewayz to get started with your digital workspace',
                          style:
                              AppTheme.darkTheme.textTheme.bodyMedium?.copyWith(
                            color: AppTheme.secondaryText,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: 4.h),

                  // Registration Form
                  RegistrationFormWidget(
                    formKey: _formKey,
                    fullNameController: _fullNameController,
                    emailController: _emailController,
                    passwordController: _passwordController,
                    confirmPasswordController: _confirmPasswordController,
                    fullNameFocusNode: _fullNameFocusNode,
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

                  // Password Strength Indicator
                  PasswordStrengthIndicatorWidget(
                    strength: _passwordStrength,
                    strengthText: _passwordStrengthText,
                  ),

                  SizedBox(height: 3.h),

                  // Terms and Privacy
                  TermsAndPrivacyWidget(
                    acceptTerms: _acceptTerms,
                    acceptPrivacy: _acceptPrivacy,
                    onTermsChanged: (value) {
                      setState(() {
                        _acceptTerms = value ?? false;
                      });
                    },
                    onPrivacyChanged: (value) {
                      setState(() {
                        _acceptPrivacy = value ?? false;
                      });
                    },
                    onTermsOfServiceTap: _handleTermsOfService,
                    onPrivacyPolicyTap: _handlePrivacyPolicy,
                  ),

                  SizedBox(height: 4.h),

                  // Social Registration
                  SocialRegistrationWidget(
                    onGoogleSignUp: _handleGoogleSignUp,
                    onAppleSignUp: _handleAppleSignUp,
                  ),

                  SizedBox(height: 4.h),

                  // Login Link
                  Center(
                    child: GestureDetector(
                      onTap: () {
                        Navigator.pushReplacementNamed(
                            context, AppRoutes.loginScreen);
                      },
                      child: RichText(
                        text: TextSpan(
                          text: 'Already have an account? ',
                          style:
                              AppTheme.darkTheme.textTheme.bodyMedium?.copyWith(
                            color: AppTheme.secondaryText,
                          ),
                          children: [
                            TextSpan(
                              text: 'Login',
                              style: AppTheme.darkTheme.textTheme.bodyMedium
                                  ?.copyWith(
                                color: AppTheme.accent,
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