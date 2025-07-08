import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../core/app_export.dart';
import './widgets/authenticator_verification_widget.dart';
import './widgets/backup_codes_widget.dart';
import './widgets/email_verification_widget.dart';
import './widgets/sms_verification_widget.dart';

class TwoFactorAuthenticationScreen extends StatefulWidget {
  const TwoFactorAuthenticationScreen({Key? key}) : super(key: key);

  @override
  State<TwoFactorAuthenticationScreen> createState() =>
      _TwoFactorAuthenticationScreenState();
}

class _TwoFactorAuthenticationScreenState
    extends State<TwoFactorAuthenticationScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  String phoneNumber = '';
  String emailAddress = '';
  String verificationCode = '';
  bool isLoading = false;
  bool trustDevice = false;
  String? errorMessage;
  int attemptCount = 0;
  int maxAttempts = 5;
  int resendCountdown = 30;
  bool canResend = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _startResendTimer();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Get user data from route arguments
    final args =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
    phoneNumber = args?['phoneNumber'] ?? '+1 (555) 123-4567';
    emailAddress = args?['email'] ?? 'user@example.com';
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _startResendTimer() {
    Future.delayed(const Duration(seconds: 1), () {
      if (mounted && resendCountdown > 0) {
        setState(() {
          resendCountdown--;
        });
        _startResendTimer();
      } else if (mounted) {
        setState(() {
          canResend = true;
        });
      }
    });
  }

  Future<void> _sendVerificationCode() async {
    if (!canResend) return;

    setState(() {
      isLoading = true;
      errorMessage = null;
    });

    try {
      // Simulate API call
      await Future.delayed(const Duration(seconds: 2));

      if (mounted) {
        setState(() {
          isLoading = false;
          canResend = false;
          resendCountdown = 30;
        });
        _startResendTimer();

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Verification code sent successfully'),
            backgroundColor: AppTheme.success,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          isLoading = false;
          errorMessage = 'Failed to send verification code. Please try again.';
        });
      }
    }
  }

  Future<void> _verifyCode(String code) async {
    if (code.length != 6) return;

    setState(() {
      isLoading = true;
      errorMessage = null;
    });

    try {
      // Simulate API call
      await Future.delayed(const Duration(seconds: 2));

      // Simulate verification logic
      if (code == '123456') {
        // Success - navigate to dashboard
        if (mounted) {
          // Haptic feedback for success
          HapticFeedback.lightImpact();

          Navigator.pushNamedAndRemoveUntil(
            context,
            AppRoutes.workspaceDashboard,
            (route) => false,
          );
        }
      } else {
        // Invalid code
        if (mounted) {
          setState(() {
            isLoading = false;
            attemptCount++;
            errorMessage = 'Invalid verification code. Please try again.';
          });

          // Haptic feedback for error
          HapticFeedback.vibrate();

          if (attemptCount >= maxAttempts) {
            setState(() {
              errorMessage =
                  'Too many failed attempts. Please try again later.';
            });
          }
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          isLoading = false;
          errorMessage = 'Verification failed. Please try again.';
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.primaryBackground,
      appBar: AppBar(
        backgroundColor: AppTheme.primaryBackground,
        elevation: 0,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(
            Icons.arrow_back_ios,
            color: AppTheme.primaryText,
            size: 20,
          ),
        ),
        title: Text(
          'Two-Factor Authentication',
          style: GoogleFonts.inter(
            fontSize: 18,
            fontWeight: FontWeight.w500,
            color: AppTheme.primaryText,
          ),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Security Header
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  // Security Icon
                  Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      color: AppTheme.surface,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: AppTheme.accent.withValues(alpha: 0.3),
                        width: 2,
                      ),
                    ),
                    child: Icon(
                      Icons.security,
                      size: 40,
                      color: AppTheme.accent,
                    ),
                  ),

                  const SizedBox(height: 16),

                  Text(
                    'Two-Factor Authentication',
                    style: GoogleFonts.inter(
                      fontSize: 24,
                      fontWeight: FontWeight.w600,
                      color: AppTheme.primaryText,
                    ),
                    textAlign: TextAlign.center,
                  ),

                  const SizedBox(height: 8),

                  Text(
                    'Choose your preferred verification method',
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      color: AppTheme.secondaryText,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),

            // Tab Bar
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 24),
              decoration: BoxDecoration(
                color: AppTheme.surface,
                borderRadius: BorderRadius.circular(12),
              ),
              child: TabBar(
                controller: _tabController,
                indicator: BoxDecoration(
                  color: AppTheme.accent,
                  borderRadius: BorderRadius.circular(8),
                ),
                indicatorSize: TabBarIndicatorSize.tab,
                labelColor: AppTheme.primaryText,
                unselectedLabelColor: AppTheme.secondaryText,
                labelStyle: GoogleFonts.inter(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
                unselectedLabelStyle: GoogleFonts.inter(
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                ),
                tabs: const [
                  Tab(text: 'SMS'),
                  Tab(text: 'Email'),
                  Tab(text: 'Authenticator'),
                ],
              ),
            ),

            // Tab Content
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  // SMS Verification
                  SmsVerificationWidget(
                    phoneNumber: phoneNumber,
                    verificationCode: verificationCode,
                    isLoading: isLoading,
                    canResend: canResend,
                    resendCountdown: resendCountdown,
                    errorMessage: errorMessage,
                    attemptCount: attemptCount,
                    maxAttempts: maxAttempts,
                    onCodeChanged: (code) {
                      setState(() {
                        verificationCode = code;
                      });
                      if (code.length == 6) {
                        _verifyCode(code);
                      }
                    },
                    onResendCode: _sendVerificationCode,
                  ),

                  // Email Verification
                  EmailVerificationWidget(
                    emailAddress: emailAddress,
                    verificationCode: verificationCode,
                    isLoading: isLoading,
                    canResend: canResend,
                    resendCountdown: resendCountdown,
                    errorMessage: errorMessage,
                    attemptCount: attemptCount,
                    maxAttempts: maxAttempts,
                    onCodeChanged: (code) {
                      setState(() {
                        verificationCode = code;
                      });
                      if (code.length == 6) {
                        _verifyCode(code);
                      }
                    },
                    onResendCode: _sendVerificationCode,
                  ),

                  // Authenticator App
                  AuthenticatorVerificationWidget(
                    verificationCode: verificationCode,
                    isLoading: isLoading,
                    errorMessage: errorMessage,
                    attemptCount: attemptCount,
                    maxAttempts: maxAttempts,
                    onCodeChanged: (code) {
                      setState(() {
                        verificationCode = code;
                      });
                      if (code.length == 6) {
                        _verifyCode(code);
                      }
                    },
                  ),
                ],
              ),
            ),

            // Trust Device & Backup Codes
            Container(
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  // Trust Device Checkbox
                  Row(
                    children: [
                      Checkbox(
                        value: trustDevice,
                        onChanged: (value) {
                          setState(() {
                            trustDevice = value ?? false;
                          });
                        },
                        fillColor: WidgetStateProperty.resolveWith((states) {
                          if (states.contains(WidgetState.selected)) {
                            return AppTheme.accent;
                          }
                          return Colors.transparent;
                        }),
                        checkColor: AppTheme.primaryText,
                        side: const BorderSide(
                          color: AppTheme.border,
                          width: 2,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          'Trust this device for 30 days',
                          style: GoogleFonts.inter(
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                            color: AppTheme.primaryText,
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),

                  // Backup Codes Link
                  TextButton(
                    onPressed: () {
                      showModalBottomSheet(
                        context: context,
                        backgroundColor: AppTheme.surface,
                        isScrollControlled: true,
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(20),
                            topRight: Radius.circular(20),
                          ),
                        ),
                        builder: (context) => const BackupCodesWidget(),
                      );
                    },
                    style: TextButton.styleFrom(
                      foregroundColor: AppTheme.accent,
                      padding: const EdgeInsets.symmetric(vertical: 8),
                    ),
                    child: Text(
                      'View Backup Codes',
                      style: GoogleFonts.inter(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}