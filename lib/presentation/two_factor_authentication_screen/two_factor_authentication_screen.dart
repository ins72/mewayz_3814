
import '../../core/app_export.dart';
import './widgets/authenticator_verification_widget.dart';
import './widgets/backup_codes_widget.dart';
import './widgets/email_verification_widget.dart';
import './widgets/sms_verification_widget.dart';

class TwoFactorAuthenticationScreen extends StatefulWidget {
  const TwoFactorAuthenticationScreen({Key? key}) : super(key: key);

  @override
  State<TwoFactorAuthenticationScreen> createState() => _TwoFactorAuthenticationScreenState();
}

class _TwoFactorAuthenticationScreenState extends State<TwoFactorAuthenticationScreen> 
    with TickerProviderStateMixin {
  late TabController _tabController;
  final TextEditingController _codeController = TextEditingController();
  final FocusNode _codeFocusNode = FocusNode();
  
  bool _isLoading = false;
  bool _is2FAEnabled = false;
  String? _errorMessage;
  String? _successMessage;
  String _secretKey = '';
  List<String> _backupCodes = [];
  int _selectedVerificationMethod = 0;
  
  late AuthService _authService;

  @override
  void initState() {
    super.initState();
    _authService = AuthService();
    _tabController = TabController(length: 4, vsync: this);
    _load2FAStatus();
  }

  @override
  void dispose() {
    _tabController.dispose();
    _codeController.dispose();
    _codeFocusNode.dispose();
    super.dispose();
  }

  Future<void> _load2FAStatus() async {
    setState(() {
      _isLoading = true;
    });

    try {
      // Load 2FA status from Supabase
      final userId = _authService.currentUser?.id;
      if (userId != null) {
        final client = await SupabaseService().client;
        final response = await client
            .from('user_two_factor_auth')
            .select('is_enabled, secret_key, backup_codes')
            .eq('user_id', userId)
            .maybeSingle();
        
        if (response != null) {
          setState(() {
            _is2FAEnabled = response['is_enabled'] ?? false;
            _secretKey = response['secret_key'] ?? '';
            _backupCodes = List<String>.from(response['backup_codes'] ?? []);
          });
        }
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Failed to load 2FA status: ${e.toString()}';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _enable2FA() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
      _successMessage = null;
    });

    try {
      final secretKey = await _authService.enableTwoFactorAuth();
      final backupCodes = await _authService.generateBackupCodes();
      
      setState(() {
        _is2FAEnabled = true;
        _secretKey = secretKey;
        _backupCodes = backupCodes;
        _successMessage = 'Two-factor authentication enabled successfully!';
      });

      // Show backup codes
      _showBackupCodesDialog();
    } catch (e) {
      setState(() {
        _errorMessage = 'Failed to enable 2FA: ${e.toString()}';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _disable2FA() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
      _successMessage = null;
    });

    try {
      final userId = _authService.currentUser?.id;
      if (userId != null) {
        final client = await SupabaseService().client;
        await client
            .from('user_two_factor_auth')
            .update({
              'is_enabled': false,
              'secret_key': null,
              'backup_codes': null,
              'updated_at': DateTime.now().toIso8601String(),
            })
            .eq('user_id', userId);
        
        setState(() {
          _is2FAEnabled = false;
          _secretKey = '';
          _backupCodes = [];
          _successMessage = 'Two-factor authentication disabled successfully!';
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Failed to disable 2FA: ${e.toString()}';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _verifyCode() async {
    if (_codeController.text.length != 6) {
      setState(() {
        _errorMessage = 'Please enter a 6-digit verification code';
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
      _successMessage = null;
    });

    try {
      final isValid = await _authService.verifyTwoFactorCode(_codeController.text);
      
      if (isValid) {
        setState(() {
          _successMessage = 'Code verified successfully!';
        });
        _codeController.clear();
        
        // Navigate back or to next step
        Future.delayed(const Duration(seconds: 2), () {
          Navigator.pop(context);
        });
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
        _isLoading = false;
      });
    }
  }

  Future<void> _regenerateBackupCodes() async {
    try {
      final newCodes = await _authService.generateBackupCodes();
      setState(() {
        _backupCodes = newCodes;
        _successMessage = 'Backup codes regenerated successfully!';
      });
      _showBackupCodesDialog();
    } catch (e) {
      setState(() {
        _errorMessage = 'Failed to regenerate backup codes: ${e.toString()}';
      });
    }
  }

  void _showBackupCodesDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        backgroundColor: AppTheme.surface,
        title: Text(
          'Backup Codes',
          style: AppTheme.darkTheme.textTheme.titleLarge?.copyWith(
            color: AppTheme.primaryText)),
        content: BackupCodesWidget(),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'I have saved these codes',
              style: TextStyle(color: AppTheme.primaryAction))),
        ]));
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
          onPressed: () => Navigator.pop(context)),
        title: Text(
          'Two-Factor Authentication',
          style: AppTheme.darkTheme.textTheme.titleLarge?.copyWith(
            color: AppTheme.primaryText,
            fontWeight: FontWeight.w600)),
        actions: [
          if (_is2FAEnabled)
            IconButton(
              icon: CustomIconWidget(
                iconName: 'settings',
                color: AppTheme.primaryText,
                size: 6.w),
              onPressed: () {
                // Show 2FA settings
              }),
        ]),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(AppTheme.primaryAction)))
          : SafeArea(
              child: Column(
                children: [
                  // Status Messages
                  if (_errorMessage != null || _successMessage != null)
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.all(4.w),
                      margin: EdgeInsets.all(4.w),
                      decoration: BoxDecoration(
                        color: _errorMessage != null
                            ? AppTheme.error.withAlpha(26)
                            : AppTheme.success.withAlpha(26),
                        borderRadius: BorderRadius.circular(2.w),
                        border: Border.all(
                          color: _errorMessage != null
                              ? AppTheme.error.withAlpha(77)
                              : AppTheme.success.withAlpha(77),
                          width: 1)),
                      child: Row(
                        children: [
                          CustomIconWidget(
                            iconName: _errorMessage != null ? 'error_outline' : 'check_circle',
                            color: _errorMessage != null ? AppTheme.error : AppTheme.success,
                            size: 5.w),
                          SizedBox(width: 2.w),
                          Expanded(
                            child: Text(
                              _errorMessage ?? _successMessage ?? '',
                              style: AppTheme.darkTheme.textTheme.bodySmall?.copyWith(
                                color: _errorMessage != null ? AppTheme.error : AppTheme.success))),
                        ])),

                  // 2FA Status Header
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(4.w),
                    margin: EdgeInsets.symmetric(horizontal: 4.w),
                    decoration: BoxDecoration(
                      color: AppTheme.surface,
                      borderRadius: BorderRadius.circular(3.w)),
                    child: Row(
                      children: [
                        Container(
                          width: 12.w,
                          height: 12.w,
                          decoration: BoxDecoration(
                            color: _is2FAEnabled ? AppTheme.success : AppTheme.error,
                            shape: BoxShape.circle),
                          child: Center(
                            child: CustomIconWidget(
                              iconName: _is2FAEnabled ? 'shield' : 'shield_off',
                              color: AppTheme.primaryBackground,
                              size: 6.w))),
                        SizedBox(width: 4.w),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                _is2FAEnabled ? 'Two-Factor Authentication Enabled' : 'Two-Factor Authentication Disabled',
                                style: AppTheme.darkTheme.textTheme.titleMedium?.copyWith(
                                  color: AppTheme.primaryText,
                                  fontWeight: FontWeight.w600)),
                              SizedBox(height: 1.h),
                              Text(
                                _is2FAEnabled 
                                    ? 'Your account is protected with two-factor authentication'
                                    : 'Enable two-factor authentication to secure your account',
                                style: AppTheme.darkTheme.textTheme.bodySmall?.copyWith(
                                  color: AppTheme.secondaryText)),
                            ])),
                        CustomEnhancedButtonWidget(
                          buttonId: _is2FAEnabled ? 'disable_2fa' : 'enable_2fa',
                          onPressed: _is2FAEnabled ? _disable2FA : _enable2FA,
                          buttonType: ButtonType.outlined,
                          child: Text(
                            _is2FAEnabled ? 'Disable' : 'Enable',
                            style: AppTheme.darkTheme.textTheme.bodyMedium?.copyWith(
                              color: _is2FAEnabled ? AppTheme.error : AppTheme.primaryAction,
                              fontWeight: FontWeight.w500))),
                      ])),

                  SizedBox(height: 4.h),

                  // Tab Bar for verification methods
                  if (_is2FAEnabled) ...[
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 4.w),
                      child: TabBar(
                        controller: _tabController,
                        tabs: [
                          Tab(text: 'Authenticator'),
                          Tab(text: 'SMS'),
                          Tab(text: 'Email'),
                          Tab(text: 'Backup'),
                        ],
                        labelColor: AppTheme.primaryAction,
                        unselectedLabelColor: AppTheme.secondaryText,
                        indicatorColor: AppTheme.primaryAction,
                        labelStyle: AppTheme.darkTheme.textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w500))),

                    // Tab Views
                    Expanded(
                      child: TabBarView(
                        controller: _tabController,
                        children: [
                          // Authenticator Tab
                          AuthenticatorVerificationWidget(
                            attemptCount: 0,
                            errorMessage: _errorMessage,
                            maxAttempts: 3,
                            onCodeChanged: (code) {},
                            verificationCode: '',
                            isLoading: _isLoading),

                          // SMS Tab
                          SmsVerificationWidget(
                            attemptCount: 0,
                            canResend: true,
                            errorMessage: _errorMessage,
                            maxAttempts: 3,
                            onCodeChanged: (code) {},
                            onResendCode: () {},
                            phoneNumber: '',
                            resendCountdown: 0,
                            verificationCode: '',
                            isLoading: _isLoading),

                          // Email Tab
                          EmailVerificationWidget(
                            attemptCount: 0,
                            canResend: true,
                            emailAddress: '',
                            errorMessage: _errorMessage,
                            maxAttempts: 3,
                            onCodeChanged: (code) {},
                            onResendCode: () {},
                            resendCountdown: 0,
                            verificationCode: '',
                            isLoading: _isLoading),

                          // Backup Codes Tab
                          BackupCodesWidget(),
                        ])),
                  ],
                ])));
  }
}