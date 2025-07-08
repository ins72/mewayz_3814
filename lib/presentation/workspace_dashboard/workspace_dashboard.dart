import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
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

  final List<Map<String, dynamic>> workspaces = [
    {"id": 1, "name": "Digital Marketing Agency", "isActive": true},
    {"id": 2, "name": "E-commerce Store", "isActive": false},
    {"id": 3, "name": "Course Creator Hub", "isActive": false},
    {"id": 4, "name": "Freelance Business", "isActive": false},
  ];

  final List<Map<String, dynamic>> metricsData = [
    {
      "title": "Total Leads",
      "value": "2,847",
      "change": "+12.5%",
      "isPositive": true,
      "icon": "people",
      "color": AppTheme.accent,
    },
    {
      "title": "Revenue",
      "value": "\$45,230",
      "change": "+8.2%",
      "isPositive": true,
      "icon": "attach_money",
      "color": AppTheme.success,
    },
    {
      "title": "Social Followers",
      "value": "18.5K",
      "change": "+15.7%",
      "isPositive": true,
      "icon": "favorite",
      "color": AppTheme.warning,
    },
    {
      "title": "Course Enrollments",
      "value": "1,234",
      "change": "-2.1%",
      "isPositive": false,
      "icon": "school",
      "color": AppTheme.accent,
    },
  ];

  final List<Map<String, dynamic>> quickActions = [
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

  final List<Map<String, dynamic>> recentActivities = [
    {
      "title": "New lead from Instagram campaign",
      "subtitle": "Sarah Johnson - Digital Marketing",
      "timestamp": "2 minutes ago",
      "icon": "person_add",
      "color": AppTheme.success,
    },
    {
      "title": "Course enrollment completed",
      "subtitle": "Advanced Social Media Marketing",
      "timestamp": "15 minutes ago",
      "icon": "school",
      "color": AppTheme.accent,
    },
    {
      "title": "Product sold on marketplace",
      "subtitle": "Social Media Template Pack - \$29.99",
      "timestamp": "1 hour ago",
      "icon": "shopping_cart",
      "color": AppTheme.warning,
    },
    {
      "title": "Scheduled post published",
      "subtitle": "Instagram - Marketing Tips #5",
      "timestamp": "2 hours ago",
      "icon": "publish",
      "color": AppTheme.accent,
    },
    {
      "title": "New contact added to CRM",
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
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _handleRefresh() async {
    setState(() {
      isRefreshing = true;
    });

    // Simulate API call
    await Future.delayed(const Duration(seconds: 2));

    setState(() {
      isRefreshing = false;
    });
  }

  void _showWorkspaceSelector() {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppTheme.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: EdgeInsets.all(4.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 10.w,
                height: 0.5.h,
                decoration: BoxDecoration(
                  color: AppTheme.border,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            SizedBox(height: 2.h),
            Text(
              "Switch Workspace",
              style: AppTheme.darkTheme.textTheme.titleLarge,
            ),
            SizedBox(height: 2.h),
            ...workspaces.map((workspace) => ListTile(
                  leading: CircleAvatar(
                    backgroundColor: workspace["isActive"]
                        ? AppTheme.accent
                        : AppTheme.border,
                    radius: 2.h,
                    child: CustomIconWidget(
                      iconName: workspace["isActive"] ? 'check' : 'business',
                      color: workspace["isActive"]
                          ? AppTheme.primaryAction
                          : AppTheme.secondaryText,
                      size: 20,
                    ),
                  ),
                  title: Text(
                    workspace["name"],
                    style: AppTheme.darkTheme.textTheme.bodyLarge,
                  ),
                  trailing: workspace["isActive"]
                      ? CustomIconWidget(
                          iconName: 'check_circle',
                          color: AppTheme.accent,
                          size: 24,
                        )
                      : null,
                  onTap: () {
                    setState(() {
                      selectedWorkspace = workspace["name"];
                    });
                    Navigator.pop(context);
                  },
                )),
            SizedBox(height: 2.h),
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
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: EdgeInsets.all(4.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 10.w,
                height: 0.5.h,
                decoration: BoxDecoration(
                  color: AppTheme.border,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            SizedBox(height: 2.h),
            Text(
              "Quick Create",
              style: AppTheme.darkTheme.textTheme.titleLarge,
            ),
            SizedBox(height: 2.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildQuickCreateItem(
                    "Post", "edit", "/social-media-scheduler"),
                _buildQuickCreateItem(
                    "Product", "add_shopping_cart", "/marketplace-store"),
                _buildQuickCreateItem(
                    "Course", "play_circle_filled", "/course-creator"),
                _buildQuickCreateItem(
                    "Contact", "person_add", "/crm-contact-management"),
              ],
            ),
            SizedBox(height: 2.h),
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
        children: [
          Container(
            width: 15.w,
            height: 15.w,
            decoration: BoxDecoration(
              color: AppTheme.accent.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Center(
              child: CustomIconWidget(
                iconName: icon,
                color: AppTheme.accent,
                size: 24,
              ),
            ),
          ),
          SizedBox(height: 1.h),
          Text(
            title,
            style: AppTheme.darkTheme.textTheme.bodySmall,
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.primaryBackground,
      appBar: AppBar(
        backgroundColor: AppTheme.primaryBackground,
        elevation: 0,
        title: GestureDetector(
          onTap: _showWorkspaceSelector,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Flexible(
                child: Text(
                  selectedWorkspace,
                  style: AppTheme.darkTheme.textTheme.titleMedium,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              SizedBox(width: 2.w),
              CustomIconWidget(
                iconName: 'keyboard_arrow_down',
                color: AppTheme.primaryText,
                size: 20,
              ),
            ],
          ),
        ),
        actions: [
          IconButton(
            onPressed: () =>
                Navigator.pushNamed(context, '/analytics-dashboard'),
            icon: CustomIconWidget(
              iconName: 'analytics',
              color: AppTheme.primaryText,
              size: 24,
            ),
          ),
          IconButton(
            onPressed: () {},
            icon: CustomIconWidget(
              iconName: 'notifications',
              color: AppTheme.primaryText,
              size: 24,
            ),
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: AppTheme.accent,
          labelColor: AppTheme.primaryText,
          unselectedLabelColor: AppTheme.secondaryText,
          tabs: const [
            Tab(text: "Dashboard"),
            Tab(text: "Social"),
            Tab(text: "CRM"),
            Tab(text: "Store"),
            Tab(text: "More"),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildDashboardTab(),
          _buildPlaceholderTab("Social"),
          _buildPlaceholderTab("CRM"),
          _buildPlaceholderTab("Store"),
          _buildPlaceholderTab("More"),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showQuickCreateMenu,
        backgroundColor: AppTheme.primaryAction,
        child: CustomIconWidget(
          iconName: 'add',
          color: AppTheme.primaryBackground,
          size: 24,
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
        padding: EdgeInsets.all(4.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Metrics Cards
            SizedBox(
              height: 20.h,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: metricsData.length,
                separatorBuilder: (context, index) => SizedBox(width: 4.w),
                itemBuilder: (context, index) {
                  return MetricsCardWidget(
                    data: metricsData[index],
                    onLongPress: () => _showMetricsDetail(metricsData[index]),
                  );
                },
              ),
            ),

            SizedBox(height: 4.h),

            // Quick Actions
            Text(
              "Quick Actions",
              style: AppTheme.darkTheme.textTheme.titleLarge,
            ),
            SizedBox(height: 2.h),

            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 4.w,
                mainAxisSpacing: 2.h,
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

            SizedBox(height: 4.h),

            // Recent Activity
            Text(
              "Recent Activity",
              style: AppTheme.darkTheme.textTheme.titleLarge,
            ),
            SizedBox(height: 2.h),

            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: recentActivities.length,
              separatorBuilder: (context, index) => SizedBox(height: 1.h),
              itemBuilder: (context, index) {
                return ActivityItemWidget(
                  data: recentActivities[index],
                );
              },
            ),

            SizedBox(height: 10.h), // Bottom padding for FAB
          ],
        ),
      ),
    );
  }

  Widget _buildPlaceholderTab(String tabName) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CustomIconWidget(
            iconName: 'construction',
            color: AppTheme.secondaryText,
            size: 48,
          ),
          SizedBox(height: 2.h),
          Text(
            "$tabName Coming Soon",
            style: AppTheme.darkTheme.textTheme.titleMedium?.copyWith(
              color: AppTheme.secondaryText,
            ),
          ),
        ],
      ),
    );
  }

  void _showMetricsDetail(Map<String, dynamic> metric) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppTheme.surface,
        title: Text(
          "${metric['title']} Analytics",
          style: AppTheme.darkTheme.textTheme.titleLarge,
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Current Value: ${metric['value']}",
              style: AppTheme.darkTheme.textTheme.bodyLarge,
            ),
            SizedBox(height: 1.h),
            Text(
              "Change: ${metric['change']}",
              style: AppTheme.darkTheme.textTheme.bodyMedium?.copyWith(
                color: metric['isPositive'] ? AppTheme.success : AppTheme.error,
              ),
            ),
            SizedBox(height: 2.h),
            Text(
              "Detailed analytics available in the Analytics Dashboard.",
              style: AppTheme.darkTheme.textTheme.bodySmall,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              "Close",
              style: TextStyle(color: AppTheme.accent),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, '/analytics-dashboard');
            },
            child: const Text("View Details"),
          ),
        ],
      ),
    );
  }
}
