
import '../../../core/app_export.dart';

class EnhancedSocialRegistrationWidget extends StatelessWidget {
  final VoidCallback onGoogleSignUp;
  final VoidCallback onAppleSignUp;

  const EnhancedSocialRegistrationWidget({
    Key? key,
    required this.onGoogleSignUp,
    required this.onAppleSignUp,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Divider
        Row(
          children: [
            Expanded(
              child: Container(
                height: 1,
                color: const Color(0xFF2A2A2A),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 4.w),
              child: Text(
                'Or continue with',
                style: GoogleFonts.inter(
                  fontSize: 14.sp,
                  color: const Color(0xFF8E8E93),
                ),
              ),
            ),
            Expanded(
              child: Container(
                height: 1,
                color: const Color(0xFF2A2A2A),
              ),
            ),
          ],
        ),

        SizedBox(height: 4.h),

        // Social Login Buttons
        Row(
          children: [
            // Google Sign Up
            Expanded(
              child: _buildSocialButton(
                label: 'Google',
                icon: Icons.g_mobiledata,
                onTap: onGoogleSignUp,
              ),
            ),
            SizedBox(width: 3.w),
            // Apple Sign Up
            Expanded(
              child: _buildSocialButton(
                label: 'Apple',
                icon: Icons.apple,
                onTap: onAppleSignUp,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildSocialButton({
    required String label,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return Container(
      height: 12.h,
      decoration: BoxDecoration(
        color: const Color(0xFF191919),
        borderRadius: BorderRadius.circular(2.w),
        border: Border.all(
          color: const Color(0xFF2A2A2A),
          width: 1,
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(2.w),
          onTap: onTap,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                color: const Color(0xFFF1F1F1),
                size: 6.w,
              ),
              SizedBox(width: 2.w),
              Text(
                label,
                style: GoogleFonts.inter(
                  fontSize: 14.sp,
                  color: const Color(0xFFF1F1F1),
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}