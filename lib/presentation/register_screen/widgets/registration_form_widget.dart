
import '../../../core/app_export.dart';

class RegistrationFormWidget extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController fullNameController;
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final TextEditingController confirmPasswordController;
  final FocusNode fullNameFocusNode;
  final FocusNode emailFocusNode;
  final FocusNode passwordFocusNode;
  final FocusNode confirmPasswordFocusNode;
  final bool isPasswordVisible;
  final bool isConfirmPasswordVisible;
  final String? fullNameError;
  final String? emailError;
  final String? passwordError;
  final String? confirmPasswordError;
  final String? generalError;
  final bool isLoading;
  final bool isFormValid;
  final VoidCallback onPasswordVisibilityToggle;
  final VoidCallback onConfirmPasswordVisibilityToggle;
  final VoidCallback onRegister;

  const RegistrationFormWidget({
    Key? key,
    required this.formKey,
    required this.fullNameController,
    required this.emailController,
    required this.passwordController,
    required this.confirmPasswordController,
    required this.fullNameFocusNode,
    required this.emailFocusNode,
    required this.passwordFocusNode,
    required this.confirmPasswordFocusNode,
    required this.isPasswordVisible,
    required this.isConfirmPasswordVisible,
    this.fullNameError,
    this.emailError,
    this.passwordError,
    this.confirmPasswordError,
    this.generalError,
    required this.isLoading,
    required this.isFormValid,
    required this.onPasswordVisibilityToggle,
    required this.onConfirmPasswordVisibilityToggle,
    required this.onRegister,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Full Name Input
          TextFormField(
            controller: fullNameController,
            focusNode: fullNameFocusNode,
            textInputAction: TextInputAction.next,
            keyboardType: TextInputType.name,
            style: AppTheme.darkTheme.textTheme.bodyLarge,
            decoration: InputDecoration(
              labelText: 'Full Name',
              hintText: 'Enter your full name',
              prefixIcon: const Icon(Icons.person_outline,
                  color: AppTheme.secondaryText),
              errorText: fullNameError,
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

          SizedBox(height: 2.h),

          // Email Input
          TextFormField(
            controller: emailController,
            focusNode: emailFocusNode,
            textInputAction: TextInputAction.next,
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

          SizedBox(height: 2.h),

          // Password Input
          TextFormField(
            controller: passwordController,
            focusNode: passwordFocusNode,
            textInputAction: TextInputAction.next,
            obscureText: !isPasswordVisible,
            style: AppTheme.darkTheme.textTheme.bodyLarge,
            decoration: InputDecoration(
              labelText: 'Password',
              hintText: 'Enter your password',
              prefixIcon:
                  const Icon(Icons.lock_outline, color: AppTheme.secondaryText),
              suffixIcon: IconButton(
                icon: Icon(
                  isPasswordVisible ? Icons.visibility_off : Icons.visibility,
                  color: AppTheme.secondaryText,
                ),
                onPressed: onPasswordVisibilityToggle,
              ),
              errorText: passwordError,
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

          SizedBox(height: 2.h),

          // Confirm Password Input
          TextFormField(
            controller: confirmPasswordController,
            focusNode: confirmPasswordFocusNode,
            textInputAction: TextInputAction.done,
            obscureText: !isConfirmPasswordVisible,
            style: AppTheme.darkTheme.textTheme.bodyLarge,
            decoration: InputDecoration(
              labelText: 'Confirm Password',
              hintText: 'Confirm your password',
              prefixIcon:
                  const Icon(Icons.lock_outline, color: AppTheme.secondaryText),
              suffixIcon: IconButton(
                icon: Icon(
                  isConfirmPasswordVisible
                      ? Icons.visibility_off
                      : Icons.visibility,
                  color: AppTheme.secondaryText,
                ),
                onPressed: onConfirmPasswordVisibilityToggle,
              ),
              errorText: confirmPasswordError,
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

          // Register Button
          ElevatedButton(
            onPressed: isFormValid && !isLoading ? onRegister : null,
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
                    'Create Account',
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