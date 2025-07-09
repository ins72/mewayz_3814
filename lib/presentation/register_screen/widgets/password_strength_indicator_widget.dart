
import '../../../core/app_export.dart';

class PasswordStrengthIndicatorWidget extends StatelessWidget {
  final int strength;
  final String strengthText;

  const PasswordStrengthIndicatorWidget({
    Key? key,
    required this.strength,
    required this.strengthText,
  }) : super(key: key);

  Color _getStrengthColor(int strength) {
    switch (strength) {
      case 1:
        return AppTheme.error;
      case 2:
        return Colors.orange;
      case 3:
        return AppTheme.warning;
      case 4:
        return AppTheme.accent;
      case 5:
        return AppTheme.success;
      default:
        return AppTheme.border;
    }
  }

  @override
  Widget build(BuildContext context) {
    // Show indicator when password is being typed (strength > 0) or when there's text
    if (strength == 0 && strengthText.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Password Strength',
              style: AppTheme.darkTheme.textTheme.bodySmall?.copyWith(
                color: AppTheme.secondaryText,
              ),
            ),
            if (strengthText.isNotEmpty)
              Text(
                strengthText,
                style: AppTheme.darkTheme.textTheme.bodySmall?.copyWith(
                  color: _getStrengthColor(strength),
                  fontWeight: FontWeight.w500,
                ),
              ),
          ],
        ),
        SizedBox(height: 1.h),
        Row(
          children: List.generate(5, (index) {
            return Expanded(
              child: Container(
                height: 4,
                margin: EdgeInsets.only(right: index < 4 ? 1.w : 0),
                decoration: BoxDecoration(
                  color: index < strength
                      ? _getStrengthColor(strength)
                      : AppTheme.border,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            );
          }),
        ),
        SizedBox(height: 1.h),
        // Password requirements helper text
        if (strength > 0) ...[
          Text(
            'Password Requirements:',
            style: AppTheme.darkTheme.textTheme.bodySmall?.copyWith(
              color: AppTheme.secondaryText,
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: 0.5.h),
          _buildRequirementRow('At least 8 characters', strength >= 1),
          _buildRequirementRow('One uppercase letter', strength >= 2),
          _buildRequirementRow('One lowercase letter', strength >= 3),
          _buildRequirementRow('One number', strength >= 4),
          _buildRequirementRow('One special character', strength >= 5),
        ],
      ],
    );
  }

  Widget _buildRequirementRow(String requirement, bool isMet) {
    return Padding(
      padding: EdgeInsets.only(bottom: 0.5.h),
      child: Row(
        children: [
          Icon(
            isMet ? Icons.check_circle : Icons.circle_outlined,
            size: 16,
            color: isMet ? AppTheme.success : AppTheme.secondaryText,
          ),
          SizedBox(width: 2.w),
          Text(
            requirement,
            style: AppTheme.darkTheme.textTheme.bodySmall?.copyWith(
              color: isMet ? AppTheme.success : AppTheme.secondaryText,
            ),
          ),
        ],
      ),
    );
  }
}