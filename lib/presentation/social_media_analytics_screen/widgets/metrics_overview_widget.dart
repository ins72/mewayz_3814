import '../../../core/app_export.dart';

class MetricsOverviewWidget extends StatelessWidget {
  final List<String> selectedPlatforms;
  final String dateRange;

  const MetricsOverviewWidget({
    super.key,
    required this.selectedPlatforms,
    required this.dateRange,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppTheme.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Key Metrics',
            style: TextStyle(
              color: AppTheme.primaryText,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 16),
          _buildMetricsGrid(),
        ],
      ),
    );
  }

  Widget _buildMetricsGrid() {
    final metrics = [
      {
        'title': 'Total Reach',
        'value': '125.4K',
        'change': '+12.5%',
        'trend': 'up',
        'icon': Icons.visibility,
        'color': AppTheme.accent,
      },
      {
        'title': 'Engagement Rate',
        'value': '8.2%',
        'change': '+2.1%',
        'trend': 'up',
        'icon': Icons.favorite,
        'color': AppTheme.success,
      },
      {
        'title': 'Follower Growth',
        'value': '2.8K',
        'change': '+18.7%',
        'trend': 'up',
        'icon': Icons.trending_up,
        'color': AppTheme.warning,
      },
      {
        'title': 'Top Content',
        'value': '15',
        'change': '-5.2%',
        'trend': 'down',
        'icon': Icons.star,
        'color': AppTheme.error,
      },
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 1.5,
      ),
      itemCount: metrics.length,
      itemBuilder: (context, index) {
        final metric = metrics[index];
        return _buildMetricCard(metric);
      },
    );
  }

  Widget _buildMetricCard(Map<String, dynamic> metric) {
    final isPositive = metric['trend'] == 'up';
    
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.primaryBackground,
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
                  color: (metric['color'] as Color).withAlpha(26),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  metric['icon'] as IconData,
                  color: metric['color'] as Color,
                  size: 20,
                ),
              ),
              const Spacer(),
              Icon(
                isPositive ? Icons.arrow_upward : Icons.arrow_downward,
                color: isPositive ? AppTheme.success : AppTheme.error,
                size: 16,
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            metric['value'] as String,
            style: const TextStyle(
              color: AppTheme.primaryText,
              fontSize: 24,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 4),
          Row(
            children: [
              Expanded(
                child: Text(
                  metric['title'] as String,
                  style: const TextStyle(
                    color: AppTheme.secondaryText,
                    fontSize: 12,
                  ),
                ),
              ),
              Text(
                metric['change'] as String,
                style: TextStyle(
                  color: isPositive ? AppTheme.success : AppTheme.error,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}