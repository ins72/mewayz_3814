import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
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

  final List<Map<String, dynamic>> _mockMetrics = [
    {
      "title": "Total Revenue",
      "value": "\$24,580",
      "change": "+12.5%",
      "isPositive": true,
      "icon": "attach_money"
    },
    {
      "title": "Leads Generated",
      "value": "1,247",
      "change": "+8.3%",
      "isPositive": true,
      "icon": "people"
    },
    {
      "title": "Social Followers",
      "value": "15.2K",
      "change": "+15.7%",
      "isPositive": true,
      "icon": "thumb_up"
    },
    {
      "title": "Course Completions",
      "value": "89",
      "change": "-2.1%",
      "isPositive": false,
      "icon": "school"
    },
    {
      "title": "Active Workspaces",
      "value": "12",
      "change": "+4.2%",
      "isPositive": true,
      "icon": "business"
    },
    {
      "title": "Conversion Rate",
      "value": "3.8%",
      "change": "+0.5%",
      "isPositive": true,
      "icon": "trending_up"
    }
  ];

  final List<Map<String, dynamic>> _mockRevenueData = [
    {"day": "Mon", "value": 3200.0},
    {"day": "Tue", "value": 4100.0},
    {"day": "Wed", "value": 3800.0},
    {"day": "Thu", "value": 4500.0},
    {"day": "Fri", "value": 5200.0},
    {"day": "Sat", "value": 4800.0},
    {"day": "Sun", "value": 3900.0}
  ];

  final List<Map<String, dynamic>> _mockLeadSources = [
    {"source": "Instagram", "value": 35.0, "color": "0xFFE91E63"},
    {"source": "Facebook", "value": 25.0, "color": "0xFF2196F3"},
    {"source": "LinkedIn", "value": 20.0, "color": "0xFF0077B5"},
    {"source": "Direct", "value": 15.0, "color": "0xFF4CAF50"},
    {"source": "Other", "value": 5.0, "color": "0xFF9E9E9E"}
  ];

  final List<Map<String, dynamic>> _mockSocialPerformance = [
    {"platform": "Instagram", "followers": 8500, "engagement": 4.2},
    {"platform": "Facebook", "followers": 3200, "engagement": 2.8},
    {"platform": "LinkedIn", "followers": 1800, "engagement": 6.1},
    {"platform": "Twitter", "followers": 2100, "engagement": 3.5},
    {"platform": "TikTok", "followers": 5400, "engagement": 7.8}
  ];

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
          _buildLeadSourcesChart(),
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
                      iconName: metric["icon"] as String));
            }));
  }

  Widget _buildRevenueChart() {
    return ChartContainerWidget(
        title: 'Revenue Trends',
        child: SizedBox(
            height: 30.h,
            child: LineChart(LineChartData(
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
                              if (value.toInt() < _mockRevenueData.length) {
                                return SideTitleWidget(
                                    axisSide: meta.axisSide,
                                    child: Text(
                                        _mockRevenueData[value.toInt()]["day"]
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
                maxX: (_mockRevenueData.length - 1).toDouble(),
                minY: 0,
                maxY: 6000,
                lineBarsData: [
                  LineChartBarData(
                      spots: _mockRevenueData.asMap().entries.map((entry) {
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

  Widget _buildLeadSourcesChart() {
    return ChartContainerWidget(
        title: 'Lead Sources',
        child: SizedBox(
            height: 30.h,
            child: PieChart(PieChartData(
                pieTouchData: PieTouchData(
                    touchCallback: (FlTouchEvent event, pieTouchResponse) {
                  // Handle touch events for detailed breakdowns
                }),
                borderData: FlBorderData(show: false),
                sectionsSpace: 2,
                centerSpaceRadius: 40,
                sections: _mockLeadSources.map((source) {
                  return PieChartSectionData(
                      color: Color(int.parse(source["color"] as String)),
                      value: source["value"] as double,
                      title:
                          '${(source["value"] as double).toStringAsFixed(0)}%',
                      radius: 60,
                      titleStyle: AppTheme.darkTheme.textTheme.labelMedium
                          ?.copyWith(
                              color: AppTheme.primaryText,
                              fontWeight: FontWeight.bold));
                }).toList()))));
  }

  Widget _buildSocialPerformanceChart() {
    return ChartContainerWidget(
        title: 'Social Media Performance',
        child: SizedBox(
            height: 30.h,
            child: BarChart(BarChartData(
                alignment: BarChartAlignment.spaceAround,
                maxY: 10000,
                barTouchData: BarTouchData(
                    touchTooltipData: BarTouchTooltipData(
                        tooltipHorizontalAlignment:
                            FLHorizontalAlignment.center,
                        tooltipMargin: -10,
                        getTooltipItem: (group, groupIndex, rod, rodIndex) {
                          String platform =
                              _mockSocialPerformance[group.x.toInt()]
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
                                  _mockSocialPerformance.length) {
                                return SideTitleWidget(
                                    axisSide: meta.axisSide,
                                    child: Text(
                                        _mockSocialPerformance[value.toInt()]
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
                barGroups: _mockSocialPerformance.asMap().entries.map((entry) {
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
          ..._mockSocialPerformance.map((platform) {
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

  void _exportToPDF() {
    // PDF export logic
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Exporting to PDF...'),
        backgroundColor: AppTheme.surface));
  }

  void _exportToCSV() {
    // CSV export logic
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Exporting to CSV...'),
        backgroundColor: AppTheme.surface));
  }

  void _exportWhiteLabel() {
    // White-label export logic
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Generating white-label report...'),
        backgroundColor: AppTheme.surface));
  }

  void _showCustomReportBuilder() {
    Navigator.pushNamed(context, '/custom-report-builder');
  }

  void _showScheduledReports() {
    Navigator.pushNamed(context, '/scheduled-reports');
  }
}
