
import '../../../core/app_export.dart';

class CrmHeaderWidget extends StatelessWidget {
  const CrmHeaderWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          padding: EdgeInsets.all(2.w),
          decoration: BoxDecoration(
            color: AppTheme.accent.withAlpha(26),
            borderRadius: BorderRadius.circular(8),
          ),
          child: const Icon(
            Icons.business_center,
            color: AppTheme.accent,
            size: 20,
          ),
        ),
        SizedBox(width: 3.w),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'CRM Hub',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w700,
                color: AppTheme.primaryText,
              ),
            ),
            Text(
              'Enterprise Management',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: AppTheme.secondaryText,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ],
    );
  }
}