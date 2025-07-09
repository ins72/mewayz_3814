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
import './widgets/trending_hashtags_widget.dart';

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

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    _startRealTimeUpdates();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _startRealTimeUpdates() {
    if (_isRealTimeUpdatesEnabled) {
      // Simulate real-time updates
      Timer.periodic(const Duration(seconds: 30), (timer) {
        if (mounted && _isRealTimeUpdatesEnabled) {
          setState(() {
            // Update data
          });
        } else {
          timer.cancel();
        }
      });
    }
  }

  Future<void> _refreshData() async {
    if (mounted) {
      setState(() => _isLoading = true);
      // Simulate API call
      await Future.delayed(const Duration(seconds: 2));
      // Haptic feedback
      HapticFeedback.lightImpact();
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  void _showQuickPostModal() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const QuickPostModalWidget(),
    );
  }

  void _showFilterOptions() {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppTheme.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
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
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            SizedBox(height: 4.h),
            Text(
              'Filter Options',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            SizedBox(height: 4.h),
            _buildFilterSection(
              'Time Range',
              _selectedTimeRange,
              ['Today', 'This Week', 'This Month', 'Last 30 Days', 'Last 90 Days'],
              (value) => setState(() => _selectedTimeRange = value),
            ),
            SizedBox(height: 3.h),
            _buildFilterSection(
              'Platform',
              _selectedPlatform,
              ['All Platforms', 'Instagram', 'Facebook', 'Twitter', 'LinkedIn', 'TikTok'],
              (value) => setState(() => _selectedPlatform = value),
            ),
            SizedBox(height: 4.h),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      setState(() {
                        _selectedTimeRange = 'This Week';
                        _selectedPlatform = 'All Platforms';
                      });
                      Navigator.pop(context);
                    },
                    child: const Text('Reset'),
                  ),
                ),
                SizedBox(width: 4.w),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Apply'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterSection(String title, String selectedValue, List<String> options, Function(String) onChanged) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.titleSmall,
        ),
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
                    color: isSelected ? AppTheme.accent : AppTheme.border,
                  ),
                ),
                child: Text(
                  option,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: isSelected ? AppTheme.primaryAction : AppTheme.primaryText,
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
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
          onPressed: () => Navigator.pop(context),
        ),
        title: const SocialMediaHeaderWidget(),
        actions: [
          IconButton(
            icon: Icon(
              _isRealTimeUpdatesEnabled ? Icons.notifications_active : Icons.notifications_off,
              color: _isRealTimeUpdatesEnabled ? AppTheme.success : AppTheme.secondaryText,
            ),
            onPressed: () {
              setState(() {
                _isRealTimeUpdatesEnabled = !_isRealTimeUpdatesEnabled;
              });
              if (_isRealTimeUpdatesEnabled) {
                _startRealTimeUpdates();
              }
            },
          ),
          IconButton(
            icon: const Icon(Icons.filter_alt_outlined, color: AppTheme.primaryText),
            onPressed: _showFilterOptions,
          ),
          IconButton(
            icon: const Icon(Icons.refresh_rounded, color: AppTheme.primaryText),
            onPressed: _refreshData,
          ),
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
          ],
        ),
      ),
      body: _isLoading
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(AppTheme.accent),
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    'Loading social media data...',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: AppTheme.secondaryText,
                    ),
                  ),
                ],
              ),
            )
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
                ],
              ),
            ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _showQuickPostModal,
        backgroundColor: AppTheme.accent,
        foregroundColor: AppTheme.primaryAction,
        icon: const Icon(Icons.add_rounded),
        label: const Text('New Post'),
      ),
    );
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
        ],
      ),
    );
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
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.analytics_outlined,
                    color: AppTheme.accent,
                    size: 24,
                  ),
                ),
                SizedBox(width: 4.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Analytics Dashboard',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      SizedBox(height: 1.h),
                      Text(
                        'Track your social media performance across all platforms',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AppTheme.secondaryText,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
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
                Text(
                  'Top Performing Content',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                SizedBox(height: 4.h),
                _buildTopPerformingContent(),
              ],
            ),
          ),
        ],
      ),
    );
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
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.content_copy_outlined,
                    color: AppTheme.success,
                    size: 24,
                  ),
                ),
                SizedBox(width: 4.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Content Management',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      SizedBox(height: 1.h),
                      Text(
                        'Manage your content library and scheduled posts',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AppTheme.secondaryText,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 6.h),
          const ContentCalendarWidget(),
          SizedBox(height: 6.h),
          const ContentSuggestionsWidget(),
          SizedBox(height: 6.h),
          _buildContentLibrary(),
        ],
      ),
    );
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
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.lightbulb_outline,
                    color: AppTheme.warning,
                    size: 24,
                  ),
                ),
                SizedBox(width: 4.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'AI-Powered Insights',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      SizedBox(height: 1.h),
                      Text(
                        'Get intelligent recommendations and insights',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AppTheme.secondaryText,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 6.h),
          const TrendingHashtagsWidget(),
          SizedBox(height: 6.h),
          const ContentSuggestionsWidget(),
          SizedBox(height: 6.h),
          _buildAudienceInsights(),
        ],
      ),
    );
  }

  Widget _buildTopPerformingContent() {
    final topContent = [
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
            border: Border.all(color: AppTheme.border),
          ),
          child: Row(
            children: [
              Container(
                padding: EdgeInsets.all(2.w),
                decoration: BoxDecoration(
                  color: content['color'] as Color,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.trending_up,
                  color: AppTheme.primaryAction,
                  size: 20,
                ),
              ),
              SizedBox(width: 4.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      content['title'] as String,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    SizedBox(height: 1.h),
                    Text(
                      content['platform'] as String,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppTheme.secondaryText,
                      ),
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    '${content['engagement']} engagements',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: AppTheme.success,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: 1.h),
                  Text(
                    '${content['reach']} reach',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: AppTheme.secondaryText,
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      }).toList(),
    );
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
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const Spacer(),
              TextButton(
                onPressed: () {},
                child: const Text('View All'),
              ),
            ],
          ),
          SizedBox(height: 4.h),
          SizedBox(
            height: 25.h,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: 5,
              itemBuilder: (context, index) {
                return Container(
                  width: 40.w,
                  margin: EdgeInsets.only(right: 4.w),
                  decoration: BoxDecoration(
                    color: AppTheme.surfaceVariant,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppTheme.border),
                  ),
                  child: Column(
                    children: [
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                            color: AppTheme.accent.withAlpha(26),
                            borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(12),
                              topRight: Radius.circular(12),
                            ),
                          ),
                          child: const Center(
                            child: Icon(
                              Icons.image_outlined,
                              color: AppTheme.accent,
                              size: 32,
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(3.w),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Content ${index + 1}',
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                            SizedBox(height: 1.h),
                            Text(
                              'Scheduled for today',
                              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                color: AppTheme.secondaryText,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAudienceInsights() {
    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: AppTheme.cardDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Audience Insights',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          SizedBox(height: 4.h),
          Row(
            children: [
              Expanded(
                child: _buildInsightCard('Peak Activity', '2-4 PM', Icons.schedule, AppTheme.accent),
              ),
              SizedBox(width: 4.w),
              Expanded(
                child: _buildInsightCard('Top Location', 'New York', Icons.location_on, AppTheme.success),
              ),
            ],
          ),
          SizedBox(height: 4.h),
          Row(
            children: [
              Expanded(
                child: _buildInsightCard('Age Group', '25-34', Icons.person, AppTheme.warning),
              ),
              SizedBox(width: 4.w),
              Expanded(
                child: _buildInsightCard('Gender Split', '52% F, 48% M', Icons.people, AppTheme.error),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInsightCard(String title, String value, IconData icon, Color color) {
    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: AppTheme.surfaceVariant,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppTheme.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: 24),
          SizedBox(height: 2.h),
          Text(
            value,
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
              color: color,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 1.h),
          Text(
            title,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: AppTheme.secondaryText,
            ),
          ),
        ],
      ),
    );
  }
}