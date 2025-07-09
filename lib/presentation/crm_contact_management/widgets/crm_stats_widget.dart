
import '../../../core/app_export.dart';

class CrmStatsWidget extends StatelessWidget {
  const CrmStatsWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(4.w),
      padding: EdgeInsets.all(4.w),
      decoration: AppTheme.cardDecoration(),
      child: Column(
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
                'Sales Pipeline Overview',
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
                      '+12.5%',
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
                child: _buildStatCard(
                  'Total Contacts',
                  '1,247',
                  '+28 this week',
                  Icons.contacts,
                  AppTheme.accent,
                  context,
                ),
              ),
              SizedBox(width: 4.w),
              Expanded(
                child: _buildStatCard(
                  'Active Deals',
                  '43',
                  '\$284K value',
                  Icons.handshake,
                  AppTheme.success,
                  context,
                ),
              ),
            ],
          ),
          SizedBox(height: 3.h),
          Row(
            children: [
              Expanded(
                child: _buildStatCard(
                  'Conversion Rate',
                  '18.7%',
                  '+2.3% this month',
                  Icons.trending_up,
                  AppTheme.warning,
                  context,
                ),
              ),
              SizedBox(width: 4.w),
              Expanded(
                child: _buildStatCard(
                  'Avg. Deal Size',
                  '\$6.6K',
                  '+\$1.2K increase',
                  Icons.monetization_on,
                  AppTheme.error,
                  context,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(String title, String value, String subtitle, IconData icon, Color color, BuildContext context) {
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
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(2.w),
                decoration: BoxDecoration(
                  color: color.withAlpha(26),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  icon,
                  color: color,
                  size: 20,
                ),
              ),
              const Spacer(),
              Icon(
                Icons.more_horiz,
                color: AppTheme.secondaryText,
                size: 16,
              ),
            ],
          ),
          SizedBox(height: 3.h),
          Text(
            value,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
              color: color,
            ),
          ),
          SizedBox(height: 1.h),
          Text(
            title,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: AppTheme.secondaryText,
            ),
          ),
          SizedBox(height: 2.h),
          Text(
            subtitle,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: AppTheme.success,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}