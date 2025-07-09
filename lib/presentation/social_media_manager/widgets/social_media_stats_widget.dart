
import '../../../core/app_export.dart';

class SocialMediaStatsWidget extends StatelessWidget {
  const SocialMediaStatsWidget({Key? key}) : super(key: key);

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
                  Icons.dashboard_outlined,
                  color: AppTheme.accent,
                  size: 20,
                ),
              ),
              SizedBox(width: 3.w),
              Text(
                'Quick Stats',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const Spacer(),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
                decoration: BoxDecoration(
                  color: AppTheme.success.withAlpha(26),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.trending_up,
                      color: AppTheme.success,
                      size: 16,
                    ),
                    SizedBox(width: 1.w),
                    Text(
                      'Live',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppTheme.success,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 4.h),
          Row(
            children: [
              Expanded(
                child: _buildStatItem('Total Reach', '127.5K', '+15.2%', AppTheme.accent),
              ),
              SizedBox(width: 4.w),
              Expanded(
                child: _buildStatItem('Engagement', '8.4K', '+12.8%', AppTheme.success),
              ),
            ],
          ),
          SizedBox(height: 3.h),
          Row(
            children: [
              Expanded(
                child: _buildStatItem('Active Posts', '24', '+3 today', AppTheme.warning),
              ),
              SizedBox(width: 4.w),
              Expanded(
                child: _buildStatItem('New Followers', '342', '+28 today', AppTheme.error),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(String title, String value, String change, Color color) {
    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: AppTheme.surfaceVariant,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppTheme.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: AppTheme.darkTheme.textTheme.bodySmall?.copyWith(
              color: AppTheme.secondaryText,
            ),
          ),
          SizedBox(height: 1.h),
          Row(
            children: [
              Text(
                value,
                style: AppTheme.darkTheme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: color,
                ),
              ),
              const Spacer(),
              Icon(
                Icons.arrow_upward,
                color: color,
                size: 16,
              ),
            ],
          ),
          SizedBox(height: 1.h),
          Text(
            change,
            style: AppTheme.darkTheme.textTheme.bodySmall?.copyWith(
              color: color,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}