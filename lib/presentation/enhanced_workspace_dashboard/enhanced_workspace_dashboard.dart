import '../../core/app_export.dart';
import '../../services/dynamic_data_service.dart';
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
  
  final DynamicDataService _dataService = DynamicDataService();
  
  bool _isRefreshing = false;
  bool _isLoading = true;
  String _selectedWorkspace = '';
  String _selectedWorkspaceId = '';
  int _selectedTabIndex = 0;

  List<Map<String, dynamic>> _workspaces = [];
  Map<String, dynamic> _dashboardData = {};
  Map<String, dynamic> _heroMetrics = {};
  List<Map<String, dynamic>> _recentActivities = [];

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
    _loadData();
  }

  @override
  void dispose() {
    _tabController.dispose();
    _refreshController.dispose();
    super.dispose();
  }

  Future<void> _loadData() async {
    setState(() => _isLoading = true);
    
    try {
      // Load workspaces from Supabase
      final workspaces = await _dataService.fetchWorkspaces();
      
      if (workspaces.isNotEmpty) {
        final firstWorkspace = workspaces.first;
        _selectedWorkspace = firstWorkspace['name'] ?? 'Unknown Workspace';
        _selectedWorkspaceId = firstWorkspace['id'] ?? '';
        
        // Load dashboard data for selected workspace
        await _loadWorkspaceData(_selectedWorkspaceId);
      }
      
      setState(() {
        _workspaces = workspaces;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      ErrorHandler.handleError('Failed to load workspace data: $e');
    }
  }

  Future<void> _loadWorkspaceData(String workspaceId) async {
    if (workspaceId.isEmpty) return;
    
    try {
      final dashboardData = await _dataService.fetchWorkspaceDashboardAnalytics(workspaceId);
      
      setState(() {
        _dashboardData = dashboardData;
        _heroMetrics = dashboardData['hero_metrics'] ?? {};
        _recentActivities = List<Map<String, dynamic>>.from(
          dashboardData['recent_activities'] ?? []
        );
      });
    } catch (e) {
      ErrorHandler.handleError('Failed to load workspace analytics: $e');
    }
  }

  Future<void> _handleRefresh() async {
    if (_isRefreshing) return;
    
    setState(() => _isRefreshing = true);
    
    HapticFeedback.mediumImpact();
    _refreshController.forward();
    
    // Reload workspace data
    if (_selectedWorkspaceId.isNotEmpty) {
      await _loadWorkspaceData(_selectedWorkspaceId);
    }
    
    await Future.delayed(const Duration(seconds: 1));
    
    _refreshController.reverse();
    setState(() => _isRefreshing = false);
    
    HapticFeedback.lightImpact();
  }

  Future<void> _onWorkspaceChanged(String workspaceName) async {
    final selectedWorkspace = _workspaces.firstWhere(
      (w) => w['name'] == workspaceName,
      orElse: () => {},
    );
    
    if (selectedWorkspace.isNotEmpty) {
      setState(() {
        _selectedWorkspace = workspaceName;
        _selectedWorkspaceId = selectedWorkspace['id'] ?? '';
      });
      
      await _loadWorkspaceData(_selectedWorkspaceId);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        backgroundColor: const Color(0xFF101010),
        body: const Center(
          child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF007AFF)),
          ),
        ),
      );
    }

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
              // Workspace Status Bar with dynamic data
              WorkspaceStatusBarWidget(
                selectedWorkspace: _selectedWorkspace,
                workspaces: _workspaces.map((w) => {
                  'name': w['name'] ?? 'Unknown',
                  'members': 0, // This could be calculated from workspace_members
                  'status': 'Active',
                }).toList(),
                onWorkspaceChanged: _onWorkspaceChanged,
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
                        // Hero Metrics Section with dynamic data
                        HeroMetricsSectionWidget(
                          isRefreshing: _isRefreshing,
                          refreshController: _refreshController,
                          heroMetrics: _heroMetrics,
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
                        
                        // Recent Activity Feed with dynamic data
                        Text(
                          'Recent Activity',
                          style: GoogleFonts.inter(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 12),
                        RecentActivityFeedWidget(
                          activities: _recentActivities,
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