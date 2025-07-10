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
    required this.fullNameError,
    required this.emailError,
    required this.passwordError,
    required this.confirmPasswordError,
    required this.generalError,
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
          // Full Name Field
          CustomFormFieldWidget(
            controller: fullNameController,
            focusNode: fullNameFocusNode,
            label: 'Full Name',
            hint: 'Enter your full name',
            keyboardType: TextInputType.name,
            textInputAction: TextInputAction.next,
            required: true,
            validator: (value) => fullNameError,
            prefixIcon: CustomIconWidget(
              iconName: 'person',
              size: 5.w,
              color: AppTheme.secondaryText),
            onFieldSubmitted: (value) {
              FocusScope.of(context).requestFocus(emailFocusNode);
            }),

          SizedBox(height: 3.h),

          // Email Field
          CustomFormFieldWidget(
            controller: emailController,
            focusNode: emailFocusNode,
            label: 'Email Address',
            hint: 'Enter your email address',
            keyboardType: TextInputType.emailAddress,
            textInputAction: TextInputAction.next,
            required: true,
            validator: (value) => emailError,
            prefixIcon: CustomIconWidget(
              iconName: 'email',
              size: 5.w,
              color: AppTheme.secondaryText),
            onFieldSubmitted: (value) {
              FocusScope.of(context).requestFocus(passwordFocusNode);
            }),

          SizedBox(height: 3.h),

          // Password Field
          CustomFormFieldWidget(
            controller: passwordController,
            focusNode: passwordFocusNode,
            label: 'Password',
            hint: 'Enter your password',
            obscureText: !isPasswordVisible,
            textInputAction: TextInputAction.next,
            required: true,
            validator: (value) => passwordError,
            prefixIcon: CustomIconWidget(
              iconName: 'lock',
              size: 5.w,
              color: AppTheme.secondaryText),
            suffixIcon: GestureDetector(
              onTap: onPasswordVisibilityToggle,
              child: CustomIconWidget(
                iconName: isPasswordVisible ? 'visibility_off' : 'visibility',
                size: 5.w,
                color: AppTheme.secondaryText)),
            onFieldSubmitted: (value) {
              FocusScope.of(context).requestFocus(confirmPasswordFocusNode);
            }),

          SizedBox(height: 3.h),

          // Confirm Password Field
          CustomFormFieldWidget(
            controller: confirmPasswordController,
            focusNode: confirmPasswordFocusNode,
            label: 'Confirm Password',
            hint: 'Confirm your password',
            obscureText: !isConfirmPasswordVisible,
            textInputAction: TextInputAction.done,
            required: true,
            validator: (value) => confirmPasswordError,
            prefixIcon: CustomIconWidget(
              iconName: 'lock',
              size: 5.w,
              color: AppTheme.secondaryText),
            suffixIcon: GestureDetector(
              onTap: onConfirmPasswordVisibilityToggle,
              child: CustomIconWidget(
                iconName: isConfirmPasswordVisible ? 'visibility_off' : 'visibility',
                size: 5.w,
                color: AppTheme.secondaryText)),
            onFieldSubmitted: (value) {
              if (isFormValid) {
                onRegister();
              }
            }),

          SizedBox(height: 2.h),

          // General Error Message
          if (generalError != null)
            Container(
              padding: EdgeInsets.all(3.w),
              decoration: BoxDecoration(
                color: Colors.red.withAlpha(26),
                borderRadius: BorderRadius.circular(2.w),
                border: Border.all(color: Colors.red.withAlpha(77))),
              child: Row(
                children: [
                  CustomIconWidget(
                    iconName: 'error',
                    color: Colors.red,
                    size: 5.w),
                  SizedBox(width: 2.w),
                  Expanded(
                    child: Text(
                      generalError!,
                      style: AppTheme.darkTheme.textTheme.bodySmall?.copyWith(
                        color: Colors.red))),
                ])),

          SizedBox(height: 4.h),

          // Register Button
          CustomEnhancedButtonWidget(
            buttonId: 'register_button',
            child: Text('Create Account'),
            isLoading: isLoading,
            isEnabled: isFormValid && !isLoading,
            onPressed: isFormValid && !isLoading ? () => onRegister() : () {},
            buttonType: ButtonType.primary),
        ]));
  }
}