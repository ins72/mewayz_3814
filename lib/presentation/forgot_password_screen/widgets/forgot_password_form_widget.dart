
import '../../../core/app_export.dart';

class ForgotPasswordFormWidget extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController emailController;
  final FocusNode emailFocusNode;
  final String? emailError;
  final String? generalError;
  final bool isLoading;
  final bool isFormValid;
  final VoidCallback onSendResetLink;

  const ForgotPasswordFormWidget({
    Key? key,
    required this.formKey,
    required this.emailController,
    required this.emailFocusNode,
    this.emailError,
    this.generalError,
    required this.isLoading,
    required this.isFormValid,
    required this.onSendResetLink,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Email Input
          TextFormField(
            controller: emailController,
            focusNode: emailFocusNode,
            textInputAction: TextInputAction.done,
            keyboardType: TextInputType.emailAddress,
            style: AppTheme.darkTheme.textTheme.bodyLarge,
            decoration: InputDecoration(
              labelText: 'Email Address',
              hintText: 'Enter your email address',
              prefixIcon: const Icon(Icons.email_outlined,
                  color: AppTheme.secondaryText),
              errorText: emailError,
              filled: true,
              fillColor: AppTheme.surface,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: AppTheme.border),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: AppTheme.border),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: AppTheme.accent, width: 2),
              ),
              errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: AppTheme.error),
              ),
            ),
          ),

          if (generalError != null) ...[
            SizedBox(height: 2.h),
            Container(
              padding: EdgeInsets.all(3.w),
              decoration: BoxDecoration(
                color: AppTheme.error.withAlpha(26),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppTheme.error),
              ),
              child: Row(
                children: [
                  const Icon(Icons.error_outline,
                      color: AppTheme.error, size: 20),
                  SizedBox(width: 2.w),
                  Expanded(
                    child: Text(
                      generalError!,
                      style: AppTheme.darkTheme.textTheme.bodyMedium?.copyWith(
                        color: AppTheme.error,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],

          SizedBox(height: 4.h),

          // Send Reset Link Button
          ElevatedButton(
            onPressed: isFormValid && !isLoading ? onSendResetLink : null,
            style: ElevatedButton.styleFrom(
              backgroundColor: isFormValid && !isLoading
                  ? AppTheme.primaryAction
                  : AppTheme.border,
              foregroundColor: isFormValid && !isLoading
                  ? AppTheme.primaryBackground
                  : AppTheme.secondaryText,
              padding: EdgeInsets.symmetric(vertical: 4.w),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 0,
            ),
            child: isLoading
                ? SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(
                        isFormValid
                            ? AppTheme.primaryBackground
                            : AppTheme.secondaryText,
                      ),
                    ),
                  )
                : Text(
                    'Send Reset Link',
                    style: AppTheme.darkTheme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: isFormValid
                          ? AppTheme.primaryBackground
                          : AppTheme.secondaryText,
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}