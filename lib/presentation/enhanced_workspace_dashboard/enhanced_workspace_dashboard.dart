
import '../../core/app_export.dart';
import './widgets/enhanced_floating_action_button_widget.dart';
import './widgets/hero_metrics_section_widget.dart';
import './widgets/quick_actions_grid_widget.dart';
import './widgets/recent_activity_feed_widget.dart';
import './widgets/workspace_status_bar_widget.dart';

class EnhancedWorkspaceDashboard extends StatefulWidget {
  const EnhancedWorkspaceDashboard({Key? key}) : super(key: key);

  @override
  State<EnhancedWorkspaceDashboard> createState() => _EnhancedWorkspaceDashboardState();
}

class _EnhancedWorkspaceDashboardState extends State<EnhancedWorkspaceDashboard> with TickerProviderStateMixin {
  late TabController _tabController;
  late AnimationController _refreshController;
  bool _isRefreshing = false;
  String _selectedWorkspace = 'Marketing Team';
  int _selectedTabIndex = 0;

  final List<Map<String, dynamic>> _workspaces = [
{'name': 'Marketing Team', 'members': 12, 'status': 'Active'},
{'name': 'Sales Department', 'members': 8, 'status': 'Active'},
{'name': 'Product Development', 'members': 15, 'status': 'Active'},
];

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
  }

  @override
  void dispose() {
    _tabController.dispose();
    _refreshController.dispose();
    super.dispose();
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
              // Workspace Status Bar
              WorkspaceStatusBarWidget(
                selectedWorkspace: _selectedWorkspace,
                workspaces: _workspaces,
                onWorkspaceChanged: (workspace) {
                  setState(() {
                    _selectedWorkspace = workspace;
                  });
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
                  child: SingleChildScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Hero Metrics Section
                        HeroMetricsSectionWidget(
                          isRefreshing: _isRefreshing,
                          refreshController: _refreshController,
                        ),
                        
                        const SizedBox(height: 24),
                        
                        // Quick Actions Grid
                        Text(
                          'Quick Actions',
                          style: GoogleFonts.inter(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 12),
                        const QuickActionsGridWidget(),
                        
                        const SizedBox(height: 24),
                        
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
                        const RecentActivityFeedWidget(),
                        
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
      floatingActionButton: const EnhancedFloatingActionButtonWidget(),
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