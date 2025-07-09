import 'dart:async';


import '../../core/app_export.dart';
import './widgets/analytics_cards_widget.dart';
import './widgets/content_calendar_widget.dart';
import './widgets/content_suggestions_widget.dart';
import './widgets/instagram_database_widget.dart';
import './widgets/performance_charts_widget.dart';
import './widgets/platform_connection_widget.dart';
import './widgets/quick_actions_grid_widget.dart';
import './widgets/quick_post_modal_widget.dart';
import './widgets/recent_activity_widget.dart';
import './widgets/social_media_header_widget.dart';
import './widgets/social_media_stats_widget.dart';
import './widgets/trending_hashtags_widget';

class SocialMediaManager extends StatefulWidget {
  const SocialMediaManager({Key? key}) : super(key: key);

  @override
  State<SocialMediaManager> createState() => _SocialMediaManagerState();
}

class _SocialMediaManagerState extends State<SocialMediaManager>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  bool _isLoading = false;
  bool _isRealTimeUpdatesEnabled = true;
  String _selectedTimeRange = 'This Week';
  String _selectedPlatform = 'All Platforms';

  final DataService _dataService = DataService();
  Map<String, dynamic> _socialMediaStats = {};
  List<Map<String, dynamic>> _posts = [];
  List<Map<String, dynamic>> _trendingHashtags = [];
  
  Timer? _realTimeTimer;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    _loadSocialMediaData();
    _startRealTimeUpdates();
  }

  @override
  void dispose() {
    _tabController.dispose();
    _realTimeTimer?.cancel();
    super.dispose();
  }

  Future<void> _loadSocialMediaData() async {
    setState(() => _isLoading = true);
    
    try {
      // Load social media statistics
      final stats = await _dataService.getSocialMediaStats();
      
      // Load posts
      final posts = await _dataService.getSocialMediaPosts();
      
      // Load trending hashtags
      final hashtags = await _dataService.getTrendingHashtags();
      
      setState(() {
        _socialMediaStats = stats;
        _posts = posts;
        _trendingHashtags = hashtags;
      });
    } catch (e) {
      ErrorHandler.handleError(e);
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void _startRealTimeUpdates() {
    if (_isRealTimeUpdatesEnabled) {
      _realTimeTimer = Timer.periodic(const Duration(seconds: 30), (timer) {
        if (mounted && _isRealTimeUpdatesEnabled) {
          _loadSocialMediaData();
        }
      });
    }
  }

  void _stopRealTimeUpdates() {
    _realTimeTimer?.cancel();
  }

  Future<void> _refreshData() async {
    await ButtonService.handleButtonPress(() {});
  }

  void _toggleRealTimeUpdates() {
    setState(() {
      _isRealTimeUpdatesEnabled = !_isRealTimeUpdatesEnabled;
    });
    
    if (_isRealTimeUpdatesEnabled) {
      _startRealTimeUpdates();
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Real-time updates enabled')));
    } else {
      _stopRealTimeUpdates();
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Real-time updates disabled')));
    }
  }

  Future<void> _showQuickPostModal() async {
    final result = await showModalBottomSheet<Map<String, dynamic>>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const QuickPostModalWidget());

    if (result != null) {
      await _handleCreatePost(result);
    }
  }

  Future<void> _handleCreatePost(Map<String, dynamic> postData) async {
    await ButtonService.handleButtonPress(() {});
  }

  Future<void> _handleSchedulePost(Map<String, dynamic> postData) async {
    await ButtonService.handleButtonPress(() {});
  }

  Future<void> _handleDeletePost(String postId) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Post'),
        content: const Text('Are you sure you want to delete this post?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Cancel')),
          TextButton(onPressed: () => Navigator.pop(context, true), child: const Text('Delete')),
        ],
      ),
    ) ?? false;

    if (confirmed) {
      await ButtonService.handleButtonPress(() {});
    }
  }

  void _showFilterOptions() {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppTheme.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (context) => Container(
        padding: EdgeInsets.all(6.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 12.w,
              height: 0.5.h,
              decoration: BoxDecoration(
                color: AppTheme.border,
                borderRadius: BorderRadius.circular(2))),
            SizedBox(height: 4.h),
            Text(
              'Filter Options',
              style: Theme.of(context).textTheme.titleLarge),
            SizedBox(height: 4.h),
            _buildFilterSection(
              'Time Range',
              _selectedTimeRange,
              ['Today', 'This Week', 'This Month', 'Last 30 Days', 'Last 90 Days'],
              (value) => setState(() => _selectedTimeRange = value)),
            SizedBox(height: 3.h),
            _buildFilterSection(
              'Platform',
              _selectedPlatform,
              ['All Platforms', 'Instagram', 'Facebook', 'Twitter', 'LinkedIn', 'TikTok'],
              (value) => setState(() => _selectedPlatform = value)),
            SizedBox(height: 4.h),
            Row(
              children: [
                Expanded(
                  child: CustomEnhancedButtonWidget(
                    buttonId: 'reset_filters',
                    child: const Text('Reset'),
                    onPressed: () {
                      setState(() {
                        _selectedTimeRange = 'This Week';
                        _selectedPlatform = 'All Platforms';
                      });
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Filters reset')));
                    })),
                SizedBox(width: 4.w),
                Expanded(
                  child: CustomEnhancedButtonWidget(
                    buttonId: 'apply_filters',
                    child: const Text('Apply'),
                    onPressed: () async {
                      Navigator.pop(context);
                      await _refreshData();
                    })),
              ]),
          ])));
  }

  Widget _buildFilterSection(String title, String selectedValue, List<String> options, Function(String) onChanged) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.titleSmall),
        SizedBox(height: 2.h),
        Wrap(
          spacing: 2.w,
          runSpacing: 1.h,
          children: options.map((option) {
            final isSelected = selectedValue == option;
            return GestureDetector(
              onTap: () => onChanged(option),
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
                decoration: BoxDecoration(
                  color: isSelected ? AppTheme.accent : Colors.transparent,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: isSelected ? AppTheme.accent : AppTheme.border)),
                child: Text(
                  option,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: isSelected ? AppTheme.primaryAction : AppTheme.primaryText,
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400))));
          }).toList()),
      ]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.primaryBackground,
      appBar: AppBar(
        backgroundColor: AppTheme.primaryBackground,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: AppTheme.primaryText),
          onPressed: () => Navigator.pop(context)),
        title: const SocialMediaHeaderWidget(),
        actions: [
          IconButton(
            icon: Icon(
              _isRealTimeUpdatesEnabled ? Icons.notifications_active : Icons.notifications_off,
              color: _isRealTimeUpdatesEnabled ? AppTheme.success : AppTheme.secondaryText),
            onPressed: _toggleRealTimeUpdates),
          IconButton(
            icon: const Icon(Icons.filter_alt_outlined, color: AppTheme.primaryText),
            onPressed: _showFilterOptions),
          IconButton(
            icon: const Icon(Icons.refresh_rounded, color: AppTheme.primaryText),
            onPressed: _refreshData),
        ],
        bottom: TabBar(
          controller: _tabController,
          isScrollable: true,
          labelColor: AppTheme.primaryText,
          unselectedLabelColor: AppTheme.secondaryText,
          indicatorColor: AppTheme.accent,
          indicatorWeight: 3,
          tabs: const [
            Tab(text: 'Overview'),
            Tab(text: 'Analytics'),
            Tab(text: 'Content'),
            Tab(text: 'Insights'),
          ])),
      body: _isLoading
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(AppTheme.accent)),
                  SizedBox(height: 4.h),
                  Text(
                    'Loading social media data...',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: AppTheme.secondaryText)),
                ]))
          : RefreshIndicator(
              onRefresh: _refreshData,
              color: AppTheme.accent,
              backgroundColor: AppTheme.surface,
              child: TabBarView(
                controller: _tabController,
                children: [
                  _buildOverviewTab(),
                  _buildAnalyticsTab(),
                  _buildContentTab(),
                  _buildInsightsTab(),
                ])),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _showQuickPostModal,
        backgroundColor: AppTheme.accent,
        foregroundColor: AppTheme.primaryAction,
        icon: const Icon(Icons.add_rounded),
        label: const Text('New Post')));
  }

  Widget _buildOverviewTab() {
    return SingleChildScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: EdgeInsets.all(4.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SocialMediaStatsWidget(),
          SizedBox(height: 6.h),
          const PlatformConnectionWidget(),
          SizedBox(height: 6.h),
          const AnalyticsCardsWidget(),
          SizedBox(height: 6.h),
          const QuickActionsGridWidget(),
          SizedBox(height: 6.h),
          const RecentActivityWidget(),
          SizedBox(height: 6.h),
          const InstagramDatabaseWidget(),
          SizedBox(height: 6.h),
          const ContentCalendarWidget(),
          SizedBox(height: 20.h), // Extra space for FAB
        ]));
  }

  Widget _buildAnalyticsTab() {
    return SingleChildScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: EdgeInsets.all(4.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.all(4.w),
            decoration: AppTheme.cardDecoration(),
            child: Row(
              children: [
                Container(
                  padding: EdgeInsets.all(3.w),
                  decoration: BoxDecoration(
                    color: AppTheme.accent.withAlpha(26),
                    borderRadius: BorderRadius.circular(12)),
                  child: const Icon(
                    Icons.analytics_outlined,
                    color: AppTheme.accent,
                    size: 24)),
                SizedBox(width: 4.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Analytics Dashboard',
                        style: Theme.of(context).textTheme.titleMedium),
                      SizedBox(height: 1.h),
                      Text(
                        'Track your social media performance across all platforms',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AppTheme.secondaryText)),
                    ])),
                CustomEnhancedButtonWidget(
                  buttonId: 'view_analytics',
                  child: const Text('View All'),
                  onPressed: () async {
                    Navigator.pushNamed(context, AppRoutes.socialMediaAnalyticsScreen);
                  }),
              ])),
          SizedBox(height: 6.h),
          const PerformanceChartsWidget(),
          SizedBox(height: 6.h),
          const AnalyticsCardsWidget(),
          SizedBox(height: 6.h),
          Container(
            padding: EdgeInsets.all(4.w),
            decoration: AppTheme.cardDecoration(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Top Performing Content',
                      style: Theme.of(context).textTheme.titleMedium),
                    CustomEnhancedButtonWidget(
                      buttonId: 'view_content',
                      child: const Text('View All'),
                      onPressed: () async {
                        Navigator.pushNamed(context, AppRoutes.contentTemplatesScreen);
                      }),
                  ]),
                SizedBox(height: 4.h),
                _buildTopPerformingContent(),
              ])),
        ]));
  }

  Widget _buildContentTab() {
    return SingleChildScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: EdgeInsets.all(4.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.all(4.w),
            decoration: AppTheme.cardDecoration(),
            child: Row(
              children: [
                Container(
                  padding: EdgeInsets.all(3.w),
                  decoration: BoxDecoration(
                    color: AppTheme.success.withAlpha(26),
                    borderRadius: BorderRadius.circular(12)),
                  child: const Icon(
                    Icons.content_copy_outlined,
                    color: AppTheme.success,
                    size: 24)),
                SizedBox(width: 4.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Content Management',
                        style: Theme.of(context).textTheme.titleMedium),
                      SizedBox(height: 1.h),
                      Text(
                        'Manage your content library and scheduled posts',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AppTheme.secondaryText)),
                    ])),
                CustomEnhancedButtonWidget(
                  buttonId: 'open_scheduler',
                  child: const Text('Schedule Post'),
                  onPressed: () async {
                    Navigator.pushNamed(context, AppRoutes.socialMediaScheduler);
                  }),
              ])),
          SizedBox(height: 6.h),
          const ContentCalendarWidget(),
          SizedBox(height: 6.h),
          const ContentSuggestionsWidget(),
          SizedBox(height: 6.h),
          _buildContentLibrary(),
        ]));
  }

  Widget _buildInsightsTab() {
    return SingleChildScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: EdgeInsets.all(4.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.all(4.w),
            decoration: AppTheme.cardDecoration(),
            child: Row(
              children: [
                Container(
                  padding: EdgeInsets.all(3.w),
                  decoration: BoxDecoration(
                    color: AppTheme.warning.withAlpha(26),
                    borderRadius: BorderRadius.circular(12)),
                  child: const Icon(
                    Icons.lightbulb_outline,
                    color: AppTheme.warning,
                    size: 24)),
                SizedBox(width: 4.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'AI-Powered Insights',
                        style: Theme.of(context).textTheme.titleMedium),
                      SizedBox(height: 1.h),
                      Text(
                        'Get intelligent recommendations and insights',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AppTheme.secondaryText)),
                    ])),
                CustomEnhancedButtonWidget(
                  buttonId: 'hashtag_research',
                  child: const Text('Research'),
                  onPressed: () async {
                    Navigator.pushNamed(context, AppRoutes.hashtagResearchScreen);
                  }),
              ])),
          SizedBox(height: 6.h),
          const TrendingHashtagsWidget(),
          SizedBox(height: 6.h),
          const ContentSuggestionsWidget(),
          SizedBox(height: 6.h),
          _buildAudienceInsights(),
        ]));
  }

  Widget _buildTopPerformingContent() {
    final topContent = _posts.isNotEmpty ? _posts.take(3).toList() : [
      {
        'title': 'Product Launch Announcement',
        'engagement': '2.4K',
        'reach': '15.8K',
        'platform': 'Instagram',
        'color': AppTheme.success,
      },
      {
        'title': 'Behind the Scenes Video',
        'engagement': '1.8K',
        'reach': '12.3K',
        'platform': 'TikTok',
        'color': AppTheme.accent,
      },
      {
        'title': 'Customer Testimonial',
        'engagement': '1.2K',
        'reach': '8.7K',
        'platform': 'LinkedIn',
        'color': AppTheme.warning,
      },
    ];

    return Column(
      children: topContent.map((content) {
        return Container(
          margin: EdgeInsets.only(bottom: 3.h),
          padding: EdgeInsets.all(4.w),
          decoration: BoxDecoration(
            color: AppTheme.surfaceVariant,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppTheme.border)),
          child: Row(
            children: [
              Container(
                padding: EdgeInsets.all(2.w),
                decoration: BoxDecoration(
                  color: (content['color'] as Color? ?? AppTheme.accent),
                  borderRadius: BorderRadius.circular(8)),
                child: const Icon(
                  Icons.trending_up,
                  color: AppTheme.primaryAction,
                  size: 20)),
              SizedBox(width: 4.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      content['title'] as String,
                      style: Theme.of(context).textTheme.bodyMedium),
                    SizedBox(height: 1.h),
                    Text(
                      content['platform'] as String,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppTheme.secondaryText)),
                  ])),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    '${content['engagement']} engagements',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: AppTheme.success,
                      fontWeight: FontWeight.w600)),
                  SizedBox(height: 1.h),
                  Text(
                    '${content['reach']} reach',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: AppTheme.secondaryText)),
                ]),
              IconButton(
                icon: const Icon(Icons.more_vert, color: AppTheme.secondaryText),
                onPressed: () => _showPostActions(content)),
            ]));
      }).toList());
  }

  void _showPostActions(Map<String, dynamic> content) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppTheme.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (context) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 48,
            height: 4,
            margin: EdgeInsets.only(top: 12, bottom: 20),
            decoration: BoxDecoration(
              color: AppTheme.border,
              borderRadius: BorderRadius.circular(2))),
          ListTile(
            leading: const Icon(Icons.edit, color: AppTheme.accent),
            title: const Text('Edit Post'),
            onTap: () async {
              Navigator.pop(context);
              // Using Navigator directly
              Navigator.pushNamed(context, AppRoutes.socialMediaScheduler, arguments: content);
            }),
          ListTile(
            leading: const Icon(Icons.share, color: AppTheme.success),
            title: const Text('Share Post'),
            onTap: () async {
              Navigator.pop(context);
              await ButtonService.handleButtonPress(() {});
            }),
          ListTile(
            leading: const Icon(Icons.analytics, color: AppTheme.warning),
            title: const Text('View Analytics'),
            onTap: () async {
              Navigator.pop(context);
              // Using Navigator directly
              Navigator.pushNamed(context, AppRoutes.socialMediaAnalyticsScreen, arguments: content);
            }),
          ListTile(
            leading: const Icon(Icons.delete, color: AppTheme.error),
            title: const Text('Delete Post'),
            onTap: () async {
              Navigator.pop(context);
              await _handleDeletePost(content['id'] ?? '');
            }),
          SizedBox(height: 20),
        ]));
  }

  Widget _buildContentLibrary() {
    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: AppTheme.cardDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                'Content Library',
                style: Theme.of(context).textTheme.titleMedium),
              const Spacer(),
              CustomEnhancedButtonWidget(
                buttonId: 'open_library',
                child: const Text('View All'),
                onPressed: () async {
                  Navigator.pushNamed(context, AppRoutes.contentTemplatesScreen);
                }),
            ]),
          SizedBox(height: 4.h),
          SizedBox(
            height: 25.h,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: _posts.isNotEmpty ? _posts.length : 5,
              itemBuilder: (context, index) {
                final content = _posts.isNotEmpty ? _posts[index] : {
                  'title': 'Content ${index + 1}',
                  'status': 'scheduled',
                };
                
                return Container(
                  width: 40.w,
                  margin: EdgeInsets.only(right: 4.w),
                  decoration: BoxDecoration(
                    color: AppTheme.surfaceVariant,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppTheme.border)),
                  child: Column(
                    children: [
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                            color: AppTheme.accent.withAlpha(26),
                            borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(12),
                              topRight: Radius.circular(12))),
                          child: const Center(
                            child: Icon(
                              Icons.image_outlined,
                              color: AppTheme.accent,
                              size: 32)))),
                      Padding(
                        padding: EdgeInsets.all(3.w),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              content['title'] ?? 'Content ${index + 1}',
                              style: Theme.of(context).textTheme.bodySmall,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis),
                            SizedBox(height: 1.h),
                            Text(
                              content['status'] ?? 'Scheduled for today',
                              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                color: AppTheme.secondaryText)),
                          ])),
                    ]));
              })),
        ]));
  }

  Widget _buildAudienceInsights() {
    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: AppTheme.cardDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Audience Insights',
                style: Theme.of(context).textTheme.titleMedium),
              CustomEnhancedButtonWidget(
                buttonId: 'audience_insights',
                child: const Text('View Details'),
                onPressed: () async {
                  Navigator.pushNamed(context, AppRoutes.socialMediaAnalyticsScreen);
                }),
            ]),
          SizedBox(height: 4.h),
          Row(
            children: [
              Expanded(
                child: _buildInsightCard('Peak Activity', '2-4 PM', Icons.schedule, AppTheme.accent)),
              SizedBox(width: 4.w),
              Expanded(
                child: _buildInsightCard('Top Location', 'New York', Icons.location_on, AppTheme.success)),
            ]),
          SizedBox(height: 4.h),
          Row(
            children: [
              Expanded(
                child: _buildInsightCard('Age Group', '25-34', Icons.person, AppTheme.warning)),
              SizedBox(width: 4.w),
              Expanded(
                child: _buildInsightCard('Gender Split', '52% F, 48% M', Icons.people, AppTheme.error)),
            ]),
        ]));
  }

  Widget _buildInsightCard(String title, String value, IconData icon, Color color) {
    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: AppTheme.surfaceVariant,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppTheme.border)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: 24),
          SizedBox(height: 2.h),
          Text(
            value,
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
              color: color,
              fontWeight: FontWeight.w600)),
          SizedBox(height: 1.h),
          Text(
            title,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: AppTheme.secondaryText)),
        ]));
  }
}