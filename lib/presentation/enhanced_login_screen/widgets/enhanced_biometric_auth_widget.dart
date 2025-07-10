import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sizer/sizer.dart';

class EnhancedBiometricAuthWidget extends StatefulWidget {
  final VoidCallback onBiometricAuth;
  final bool isLoading;

  const EnhancedBiometricAuthWidget({
    super.key,
    required this.onBiometricAuth,
    required this.isLoading,
  });

  @override
  State<EnhancedBiometricAuthWidget> createState() => _EnhancedBiometricAuthWidgetState();
}

class _EnhancedBiometricAuthWidgetState extends State<EnhancedBiometricAuthWidget> {
  bool _isBiometricAvailable = true;
  bool _isPressed = false;

  @override
  void initState() {
    super.initState();
    _checkBiometricAvailability();
  }

  void _checkBiometricAvailability() {
    // Simulate biometric availability check
    // In real implementation, use local_auth package
    setState(() {
      _isBiometricAvailable = true;
    });
  }

  void _handleBiometricAuth() {
    if (!_isBiometricAvailable || widget.isLoading) return;
    
    HapticFeedback.lightImpact();
    widget.onBiometricAuth();
  }

  @override
  Widget build(BuildContext context) {
    if (!_isBiometricAvailable) {
      return const SizedBox.shrink();
    }

    return Column(
      children: [
        // Divider with "OR" text
        Row(
          children: [
            Expanded(
              child: Container(
                height: 1,
                color: const Color(0xFF7B7B7B).withAlpha(77),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 4.w),
              child: Text(
                'OR',
                style: GoogleFonts.inter(
                  color: const Color(0xFF7B7B7B),
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            Expanded(
              child: Container(
                height: 1,
                color: const Color(0xFF7B7B7B).withAlpha(77),
              ),
            ),
          ],
        ),
        
        SizedBox(height: 3.h),
        
        // Biometric authentication button
        GestureDetector(
          onTapDown: (_) {
            setState(() {
              _isPressed = true;
            });
          },
          onTapUp: (_) {
            setState(() {
              _isPressed = false;
            });
          },
          onTapCancel: () {
            setState(() {
              _isPressed = false;
            });
          },
          onTap: _handleBiometricAuth,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 150),
            width: 15.w,
            height: 15.w,
            decoration: BoxDecoration(
              color: _isPressed 
                  ? const Color(0xFF191919) 
                  : const Color(0xFF2A2A2A),
              shape: BoxShape.circle,
              border: Border.all(
                color: const Color(0xFF7B7B7B).withAlpha(77),
                width: 1,
              ),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF000000).withAlpha(51),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Icon(
              Icons.fingerprint,
              color: widget.isLoading 
                  ? const Color(0xFF7B7B7B).withAlpha(128)
                  : const Color(0xFFF1F1F1),
              size: 8.w,
            ),
          ),
        ),
        
        SizedBox(height: 2.h),
        
        // Biometric auth label
        Text(
          'Use biometric authentication',
          style: GoogleFonts.inter(
            color: const Color(0xFF7B7B7B),
            fontSize: 13.sp,
            fontWeight: FontWeight.w400,
          ),
        ),
        
        SizedBox(height: 1.h),
        
        Text(
          'Touch the fingerprint sensor or use Face ID',
          style: GoogleFonts.inter(
            color: const Color(0xFF7B7B7B).withAlpha(179),
            fontSize: 11.sp,
            fontWeight: FontWeight.w400,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}