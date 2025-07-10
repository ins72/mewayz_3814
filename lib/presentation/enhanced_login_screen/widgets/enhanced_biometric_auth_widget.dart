import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sizer/sizer.dart';
import '../../../services/enhanced_auth_service.dart';

class EnhancedBiometricAuthWidget extends StatefulWidget {
  final VoidCallback onBiometricAuth;
  final bool isLoading;
  final EnhancedAuthService? authService;

  const EnhancedBiometricAuthWidget({
    super.key,
    required this.onBiometricAuth,
    required this.isLoading,
    this.authService,
  });

  @override
  State<EnhancedBiometricAuthWidget> createState() => _EnhancedBiometricAuthWidgetState();
}

class _EnhancedBiometricAuthWidgetState extends State<EnhancedBiometricAuthWidget> {
  bool _isBiometricAvailable = false;
  bool _isDeviceRegistered = false;
  bool _isPressed = false;
  late final EnhancedAuthService _authService;

  @override
  void initState() {
    super.initState();
    _authService = widget.authService ?? EnhancedAuthService();
    _checkBiometricStatus();
  }

  void _checkBiometricStatus() async {
    try {
      final isAvailable = await _authService.isBiometricAvailable();
      final isRegistered = await _authService.checkDeviceRegistration();
      
      setState(() {
        _isBiometricAvailable = isAvailable;
        _isDeviceRegistered = isRegistered;
      });
    } catch (e) {
      debugPrint('Error checking biometric status: $e');
      setState(() {
        _isBiometricAvailable = false;
        _isDeviceRegistered = false;
      });
    }
  }

  void _handleBiometricAuth() async {
    if (!_isBiometricAvailable || widget.isLoading) return;
    
    HapticFeedback.lightImpact();
    
    try {
      if (_isDeviceRegistered) {
        // Existing user - authenticate with biometrics
        final response = await _authService.authenticateWithBiometrics();
        widget.onBiometricAuth();
            } else {
        // New device - show registration dialog
        _showBiometricRegistrationDialog();
      }
    } catch (e) {
      _showErrorSnackBar('Biometric authentication failed: ${e.toString()}');
    }
  }

  void _showBiometricRegistrationDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => _BiometricRegistrationDialog(
        authService: _authService,
        onRegistrationComplete: () {
          Navigator.of(context).pop();
          setState(() {
            _isDeviceRegistered = true;
          });
          widget.onBiometricAuth();
        },
        onError: (error) {
          Navigator.of(context).pop();
          _showErrorSnackBar(error);
        },
      ),
    );
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: const Color(0xFFFF6B6B),
        behavior: SnackBarBehavior.floating,
      ),
    );
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
                color: _isDeviceRegistered 
                    ? const Color(0xFF007AFF).withAlpha(128)
                    : const Color(0xFF7B7B7B).withAlpha(77),
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
                  : (_isDeviceRegistered 
                      ? const Color(0xFF007AFF)
                      : const Color(0xFFF1F1F1)),
              size: 8.w,
            ),
          ),
        ),
        
        SizedBox(height: 2.h),
        
        // Biometric auth label
        Text(
          _isDeviceRegistered 
              ? 'Use biometric authentication'
              : 'Register device for biometric login',
          style: GoogleFonts.inter(
            color: const Color(0xFF7B7B7B),
            fontSize: 13.sp,
            fontWeight: FontWeight.w400,
          ),
        ),
        
        SizedBox(height: 1.h),
        
        Text(
          _isDeviceRegistered
              ? 'Touch the fingerprint sensor or use Face ID'
              : 'Set up biometric login for this device',
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

class _BiometricRegistrationDialog extends StatefulWidget {
  final EnhancedAuthService authService;
  final VoidCallback onRegistrationComplete;
  final Function(String) onError;

  const _BiometricRegistrationDialog({
    required this.authService,
    required this.onRegistrationComplete,
    required this.onError,
  });

  @override
  State<_BiometricRegistrationDialog> createState() => _BiometricRegistrationDialogState();
}

class _BiometricRegistrationDialogState extends State<_BiometricRegistrationDialog> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  bool _skipCredentials = false;
  bool _isLoading = false;

  void _handleRegistration() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final result = await widget.authService.registerDevice(
        email: _skipCredentials ? null : _emailController.text.trim(),
        fullName: _skipCredentials ? null : _nameController.text.trim(),
      );

      if (result != null) {
        widget.onRegistrationComplete();
      }
    } catch (e) {
      widget.onError(e.toString());
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: const Color(0xFF191919),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Register Device',
              style: GoogleFonts.inter(
                color: const Color(0xFFF1F1F1),
                fontSize: 20,
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),
            
            const SizedBox(height: 16),
            
            Text(
              'Set up biometric authentication for this device. You can add email and name now, or skip and add them later.',
              style: GoogleFonts.inter(
                color: const Color(0xFF7B7B7B),
                fontSize: 14,
              ),
              textAlign: TextAlign.center,
            ),
            
            const SizedBox(height: 24),
            
            if (!_skipCredentials) ...[
              // Email field
              TextField(
                controller: _emailController,
                decoration: InputDecoration(
                  labelText: 'Email (Optional)',
                  labelStyle: GoogleFonts.inter(color: const Color(0xFF7B7B7B)),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(color: Color(0xFF7B7B7B)),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(color: Color(0xFF7B7B7B)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(color: Color(0xFF007AFF)),
                  ),
                ),
                style: GoogleFonts.inter(color: const Color(0xFFF1F1F1)),
                keyboardType: TextInputType.emailAddress,
              ),
              
              const SizedBox(height: 16),
              
              // Name field
              TextField(
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: 'Full Name (Optional)',
                  labelStyle: GoogleFonts.inter(color: const Color(0xFF7B7B7B)),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(color: Color(0xFF7B7B7B)),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(color: Color(0xFF7B7B7B)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(color: Color(0xFF007AFF)),
                  ),
                ),
                style: GoogleFonts.inter(color: const Color(0xFFF1F1F1)),
              ),
              
              const SizedBox(height: 16),
              
              // Skip credentials option
              Row(
                children: [
                  Checkbox(
                    value: _skipCredentials,
                    onChanged: (value) {
                      setState(() {
                        _skipCredentials = value ?? false;
                      });
                    },
                    fillColor: WidgetStateProperty.all(const Color(0xFF007AFF)),
                  ),
                  Expanded(
                    child: Text(
                      'Skip for now (use device info only)',
                      style: GoogleFonts.inter(
                        color: const Color(0xFF7B7B7B),
                        fontSize: 14,
                      ),
                    ),
                  ),
                ],
              ),
              
              const SizedBox(height: 24),
            ],
            
            // Register button
            ElevatedButton(
              onPressed: _isLoading ? null : _handleRegistration,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF007AFF),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: _isLoading
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    )
                  : Text(
                      'Register with Biometrics',
                      style: GoogleFonts.inter(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
            ),
            
            const SizedBox(height: 12),
            
            // Cancel button
            TextButton(
              onPressed: _isLoading ? null : () => Navigator.of(context).pop(),
              child: Text(
                'Cancel',
                style: GoogleFonts.inter(
                  color: const Color(0xFF7B7B7B),
                  fontSize: 16,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _nameController.dispose();
    super.dispose();
  }
}