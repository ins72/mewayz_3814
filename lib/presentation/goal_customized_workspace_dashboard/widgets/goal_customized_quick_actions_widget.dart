import '../../../core/app_export.dart';

class GoalCustomizedQuickActionsWidget extends StatelessWidget {
  final List<Map<String, dynamic>> quickActions;
  final String workspaceGoal;

  const GoalCustomizedQuickActionsWidget({
    Key? key,
    required this.quickActions,
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
          // Header with Goal Context
          Row(
            children: [
              _buildGoalIcon(),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Goal-Optimized Actions',
                      style: GoogleFonts.inter(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      _getGoalDescription(),
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                        color: const Color(0xFF8E8E93),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 16),
          
          // Quick Actions Grid
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 1.2,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
            ),
            itemCount: quickActions.length,
            itemBuilder: (context, index) {
              final action = quickActions[index];
              return _buildQuickActionCard(context, action, index);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildGoalIcon() {
    Map<String, dynamic> goalInfo = _getGoalInfo();
    
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: goalInfo['color'].withAlpha(26),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Icon(
        goalInfo['icon'],
        size: 20,
        color: goalInfo['color'],
      ),
    );
  }

  Widget _buildQuickActionCard(BuildContext context, Map<String, dynamic> action, int index) {
    final isPrimary = index < 2; // First two actions are primary
    
    return GestureDetector(
      onTap: () {
        HapticFeedback.lightImpact();
        Navigator.pushNamed(context, action['route']);
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isPrimary 
              ? const Color(0xFF007AFF).withAlpha(13) 
              : const Color(0xFF2C2C2E),
          borderRadius: BorderRadius.circular(12),
          border: isPrimary 
              ? Border.all(
                  color: const Color(0xFF007AFF).withAlpha(26),
                  width: 1,
                )
              : null,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Action Icon
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: isPrimary 
                    ? const Color(0xFF007AFF).withAlpha(26)
                    : const Color(0xFF8E8E93).withAlpha(26),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                action['icon'],
                size: 20,
                color: isPrimary ? const Color(0xFF007AFF) : const Color(0xFF8E8E93),
              ),
            ),
            
            const SizedBox(height: 12),
            
            // Action Title
            Text(
              action['title'],
              style: GoogleFonts.inter(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            
            const SizedBox(height: 4),
            
            // Priority Badge
            if (isPrimary) ...[
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: const Color(0xFF007AFF).withAlpha(26),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  'Priority',
                  style: GoogleFonts.inter(
                    fontSize: 10,
                    fontWeight: FontWeight.w500,
                    color: const Color(0xFF007AFF),
                  ),
                ),
              ),
            ] else ...[
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: const Color(0xFF8E8E93).withAlpha(26),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  'Available',
                  style: GoogleFonts.inter(
                    fontSize: 10,
                    fontWeight: FontWeight.w500,
                    color: const Color(0xFF8E8E93),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  String _getGoalDescription() {
    switch (workspaceGoal) {
      case 'social_media_growth':
        return 'Prioritized for social media growth';
      case 'e_commerce_sales':
        return 'Optimized for e-commerce success';
      case 'course_creation':
        return 'Focused on course creation and education';
      case 'lead_generation':
        return 'Designed for lead generation';
      case 'content_creation':
        return 'Tailored for content creation';
      case 'brand_building':
        return 'Optimized for brand building';
      default:
        return 'General workspace actions';
    }
  }

  Map<String, dynamic> _getGoalInfo() {
    switch (workspaceGoal) {
      case 'social_media_growth':
        return {
          'icon': Icons.trending_up,
          'color': const Color(0xFF00D4AA),
        };
      case 'e_commerce_sales':
        return {
          'icon': Icons.shopping_cart,
          'color': const Color(0xFFFF6B35),
        };
      case 'course_creation':
        return {
          'icon': Icons.school,
          'color': const Color(0xFF6366F1),
        };
      case 'lead_generation':
        return {
          'icon': Icons.people_alt,
          'color': const Color(0xFFF59E0B),
        };
      case 'content_creation':
        return {
          'icon': Icons.create,
          'color': const Color(0xFFEF4444),
        };
      case 'brand_building':
        return {
          'icon': Icons.branding_watermark,
          'color': const Color(0xFF8B5CF6),
        };
      default:
        return {
          'icon': Icons.dashboard,
          'color': const Color(0xFF8E8E93),
        };
    }
  }
}