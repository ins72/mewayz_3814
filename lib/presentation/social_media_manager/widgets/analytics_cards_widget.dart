
import '../../../core/app_export.dart';

class AnalyticsCardsWidget extends StatelessWidget {
  const AnalyticsCardsWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              Icons.trending_up_rounded,
              color: AppTheme.accent,
              size: 20,
            ),
            SizedBox(width: 8.w),
            Text(
              'Analytics Overview',
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ],
        ),
        SizedBox(height: 16.h),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              _buildMetricCard(
                'Total Followers',
                '24.8K',
                '+12.5%',
                Icons.people_outline_rounded,
                AppTheme.accent,
                true,
              ),
              SizedBox(width: 12.w),
              _buildMetricCard(
                'Engagement Rate',
                '4.2%',
                '+0.8%',
                Icons.favorite_outline_rounded,
                AppTheme.success,
                true,
              ),
              SizedBox(width: 12.w),
              _buildMetricCard(
                'Scheduled Posts',
                '18',
                '6 today',
                Icons.schedule_rounded,
                AppTheme.warning,
                false,
              ),
              SizedBox(width: 12.w),
              _buildMetricCard(
                'Generated Leads',
                '127',
                '+23 today',
                Icons.person_add_outlined,
                AppTheme.accent,
                true,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildMetricCard(
    String title,
    String value,
    String subtitle,
    IconData icon,
    Color color,
    bool isPositive,
  ) {
    return Builder(
      builder: (context) => Container(
        width: 160.w,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppTheme.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppTheme.border),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: color.withAlpha(26),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    icon,
                    size: 16,
                    color: color,
                  ),
                ),
                const Spacer(),
                Icon(
                  isPositive
                      ? Icons.trending_up_rounded
                      : Icons.trending_flat_rounded,
                  size: 16,
                  color: isPositive ? AppTheme.success : AppTheme.warning,
                ),
              ],
            ),
            SizedBox(height: 12.h),
            Text(
              value,
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: AppTheme.primaryText,
                  ),
            ),
            SizedBox(height: 4.h),
            Text(
              title,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppTheme.secondaryText,
                  ),
            ),
            SizedBox(height: 8.h),
            Text(
              subtitle,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: isPositive ? AppTheme.success : AppTheme.warning,
                    fontWeight: FontWeight.w500,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}