import '../../core/app_export.dart';
import '../social_media_analytics_screen/widgets/audience_insights_widget.dart';
import '../social_media_analytics_screen/widgets/engagement_chart_widget.dart';
import '../social_media_analytics_screen/widgets/metrics_overview_widget.dart';
import '../social_media_analytics_screen/widgets/platform_tabs_widget.dart';
import '../social_media_manager/widgets/analytics_cards_widget.dart';
import '../social_media_manager/widgets/content_calendar_widget.dart';
import '../social_media_manager/widgets/instagram_database_widget.dart';
import '../social_media_manager/widgets/platform_connection_widget.dart';
import '../social_media_manager/widgets/quick_actions_grid_widget.dart';
import '../social_media_manager/widgets/quick_post_modal_widget.dart';
import '../social_media_manager/widgets/recent_activity_widget.dart';
import '../social_media_scheduler/widgets/add_post_modal.dart';
import '../social_media_scheduler/widgets/bulk_upload_modal.dart';
import '../social_media_scheduler/widgets/calendar_widget.dart';
import '../social_media_scheduler/widgets/platform_status_widget.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart' as pull_to_refresh;

class SocialMediaManagementScreen extends StatefulWidget {
  const SocialMediaManagementScreen({Key? key}) : super(key: key);

  @override
  State<SocialMediaManagementScreen> createState() => _SocialMediaManagementScreenState();
}

class _SocialMediaManagementScreenState extends State<SocialMediaManagementScreen>
    with TickerProviderStateMixin {
  late TabController _tabController;
  final pull_to_refresh.RefreshController _refreshController = pull_to_refresh.RefreshController();
  bool _isLoading = false;

  // Platform connection status
  final Map<String, Map<String, dynamic>> _platforms = {
    'instagram': {
      'name': 'Instagram',
      'connected': true,
      'account': '@mewayz_official',
      'followers': 8500,
      'color': const Color(0xFFE4405F),
      'icon': 'camera_alt'
    },
    'facebook': {
      'name': 'Facebook',
      'connected': true,
      'account': 'Mewayz Business',
      'followers': 3200,
      'color': const Color(0xFF1877F2),
      'icon': 'facebook'
    },
    'twitter': {
      'name': 'Twitter',
      'connected': false,
      'account': null,
      'followers': 0,
      'color': const Color(0xFF1DA1F2),
      'icon': 'alternate_email'
    },
    'linkedin': {
      'name': 'LinkedIn',
      'connected': true,
      'account': 'Mewayz Company',
      'followers': 1800,
      'color': const Color(0xFF0A66C2),
      'icon': 'business'
    },
    'tiktok': {
      'name': 'TikTok',
      'connected': false,
      'account': null,
      'followers': 0,
      'color': const Color(0xFF000000),
      'icon': 'music_note'
    },
  };

  // Analytics data
  final Map<String, dynamic> _analyticsData = {
    'totalFollowers': 13500,
    'totalFollowersChange': 15.7,
    'engagementRate': 4.2,
    'engagementRateChange': 8.3,
    'scheduledPosts': 24,
    'scheduledPostsChange': 12.5,
    'generatedLeads': 147,
    'generatedLeadsChange': 22.1,
    'hashtagPerformance': 8.7,
    'hashtagPerformanceChange': 5.4,
  };

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 5, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _refreshController.dispose();
    super.dispose();
  }

  Future<void> _refreshData() async {
    setState(() {
      _isLoading = true;
    });

    // Simulate API call
    await Future.delayed(const Duration(seconds: 2));

    setState(() {
      _isLoading = false;
    });

    HapticFeedback.lightImpact();
    _refreshController.refreshCompleted();
  }

  void _showQuickPostModal() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const QuickPostModalWidget());
  }

  void _showAddPostModal() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => AddPostModal(onPostScheduled: (postData) {
        // Handle post scheduled
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Post scheduled successfully'),
            backgroundColor: AppTheme.success,
          ),
        );
      }));
  }

  void _showBulkUploadModal() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => BulkUploadModal(onBulkUpload: (posts) {
        // Handle bulk upload
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${posts.length} posts uploaded successfully'),
            backgroundColor: AppTheme.success,
          ),
        );
      }));
  }

  void _togglePlatformConnection(String platform) {
    setState(() {
      _platforms[platform]!['connected'] = !_platforms[platform]!['connected'];
    });
    HapticFeedback.selectionClick();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.primaryBackground,
      appBar: AppBar(
        backgroundColor: AppTheme.primaryBackground,
        elevation: 0,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: CustomIconWidget(
            iconName: 'arrow_back',
            color: AppTheme.primaryText,
            size: 24)),
        title: Text(
          'Social Media Management',
          style: GoogleFonts.inter(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: AppTheme.primaryText)),
        actions: [
          IconButton(
            onPressed: () {},
            icon: CustomIconWidget(
              iconName: 'analytics',
              color: AppTheme.primaryText,
              size: 24)),
          PopupMenuButton<String>(
            onSelected: (value) {
              switch (value) {
                case 'settings':
                  Navigator.pushNamed(context, AppRoutes.settingsScreen);
                  break;
                case 'help':
                  Navigator.pushNamed(context, AppRoutes.contactUsScreen);
                  break;
              }
            },
            color: AppTheme.surface,
            icon: CustomIconWidget(
              iconName: 'more_vert',
              color: AppTheme.primaryText,
              size: 24),
            itemBuilder: (context) => [
              PopupMenuItem(
                value: 'settings',
                child: Row(
                  children: [
                    CustomIconWidget(
                      iconName: 'settings',
                      color: AppTheme.primaryText,
                      size: 20),
                    const SizedBox(width: 12),
                    Text(
                      'Settings',
                      style: GoogleFonts.inter(
                        color: AppTheme.primaryText,
                        fontSize: 14)),
                  ])),
              PopupMenuItem(
                value: 'help',
                child: Row(
                  children: [
                    CustomIconWidget(
                      iconName: 'help_outline',
                      color: AppTheme.primaryText,
                      size: 20),
                    const SizedBox(width: 12),
                    Text(
                      'Help',
                      style: GoogleFonts.inter(
                        color: AppTheme.primaryText,
                        fontSize: 14)),
                  ])),
            ]),
        ],
        bottom: TabBar(
          controller: _tabController,
          labelColor: AppTheme.primaryText,
          unselectedLabelColor: AppTheme.secondaryText,
          indicatorColor: AppTheme.accent,
          isScrollable: true,
          tabs: const [
            Tab(text: 'Overview'),
            Tab(text: 'Scheduler'),
            Tab(text: 'Analytics'),
            Tab(text: 'Content'),
            Tab(text: 'Activity'),
          ])),
      body: RefreshIndicator(
        onRefresh: _refreshData,
        child: TabBarView(
          controller: _tabController,
          children: [
            _buildOverviewTab(),
            _buildSchedulerTab(),
            _buildAnalyticsTab(),
            _buildContentTab(),
            _buildActivityTab(),
          ])),
      floatingActionButton: FloatingActionButton(
        onPressed: _showQuickPostModal,
        backgroundColor: AppTheme.accent,
        foregroundColor: AppTheme.primaryBackground,
        child: CustomIconWidget(
          iconName: 'add',
          color: AppTheme.primaryBackground,
          size: 24)));
  }

  Widget _buildOverviewTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Platform connections
          const PlatformConnectionWidget(),
          
          const SizedBox(height: 24),
          
          // Analytics cards
          const AnalyticsCardsWidget(),
          
          const SizedBox(height: 24),
          
          // Quick actions grid
          const QuickActionsGridWidget(),
          
          const SizedBox(height: 24),
          
          // Recent activity preview
          const RecentActivityWidget(),
        ]));
  }

  Widget _buildSchedulerTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Platform status
          PlatformStatusWidget(
            platformStatus: _platforms,
            onToggleConnection: _togglePlatformConnection),
          
          const SizedBox(height: 24),
          
          // Calendar widget
          CalendarWidget(
            currentMonth: DateTime.now(),
            selectedDate: DateTime.now(),
            scheduledPosts: const <String, List<Map<String, dynamic>>>{},
            isWeekView: false,
            onDateSelected: (date) {},
            onMonthChanged: (month) {}),
          
          const SizedBox(height: 24),
          
          // Quick actions
          Row(
            children: [
              Expanded(
                child: _buildActionCard(
                  'Schedule Post',
                  'Create and schedule a new post',
                  'schedule',
                  _showAddPostModal)),
              const SizedBox(width: 16),
              Expanded(
                child: _buildActionCard(
                  'Bulk Upload',
                  'Upload multiple posts at once',
                  'upload',
                  _showBulkUploadModal)),
            ]),
        ]));
  }

  Widget _buildAnalyticsTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Metrics overview
          MetricsOverviewWidget(
            dateRange: '${DateTime.now().subtract(const Duration(days: 30)).day}/${DateTime.now().subtract(const Duration(days: 30)).month}/${DateTime.now().subtract(const Duration(days: 30)).year} - ${DateTime.now().day}/${DateTime.now().month}/${DateTime.now().year}',
            selectedPlatforms: _platforms.keys.toList()),
          
          const SizedBox(height: 24),
          
          // Platform tabs
          PlatformTabsWidget(
            selectedPlatforms: _platforms.keys.toList(),
            activePlatform: 'instagram',
            onPlatformSelected: (platform) {}),
          
          const SizedBox(height: 24),
          
          // Engagement chart
          EngagementChartWidget(
            dateRange: '${DateTime.now().subtract(const Duration(days: 30)).day}/${DateTime.now().subtract(const Duration(days: 30)).month}/${DateTime.now().subtract(const Duration(days: 30)).year} - ${DateTime.now().day}/${DateTime.now().month}/${DateTime.now().year}',
            selectedPlatforms: _platforms.keys.toList()),
          
          const SizedBox(height: 24),
          
          // Audience insights
          AudienceInsightsWidget(
            dateRange: '${DateTime.now().subtract(const Duration(days: 30)).day}/${DateTime.now().subtract(const Duration(days: 30)).month}/${DateTime.now().subtract(const Duration(days: 30)).year} - ${DateTime.now().day}/${DateTime.now().month}/${DateTime.now().year}',
            selectedPlatforms: _platforms.keys.toList()),
        ]));
  }

  Widget _buildContentTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Content management section
          _buildSectionHeader('Content Management'),
          const SizedBox(height: 16),
          
          // Content actions
          Row(
            children: [
              Expanded(
                child: _buildActionCard(
                  'Templates',
                  'Browse content templates',
                  'template',
                  () => Navigator.pushNamed(context, AppRoutes.contentTemplatesScreen))),
              const SizedBox(width: 16),
              Expanded(
                child: _buildActionCard(
                  'Multi-Platform',
                  'Post to multiple platforms',
                  'public',
                  () => Navigator.pushNamed(context, AppRoutes.multiPlatformPostingScreen))),
            ]),
          
          const SizedBox(height: 16),
          
          Row(
            children: [
              Expanded(
                child: _buildActionCard(
                  'Calendar',
                  'View content calendar',
                  'calendar_today',
                  () => Navigator.pushNamed(context, AppRoutes.contentCalendarScreen))),
              const SizedBox(width: 16),
              Expanded(
                child: _buildActionCard(
                  'Hashtags',
                  'Research hashtags',
                  'tag',
                  () => Navigator.pushNamed(context, AppRoutes.hashtagResearchScreen))),
            ]),
          
          const SizedBox(height: 32),
          
          // Content calendar widget
          const ContentCalendarWidget(),
        ]));
  }

  Widget _buildActivityTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionHeader('Recent Activity'),
          const SizedBox(height: 16),
          
          const RecentActivityWidget(),
          
          const SizedBox(height: 24),
          
          // Instagram database
          const InstagramDatabaseWidget(),
        ]));
  }

  Widget _buildSectionHeader(String title) {
    return Text(
      title,
      style: GoogleFonts.inter(
        fontSize: 18,
        fontWeight: FontWeight.w600,
        color: AppTheme.primaryText));
  }

  Widget _buildActionCard(String title, String description, String iconName, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppTheme.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppTheme.border)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: AppTheme.border,
                borderRadius: BorderRadius.circular(8)),
              child: Center(
                child: CustomIconWidget(
                  iconName: iconName,
                  color: AppTheme.accent,
                  size: 20))),
            const SizedBox(height: 12),
            Text(
              title,
              style: GoogleFonts.inter(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: AppTheme.primaryText)),
            const SizedBox(height: 4),
            Text(
              description,
              style: GoogleFonts.inter(
                fontSize: 12,
                color: AppTheme.secondaryText),
              maxLines: 2,
              overflow: TextOverflow.ellipsis),
          ])));
  }
}