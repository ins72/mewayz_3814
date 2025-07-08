import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../core/app_export.dart';
import '../../routes/app_routes.dart';
import '../../widgets/custom_image_widget.dart';
import '../../widgets/custom_icon_widget.dart';
import 'widgets/email_verification_form_widget.dart';
import 'widgets/email_verification_status_widget.dart';

class EmailVerificationScreen extends StatefulWidget {
  const EmailVerificationScreen({Key? key}) : super(key: key);

  @override
  State<EmailVerificationScreen> createState() => _EmailVerificationScreenState();
}

class _EmailVerificationScreenState extends State<EmailVerificationScreen> {
  late String userEmail;
  bool isLoading = false;
  bool isResendLoading = false;
  int resendCountdown = 60;
  bool canResend = false;
  String? errorMessage;
  String? successMessage;

  @override
  void initState() {
    super.initState();
    _startResendTimer();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Get email from route arguments
    final args = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
    userEmail = args?['email'] ?? 'user@example.com';
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

  Future<void> _resendVerificationEmail() async {
    if (!canResend || isResendLoading) return;

    setState(() {
      isResendLoading = true;
      errorMessage = null;
      successMessage = null;
    });

    try {
      // Simulate API call
      await Future.delayed(const Duration(seconds: 2));
      
      if (mounted) {
        setState(() {
          isResendLoading = false;
          canResend = false;
          resendCountdown = 60;
          successMessage = 'Verification email sent successfully!';
        });
        _startResendTimer();
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          isResendLoading = false;
          errorMessage = 'Failed to send verification email. Please try again.';
        });
      }
    }
  }

  Future<void> _changeEmail() async {
    Navigator.pop(context);
  }

  Future<void> _openEmailApp() async {
    final Uri emailLaunchUri = Uri(
      scheme: 'mailto',
      path: '',
    );

    try {
      await launchUrl(emailLaunchUri);
    } catch (e) {
      // Handle error if email app cannot be opened
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Could not open email app'),
            backgroundColor: AppTheme.error,
          ),
        );
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
          'Email Verification',
          style: GoogleFonts.inter(
            fontSize: 18,
            fontWeight: FontWeight.w500,
            color: AppTheme.primaryText,
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 40),
              
              // Mewayz Logo
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: AppTheme.surface,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Center(
                  child: CustomImageWidget(
                    imagePath: 'assets/images/img_app_logo.svg',
                    width: 40,
                    height: 40,
                  ),
                ),
              ),
              
              const SizedBox(height: 32),
              
              // Email Verification Status Widget
              EmailVerificationStatusWidget(
                userEmail: userEmail,
                onOpenEmailApp: _openEmailApp,
              ),
              
              const SizedBox(height: 40),
              
              // Email Icon with Checkmark
              Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  color: AppTheme.surface,
                  borderRadius: BorderRadius.circular(50),
                  border: Border.all(
                    color: AppTheme.success.withValues(alpha: 0.3),
                    width: 2,
                  ),
                ),
                child: Stack(
                  children: [
                    const Center(
                      child: Icon(
                        Icons.email_outlined,
                        size: 40,
                        color: AppTheme.primaryText,
                      ),
                    ),
                    Positioned(
                      bottom: 10,
                      right: 10,
                      child: Container(
                        width: 28,
                        height: 28,
                        decoration: BoxDecoration(
                          color: AppTheme.success,
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: const Icon(
                          Icons.check,
                          size: 16,
                          color: AppTheme.primaryText,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              
              const SizedBox(height: 32),
              
              // Success/Error Messages
              if (successMessage != null)
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  margin: const EdgeInsets.only(bottom: 16),
                  decoration: BoxDecoration(
                    color: AppTheme.success.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: AppTheme.success.withValues(alpha: 0.3),
                      width: 1,
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.check_circle,
                        color: AppTheme.success,
                        size: 20,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          successMessage!,
                          style: GoogleFonts.inter(
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                            color: AppTheme.success,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              
              if (errorMessage != null)
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  margin: const EdgeInsets.only(bottom: 16),
                  decoration: BoxDecoration(
                    color: AppTheme.error.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: AppTheme.error.withValues(alpha: 0.3),
                      width: 1,
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.error_outline,
                        color: AppTheme.error,
                        size: 20,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          errorMessage!,
                          style: GoogleFonts.inter(
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                            color: AppTheme.error,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              
              // Resend Email Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: canResend && !isResendLoading ? _resendVerificationEmail : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: canResend && !isResendLoading 
                        ? AppTheme.primaryAction 
                        : AppTheme.surface,
                    foregroundColor: canResend && !isResendLoading 
                        ? AppTheme.primaryBackground 
                        : AppTheme.secondaryText,
                    elevation: 0,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: isResendLoading
                      ? SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(
                              AppTheme.secondaryText,
                            ),
                          ),
                        )
                      : Text(
                          canResend 
                              ? 'Resend Email' 
                              : 'Resend Email (${resendCountdown}s)',
                          style: GoogleFonts.inter(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                ),
              ),
              
              const SizedBox(height: 16),
              
              // Change Email Button
              SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  onPressed: _changeEmail,
                  style: OutlinedButton.styleFrom(
                    backgroundColor: AppTheme.surface,
                    foregroundColor: AppTheme.primaryText,
                    side: const BorderSide(
                      color: AppTheme.border,
                      width: 1,
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    'Change Email Address',
                    style: GoogleFonts.inter(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
              
              const SizedBox(height: 32),
              
              // Security Note
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppTheme.surface,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: AppTheme.border,
                    width: 1,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.security,
                          color: AppTheme.accent,
                          size: 20,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'Security Notice',
                          style: GoogleFonts.inter(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: AppTheme.primaryText,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'The verification link will expire in 24 hours. If you don\'t verify your email within this time, you\'ll need to request a new verification email.',
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                        color: AppTheme.secondaryText,
                        height: 1.4,
                      ),
                    ),
                  ],
                ),
              ),
              
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }
}