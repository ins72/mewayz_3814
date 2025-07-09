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
      height: 200,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 4),
        child: Row(
          children: _buildMetricCards(),
        ),
      ),
    );
  }

  List<Widget> _buildMetricCards() {
    List<Widget> cards = [];
    
    switch (workspaceGoal) {
      case 'social_media_growth':
        cards = [
          _buildMetricCard(
            title: 'Followers',
            value: metrics['followers']?['value']?.toString() ?? '0',
            change: metrics['followers']?['change']?.toString() ?? '0',
            trend: metrics['followers']?['trend'] ?? 'neutral',
            icon: Icons.people,
            color: const Color(0xFF00D4AA),
          ),
          _buildMetricCard(
            title: 'Engagement Rate',
            value: '${metrics['engagement_rate']?['value']?.toString() ?? '0.0'}%',
            change: metrics['engagement_rate']?['change']?.toString() ?? '0',
            trend: metrics['engagement_rate']?['trend'] ?? 'neutral',
            icon: Icons.favorite,
            color: const Color(0xFFFF6B35),
          ),
          _buildMetricCard(
            title: 'Scheduled Posts',
            value: metrics['scheduled_posts']?['value']?.toString() ?? '0',
            change: metrics['scheduled_posts']?['change']?.toString() ?? '0',
            trend: metrics['scheduled_posts']?['trend'] ?? 'neutral',
            icon: Icons.schedule,
            color: const Color(0xFF6366F1),
          ),
          _buildMetricCard(
            title: 'Reach',
            value: _formatNumber(metrics['reach']?['value'] ?? 0),
            change: metrics['reach']?['change']?.toString() ?? '0',
            trend: metrics['reach']?['trend'] ?? 'neutral',
            icon: Icons.visibility,
            color: const Color(0xFFF59E0B),
          ),
        ];
        break;
      case 'e_commerce_sales':
        cards = [
          _buildMetricCard(
            title: 'Revenue',
            value: '\$${_formatNumber(metrics['revenue']?['value'] ?? 0)}',
            change: metrics['revenue']?['change']?.toString() ?? '0',
            trend: metrics['revenue']?['trend'] ?? 'neutral',
            icon: Icons.attach_money,
            color: const Color(0xFF00D4AA),
          ),
          _buildMetricCard(
            title: 'Orders',
            value: metrics['orders']?['value']?.toString() ?? '0',
            change: metrics['orders']?['change']?.toString() ?? '0',
            trend: metrics['orders']?['trend'] ?? 'neutral',
            icon: Icons.shopping_bag,
            color: const Color(0xFFFF6B35),
          ),
          _buildMetricCard(
            title: 'Inventory Alerts',
            value: metrics['inventory_alerts']?['value']?.toString() ?? '0',
            change: metrics['inventory_alerts']?['change']?.toString() ?? '0',
            trend: metrics['inventory_alerts']?['trend'] ?? 'neutral',
            icon: Icons.warning,
            color: const Color(0xFFEF4444),
          ),
          _buildMetricCard(
            title: 'Conversion Rate',
            value: '${metrics['conversion_rate']?['value']?.toString() ?? '0.0'}%',
            change: metrics['conversion_rate']?['change']?.toString() ?? '0',
            trend: metrics['conversion_rate']?['trend'] ?? 'neutral',
            icon: Icons.trending_up,
            color: const Color(0xFF6366F1),
          ),
        ];
        break;
      case 'course_creation':
        cards = [
          _buildMetricCard(
            title: 'Students',
            value: metrics['students']?['value']?.toString() ?? '0',
            change: metrics['students']?['change']?.toString() ?? '0',
            trend: metrics['students']?['trend'] ?? 'neutral',
            icon: Icons.school,
            color: const Color(0xFF6366F1),
          ),
          _buildMetricCard(
            title: 'Completion Rate',
            value: '${metrics['completion_rate']?['value']?.toString() ?? '0.0'}%',
            change: metrics['completion_rate']?['change']?.toString() ?? '0',
            trend: metrics['completion_rate']?['trend'] ?? 'neutral',
            icon: Icons.check_circle,
            color: const Color(0xFF00D4AA),
          ),
          _buildMetricCard(
            title: 'Course Revenue',
            value: '\$${_formatNumber(metrics['course_revenue']?['value'] ?? 0)}',
            change: metrics['course_revenue']?['change']?.toString() ?? '0',
            trend: metrics['course_revenue']?['trend'] ?? 'neutral',
            icon: Icons.attach_money,
            color: const Color(0xFFF59E0B),
          ),
          _buildMetricCard(
            title: 'Enrollments',
            value: metrics['enrollments']?['value']?.toString() ?? '0',
            change: metrics['enrollments']?['change']?.toString() ?? '0',
            trend: metrics['enrollments']?['trend'] ?? 'neutral',
            icon: Icons.person_add,
            color: const Color(0xFFFF6B35),
          ),
        ];
        break;
      default:
        cards = [
          _buildMetricCard(
            title: 'Total Activity',
            value: metrics['total_activity']?['value']?.toString() ?? '0',
            change: metrics['total_activity']?['change']?.toString() ?? '0',
            trend: metrics['total_activity']?['trend'] ?? 'neutral',
            icon: Icons.help_outline,
            color: const Color(0xFF8E8E93),
          ),
          _buildMetricCard(
            title: 'Features Used',
            value: metrics['features_used']?['value']?.toString() ?? '0',
            change: metrics['features_used']?['change']?.toString() ?? '0',
            trend: metrics['features_used']?['trend'] ?? 'neutral',
            icon: Icons.apps,
            color: const Color(0xFF6366F1),
          ),
        ];
        break;
    }
    
    return cards;
  }

  Widget _buildMetricCard({
    required String title,
    required String value,
    required String change,
    required String trend,
    required IconData icon,
    required Color color,
  }) {
    return AnimatedBuilder(
      animation: refreshController,
      builder: (context, child) {
        return Transform.scale(
          scale: 1.0 + (refreshController.value * 0.05),
          child: Container(
            width: 160,
            margin: const EdgeInsets.only(right: 16),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFF191919),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: color.withAlpha(26),
                width: 1,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Icon and Trend
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
                        size: 20,
                        color: color,
                      ),
                    ),
                    const Spacer(),
                    _buildTrendIndicator(trend, change),
                  ],
                ),
                
                const SizedBox(height: 16),
                
                // Value
                Text(
                  value,
                  style: GoogleFonts.inter(
                    fontSize: 24,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
                
                const SizedBox(height: 4),
                
                // Title
                Text(
                  title,
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: const Color(0xFF8E8E93),
                  ),
                ),
                
                const SizedBox(height: 8),
                
                // Empty state message
                if (value == '0' || value == '0.0%' || value == '\$0') ...[
                  Text(
                    'No data yet',
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                      color: const Color(0xFF8E8E93),
                    ),
                  ),
                ],
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildTrendIndicator(String trend, String change) {
    Color trendColor;
    IconData trendIcon;
    
    switch (trend) {
      case 'up':
        trendColor = const Color(0xFF00D4AA);
        trendIcon = Icons.trending_up;
        break;
      case 'down':
        trendColor = const Color(0xFFEF4444);
        trendIcon = Icons.trending_down;
        break;
      default:
        trendColor = const Color(0xFF8E8E93);
        trendIcon = Icons.trending_flat;
        break;
    }
    
    return Row(
      children: [
        Icon(
          trendIcon,
          size: 16,
          color: trendColor,
        ),
        const SizedBox(width: 4),
        Text(
          change == '0' ? '0%' : '${change}%',
          style: GoogleFonts.inter(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: trendColor,
          ),
        ),
      ],
    );
  }

  String _formatNumber(dynamic number) {
    if (number == null || number == 0) return '0';
    if (number < 1000) return number.toString();
    if (number < 1000000) return '${(number / 1000).toStringAsFixed(1)}K';
    return '${(number / 1000000).toStringAsFixed(1)}M';
  }
}