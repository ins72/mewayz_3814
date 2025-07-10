import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sizer/sizer.dart';
import '../../../services/enhanced_auth_service.dart';

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
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  final List<TextEditingController> _codeControllers = List.generate(6, (_) => TextEditingController());
  final List<FocusNode> _codeFocusNodes = List.generate(6, (_) => FocusNode());
  
  bool _isLoading = false;
  String _errorMessage = '';
  String _selectedMethod = 'authenticator';
  
  final EnhancedAuthService _authService = EnhancedAuthService();

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _startEntryAnimation();
  }

  void _initializeAnimations() {
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

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 1),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOutCubic,
    ));
  }

  void _startEntryAnimation() {
    _animationController.forward();
  }

  void _handleCodeInput(String value, int index) {
    if (value.isNotEmpty) {
      if (index < 5) {
        _codeFocusNodes[index + 1].requestFocus();
      } else {
        // Last digit entered, verify code
        _verifyCode();
      }
    } else if (value.isEmpty && index > 0) {
      _codeFocusNodes[index - 1].requestFocus();
    }
  }

  void _verifyCode() async {
    final code = _codeControllers.map((controller) => controller.text).join();
    
    if (code.length != 6) {
      _showError('Please enter the complete 6-digit code');
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });

    try {
      final isValid = await _authService.verifyTwoFactorCode(
        code,
        method: _selectedMethod,
      );

      if (isValid) {
        HapticFeedback.lightImpact();
        await _animationController.reverse();
        widget.onComplete();
      } else {
        _showError('Invalid verification code. Please try again.');
        _clearCode();
      }
    } catch (e) {
      _showError('Verification failed. Please try again.');
      _clearCode();
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _clearCode() {
    for (final controller in _codeControllers) {
      controller.clear();
    }
    _codeFocusNodes[0].requestFocus();
  }

  void _showError(String message) {
    setState(() {
      _errorMessage = message;
    });
    
    HapticFeedback.heavyImpact();
    
    // Clear error after 3 seconds
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        setState(() {
          _errorMessage = '';
        });
      }
    });
  }

  void _handleCancel() async {
    await _animationController.reverse();
    widget.onCancel();
  }

  void _resendCode() async {
    setState(() {
      _isLoading = true;
    });

    try {
      // Simulate resend logic
      await Future.delayed(const Duration(seconds: 1));
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Verification code sent',
            style: GoogleFonts.inter(),
          ),
          backgroundColor: const Color(0xFF4CAF50),
          behavior: SnackBarBehavior.floating,
        ),
      );
    } catch (e) {
      _showError('Failed to resend code. Please try again.');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    for (final controller in _codeControllers) {
      controller.dispose();
    }
    for (final node in _codeFocusNodes) {
      node.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: AnimatedBuilder(
        animation: _animationController,
        builder: (context, child) {
          return Opacity(
            opacity: _fadeAnimation.value,
            child: Container(
              color: Colors.black.withOpacity(0.7 * _fadeAnimation.value),
              child: Center(
                child: SlideTransition(
                  position: _slideAnimation,
                  child: _buildModalContent(),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildModalContent() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 6.w),
      padding: EdgeInsets.all(6.w),
      decoration: BoxDecoration(
        color: const Color(0xFF191919),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: const Color(0xFF2A2A2A),
          width: 1,
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
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
              GestureDetector(
                onTap: _handleCancel,
                child: Container(
                  padding: EdgeInsets.all(2.w),
                  decoration: BoxDecoration(
                    color: const Color(0xFF2A2A2A),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    Icons.close,
                    color: const Color(0xFF7B7B7B),
                    size: 5.w,
                  ),
                ),
              ),
            ],
          ),
          
          SizedBox(height: 4.h),
          
          // Method selector
          Container(
            padding: EdgeInsets.all(3.w),
            decoration: BoxDecoration(
              color: const Color(0xFF2A2A2A),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                _buildMethodOption('authenticator', 'Authenticator App', Icons.smartphone),
                SizedBox(width: 3.w),
                _buildMethodOption('sms', 'SMS', Icons.message),
                SizedBox(width: 3.w),
                _buildMethodOption('email', 'Email', Icons.email),
              ],
            ),
          ),
          
          SizedBox(height: 4.h),
          
          // Instructions
          Text(
            _getInstructionText(),
            style: GoogleFonts.inter(
              color: const Color(0xFF7B7B7B),
              fontSize: 14.sp,
            ),
            textAlign: TextAlign.center,
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
          
          // Code input fields
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: List.generate(6, (index) => _buildCodeField(index)),
          ),
          
          SizedBox(height: 4.h),
          
          // Verify button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _isLoading ? null : _verifyCode,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF007AFF),
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(vertical: 4.w),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                elevation: 0,
              ),
              child: _isLoading
                  ? SizedBox(
                      width: 5.w,
                      height: 5.w,
                      child: const CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    )
                  : Text(
                      'Verify Code',
                      style: GoogleFonts.inter(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
            ),
          ),
          
          SizedBox(height: 3.h),
          
          // Resend code
          TextButton(
            onPressed: _isLoading ? null : _resendCode,
            child: Text(
              'Resend Code',
              style: GoogleFonts.inter(
                color: const Color(0xFF007AFF),
                fontSize: 14.sp,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMethodOption(String method, String label, IconData icon) {
    final isSelected = _selectedMethod == method;
    
    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            _selectedMethod = method;
          });
        },
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 2.w, horizontal: 1.w),
          decoration: BoxDecoration(
            color: isSelected ? const Color(0xFF007AFF) : Colors.transparent,
            borderRadius: BorderRadius.circular(6),
          ),
          child: Column(
            children: [
              Icon(
                icon,
                color: isSelected ? Colors.white : const Color(0xFF7B7B7B),
                size: 5.w,
              ),
              SizedBox(height: 1.w),
              Text(
                label,
                style: GoogleFonts.inter(
                  color: isSelected ? Colors.white : const Color(0xFF7B7B7B),
                  fontSize: 10.sp,
                  fontWeight: FontWeight.w500,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCodeField(int index) {
    return Container(
      width: 12.w,
      height: 12.w,
      decoration: BoxDecoration(
        color: const Color(0xFF2A2A2A),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: _codeFocusNodes[index].hasFocus 
              ? const Color(0xFF007AFF)
              : const Color(0xFF7B7B7B).withAlpha(77),
          width: 1,
        ),
      ),
      child: TextField(
        controller: _codeControllers[index],
        focusNode: _codeFocusNodes[index],
        textAlign: TextAlign.center,
        keyboardType: TextInputType.number,
        maxLength: 1,
        style: GoogleFonts.inter(
          color: const Color(0xFFF1F1F1),
          fontSize: 18.sp,
          fontWeight: FontWeight.w600,
        ),
        decoration: const InputDecoration(
          border: InputBorder.none,
          counterText: '',
        ),
        inputFormatters: [
          FilteringTextInputFormatter.digitsOnly,
        ],
        onChanged: (value) => _handleCodeInput(value, index),
        onTap: () {
          _codeControllers[index].selection = TextSelection.fromPosition(
            TextPosition(offset: _codeControllers[index].text.length),
          );
        },
      ),
    );
  }

  String _getInstructionText() {
    switch (_selectedMethod) {
      case 'authenticator':
        return 'Enter the 6-digit code from your authenticator app';
      case 'sms':
        return 'Enter the 6-digit code sent to your phone';
      case 'email':
        return 'Enter the 6-digit code sent to your email';
      default:
        return 'Enter the 6-digit verification code';
    }
  }
}