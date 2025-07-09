
import '../../core/app_export.dart';
import '../../services/analytics_data_service.dart';
import '../../services/workspace_service.dart';
import './widgets/chart_container_widget.dart';
import './widgets/date_range_selector_widget.dart';
import './widgets/export_button_widget.dart';
import './widgets/filter_chip_widget.dart';
import './widgets/metric_card_widget.dart';

class AnalyticsDashboard extends StatefulWidget {
  const AnalyticsDashboard({Key? key}) : super(key: key);

  @override
  State<AnalyticsDashboard> createState() => _AnalyticsDashboardState();
}

class _AnalyticsDashboardState extends State<AnalyticsDashboard>
    with TickerProviderStateMixin {
  late TabController _tabController;
  String _selectedDateRange = 'Last 7 days';
  bool _autoRefresh = true;
  bool _comparisonMode = false;
  String _selectedFilter = 'All';
  bool _isLoading = false;
  
  final AnalyticsDataService _analyticsService = AnalyticsDataService();
  final WorkspaceService _workspaceService = WorkspaceService();
  
  Map<String, dynamic> _dashboardData = {};
  List<Map<String, dynamic>> _metrics = [];
  List<Map<String, dynamic>> _revenueData = [];
  List<Map<String, dynamic>> _socialData = [];
  String? _currentWorkspaceId;

  final List<String> _filterOptions = [
    'All',
    'Revenue',
    'Social Media',
    'Courses',
    'CRM',
    'Marketplace'
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    _loadAnalyticsData();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _loadAnalyticsData() async {
    setState(() {
      _isLoading = true;
    });

    try {
      // Get current workspace
      final workspaces = await _workspaceService.getUserWorkspaces();
      if (workspaces.isNotEmpty) {
        _currentWorkspaceId = workspaces.first['id'];
        
        // Load dashboard data
        final dashboardData = await _analyticsService.getDashboardData(_currentWorkspaceId!);
        
        // Load metrics
        final metrics = await _analyticsService.getAnalyticsMetrics(_currentWorkspaceId!);
        
        // Load revenue data
        final revenueData = await _analyticsService.getRevenueAnalytics(_currentWorkspaceId!);
        
        // Load social media data
        final socialData = await _analyticsService.getSocialMediaAnalytics(_currentWorkspaceId!);
        
        setState(() {
          _dashboardData = dashboardData;
          _metrics = _buildMetricsFromData(dashboardData);
          _revenueData = _buildRevenueChartData(revenueData);
          _socialData = _buildSocialChartData(socialData);
        });
        
        // Track analytics view
        await _analyticsService.trackEvent('analytics_dashboard_viewed', {
          'date_range': _selectedDateRange,
          'filter': _selectedFilter,
        }, workspaceId: _currentWorkspaceId);
      }
    } catch (e) {
      if (kDebugMode) {
        debugPrint('Failed to load analytics data: $e');
      }
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  List<Map<String, dynamic>> _buildMetricsFromData(Map<String, dynamic> data) {
    final revenue = data['revenue'] ?? {};
    final social = data['social_media'] ?? {};
    final products = data['products'] ?? {};
    final notifications = data['notifications'] ?? {};
    
    return [
      {
        "title": "Total Revenue",
        "value": "\$${(revenue['total_revenue'] ?? 0).toStringAsFixed(2)}",
        "change": "+12.5%", // This could be calculated from historical data
        "isPositive": true,
        "icon": "attach_money"
      },
      {
        "title": "Total Orders",
        "value": (revenue['total_orders'] ?? 0).toString(),
        "change": "+8.3%",
        "isPositive": true,
        "icon": "shopping_cart"
      },
      {
        "title": "Social Followers",
        "value": _formatNumber(social['total_followers'] ?? 0),
        "change": "+15.7%",
        "isPositive": true,
        "icon": "thumb_up"
      },
      {
        "title": "Active Products",
        "value": (products['active_products'] ?? 0).toString(),
        "change": "+4.2%",
        "isPositive": true,
        "icon": "inventory"
      },
      {
        "title": "Conversion Rate",
        "value": "${(revenue['conversion_rate'] ?? 0).toStringAsFixed(1)}%",
        "change": "+0.5%",
        "isPositive": true,
        "icon": "trending_up"
      },
      {
        "title": "Notifications",
        "value": (notifications['total_notifications'] ?? 0).toString(),
        "change": "+2.1%",
        "isPositive": true,
        "icon": "notifications"
      },
    ];
  }

  List<Map<String, dynamic>> _buildRevenueChartData(List<Map<String, dynamic>> data) {
    // Convert analytics data to chart format
    final Map<String, double> dailyRevenue = {};
    
    for (final metric in data) {
      final date = metric['date_bucket'] as String;
      final value = (metric['metric_value'] as num).toDouble();
      
      if (metric['metric_name'] == 'total_revenue') {
        dailyRevenue[date] = value;
      }
    }
    
    // Generate last 7 days
    final chartData = <Map<String, dynamic>>[];
    for (int i = 6; i >= 0; i--) {
      final date = DateTime.now().subtract(Duration(days: i));
      final dateStr = date.toIso8601String().split('T')[0];
      final dayName = _getDayName(date.weekday);
      
      chartData.add({
        "day": dayName,
        "value": dailyRevenue[dateStr] ?? 0.0,
      });
    }
    
    return chartData;
  }

  List<Map<String, dynamic>> _buildSocialChartData(List<Map<String, dynamic>> data) {
    final Map<String, Map<String, double>> platformData = {};
    
    for (final metric in data) {
      final platform = metric['social_media_accounts']['platform'] as String;
      final metricName = metric['metric_name'] as String;
      final value = (metric['metric_value'] as num).toDouble();
      
      if (!platformData.containsKey(platform)) {
        platformData[platform] = {};
      }
      
      platformData[platform]![metricName] = value;
    }
    
    return platformData.entries.map((entry) {
      return {
        "platform": entry.key,
        "followers": (entry.value['followers'] ?? 0).toInt(),
        "engagement": entry.value['engagement_rate'] ?? 0.0,
      };
    }).toList();
  }

  String _getDayName(int weekday) {
    const days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    return days[weekday - 1];
  }

  String _formatNumber(num value) {
    if (value >= 1000000) {
      return "${(value / 1000000).toStringAsFixed(1)}M";
    } else if (value >= 1000) {
      return "${(value / 1000).toStringAsFixed(1)}K";
    }
    return value.toString();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: AppTheme.primaryBackground,
        appBar: _buildAppBar(),
        body: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : RefreshIndicator(
                onRefresh: _refreshData,
                color: AppTheme.accent,
                backgroundColor: AppTheme.surface,
                child: Column(children: [
                  _buildHeader(),
                  _buildFilterChips(),
                  Expanded(
                      child: TabBarView(controller: _tabController, children: [
                    _buildOverviewTab(),
                    _buildRevenueTab(),
                    _buildSocialTab(),
                    _buildCoursesTab(),
                  ])),
                ])));
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
        title: Text('Analytics Dashboard',
            style: AppTheme.darkTheme.textTheme.titleLarge),
        backgroundColor: AppTheme.primaryBackground,
        elevation: 0,
        leading: IconButton(
            onPressed: () => Navigator.pop(context),
            icon: CustomIconWidget(
                iconName: 'arrow_back', color: AppTheme.primaryText, size: 24)),
        actions: [
          IconButton(
              onPressed: _toggleAutoRefresh,
              icon: CustomIconWidget(
                  iconName: _autoRefresh ? 'refresh' : 'refresh_outlined',
                  color:
                      _autoRefresh ? AppTheme.accent : AppTheme.secondaryText,
                  size: 24)),
          IconButton(
              onPressed: _showExportOptions,
              icon: CustomIconWidget(
                  iconName: 'file_download',
                  color: AppTheme.primaryText,
                  size: 24)),
          PopupMenuButton<String>(
              onSelected: _handleMenuSelection,
              color: AppTheme.surface,
              icon: CustomIconWidget(
                  iconName: 'more_vert', color: AppTheme.primaryText, size: 24),
              itemBuilder: (context) => [
                    PopupMenuItem(
                        value: 'comparison',
                        child: Row(children: [
                          CustomIconWidget(
                              iconName: 'compare_arrows',
                              color: AppTheme.primaryText,
                              size: 20),
                          SizedBox(width: 12),
                          Text('Comparison Mode',
                              style: AppTheme.darkTheme.textTheme.bodyMedium),
                        ])),
                    PopupMenuItem(
                        value: 'custom_report',
                        child: Row(children: [
                          CustomIconWidget(
                              iconName: 'dashboard_customize',
                              color: AppTheme.primaryText,
                              size: 20),
                          SizedBox(width: 12),
                          Text('Custom Report',
                              style: AppTheme.darkTheme.textTheme.bodyMedium),
                        ])),
                    PopupMenuItem(
                        value: 'scheduled_reports',
                        child: Row(children: [
                          CustomIconWidget(
                              iconName: 'schedule',
                              color: AppTheme.primaryText,
                              size: 20),
                          SizedBox(width: 12),
                          Text('Scheduled Reports',
                              style: AppTheme.darkTheme.textTheme.bodyMedium),
                        ])),
                  ]),
        ],
        bottom: TabBar(
            controller: _tabController,
            labelColor: AppTheme.primaryText,
            unselectedLabelColor: AppTheme.secondaryText,
            indicatorColor: AppTheme.accent,
            indicatorWeight: 2,
            labelStyle: AppTheme.darkTheme.textTheme.titleSmall,
            unselectedLabelStyle: AppTheme.darkTheme.textTheme.bodySmall,
            tabs: const [
              Tab(text: 'Overview'),
              Tab(text: 'Revenue'),
              Tab(text: 'Social'),
              Tab(text: 'Courses'),
            ]));
  }

  Widget _buildHeader() {
    return Container(
        padding: EdgeInsets.all(4.w),
        child: Row(children: [
          Expanded(
              child: DateRangeSelectorWidget(
                  selectedRange: _selectedDateRange,
                  onRangeChanged: (range) {
                    setState(() {
                      _selectedDateRange = range;
                    });
                    _loadAnalyticsData();
                  })),
          SizedBox(width: 3.w),
          ExportButtonWidget(onExport: _showExportOptions),
        ]));
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
                        _loadAnalyticsData();
                      }));
            }));
  }

  Widget _buildOverviewTab() {
    return SingleChildScrollView(
        padding: EdgeInsets.all(4.w),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          _buildMetricsRow(),
          SizedBox(height: 4.h),
          _buildRevenueChart(),
          SizedBox(height: 4.h),
          _buildSocialPerformanceChart(),
        ]));
  }

  Widget _buildRevenueTab() {
    return SingleChildScrollView(
        padding: EdgeInsets.all(4.w),
        child: Column(children: [
          _buildRevenueChart(),
          SizedBox(height: 4.h),
          _buildRevenueBreakdown(),
        ]));
  }

  Widget _buildSocialTab() {
    return SingleChildScrollView(
        padding: EdgeInsets.all(4.w),
        child: Column(children: [
          _buildSocialPerformanceChart(),
          SizedBox(height: 4.h),
          _buildSocialMetrics(),
        ]));
  }

  Widget _buildCoursesTab() {
    return SingleChildScrollView(
        padding: EdgeInsets.all(4.w),
        child: Column(children: [
          _buildCourseEngagementChart(),
          SizedBox(height: 4.h),
          _buildCourseMetrics(),
        ]));
  }

  Widget _buildMetricsRow() {
    return SizedBox(
        height: 20.h,
        child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: _metrics.length,
            itemBuilder: (context, index) {
              final metric = _metrics[index];
              return Padding(
                  padding: EdgeInsets.only(right: 3.w),
                  child: MetricCardWidget(
                      title: metric["title"] as String,
                      value: metric["value"] as String,
                      change: metric["change"] as String,
                      isPositive: metric["isPositive"] as bool,
                      iconName: metric["icon"] as String));
            }));
  }

  Widget _buildRevenueChart() {
    return ChartContainerWidget(
        title: 'Revenue Trends',
        child: SizedBox(
            height: 30.h,
            child: _revenueData.isEmpty
                ? Center(
                    child: Text(
                      'No revenue data available',
                      style: AppTheme.darkTheme.textTheme.bodyMedium,
                    ),
                  )
                : LineChart(LineChartData(
                    gridData: FlGridData(
                        show: true,
                        drawVerticalLine: true,
                        horizontalInterval: 1000,
                        verticalInterval: 1,
                        getDrawingHorizontalLine: (value) {
                          return FlLine(
                              color: AppTheme.secondaryText.withValues(alpha: 0.3),
                              strokeWidth: 1);
                        },
                        getDrawingVerticalLine: (value) {
                          return FlLine(
                              color: AppTheme.secondaryText.withValues(alpha: 0.3),
                              strokeWidth: 1);
                        }),
                    titlesData: FlTitlesData(
                        show: true,
                        rightTitles:
                            AxisTitles(sideTitles: SideTitles(showTitles: false)),
                        topTitles:
                            AxisTitles(sideTitles: SideTitles(showTitles: false)),
                        bottomTitles: AxisTitles(
                            sideTitles: SideTitles(
                                showTitles: true,
                                reservedSize: 30,
                                interval: 1,
                                getTitlesWidget: (double value, TitleMeta meta) {
                                  if (value.toInt() < _revenueData.length) {
                                    return SideTitleWidget(
                                        axisSide: meta.axisSide,
                                        child: Text(
                                            _revenueData[value.toInt()]["day"]
                                                as String,
                                            style: AppTheme
                                                .darkTheme.textTheme.bodySmall));
                                  }
                                  return Container();
                                })),
                        leftTitles: AxisTitles(
                            sideTitles: SideTitles(
                                showTitles: true,
                                interval: 1000,
                                reservedSize: 42,
                                getTitlesWidget: (double value, TitleMeta meta) {
                                  return SideTitleWidget(
                                      axisSide: meta.axisSide,
                                      child: Text(
                                          '\$${(value / 1000).toStringAsFixed(0)}K',
                                          style: AppTheme
                                              .darkTheme.textTheme.bodySmall));
                                }))),
                    borderData: FlBorderData(
                        show: true,
                        border: Border.all(color: AppTheme.border, width: 1)),
                    minX: 0,
                    maxX: (_revenueData.length - 1).toDouble(),
                    minY: 0,
                    maxY: 6000,
                    lineBarsData: [
                      LineChartBarData(
                          spots: _revenueData.asMap().entries.map((entry) {
                            return FlSpot(entry.key.toDouble(),
                                (entry.value["value"] as double));
                          }).toList(),
                          isCurved: true,
                          gradient: LinearGradient(colors: [
                            AppTheme.accent,
                            AppTheme.accent.withValues(alpha: 0.3),
                          ]),
                          barWidth: 3,
                          isStrokeCapRound: true,
                          dotData: FlDotData(
                              show: true,
                              getDotPainter: (spot, percent, barData, index) {
                                return FlDotCirclePainter(
                                    radius: 4,
                                    color: AppTheme.primaryText,
                                    strokeWidth: 2,
                                    strokeColor: AppTheme.accent);
                              }),
                          belowBarData: BarAreaData(
                              show: true,
                              gradient: LinearGradient(
                                  colors: [
                                    AppTheme.accent.withValues(alpha: 0.3),
                                    AppTheme.accent.withValues(alpha: 0.1),
                                  ],
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter))),
                    ]))));
  }

  Widget _buildSocialPerformanceChart() {
    return ChartContainerWidget(
        title: 'Social Media Performance',
        child: SizedBox(
            height: 30.h,
            child: _socialData.isEmpty
                ? Center(
                    child: Text(
                      'No social media data available',
                      style: AppTheme.darkTheme.textTheme.bodyMedium,
                    ),
                  )
                : BarChart(BarChartData(
                    alignment: BarChartAlignment.spaceAround,
                    maxY: 10000,
                    barTouchData: BarTouchData(
                        touchTooltipData: BarTouchTooltipData(
                            tooltipHorizontalAlignment:
                                FLHorizontalAlignment.center,
                            tooltipMargin: -10,
                            getTooltipItem: (group, groupIndex, rod, rodIndex) {
                              String platform =
                                  _socialData[group.x.toInt()]
                                      ["platform"] as String;
                              return BarTooltipItem('$platform\n',
                                  AppTheme.darkTheme.textTheme.bodySmall!,
                                  children: <TextSpan>[
                                    TextSpan(
                                        text: '${rod.toY.round()} followers',
                                        style: AppTheme
                                            .darkTheme.textTheme.bodySmall
                                            ?.copyWith(color: AppTheme.accent)),
                                  ]);
                            })),
                    titlesData: FlTitlesData(
                        show: true,
                        rightTitles:
                            AxisTitles(sideTitles: SideTitles(showTitles: false)),
                        topTitles:
                            AxisTitles(sideTitles: SideTitles(showTitles: false)),
                        bottomTitles: AxisTitles(
                            sideTitles: SideTitles(
                                showTitles: true,
                                getTitlesWidget: (double value, TitleMeta meta) {
                                  if (value.toInt() <
                                      _socialData.length) {
                                    return SideTitleWidget(
                                        axisSide: meta.axisSide,
                                        child: Text(
                                            _socialData[value.toInt()]
                                                ["platform"] as String,
                                            style: AppTheme
                                                .darkTheme.textTheme.bodySmall));
                                  }
                                  return Container();
                                },
                                reservedSize: 38)),
                        leftTitles: AxisTitles(
                            sideTitles: SideTitles(
                                showTitles: true,
                                reservedSize: 28,
                                interval: 2000,
                                getTitlesWidget: (double value, TitleMeta meta) {
                                  return SideTitleWidget(
                                      axisSide: meta.axisSide,
                                      child: Text(
                                          '${(value / 1000).toStringAsFixed(0)}K',
                                          style: AppTheme
                                              .darkTheme.textTheme.bodySmall));
                                }))),
                    borderData: FlBorderData(show: false),
                    barGroups: _socialData.asMap().entries.map((entry) {
                      return BarChartGroupData(x: entry.key, barRods: [
                        BarChartRodData(
                            toY: (entry.value["followers"] as int).toDouble(),
                            color: AppTheme.accent,
                            width: 16,
                            borderRadius: BorderRadius.circular(4)),
                      ]);
                    }).toList()))));
  }

  Widget _buildCourseEngagementChart() {
    final List<Map<String, dynamic>> courseData = [
{"week": "Week 1", "completions": 45, "enrollments": 120},
{"week": "Week 2", "completions": 38, "enrollments": 95},
{"week": "Week 3", "completions": 52, "enrollments": 110},
{"week": "Week 4", "completions": 41, "enrollments": 88},
];

    return ChartContainerWidget(
        title: 'Course Engagement',
        child: SizedBox(
            height: 30.h,
            child: LineChart(LineChartData(
                gridData: FlGridData(
                    show: true,
                    drawVerticalLine: true,
                    horizontalInterval: 20,
                    verticalInterval: 1,
                    getDrawingHorizontalLine: (value) {
                      return FlLine(
                          color: AppTheme.secondaryText.withValues(alpha: 0.3),
                          strokeWidth: 1);
                    },
                    getDrawingVerticalLine: (value) {
                      return FlLine(
                          color: AppTheme.secondaryText.withValues(alpha: 0.3),
                          strokeWidth: 1);
                    }),
                titlesData: FlTitlesData(
                    show: true,
                    rightTitles:
                        AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    topTitles:
                        AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    bottomTitles: AxisTitles(
                        sideTitles: SideTitles(
                            showTitles: true,
                            reservedSize: 30,
                            interval: 1,
                            getTitlesWidget: (double value, TitleMeta meta) {
                              if (value.toInt() < courseData.length) {
                                return SideTitleWidget(
                                    axisSide: meta.axisSide,
                                    child: Text(
                                        courseData[value.toInt()]["week"]
                                            as String,
                                        style: AppTheme
                                            .darkTheme.textTheme.bodySmall));
                              }
                              return Container();
                            })),
                    leftTitles: AxisTitles(
                        sideTitles: SideTitles(
                            showTitles: true,
                            interval: 20,
                            reservedSize: 42,
                            getTitlesWidget: (double value, TitleMeta meta) {
                              return SideTitleWidget(
                                  axisSide: meta.axisSide,
                                  child: Text(value.toInt().toString(),
                                      style: AppTheme
                                          .darkTheme.textTheme.bodySmall));
                            }))),
                borderData: FlBorderData(
                    show: true,
                    border: Border.all(color: AppTheme.border, width: 1)),
                minX: 0,
                maxX: (courseData.length - 1).toDouble(),
                minY: 0,
                maxY: 140,
                lineBarsData: [
                  LineChartBarData(
                      spots: courseData.asMap().entries.map((entry) {
                        return FlSpot(entry.key.toDouble(),
                            (entry.value["completions"] as int).toDouble());
                      }).toList(),
                      isCurved: true,
                      color: AppTheme.success,
                      barWidth: 3,
                      isStrokeCapRound: true,
                      dotData: FlDotData(show: false),
                      belowBarData: BarAreaData(
                          show: true,
                          color: AppTheme.success.withValues(alpha: 0.2))),
                  LineChartBarData(
                      spots: courseData.asMap().entries.map((entry) {
                        return FlSpot(entry.key.toDouble(),
                            (entry.value["enrollments"] as int).toDouble());
                      }).toList(),
                      isCurved: true,
                      color: AppTheme.accent,
                      barWidth: 3,
                      isStrokeCapRound: true,
                      dotData: FlDotData(show: false)),
                ]))));
  }

  Widget _buildRevenueBreakdown() {
    final List<Map<String, dynamic>> revenueBreakdown = [
{"category": "Course Sales", "amount": 12580, "percentage": 51.2},
{"category": "Marketplace", "amount": 7890, "percentage": 32.1},
{"category": "Subscriptions", "amount": 3210, "percentage": 13.1},
{"category": "Services", "amount": 900, "percentage": 3.6},
];

    return Container(
        padding: EdgeInsets.all(4.w),
        decoration: BoxDecoration(
            color: AppTheme.surface, borderRadius: BorderRadius.circular(12)),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text('Revenue Breakdown',
              style: AppTheme.darkTheme.textTheme.titleMedium),
          SizedBox(height: 2.h),
          ...revenueBreakdown.map((item) {
            return Padding(
                padding: EdgeInsets.only(bottom: 2.h),
                child: Row(children: [
                  Expanded(
                      flex: 3,
                      child: Text(item["category"] as String,
                          style: AppTheme.darkTheme.textTheme.bodyMedium)),
                  Expanded(
                      flex: 2,
                      child: Text('\$${(item["amount"] as int).toString()}',
                          style: AppTheme.dataTextTheme.bodyMedium,
                          textAlign: TextAlign.right)),
                  Expanded(
                      child: Text(
                          '${(item["percentage"] as double).toStringAsFixed(1)}%',
                          style: AppTheme.darkTheme.textTheme.bodySmall
                              ?.copyWith(color: AppTheme.secondaryText),
                          textAlign: TextAlign.right)),
                ]));
          }).toList(),
        ]));
  }

  Widget _buildSocialMetrics() {
    return Container(
        padding: EdgeInsets.all(4.w),
        decoration: BoxDecoration(
            color: AppTheme.surface, borderRadius: BorderRadius.circular(12)),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text('Social Media Metrics',
              style: AppTheme.darkTheme.textTheme.titleMedium),
          SizedBox(height: 2.h),
          if (_socialData.isEmpty)
            Center(
              child: Text(
                'No social media data available',
                style: AppTheme.darkTheme.textTheme.bodyMedium,
              ),
            )
          else
            ..._socialData.map((platform) {
              return Padding(
                  padding: EdgeInsets.only(bottom: 2.h),
                  child: Row(children: [
                    Expanded(
                        flex: 2,
                        child: Text(platform["platform"] as String,
                            style: AppTheme.darkTheme.textTheme.bodyMedium)),
                    Expanded(
                        flex: 2,
                        child: Text(
                            '${(platform["followers"] as int).toString()} followers',
                            style: AppTheme.dataTextTheme.bodySmall,
                            textAlign: TextAlign.center)),
                    Expanded(
                        child: Text(
                            '${(platform["engagement"] as double).toStringAsFixed(1)}%',
                            style: AppTheme.darkTheme.textTheme.bodySmall
                                ?.copyWith(color: AppTheme.success),
                            textAlign: TextAlign.right)),
                  ]));
            }).toList(),
        ]));
  }

  Widget _buildCourseMetrics() {
    final List<Map<String, dynamic>> courseMetrics = [
{"title": "Active Courses", "value": "24", "change": "+3"},
{"title": "Total Students", "value": "1,247", "change": "+89"},
{"title": "Completion Rate", "value": "78.5%", "change": "+2.1%"},
{"title": "Average Rating", "value": "4.6", "change": "+0.2"},
];

    return Container(
        padding: EdgeInsets.all(4.w),
        decoration: BoxDecoration(
            color: AppTheme.surface, borderRadius: BorderRadius.circular(12)),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text('Course Performance',
              style: AppTheme.darkTheme.textTheme.titleMedium),
          SizedBox(height: 2.h),
          GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 3.w,
                  mainAxisSpacing: 2.h,
                  childAspectRatio: 2.5),
              itemCount: courseMetrics.length,
              itemBuilder: (context, index) {
                final metric = courseMetrics[index];
                return Container(
                    padding: EdgeInsets.all(3.w),
                    decoration: BoxDecoration(
                        color: AppTheme.primaryBackground,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: AppTheme.border, width: 1)),
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(metric["title"] as String,
                              style: AppTheme.darkTheme.textTheme.bodySmall
                                  ?.copyWith(color: AppTheme.secondaryText)),
                          Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(metric["value"] as String,
                                    style: AppTheme.dataTextTheme.titleMedium),
                                Text(metric["change"] as String,
                                    style: AppTheme
                                        .darkTheme.textTheme.bodySmall
                                        ?.copyWith(color: AppTheme.success)),
                              ]),
                        ]));
              }),
        ]));
  }

  Future<void> _refreshData() async {
    await _loadAnalyticsData();
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
                topLeft: Radius.circular(20), topRight: Radius.circular(20))),
        builder: (context) {
          return Container(
              padding: EdgeInsets.all(4.w),
              child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Export Options',
                        style: AppTheme.darkTheme.textTheme.titleMedium),
                    SizedBox(height: 2.h),
                    ListTile(
                        leading: CustomIconWidget(
                            iconName: 'picture_as_pdf',
                            color: AppTheme.error,
                            size: 24),
                        title: Text('Export as PDF',
                            style: AppTheme.darkTheme.textTheme.bodyMedium),
                        onTap: () {
                          Navigator.pop(context);
                          _exportToPDF();
                        }),
                    ListTile(
                        leading: CustomIconWidget(
                            iconName: 'table_chart',
                            color: AppTheme.success,
                            size: 24),
                        title: Text('Export as CSV',
                            style: AppTheme.darkTheme.textTheme.bodyMedium),
                        onTap: () {
                          Navigator.pop(context);
                          _exportToCSV();
                        }),
                    ListTile(
                        leading: CustomIconWidget(
                            iconName: 'business',
                            color: AppTheme.accent,
                            size: 24),
                        title: Text('White-label Report',
                            style: AppTheme.darkTheme.textTheme.bodyMedium),
                        onTap: () {
                          Navigator.pop(context);
                          _exportWhiteLabel();
                        }),
                  ]));
        });
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

  void _exportToPDF() async {
    if (_currentWorkspaceId != null) {
      final exportData = await _analyticsService.exportAnalyticsData(
        _currentWorkspaceId!,
        'pdf',
      );
      
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('PDF export prepared - ${exportData.length} records'),
          backgroundColor: AppTheme.success));
    }
  }

  void _exportToCSV() async {
    if (_currentWorkspaceId != null) {
      final exportData = await _analyticsService.exportAnalyticsData(
        _currentWorkspaceId!,
        'csv',
      );
      
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('CSV export prepared - ${exportData.length} records'),
          backgroundColor: AppTheme.success));
    }
  }

  void _exportWhiteLabel() async {
    if (_currentWorkspaceId != null) {
      final exportData = await _analyticsService.exportAnalyticsData(
        _currentWorkspaceId!,
        'white_label',
      );
      
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('White-label report prepared'),
          backgroundColor: AppTheme.success));
    }
  }

  void _showCustomReportBuilder() {
    Navigator.pushNamed(context, '/custom-report-builder');
  }

  void _showScheduledReports() {
    Navigator.pushNamed(context, '/scheduled-reports');
  }
}