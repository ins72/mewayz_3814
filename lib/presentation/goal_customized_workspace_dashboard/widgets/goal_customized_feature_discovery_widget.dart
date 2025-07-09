import '../../../core/app_export.dart';

class GoalCustomizedFeatureDiscoveryWidget extends StatefulWidget {
  final List<Map<String, dynamic>> secondaryFeatures;
  final String workspaceGoal;

  const GoalCustomizedFeatureDiscoveryWidget({
    Key? key,
    required this.secondaryFeatures,
    required this.workspaceGoal,
  }) : super(key: key);

  @override
  State<GoalCustomizedFeatureDiscoveryWidget> createState() => _GoalCustomizedFeatureDiscoveryWidgetState();
}

class _GoalCustomizedFeatureDiscoveryWidgetState extends State<GoalCustomizedFeatureDiscoveryWidget> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF191919),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: const Color(0xFF007AFF).withAlpha(26),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          GestureDetector(
            onTap: () {
              setState(() {
                _isExpanded = !_isExpanded;
              });
            },
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: const Color(0xFF007AFF).withAlpha(26),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(
                    Icons.auto_awesome,
                    size: 20,
                    color: Color(0xFF007AFF),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Discover More Features',
                        style: GoogleFonts.inter(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        'Expand your ${_getGoalName()} capabilities',
                        style: GoogleFonts.inter(
                          fontSize: 12,
                          fontWeight: FontWeight.w400,
                          color: const Color(0xFF8E8E93),
                        ),
                      ),
                    ],
                  ),
                ),
                AnimatedRotation(
                  turns: _isExpanded ? 0.5 : 0,
                  duration: const Duration(milliseconds: 200),
                  child: const Icon(
                    Icons.keyboard_arrow_down,
                    color: Color(0xFF8E8E93),
                    size: 20,
                  ),
                ),
              ],
            ),
          ),
          
          // Expandable Content
          AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            height: _isExpanded ? null : 0,
            child: _isExpanded
                ? Column(
                    children: [
                      const SizedBox(height: 16),
                      _buildFeaturesList(),
                    ],
                  )
                : null,
          ),
        ],
      ),
    );
  }

  Widget _buildFeaturesList() {
    return Column(
      children: widget.secondaryFeatures.map((feature) {
        return _buildFeatureItem(feature);
      }).toList(),
    );
  }

  Widget _buildFeatureItem(Map<String, dynamic> feature) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFF2C2C2E),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          // Feature Icon
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: const Color(0xFF8E8E93).withAlpha(26),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Icon(
              feature['icon'],
              size: 16,
              color: const Color(0xFF8E8E93),
            ),
          ),
          
          const SizedBox(width: 12),
          
          // Feature Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  feature['title'],
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
                Text(
                  _getFeatureDescription(feature['title']),
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                    color: const Color(0xFF8E8E93),
                  ),
                ),
              ],
            ),
          ),
          
          // Enable Button
          GestureDetector(
            onTap: () {
              HapticFeedback.lightImpact();
              Navigator.pushNamed(context, feature['route']);
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: const Color(0xFF007AFF).withAlpha(26),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: const Color(0xFF007AFF).withAlpha(51),
                  width: 1,
                ),
              ),
              child: Text(
                'Enable',
                style: GoogleFonts.inter(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: const Color(0xFF007AFF),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _getGoalName() {
    switch (widget.workspaceGoal) {
      case 'social_media_growth':
        return 'social media';
      case 'e_commerce_sales':
        return 'e-commerce';
      case 'course_creation':
        return 'course creation';
      case 'lead_generation':
        return 'lead generation';
      case 'content_creation':
        return 'content creation';
      case 'brand_building':
        return 'brand building';
      default:
        return 'workspace';
    }
  }

  String _getFeatureDescription(String featureTitle) {
    switch (featureTitle) {
      case 'Analytics Dashboard':
        return 'Advanced analytics and reporting';
      case 'Social Media Hub':
        return 'Centralized social media management';
      case 'Email Marketing':
        return 'Create and send email campaigns';
      case 'QR Code Generator':
        return 'Generate QR codes for your content';
      case 'CRM System':
        return 'Manage customer relationships';
      default:
        return 'Additional workspace functionality';
    }
  }
}