import '../../../core/app_export.dart';

class GoalCustomizedRecentActivityWidget extends StatelessWidget {
  final String workspaceGoal;

  const GoalCustomizedRecentActivityWidget({
    Key? key,
    required this.workspaceGoal,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF191919),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            children: [
              const Icon(
                Icons.history,
                size: 20,
                color: Color(0xFF8E8E93),
              ),
              const SizedBox(width: 8),
              Text(
                'Recent Activity',
                style: GoogleFonts.inter(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
              const Spacer(),
              GestureDetector(
                onTap: () {
                  // Navigate to full activity log
                },
                child: Text(
                  'View All',
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: const Color(0xFF007AFF),
                  ),
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 16),
          
          // Activity List
          _buildActivityList(),
        ],
      ),
    );
  }

  Widget _buildActivityList() {
    List<Map<String, dynamic>> activities = _getGoalRelevantActivities();
    
    if (activities.isEmpty) {
      return _buildEmptyState();
    }
    
    return Column(
      children: activities.map((activity) {
        return _buildActivityItem(activity);
      }).toList(),
    );
  }

  Widget _buildActivityItem(Map<String, dynamic> activity) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFF2C2C2E),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          // Activity Icon
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: activity['color'].withAlpha(26),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Icon(
              activity['icon'],
              size: 16,
              color: activity['color'],
            ),
          ),
          
          const SizedBox(width: 12),
          
          // Activity Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  activity['title'],
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
                Text(
                  activity['description'],
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                    color: const Color(0xFF8E8E93),
                  ),
                ),
              ],
            ),
          ),
          
          // Time
          Text(
            activity['time'],
            style: GoogleFonts.inter(
              fontSize: 12,
              fontWeight: FontWeight.w400,
              color: const Color(0xFF8E8E93),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: const Color(0xFF2C2C2E),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Icon(
            Icons.timeline,
            size: 48,
            color: const Color(0xFF8E8E93).withAlpha(128),
          ),
          const SizedBox(height: 16),
          Text(
            'No recent activity',
            style: GoogleFonts.inter(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            _getEmptyStateMessage(),
            style: GoogleFonts.inter(
              fontSize: 14,
              fontWeight: FontWeight.w400,
              color: const Color(0xFF8E8E93),
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  List<Map<String, dynamic>> _getGoalRelevantActivities() {
    // For new workspaces, return empty list to show empty state
    // In real implementation, this would fetch from database
    return [];
  }

  String _getEmptyStateMessage() {
    switch (workspaceGoal) {
      case 'social_media_growth':
        return 'Start by scheduling your first post or researching hashtags to see activity here.';
      case 'e_commerce_sales':
        return 'Add products to your store or set up payment processing to see activity here.';
      case 'course_creation':
        return 'Create your first course or add students to see activity here.';
      case 'lead_generation':
        return 'Start capturing leads or set up email campaigns to see activity here.';
      case 'content_creation':
        return 'Create content templates or schedule posts to see activity here.';
      case 'brand_building':
        return 'Customize your brand settings or create content to see activity here.';
      default:
        return 'Start using workspace features to see activity here.';
    }
  }
}