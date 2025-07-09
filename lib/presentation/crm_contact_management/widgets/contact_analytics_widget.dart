
import '../../../core/app_export.dart';

class ContactAnalyticsWidget extends StatefulWidget {
  const ContactAnalyticsWidget({Key? key}) : super(key: key);

  @override
  State<ContactAnalyticsWidget> createState() => _ContactAnalyticsWidgetState();
}

class _ContactAnalyticsWidgetState extends State<ContactAnalyticsWidget> {
  String _selectedPeriod = 'This Month';

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(4.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildPeriodSelector(),
          SizedBox(height: 6.h),
          _buildAnalyticsCards(),
          SizedBox(height: 6.h),
          _buildConversionFunnel(),
          SizedBox(height: 6.h),
          _buildLeadSourceBreakdown(),
          SizedBox(height: 6.h),
          _buildPerformanceMetrics(),
        ],
      ),
    );
  }

  Widget _buildPeriodSelector() {
    final periods = ['This Week', 'This Month', 'This Quarter', 'This Year'];
    
    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: AppTheme.cardDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Analytics Period',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          SizedBox(height: 3.h),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: periods.map((period) {
                final isSelected = _selectedPeriod == period;
                return GestureDetector(
                  onTap: () => setState(() => _selectedPeriod = period),
                  child: Container(
                    margin: EdgeInsets.only(right: 3.w),
                    padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
                    decoration: BoxDecoration(
                      color: isSelected ? AppTheme.accent : AppTheme.surfaceVariant,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: isSelected ? AppTheme.accent : AppTheme.border,
                      ),
                    ),
                    child: Text(
                      period,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: isSelected ? AppTheme.primaryAction : AppTheme.primaryText,
                        fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAnalyticsCards() {
    return Row(
      children: [
        Expanded(
          child: Container(
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
                        color: AppTheme.success.withAlpha(26),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(
                        Icons.trending_up,
                        color: AppTheme.success,
                        size: 20,
                      ),
                    ),
                    SizedBox(width: 2.w),
                    Text(
                      'Conversion Rate',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppTheme.secondaryText,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 3.h),
                Text(
                  '18.7%',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: AppTheme.success,
                  ),
                ),
                SizedBox(height: 1.h),
                Text(
                  '+2.3% from last month',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppTheme.success,
                  ),
                ),
              ],
            ),
          ),
        ),
        SizedBox(width: 4.w),
        Expanded(
          child: Container(
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
                        color: AppTheme.warning.withAlpha(26),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(
                        Icons.schedule,
                        color: AppTheme.warning,
                        size: 20,
                      ),
                    ),
                    SizedBox(width: 2.w),
                    Text(
                      'Avg. Sales Cycle',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppTheme.secondaryText,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 3.h),
                Text(
                  '23 days',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: AppTheme.warning,
                  ),
                ),
                SizedBox(height: 1.h),
                Text(
                  '-3 days improvement',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppTheme.success,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildConversionFunnel() {
    final funnelData = [
      {'stage': 'Leads', 'count': 1247, 'percentage': 100.0, 'color': AppTheme.accent},
      {'stage': 'Qualified', 'count': 456, 'percentage': 36.6, 'color': AppTheme.success},
      {'stage': 'Proposal', 'count': 123, 'percentage': 9.9, 'color': AppTheme.warning},
      {'stage': 'Negotiation', 'count': 67, 'percentage': 5.4, 'color': AppTheme.error},
      {'stage': 'Closed Won', 'count': 23, 'percentage': 1.8, 'color': AppTheme.success},
    ];

    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: AppTheme.cardDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Conversion Funnel',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          SizedBox(height: 4.h),
          ...funnelData.map((data) {
            return Container(
              margin: EdgeInsets.only(bottom: 3.h),
              child: Row(
                children: [
                  Container(
                    width: 20.w,
                    child: Text(
                      data['stage'] as String,
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ),
                  SizedBox(width: 4.w),
                  Expanded(
                    child: Container(
                      height: 6.h,
                      decoration: BoxDecoration(
                        color: AppTheme.surfaceVariant,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: FractionallySizedBox(
                        alignment: Alignment.centerLeft,
                        widthFactor: (data['percentage'] as double) / 100,
                        child: Container(
                          decoration: BoxDecoration(
                            color: data['color'] as Color,
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 4.w),
                  Container(
                    width: 15.w,
                    child: Text(
                      '${data['count']}',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                      textAlign: TextAlign.end,
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
        ],
      ),
    );
  }

  Widget _buildLeadSourceBreakdown() {
    final sources = [
      {'name': 'Website', 'count': 456, 'percentage': 36.6, 'color': AppTheme.accent},
      {'name': 'LinkedIn', 'count': 234, 'percentage': 18.8, 'color': AppTheme.success},
      {'name': 'Referral', 'count': 187, 'percentage': 15.0, 'color': AppTheme.warning},
      {'name': 'Cold Email', 'count': 156, 'percentage': 12.5, 'color': AppTheme.error},
      {'name': 'Social Media', 'count': 123, 'percentage': 9.9, 'color': AppTheme.accent},
      {'name': 'Other', 'count': 91, 'percentage': 7.3, 'color': AppTheme.secondaryText},
    ];

    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: AppTheme.cardDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Lead Source Breakdown',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          SizedBox(height: 4.h),
          ...sources.map((source) {
            return Container(
              margin: EdgeInsets.only(bottom: 3.h),
              padding: EdgeInsets.all(3.w),
              decoration: BoxDecoration(
                color: AppTheme.surfaceVariant,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: AppTheme.border),
              ),
              child: Row(
                children: [
                  Container(
                    width: 4.w,
                    height: 4.w,
                    decoration: BoxDecoration(
                      color: source['color'] as Color,
                      shape: BoxShape.circle,
                    ),
                  ),
                  SizedBox(width: 4.w),
                  Expanded(
                    child: Text(
                      source['name'] as String,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ),
                  Text(
                    '${source['count']}',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(width: 4.w),
                  Text(
                    '${source['percentage']}%',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: AppTheme.secondaryText,
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
        ],
      ),
    );
  }

  Widget _buildPerformanceMetrics() {
    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: AppTheme.cardDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Performance Metrics',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          SizedBox(height: 4.h),
          Row(
            children: [
              Expanded(
                child: _buildMetricItem(
                  'Response Rate',
                  '67%',
                  '+5% this month',
                  Icons.reply,
                  AppTheme.success,
                ),
              ),
              SizedBox(width: 4.w),
              Expanded(
                child: _buildMetricItem(
                  'Follow-up Rate',
                  '43%',
                  '+8% this month',
                  Icons.schedule_send,
                  AppTheme.warning,
                ),
              ),
            ],
          ),
          SizedBox(height: 4.h),
          Row(
            children: [
              Expanded(
                child: _buildMetricItem(
                  'Meeting Rate',
                  '28%',
                  '+3% this month',
                  Icons.video_call,
                  AppTheme.accent,
                ),
              ),
              SizedBox(width: 4.w),
              Expanded(
                child: _buildMetricItem(
                  'Close Rate',
                  '12%',
                  '+2% this month',
                  Icons.check_circle,
                  AppTheme.success,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMetricItem(String title, String value, String change, IconData icon, Color color) {
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
              Icon(icon, color: color, size: 20),
              const Spacer(),
              Icon(
                Icons.trending_up,
                color: AppTheme.success,
                size: 16,
              ),
            ],
          ),
          SizedBox(height: 2.h),
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
          SizedBox(height: 1.h),
          Text(
            change,
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