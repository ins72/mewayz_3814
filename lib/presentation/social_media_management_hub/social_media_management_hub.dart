import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../../core/app_export.dart';
import '../social_media_manager/widgets/analytics_cards_widget.dart';
import '../social_media_manager/widgets/content_calendar_widget.dart';
import '../social_media_manager/widgets/instagram_database_widget.dart';
import '../social_media_manager/widgets/platform_connection_widget.dart';
import '../social_media_manager/widgets/quick_actions_grid_widget.dart';
import '../social_media_manager/widgets/quick_post_modal_widget.dart';
import '../social_media_manager/widgets/recent_activity_widget.dart';

class SocialMediaManagementHub extends StatefulWidget {
  const SocialMediaManagementHub({Key? key}) : super(key: key);

  @override
  State<SocialMediaManagementHub> createState() => _SocialMediaManagementHubState();
}

class _SocialMediaManagementHubState extends State<SocialMediaManagementHub>
    with TickerProviderStateMixin {
  late TabController _tabController;
  final RefreshController _refreshController = RefreshController();
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
      builder: (context) => QuickPostModalWidget());
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
      backgroundColor: Color(0xFF101010),
      appBar: AppBar(
        backgroundColor: Color(0xFF101010),
        elevation: 0,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: CustomIconWidget(
            iconName: 'arrow_back',
            color: Color(0xFFF1F1F1),
            size: 24)),
        title: Text(
          'Social Media Hub',
          style: GoogleFonts.inter(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Color(0xFFF1F1F1))),
        actions: [
          IconButton(
            onPressed: () => Navigator.pushNamed(context, '/analytics-dashboard'),
            icon: CustomIconWidget(
              iconName: 'analytics',
              color: Color(0xFFF1F1F1),
              size: 24)),
          PopupMenuButton<String>(
            onSelected: (value) {
              switch (value) {
                case 'settings':
                  Navigator.pushNamed(context, '/settings-account-management');
                  break;
                case 'help':
                  Navigator.pushNamed(context, '/contact-us-screen');
                  break;
              }
            },
            color: Color(0xFF191919),
            icon: CustomIconWidget(
              iconName: 'more_vert',
              color: Color(0xFFF1F1F1),
              size: 24),
            itemBuilder: (context) => [
              PopupMenuItem(
                value: 'settings',
                child: Row(
                  children: [
                    CustomIconWidget(
                      iconName: 'settings',
                      color: Color(0xFFF1F1F1),
                      size: 20),
                    SizedBox(width: 12),
                    Text(
                      'Settings',
                      style: GoogleFonts.inter(
                        color: Color(0xFFF1F1F1),
                        fontSize: 14)),
                  ])),
              PopupMenuItem(
                value: 'help',
                child: Row(
                  children: [
                    CustomIconWidget(
                      iconName: 'help_outline',
                      color: Color(0xFFF1F1F1),
                      size: 20),
                    SizedBox(width: 12),
                    Text(
                      'Help',
                      style: GoogleFonts.inter(
                        color: Color(0xFFF1F1F1),
                        fontSize: 14)),
                  ])),
            ]),
        ],
        bottom: TabBar(
          controller: _tabController,
          labelColor: Color(0xFFF1F1F1),
          unselectedLabelColor: Color(0xFF666666),
          indicatorColor: Color(0xFFDDDDDD),
          isScrollable: true,
          tabs: const [
            Tab(text: 'Overview'),
            Tab(text: 'Content'),
            Tab(text: 'Leads'),
            Tab(text: 'Analytics'),
            Tab(text: 'Activity'),
          ])),
      body: SmartRefresher(
        controller: _refreshController,
        onRefresh: _refreshData,
        header: WaterDropHeader(
          complete: Icon(
            Icons.done,
            color: Color(0xFFDDDDDD)),
          waterDropColor: Color(0xFFDDDDDD)),
        child: TabBarView(
          controller: _tabController,
          children: [
            _buildOverviewTab(),
            _buildContentTab(),
            _buildLeadsTab(),
            _buildAnalyticsTab(),
            _buildActivityTab(),
          ])),
      floatingActionButton: FloatingActionButton(
        onPressed: _showQuickPostModal,
        backgroundColor: Color(0xFFDDDDDD),
        foregroundColor: Color(0xFF101010),
        child: CustomIconWidget(
          iconName: 'add',
          color: Color(0xFF101010),
          size: 24)));
  }

  Widget _buildOverviewTab() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Platform connections
          PlatformConnectionWidget(),
          
          SizedBox(height: 24),
          
          // Analytics cards
          AnalyticsCardsWidget(),
          
          SizedBox(height: 24),
          
          // Quick actions grid
          QuickActionsGridWidget(),
          
          SizedBox(height: 24),
          
          // Content calendar preview
          ContentCalendarWidget(),
        ]));
  }

  Widget _buildContentTab() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Content management section
          _buildSectionHeader('Content Management'),
          SizedBox(height: 16),
          
          // Content actions
          Row(
            children: [
              Expanded(
                child: _buildActionCard(
                  'Scheduler',
                  'Schedule posts across platforms',
                  'schedule',
                  () => Navigator.pushNamed(context, '/social-media-scheduler'))),
              SizedBox(width: 16),
              Expanded(
                child: _buildActionCard(
                  'Templates',
                  'Browse content templates',
                  'template',
                  () => Navigator.pushNamed(context, '/content-templates-screen'))),
            ]),
          
          SizedBox(height: 16),
          
          Row(
            children: [
              Expanded(
                child: _buildActionCard(
                  'Multi-Platform',
                  'Post to multiple platforms',
                  'public',
                  () => Navigator.pushNamed(context, '/multi-platform-posting-screen'))),
              SizedBox(width: 16),
              Expanded(
                child: _buildActionCard(
                  'Calendar',
                  'View content calendar',
                  'calendar_today',
                  () => Navigator.pushNamed(context, '/content-calendar-screen'))),
            ]),
          
          SizedBox(height: 32),
          
          // Content calendar widget
          ContentCalendarWidget(),
        ]));
  }

  Widget _buildLeadsTab() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Lead generation section
          _buildSectionHeader('Lead Generation'),
          SizedBox(height: 16),
          
          // Lead actions
          Row(
            children: [
              Expanded(
                child: _buildActionCard(
                  'Instagram Search',
                  'Search and filter Instagram accounts',
                  'search',
                  () => Navigator.pushNamed(context, '/instagram-lead-search'))),
              SizedBox(width: 16),
              Expanded(
                child: _buildActionCard(
                  'Hashtag Research',
                  'Research trending hashtags',
                  'tag',
                  () => Navigator.pushNamed(context, '/hashtag-research-screen'))),
            ]),
          
          SizedBox(height: 32),
          
          // Instagram database widget
          InstagramDatabaseWidget(),
        ]));
  }

  Widget _buildAnalyticsTab() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Performance tracking section
          _buildSectionHeader('Performance Tracking'),
          SizedBox(height: 16),
          
          // Analytics actions
          Row(
            children: [
              Expanded(
                child: _buildActionCard(
                  'Social Analytics',
                  'Detailed social media analytics',
                  'analytics',
                  () => Navigator.pushNamed(context, '/social-media-analytics-screen'))),
              SizedBox(width: 16),
              Expanded(
                child: _buildActionCard(
                  'Link Analytics',
                  'Link in bio performance',
                  'link',
                  () => Navigator.pushNamed(context, '/link-in-bio-analytics-screen'))),
            ]),
          
          SizedBox(height: 16),
          
          Row(
            children: [
              Expanded(
                child: _buildActionCard(
                  'QR Analytics',
                  'QR code tracking',
                  'qr_code',
                  () => Navigator.pushNamed(context, '/qr-code-generator-screen'))),
              SizedBox(width: 16),
              Expanded(
                child: _buildActionCard(
                  'Full Dashboard',
                  'Complete analytics dashboard',
                  'dashboard',
                  () => Navigator.pushNamed(context, '/analytics-dashboard'))),
            ]),
          
          SizedBox(height: 32),
          
          // Analytics preview
          AnalyticsCardsWidget(),
        ]));
  }

  Widget _buildActivityTab() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionHeader('Recent Activity'),
          SizedBox(height: 16),
          
          RecentActivityWidget(),
        ]));
  }

  Widget _buildSectionHeader(String title) {
    return Text(
      title,
      style: GoogleFonts.inter(
        fontSize: 18,
        fontWeight: FontWeight.w600,
        color: Color(0xFFF1F1F1)));
  }

  Widget _buildActionCard(String title, String description, String iconName, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Color(0xFF191919),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Color(0xFF282828))),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: Color(0xFF282828),
                borderRadius: BorderRadius.circular(8)),
              child: Center(
                child: CustomIconWidget(
                  iconName: iconName,
                  color: Color(0xFFDDDDDD),
                  size: 20))),
            SizedBox(height: 12),
            Text(
              title,
              style: GoogleFonts.inter(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Color(0xFFF1F1F1))),
            SizedBox(height: 4),
            Text(
              description,
              style: GoogleFonts.inter(
                fontSize: 12,
                color: Color(0xFF999999)),
              maxLines: 2,
              overflow: TextOverflow.ellipsis),
          ])));
  }
}