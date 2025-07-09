
import '../../../core/app_export.dart';

class BiometricAuthWidget extends StatefulWidget {
  final VoidCallback onBiometricAuth;

  const BiometricAuthWidget({
    Key? key,
    required this.onBiometricAuth,
  }) : super(key: key);

  @override
  State<BiometricAuthWidget> createState() => _BiometricAuthWidgetState();
}

class _BiometricAuthWidgetState extends State<BiometricAuthWidget> {
  bool _isBiometricAvailable = true;
  bool _isAuthenticating = false;

  Future<void> _authenticateWithBiometrics() async {
    if (_isAuthenticating) return;

    setState(() {
      _isAuthenticating = true;
    });

    try {
      // Simulate biometric authentication
      await Future.delayed(const Duration(seconds: 1));

      // Simulate successful authentication
      HapticFeedback.lightImpact();
      widget.onBiometricAuth();
    } catch (e) {
      // Handle biometric authentication error
      _showBiometricError();
    } finally {
      setState(() {
        _isAuthenticating = false;
      });
    }
  }

  void _showBiometricError() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'Authentication Failed',
          style: AppTheme.darkTheme.textTheme.titleLarge,
        ),
        content: Text(
          'Biometric authentication failed. Please try again or use your password.',
          style: AppTheme.darkTheme.textTheme.bodyMedium,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
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
        // Divider with "OR"
        Row(
          children: [
            Expanded(
              child: Container(
                height: 1,
                color: AppTheme.border,
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 4.w),
              child: Text(
                'OR',
                style: AppTheme.darkTheme.textTheme.bodySmall?.copyWith(
                  color: AppTheme.secondaryText,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            Expanded(
              child: Container(
                height: 1,
                color: AppTheme.border,
              ),
            ),
          ],
        ),

        SizedBox(height: 3.h),

        // Biometric Authentication Button
        GestureDetector(
          onTap: _authenticateWithBiometrics,
          child: Container(
            width: 15.w,
            height: 15.w,
            decoration: BoxDecoration(
              color: AppTheme.surface,
              shape: BoxShape.circle,
              border: Border.all(
                color: AppTheme.border,
                width: 1,
              ),
            ),
            child: Center(
              child: _isAuthenticating
                  ? SizedBox(
                      width: 6.w,
                      height: 6.w,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(
                          AppTheme.accent,
                        ),
                      ),
                    )
                  : CustomIconWidget(
                      iconName: 'fingerprint',
                      color: AppTheme.accent,
                      size: 8.w,
                    ),
            ),
          ),
        ),

        SizedBox(height: 2.h),

        Text(
          'Use biometric authentication',
          style: AppTheme.darkTheme.textTheme.bodySmall?.copyWith(
            color: AppTheme.secondaryText,
          ),
        ),
      ],
    );
  }
}