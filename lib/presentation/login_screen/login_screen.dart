import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../core/app_export.dart';
import './widgets/biometric_auth_widget.dart';
import './widgets/login_form_widget.dart';
import './widgets/two_factor_modal_widget.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final FocusNode _emailFocusNode = FocusNode();
  final FocusNode _passwordFocusNode = FocusNode();

  bool _isPasswordVisible = false;
  bool _isLoading = false;
  bool _showTwoFactorModal = false;
  String? _emailError;
  String? _passwordError;
  String? _generalError;

  // Mock credentials for authentication
  final Map<String, String> _mockCredentials = {
    'admin@mewayz.com': 'Admin123!',
    'user@mewayz.com': 'User123!',
    'demo@mewayz.com': 'Demo123!',
  };

  @override
  void initState() {
    super.initState();
    _emailFocusNode.addListener(_onEmailFocusChange);
    _passwordFocusNode.addListener(_onPasswordFocusChange);
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _emailFocusNode.dispose();
    _passwordFocusNode.dispose();
    super.dispose();
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

  bool get _isFormValid {
    return _emailController.text.isNotEmpty &&
        _passwordController.text.isNotEmpty &&
        _emailError == null &&
        _passwordError == null;
  }

  Future<void> _handleLogin() async {
    if (!_validateEmail() || !_validatePassword()) {
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
      final password = _passwordController.text;

      // Check mock credentials
      if (_mockCredentials.containsKey(email) &&
          _mockCredentials[email] == password) {
        // Simulate two-factor authentication requirement
        if (email == 'admin@mewayz.com') {
          setState(() {
            _isLoading = false;
            _showTwoFactorModal = true;
          });
          return;
        }

        // Success - trigger haptic feedback
        HapticFeedback.lightImpact();

        // Navigate to workspace dashboard
        Navigator.pushReplacementNamed(context, '/workspace-dashboard');
      } else {
        setState(() {
          _generalError = 'Invalid email or password. Please try again.';
        });
      }
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

  void _handleTwoFactorSuccess() {
    setState(() {
      _showTwoFactorModal = false;
    });

    HapticFeedback.lightImpact();
    Navigator.pushReplacementNamed(context, '/workspace-dashboard');
  }

  void _handleForgotPassword() {
    Navigator.pushNamed(context, AppRoutes.forgotPasswordScreen);
  }

  void _handleSignUp() {
    Navigator.pushNamed(context, AppRoutes.registerScreen);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.primaryBackground,
      body: SafeArea(
        child: Stack(
          children: [
            GestureDetector(
              onTap: () {
                FocusScope.of(context).unfocus();
              },
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 4.h),
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
                      SizedBox(height: 8.h),

                      // Mewayz Logo
                      Center(
                        child: Column(
                          children: [
                            Container(
                              width: 20.w,
                              height: 20.w,
                              decoration: BoxDecoration(
                                color: AppTheme.accent,
                                borderRadius: BorderRadius.circular(4.w),
                              ),
                              child: Center(
                                child: Text(
                                  'M',
                                  style: AppTheme
                                      .darkTheme.textTheme.headlineLarge
                                      ?.copyWith(
                                    color: AppTheme.primaryAction,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(height: 2.h),
                            Text(
                              'Mewayz',
                              style: AppTheme.darkTheme.textTheme.headlineMedium
                                  ?.copyWith(
                                fontWeight: FontWeight.w600,
                                letterSpacing: 1.2,
                              ),
                            ),
                          ],
                        ),
                      ),

                      SizedBox(height: 6.h),

                      // Login Form
                      LoginFormWidget(
                        formKey: _formKey,
                        emailController: _emailController,
                        passwordController: _passwordController,
                        emailFocusNode: _emailFocusNode,
                        passwordFocusNode: _passwordFocusNode,
                        isPasswordVisible: _isPasswordVisible,
                        emailError: _emailError,
                        passwordError: _passwordError,
                        generalError: _generalError,
                        isLoading: _isLoading,
                        isFormValid: _isFormValid,
                        onPasswordVisibilityToggle: () {
                          setState(() {
                            _isPasswordVisible = !_isPasswordVisible;
                          });
                        },
                        onLogin: _handleLogin,
                        onForgotPassword: _handleForgotPassword,
                      ),

                      SizedBox(height: 4.h),

                      // Biometric Authentication
                      BiometricAuthWidget(
                        onBiometricAuth: () {
                          HapticFeedback.lightImpact();
                          Navigator.pushReplacementNamed(
                              context, '/workspace-dashboard');
                        },
                      ),

                      SizedBox(height: 6.h),

                      // Sign Up Link
                      Center(
                        child: GestureDetector(
                          onTap: _handleSignUp,
                          child: RichText(
                            text: TextSpan(
                              text: 'New user? ',
                              style: AppTheme.darkTheme.textTheme.bodyMedium
                                  ?.copyWith(
                                color: AppTheme.secondaryText,
                              ),
                              children: [
                                TextSpan(
                                  text: 'Sign Up',
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

            // Two Factor Authentication Modal
            _showTwoFactorModal
                ? TwoFactorModalWidget(
                    onSuccess: _handleTwoFactorSuccess,
                    onCancel: () {
                      setState(() {
                        _showTwoFactorModal = false;
                      });
                    },
                  )
                : const SizedBox.shrink(),
          ],
        ),
      ),
    );
  }
}