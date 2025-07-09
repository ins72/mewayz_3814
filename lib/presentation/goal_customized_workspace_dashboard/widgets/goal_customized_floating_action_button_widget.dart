import '../../../core/app_export.dart';

class GoalCustomizedFloatingActionButtonWidget extends StatefulWidget {
  final String workspaceGoal;

  const GoalCustomizedFloatingActionButtonWidget({
    Key? key,
    required this.workspaceGoal,
  }) : super(key: key);

  @override
  State<GoalCustomizedFloatingActionButtonWidget> createState() => _GoalCustomizedFloatingActionButtonWidgetState();
}

class _GoalCustomizedFloatingActionButtonWidgetState extends State<GoalCustomizedFloatingActionButtonWidget> 
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;
  bool _isExpanded = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _animation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _toggleExpanded() {
    setState(() {
      _isExpanded = !_isExpanded;
    });
    if (_isExpanded) {
      _animationController.forward();
    } else {
      _animationController.reverse();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.bottomRight,
      children: [
        // Backdrop
        if (_isExpanded)
          GestureDetector(
            onTap: _toggleExpanded,
            child: Container(
              width: double.infinity,
              height: double.infinity,
              color: Colors.black.withAlpha(77),
            ),
          ),
        
        // Action buttons
        ..._buildQuickCreateActions(),
        
        // Main FAB
        _buildMainFAB(),
      ],
    );
  }

  Widget _buildMainFAB() {
    return FloatingActionButton(
      onPressed: _toggleExpanded,
      backgroundColor: _getGoalColor(),
      heroTag: "main_fab",
      child: AnimatedRotation(
        turns: _isExpanded ? 0.125 : 0,
        duration: const Duration(milliseconds: 300),
        child: Icon(
          _isExpanded ? Icons.close : Icons.add,
          color: Colors.white,
          size: 28,
        ),
      ),
    );
  }

  List<Widget> _buildQuickCreateActions() {
    List<Map<String, dynamic>> actions = _getGoalContextualActions();
    
    return actions.asMap().entries.map((entry) {
      int index = entry.key;
      Map<String, dynamic> action = entry.value;
      
      return AnimatedBuilder(
        animation: _animation,
        builder: (context, child) {
          return Transform.translate(
            offset: Offset(
              0,
              -_animation.value * (70.0 * (index + 1)),
            ),
            child: Opacity(
              opacity: _animation.value,
              child: Container(
                margin: const EdgeInsets.only(bottom: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    // Action label
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      decoration: BoxDecoration(
                        color: const Color(0xFF191919),
                        borderRadius: BorderRadius.circular(8),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withAlpha(51),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Text(
                        action['label'],
                        style: GoogleFonts.inter(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    
                    const SizedBox(width: 12),
                    
                    // Action button
                    FloatingActionButton(
                      mini: true,
                      heroTag: "fab_${index}",
                      backgroundColor: action['color'],
                      onPressed: () {
                        HapticFeedback.lightImpact();
                        _toggleExpanded();
                        _handleActionTap(action);
                      },
                      child: Icon(
                        action['icon'],
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      );
    }).toList();
  }

  void _handleActionTap(Map<String, dynamic> action) {
    switch (action['type']) {
      case 'navigate':
        Navigator.pushNamed(context, action['route']);
        break;
      case 'modal':
        _showQuickCreateModal(action);
        break;
      case 'share':
        _showShareModal();
        break;
      default:
        break;
    }
  }

  void _showQuickCreateModal(Map<String, dynamic> action) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF191919),
        title: Text(
          'Quick ${action['label']}',
          style: GoogleFonts.inter(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              style: GoogleFonts.inter(color: Colors.white),
              decoration: InputDecoration(
                hintText: action['placeholder'],
                hintStyle: GoogleFonts.inter(color: const Color(0xFF8E8E93)),
                filled: true,
                fillColor: const Color(0xFF2C2C2E),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text(
                    'Cancel',
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: const Color(0xFF8E8E93),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                    if (action['route'] != null) {
                      Navigator.pushNamed(context, action['route']);
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: action['color'],
                    foregroundColor: Colors.white,
                  ),
                  child: Text(
                    'Create',
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showShareModal() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF191919),
        title: Text(
          'Share Workspace',
          style: GoogleFonts.inter(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
        content: Text(
          'Share your workspace progress and achievements with your team.',
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
              'Cancel',
              style: GoogleFonts.inter(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: const Color(0xFF8E8E93),
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              // Implement sharing logic
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF007AFF),
              foregroundColor: Colors.white,
            ),
            child: Text(
              'Share',
              style: GoogleFonts.inter(
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  List<Map<String, dynamic>> _getGoalContextualActions() {
    switch (widget.workspaceGoal) {
      case 'social_media_growth':
        return [
          {
            'label': 'Quick Post',
            'icon': Icons.post_add,
            'color': const Color(0xFF00D4AA),
            'type': 'modal',
            'placeholder': 'What\'s on your mind?',
            'route': '/social-media-scheduler',
          },
          {
            'label': 'Schedule Content',
            'icon': Icons.schedule,
            'color': const Color(0xFF6366F1),
            'type': 'navigate',
            'route': '/content-calendar-screen',
          },
          {
            'label': 'Share Progress',
            'icon': Icons.share,
            'color': const Color(0xFF8B5CF6),
            'type': 'share',
          },
        ];
      case 'e_commerce_sales':
        return [
          {
            'label': 'Add Product',
            'icon': Icons.add_shopping_cart,
            'color': const Color(0xFFFF6B35),
            'type': 'modal',
            'placeholder': 'Product name',
            'route': '/marketplace-store',
          },
          {
            'label': 'View Orders',
            'icon': Icons.receipt_long,
            'color': const Color(0xFF6366F1),
            'type': 'navigate',
            'route': '/marketplace-store',
          },
          {
            'label': 'Share Store',
            'icon': Icons.share,
            'color': const Color(0xFF8B5CF6),
            'type': 'share',
          },
        ];
      case 'course_creation':
        return [
          {
            'label': 'Create Course',
            'icon': Icons.school,
            'color': const Color(0xFF6366F1),
            'type': 'modal',
            'placeholder': 'Course title',
            'route': '/course-creator',
          },
          {
            'label': 'Add Content',
            'icon': Icons.library_add,
            'color': const Color(0xFF00D4AA),
            'type': 'navigate',
            'route': '/content-templates-screen',
          },
          {
            'label': 'Share Course',
            'icon': Icons.share,
            'color': const Color(0xFF8B5CF6),
            'type': 'share',
          },
        ];
      default:
        return [
          {
            'label': 'Quick Action',
            'icon': Icons.flash_on,
            'color': const Color(0xFF007AFF),
            'type': 'navigate',
            'route': '/analytics-dashboard',
          },
          {
            'label': 'Share Workspace',
            'icon': Icons.share,
            'color': const Color(0xFF8B5CF6),
            'type': 'share',
          },
        ];
    }
  }

  Color _getGoalColor() {
    switch (widget.workspaceGoal) {
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
        return const Color(0xFF007AFF);
    }
  }
}