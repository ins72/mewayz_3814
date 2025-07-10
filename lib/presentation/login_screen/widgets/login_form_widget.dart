
import '../../../core/app_export.dart';

class LoginFormWidget extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final FocusNode emailFocusNode;
  final FocusNode passwordFocusNode;
  final bool isPasswordVisible;
  final String? emailError;
  final String? passwordError;
  final String? generalError;
  final bool isLoading;
  final bool isFormValid;
  final VoidCallback onPasswordVisibilityToggle;
  final VoidCallback onLogin;
  final VoidCallback onForgotPassword;
  final VoidCallback onGoogleSignIn;
  final VoidCallback onAppleSignIn;

  const LoginFormWidget({
    Key? key,
    required this.formKey,
    required this.emailController,
    required this.passwordController,
    required this.emailFocusNode,
    required this.passwordFocusNode,
    required this.isPasswordVisible,
    this.emailError,
    this.passwordError,
    this.generalError,
    required this.isLoading,
    required this.isFormValid,
    required this.onPasswordVisibilityToggle,
    required this.onLogin,
    required this.onForgotPassword,
    required this.onGoogleSignIn,
    required this.onAppleSignIn,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // General Error Message
          generalError != null
              ? Container(
                  padding: EdgeInsets.all(3.w),
                  margin: EdgeInsets.only(bottom: 2.h),
                  decoration: BoxDecoration(
                    color: AppTheme.error.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(2.w),
                    border: Border.all(
                      color: AppTheme.error.withValues(alpha: 0.3),
                      width: 1,
                    ),
                  ),
                  child: Row(
                    children: [
                      CustomIconWidget(
                        iconName: 'error_outline',
                        color: AppTheme.error,
                        size: 5.w,
                      ),
                      SizedBox(width: 2.w),
                      Expanded(
                        child: Text(
                          generalError!,
                          style:
                              AppTheme.darkTheme.textTheme.bodySmall?.copyWith(
                            color: AppTheme.error,
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              : const SizedBox.shrink(),

          // Email Field
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                decoration: BoxDecoration(
                  color: AppTheme.surface,
                  borderRadius: BorderRadius.circular(3.w),
                  border: Border.all(
                    color:
                        emailError != null ? AppTheme.error : AppTheme.border,
                    width: 1,
                  ),
                ),
                child: TextFormField(
                  controller: emailController,
                  focusNode: emailFocusNode,
                  keyboardType: TextInputType.emailAddress,
                  textInputAction: TextInputAction.next,
                  enabled: !isLoading,
                  style: AppTheme.darkTheme.textTheme.bodyLarge?.copyWith(
                    color: AppTheme.primaryText,
                  ),
                  decoration: InputDecoration(
                    hintText: 'Enter your email',
                    hintStyle: AppTheme.darkTheme.textTheme.bodyLarge?.copyWith(
                      color: AppTheme.secondaryText,
                    ),
                    prefixIcon: Padding(
                      padding: EdgeInsets.all(3.w),
                      child: CustomIconWidget(
                        iconName: 'email',
                        color: AppTheme.secondaryText,
                        size: 5.w,
                      ),
                    ),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 4.w,
                      vertical: 4.w,
                    ),
                  ),
                  onFieldSubmitted: (_) {
                    FocusScope.of(context).requestFocus(passwordFocusNode);
                  },
                ),
              ),
              emailError != null
                  ? Padding(
                      padding: EdgeInsets.only(top: 1.h, left: 2.w),
                      child: Text(
                        emailError!,
                        style: AppTheme.darkTheme.textTheme.bodySmall?.copyWith(
                          color: AppTheme.error,
                        ),
                      ),
                    )
                  : const SizedBox.shrink(),
            ],
          ),

          SizedBox(height: 3.h),

          // Password Field
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                decoration: BoxDecoration(
                  color: AppTheme.surface,
                  borderRadius: BorderRadius.circular(3.w),
                  border: Border.all(
                    color: passwordError != null
                        ? AppTheme.error
                        : AppTheme.border,
                    width: 1,
                  ),
                ),
                child: TextFormField(
                  controller: passwordController,
                  focusNode: passwordFocusNode,
                  obscureText: !isPasswordVisible,
                  textInputAction: TextInputAction.done,
                  enabled: !isLoading,
                  style: AppTheme.darkTheme.textTheme.bodyLarge?.copyWith(
                    color: AppTheme.primaryText,
                  ),
                  decoration: InputDecoration(
                    hintText: 'Enter your password',
                    hintStyle: AppTheme.darkTheme.textTheme.bodyLarge?.copyWith(
                      color: AppTheme.secondaryText,
                    ),
                    prefixIcon: Padding(
                      padding: EdgeInsets.all(3.w),
                      child: CustomIconWidget(
                        iconName: 'lock',
                        color: AppTheme.secondaryText,
                        size: 5.w,
                      ),
                    ),
                    suffixIcon: GestureDetector(
                      onTap: onPasswordVisibilityToggle,
                      child: Padding(
                        padding: EdgeInsets.all(3.w),
                        child: CustomIconWidget(
                          iconName: isPasswordVisible
                              ? 'visibility'
                              : 'visibility_off',
                          color: AppTheme.secondaryText,
                          size: 5.w,
                        ),
                      ),
                    ),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 4.w,
                      vertical: 4.w,
                    ),
                  ),
                  onFieldSubmitted: (_) {
                    if (isFormValid) {
                      onLogin();
                    }
                  },
                ),
              ),
              passwordError != null
                  ? Padding(
                      padding: EdgeInsets.only(top: 1.h, left: 2.w),
                      child: Text(
                        passwordError!,
                        style: AppTheme.darkTheme.textTheme.bodySmall?.copyWith(
                          color: AppTheme.error,
                        ),
                      ),
                    )
                  : const SizedBox.shrink(),
            ],
          ),

          SizedBox(height: 2.h),

          // Forgot Password Link
          Align(
            alignment: Alignment.centerRight,
            child: GestureDetector(
              onTap: onForgotPassword,
              child: Text(
                'Forgot Password?',
                style: AppTheme.darkTheme.textTheme.bodyMedium?.copyWith(
                  color: AppTheme.secondaryText,
                  decoration: TextDecoration.underline,
                ),
              ),
            ),
          ),

          SizedBox(height: 4.h),

          // Login Button
          SizedBox(
            width: double.infinity,
            height: 6.h,
            child: ElevatedButton(
              onPressed: isFormValid && !isLoading ? onLogin : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: isFormValid && !isLoading
                    ? AppTheme.primaryAction
                    : AppTheme.secondaryText,
                foregroundColor: AppTheme.primaryBackground,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(3.w),
                ),
              ),
              child: isLoading
                  ? SizedBox(
                      width: 5.w,
                      height: 5.w,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(
                          AppTheme.primaryBackground,
                        ),
                      ),
                    )
                  : Text(
                      'Login',
                      style: AppTheme.darkTheme.textTheme.titleMedium?.copyWith(
                        color: AppTheme.primaryBackground,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
            ),
          ),

          SizedBox(height: 3.h),

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

          // Social Login Buttons
          Row(
            children: [
              // Google Sign In
              Expanded(
                child: SizedBox(
                  height: 6.h,
                  child: OutlinedButton(
                    onPressed: isLoading ? null : onGoogleSignIn,
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(color: AppTheme.border),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(3.w),
                      ),
                    ),
                    child: Row(
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

              // Apple Sign In
              Expanded(
                child: SizedBox(
                  height: 6.h,
                  child: OutlinedButton(
                    onPressed: isLoading ? null : onAppleSignIn,
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(color: AppTheme.border),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(3.w),
                      ),
                    ),
                    child: Row(
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
      ),
    );
  }
}