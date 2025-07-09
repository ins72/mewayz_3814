
import '../../../core/app_export.dart';

class MetricCardWidget extends StatelessWidget {
  final String title;
  final String value;
  final String change;
  final bool isPositive;
  final String iconName;

  const MetricCardWidget({
    Key? key,
    required this.title,
    required this.value,
    required this.change,
    required this.isPositive,
    required this.iconName,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 40.w,
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppTheme.border,
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CustomIconWidget(
                iconName: iconName,
                color: AppTheme.accent,
                size: 24,
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 1.h),
                decoration: BoxDecoration(
                  color: isPositive
                      ? AppTheme.success.withValues(alpha: 0.2)
                      : AppTheme.error.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CustomIconWidget(
                      iconName: isPositive ? 'trending_up' : 'trending_down',
                      color: isPositive ? AppTheme.success : AppTheme.error,
                      size: 12,
                    ),
                    SizedBox(width: 1.w),
                    Text(
                      change,
                      style: AppTheme.darkTheme.textTheme.bodySmall?.copyWith(
                        color: isPositive ? AppTheme.success : AppTheme.error,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 2.h),
          Text(
            value,
            style: AppTheme.dataTextTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 1.h),
          Text(
            title,
            style: AppTheme.darkTheme.textTheme.bodySmall?.copyWith(
              color: AppTheme.secondaryText,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}