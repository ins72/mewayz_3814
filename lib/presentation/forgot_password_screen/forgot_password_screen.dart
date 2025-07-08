import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../core/app_export.dart';
import './widgets/forgot_password_form_widget.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({Key? key}) : super(key: key);

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final FocusNode _emailFocusNode = FocusNode();

  bool _isLoading = false;
  bool _isEmailSent = false;
  bool _canResend = false;
  String? _emailError;
  String? _generalError;
  int _resendCountdown = 60;

  @override
  void initState() {
    super.initState();
    _emailFocusNode.addListener(_onEmailFocusChange);
    // Auto-focus on email field
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _emailFocusNode.requestFocus();
    });
  }

  @override
  void dispose() {
    _emailController.dispose();
    _emailFocusNode.dispose();
    super.dispose();
  }

  void _onEmailFocusChange() {
    if (!_emailFocusNode.hasFocus && _emailController.text.isNotEmpty) {
      _validateEmail();
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

  bool get _isFormValid {
    return _emailController.text.isNotEmpty && _emailError == null;
  }

  Future<void> _handleSendResetLink() async {
    if (!_validateEmail()) {
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

      // Simulate different scenarios
      if (email == 'nonexistent@example.com') {
        setState(() {
          _generalError = 'No account found with this email address';
        });
        return;
      }

      if (email == 'ratelimited@example.com') {
        setState(() {
          _generalError = 'Too many reset attempts. Please try again later';
        });
        return;
      }

      // Success
      setState(() {
        _isEmailSent = true;
        _canResend = false;
        _resendCountdown = 60;
      });

      // Trigger haptic feedback
      HapticFeedback.lightImpact();

      // Start countdown timer
      _startResendTimer();
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

  void _startResendTimer() {
    Future.delayed(const Duration(seconds: 1), () {
      if (mounted && _resendCountdown > 0) {
        setState(() {
          _resendCountdown--;
        });
        _startResendTimer();
      } else if (mounted) {
        setState(() {
          _canResend = true;
        });
      }
    });
  }

  Future<void> _handleResendLink() async {
    if (!_canResend) return;

    setState(() {
      _isLoading = true;
      _canResend = false;
      _resendCountdown = 60;
    });

    try {
      // Simulate network delay
      await Future.delayed(const Duration(seconds: 1));

      // Trigger haptic feedback
      HapticFeedback.lightImpact();

      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Reset link sent again to ${_emailController.text.trim()}',
            style: AppTheme.darkTheme.textTheme.bodyMedium,
          ),
          backgroundColor: AppTheme.success,
          behavior: SnackBarBehavior.floating,
        ),
      );

      // Start countdown timer again
      _startResendTimer();
    } catch (e) {
      setState(() {
        _generalError = 'Failed to resend reset link. Please try again.';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _handleBackToLogin() {
    Navigator.pushReplacementNamed(context, AppRoutes.loginScreen);
  }

  void _handleHelpAction() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppTheme.surface,
        title: Text(
          'Need Help?',
          style: AppTheme.darkTheme.textTheme.titleLarge,
        ),
        content: Text(
          'If you\'re having trouble resetting your password, please contact our support team at support@mewayz.com or check your spam folder.',
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

                  // Header with back button and help icon
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        onPressed: _handleBackToLogin,
                        icon: const Icon(Icons.arrow_back,
                            color: AppTheme.primaryText),
                        style: IconButton.styleFrom(
                          backgroundColor: AppTheme.surface,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                      IconButton(
                        onPressed: _handleHelpAction,
                        icon: const Icon(Icons.help_outline,
                            color: AppTheme.primaryText),
                        style: IconButton.styleFrom(
                          backgroundColor: AppTheme.surface,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: 6.h),

                  // Mewayz Logo
                  Center(
                    child: Column(
                      children: [
                        Container(
                          width: 18.w,
                          height: 18.w,
                          decoration: BoxDecoration(
                            color: AppTheme.accent,
                            borderRadius: BorderRadius.circular(4.w),
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
                        SizedBox(height: 3.h),
                        Text(
                          _isEmailSent
                              ? 'Check Your Email'
                              : 'Forgot Password?',
                          style: AppTheme.darkTheme.textTheme.headlineMedium
                              ?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        SizedBox(height: 2.h),
                        Text(
                          _isEmailSent
                              ? 'We\'ve sent a password reset link to ${_emailController.text.trim()}. Please check your inbox and spam folder.'
                              : 'Enter your email address and we\'ll send you a link to reset your password.',
                          style:
                              AppTheme.darkTheme.textTheme.bodyMedium?.copyWith(
                            color: AppTheme.secondaryText,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: 6.h),

                  // Forgot Password Form or Success State
                  if (!_isEmailSent) ...[
                    ForgotPasswordFormWidget(
                      formKey: _formKey,
                      emailController: _emailController,
                      emailFocusNode: _emailFocusNode,
                      emailError: _emailError,
                      generalError: _generalError,
                      isLoading: _isLoading,
                      isFormValid: _isFormValid,
                      onSendResetLink: _handleSendResetLink,
                    ),
                  ] else ...[
                    // Success State
                    Container(
                      padding: EdgeInsets.all(6.w),
                      decoration: BoxDecoration(
                        color: AppTheme.success.withAlpha(26),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: AppTheme.success),
                      ),
                      child: Column(
                        children: [
                          Icon(
                            Icons.email_outlined,
                            size: 12.w,
                            color: AppTheme.success,
                          ),
                          SizedBox(height: 2.h),
                          Text(
                            'Reset Link Sent!',
                            style: AppTheme.darkTheme.textTheme.titleLarge
                                ?.copyWith(
                              color: AppTheme.success,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          SizedBox(height: 1.h),
                          Text(
                            'Please check your email and click the reset link to create a new password. The link will expire in 15 minutes.',
                            style: AppTheme.darkTheme.textTheme.bodyMedium
                                ?.copyWith(
                              color: AppTheme.secondaryText,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),

                    SizedBox(height: 4.h),

                    // Resend Link Button
                    TextButton(
                      onPressed:
                          _canResend && !_isLoading ? _handleResendLink : null,
                      child: _isLoading
                          ? SizedBox(
                              height: 16,
                              width: 16,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor: AlwaysStoppedAnimation<Color>(
                                    AppTheme.accent),
                              ),
                            )
                          : Text(
                              _canResend
                                  ? 'Resend Link'
                                  : 'Resend in ${_resendCountdown}s',
                              style: AppTheme.darkTheme.textTheme.bodyMedium
                                  ?.copyWith(
                                color: _canResend
                                    ? AppTheme.accent
                                    : AppTheme.secondaryText,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                    ),
                  ],

                  SizedBox(height: 6.h),

                  // Back to Login Button
                  OutlinedButton(
                    onPressed: _handleBackToLogin,
                    style: OutlinedButton.styleFrom(
                      backgroundColor: AppTheme.surface,
                      side: const BorderSide(color: AppTheme.border),
                      padding: EdgeInsets.symmetric(vertical: 4.w),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(
                      'Back to Login',
                      style: AppTheme.darkTheme.textTheme.titleMedium?.copyWith(
                        color: AppTheme.primaryText,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),

                  SizedBox(height: 2.h),

                  // Security Note
                  Container(
                    padding: EdgeInsets.all(4.w),
                    decoration: BoxDecoration(
                      color: AppTheme.surface,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: AppTheme.border),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.security_outlined,
                          size: 5.w,
                          color: AppTheme.secondaryText,
                        ),
                        SizedBox(width: 3.w),
                        Expanded(
                          child: Text(
                            'For security reasons, password reset links expire after 15 minutes.',
                            style: AppTheme.darkTheme.textTheme.bodySmall
                                ?.copyWith(
                              color: AppTheme.secondaryText,
                            ),
                          ),
                        ),
                      ],
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