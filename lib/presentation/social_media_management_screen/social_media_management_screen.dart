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

class SocialMediaManagementScreen extends StatefulWidget {
  const SocialMediaManagementScreen({Key? key}) : super(key: key);

  @override
  State<SocialMediaManagementScreen> createState() => _SocialMediaManagementScreenState();
}

class _SocialMediaManagementScreenState extends State<SocialMediaManagementScreen>
    with TickerProviderStateMixin {
  late TabController _tabController;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  
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
    'youtube': {
      'name': 'YouTube',
      'connected': true,
      'account': 'Mewayz Channel',
      'followers': 2100,
      'color': const Color(0xFFFF0000),
      'icon': 'play_circle_filled'
    },
  };

  // Analytics data
  final Map<String, dynamic> _analyticsData = {
    'totalFollowers': 15600,
    'totalFollowersChange': 18.2,
    'engagementRate': 4.8,
    'engagementRateChange': 12.7,
    'scheduledPosts': 32,
    'scheduledPostsChange': 15.3,
    'generatedLeads': 189,
    'generatedLeadsChange': 28.4,
    'hashtagPerformance': 9.2,
    'hashtagPerformanceChange': 7.1,
    'contentReach': 45200,
    'contentReachChange': 22.8,
  };

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 5, vsync: this);
    _setupAnimations();
  }

  void _setupAnimations() {
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: const Interval(0.0, 0.6, curve: Curves.easeOut),
    ));

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.1),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: const Interval(0.2, 1.0, curve: Curves.easeOutCubic),
    ));

    _animationController.forward();
  }

  @override
  void dispose() {
    _tabController.dispose();
    _animationController.dispose();
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
  }

  void _showQuickPostModal() {
    HapticFeedback.lightImpact();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const QuickPostModalWidget(),
    );
  }

  void _showAddPostModal() {
    HapticFeedback.lightImpact();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => AddPostModal(onPostScheduled: (postData) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                Container(
                  width: 24,
                  height: 24,
                  decoration: BoxDecoration(
                    color: AppTheme.success,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.check,
                    color: Colors.white,
                    size: 16,
                  ),
                ),
                const SizedBox(width: 12),
                const Text('Post scheduled successfully'),
              ],
            ),
            backgroundColor: AppTheme.surface,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }),
    );
  }

  void _showBulkUploadModal() {
    HapticFeedback.lightImpact();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => BulkUploadModal(onBulkUpload: (posts) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                Container(
                  width: 24,
                  height: 24,
                  decoration: BoxDecoration(
                    color: AppTheme.success,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.check,
                    color: Colors.white,
                    size: 16,
                  ),
                ),
                const SizedBox(width: 12),
                Text('${posts.length} posts uploaded successfully'),
              ],
            ),
            backgroundColor: AppTheme.surface,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }),
    );
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
      body: CustomScrollView(
        slivers: [
          _buildSliverAppBar(),
          SliverFillRemaining(
            child: RefreshIndicator(
              onRefresh: _refreshData,
              color: AppTheme.accent,
              backgroundColor: AppTheme.surface,
              child: AnimatedBuilder(
                animation: _animationController,
                builder: (context, child) {
                  return FadeTransition(
                    opacity: _fadeAnimation,
                    child: SlideTransition(
                      position: _slideAnimation,
                      child: TabBarView(
                        controller: _tabController,
                        children: [
                          _buildOverviewTab(),
                          _buildSchedulerTab(),
                          _buildAnalyticsTab(),
                          _buildContentTab(),
                          _buildActivityTab(),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: _buildFloatingActionButton(),
    );
  }

  Widget _buildSliverAppBar() {
    return SliverAppBar(
      expandedHeight: 160,
      floating: false,
      pinned: true,
      backgroundColor: AppTheme.primaryBackground,
      elevation: 0,
      leading: Container(
        margin: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: AppTheme.surface,
          borderRadius: BorderRadius.circular(12),
        ),
        child: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back_ios, color: AppTheme.primaryText),
        ),
      ),
      actions: [
        Container(
          margin: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: AppTheme.surface,
            borderRadius: BorderRadius.circular(12),
          ),
          child: IconButton(
            onPressed: () => Navigator.pushNamed(context, AppRoutes.analyticsScreen),
            icon: const Icon(Icons.analytics, color: AppTheme.primaryText),
          ),
        ),
        Container(
          margin: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: AppTheme.surface,
            borderRadius: BorderRadius.circular(12),
          ),
          child: PopupMenuButton<String>(
            onSelected: (value) {
              switch (value) {
                case 'settings':
                  Navigator.pushNamed(context, AppRoutes.settingsScreen);
                  break;
                case 'help':
                  Navigator.pushNamed(context, AppRoutes.contactUsScreen);
                  break;
                case 'templates':
                  Navigator.pushNamed(context, AppRoutes.contentTemplatesScreen);
                  break;
              }
            },
            color: AppTheme.surface,
            icon: const Icon(Icons.more_vert, color: AppTheme.primaryText),
            itemBuilder: (context) => [
              PopupMenuItem(
                value: 'templates',
                child: Row(
                  children: [
                    const Icon(Icons.help_outline, color: AppTheme.primaryText, size: 20),
                    const SizedBox(width: 12),
                    Text('Templates', style: GoogleFonts.inter(color: AppTheme.primaryText, fontSize: 14)),
                  ],
                ),
              ),
              PopupMenuItem(
                value: 'settings',
                child: Row(
                  children: [
                    const Icon(Icons.settings, color: AppTheme.primaryText, size: 20),
                    const SizedBox(width: 12),
                    Text('Settings', style: GoogleFonts.inter(color: AppTheme.primaryText, fontSize: 14)),
                  ],
                ),
              ),
              PopupMenuItem(
                value: 'help',
                child: Row(
                  children: [
                    const Icon(Icons.help_outline, color: AppTheme.primaryText, size: 20),
                    const SizedBox(width: 12),
                    Text('Help', style: GoogleFonts.inter(color: AppTheme.primaryText, fontSize: 14)),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
      flexibleSpace: FlexibleSpaceBar(
        title: Text(
          'Social Media Hub',
          style: GoogleFonts.inter(
            fontSize: 24,
            fontWeight: FontWeight.w700,
            color: AppTheme.primaryText,
          ),
        ),
        background: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [AppTheme.primaryBackground, AppTheme.surface],
            ),
          ),
        ),
      ),
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(60),
        child: Container(
          decoration: const BoxDecoration(
            color: AppTheme.primaryBackground,
            border: Border(
              bottom: BorderSide(
                color: AppTheme.border,
                width: 0.5,
              ),
            ),
          ),
          child: TabBar(
            controller: _tabController,
            labelColor: AppTheme.primaryText,
            unselectedLabelColor: AppTheme.secondaryText,
            indicatorColor: AppTheme.accent,
            indicatorWeight: 3,
            indicatorSize: TabBarIndicatorSize.label,
            labelStyle: GoogleFonts.inter(
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
            unselectedLabelStyle: GoogleFonts.inter(
              fontSize: 14,
              fontWeight: FontWeight.w400,
            ),
            isScrollable: true,
            tabs: const [
              Tab(text: 'Overview'),
              Tab(text: 'Scheduler'),
              Tab(text: 'Analytics'),
              Tab(text: 'Content'),
              Tab(text: 'Activity'),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFloatingActionButton() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppTheme.accent.withAlpha(77),
            blurRadius: 16,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: FloatingActionButton.extended(
        onPressed: _showQuickPostModal,
        backgroundColor: AppTheme.accent,
        foregroundColor: AppTheme.primaryBackground,
        label: Text(
          'Quick Post',
          style: GoogleFonts.inter(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        icon: const Icon(Icons.add, size: 24),
      ),
    );
  }

  Widget _buildOverviewTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildConnectedPlatformsSection(),
          const SizedBox(height: 32),
          _buildAnalyticsCardsSection(),
          const SizedBox(height: 32),
          _buildQuickActionsSection(),
          const SizedBox(height: 32),
          _buildRecentActivityPreview(),
        ],
      ),
    );
  }

  Widget _buildSchedulerTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildPlatformStatusSection(),
          const SizedBox(height: 32),
          _buildCalendarSection(),
          const SizedBox(height: 32),
          _buildSchedulerActions(),
        ],
      ),
    );
  }

  Widget _buildAnalyticsTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildAnalyticsHeader(),
          const SizedBox(height: 24),
          MetricsOverviewWidget(
            dateRange: '${DateTime.now().subtract(const Duration(days: 30)).day}/${DateTime.now().subtract(const Duration(days: 30)).month}/${DateTime.now().subtract(const Duration(days: 30)).year} - ${DateTime.now().day}/${DateTime.now().month}/${DateTime.now().year}',
            selectedPlatforms: _platforms.keys.toList(),
          ),
          const SizedBox(height: 24),
          PlatformTabsWidget(
            selectedPlatforms: _platforms.keys.toList(),
            activePlatform: 'instagram',
            onPlatformSelected: (platform) {},
          ),
          const SizedBox(height: 24),
          EngagementChartWidget(
            dateRange: '${DateTime.now().subtract(const Duration(days: 30)).day}/${DateTime.now().subtract(const Duration(days: 30)).month}/${DateTime.now().subtract(const Duration(days: 30)).year} - ${DateTime.now().day}/${DateTime.now().month}/${DateTime.now().year}',
            selectedPlatforms: _platforms.keys.toList(),
          ),
          const SizedBox(height: 24),
          AudienceInsightsWidget(
            dateRange: '${DateTime.now().subtract(const Duration(days: 30)).day}/${DateTime.now().subtract(const Duration(days: 30)).month}/${DateTime.now().subtract(const Duration(days: 30)).year} - ${DateTime.now().day}/${DateTime.now().month}/${DateTime.now().year}',
            selectedPlatforms: _platforms.keys.toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildContentTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildContentHeader(),
          const SizedBox(height: 24),
          _buildContentActions(),
          const SizedBox(height: 32),
          _buildContentCalendar(),
        ],
      ),
    );
  }

  Widget _buildActivityTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildActivityHeader(),
          const SizedBox(height: 24),
          const RecentActivityWidget(),
          const SizedBox(height: 32),
          const InstagramDatabaseWidget(),
        ],
      ),
    );
  }

  Widget _buildConnectedPlatformsSection() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppTheme.border.withAlpha(77),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.link,
                color: AppTheme.accent,
                size: 24,
              ),
              const SizedBox(width: 12),
              Text(
                'Connected Platforms',
                style: GoogleFonts.inter(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: AppTheme.primaryText,
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          const PlatformConnectionWidget(),
        ],
      ),
    );
  }

  Widget _buildAnalyticsCardsSection() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppTheme.border.withAlpha(77),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.analytics,
                color: AppTheme.accent,
                size: 24,
              ),
              const SizedBox(width: 12),
              Text(
                'Performance Overview',
                style: GoogleFonts.inter(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: AppTheme.primaryText,
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          const AnalyticsCardsWidget(),
        ],
      ),
    );
  }

  Widget _buildQuickActionsSection() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppTheme.border.withAlpha(77),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.flash_on,
                color: AppTheme.accent,
                size: 24,
              ),
              const SizedBox(width: 12),
              Text(
                'Quick Actions',
                style: GoogleFonts.inter(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: AppTheme.primaryText,
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          const QuickActionsGridWidget(),
        ],
      ),
    );
  }

  Widget _buildRecentActivityPreview() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppTheme.border.withAlpha(77),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.history,
                color: AppTheme.accent,
                size: 24,
              ),
              const SizedBox(width: 12),
              Text(
                'Recent Activity',
                style: GoogleFonts.inter(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: AppTheme.primaryText,
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          const RecentActivityWidget(),
        ],
      ),
    );
  }

  Widget _buildPlatformStatusSection() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppTheme.border.withAlpha(77),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.help_outline,
                color: AppTheme.accent,
                size: 24,
              ),
              const SizedBox(width: 12),
              Text(
                'Platform Status',
                style: GoogleFonts.inter(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: AppTheme.primaryText,
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          PlatformStatusWidget(
            platformStatus: _platforms,
            onToggleConnection: _togglePlatformConnection,
          ),
        ],
      ),
    );
  }

  Widget _buildCalendarSection() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppTheme.border.withAlpha(77),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.calendar_today,
                color: AppTheme.accent,
                size: 24,
              ),
              const SizedBox(width: 12),
              Text(
                'Content Calendar',
                style: GoogleFonts.inter(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: AppTheme.primaryText,
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          CalendarWidget(
            currentMonth: DateTime.now(),
            selectedDate: DateTime.now(),
            scheduledPosts: const <String, List<Map<String, dynamic>>>{},
            isWeekView: false,
            onDateSelected: (date) {},
            onMonthChanged: (month) {},
          ),
        ],
      ),
    );
  }

  Widget _buildSchedulerActions() {
    return Row(
      children: [
        Expanded(
          child: _buildActionCard(
            'Schedule Post',
            'Create and schedule a new post',
            Icons.schedule,
            _showAddPostModal,
            AppTheme.accent,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: _buildActionCard(
            'Bulk Upload',
            'Upload multiple posts at once',
            Icons.upload,
            _showBulkUploadModal,
            AppTheme.success,
          ),
        ),
      ],
    );
  }

  Widget _buildAnalyticsHeader() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppTheme.border.withAlpha(77),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Icon(
            Icons.analytics,
            color: AppTheme.accent,
            size: 32,
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Analytics Dashboard',
                  style: GoogleFonts.inter(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.primaryText,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Track your social media performance',
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    color: AppTheme.secondaryText,
                  ),
                ),
              ],
            ),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pushNamed(context, AppRoutes.analyticsScreen),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.accent,
              foregroundColor: AppTheme.primaryBackground,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            ),
            child: const Text('View All'),
          ),
        ],
      ),
    );
  }

  Widget _buildContentHeader() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppTheme.border.withAlpha(77),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Icon(
            Icons.content_paste,
            color: AppTheme.accent,
            size: 32,
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Content Management',
                  style: GoogleFonts.inter(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.primaryText,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Create, organize, and schedule content',
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    color: AppTheme.secondaryText,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActivityHeader() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppTheme.border.withAlpha(77),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Icon(
            Icons.help_outline,
            color: AppTheme.accent,
            size: 32,
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Activity Feed',
                  style: GoogleFonts.inter(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.primaryText,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Monitor your social media activity',
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    color: AppTheme.secondaryText,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContentActions() {
    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      mainAxisSpacing: 16,
      crossAxisSpacing: 16,
      childAspectRatio: 1.5,
      children: [
        _buildActionCard(
          'Templates',
          'Browse content templates',
          Icons.help_outline,
          () => Navigator.pushNamed(context, AppRoutes.contentTemplatesScreen),
          AppTheme.accent,
        ),
        _buildActionCard(
          'Multi-Platform',
          'Post to multiple platforms',
          Icons.public,
          () => Navigator.pushNamed(context, AppRoutes.multiPlatformPostingScreen),
          AppTheme.success,
        ),
        _buildActionCard(
          'Calendar',
          'View content calendar',
          Icons.calendar_today,
          () => Navigator.pushNamed(context, AppRoutes.contentCalendarScreen),
          AppTheme.warning,
        ),
        _buildActionCard(
          'Hashtags',
          'Research hashtags',
          Icons.tag,
          () => Navigator.pushNamed(context, AppRoutes.hashtagResearchScreen),
          AppTheme.error,
        ),
      ],
    );
  }

  Widget _buildContentCalendar() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppTheme.border.withAlpha(77),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.calendar_view_month,
                color: AppTheme.accent,
                size: 24,
              ),
              const SizedBox(width: 12),
              Text(
                'Content Calendar',
                style: GoogleFonts.inter(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: AppTheme.primaryText,
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          const ContentCalendarWidget(),
        ],
      ),
    );
  }

  Widget _buildActionCard(
    String title,
    String description,
    IconData icon,
    VoidCallback onTap,
    Color color,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: AppTheme.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: AppTheme.border.withAlpha(77),
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha(13),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: color.withAlpha(26),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                icon,
                color: color,
                size: 24,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              title,
              style: GoogleFonts.inter(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: AppTheme.primaryText,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              description,
              style: GoogleFonts.inter(
                fontSize: 14,
                color: AppTheme.secondaryText,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}