import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sizer/sizer.dart';

class EnhancedLoginFormWidget extends StatefulWidget {
  final Function(String email, String password) onLogin;
  final VoidCallback onForgotPassword;
  final bool isLoading;

  const EnhancedLoginFormWidget({
    super.key,
    required this.onLogin,
    required this.onForgotPassword,
    required this.isLoading,
  });

  @override
  State<EnhancedLoginFormWidget> createState() => _EnhancedLoginFormWidgetState();
}

class _EnhancedLoginFormWidgetState extends State<EnhancedLoginFormWidget> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _emailFocusNode = FocusNode();
  final _passwordFocusNode = FocusNode();

  bool _isEmailFocused = false;
  bool _isPasswordFocused = false;
  bool _isPasswordVisible = false;
  bool _isEmailValid = true;

  @override
  void initState() {
    super.initState();
    _emailFocusNode.addListener(_handleEmailFocusChange);
    _passwordFocusNode.addListener(_handlePasswordFocusChange);
    _emailController.addListener(_validateEmail);
  }

  void _handleEmailFocusChange() {
    setState(() {
      _isEmailFocused = _emailFocusNode.hasFocus;
    });
  }

  void _handlePasswordFocusChange() {
    setState(() {
      _isPasswordFocused = _passwordFocusNode.hasFocus;
    });
  }

  void _validateEmail() {
    final email = _emailController.text;
    final isValid = email.isEmpty || RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email);
    if (_isEmailValid != isValid) {
      setState(() {
        _isEmailValid = isValid;
      });
    }
  }

  void _handleLogin() {
    if (_formKey.currentState!.validate()) {
      HapticFeedback.lightImpact();
      widget.onLogin(_emailController.text, _passwordController.text);
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _emailFocusNode.dispose();
    _passwordFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Email field
          Container(
            decoration: BoxDecoration(
              color: const Color(0xFF191919),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: _isEmailFocused 
                    ? const Color(0xFFF1F1F1) 
                    : !_isEmailValid 
                        ? const Color(0xFFFF6B6B)
                        : Colors.transparent,
                width: 1.5,
              ),
            ),
            child: TextFormField(
              controller: _emailController,
              focusNode: _emailFocusNode,
              keyboardType: TextInputType.emailAddress,
              textInputAction: TextInputAction.next,
              enabled: !widget.isLoading,
              style: GoogleFonts.inter(
                color: const Color(0xFFF1F1F1),
                fontSize: 16.sp,
                fontWeight: FontWeight.w500,
              ),
              decoration: InputDecoration(
                hintText: 'Email address',
                hintStyle: GoogleFonts.inter(
                  color: const Color(0xFF7B7B7B),
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w400,
                ),
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 4.w,
                  vertical: 2.h,
                ),
                border: InputBorder.none,
                suffixIcon: _emailController.text.isNotEmpty
                    ? Icon(
                        _isEmailValid ? Icons.check_circle : Icons.error,
                        color: _isEmailValid 
                            ? const Color(0xFF4CAF50) 
                            : const Color(0xFFFF6B6B),
                        size: 5.w,
                      )
                    : null,
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your email address';
                }
                if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
                  return 'Please enter a valid email address';
                }
                return null;
              },
            ),
          ),
          
          SizedBox(height: 2.h),
          
          // Password field
          Container(
            decoration: BoxDecoration(
              color: const Color(0xFF191919),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: _isPasswordFocused 
                    ? const Color(0xFFF1F1F1) 
                    : Colors.transparent,
                width: 1.5,
              ),
            ),
            child: TextFormField(
              controller: _passwordController,
              focusNode: _passwordFocusNode,
              obscureText: !_isPasswordVisible,
              textInputAction: TextInputAction.done,
              enabled: !widget.isLoading,
              style: GoogleFonts.inter(
                color: const Color(0xFFF1F1F1),
                fontSize: 16.sp,
                fontWeight: FontWeight.w500,
              ),
              decoration: InputDecoration(
                hintText: 'Password',
                hintStyle: GoogleFonts.inter(
                  color: const Color(0xFF7B7B7B),
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w400,
                ),
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 4.w,
                  vertical: 2.h,
                ),
                border: InputBorder.none,
                suffixIcon: IconButton(
                  onPressed: () {
                    setState(() {
                      _isPasswordVisible = !_isPasswordVisible;
                    });
                    HapticFeedback.selectionClick();
                  },
                  icon: Icon(
                    _isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                    color: const Color(0xFF7B7B7B),
                    size: 5.w,
                  ),
                ),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your password';
                }
                if (value.length < 6) {
                  return 'Password must be at least 6 characters';
                }
                return null;
              },
              onFieldSubmitted: (_) => _handleLogin(),
            ),
          ),
          
          SizedBox(height: 2.h),
          
          // Forgot password link
          Align(
            alignment: Alignment.centerRight,
            child: GestureDetector(
              onTap: widget.isLoading ? null : widget.onForgotPassword,
              child: Container(
                padding: EdgeInsets.symmetric(
                  horizontal: 2.w,
                  vertical: 1.h,
                ),
                child: Text(
                  'Forgot Password?',
                  style: GoogleFonts.inter(
                    color: widget.isLoading 
                        ? const Color(0xFF7B7B7B).withAlpha(128)
                        : const Color(0xFF7B7B7B),
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w500,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
            ),
          ),
          
          SizedBox(height: 3.h),
          
          // Login button
          Container(
            width: double.infinity,
            height: 6.h,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFFF1F1F1).withAlpha(26),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: ElevatedButton(
              onPressed: widget.isLoading ? null : _handleLogin,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFFDFDFD),
                foregroundColor: const Color(0xFF141414),
                disabledBackgroundColor: const Color(0xFF7B7B7B),
                disabledForegroundColor: const Color(0xFF191919),
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: widget.isLoading
                  ? SizedBox(
                      width: 5.w,
                      height: 5.w,
                      child: const CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(
                          Color(0xFF191919),
                        ),
                      ),
                    )
                  : Text(
                      'Login',
                      style: GoogleFonts.inter(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
            ),
          ),
        ],
      ),
    );
  }
}