
import '../../../core/app_export.dart';

class EnhancedRegistrationFormWidget extends StatelessWidget {
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

  const EnhancedRegistrationFormWidget({
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
          _buildInputField(
            controller: fullNameController,
            focusNode: fullNameFocusNode,
            hintText: 'Enter your full name',
            labelText: 'Full Name',
            keyboardType: TextInputType.name,
            textInputAction: TextInputAction.next,
            errorText: fullNameError,
            prefixIcon: Icons.person_outline,
            onFieldSubmitted: (value) {
              FocusScope.of(context).requestFocus(emailFocusNode);
            },
          ),

          SizedBox(height: 3.h),

          // Email Field
          _buildInputField(
            controller: emailController,
            focusNode: emailFocusNode,
            hintText: 'Enter your email',
            labelText: 'Email',
            keyboardType: TextInputType.emailAddress,
            textInputAction: TextInputAction.next,
            errorText: emailError,
            prefixIcon: Icons.email_outlined,
            onFieldSubmitted: (value) {
              FocusScope.of(context).requestFocus(passwordFocusNode);
            },
          ),

          SizedBox(height: 3.h),

          // Password Field
          _buildInputField(
            controller: passwordController,
            focusNode: passwordFocusNode,
            hintText: 'Create a password',
            labelText: 'Password',
            obscureText: !isPasswordVisible,
            textInputAction: TextInputAction.next,
            errorText: passwordError,
            prefixIcon: Icons.lock_outline,
            suffixIcon: GestureDetector(
              onTap: onPasswordVisibilityToggle,
              child: Icon(
                isPasswordVisible ? Icons.visibility_off : Icons.visibility,
                color: const Color(0xFF8E8E93),
                size: 5.w,
              ),
            ),
            onFieldSubmitted: (value) {
              FocusScope.of(context).requestFocus(confirmPasswordFocusNode);
            },
          ),

          SizedBox(height: 3.h),

          // Confirm Password Field
          _buildInputField(
            controller: confirmPasswordController,
            focusNode: confirmPasswordFocusNode,
            hintText: 'Confirm your password',
            labelText: 'Confirm Password',
            obscureText: !isConfirmPasswordVisible,
            textInputAction: TextInputAction.done,
            errorText: confirmPasswordError,
            prefixIcon: Icons.lock_outline,
            suffixIcon: GestureDetector(
              onTap: onConfirmPasswordVisibilityToggle,
              child: Icon(
                isConfirmPasswordVisible ? Icons.visibility_off : Icons.visibility,
                color: const Color(0xFF8E8E93),
                size: 5.w,
              ),
            ),
            onFieldSubmitted: (value) {
              if (isFormValid) {
                onRegister();
              }
            },
          ),

          SizedBox(height: 2.h),

          // General Error Message
          if (generalError != null)
            Container(
              padding: EdgeInsets.all(3.w),
              decoration: BoxDecoration(
                color: Colors.red.withAlpha(26),
                borderRadius: BorderRadius.circular(2.w),
                border: Border.all(color: Colors.red.withAlpha(77)),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.error_outline,
                    color: Colors.red,
                    size: 5.w,
                  ),
                  SizedBox(width: 2.w),
                  Expanded(
                    child: Text(
                      generalError!,
                      style: GoogleFonts.inter(
                        fontSize: 12.sp,
                        color: Colors.red,
                      ),
                    ),
                  ),
                ],
              ),
            ),

          SizedBox(height: 4.h),

          // Register Button
          Container(
            height: 7.h,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: isFormValid && !isLoading
                    ? [const Color(0xFF007AFF), const Color(0xFF0051D5)]
                    : [const Color(0xFF2C2C2E), const Color(0xFF2C2C2E)],
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
              ),
              borderRadius: BorderRadius.circular(2.w),
              boxShadow: isFormValid && !isLoading
                  ? [
                      BoxShadow(
                        color: const Color(0xFF007AFF).withAlpha(77),
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ]
                  : [],
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: isFormValid && !isLoading ? onRegister : null,
                borderRadius: BorderRadius.circular(2.w),
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 2.h),
                  child: isLoading
                      ? const Center(
                          child: SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                            ),
                          ),
                        )
                      : Center(
                          child: Text(
                            'Create Account',
                            style: GoogleFonts.inter(
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                        ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInputField({
    required TextEditingController controller,
    required FocusNode focusNode,
    required String hintText,
    required String labelText,
    required IconData prefixIcon,
    Widget? suffixIcon,
    bool obscureText = false,
    TextInputType keyboardType = TextInputType.text,
    TextInputAction textInputAction = TextInputAction.next,
    String? errorText,
    Function(String)? onFieldSubmitted,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          labelText,
          style: GoogleFonts.inter(
            fontSize: 14.sp,
            fontWeight: FontWeight.w500,
            color: Colors.white,
          ),
        ),
        SizedBox(height: 1.h),
        Container(
          decoration: BoxDecoration(
            color: const Color(0xFF1C1C1E),
            borderRadius: BorderRadius.circular(2.w),
            border: Border.all(
              color: errorText != null
                  ? Colors.red
                  : focusNode.hasFocus
                      ? const Color(0xFF007AFF)
                      : const Color(0xFF2C2C2E),
            ),
          ),
          child: TextFormField(
            controller: controller,
            focusNode: focusNode,
            obscureText: obscureText,
            keyboardType: keyboardType,
            textInputAction: textInputAction,
            onFieldSubmitted: onFieldSubmitted,
            style: GoogleFonts.inter(
              fontSize: 16.sp,
              color: Colors.white,
            ),
            decoration: InputDecoration(
              hintText: hintText,
              hintStyle: GoogleFonts.inter(
                fontSize: 16.sp,
                color: const Color(0xFF8E8E93),
              ),
              prefixIcon: Icon(
                prefixIcon,
                color: const Color(0xFF8E8E93),
                size: 5.w,
              ),
              suffixIcon: suffixIcon,
              border: InputBorder.none,
              contentPadding: EdgeInsets.symmetric(
                horizontal: 4.w,
                vertical: 2.h,
              ),
            ),
          ),
        ),
        if (errorText != null) ...[
          SizedBox(height: 1.h),
          Text(
            errorText,
            style: GoogleFonts.inter(
              fontSize: 12.sp,
              color: Colors.red,
            ),
          ),
        ],
      ],
    );
  }
}