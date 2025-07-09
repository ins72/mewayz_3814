import '../../core/app_export.dart';
import '../crm_contact_management/crm_contact_management.dart';
import '../marketplace_store/marketplace_store.dart';
import '../social_media_manager/social_media_manager.dart';
import './widgets/activity_item_widget.dart';
import './widgets/metrics_card_widget.dart';
import './widgets/quick_action_widget.dart';

class WorkspaceDashboard extends StatefulWidget {
  const WorkspaceDashboard({Key? key}) : super(key: key);

  @override
  State<WorkspaceDashboard> createState() => _WorkspaceDashboardState();
}

class _WorkspaceDashboardState extends State<WorkspaceDashboard>
    with TickerProviderStateMixin {
  late TabController _tabController;
  String selectedWorkspace = "Digital Marketing Agency";
  bool isRefreshing = false;
  int _currentBottomNavIndex = 0;
  bool _isLoading = false;

  final List<Map<String, dynamic>> workspaces = [
{"id": "1", "name": "Digital Marketing Agency", "isActive": true},
{"id": "2", "name": "E-commerce Store", "isActive": false},
{"id": "3", "name": "Course Creator Hub", "isActive": false},
{"id": "4", "name": "Freelance Business", "isActive": false},
];

  final List<Map<String, dynamic>> metricsData = [
{ "title": "Total Leads",
"value": "2,847",
"change": "+12.5%",
"isPositive": true,
"icon": "people",
"color": AppTheme.accent,
},
{ "title": "Revenue",
"value": "\$45,230",
"change": "+8.2%",
"isPositive": true,
"icon": "attach_money",
"color": AppTheme.success,
},
{ "title": "Social Followers",
"value": "18.5K",
"change": "+15.7%",
"isPositive": true,
"icon": "favorite",
"color": AppTheme.warning,
},
{ "title": "Course Enrollments",
"value": "1,234",
"change": "-2.1%",
"isPositive": false,
"icon": "school",
"color": AppTheme.accent,
},
];

  final List<Map<String, dynamic>> quickActions = [
{ "title": "Instagram Search",
"subtitle": "Find leads",
"icon": "search",
"route": AppRoutes.instagramLeadSearch,
"color": AppTheme.accent,
},
{ "title": "Post Scheduler",
"subtitle": "Schedule posts",
"icon": "schedule",
"route": AppRoutes.socialMediaScheduler,
"color": AppTheme.success,
},
{ "title": "Link in Bio",
"subtitle": "Build pages",
"icon": "link",
"route": AppRoutes.linkInBioTemplatesScreen,
"color": AppTheme.warning,
},
{ "title": "Course Creator",
"subtitle": "Create courses",
"icon": "play_circle_filled",
"route": AppRoutes.courseCreator,
"color": AppTheme.accent,
},
{ "title": "Marketplace",
"subtitle": "Manage store",
"icon": "store",
"route": AppRoutes.marketplaceStore,
"color": AppTheme.success,
},
{ "title": "CRM",
"subtitle": "Manage contacts",
"icon": "contacts",
"route": AppRoutes.crmContactManagement,
"color": AppTheme.warning,
},
];

  final List<Map<String, dynamic>> recentActivities = [
{ "title": "New lead from Instagram campaign",
"subtitle": "Sarah Johnson - Digital Marketing",
"timestamp": "2 minutes ago",
"icon": "person_add",
"color": AppTheme.success,
},
{ "title": "Course enrollment completed",
"subtitle": "Advanced Social Media Marketing",
"timestamp": "15 minutes ago",
"icon": "school",
"color": AppTheme.accent,
},
{ "title": "Product sold on marketplace",
"subtitle": "Social Media Template Pack - \$29.99",
"timestamp": "1 hour ago",
"icon": "shopping_cart",
"color": AppTheme.warning,
},
{ "title": "Scheduled post published",
"subtitle": "Instagram - Marketing Tips #5",
"timestamp": "2 hours ago",
"icon": "publish",
"color": AppTheme.accent,
},
{ "title": "New contact added to CRM",
"subtitle": "Michael Rodriguez - Lead",
"timestamp": "3 hours ago",
"icon": "contact_page",
"color": AppTheme.success,
},
];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 5, vsync: this);
    _loadDashboardData();
    _loadWorkspaceData();
  }

  Future<void> _loadWorkspaceData() async {
    try {
      final storageService = StorageService();
      final currentWorkspaceId = await storageService.getCurrentWorkspace();
      final workspacesData = await storageService.getWorkspacesData();
      
      if (workspacesData != null) {
        setState(() {
          workspaces.clear();
          workspaces.addAll(workspacesData);
        });
      }
      
      if (currentWorkspaceId != null) {
        final currentWorkspace = workspaces.firstWhere(
          (ws) => ws['id'] == currentWorkspaceId,
          orElse: () => workspaces.first);
        setState(() {
          selectedWorkspace = currentWorkspace['name'];
          // Update active workspace
          for (var ws in workspaces) {
            ws['isActive'] = ws['id'] == currentWorkspaceId;
          }
        });
      }
    } catch (e) {
      ErrorHandler.handleError(e);
    }
  }

  Future<void> _saveWorkspaceData() async {
    try {
      final storageService = StorageService();
      await storageService.saveWorkspacesData(workspaces);
      
      final activeWorkspace = workspaces.firstWhere(
        (ws) => ws['isActive'] == true,
        orElse: () => workspaces.first);
      await storageService.saveCurrentWorkspace(activeWorkspace['id']);
    } catch (e) {
      ErrorHandler.handleError(e);
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _loadDashboardData() async {
    setState(() {
      _isLoading = true;
    });

    try {
      // Simulate API call to load dashboard data
      await Future.delayed(const Duration(milliseconds: 1500));
      
      // In real implementation, load actual data from API
      // await DashboardService.loadDashboardData();
    } catch (e) {
      // Handle error
      ErrorHandler.handleError(e);
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _handleRefresh() async {
    setState(() {
      isRefreshing = true;
    });

    try {
      // Simulate API call with better error handling
      await Future.delayed(const Duration(seconds: 2));
      
      // In real implementation, refresh data from API
      // await DashboardService.refreshDashboardData();
    } catch (e) {
      ErrorHandler.handleError(e);
    } finally {
      if (mounted) {
        setState(() {
          isRefreshing = false;
        });
      }
    }
  }

  void _showWorkspaceSelector() {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppTheme.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(AppTheme.radiusXl))),
      builder: (context) => Container(
        padding: EdgeInsets.all(AppTheme.spacingM),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Handle bar
            Center(
              child: Container(
                width: 48,
                height: 4,
                decoration: BoxDecoration(
                  color: AppTheme.border,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            SizedBox(height: AppTheme.spacingL),
            
            Text(
              "Switch Workspace",
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: AppTheme.spacingL),
            
            if (workspaces.isNotEmpty)
              ...workspaces.map((workspace) => Container(
                margin: const EdgeInsets.only(bottom: AppTheme.spacingM),
                child: ListTile(
                  title: Text(workspace['name']),
                  trailing: workspace['isActive'] ? Icon(Icons.check, color: AppTheme.accent) : null,
                ),
              )).toList()
            else
              Center(
                child: Text(
                  'No workspaces found',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ),
            
            SizedBox(height: AppTheme.spacingL),
            
            // Create New Workspace Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.pushNamed(context, AppRoutes.workspaceCreationScreen);
                },
                icon: Icon(Icons.add, size: AppTheme.iconSizeM),
                label: const Text('Create New Workspace'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.accent,
                  foregroundColor: AppTheme.primaryAction,
                  minimumSize: Size(double.infinity, AppTheme.buttonHeightM),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppTheme.radiusM),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showQuickCreateMenu() {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppTheme.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(AppTheme.radiusXl))),
      builder: (context) => Container(
        padding: EdgeInsets.all(AppTheme.spacingM),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Handle bar
            Center(
              child: Container(
                width: 48,
                height: 4,
                decoration: BoxDecoration(
                  color: AppTheme.border,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            SizedBox(height: AppTheme.spacingL),
            
            Text(
              "Quick Create",
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: AppTheme.spacingL),
            
            GridView.count(
              shrinkWrap: true,
              crossAxisCount: 4,
              crossAxisSpacing: AppTheme.spacingM,
              mainAxisSpacing: AppTheme.spacingM,
              children: [
                _buildQuickCreateItem(
                    "Post", "edit", AppRoutes.socialMediaScheduler),
                _buildQuickCreateItem(
                    "Product", "add_shopping_cart", AppRoutes.marketplaceStore),
                _buildQuickCreateItem(
                    "Course", "play_circle_filled", AppRoutes.courseCreator),
                _buildQuickCreateItem(
                    "Contact", "person_add", AppRoutes.crmContactManagement),
              ],
            ),
            SizedBox(height: AppTheme.spacingL),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickCreateItem(String title, String icon, String route) {
    return GestureDetector(
      onTap: () {
        Navigator.pop(context);
        Navigator.pushNamed(context, route);
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  AppTheme.accent.withAlpha(51),
                  AppTheme.accent.withAlpha(26),
                ],
              ),
              borderRadius: BorderRadius.circular(AppTheme.radiusM),
              border: Border.all(
                color: AppTheme.accent.withAlpha(77),
                width: 1,
              ),
            ),
            child: Center(
              child: CustomIconWidget(
                iconName: icon,
                color: AppTheme.accent,
                size: AppTheme.iconSizeL,
              ),
            ),
          ),
          SizedBox(height: AppTheme.spacingS),
          Text(
            title,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  void _onBottomNavTap(int index) {
    setState(() {
      _currentBottomNavIndex = index;
      _tabController.index = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.primaryBackground,
      appBar: CustomAppBarWidget(
        title: selectedWorkspace,
        titleWidget: GestureDetector(
          onTap: _showWorkspaceSelector,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Flexible(
                child: Text(
                  selectedWorkspace,
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              SizedBox(width: AppTheme.spacingS),
              CustomIconWidget(
                iconName: 'keyboard_arrow_down',
                color: AppTheme.primaryText,
                size: AppTheme.iconSizeM,
              ),
            ],
          ),
        ),
        actions: [
          IconButton(
            onPressed: () =>
                Navigator.pushNamed(context, AppRoutes.analyticsDashboard),
            icon: CustomIconWidget(
              iconName: 'analytics',
              color: AppTheme.primaryText,
              size: AppTheme.iconSizeL,
            ),
          ),
          IconButton(
            onPressed: () =>
                Navigator.pushNamed(context, AppRoutes.notificationSettingsScreen),
            icon: CustomIconWidget(
              iconName: 'notifications',
              color: AppTheme.primaryText,
              size: AppTheme.iconSizeL,
            ),
          ),
          SizedBox(width: AppTheme.spacingS),
        ],
      ),
      body: _isLoading
          ? const CustomLoadingWidget(
              message: 'Loading dashboard...')
          : TabBarView(
              controller: _tabController,
              children: [
                _buildDashboardTab(),
                _buildSocialTab(),
                _buildCRMTab(),
                _buildStoreTab(),
                _buildMoreTab(),
              ],
            ),
      bottomNavigationBar: CustomBottomNavigationWidget(
        currentIndex: _currentBottomNavIndex,
        onTap: _onBottomNavTap,
        items: const [
          BottomNavigationItem(
            iconName: 'dashboard',
            label: 'Dashboard',
          ),
          BottomNavigationItem(
            iconName: 'favorite',
            label: 'Social',
          ),
          BottomNavigationItem(
            iconName: 'contacts',
            label: 'CRM',
          ),
          BottomNavigationItem(
            iconName: 'store',
            label: 'Store',
          ),
          BottomNavigationItem(
            iconName: 'more_horiz',
            label: 'More',
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showQuickCreateMenu,
        backgroundColor: AppTheme.accent,
        child: CustomIconWidget(
          iconName: 'add',
          color: AppTheme.primaryAction,
          size: AppTheme.iconSizeL,
        ),
      ),
    );
  }

  Widget _buildDashboardTab() {
    return RefreshIndicator(
      onRefresh: _handleRefresh,
      color: AppTheme.accent,
      backgroundColor: AppTheme.surface,
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: EdgeInsets.all(AppTheme.spacingM),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Enhanced Metrics Cards
            SizedBox(
              height: 180,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: metricsData.length,
                separatorBuilder: (context, index) => SizedBox(width: AppTheme.spacingM),
                itemBuilder: (context, index) {
                  return MetricsCardWidget(
                    data: metricsData[index],
                    onLongPress: () => _showMetricsDetail(metricsData[index]),
                  );
                },
              ),
            ),

            SizedBox(height: AppTheme.spacingXl),

            // Quick Actions Section
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Quick Actions",
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                TextButton(
                  onPressed: () => _showQuickCreateMenu(),
                  child: Text(
                    "View All",
                    style: TextStyle(
                      color: AppTheme.accent,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: AppTheme.spacingM),

            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: AppTheme.spacingM,
                mainAxisSpacing: AppTheme.spacingM,
                childAspectRatio: 1.2,
              ),
              itemCount: quickActions.length > 4 ? 4 : quickActions.length,
              itemBuilder: (context, index) {
                return QuickActionWidget(
                  data: quickActions[index],
                  onTap: () => Navigator.pushNamed(
                      context, quickActions[index]["route"]),
                );
              },
            ),

            SizedBox(height: AppTheme.spacingXl),

            // Recent Activity Section
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Recent Activity",
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                TextButton(
                  onPressed: () {
                    // Navigate to full activity log
                  },
                  child: Text(
                    "View All",
                    style: TextStyle(
                      color: AppTheme.accent,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: AppTheme.spacingM),

            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: recentActivities.length,
              separatorBuilder: (context, index) => SizedBox(height: AppTheme.spacingM),
              itemBuilder: (context, index) {
                return ActivityItemWidget(
                  data: recentActivities[index],
                );
              },
            ),

            SizedBox(height: 120), // Bottom padding for FAB
          ],
        ),
      ),
    );
  }

  Widget _buildSocialTab() {
    return Navigator(
      onGenerateRoute: (settings) {
        return MaterialPageRoute(
          builder: (context) => const SocialMediaManager(),
        );
      },
    );
  }

  Widget _buildCRMTab() {
    return Navigator(
      onGenerateRoute: (settings) {
        return MaterialPageRoute(
          builder: (context) => const CrmContactManagement(),
        );
      },
    );
  }

  Widget _buildStoreTab() {
    return Navigator(
      onGenerateRoute: (settings) {
        return MaterialPageRoute(
          builder: (context) => const MarketplaceStore(),
        );
      },
    );
  }

  Widget _buildMoreTab() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(AppTheme.spacingM),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "More Features",
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: AppTheme.spacingL),
          
          // Quick Access Grid
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: AppTheme.spacingM,
              mainAxisSpacing: AppTheme.spacingM,
              childAspectRatio: 1.2,
            ),
            itemCount: quickActions.length,
            itemBuilder: (context, index) {
              return QuickActionWidget(
                data: quickActions[index],
                onTap: () => Navigator.pushNamed(
                    context, quickActions[index]["route"]),
              );
            },
          ),
          
          SizedBox(height: AppTheme.spacingXl),
          
          // Settings Section
          Container(
            padding: EdgeInsets.all(AppTheme.spacingM),
            decoration: AppTheme.cardDecoration(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Settings & Tools",
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: AppTheme.spacingM),
                
                _buildActionTile(
                  icon: Icons.settings,
                  title: 'Settings',
                  onTap: () => Navigator.pushNamed(context, AppRoutes.settingsScreen),
                ),
                
                _buildActionTile(
                  icon: Icons.analytics,
                  title: 'Analytics Dashboard',
                  onTap: () => Navigator.pushNamed(context, AppRoutes.analyticsDashboard),
                ),
                
                _buildActionTile(
                  icon: Icons.people,
                  title: 'Team Management',
                  onTap: () => Navigator.pushNamed(context, AppRoutes.usersTeamManagementScreen),
                ),
                
                _buildActionTile(
                  icon: Icons.help,
                  title: 'Contact Support',
                  onTap: () => Navigator.pushNamed(context, AppRoutes.contactUsScreen),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionTile({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: CustomIconWidget(
        iconName: icon.toString().split('.').last,
        color: AppTheme.accent,
        size: AppTheme.iconSizeL,
      ),
      title: Text(
        title,
        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
          fontWeight: FontWeight.w500,
        ),
      ),
      trailing: Icon(
        Icons.arrow_forward_ios,
        color: AppTheme.secondaryText,
        size: AppTheme.iconSizeS,
      ),
      onTap: onTap,
      contentPadding: EdgeInsets.zero,
    );
  }

  void _showMetricsDetail(Map<String, dynamic> metric) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppTheme.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppTheme.radiusL),
        ),
        title: Text(
          "${metric['title']} Analytics",
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: EdgeInsets.all(AppTheme.spacingM),
              decoration: BoxDecoration(
                color: (metric['color'] as Color).withAlpha(26),
                borderRadius: BorderRadius.circular(AppTheme.radiusM),
              ),
              child: Row(
                children: [
                  CustomIconWidget(
                    iconName: metric['icon'] ?? 'analytics',
                    color: metric['color'] ?? AppTheme.accent,
                    size: AppTheme.iconSizeL,
                  ),
                  SizedBox(width: AppTheme.spacingM),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Current Value",
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                        Text(
                          metric['value'],
                          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ]
              ),
            ),
            SizedBox(height: AppTheme.spacingM),
            Row(
              children: [
                Text(
                  "Change: ",
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: AppTheme.spacingS,
                    vertical: AppTheme.spacingXs,
                  ),
                  decoration: BoxDecoration(
                    color: metric['isPositive'] 
                        ? AppTheme.success.withAlpha(51)
                        : AppTheme.error.withAlpha(51),
                    borderRadius: BorderRadius.circular(AppTheme.radiusS),
                  ),
                  child: Text(
                    metric['change'],
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: metric['isPositive'] ? AppTheme.success : AppTheme.error,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: AppTheme.spacingL),
            Text(
              "View detailed analytics in the Analytics Dashboard for comprehensive insights and trends.",
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: AppTheme.secondaryText,
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              "Close",
              style: TextStyle(color: AppTheme.secondaryText),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, "/analytics-dashboard");
            },
            child: const Text("View Details"),
          ),
        ],
      ),
    );
  }
}