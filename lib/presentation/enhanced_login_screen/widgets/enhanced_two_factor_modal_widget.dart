import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sizer/sizer.dart';

class EnhancedTwoFactorModalWidget extends StatefulWidget {
  final VoidCallback onComplete;
  final VoidCallback onCancel;

  const EnhancedTwoFactorModalWidget({
    super.key,
    required this.onComplete,
    required this.onCancel,
  });

  @override
  State<EnhancedTwoFactorModalWidget> createState() => _EnhancedTwoFactorModalWidgetState();
}

class _EnhancedTwoFactorModalWidgetState extends State<EnhancedTwoFactorModalWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;

  final List<TextEditingController> _controllers = List.generate(6, (index) => TextEditingController());
  final List<FocusNode> _focusNodes = List.generate(6, (index) => FocusNode());
  
  bool _isLoading = false;
  String _errorMessage = '';

  @override
  void initState() {
    super.initState();
    _initializeAnimation();
    _startEntryAnimation();
  }

  void _initializeAnimation() {
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));

    _scaleAnimation = Tween<double>(
      begin: 0.8,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOutBack,
    ));
  }

  void _startEntryAnimation() {
    _animationController.forward();
    // Auto-focus first field
    Future.delayed(const Duration(milliseconds: 300), () {
      if (mounted) {
        _focusNodes[0].requestFocus();
      }
    });
  }

  void _handleCodeInput(String value, int index) {
    if (value.length == 1) {
      if (index < 5) {
        _focusNodes[index + 1].requestFocus();
      } else {
        _focusNodes[index].unfocus();
        _verifyCode();
      }
    }
  }

  void _verifyCode() async {
    final code = _controllers.map((controller) => controller.text).join();
    if (code.length != 6) return;

    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });

    try {
      await Future.delayed(const Duration(milliseconds: 1500));
      
      if (code == '123456') {
        HapticFeedback.lightImpact();
        widget.onComplete();
      } else {
        setState(() {
          _errorMessage = 'Invalid verification code. Please try again.';
          _isLoading = false;
        });
        
        // Clear fields
        for (var controller in _controllers) {
          controller.clear();
        }
        _focusNodes[0].requestFocus();
        
        HapticFeedback.heavyImpact();
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Verification failed. Please try again.';
        _isLoading = false;
      });
      
      HapticFeedback.heavyImpact();
    }
  }

  void _handleCancel() {
    _animationController.reverse().then((_) {
      widget.onCancel();
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    for (var controller in _controllers) {
      controller.dispose();
    }
    for (var focusNode in _focusNodes) {
      focusNode.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        return Container(
          width: 100.w,
          height: 100.h,
          color: Colors.black.withOpacity(0.7 * _fadeAnimation.value),
          child: Center(
            child: Transform.scale(
              scale: _scaleAnimation.value,
              child: Opacity(
                opacity: _fadeAnimation.value,
                child: Container(
                  width: 85.w,
                  padding: EdgeInsets.all(6.w),
                  decoration: BoxDecoration(
                    color: const Color(0xFF191919),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: const Color(0xFF7B7B7B).withAlpha(77),
                    ),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Header
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Two-Factor Authentication',
                            style: GoogleFonts.inter(
                              color: const Color(0xFFF1F1F1),
                              fontSize: 18.sp,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          IconButton(
                            onPressed: _isLoading ? null : _handleCancel,
                            icon: Icon(
                              Icons.close,
                              color: const Color(0xFF7B7B7B),
                              size: 6.w,
                            ),
                          ),
                        ],
                      ),
                      
                      SizedBox(height: 2.h),
                      
                      // Description
                      Text(
                        'Enter the 6-digit code from your authenticator app',
                        style: GoogleFonts.inter(
                          color: const Color(0xFF7B7B7B),
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w400,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      
                      SizedBox(height: 4.h),
                      
                      // Code input fields
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: List.generate(6, (index) {
                          return Container(
                            width: 10.w,
                            height: 10.w,
                            decoration: BoxDecoration(
                              color: const Color(0xFF2A2A2A),
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                color: _focusNodes[index].hasFocus
                                    ? const Color(0xFFF1F1F1)
                                    : const Color(0xFF7B7B7B).withAlpha(77),
                              ),
                            ),
                            child: TextField(
                              controller: _controllers[index],
                              focusNode: _focusNodes[index],
                              textAlign: TextAlign.center,
                              keyboardType: TextInputType.number,
                              maxLength: 1,
                              enabled: !_isLoading,
                              style: GoogleFonts.inter(
                                color: const Color(0xFFF1F1F1),
                                fontSize: 18.sp,
                                fontWeight: FontWeight.w600,
                              ),
                              decoration: const InputDecoration(
                                border: InputBorder.none,
                                counterText: '',
                              ),
                              onChanged: (value) => _handleCodeInput(value, index),
                            ),
                          );
                        }),
                      ),
                      
                      SizedBox(height: 3.h),
                      
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
                          child: Text(
                            _errorMessage,
                            style: GoogleFonts.inter(
                              color: const Color(0xFFFF6B6B),
                              fontSize: 13.sp,
                              fontWeight: FontWeight.w500,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        SizedBox(height: 2.h),
                      ],
                      
                      // Verify button
                      Container(
                        width: double.infinity,
                        height: 6.h,
                        child: ElevatedButton(
                          onPressed: _isLoading ? null : _verifyCode,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFF1F1F1),
                            foregroundColor: const Color(0xFF141414),
                            disabledBackgroundColor: const Color(0xFF7B7B7B),
                            disabledForegroundColor: const Color(0xFF191919),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: _isLoading
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
                                  'Verify',
                                  style: GoogleFonts.inter(
                                    fontSize: 16.sp,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}