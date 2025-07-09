import '../../core/app_export.dart';
import '../analytics_dashboard/widgets/date_range_selector_widget.dart';
import '../analytics_dashboard/widgets/export_button_widget.dart';
import '../analytics_dashboard/widgets/filter_chip_widget.dart';
import '../link_in_bio_analytics_screen/widgets/analytics_charts_widget.dart';
import '../link_in_bio_analytics_screen/widgets/conversion_funnel_widget.dart';
import '../link_in_bio_analytics_screen/widgets/real_time_tracking_widget.dart';
import '../social_media_analytics_screen/widgets/audience_insights_widget.dart';
import '../social_media_analytics_screen/widgets/engagement_chart_widget.dart';
import '../social_media_analytics_screen/widgets/metrics_overview_widget.dart';
import '../social_media_analytics_screen/widgets/platform_tabs_widget.dart';

class UnifiedAnalyticsScreen extends StatefulWidget {
  const UnifiedAnalyticsScreen({Key? key}) : super(key: key);

  @override
  State<UnifiedAnalyticsScreen> createState() => _UnifiedAnalyticsScreenState();
}

class _UnifiedAnalyticsScreenState extends State<UnifiedAnalyticsScreen>
    with TickerProviderStateMixin {
  late TabController _tabController;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  
  String _selectedDateRange = 'Last 7 days';
  bool _autoRefresh = true;
  bool _comparisonMode = false;
  String _selectedFilter = 'All';
  String _selectedPlatform = 'All';

  final List<Map<String, dynamic>> _mockMetrics = [
{ "title": "Total Revenue",
"value": "\$24,580",
"change": "+12.5%",
"isPositive": true,
"icon": "attach_money",
"color": AppTheme.success },
{ "title": "Leads Generated",
"value": "1,247",
"change": "+8.3%",
"isPositive": true,
"icon": "people",
"color": AppTheme.accent },
{ "title": "Social Followers",
"value": "15.2K",
"change": "+15.7%",
"isPositive": true,
"icon": "thumb_up",
"color": AppTheme.primaryAction },
{ "title": "Link Clicks",
"value": "3,482",
"change": "+22.1%",
"isPositive": true,
"icon": "link",
"color": AppTheme.warning },
{ "title": "Conversion Rate",
"value": "3.8%",
"change": "+0.5%",
"isPositive": true,
"icon": "trending_up",
"color": AppTheme.success },
{ "title": "Engagement Rate",
"value": "4.2%",
"change": "+8.3%",
"isPositive": true,
"icon": "favorite",
"color": AppTheme.error }
];

  final List<String> _filterOptions = [
    'All',
    'Revenue',
    'Social Media',
    'Link in Bio',
    'Courses',
    'CRM',
    'Marketplace'
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 5, vsync: this);
    _setupAnimations();
  }

  void _setupAnimations() {
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1000),
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
                      child: Column(
                        children: [
                          _buildHeader(),
                          _buildFilterChips(),
                          Expanded(
                            child: TabBarView(
                              controller: _tabController,
                              children: [
                                _buildOverviewTab(),
                                _buildSocialMediaTab(),
                                _buildLinkInBioTab(),
                                _buildRevenueTab(),
                                _buildRealTimeTab(),
                              ],
                            ),
                          ),
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
            onPressed: _toggleAutoRefresh,
            icon: Icon(
              _autoRefresh ? Icons.refresh : Icons.refresh_outlined,
              color: _autoRefresh ? AppTheme.accent : AppTheme.secondaryText,
            ),
          ),
        ),
        Container(
          margin: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: AppTheme.surface,
            borderRadius: BorderRadius.circular(12),
          ),
          child: IconButton(
            onPressed: _showExportOptions,
            icon: const Icon(Icons.file_download, color: AppTheme.primaryText),
          ),
        ),
        Container(
          margin: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: AppTheme.surface,
            borderRadius: BorderRadius.circular(12),
          ),
          child: PopupMenuButton<String>(
            onSelected: _handleMenuSelection,
            color: AppTheme.surface,
            icon: const Icon(Icons.more_vert, color: AppTheme.primaryText),
            itemBuilder: (context) => [
              PopupMenuItem(
                value: 'comparison',
                child: Row(
                  children: [
                    Icon(
                      Icons.compare_arrows,
                      color: AppTheme.primaryText,
                      size: 20,
                    ),
                    const SizedBox(width: 12),
                    Text(
                      'Comparison Mode',
                      style: GoogleFonts.inter(
                        color: AppTheme.primaryText,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              PopupMenuItem(
                value: 'custom_report',
                child: Row(
                  children: [
                    Icon(
                      Icons.dashboard_customize,
                      color: AppTheme.primaryText,
                      size: 20,
                    ),
                    const SizedBox(width: 12),
                    Text(
                      'Custom Report',
                      style: GoogleFonts.inter(
                        color: AppTheme.primaryText,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              PopupMenuItem(
                value: 'scheduled_reports',
                child: Row(
                  children: [
                    Icon(
                      Icons.schedule,
                      color: AppTheme.primaryText,
                      size: 20,
                    ),
                    const SizedBox(width: 12),
                    Text(
                      'Scheduled Reports',
                      style: GoogleFonts.inter(
                        color: AppTheme.primaryText,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
      flexibleSpace: FlexibleSpaceBar(
        title: Text(
          'Analytics Dashboard',
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
              Tab(text: 'Social Media'),
              Tab(text: 'Link in Bio'),
              Tab(text: 'Revenue'),
              Tab(text: 'Real Time'),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppTheme.surface,
        border: Border(
          bottom: BorderSide(
            color: AppTheme.border.withAlpha(77),
            width: 1,
          ),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: DateRangeSelectorWidget(
              selectedRange: _selectedDateRange,
              onRangeChanged: (range) {
                setState(() {
                  _selectedDateRange = range;
                });
              },
            ),
          ),
          const SizedBox(width: 16),
          Container(
            decoration: BoxDecoration(
              color: AppTheme.accent.withAlpha(26),
              borderRadius: BorderRadius.circular(12),
            ),
            child: ExportButtonWidget(onExport: _showExportOptions),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChips() {
    return Container(
      height: 60,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: _filterOptions.length,
        itemBuilder: (context, index) {
          final filter = _filterOptions[index];
          return Padding(
            padding: const EdgeInsets.only(right: 12),
            child: FilterChipWidget(
              label: filter,
              isSelected: _selectedFilter == filter,
              onSelected: (selected) {
                setState(() {
                  _selectedFilter = selected ? filter : 'All';
                });
              },
            ),
          );
        },
      ),
    );
  }

  Widget _buildOverviewTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildMetricsGrid(),
          const SizedBox(height: 32),
          _buildMainChart(),
          const SizedBox(height: 32),
          _buildQuickInsights(),
          const SizedBox(height: 32),
          _buildTopPerformers(),
        ],
      ),
    );
  }

  Widget _buildSocialMediaTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          MetricsOverviewWidget(
            dateRange: _selectedDateRange,
            selectedPlatforms: const ['Instagram', 'Twitter'],
          ),
          const SizedBox(height: 24),
          PlatformTabsWidget(
            activePlatform: 'Instagram',
            selectedPlatforms: const ['Instagram', 'Twitter', 'Facebook'],
            onPlatformSelected: (platform) {
              setState(() {
                _selectedPlatform = platform;
              });
            },
          ),
          const SizedBox(height: 24),
          EngagementChartWidget(
            dateRange: _selectedDateRange,
            selectedPlatforms: const ['Instagram', 'Twitter'],
          ),
          const SizedBox(height: 24),
          AudienceInsightsWidget(
            dateRange: _selectedDateRange,
            selectedPlatforms: const ['Instagram', 'Twitter'],
          ),
        ],
      ),
    );
  }

  Widget _buildLinkInBioTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AnalyticsChartsWidget(
            dateRange: _selectedDateRange,
            selectedMetric: 'Clicks',
            onMetricChanged: (metric) {},
          ),
          const SizedBox(height: 24),
          ConversionFunnelWidget(
            dateRange: _selectedDateRange,
          ),
          const SizedBox(height: 24),
          _buildLinkPerformanceMetrics(),
        ],
      ),
    );
  }

  Widget _buildRevenueTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          _buildRevenueChart(),
          const SizedBox(height: 24),
          _buildRevenueBreakdown(),
          const SizedBox(height: 24),
          _buildMonthlyTrends(),
        ],
      ),
    );
  }

  Widget _buildRealTimeTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          const RealTimeTrackingWidget(),
          const SizedBox(height: 24),
          _buildLiveMetrics(),
          const SizedBox(height: 24),
          _buildActiveUsers(),
        ],
      ),
    );
  }

  Widget _buildMetricsGrid() {
    return SizedBox(
      height: 180,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: _mockMetrics.length,
        itemBuilder: (context, index) {
          final metric = _mockMetrics[index];
          return Container(
            width: 200,
            margin: const EdgeInsets.only(right: 16),
            child: _buildEnhancedMetricCard(
              title: metric["title"] as String,
              value: metric["value"] as String,
              change: metric["change"] as String,
              isPositive: metric["isPositive"] as bool,
              iconName: metric["icon"] as String,
              color: metric["color"] as Color,
            ),
          );
        },
      ),
    );
  }

  Widget _buildEnhancedMetricCard({
    required String title,
    required String value,
    required String change,
    required bool isPositive,
    required String iconName,
    required Color color,
  }) {
    return Container(
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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: color.withAlpha(26),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  _getIconData(iconName),
                  color: color,
                  size: 24,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: isPositive ? AppTheme.success.withAlpha(26) : AppTheme.error.withAlpha(26),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  change,
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: isPositive ? AppTheme.success : AppTheme.error,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            value,
            style: GoogleFonts.inter(
              fontSize: 28,
              fontWeight: FontWeight.w700,
              color: AppTheme.primaryText,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: GoogleFonts.inter(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: AppTheme.secondaryText,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMainChart() {
    return Container(
      padding: const EdgeInsets.all(20),
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
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Performance Overview',
                style: GoogleFonts.inter(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: AppTheme.primaryText,
                ),
              ),
              Icon(
                Icons.trending_up,
                color: AppTheme.accent,
                size: 24,
              ),
            ],
          ),
          const SizedBox(height: 20),
          Container(
            height: 200,
            child: Center(
              child: Text(
                'Interactive Chart Placeholder',
                style: GoogleFonts.inter(
                  fontSize: 16,
                  color: AppTheme.secondaryText,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickInsights() {
    return Container(
      padding: const EdgeInsets.all(20),
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
                Icons.lightbulb_outline,
                color: AppTheme.accent,
                size: 24,
              ),
              const SizedBox(width: 8),
              Text(
                'Quick Insights',
                style: GoogleFonts.inter(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: AppTheme.primaryText,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          _buildInsightItem(
            'Best performing platform',
            'Instagram with 4.2% engagement',
            Icons.trending_up,
            AppTheme.success,
          ),
          _buildInsightItem(
            'Peak activity time',
            'Tuesday 2-4 PM',
            Icons.schedule,
            AppTheme.accent,
          ),
          _buildInsightItem(
            'Top converting link',
            'Course landing page (8.3%)',
            Icons.link,
            AppTheme.primaryAction,
          ),
        ],
      ),
    );
  }

  Widget _buildInsightItem(String title, String value, IconData icon, Color color) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.surfaceVariant,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withAlpha(26),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              icon,
              color: color,
              size: 20,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: AppTheme.secondaryText,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: GoogleFonts.inter(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.primaryText,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTopPerformers() {
    return Container(
      padding: const EdgeInsets.all(20),
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
                Icons.star_outline,
                color: AppTheme.warning,
                size: 24,
              ),
              const SizedBox(width: 8),
              Text(
                'Top Performers',
                style: GoogleFonts.inter(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: AppTheme.primaryText,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          _buildPerformerItem('Instagram Post', '2.4K engagements', '1'),
          _buildPerformerItem('Course Landing Page', '186 conversions', '2'),
          _buildPerformerItem('Newsletter Link', '89 clicks', '3'),
        ],
      ),
    );
  }

  Widget _buildPerformerItem(String title, String metric, String rank) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.surfaceVariant,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: AppTheme.accent.withAlpha(26),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Center(
              child: Text(
                rank,
                style: GoogleFonts.inter(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: AppTheme.accent,
                ),
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.inter(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.primaryText,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  metric,
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    color: AppTheme.secondaryText,
                  ),
                ),
              ],
            ),
          ),
          Icon(
            Icons.arrow_forward_ios,
            color: AppTheme.secondaryText,
            size: 16,
          ),
        ],
      ),
    );
  }

  Widget _buildLinkPerformanceMetrics() {
    return Container(
      padding: const EdgeInsets.all(20),
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
              const SizedBox(width: 8),
              Text(
                'Link Performance',
                style: GoogleFonts.inter(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: AppTheme.primaryText,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          _buildLinkMetricRow('Total Clicks', '3,482', '+22.1%'),
          _buildLinkMetricRow('Unique Visitors', '2,847', '+18.5%'),
          _buildLinkMetricRow('Conversion Rate', '3.8%', '+0.5%'),
          _buildLinkMetricRow('Bounce Rate', '24.2%', '-2.1%'),
        ],
      ),
    );
  }

  Widget _buildLinkMetricRow(String label, String value, String change) {
    final isPositive = change.startsWith('+');
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.surfaceVariant,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: GoogleFonts.inter(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: AppTheme.primaryText,
            ),
          ),
          Row(
            children: [
              Text(
                value,
                style: GoogleFonts.inter(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: AppTheme.primaryText,
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: isPositive ? AppTheme.success.withAlpha(26) : AppTheme.error.withAlpha(26),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  change,
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: isPositive ? AppTheme.success : AppTheme.error,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildRevenueChart() {
    return Container(
      padding: const EdgeInsets.all(20),
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
                Icons.attach_money,
                color: AppTheme.success,
                size: 24,
              ),
              const SizedBox(width: 8),
              Text(
                'Revenue Overview',
                style: GoogleFonts.inter(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: AppTheme.primaryText,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Container(
            height: 200,
            child: Center(
              child: Text(
                'Revenue Chart Implementation',
                style: GoogleFonts.inter(
                  fontSize: 16,
                  color: AppTheme.secondaryText,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRevenueBreakdown() {
    return Container(
      padding: const EdgeInsets.all(20),
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
                Icons.pie_chart,
                color: AppTheme.accent,
                size: 24,
              ),
              const SizedBox(width: 8),
              Text(
                'Revenue Breakdown',
                style: GoogleFonts.inter(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: AppTheme.primaryText,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          _buildRevenueItem('Course Sales', '\$12,580', '51.2%', AppTheme.success),
          _buildRevenueItem('Marketplace', '\$7,890', '32.1%', AppTheme.accent),
          _buildRevenueItem('Subscriptions', '\$3,210', '13.1%', AppTheme.warning),
          _buildRevenueItem('Services', '\$900', '3.6%', AppTheme.error),
        ],
      ),
    );
  }

  Widget _buildRevenueItem(String category, String amount, String percentage, Color color) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.surfaceVariant,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Container(
            width: 4,
            height: 40,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  category,
                  style: GoogleFonts.inter(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.primaryText,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  amount,
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    color: AppTheme.secondaryText,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: color.withAlpha(26),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              percentage,
              style: GoogleFonts.inter(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: color,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMonthlyTrends() {
    return Container(
      padding: const EdgeInsets.all(20),
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
                Icons.trending_up,
                color: AppTheme.success,
                size: 24,
              ),
              const SizedBox(width: 8),
              Text(
                'Monthly Trends',
                style: GoogleFonts.inter(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: AppTheme.primaryText,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Container(
            height: 120,
            child: Center(
              child: Text(
                'Monthly Trends Chart',
                style: GoogleFonts.inter(
                  fontSize: 16,
                  color: AppTheme.secondaryText,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLiveMetrics() {
    return Container(
      padding: const EdgeInsets.all(20),
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
              Container(
                width: 12,
                height: 12,
                decoration: BoxDecoration(
                  color: AppTheme.success,
                  borderRadius: BorderRadius.circular(6),
                ),
              ),
              const SizedBox(width: 8),
              Text(
                'Live Metrics',
                style: GoogleFonts.inter(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: AppTheme.primaryText,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          _buildLiveMetricItem('Active Users', '147', AppTheme.success),
          _buildLiveMetricItem('Current Sessions', '89', AppTheme.accent),
          _buildLiveMetricItem('Page Views/min', '23', AppTheme.warning),
          _buildLiveMetricItem('Bounce Rate', '24.2%', AppTheme.error),
        ],
      ),
    );
  }

  Widget _buildLiveMetricItem(String label, String value, Color color) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.surfaceVariant,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: GoogleFonts.inter(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: AppTheme.primaryText,
            ),
          ),
          Text(
            value,
            style: GoogleFonts.inter(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActiveUsers() {
    return Container(
      padding: const EdgeInsets.all(20),
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
                Icons.people,
                color: AppTheme.accent,
                size: 24,
              ),
              const SizedBox(width: 8),
              Text(
                'Active Users',
                style: GoogleFonts.inter(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: AppTheme.primaryText,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Container(
            height: 120,
            child: Center(
              child: Text(
                'Active Users Chart',
                style: GoogleFonts.inter(
                  fontSize: 16,
                  color: AppTheme.secondaryText,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  IconData _getIconData(String iconName) {
    switch (iconName) {
      case 'attach_money':
        return Icons.attach_money;
      case 'people':
        return Icons.people;
      case 'thumb_up':
        return Icons.thumb_up;
      case 'link':
        return Icons.link;
      case 'trending_up':
        return Icons.trending_up;
      case 'favorite':
        return Icons.favorite;
      default:
        return Icons.help_outline;
    }
  }

  Future<void> _refreshData() async {
    await Future.delayed(const Duration(seconds: 2));
    setState(() {
      // Refresh data logic here
    });
  }

  void _toggleAutoRefresh() {
    setState(() {
      _autoRefresh = !_autoRefresh;
    });
  }

  void _showExportOptions() {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppTheme.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Export Options',
                style: GoogleFonts.inter(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: AppTheme.primaryText,
                ),
              ),
              const SizedBox(height: 20),
              _buildExportOption(
                icon: Icons.picture_as_pdf,
                title: 'Export as PDF',
                color: AppTheme.error,
                onTap: () {
                  Navigator.pop(context);
                  _exportToPDF();
                },
              ),
              _buildExportOption(
                icon: Icons.table_chart,
                title: 'Export as CSV',
                color: AppTheme.success,
                onTap: () {
                  Navigator.pop(context);
                  _exportToCSV();
                },
              ),
              _buildExportOption(
                icon: Icons.business,
                title: 'White-label Report',
                color: AppTheme.accent,
                onTap: () {
                  Navigator.pop(context);
                  _exportWhiteLabel();
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildExportOption({
    required IconData icon,
    required String title,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: ListTile(
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: color.withAlpha(26),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: color, size: 24),
        ),
        title: Text(
          title,
          style: GoogleFonts.inter(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: AppTheme.primaryText,
          ),
        ),
        onTap: onTap,
      ),
    );
  }

  void _handleMenuSelection(String value) {
    switch (value) {
      case 'comparison':
        setState(() {
          _comparisonMode = !_comparisonMode;
        });
        break;
      case 'custom_report':
        _showCustomReportBuilder();
        break;
      case 'scheduled_reports':
        _showScheduledReports();
        break;
    }
  }

  void _exportToPDF() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Exporting to PDF...'),
        backgroundColor: AppTheme.surface,
      ),
    );
  }

  void _exportToCSV() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Exporting to CSV...'),
        backgroundColor: AppTheme.surface,
      ),
    );
  }

  void _exportWhiteLabel() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Generating white-label report...'),
        backgroundColor: AppTheme.surface,
      ),
    );
  }

  void _showCustomReportBuilder() {
    Navigator.pushNamed(context, '/custom-report-builder');
  }

  void _showScheduledReports() {
    Navigator.pushNamed(context, '/scheduled-reports');
  }
}