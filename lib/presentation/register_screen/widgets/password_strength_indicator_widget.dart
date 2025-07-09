
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
        return AppTheme.warning;
      case 3:
        return AppTheme.accent;
      case 4:
        return AppTheme.success;
      default:
        return AppTheme.border;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (strength == 0) {
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
          children: List.generate(4, (index) {
            return Expanded(
              child: Container(
                height: 4,
                margin: EdgeInsets.only(right: index < 3 ? 1.w : 0),
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
      ],
    );
  }
}