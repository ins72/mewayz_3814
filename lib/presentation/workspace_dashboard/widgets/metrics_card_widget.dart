
import '../../../core/app_export.dart';

class MetricsCardWidget extends StatelessWidget {
  final Map<String, dynamic> data;
  final VoidCallback? onLongPress;

  const MetricsCardWidget({
    Key? key,
    required this.data,
    this.onLongPress,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onLongPress: onLongPress,
      child: Container(
        width: 45.w,
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
                Container(
                  padding: EdgeInsets.all(2.w),
                  decoration: BoxDecoration(
                    color: (data["color"] as Color).withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: CustomIconWidget(
                    iconName: data["icon"] ?? 'analytics',
                    color: data["color"] ?? AppTheme.accent,
                    size: 20,
                  ),
                ),
                Container(
                  padding:
                      EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.5.h),
                  decoration: BoxDecoration(
                    color: data["isPositive"]
                        ? AppTheme.success.withValues(alpha: 0.2)
                        : AppTheme.error.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    data["change"] ?? "+0%",
                    style: AppTheme.darkTheme.textTheme.bodySmall?.copyWith(
                      color: data["isPositive"]
                          ? AppTheme.success
                          : AppTheme.error,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 2.h),
            Text(
              data["value"] ?? "0",
              style: AppTheme.darkTheme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.w600,
                color: AppTheme.primaryText,
              ),
            ),
            SizedBox(height: 0.5.h),
            Text(
              data["title"] ?? "Metric",
              style: AppTheme.darkTheme.textTheme.bodyMedium?.copyWith(
                color: AppTheme.secondaryText,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}