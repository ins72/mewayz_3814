
import '../../core/app_export.dart';
import './widgets/password_input_widget.dart';
import './widgets/password_strength_indicator_widget.dart';
import './widgets/security_header_widget.dart';

class ResetPasswordScreen extends StatefulWidget {
  const ResetPasswordScreen({Key? key}) : super(key: key);

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  final FocusNode _newPasswordFocusNode = FocusNode();
  final FocusNode _confirmPasswordFocusNode = FocusNode();

  bool _isNewPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;
  bool _isLoading = false;
  bool _isTokenValid = true;
  String? _newPasswordError;
  String? _confirmPasswordError;
  String? _generalError;
  double _passwordStrength = 0.0;
  String _passwordStrengthText = '';
  Color _passwordStrengthColor = AppTheme.error;

  // Password validation requirements
  final Map<String, bool> _passwordRequirements = {
    'minLength': false,
    'uppercase': false,
    'lowercase': false,
    'number': false,
    'specialChar': false,
  };

  @override
  void initState() {
    super.initState();
    _validateResetToken();
    _newPasswordFocusNode.addListener(_onNewPasswordFocusChange);
    _confirmPasswordFocusNode.addListener(_onConfirmPasswordFocusChange);
    _newPasswordController.addListener(_onPasswordChange);
    _confirmPasswordController.addListener(_onConfirmPasswordChange);
  }

  @override
  void dispose() {
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    _newPasswordFocusNode.dispose();
    _confirmPasswordFocusNode.dispose();
    super.dispose();
  }

  void _validateResetToken() {
    // Get token from route arguments
    final String? token = ModalRoute.of(context)?.settings.arguments as String?;

    if (token == null || token.isEmpty) {
      setState(() {
        _isTokenValid = false;
        _generalError =
            'Invalid reset link. Please request a new password reset.';
      });
      return;
    }

    // Simulate token validation
    if (token.length < 20) {
      setState(() {
        _isTokenValid = false;
        _generalError =
            'Reset link has expired. Please request a new password reset.';
      });
    }
  }

  void _onNewPasswordFocusChange() {
    if (!_newPasswordFocusNode.hasFocus &&
        _newPasswordController.text.isNotEmpty) {
      _validateNewPassword();
    }
  }

  void _onConfirmPasswordFocusChange() {
    if (!_confirmPasswordFocusNode.hasFocus &&
        _confirmPasswordController.text.isNotEmpty) {
      _validateConfirmPassword();
    }
  }

  void _onPasswordChange() {
    _validatePasswordStrength();
    _validateNewPassword();
  }

  void _onConfirmPasswordChange() {
    _validateConfirmPassword();
  }

  void _validatePasswordStrength() {
    final password = _newPasswordController.text;
    int score = 0;

    // Check minimum length (8 characters)
    _passwordRequirements['minLength'] = password.length >= 8;
    if (_passwordRequirements['minLength']!) score++;

    // Check for uppercase letter
    _passwordRequirements['uppercase'] = RegExp(r'[A-Z]').hasMatch(password);
    if (_passwordRequirements['uppercase']!) score++;

    // Check for lowercase letter
    _passwordRequirements['lowercase'] = RegExp(r'[a-z]').hasMatch(password);
    if (_passwordRequirements['lowercase']!) score++;

    // Check for number
    _passwordRequirements['number'] = RegExp(r'[0-9]').hasMatch(password);
    if (_passwordRequirements['number']!) score++;

    // Check for special character
    _passwordRequirements['specialChar'] =
        RegExp(r'[!@#$%^&*(),.?":{}|<>]').hasMatch(password);
    if (_passwordRequirements['specialChar']!) score++;

    setState(() {
      _passwordStrength = score / 5.0;

      if (score == 0) {
        _passwordStrengthText = '';
        _passwordStrengthColor = AppTheme.error;
      } else if (score <= 2) {
        _passwordStrengthText = 'Weak';
        _passwordStrengthColor = AppTheme.error;
      } else if (score <= 3) {
        _passwordStrengthText = 'Fair';
        _passwordStrengthColor = AppTheme.warning;
      } else if (score <= 4) {
        _passwordStrengthText = 'Good';
        _passwordStrengthColor = AppTheme.accent;
      } else {
        _passwordStrengthText = 'Strong';
        _passwordStrengthColor = AppTheme.success;
      }
    });
  }

  bool _validateNewPassword() {
    final password = _newPasswordController.text;

    if (password.isEmpty) {
      setState(() {
        _newPasswordError = 'Password is required';
      });
      return false;
    }

    if (password.length < 8) {
      setState(() {
        _newPasswordError = 'Password must be at least 8 characters';
      });
      return false;
    }

    if (_passwordStrength < 0.8) {
      setState(() {
        _newPasswordError = 'Password does not meet strength requirements';
      });
      return false;
    }

    setState(() {
      _newPasswordError = null;
    });
    return true;
  }

  bool _validateConfirmPassword() {
    final confirmPassword = _confirmPasswordController.text;
    final newPassword = _newPasswordController.text;

    if (confirmPassword.isEmpty) {
      setState(() {
        _confirmPasswordError = 'Please confirm your password';
      });
      return false;
    }

    if (confirmPassword != newPassword) {
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
    return _isTokenValid &&
        _newPasswordController.text.isNotEmpty &&
        _confirmPasswordController.text.isNotEmpty &&
        _newPasswordError == null &&
        _confirmPasswordError == null &&
        _passwordStrength >= 0.8 &&
        _newPasswordController.text == _confirmPasswordController.text;
  }

  Future<void> _handleResetPassword() async {
    if (!_validateNewPassword() || !_validateConfirmPassword()) {
      return;
    }

    setState(() {
      _isLoading = true;
      _generalError = null;
    });

    try {
      // Simulate network delay
      await Future.delayed(const Duration(seconds: 2));

      // Simulate password reset success
      HapticFeedback.lightImpact();

      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Password reset successful! Logging you in...',
            style: AppTheme.darkTheme.textTheme.bodyMedium?.copyWith(
              color: AppTheme.primaryText,
            ),
          ),
          backgroundColor: AppTheme.success,
          duration: const Duration(seconds: 3),
        ),
      );

      // Navigate to workspace dashboard after success
      await Future.delayed(const Duration(seconds: 1));
      Navigator.pushNamedAndRemoveUntil(
        context,
        '/workspace-dashboard',
        (route) => false,
      );
    } catch (e) {
      setState(() {
        _generalError = 'Failed to reset password. Please try again.';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _handleBackToLogin() {
    Navigator.pushReplacementNamed(context, '/login-screen');
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

                  // Security Header
                  SecurityHeaderWidget(),

                  SizedBox(height: 6.h),

                  // Form
                  if (_isTokenValid) ...[
                    Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          // New Password Field
                          PasswordInputWidget(
                            controller: _newPasswordController,
                            focusNode: _newPasswordFocusNode,
                            isPasswordVisible: _isNewPasswordVisible,
                            error: _newPasswordError,
                            label: 'New Password',
                            hintText: 'Enter your new password',
                            onVisibilityToggle: () {
                              setState(() {
                                _isNewPasswordVisible = !_isNewPasswordVisible;
                              });
                            },
                          ),

                          SizedBox(height: 2.h),

                          // Password Strength Indicator
                          PasswordStrengthIndicatorWidget(
                            strength: _passwordStrength,
                            strengthText: _passwordStrengthText,
                            strengthColor: _passwordStrengthColor,
                            requirements: _passwordRequirements,
                          ),

                          SizedBox(height: 3.h),

                          // Confirm Password Field
                          PasswordInputWidget(
                            controller: _confirmPasswordController,
                            focusNode: _confirmPasswordFocusNode,
                            isPasswordVisible: _isConfirmPasswordVisible,
                            error: _confirmPasswordError,
                            label: 'Confirm Password',
                            hintText: 'Re-enter your new password',
                            onVisibilityToggle: () {
                              setState(() {
                                _isConfirmPasswordVisible =
                                    !_isConfirmPasswordVisible;
                              });
                            },
                          ),

                          SizedBox(height: 4.h),

                          // Error Message
                          if (_generalError != null) ...[
                            Container(
                              padding: EdgeInsets.all(3.w),
                              decoration: BoxDecoration(
                                color: AppTheme.error.withAlpha(26),
                                borderRadius: BorderRadius.circular(2.w),
                                border: Border.all(
                                  color: AppTheme.error.withAlpha(77),
                                ),
                              ),
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.error_outline,
                                    color: AppTheme.error,
                                    size: 5.w,
                                  ),
                                  SizedBox(width: 3.w),
                                  Expanded(
                                    child: Text(
                                      _generalError!,
                                      style: AppTheme
                                          .darkTheme.textTheme.bodyMedium
                                          ?.copyWith(
                                        color: AppTheme.error,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: 3.h),
                          ],

                          // Reset Password Button
                          SizedBox(
                            height: 12.w,
                            child: ElevatedButton(
                              onPressed: _isFormValid && !_isLoading
                                  ? _handleResetPassword
                                  : null,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: _isFormValid
                                    ? AppTheme.primaryAction
                                    : AppTheme.border,
                                foregroundColor: _isFormValid
                                    ? AppTheme.primaryBackground
                                    : AppTheme.secondaryText,
                                elevation: 0,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(3.w),
                                ),
                              ),
                              child: _isLoading
                                  ? SizedBox(
                                      width: 5.w,
                                      height: 5.w,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                        valueColor:
                                            AlwaysStoppedAnimation<Color>(
                                          _isFormValid
                                              ? AppTheme.primaryBackground
                                              : AppTheme.secondaryText,
                                        ),
                                      ),
                                    )
                                  : Text(
                                      'Reset Password',
                                      style: AppTheme
                                          .darkTheme.textTheme.titleMedium
                                          ?.copyWith(
                                        color: _isFormValid
                                            ? AppTheme.primaryBackground
                                            : AppTheme.secondaryText,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                            ),
                          ),

                          SizedBox(height: 4.h),

                          // Security Note
                          Container(
                            padding: EdgeInsets.all(4.w),
                            decoration: BoxDecoration(
                              color: AppTheme.surface,
                              borderRadius: BorderRadius.circular(3.w),
                              border: Border.all(
                                color: AppTheme.border,
                              ),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Icon(
                                      Icons.info_outline,
                                      color: AppTheme.accent,
                                      size: 5.w,
                                    ),
                                    SizedBox(width: 3.w),
                                    Text(
                                      'Security Information',
                                      style: AppTheme
                                          .darkTheme.textTheme.titleSmall
                                          ?.copyWith(
                                        color: AppTheme.primaryText,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 2.h),
                                Text(
                                  'Your password should be unique and not used on other sites. We recommend using a password manager to generate and store strong passwords.',
                                  style: AppTheme.darkTheme.textTheme.bodySmall
                                      ?.copyWith(
                                    color: AppTheme.secondaryText,
                                    height: 1.4,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],

                  SizedBox(height: 6.h),

                  // Back to Login Button
                  TextButton(
                    onPressed: _handleBackToLogin,
                    style: TextButton.styleFrom(
                      foregroundColor: AppTheme.accent,
                      padding: EdgeInsets.symmetric(vertical: 4.w),
                    ),
                    child: Text(
                      'Back to Login',
                      style: AppTheme.darkTheme.textTheme.bodyMedium?.copyWith(
                        color: AppTheme.accent,
                        fontWeight: FontWeight.w500,
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