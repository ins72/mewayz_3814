import '../../../core/app_export.dart';

class GoalCustomizedHeroMetricsWidget extends StatelessWidget {
  final String workspaceGoal;
  final Map<String, dynamic> metrics;
  final bool isRefreshing;
  final AnimationController refreshController;

  const GoalCustomizedHeroMetricsWidget({
    Key? key,
    required this.workspaceGoal,
    required this.metrics,
    required this.isRefreshing,
    required this.refreshController,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF191919),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: const Color(0xFF2A2A2A),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Key Metrics',
            style: GoogleFonts.inter(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 16),
          
          if (metrics.isNotEmpty)
            GridView.builder(
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
                final metricKey = metrics.keys.elementAt(index);
                final metricData = metrics[metricKey];
                
                return Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: const Color(0xFF2A2A2A),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        _getMetricDisplayName(metricKey),
                        style: GoogleFonts.inter(
                          fontSize: 12,
                          color: const Color(0xFF8E8E93),
                        ),
                      ),
                      Text(
                        '${metricData['value'] ?? 0}',
                        style: GoogleFonts.inter(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        '${metricData['change'] ?? 0}%',
                        style: GoogleFonts.inter(
                          fontSize: 12,
                          color: const Color(0xFF8E8E93),
                        ),
                      ),
                    ],
                  ),
                );
              },
            )
          else
            // Empty state for metrics
            Container(
              height: 120,
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.analytics_outlined,
                      size: 32,
                      color: const Color(0xFF8E8E93),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'No metrics data available',
                      style: GoogleFonts.inter(
                        fontSize: 14,
                        color: const Color(0xFF8E8E93),
                      ),
                    ),
                    Text(
                      'Data will appear as you use the app',
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        color: const Color(0xFF8E8E93),
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

  String _getMetricDisplayName(String metricKey) {
    switch (metricKey) {
      case 'followers':
        return 'Followers';
      case 'engagement_rate':
        return 'Engagement Rate';
      case 'scheduled_posts':
        return 'Scheduled Posts';
      case 'reach':
        return 'Reach';
      case 'revenue':
        return 'Revenue';
      case 'orders':
        return 'Orders';
      case 'inventory_alerts':
        return 'Inventory Alerts';
      case 'conversion_rate':
        return 'Conversion Rate';
      case 'students':
        return 'Students';
      case 'completion_rate':
        return 'Completion Rate';
      case 'course_revenue':
        return 'Course Revenue';
      case 'enrollments':
        return 'Enrollments';
      case 'total_activity':
        return 'Total Activity';
      case 'features_used':
        return 'Features Used';
      default:
        return metricKey.replaceAll('_', ' ').toUpperCase();
    }
  }
}