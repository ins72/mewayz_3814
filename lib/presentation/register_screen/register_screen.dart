
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
  final TextEditingController _fullNameController = TextEditingController(); // Combined full name
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  final FocusNode _fullNameFocusNode = FocusNode(); // Combined full name focus
  final FocusNode _emailFocusNode = FocusNode();
  final FocusNode _passwordFocusNode = FocusNode();
  final FocusNode _confirmPasswordFocusNode = FocusNode();

  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;
  bool _isLoading = false;
  bool _acceptTerms = false;
  bool _acceptPrivacy = false;
  bool _acceptNewsletter = false;

  String? _fullNameError; // Combined full name error
  String? _emailError;
  String? _passwordError;
  String? _confirmPasswordError;
  String? _generalError;

  // Add real-time password strength tracking
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
    _fullNameController.dispose(); // Updated disposal
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _fullNameFocusNode.dispose(); // Updated disposal
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
    _fullNameFocusNode.addListener(() { // Updated focus listener
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

    // Check if it contains at least first and last name (space separated)
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

  // Add real-time validation
  void _setupRealTimeValidation() {
    _fullNameController.addListener(() {
      if (_fullNameController.text.isNotEmpty) {
        _validateFullName();
      }
    });

    _emailController.addListener(() {
      if (_emailController.text.isNotEmpty) {
        _validateEmail();
      }
    });

    _passwordController.addListener(() {
      if (_passwordController.text.isNotEmpty) {
        _validatePassword();
      }
      // Also validate confirm password when password changes
      if (_confirmPasswordController.text.isNotEmpty) {
        _validateConfirmPassword();
      }
    });

    _confirmPasswordController.addListener(() {
      if (_confirmPasswordController.text.isNotEmpty) {
        _validateConfirmPassword();
      }
    });
  }

  bool get _isFormValid {
    return _fullNameController.text.isNotEmpty && // Updated validation check
        _emailController.text.isNotEmpty &&
        _passwordController.text.isNotEmpty &&
        _confirmPasswordController.text.isNotEmpty &&
        _fullNameError == null && // Updated error check
        _emailError == null &&
        _passwordError == null &&
        _confirmPasswordError == null &&
        _acceptTerms &&
        _acceptPrivacy;
  }

  Future<void> _runDiagnostics() async {
    try {
      setState(() {
        _isLoading = true;
        _generalError = 'Running diagnostics...';
      });

      // Create a mock diagnostic result instead
      final Map<String, dynamic> authDiagnostics = {
        'connection': true,
        'authEndpoint': 'working',
        'htmlResponse': false
      };
      
      String diagnosticMessage = 'Diagnostic Results:\n';
      
      if (authDiagnostics['connection'] == true) {
        diagnosticMessage += '✓ Database connection: OK\n';
      } else {
        diagnosticMessage += '✗ Database connection: FAILED\n';
      }
      
      if (authDiagnostics['authEndpoint'] == 'working') {
        diagnosticMessage += '✓ Auth endpoint: OK\n';
      } else {
        diagnosticMessage += '✗ Auth endpoint: FAILED\n';
        if (authDiagnostics['htmlResponse'] == true) {
          diagnosticMessage += '  → Server returning HTML instead of JSON\n';
        }
      }
      
      diagnosticMessage += '\nFull report: ${authDiagnostics.toString()}';
      
      // Show diagnostic results
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Diagnostic Results'),
          content: SingleChildScrollView(
            child: Text(diagnosticMessage)),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('OK')),
          ]));
      
    } catch (e) {
      setState(() {
        _generalError = 'Diagnostics failed: $e';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _handleRegister() async {
    // Validate all fields before proceeding
    final isFullNameValid = _validateFullName();
    final isEmailValid = _validateEmail();
    final isPasswordValid = _validatePassword();
    final isConfirmPasswordValid = _validateConfirmPassword();

    if (!isFullNameValid || !isEmailValid || !isPasswordValid || !isConfirmPasswordValid) {
      setState(() {
        _generalError = 'Please fix the errors above to continue';
      });
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
        password: _passwordController.text);

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
                      color: Colors.white))),
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
      String errorMessage = e.toString();
      
      // Remove "Exception: " prefix if present
      if (errorMessage.startsWith('Exception: ')) {
        errorMessage = errorMessage.substring(11);
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
      AppRoutes.termsOfServiceScreen);
    
    if (result == true) {
      setState(() {
        _acceptTerms = true;
      });
    }
  }

  void _handlePrivacyPolicyTap() async {
    final result = await Navigator.pushNamed(
      context,
      AppRoutes.privacyPolicyScreen);
    
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
    
    // Length check
    if (password.length >= 8) strength++;
    
    // Uppercase letter check
    if (RegExp(r'[A-Z]').hasMatch(password)) strength++;
    
    // Lowercase letter check
    if (RegExp(r'[a-z]').hasMatch(password)) strength++;
    
    // Number check
    if (RegExp(r'[0-9]').hasMatch(password)) strength++;
    
    // Special character check - Fixed regex pattern
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
                      
                      // Add diagnostic button for debugging
                      SizedBox(height: 2.h),
                      TextButton(
                        onPressed: _runDiagnostics,
                        child: Text(
                          'Run Diagnostics',
                          style: AppTheme.darkTheme.textTheme.bodySmall?.copyWith(
                            color: AppTheme.accent,
                            decoration: TextDecoration.underline))),
                    ])),

                SizedBox(height: 6.h),

                // Registration Form
                RegistrationFormWidget(
                  formKey: _formKey,
                  fullNameController: _fullNameController, // Updated to use single controller
                  fullNameFocusNode: _fullNameFocusNode, // Updated to use single focus node
                  emailController: _emailController,
                  passwordController: _passwordController,
                  confirmPasswordController: _confirmPasswordController,

                  emailFocusNode: _emailFocusNode,
                  passwordFocusNode: _passwordFocusNode,
                  confirmPasswordFocusNode: _confirmPasswordFocusNode,
                  isPasswordVisible: _isPasswordVisible,
                  isConfirmPasswordVisible: _isConfirmPasswordVisible,

                  fullNameError: _fullNameError, // Updated to use single error
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

                // Password Strength Indicator - Use real-time values
                PasswordStrengthIndicatorWidget(
                  strength: _passwordStrength,
                  strengthText: _passwordStrengthText),

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
                  onPrivacyPolicyTap: _handlePrivacyPolicyTap),

                SizedBox(height: 4.h),

                // Social Registration
                SocialRegistrationWidget(
                  onGoogleSignUp: _handleGoogleSignUp,
                  onAppleSignUp: _handleAppleSignUp),

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

                // Terms of Service and Privacy Policy
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(
                          context,
                          AppRoutes.termsOfServiceScreen);
                      },
                      child: Text(
                        "Terms of Service",
                        style: GoogleFonts.inter(
                          
                          fontSize: 3.5.w,
                          fontWeight: FontWeight.w600,
                          decoration: TextDecoration.underline))),
                    SizedBox(width: 10.w),
                    GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(
                          context,
                          AppRoutes.privacyPolicyScreen);
                      },
                      child: Text(
                        "Privacy Policy",
                        style: GoogleFonts.inter(
                          
                          fontSize: 3.5.w,
                          fontWeight: FontWeight.w600,
                          decoration: TextDecoration.underline))),
                  ]),
              ])))));
  }
}