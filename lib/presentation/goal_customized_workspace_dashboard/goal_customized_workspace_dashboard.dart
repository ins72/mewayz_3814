import '../../core/app_export.dart';
import './widgets/goal_customized_floating_action_button_widget.dart';
import './widgets/goal_customized_hero_metrics_widget.dart';
import './widgets/goal_customized_quick_actions_widget.dart';
import './widgets/goal_customized_recent_activity_widget.dart';
import './widgets/goal_customized_workspace_header_widget.dart';
import './widgets/goal_customized_feature_discovery_widget.dart';
import './widgets/goal_customized_empty_state_widget.dart';

class GoalCustomizedWorkspaceDashboard extends StatefulWidget {
  const GoalCustomizedWorkspaceDashboard({Key? key}) : super(key: key);

  @override
  State<GoalCustomizedWorkspaceDashboard> createState() => _GoalCustomizedWorkspaceDashboardState();
}

class _GoalCustomizedWorkspaceDashboardState extends State<GoalCustomizedWorkspaceDashboard> with TickerProviderStateMixin {
  late TabController _tabController;
  late AnimationController _refreshController;
  bool _isRefreshing = false;
  String _selectedWorkspace = 'My Workspace';
  int _selectedTabIndex = 0;
  String _workspaceGoal = 'general';
  Map<String, dynamic> _workspaceData = {};
  bool _isLoading = true;

  final List<Map<String, dynamic>> _workspaces = [];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 5, vsync: this);
    _refreshController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    _tabController.addListener(() {
      setState(() {
        _selectedTabIndex = _tabController.index;
      });
    });
    _loadWorkspaceData();
  }

  @override
  void dispose() {
    _tabController.dispose();
    _refreshController.dispose();
    super.dispose();
  }

  void _loadWorkspaceData() {
    setState(() {
      _isLoading = true;
    });
    
    // Load workspace data without sample data
    Future.delayed(const Duration(milliseconds: 800), () {
      setState(() {
        _workspaceGoal = 'general';
        _workspaceData = _getWorkspaceDataForGoal(_workspaceGoal);
        _isLoading = false;
      });
    });
  }

  Map<String, dynamic> _getWorkspaceDataForGoal(String goal) {
    switch (goal) {
      case 'social_media_growth':
        return {
          'metrics': {
            'followers': {'value': 0, 'change': 0, 'trend': 'neutral'},
            'engagement_rate': {'value': 0.0, 'change': 0, 'trend': 'neutral'},
            'scheduled_posts': {'value': 0, 'change': 0, 'trend': 'neutral'},
            'reach': {'value': 0, 'change': 0, 'trend': 'neutral'},
          },
          'quickActions': [
            {'title': 'Instagram Search', 'icon': Icons.search, 'route': '/instagram-lead-search'},
            {'title': 'Post Scheduler', 'icon': Icons.schedule, 'route': '/social-media-scheduler'},
            {'title': 'Content Calendar', 'icon': Icons.calendar_today, 'route': '/content-calendar-screen'},
            {'title': 'Hashtag Research', 'icon': Icons.tag, 'route': '/hashtag-research-screen'},
          ],
          'secondaryFeatures': [
            {'title': 'Analytics Dashboard', 'icon': Icons.analytics, 'route': '/analytics-dashboard'},
            {'title': 'Social Media Hub', 'icon': Icons.hub, 'route': '/social-media-management-hub'},
          ],
        };
      case 'e_commerce_sales':
        return {
          'metrics': {
            'revenue': {'value': 0, 'change': 0, 'trend': 'neutral'},
            'orders': {'value': 0, 'change': 0, 'trend': 'neutral'},
            'inventory_alerts': {'value': 0, 'change': 0, 'trend': 'neutral'},
            'conversion_rate': {'value': 0.0, 'change': 0, 'trend': 'neutral'},
          },
          'quickActions': [
            {'title': 'Marketplace Store', 'icon': Icons.store, 'route': '/marketplace-store'},
            {'title': 'Inventory Management', 'icon': Icons.inventory, 'route': '/marketplace-store'},
            {'title': 'Order Processing', 'icon': Icons.receipt_long, 'route': '/marketplace-store'},
            {'title': 'CRM System', 'icon': Icons.people, 'route': '/crm-contact-management'},
          ],
          'secondaryFeatures': [
            {'title': 'Analytics Dashboard', 'icon': Icons.analytics, 'route': '/analytics-dashboard'},
            {'title': 'Email Marketing', 'icon': Icons.email, 'route': '/email-marketing-campaign'},
          ],
        };
      case 'course_creation':
        return {
          'metrics': {
            'students': {'value': 0, 'change': 0, 'trend': 'neutral'},
            'completion_rate': {'value': 0.0, 'change': 0, 'trend': 'neutral'},
            'course_revenue': {'value': 0, 'change': 0, 'trend': 'neutral'},
            'enrollments': {'value': 0, 'change': 0, 'trend': 'neutral'},
          },
          'quickActions': [
            {'title': 'Course Creator', 'icon': Icons.school, 'route': '/course-creator'},
            {'title': 'Student Management', 'icon': Icons.group, 'route': '/course-creator'},
            {'title': 'Content Library', 'icon': Icons.library_books, 'route': '/content-templates-screen'},
            {'title': 'Course Analytics', 'icon': Icons.analytics, 'route': '/analytics-dashboard'},
          ],
          'secondaryFeatures': [
            {'title': 'Email Marketing', 'icon': Icons.email, 'route': '/email-marketing-campaign'},
            {'title': 'QR Code Generator', 'icon': Icons.qr_code, 'route': '/qr-code-generator-screen'},
          ],
        };
      default:
        return {
          'metrics': {
            'total_activity': {'value': 0, 'change': 0, 'trend': 'neutral'},
            'features_used': {'value': 0, 'change': 0, 'trend': 'neutral'},
          },
          'quickActions': [
            {'title': 'Analytics Dashboard', 'icon': Icons.analytics, 'route': '/analytics-dashboard'},
            {'title': 'Settings', 'icon': Icons.settings, 'route': '/workspace-settings-screen'},
          ],
          'secondaryFeatures': [],
        };
    }
  }

  Future<void> _handleRefresh() async {
    if (_isRefreshing) return;
    
    setState(() {
      _isRefreshing = true;
    });
    
    HapticFeedback.mediumImpact();
    _refreshController.forward();
    
    await Future.delayed(const Duration(seconds: 2));
    
    _refreshController.reverse();
    setState(() {
      _isRefreshing = false;
    });
    
    HapticFeedback.lightImpact();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF101010),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF101010),
              Color(0xFF0A0A0A),
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Goal-Customized Workspace Header
              GoalCustomizedWorkspaceHeaderWidget(
                selectedWorkspace: _selectedWorkspace,
                workspaces: _workspaces,
                workspaceGoal: _workspaceGoal,
                onWorkspaceChanged: (workspace) {
                  setState(() {
                    _selectedWorkspace = workspace;
                  });
                  _loadWorkspaceData();
                },
              ),
              
              // Tab Bar Navigation
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: const Color(0xFF191919),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: TabBar(
                  controller: _tabController,
                  indicatorColor: Colors.transparent,
                  labelColor: const Color(0xFF007AFF),
                  unselectedLabelColor: const Color(0xFF8E8E93),
                  labelStyle: GoogleFonts.inter(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                  unselectedLabelStyle: GoogleFonts.inter(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                  tabs: [
                    _buildTabItem('Dashboard', 0),
                    _buildTabItem('Social', 1),
                    _buildTabItem('CRM', 2),
                    _buildTabItem('Store', 3),
                    _buildTabItem('Analytics', 4),
                  ],
                ),
              ),
              
              // Main Content
              Expanded(
                child: RefreshIndicator(
                  onRefresh: _handleRefresh,
                  backgroundColor: const Color(0xFF191919),
                  color: const Color(0xFF007AFF),
                  child: _isLoading
                      ? const Center(
                          child: CircularProgressIndicator(
                            color: Color(0xFF007AFF),
                          ),
                        )
                      : SingleChildScrollView(
                          physics: const AlwaysScrollableScrollPhysics(),
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Goal-Customized Hero Metrics
                              GoalCustomizedHeroMetricsWidget(
                                workspaceGoal: _workspaceGoal,
                                metrics: _workspaceData['metrics'] ?? {},
                                isRefreshing: _isRefreshing,
                                refreshController: _refreshController,
                              ),
                              
                              const SizedBox(height: 24),
                              
                              // Goal-Customized Quick Actions
                              Text(
                                'Quick Actions',
                                style: GoogleFonts.inter(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white,
                                ),
                              ),
                              const SizedBox(height: 12),
                              GoalCustomizedQuickActionsWidget(
                                quickActions: _workspaceData['quickActions'] ?? [],
                                workspaceGoal: _workspaceGoal,
                              ),
                              
                              const SizedBox(height: 24),
                              
                              // Feature Discovery Panel
                              if (_workspaceData['secondaryFeatures']?.isNotEmpty ?? false) ...[
                                Text(
                                  'Enable More Features',
                                  style: GoogleFonts.inter(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white,
                                  ),
                                ),
                                const SizedBox(height: 12),
                                GoalCustomizedFeatureDiscoveryWidget(
                                  secondaryFeatures: _workspaceData['secondaryFeatures'] ?? [],
                                  workspaceGoal: _workspaceGoal,
                                ),
                                const SizedBox(height: 24),
                              ],
                              
                              // Recent Activity Feed
                              Text(
                                'Recent Activity',
                                style: GoogleFonts.inter(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white,
                                ),
                              ),
                              const SizedBox(height: 12),
                              GoalCustomizedRecentActivityWidget(
                                workspaceGoal: _workspaceGoal,
                              ),
                              
                              const SizedBox(height: 24),
                              
                              // Empty State Guidance
                              GoalCustomizedEmptyStateWidget(
                                workspaceGoal: _workspaceGoal,
                              ),
                              
                              const SizedBox(height: 100), // Space for FAB
                            ],
                          ),
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: GoalCustomizedFloatingActionButtonWidget(
        workspaceGoal: _workspaceGoal,
      ),
    );
  }

  Widget _buildTabItem(String title, int index) {
    final isSelected = _selectedTabIndex == index;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: isSelected ? const Color(0xFF007AFF).withAlpha(26) : Colors.transparent,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(title),
    );
  }
}