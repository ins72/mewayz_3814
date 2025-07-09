import '../../core/app_export.dart';
import '../../widgets/custom_bottom_navigation_widget.dart' as CustomBottomNav;
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
  String selectedWorkspace = "My Workspace";
  bool isRefreshing = false;
  int _currentBottomNavIndex = 0;
  bool _isLoading = false;

  final DataService _dataService = DataService();
  final StorageService _storageService = StorageService();

  final List<Map<String, dynamic>> workspaces = [];

  List<Map<String, dynamic>> metricsData = [
    {
      "title": "Total Leads",
      "value": "0",
      "change": "0%",
      "isPositive": true,
      "icon": "people",
      "color": AppTheme.accent,
    },
    {
      "title": "Revenue",
      "value": "\$0",
      "change": "0%",
      "isPositive": true,
      "icon": "attach_money",
      "color": AppTheme.success,
    },
    {
      "title": "Social Followers",
      "value": "0",
      "change": "0%",
      "isPositive": true,
      "icon": "favorite",
      "color": AppTheme.warning,
    },
    {
      "title": "Course Enrollments",
      "value": "0",
      "change": "0%",
      "isPositive": true,
      "icon": "school",
      "color": AppTheme.accent,
    },
  ];

  List<Map<String, dynamic>> quickActions = [];

  List<Map<String, dynamic>> recentActivities = [];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 5, vsync: this);
    _loadDashboardData();
  }

  Future<void> _loadDashboardData() async {
    setState(() {
      _isLoading = true;
    });

    try {
      // Load analytics data
      final analyticsData = await _dataService.getAnalyticsData();
      
      // Load social media stats
      final socialMediaStats = await _dataService.getSocialMediaStats();
      
      // Update metrics data with real data (will be 0 for new users)
      if (analyticsData.isNotEmpty) {
        _updateMetricsData(analyticsData, socialMediaStats);
      }
      
      // Load recent activities (will be empty for new users)
      await _loadRecentActivities();
      
      // Load workspace-specific quick actions
      _loadWorkspaceQuickActions();
      
    } catch (e) {
      ErrorHandler.handleError(e.toString());
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _updateMetricsData(Map<String, dynamic> analyticsData, Map<String, dynamic> socialMediaStats) {
    setState(() {
      metricsData[0]['value'] = "${analyticsData['totalUsers'] ?? 0}";
      metricsData[1]['value'] = "\$${analyticsData['totalRevenue'] ?? 0}";
      metricsData[2]['value'] = "${socialMediaStats['totalFollowers'] ?? 0}";
      metricsData[3]['value'] = "${analyticsData['totalUsers'] ?? 0}";
      
      // Update change values (will be 0% for new users)
      metricsData[0]['change'] = "0%";
      metricsData[1]['change'] = "0%";
      metricsData[2]['change'] = "0%";
      metricsData[3]['change'] = "0%";
    });
  }

  Future<void> _loadRecentActivities() async {
    try {
      // Load recent posts (will be empty for new users)
      final posts = await _dataService.getSocialMediaPosts();
      
      // Load recent contacts (will be empty for new users)
      final contacts = await _dataService.getContacts();
      
      // Update recent activities with real data
      _updateRecentActivities(posts, contacts);
    } catch (e) {
      ErrorHandler.handleError(e.toString());
    }
  }

  void _updateRecentActivities(List<Map<String, dynamic>> posts, List<Map<String, dynamic>> contacts) {
    setState(() {
      recentActivities.clear();
      
      // Add recent posts (will be empty for new users)
      for (var post in posts.take(3)) {
        recentActivities.add({
          "title": "Post published: ${post['title']}",
          "subtitle": "Platform: ${post['platform']}",
          "timestamp": _getTimeAgo(post['publishedAt'] ?? DateTime.now().toIso8601String()),
          "icon": "publish",
          "color": AppTheme.accent,
        });
      }
      
      // Add recent contacts (will be empty for new users)
      for (var contact in contacts.take(2)) {
        recentActivities.add({
          "title": "New contact: ${contact['name']}",
          "subtitle": "${contact['company']} - ${contact['status']}",
          "timestamp": _getTimeAgo(contact['createdAt'] ?? DateTime.now().toIso8601String()),
          "icon": "person_add",
          "color": AppTheme.success,
        });
      }
    });
  }

  void _loadWorkspaceQuickActions() {
    // Load default quick actions (these are features, not sample data)
    setState(() {
      quickActions = [
        {
          "title": "Instagram Search",
          "subtitle": "Find leads",
          "icon": "search",
          "route": "/instagram-lead-search",
          "color": AppTheme.accent,
        },
        {
          "title": "Post Scheduler",
          "subtitle": "Schedule posts",
          "icon": "schedule",
          "route": "/social-media-scheduler",
          "color": AppTheme.success,
        },
        {
          "title": "Link in Bio",
          "subtitle": "Build pages",
          "icon": "link",
          "route": "/link-in-bio-builder",
          "color": AppTheme.warning,
        },
        {
          "title": "Course Creator",
          "subtitle": "Create courses",
          "icon": "play_circle_filled",
          "route": "/course-creator",
          "color": AppTheme.accent,
        },
        {
          "title": "Marketplace",
          "subtitle": "Manage store",
          "icon": "store",
          "route": "/marketplace-store",
          "color": AppTheme.success,
        },
        {
          "title": "CRM",
          "subtitle": "Manage contacts",
          "icon": "contacts",
          "route": "/crm-contact-management",
          "color": AppTheme.warning,
        },
      ];
    });
  }

  String _getTimeAgo(String dateString) {
    try {
      final date = DateTime.parse(dateString);
      final now = DateTime.now();
      final difference = now.difference(date);
      
      if (difference.inDays > 0) {
        return '${difference.inDays} days ago';
      } else if (difference.inHours > 0) {
        return '${difference.inHours} hours ago';
      } else if (difference.inMinutes > 0) {
        return '${difference.inMinutes} minutes ago';
      } else {
        return 'Just now';
      }
    } catch (e) {
      return 'Recently';
    }
  }

  Future<void> _handleRefresh() async {
    await ButtonService.handleButtonPress('refreshButton', () async {
      await _loadDashboardData();
    });
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
                  borderRadius: BorderRadius.circular(2)))),
            SizedBox(height: AppTheme.spacingL),
            
            Text(
              "Switch Workspace",
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w600)),
            SizedBox(height: AppTheme.spacingL),
            
            if (workspaces.isNotEmpty)
              ...workspaces.map((workspace) => Container(
                margin: const EdgeInsets.only(bottom: AppTheme.spacingM),
                child: ListTile(
                  title: Text(workspace['name']),
                  trailing: workspace['isActive'] ? Icon(Icons.check, color: AppTheme.accent) : null,
                  onTap: () async {
                    Navigator.pop(context);
                    await _switchWorkspace(workspace);
                  }))).toList()
            else
              Center(
                child: Text(
                  'No workspaces found',
                  style: Theme.of(context).textTheme.bodyMedium)),
            
            SizedBox(height: AppTheme.spacingL),
            
            // Create New Workspace Button
            CustomEnhancedButtonWidget(
              buttonId: 'createWorkspaceButton',
              onPressed: () async {
                Navigator.pop(context);
                await ButtonService.navigateTo(
                  context: context,
                  route: AppRoutes.workspaceCreationScreen,
                  showFeedback: true,
                  feedbackMessage: 'Opening workspace creation...');
              },
              buttonType: ButtonType.outlined,
              child: Text('Create New Workspace')),
          ])));
  }

  Future<void> _switchWorkspace(Map<String, dynamic> workspace) async {
    await ButtonService.handleButtonPress('switchWorkspace', () async {
      setState(() {
        selectedWorkspace = workspace['name'];
        // Update all workspace items active state
        for (var ws in workspaces) {
          ws['isActive'] = ws['id'] == workspace['id'];
        }
      });
      await _loadDashboardData();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Switched to ${workspace['name']}')));
    });
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
                  borderRadius: BorderRadius.circular(2)))),
            SizedBox(height: AppTheme.spacingL),
            
            Text(
              "Quick Create",
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w600)),
            SizedBox(height: AppTheme.spacingL),
            
            GridView.count(
              shrinkWrap: true,
              crossAxisCount: 4,
              crossAxisSpacing: AppTheme.spacingM,
              mainAxisSpacing: AppTheme.spacingM,
              children: [
                _buildQuickCreateItem(
                    "Post", "edit", ""),
                _buildQuickCreateItem(
                    "Product", "add_shopping_cart", ""),
                _buildQuickCreateItem(
                    "Course", "play_circle_filled", ""),
                _buildQuickCreateItem(
                    "Contact", "person_add", ""),
                _buildQuickCreateItem(
                    "Link Page", "link", ""),
                _buildQuickCreateItem(
                    "QR Code", "qr_code", ""),
                _buildQuickCreateItem(
                    "Email", "email", ""),
                _buildQuickCreateItem(
                    "Template", "description", ""),
              ]),
            SizedBox(height: AppTheme.spacingL),
          ])));
  }

  Widget _buildQuickCreateItem(String title, String icon, String route) {
    return ButtonService.createEnhancedGestureDetector(
      buttonId: 'quickCreate_$title',
      onTap: () async {
        Navigator.pop(context);
        // Remove reference to linkInBioBuilder route
        if (route == "") {
          await ButtonService.handleNavigation(
            context: context,
            route: "",
            showFeedback: true,
            feedbackMessage: 'Opening $title creation...');
        } else {
          await ButtonService.handleNavigation(
            context: context,
            route: route,
            showFeedback: true,
            feedbackMessage: 'Opening $title creation...');
        }
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
                ]),
              borderRadius: BorderRadius.circular(AppTheme.radiusM),
              border: Border.all(
                color: AppTheme.accent.withAlpha(77),
                width: 1)),
            child: Center(
              child: CustomIconWidget(
                iconName: icon,
                color: AppTheme.accent,
                size: AppTheme.iconSizeL))),
          SizedBox(height: AppTheme.spacingS),
          Text(
            title,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              fontWeight: FontWeight.w500),
            textAlign: TextAlign.center),
        ]));
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
                    fontWeight: FontWeight.w600),
                  overflow: TextOverflow.ellipsis)),
              SizedBox(width: AppTheme.spacingS),
              CustomIconWidget(
                iconName: 'keyboard_arrow_down',
                color: AppTheme.primaryText,
                size: AppTheme.iconSizeM),
            ])),
        actions: [
          IconButton(
            onPressed: () async {
              await ButtonService.navigateTo(
                context: context,
                route: "",
                showFeedback: true,
                feedbackMessage: 'Opening analytics...');
            },
            icon: CustomIconWidget(
              iconName: 'analytics',
              color: AppTheme.primaryText,
              size: AppTheme.iconSizeL)),
          IconButton(
            onPressed: () async {
              await ButtonService.navigateTo(
                context: context,
                route: "",
                showFeedback: true,
                feedbackMessage: 'Opening notifications...');
            },
            icon: CustomIconWidget(
              iconName: 'notifications',
              color: AppTheme.primaryText,
              size: AppTheme.iconSizeL)),
          SizedBox(width: AppTheme.spacingS),
        ]),
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
              ]),
      bottomNavigationBar: CustomBottomNav.CustomBottomNavigationWidget(
        currentIndex: _currentBottomNavIndex,
        onTap: _onBottomNavTap,
        items: [
          CustomBottomNav.BottomNavigationItem(
            iconName: 'dashboard',
            label: 'Dashboard'),
          CustomBottomNav.BottomNavigationItem(
            iconName: 'favorite',
            label: 'Social'),
          CustomBottomNav.BottomNavigationItem(
            iconName: 'contacts',
            label: 'CRM'),
          CustomBottomNav.BottomNavigationItem(
            iconName: 'store',
            label: 'Store'),
          CustomBottomNav.BottomNavigationItem(
            iconName: 'more_horiz',
            label: 'More'),
        ]),
      floatingActionButton: ButtonService.createEnhancedFloatingActionButton(
        buttonId: 'quickCreateFAB',
        onPressed: _showQuickCreateMenu,
        backgroundColor: AppTheme.accent,
        child: CustomIconWidget(
          iconName: 'add',
          color: AppTheme.primaryAction,
          size: AppTheme.iconSizeL)));
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
                    onLongPress: () => _showMetricsDetail(metricsData[index]));
                })),

            SizedBox(height: AppTheme.spacingXl),

            // Quick Actions Section
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Quick Actions",
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w600)),
                TextButton(
                  onPressed: () => _showQuickCreateMenu(),
                  child: Text(
                    "View All",
                    style: TextStyle(
                      color: AppTheme.accent,
                      fontWeight: FontWeight.w600))),
              ]),
            SizedBox(height: AppTheme.spacingM),

            if (quickActions.isNotEmpty)
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: AppTheme.spacingM,
                  mainAxisSpacing: AppTheme.spacingM,
                  childAspectRatio: 1.2),
                itemCount: quickActions.length > 4 ? 4 : quickActions.length,
                itemBuilder: (context, index) {
                  return QuickActionWidget(
                    data: quickActions[index],
                    onTap: () async {
                      await ButtonService.handleNavigation(
                        context: context,
                        route: quickActions[index]["route"],
                        showFeedback: true,
                        feedbackMessage: 'Opening ${quickActions[index]["title"]}...');
                    });
                })
            else
              // Show empty state for quick actions
              Container(
                padding: EdgeInsets.all(AppTheme.spacingL),
                decoration: AppTheme.cardDecoration(),
                child: Column(
                  children: [
                    CustomIconWidget(
                      iconName: 'apps',
                      color: AppTheme.secondaryText,
                      size: 48),
                    SizedBox(height: AppTheme.spacingM),
                    Text(
                      'No quick actions available',
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: AppTheme.secondaryText)),
                    SizedBox(height: AppTheme.spacingS),
                    Text(
                      'Start by creating your first workspace',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: AppTheme.secondaryText)),
                  ])),

            SizedBox(height: AppTheme.spacingXl),

            // Recent Activity Section
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Recent Activity",
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w600)),
                TextButton(
                  onPressed: () async {
                    await ButtonService.handleNavigation(
                      context: context,
                      route: "",
                      showFeedback: true,
                      feedbackMessage: 'Opening activity log...');
                  },
                  child: Text(
                    "View All",
                    style: TextStyle(
                      color: AppTheme.accent,
                      fontWeight: FontWeight.w600))),
              ]),
            SizedBox(height: AppTheme.spacingM),

            if (recentActivities.isNotEmpty)
              ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: recentActivities.length,
                separatorBuilder: (context, index) => SizedBox(height: AppTheme.spacingM),
                itemBuilder: (context, index) {
                  return ActivityItemWidget(
                    data: recentActivities[index]);
                })
            else
              // Show empty state for recent activities
              Container(
                padding: EdgeInsets.all(AppTheme.spacingL),
                decoration: AppTheme.cardDecoration(),
                child: Column(
                  children: [
                    CustomIconWidget(
                      iconName: 'timeline',
                      color: AppTheme.secondaryText,
                      size: 48),
                    SizedBox(height: AppTheme.spacingM),
                    Text(
                      'No recent activity',
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: AppTheme.secondaryText)),
                    SizedBox(height: AppTheme.spacingS),
                    Text(
                      'Start using the app to see your activity here',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: AppTheme.secondaryText)),
                  ])),

            SizedBox(height: 120), // Bottom padding for FAB
          ])));
  }

  Widget _buildSocialTab() {
    return Navigator(
      onGenerateRoute: (settings) {
        return MaterialPageRoute(
          builder: (context) => const SocialMediaManager());
      });
  }

  Widget _buildCRMTab() {
    return Navigator(
      onGenerateRoute: (settings) {
        return MaterialPageRoute(
          builder: (context) => const CrmContactManagement());
      });
  }

  Widget _buildStoreTab() {
    return Navigator(
      onGenerateRoute: (settings) {
        return MaterialPageRoute(
          builder: (context) => const MarketplaceStore());
      });
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
              fontWeight: FontWeight.w600)),
          SizedBox(height: AppTheme.spacingL),
          
          // Quick Access Grid
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: AppTheme.spacingM,
              mainAxisSpacing: AppTheme.spacingM,
              childAspectRatio: 1.2),
            itemCount: quickActions.length,
            itemBuilder: (context, index) {
              return QuickActionWidget(
                data: quickActions[index],
                onTap: () async {
                  await ButtonService.handleNavigation(
                    context: context,
                    route: quickActions[index]["route"],
                    showFeedback: true,
                    feedbackMessage: 'Opening ${quickActions[index]["title"]}...');
                });
            }),
          
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
                    fontWeight: FontWeight.w600)),
                SizedBox(height: AppTheme.spacingM),
                
                _buildActionTile(
                  icon: Icons.settings,
                  title: 'Settings',
                  onTap: () async {
                    await ButtonService.handleNavigation(
                      context: context,
                      route: "",
                      showFeedback: true,
                      feedbackMessage: 'Opening settings...');
                  }),
                
                _buildActionTile(
                  icon: Icons.analytics,
                  title: 'Analytics Dashboard',
                  onTap: () async {
                    await ButtonService.handleNavigation(
                      context: context,
                      route: AppRoutes.analyticsDashboard,
                      showFeedback: true,
                      feedbackMessage: 'Opening analytics...');
                  }),
                
                _buildActionTile(
                  icon: Icons.people,
                  title: 'Team Management',
                  onTap: () async {
                    await ButtonService.handleNavigation(
                      context: context,
                      route: "",
                      showFeedback: true,
                      feedbackMessage: 'Opening team management...');
                  }),
                
                _buildActionTile(
                  icon: Icons.help,
                  title: 'Contact Support',
                  onTap: () async {
                    await ButtonService.handleNavigation(
                      context: context,
                      route: "",
                      showFeedback: true,
                      feedbackMessage: 'Opening support...');
                  }),
              ])),
        ]));
  }

  Widget _buildActionTile({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return ButtonService.createEnhancedInkWell(
      buttonId: 'actionTile_$title',
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppTheme.radiusM),
      child: ListTile(
        leading: CustomIconWidget(
          iconName: icon.toString().split('.').last,
          color: AppTheme.accent,
          size: AppTheme.iconSizeL),
        title: Text(
          title,
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
            fontWeight: FontWeight.w500)),
        trailing: Icon(
          Icons.arrow_forward_ios,
          color: AppTheme.secondaryText,
          size: AppTheme.iconSizeS),
        contentPadding: EdgeInsets.zero));
  }

  void _showMetricsDetail(Map<String, dynamic> metric) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppTheme.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppTheme.radiusL)),
        title: Text(
          "${metric['title']} Analytics",
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w600)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: EdgeInsets.all(AppTheme.spacingM),
              decoration: BoxDecoration(
                color: (metric['color'] as Color).withAlpha(26),
                borderRadius: BorderRadius.circular(AppTheme.radiusM)),
              child: Row(
                children: [
                  CustomIconWidget(
                    iconName: metric['icon'] ?? 'analytics',
                    color: metric['color'] ?? AppTheme.accent,
                    size: AppTheme.iconSizeL),
                  SizedBox(width: AppTheme.spacingM),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Current Value",
                          style: Theme.of(context).textTheme.bodySmall),
                        Text(
                          metric['value'],
                          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                            fontWeight: FontWeight.w600)),
                      ])),
                ]
              )),
            SizedBox(height: AppTheme.spacingM),
            Row(
              children: [
                Text(
                  "Change: ",
                  style: Theme.of(context).textTheme.bodyMedium),
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: AppTheme.spacingS,
                    vertical: AppTheme.spacingXs),
                  decoration: BoxDecoration(
                    color: metric['isPositive'] 
                        ? AppTheme.success.withAlpha(51)
                        : AppTheme.error.withAlpha(51),
                    borderRadius: BorderRadius.circular(AppTheme.radiusS)),
                  child: Text(
                    metric['change'],
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: metric['isPositive'] ? AppTheme.success : AppTheme.error,
                      fontWeight: FontWeight.w600))),
              ]),
            SizedBox(height: AppTheme.spacingL),
            Text(
              "View detailed analytics in the Analytics Dashboard for comprehensive insights and trends.",
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: AppTheme.secondaryText)),
          ]),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              "Close",
              style: TextStyle(color: AppTheme.secondaryText))),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(context);
              await ButtonService.handleNavigation(
                context: context,
                route: "",
                showFeedback: true,
                feedbackMessage: 'Opening analytics dashboard...');
            },
            child: const Text("View Details")),
        ]));
  }
}