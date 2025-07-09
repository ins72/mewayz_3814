import '../../../core/app_export.dart';

class GoalCustomizedWorkspaceHeaderWidget extends StatelessWidget {
  final String selectedWorkspace;
  final List<Map<String, dynamic>> workspaces;
  final String workspaceGoal;
  final Function(String) onWorkspaceChanged;

  const GoalCustomizedWorkspaceHeaderWidget({
    Key? key,
    required this.selectedWorkspace,
    required this.workspaces,
    required this.workspaceGoal,
    required this.onWorkspaceChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(
        color: Color(0xFF101010),
        border: Border(
          bottom: BorderSide(
            color: Color(0xFF2C2C2E),
            width: 1,
          ),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Workspace Name and Goal Badge
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    DropdownButton<String>(
                      value: selectedWorkspace,
                      onChanged: (String? newValue) {
                        if (newValue != null) {
                          onWorkspaceChanged(newValue);
                        }
                      },
                      dropdownColor: const Color(0xFF191919),
                      underline: const SizedBox(),
                      icon: const Icon(
                        Icons.keyboard_arrow_down,
                        color: Color(0xFF8E8E93),
                      ),
                      items: workspaces.map<DropdownMenuItem<String>>((workspace) {
                        return DropdownMenuItem<String>(
                          value: workspace['name'],
                          child: Text(
                            workspace['name'],
                            style: GoogleFonts.inter(
                              fontSize: 20,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 4),
                    _buildGoalBadge(workspaceGoal),
                  ],
                ),
              ),
              // Quick Access to Settings
              IconButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/workspace-settings-screen');
                },
                icon: const Icon(
                  Icons.settings,
                  color: Color(0xFF8E8E93),
                  size: 24,
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 16),
          
          // Workspace Status and Members
          Row(
            children: [
              _buildStatusIndicator(),
              const SizedBox(width: 16),
              _buildMemberCount(),
              const Spacer(),
              _buildEnableMoreFeaturesButton(context),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildGoalBadge(String goal) {
    Map<String, dynamic> goalInfo = _getGoalInfo(goal);
    
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: goalInfo['color'].withAlpha(26),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: goalInfo['color'].withAlpha(51),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            goalInfo['icon'],
            size: 14,
            color: goalInfo['color'],
          ),
          const SizedBox(width: 4),
          Text(
            goalInfo['label'],
            style: GoogleFonts.inter(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: goalInfo['color'],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusIndicator() {
    return Row(
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: const BoxDecoration(
            color: Color(0xFF34C759),
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 6),
        Text(
          'Active',
          style: GoogleFonts.inter(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: const Color(0xFF8E8E93),
          ),
        ),
      ],
    );
  }

  Widget _buildMemberCount() {
    final currentWorkspace = workspaces.firstWhere(
      (w) => w['name'] == selectedWorkspace,
      orElse: () => workspaces.first,
    );
    
    return Row(
      children: [
        const Icon(
          Icons.people,
          size: 16,
          color: Color(0xFF8E8E93),
        ),
        const SizedBox(width: 4),
        Text(
          '${currentWorkspace['members']} members',
          style: GoogleFonts.inter(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: const Color(0xFF8E8E93),
          ),
        ),
      ],
    );
  }

  Widget _buildEnableMoreFeaturesButton(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, '/workspace-settings-screen');
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
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.add,
              size: 16,
              color: Color(0xFF007AFF),
            ),
            const SizedBox(width: 4),
            Text(
              'Enable More',
              style: GoogleFonts.inter(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: const Color(0xFF007AFF),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Map<String, dynamic> _getGoalInfo(String goal) {
    switch (goal) {
      case 'social_media_growth':
        return {
          'label': 'Social Media Growth',
          'icon': Icons.trending_up,
          'color': const Color(0xFF00D4AA),
        };
      case 'e_commerce_sales':
        return {
          'label': 'E-commerce Sales',
          'icon': Icons.shopping_cart,
          'color': const Color(0xFFFF6B35),
        };
      case 'course_creation':
        return {
          'label': 'Course Creation',
          'icon': Icons.school,
          'color': const Color(0xFF6366F1),
        };
      case 'lead_generation':
        return {
          'label': 'Lead Generation',
          'icon': Icons.people_alt,
          'color': const Color(0xFFF59E0B),
        };
      case 'content_creation':
        return {
          'label': 'Content Creation',
          'icon': Icons.create,
          'color': const Color(0xFFEF4444),
        };
      case 'brand_building':
        return {
          'label': 'Brand Building',
          'icon': Icons.branding_watermark,
          'color': const Color(0xFF8B5CF6),
        };
      default:
        return {
          'label': 'General',
          'icon': Icons.dashboard,
          'color': const Color(0xFF8E8E93),
        };
    }
  }
}