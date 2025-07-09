
import '../../core/app_export.dart';
import '../analytics_dashboard/widgets/chart_container_widget.dart';
import '../analytics_dashboard/widgets/date_range_selector_widget.dart';
import '../analytics_dashboard/widgets/export_button_widget.dart';
import '../analytics_dashboard/widgets/filter_chip_widget.dart';
import '../analytics_dashboard/widgets/metric_card_widget.dart';
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
  String _selectedDateRange = 'Last 7 days';
  bool _autoRefresh = true;
  bool _comparisonMode = false;
  String _selectedFilter = 'All';

  final List<Map<String, dynamic>> _mockMetrics = [
{ "title": "Total Revenue",
"value": "\$24,580",
"change": "+12.5%",
"isPositive": true,
"icon": "attach_money" },
{ "title": "Leads Generated",
"value": "1,247",
"change": "+8.3%",
"isPositive": true,
"icon": "people" },
{ "title": "Social Followers",
"value": "15.2K",
"change": "+15.7%",
"isPositive": true,
"icon": "thumb_up" },
{ "title": "Link Clicks",
"value": "3,482",
"change": "+22.1%",
"isPositive": true,
"icon": "link" },
{ "title": "Conversion Rate",
"value": "3.8%",
"change": "+0.5%",
"isPositive": true,
"icon": "trending_up" },
{ "title": "Engagement Rate",
"value": "4.2%",
"change": "+8.3%",
"isPositive": true,
"icon": "favorite" }
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
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.primaryBackground,
      appBar: _buildAppBar(),
      body: RefreshIndicator(
        onRefresh: _refreshData,
        color: AppTheme.accent,
        backgroundColor: AppTheme.surface,
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
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      title: Text(
        'Analytics Dashboard',
        style: AppTheme.darkTheme.textTheme.titleLarge,
      ),
      backgroundColor: AppTheme.primaryBackground,
      elevation: 0,
      leading: IconButton(
        onPressed: () => Navigator.pop(context),
        icon: CustomIconWidget(
          iconName: 'arrow_back',
          color: AppTheme.primaryText,
          size: 24,
        ),
      ),
      actions: [
        IconButton(
          onPressed: _toggleAutoRefresh,
          icon: CustomIconWidget(
            iconName: _autoRefresh ? 'refresh' : 'refresh_outlined',
            color: _autoRefresh ? AppTheme.accent : AppTheme.secondaryText,
            size: 24,
          ),
        ),
        IconButton(
          onPressed: _showExportOptions,
          icon: CustomIconWidget(
            iconName: 'file_download',
            color: AppTheme.primaryText,
            size: 24,
          ),
        ),
        PopupMenuButton<String>(
          onSelected: _handleMenuSelection,
          color: AppTheme.surface,
          icon: CustomIconWidget(
            iconName: 'more_vert',
            color: AppTheme.primaryText,
            size: 24,
          ),
          itemBuilder: (context) => [
            PopupMenuItem(
              value: 'comparison',
              child: Row(
                children: [
                  CustomIconWidget(
                    iconName: 'compare_arrows',
                    color: AppTheme.primaryText,
                    size: 20,
                  ),
                  const SizedBox(width: 12),
                  Text(
                    'Comparison Mode',
                    style: AppTheme.darkTheme.textTheme.bodyMedium,
                  ),
                ],
              ),
            ),
            PopupMenuItem(
              value: 'custom_report',
              child: Row(
                children: [
                  CustomIconWidget(
                    iconName: 'dashboard_customize',
                    color: AppTheme.primaryText,
                    size: 20,
                  ),
                  const SizedBox(width: 12),
                  Text(
                    'Custom Report',
                    style: AppTheme.darkTheme.textTheme.bodyMedium,
                  ),
                ],
              ),
            ),
            PopupMenuItem(
              value: 'scheduled_reports',
              child: Row(
                children: [
                  CustomIconWidget(
                    iconName: 'schedule',
                    color: AppTheme.primaryText,
                    size: 20,
                  ),
                  const SizedBox(width: 12),
                  Text(
                    'Scheduled Reports',
                    style: AppTheme.darkTheme.textTheme.bodyMedium,
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
      bottom: TabBar(
        controller: _tabController,
        labelColor: AppTheme.primaryText,
        unselectedLabelColor: AppTheme.secondaryText,
        indicatorColor: AppTheme.accent,
        indicatorWeight: 2,
        labelStyle: AppTheme.darkTheme.textTheme.titleSmall,
        unselectedLabelStyle: AppTheme.darkTheme.textTheme.bodySmall,
        isScrollable: true,
        tabs: const [
          Tab(text: 'Overview'),
          Tab(text: 'Social Media'),
          Tab(text: 'Link in Bio'),
          Tab(text: 'Revenue'),
          Tab(text: 'Real Time'),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: EdgeInsets.all(4.w),
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
          SizedBox(width: 3.w),
          ExportButtonWidget(onExport: _showExportOptions),
        ],
      ),
    );
  }

  Widget _buildFilterChips() {
    return Container(
      height: 6.h,
      padding: EdgeInsets.symmetric(horizontal: 4.w),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: _filterOptions.length,
        itemBuilder: (context, index) {
          final filter = _filterOptions[index];
          return Padding(
            padding: EdgeInsets.only(right: 2.w),
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
      padding: EdgeInsets.all(4.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildMetricsRow(),
          SizedBox(height: 4.h),
          AnalyticsChartsWidget(
            dateRange: _selectedDateRange,
            selectedMetric: 'Visitors',
            onMetricChanged: (metric) {},
          ),
          SizedBox(height: 4.h),
          _buildQuickInsights(),
        ],
      ),
    );
  }

  Widget _buildSocialMediaTab() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(4.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          MetricsOverviewWidget(
            dateRange: _selectedDateRange,
            selectedPlatforms: const ['Instagram', 'Twitter'],
          ),
          SizedBox(height: 4.h),
          PlatformTabsWidget(
            activePlatform: 'Instagram',
            selectedPlatforms: const ['Instagram', 'Twitter', 'Facebook'],
            onPlatformSelected: (platform) {},
          ),
          SizedBox(height: 4.h),
          EngagementChartWidget(
            dateRange: _selectedDateRange,
            selectedPlatforms: const ['Instagram', 'Twitter'],
          ),
          SizedBox(height: 4.h),
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
      padding: EdgeInsets.all(4.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AnalyticsChartsWidget(
            dateRange: _selectedDateRange,
            selectedMetric: 'Clicks',
            onMetricChanged: (metric) {},
          ),
          SizedBox(height: 4.h),
          ConversionFunnelWidget(
            dateRange: _selectedDateRange,
          ),
          SizedBox(height: 4.h),
          _buildLinkPerformanceMetrics(),
        ],
      ),
    );
  }

  Widget _buildRevenueTab() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(4.w),
      child: Column(
        children: [
          _buildRevenueChart(),
          SizedBox(height: 4.h),
          _buildRevenueBreakdown(),
        ],
      ),
    );
  }

  Widget _buildRealTimeTab() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(4.w),
      child: Column(
        children: [
          const RealTimeTrackingWidget(),
          SizedBox(height: 4.h),
          _buildLiveMetrics(),
        ],
      ),
    );
  }

  Widget _buildMetricsRow() {
    return SizedBox(
      height: 20.h,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: _mockMetrics.length,
        itemBuilder: (context, index) {
          final metric = _mockMetrics[index];
          return Padding(
            padding: EdgeInsets.only(right: 3.w),
            child: MetricCardWidget(
              title: metric["title"] as String,
              value: metric["value"] as String,
              change: metric["change"] as String,
              isPositive: metric["isPositive"] as bool,
              iconName: metric["icon"] as String,
            ),
          );
        },
      ),
    );
  }

  Widget _buildQuickInsights() {
    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Quick Insights',
            style: AppTheme.darkTheme.textTheme.titleMedium,
          ),
          SizedBox(height: 2.h),
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
    return Padding(
      padding: EdgeInsets.only(bottom: 2.h),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              icon,
              color: color,
              size: 16,
            ),
          ),
          SizedBox(width: 3.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppTheme.darkTheme.textTheme.bodySmall?.copyWith(
                    color: AppTheme.secondaryText,
                  ),
                ),
                Text(
                  value,
                  style: AppTheme.darkTheme.textTheme.bodyMedium,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLinkPerformanceMetrics() {
    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Link Performance',
            style: AppTheme.darkTheme.textTheme.titleMedium,
          ),
          SizedBox(height: 2.h),
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
    return Padding(
      padding: EdgeInsets.only(bottom: 2.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: AppTheme.darkTheme.textTheme.bodyMedium,
          ),
          Row(
            children: [
              Text(
                value,
                style: AppTheme.darkTheme.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(width: 2.w),
              Text(
                change,
                style: AppTheme.darkTheme.textTheme.bodySmall?.copyWith(
                  color: isPositive ? AppTheme.success : AppTheme.error,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildRevenueChart() {
    return ChartContainerWidget(
      title: 'Revenue Overview',
      child: Container(
        height: 30.h,
        child: Center(
          child: Text(
            'Revenue chart implementation',
            style: AppTheme.darkTheme.textTheme.bodyMedium,
          ),
        ),
      ),
    );
  }

  Widget _buildRevenueBreakdown() {
    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Revenue Breakdown',
            style: AppTheme.darkTheme.textTheme.titleMedium,
          ),
          SizedBox(height: 2.h),
          _buildRevenueItem('Course Sales', '\$12,580', '51.2%'),
          _buildRevenueItem('Marketplace', '\$7,890', '32.1%'),
          _buildRevenueItem('Subscriptions', '\$3,210', '13.1%'),
          _buildRevenueItem('Services', '\$900', '3.6%'),
        ],
      ),
    );
  }

  Widget _buildRevenueItem(String category, String amount, String percentage) {
    return Padding(
      padding: EdgeInsets.only(bottom: 2.h),
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: Text(
              category,
              style: AppTheme.darkTheme.textTheme.bodyMedium,
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              amount,
              style: AppTheme.darkTheme.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.right,
            ),
          ),
          Expanded(
            child: Text(
              percentage,
              style: AppTheme.darkTheme.textTheme.bodySmall?.copyWith(
                color: AppTheme.secondaryText,
              ),
              textAlign: TextAlign.right,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLiveMetrics() {
    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  color: AppTheme.success,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
              SizedBox(width: 2.w),
              Text(
                'Live Metrics',
                style: AppTheme.darkTheme.textTheme.titleMedium,
              ),
            ],
          ),
          SizedBox(height: 2.h),
          _buildLiveMetricItem('Active Users', '147'),
          _buildLiveMetricItem('Current Sessions', '89'),
          _buildLiveMetricItem('Page Views/min', '23'),
          _buildLiveMetricItem('Bounce Rate', '24.2%'),
        ],
      ),
    );
  }

  Widget _buildLiveMetricItem(String label, String value) {
    return Padding(
      padding: EdgeInsets.only(bottom: 2.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: AppTheme.darkTheme.textTheme.bodyMedium,
          ),
          Text(
            value,
            style: AppTheme.darkTheme.textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w600,
              color: AppTheme.success,
            ),
          ),
        ],
      ),
    );
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
          padding: EdgeInsets.all(4.w),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Export Options',
                style: AppTheme.darkTheme.textTheme.titleMedium,
              ),
              SizedBox(height: 2.h),
              ListTile(
                leading: CustomIconWidget(
                  iconName: 'picture_as_pdf',
                  color: AppTheme.error,
                  size: 24,
                ),
                title: Text(
                  'Export as PDF',
                  style: AppTheme.darkTheme.textTheme.bodyMedium,
                ),
                onTap: () {
                  Navigator.pop(context);
                  _exportToPDF();
                },
              ),
              ListTile(
                leading: CustomIconWidget(
                  iconName: 'table_chart',
                  color: AppTheme.success,
                  size: 24,
                ),
                title: Text(
                  'Export as CSV',
                  style: AppTheme.darkTheme.textTheme.bodyMedium,
                ),
                onTap: () {
                  Navigator.pop(context);
                  _exportToCSV();
                },
              ),
              ListTile(
                leading: CustomIconWidget(
                  iconName: 'business',
                  color: AppTheme.accent,
                  size: 24,
                ),
                title: Text(
                  'White-label Report',
                  style: AppTheme.darkTheme.textTheme.bodyMedium,
                ),
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