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
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF191919),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: _getGoalColor().withAlpha(26),
          width: 1,
        ),
      ),
      child: Column(
        children: [
          // Goal-specific illustration
          _buildGoalIllustration(),
          
          const SizedBox(height: 20),
          
          // Goal-specific guidance
          _buildGoalGuidance(context),
          
          const SizedBox(height: 20),
          
          // Getting started tips
          _buildGettingStartedTips(context),
        ],
      ),
    );
  }

  Widget _buildGoalIllustration() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: _getGoalColor().withAlpha(13),
        shape: BoxShape.circle,
      ),
      child: Icon(
        _getGoalIcon(),
        size: 48,
        color: _getGoalColor(),
      ),
    );
  }

  Widget _buildGoalGuidance(BuildContext context) {
    return Column(
      children: [
        Text(
          _getGoalTitle(),
          style: GoogleFonts.inter(
            fontSize: 20,
            fontWeight: FontWeight.w700,
            color: Colors.white,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 8),
        Text(
          _getGoalDescription(),
          style: GoogleFonts.inter(
            fontSize: 14,
            fontWeight: FontWeight.w400,
            color: const Color(0xFF8E8E93),
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildGettingStartedTips(BuildContext context) {
    List<Map<String, dynamic>> tips = _getGoalSpecificTips();
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Getting Started Tips',
          style: GoogleFonts.inter(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 12),
        ...tips.map((tip) => _buildTipItem(context, tip)).toList(),
        const SizedBox(height: 16),
        _buildTutorialButton(context),
      ],
    );
  }

  Widget _buildTipItem(BuildContext context, Map<String, dynamic> tip) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: const EdgeInsets.only(top: 6),
            width: 6,
            height: 6,
            decoration: BoxDecoration(
              color: _getGoalColor(),
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: GestureDetector(
              onTap: () {
                if (tip['route'] != null) {
                  Navigator.pushNamed(context, tip['route']);
                }
              },
              child: Text(
                tip['text'],
                style: GoogleFonts.inter(
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  color: tip['route'] != null ? const Color(0xFF007AFF) : const Color(0xFF8E8E93),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTutorialButton(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Navigate to goal-specific tutorial
        _showTutorialDialog(context);
      },
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: _getGoalColor().withAlpha(26),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: _getGoalColor().withAlpha(51),
            width: 1,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.play_circle_outline,
              size: 20,
              color: _getGoalColor(),
            ),
            const SizedBox(width: 8),
            Text(
              'Watch Tutorial',
              style: GoogleFonts.inter(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: _getGoalColor(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showTutorialDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF191919),
        title: Text(
          'Tutorial Coming Soon',
          style: GoogleFonts.inter(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
        content: Text(
          'Interactive tutorials for ${_getGoalTitle().toLowerCase()} will be available soon.',
          style: GoogleFonts.inter(
            fontSize: 14,
            fontWeight: FontWeight.w400,
            color: const Color(0xFF8E8E93),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'OK',
              style: GoogleFonts.inter(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: const Color(0xFF007AFF),
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _getGoalTitle() {
    switch (workspaceGoal) {
      case 'social_media_growth':
        return 'Ready to Grow Your Social Media?';
      case 'e_commerce_sales':
        return 'Ready to Start Selling Online?';
      case 'course_creation':
        return 'Ready to Create Your First Course?';
      case 'lead_generation':
        return 'Ready to Generate Leads?';
      case 'content_creation':
        return 'Ready to Create Amazing Content?';
      case 'brand_building':
        return 'Ready to Build Your Brand?';
      default:
        return 'Ready to Get Started?';
    }
  }

  String _getGoalDescription() {
    switch (workspaceGoal) {
      case 'social_media_growth':
        return 'Your workspace is set up for social media growth. Start by scheduling posts and researching trending hashtags.';
      case 'e_commerce_sales':
        return 'Your workspace is optimized for e-commerce sales. Begin by adding products and setting up payment processing.';
      case 'course_creation':
        return 'Your workspace is configured for course creation. Start by creating your first course and adding content.';
      case 'lead_generation':
        return 'Your workspace is designed for lead generation. Begin by setting up contact forms and email campaigns.';
      case 'content_creation':
        return 'Your workspace is tailored for content creation. Start by creating templates and scheduling posts.';
      case 'brand_building':
        return 'Your workspace is optimized for brand building. Begin by customizing your brand settings and creating content.';
      default:
        return 'Your workspace is ready to use. Explore the available features to get started.';
    }
  }

  List<Map<String, dynamic>> _getGoalSpecificTips() {
    switch (workspaceGoal) {
      case 'social_media_growth':
        return [
          {'text': 'Schedule your first post to get started', 'route': '/social-media-scheduler'},
          {'text': 'Research trending hashtags for your niche', 'route': '/hashtag-research-screen'},
          {'text': 'Set up your content calendar', 'route': '/content-calendar-screen'},
          {'text': 'Connect your Instagram account', 'route': '/instagram-lead-search'},
        ];
      case 'e_commerce_sales':
        return [
          {'text': 'Add your first product to the store', 'route': '/marketplace-store'},
          {'text': 'Set up payment processing', 'route': '/marketplace-store'},
          {'text': 'Configure inventory management', 'route': '/marketplace-store'},
          {'text': 'Set up customer relationship management', 'route': '/crm-contact-management'},
        ];
      case 'course_creation':
        return [
          {'text': 'Create your first course', 'route': '/course-creator'},
          {'text': 'Add course content and modules', 'route': '/course-creator'},
          {'text': 'Set up student management', 'route': '/course-creator'},
          {'text': 'Create email marketing campaigns', 'route': '/email-marketing-campaign'},
        ];
      case 'lead_generation':
        return [
          {'text': 'Set up contact forms', 'route': '/crm-contact-management'},
          {'text': 'Create email marketing campaigns', 'route': '/email-marketing-campaign'},
          {'text': 'Search for potential leads on Instagram', 'route': '/instagram-lead-search'},
          {'text': 'Generate QR codes for lead capture', 'route': '/qr-code-generator-screen'},
        ];
      default:
        return [
          {'text': 'Explore the quick actions above', 'route': null},
          {'text': 'Check out the analytics dashboard', 'route': '/analytics-dashboard'},
          {'text': 'Customize your workspace settings', 'route': '/workspace-settings-screen'},
        ];
    }
  }

  Color _getGoalColor() {
    switch (workspaceGoal) {
      case 'social_media_growth':
        return const Color(0xFF00D4AA);
      case 'e_commerce_sales':
        return const Color(0xFFFF6B35);
      case 'course_creation':
        return const Color(0xFF6366F1);
      case 'lead_generation':
        return const Color(0xFFF59E0B);
      case 'content_creation':
        return const Color(0xFFEF4444);
      case 'brand_building':
        return const Color(0xFF8B5CF6);
      default:
        return const Color(0xFF8E8E93);
    }
  }

  IconData _getGoalIcon() {
    switch (workspaceGoal) {
      case 'social_media_growth':
        return Icons.trending_up;
      case 'e_commerce_sales':
        return Icons.shopping_cart;
      case 'course_creation':
        return Icons.school;
      case 'lead_generation':
        return Icons.people_alt;
      case 'content_creation':
        return Icons.create;
      case 'brand_building':
        return Icons.branding_watermark;
      default:
        return Icons.dashboard;
    }
  }
}