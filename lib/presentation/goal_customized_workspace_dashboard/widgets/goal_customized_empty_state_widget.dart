import '../../../core/app_export.dart';

class GoalCustomizedEmptyStateWidget extends StatelessWidget {
  final String workspaceGoal;
  
  const GoalCustomizedEmptyStateWidget({
    Key? key,
    required this.workspaceGoal,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: const Color(0xFF191919),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: const Color(0xFF2A2A2A),
          width: 1,
        ),
      ),
      child: Column(
        children: [
          Icon(
            _getEmptyStateIcon(),
            size: 64,
            color: const Color(0xFF007AFF),
          ),
          const SizedBox(height: 16),
          Text(
            _getEmptyStateTitle(),
            style: GoogleFonts.inter(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            _getEmptyStateDescription(),
            style: GoogleFonts.inter(
              fontSize: 14,
              color: const Color(0xFF8E8E93),
              height: 1.5,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            decoration: BoxDecoration(
              color: const Color(0xFF007AFF),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              _getEmptyStateActionText(),
              style: GoogleFonts.inter(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }

  IconData _getEmptyStateIcon() {
    switch (workspaceGoal) {
      case 'social_media_growth':
        return Icons.trending_up;
      case 'e_commerce_sales':
        return Icons.store;
      case 'course_creation':
        return Icons.school;
      default:
        return Icons.workspace_premium;
    }
  }

  String _getEmptyStateTitle() {
    switch (workspaceGoal) {
      case 'social_media_growth':
        return 'Ready to Grow Your Social Media?';
      case 'e_commerce_sales':
        return 'Ready to Start Selling?';
      case 'course_creation':
        return 'Ready to Create Your First Course?';
      default:
        return 'Welcome to Your Workspace';
    }
  }

  String _getEmptyStateDescription() {
    switch (workspaceGoal) {
      case 'social_media_growth':
        return 'Start by scheduling your first post, researching hashtags, or finding leads to build your social media presence.';
      case 'e_commerce_sales':
        return 'Begin by adding products to your store, managing inventory, or setting up your CRM to track customers.';
      case 'course_creation':
        return 'Create your first course, add content modules, or set up student management to start teaching online.';
      default:
        return 'Explore the available features and tools to get started with your workspace.';
    }
  }

  String _getEmptyStateActionText() {
    switch (workspaceGoal) {
      case 'social_media_growth':
        return 'Schedule Your First Post';
      case 'e_commerce_sales':
        return 'Add Your First Product';
      case 'course_creation':
        return 'Create Your First Course';
      default:
        return 'Get Started';
    }
  }
}