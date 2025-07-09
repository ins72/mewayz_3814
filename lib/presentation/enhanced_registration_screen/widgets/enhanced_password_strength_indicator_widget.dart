
import '../../../core/app_export.dart';

class EnhancedPasswordStrengthIndicatorWidget extends StatelessWidget {
  final int strength;
  final String strengthText;

  const EnhancedPasswordStrengthIndicatorWidget({
    Key? key,
    required this.strength,
    required this.strengthText,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (strength == 0) {
      return const SizedBox.shrink();
    }

    return Container(
      padding: EdgeInsets.all(4.w),
      margin: EdgeInsets.symmetric(vertical: 2.h),
      decoration: BoxDecoration(
        color: const Color(0xFF191919),
        borderRadius: BorderRadius.circular(2.w),
        border: Border.all(
          color: _getStrengthColor().withAlpha(77),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.security_outlined,
                color: _getStrengthColor(),
                size: 5.w,
              ),
              SizedBox(width: 2.w),
              Text(
                'Password Strength: $strengthText',
                style: GoogleFonts.inter(
                  fontSize: 14.sp,
                  color: _getStrengthColor(),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          SizedBox(height: 2.h),
          
          // Strength Bar
          Row(
            children: List.generate(5, (index) {
              return Expanded(
                child: Container(
                  height: 1.h,
                  margin: EdgeInsets.only(right: index < 4 ? 1.w : 0),
                  decoration: BoxDecoration(
                    color: index < strength ? _getStrengthColor() : const Color(0xFF2A2A2A),
                    borderRadius: BorderRadius.circular(0.5.h),
                  ),
                ),
              );
            }),
          ),
          
          SizedBox(height: 2.h),
          
          // Requirements List
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildRequirement('At least 8 characters', strength >= 1),
              _buildRequirement('Contains uppercase letter', strength >= 2),
              _buildRequirement('Contains lowercase letter', strength >= 3),
              _buildRequirement('Contains number', strength >= 4),
              _buildRequirement('Contains special character', strength >= 5),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildRequirement(String text, bool isValid) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 0.5.h),
      child: Row(
        children: [
          Icon(
            isValid ? Icons.check_circle_outline : Icons.radio_button_unchecked,
            color: isValid ? Colors.green : const Color(0xFF8E8E93),
            size: 4.w,
          ),
          SizedBox(width: 2.w),
          Text(
            text,
            style: GoogleFonts.inter(
              fontSize: 12.sp,
              color: isValid ? Colors.green : const Color(0xFF8E8E93),
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Color _getStrengthColor() {
    switch (strength) {
      case 1:
        return Colors.red;
      case 2:
        return Colors.orange;
      case 3:
        return Colors.yellow;
      case 4:
        return Colors.lightGreen;
      case 5:
        return Colors.green;
      default:
        return const Color(0xFF8E8E93);
    }
  }
}