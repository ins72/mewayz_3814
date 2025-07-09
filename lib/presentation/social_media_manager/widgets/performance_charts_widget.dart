
import '../../../core/app_export.dart';

class PerformanceChartsWidget extends StatelessWidget {
  const PerformanceChartsWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: AppTheme.cardDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(2.w),
                decoration: BoxDecoration(
                  color: AppTheme.accent.withAlpha(26),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.bar_chart,
                  color: AppTheme.accent,
                  size: 20,
                ),
              ),
              SizedBox(width: 3.w),
              Text(
                'Performance Charts',
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ],
          ),
          SizedBox(height: 4.h),
          Container(
            height: 40.h,
            decoration: BoxDecoration(
              color: AppTheme.surfaceVariant,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppTheme.border),
            ),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.show_chart,
                    size: 48,
                    color: AppTheme.accent,
                  ),
                  SizedBox(height: 2.h),
                  Text(
                    'Interactive Charts',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: AppTheme.accent,
                    ),
                  ),
                  SizedBox(height: 1.h),
                  Text(
                    'View detailed performance metrics',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: AppTheme.secondaryText,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}