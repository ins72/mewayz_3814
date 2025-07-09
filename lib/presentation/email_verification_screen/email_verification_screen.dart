
import '../../core/app_export.dart';
import './widgets/email_verification_form_widget.dart';
import './widgets/email_verification_status_widget.dart';

class EmailVerificationScreen extends StatefulWidget {
  const EmailVerificationScreen({Key? key}) : super(key: key);

  @override
  State<EmailVerificationScreen> createState() => _EmailVerificationScreenState();
}

class _EmailVerificationScreenState extends State<EmailVerificationScreen> {
  final TextEditingController _codeController = TextEditingController();
  final FocusNode _codeFocusNode = FocusNode();
  
  bool _isVerifying = false;
  bool _isResendingCode = false;
  String? _errorMessage;
  String? _successMessage;
  String _email = '';
  String _fullName = '';
  int _resendCooldown = 0;
  
  late AuthService _authService;

  @override
  void initState() {
    super.initState();
    _authService = AuthService();
    
    // Get arguments from navigation
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final args = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
      if (args != null) {
        setState(() {
          _email = args['email'] ?? '';
          _fullName = args['fullName'] ?? '';
        });
      }
    });
  }

  @override
  void dispose() {
    _codeController.dispose();
    _codeFocusNode.dispose();
    super.dispose();
  }

  Future<void> _verifyEmail() async {
    if (_codeController.text.length != 6) {
      setState(() {
        _errorMessage = 'Please enter a 6-digit verification code';
      });
      return;
    }

    setState(() {
      _isVerifying = true;
      _errorMessage = null;
      _successMessage = null;
    });

    try {
      final isVerified = await _authService.verifyEmail(_codeController.text);
      
      if (isVerified) {
        setState(() {
          _successMessage = 'Email verified successfully!';
        });
        
        // Wait a moment to show success message
        await Future.delayed(const Duration(seconds: 2));
        
        // Navigate to onboarding or dashboard
        Navigator.pushNamedAndRemoveUntil(
          context,
          AppRoutes.userOnboardingScreen,
          (route) => false);
      } else {
        setState(() {
          _errorMessage = 'Invalid verification code. Please try again.';
        });
        _codeController.clear();
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Verification failed: ${e.toString()}';
      });
      _codeController.clear();
    } finally {
      setState(() {
        _isVerifying = false;
      });
    }
  }

  Future<void> _resendVerificationCode() async {
    if (_resendCooldown > 0) return;

    setState(() {
      _isResendingCode = true;
      _errorMessage = null;
      _successMessage = null;
    });

    try {
      // In a real app, this would call a resend API
      // For now, we'll simulate the API call
      await Future.delayed(const Duration(seconds: 2));
      
      setState(() {
        _successMessage = 'Verification code sent to $_email';
        _resendCooldown = 60;
      });
      
      // Start cooldown timer
      _startResendCooldown();
    } catch (e) {
      setState(() {
        _errorMessage = 'Failed to resend verification code: ${e.toString()}';
      });
    } finally {
      setState(() {
        _isResendingCode = false;
      });
    }
  }

  void _startResendCooldown() {
    Future.delayed(const Duration(seconds: 1), () {
      if (mounted && _resendCooldown > 0) {
        setState(() {
          _resendCooldown--;
        });
        _startResendCooldown();
      }
    });
  }

  void _handleBackToLogin() {
    Navigator.pushNamedAndRemoveUntil(
      context,
      AppRoutes.loginScreen,
      (route) => false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.primaryBackground,
      appBar: AppBar(
        backgroundColor: AppTheme.primaryBackground,
        elevation: 0,
        leading: IconButton(
          icon: CustomIconWidget(
            iconName: 'arrow_back',
            color: AppTheme.primaryText,
            size: 6.w),
          onPressed: _handleBackToLogin),
        title: Text(
          'Email Verification',
          style: AppTheme.darkTheme.textTheme.titleLarge?.copyWith(
            color: AppTheme.primaryText,
            fontWeight: FontWeight.w600))),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(6.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(height: 4.h),

              // Email Verification Status
              EmailVerificationStatusWidget(
                userEmail: _email,
                onOpenEmailApp: () {
                  // Add your email app opening logic here
                }),

              SizedBox(height: 6.h),

              // Email Verification Form
              EmailVerificationFormWidget(
                codeController: _codeController,
                codeFocusNode: _codeFocusNode,
                isVerifying: _isVerifying,
                isResendingCode: _isResendingCode,
                errorMessage: _errorMessage,
                resendCooldown: _resendCooldown,
                onVerify: _verifyEmail,
                onResendCode: _resendVerificationCode),

              SizedBox(height: 6.h),

              // Back to Login Link
              Center(
                child: GestureDetector(
                  onTap: _handleBackToLogin,
                  child: Text(
                    'Back to Login',
                    style: AppTheme.darkTheme.textTheme.bodyMedium?.copyWith(
                      color: AppTheme.accent,
                      decoration: TextDecoration.underline)))),
            ]))));
  }
}