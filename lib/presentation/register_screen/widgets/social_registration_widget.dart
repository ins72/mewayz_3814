
import '../../../core/app_export.dart';

class SocialRegistrationWidget extends StatefulWidget {
  final VoidCallback onGoogleSignUp;
  final VoidCallback onAppleSignUp;

  const SocialRegistrationWidget({
    Key? key,
    required this.onGoogleSignUp,
    required this.onAppleSignUp,
  }) : super(key: key);

  @override
  State<SocialRegistrationWidget> createState() => _SocialRegistrationWidgetState();
}

class _SocialRegistrationWidgetState extends State<SocialRegistrationWidget> {
  bool _isLoading = false;
  late AuthService _authService;

  @override
  void initState() {
    super.initState();
    _authService = AuthService();
  }

  Future<void> _handleGoogleSignUp() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final response = await _authService.signInWithGoogle();
      
      if (response?.user != null) {
        HapticFeedback.lightImpact();
        Navigator.pushReplacementNamed(context, AppRoutes.workspaceDashboard);
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Google sign-up failed: ${e.toString()}'),
          backgroundColor: AppTheme.error,
        ),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _handleAppleSignUp() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final response = await _authService.signInWithApple();
      
      if (response?.user != null) {
        HapticFeedback.lightImpact();
        Navigator.pushReplacementNamed(context, AppRoutes.workspaceDashboard);
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Apple sign-up failed: ${e.toString()}'),
          backgroundColor: AppTheme.error,
        ),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Divider
        Row(
          children: [
            Expanded(
              child: Divider(
                color: AppTheme.border,
                thickness: 1,
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 4.w),
              child: Text(
                'Or continue with',
                style: AppTheme.darkTheme.textTheme.bodyMedium?.copyWith(
                  color: AppTheme.secondaryText,
                ),
              ),
            ),
            Expanded(
              child: Divider(
                color: AppTheme.border,
                thickness: 1,
              ),
            ),
          ],
        ),

        SizedBox(height: 3.h),

        // Social Registration Buttons
        Row(
          children: [
            // Google Sign Up
            Expanded(
              child: SizedBox(
                height: 6.h,
                child: OutlinedButton(
                  onPressed: _isLoading ? null : _handleGoogleSignUp,
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(color: AppTheme.border),
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
                            valueColor: AlwaysStoppedAnimation<Color>(
                              AppTheme.primaryText,
                            ),
                          ),
                        )
                      : Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              width: 5.w,
                              height: 5.w,
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                  image: NetworkImage(
                                    'https://developers.google.com/identity/images/g-logo.png',
                                  ),
                                  fit: BoxFit.contain,
                                ),
                              ),
                            ),
                            SizedBox(width: 2.w),
                            Text(
                              'Google',
                              style: AppTheme.darkTheme.textTheme.bodyMedium?.copyWith(
                                color: AppTheme.primaryText,
                              ),
                            ),
                          ],
                        ),
                ),
              ),
            ),

            SizedBox(width: 3.w),

            // Apple Sign Up
            Expanded(
              child: SizedBox(
                height: 6.h,
                child: OutlinedButton(
                  onPressed: _isLoading ? null : _handleAppleSignUp,
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(color: AppTheme.border),
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
                            valueColor: AlwaysStoppedAnimation<Color>(
                              AppTheme.primaryText,
                            ),
                          ),
                        )
                      : Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CustomIconWidget(
                              iconName: 'apple',
                              color: AppTheme.primaryText,
                              size: 5.w,
                            ),
                            SizedBox(width: 2.w),
                            Text(
                              'Apple',
                              style: AppTheme.darkTheme.textTheme.bodyMedium?.copyWith(
                                color: AppTheme.primaryText,
                              ),
                            ),
                          ],
                        ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}