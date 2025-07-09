import 'package:flutter/material.dart';

import '../../core/app_export.dart';
import './widgets/analytics_header_widget.dart';
import './widgets/audience_insights_widget.dart';
import './widgets/competitor_comparison_widget.dart';
import './widgets/content_performance_widget.dart';
import './widgets/engagement_chart_widget.dart';
import './widgets/export_options_widget.dart';
import './widgets/metrics_overview_widget.dart';

class SocialMediaAnalyticsScreen extends StatefulWidget {
  const SocialMediaAnalyticsScreen({super.key});

  @override
  State<SocialMediaAnalyticsScreen> createState() => _SocialMediaAnalyticsScreenState();
}

class _SocialMediaAnalyticsScreenState extends State<SocialMediaAnalyticsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  
  String _selectedDateRange = '30 days';
  final List<String> _selectedPlatforms = ['instagram', 'facebook', 'twitter'];
  
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
      appBar: AppBar(
        backgroundColor: AppTheme.primaryBackground,
        title: const Text(
          'Social Media Analytics',
          style: TextStyle(
            color: AppTheme.primaryText,
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios,
            color: AppTheme.primaryText,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: const Icon(
              Icons.download,
              color: AppTheme.primaryText,
            ),
            onPressed: _showExportOptions,
          ),
          IconButton(
            icon: const Icon(
              Icons.refresh,
              color: AppTheme.primaryText,
            ),
            onPressed: _refreshData,
          ),
        ],
      ),
      body: Column(
        children: [
          // Header with date range and platform filters
          AnalyticsHeaderWidget(
            selectedDateRange: _selectedDateRange,
            selectedPlatforms: _selectedPlatforms,
            onDateRangeChanged: _onDateRangeChanged,
            onPlatformToggle: _onPlatformToggle,
          ),
          
          // Tab Bar
          Container(
            color: AppTheme.primaryBackground,
            child: TabBar(
              controller: _tabController,
              isScrollable: true,
              tabs: const [
                Tab(text: 'Overview'),
                Tab(text: 'Content'),
                Tab(text: 'Audience'),
                Tab(text: 'Competitors'),
                Tab(text: 'Reports'),
              ],
              labelColor: AppTheme.primaryText,
              unselectedLabelColor: AppTheme.secondaryText,
              indicatorColor: AppTheme.accent,
            ),
          ),
          
          // Tab Content
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildOverviewTab(),
                _buildContentTab(),
                _buildAudienceTab(),
                _buildCompetitorsTab(),
                _buildReportsTab(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOverviewTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          MetricsOverviewWidget(
            selectedPlatforms: _selectedPlatforms,
            dateRange: _selectedDateRange,
          ),
          const SizedBox(height: 16),
          EngagementChartWidget(
            selectedPlatforms: _selectedPlatforms,
            dateRange: _selectedDateRange,
          ),
          const SizedBox(height: 16),
          _buildOptimalPostingTimes(),
        ],
      ),
    );
  }

  Widget _buildContentTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          ContentPerformanceWidget(
            selectedPlatforms: _selectedPlatforms,
            dateRange: _selectedDateRange,
          ),
          const SizedBox(height: 16),
          _buildHashtagAnalytics(),
          const SizedBox(height: 16),
          _buildContentTypeAnalysis(),
        ],
      ),
    );
  }

  Widget _buildAudienceTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          AudienceInsightsWidget(
            selectedPlatforms: _selectedPlatforms,
            dateRange: _selectedDateRange,
          ),
          const SizedBox(height: 16),
          _buildAudienceGrowth(),
          const SizedBox(height: 16),
          _buildDemographics(),
        ],
      ),
    );
  }

  Widget _buildCompetitorsTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          CompetitorComparisonWidget(
            selectedPlatforms: _selectedPlatforms,
            dateRange: _selectedDateRange,
          ),
        ],
      ),
    );
  }

  Widget _buildReportsTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          ExportOptionsWidget(
            selectedPlatforms: _selectedPlatforms,
            dateRange: _selectedDateRange,
            onExport: _exportReport,
          ),
        ],
      ),
    );
  }

  Widget _buildOptimalPostingTimes() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppTheme.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Optimal Posting Times',
            style: TextStyle(
              color: AppTheme.primaryText,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 16),
          _buildHeatmapChart(),
        ],
      ),
    );
  }

  Widget _buildHeatmapChart() {
    return Container(
      height: 200,
      decoration: BoxDecoration(
        color: AppTheme.primaryBackground,
        borderRadius: BorderRadius.circular(8),
      ),
      child: const Center(
        child: Text(
          'Heatmap Chart',
          style: TextStyle(
            color: AppTheme.secondaryText,
            fontSize: 14,
          ),
        ),
      ),
    );
  }

  Widget _buildHashtagAnalytics() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppTheme.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Hashtag Performance',
            style: TextStyle(
              color: AppTheme.primaryText,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 16),
          _buildHashtagList(),
        ],
      ),
    );
  }

  Widget _buildHashtagList() {
    final hashtags = [
      {'tag': '#marketing', 'reach': '12.5K', 'engagement': '8.2%'},
      {'tag': '#business', 'reach': '8.9K', 'engagement': '6.7%'},
      {'tag': '#socialmedia', 'reach': '15.3K', 'engagement': '9.1%'},
      {'tag': '#growth', 'reach': '6.2K', 'engagement': '5.4%'},
    ];

    return Column(
      children: hashtags.map((hashtag) {
        return Container(
          margin: const EdgeInsets.only(bottom: 8),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: AppTheme.primaryBackground,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: AppTheme.border),
          ),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  hashtag['tag']!,
                  style: const TextStyle(
                    color: AppTheme.primaryText,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              Text(
                hashtag['reach']!,
                style: const TextStyle(
                  color: AppTheme.secondaryText,
                  fontSize: 12,
                ),
              ),
              const SizedBox(width: 16),
              Text(
                hashtag['engagement']!,
                style: const TextStyle(
                  color: AppTheme.success,
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget _buildContentTypeAnalysis() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppTheme.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Content Type Performance',
            style: TextStyle(
              color: AppTheme.primaryText,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 16),
          _buildContentTypeChart(),
        ],
      ),
    );
  }

  Widget _buildContentTypeChart() {
    return Container(
      height: 200,
      child: PieChart(
        PieChartData(
          sections: [
            PieChartSectionData(
              color: AppTheme.accent,
              value: 40,
              title: '40%',
              radius: 50,
              titleStyle: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: AppTheme.primaryText,
              ),
            ),
            PieChartSectionData(
              color: AppTheme.success,
              value: 30,
              title: '30%',
              radius: 50,
              titleStyle: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: AppTheme.primaryText,
              ),
            ),
            PieChartSectionData(
              color: AppTheme.warning,
              value: 20,
              title: '20%',
              radius: 50,
              titleStyle: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: AppTheme.primaryText,
              ),
            ),
            PieChartSectionData(
              color: AppTheme.error,
              value: 10,
              title: '10%',
              radius: 50,
              titleStyle: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: AppTheme.primaryText,
              ),
            ),
          ],
          sectionsSpace: 2,
          centerSpaceRadius: 40,
        ),
      ),
    );
  }

  Widget _buildAudienceGrowth() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppTheme.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Audience Growth',
            style: TextStyle(
              color: AppTheme.primaryText,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 16),
          _buildGrowthChart(),
        ],
      ),
    );
  }

  Widget _buildGrowthChart() {
    return Container(
      height: 200,
      child: LineChart(
        LineChartData(
          gridData: const FlGridData(show: false),
          titlesData: const FlTitlesData(show: false),
          borderData: FlBorderData(show: false),
          lineBarsData: [
            LineChartBarData(
              spots: [
                const FlSpot(0, 1),
                const FlSpot(1, 3),
                const FlSpot(2, 2),
                const FlSpot(3, 5),
                const FlSpot(4, 4),
                const FlSpot(5, 7),
                const FlSpot(6, 6),
              ],
              isCurved: true,
              color: AppTheme.accent,
              barWidth: 3,
              isStrokeCapRound: true,
              belowBarData: BarAreaData(
                show: true,
                color: AppTheme.accent.withAlpha(26),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDemographics() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppTheme.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Demographics',
            style: TextStyle(
              color: AppTheme.primaryText,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 16),
          _buildDemographicsList(),
        ],
      ),
    );
  }

  Widget _buildDemographicsList() {
    final demographics = [
      {'label': 'Age 18-24', 'percentage': '35%', 'color': AppTheme.accent},
      {'label': 'Age 25-34', 'percentage': '42%', 'color': AppTheme.success},
      {'label': 'Age 35-44', 'percentage': '18%', 'color': AppTheme.warning},
      {'label': 'Age 45+', 'percentage': '5%', 'color': AppTheme.error},
    ];

    return Column(
      children: demographics.map((demo) {
        return Container(
          margin: const EdgeInsets.only(bottom: 8),
          child: Row(
            children: [
              Container(
                width: 12,
                height: 12,
                decoration: BoxDecoration(
                  color: demo['color'] as Color,
                  borderRadius: BorderRadius.circular(6),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  demo['label'] as String,
                  style: const TextStyle(
                    color: AppTheme.primaryText,
                    fontSize: 14,
                  ),
                ),
              ),
              Text(
                demo['percentage'] as String,
                style: const TextStyle(
                  color: AppTheme.secondaryText,
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  void _onDateRangeChanged(String dateRange) {
    setState(() {
      _selectedDateRange = dateRange;
    });
  }

  void _onPlatformToggle(String platform) {
    setState(() {
      if (_selectedPlatforms.contains(platform)) {
        _selectedPlatforms.remove(platform);
      } else {
        _selectedPlatforms.add(platform);
      }
    });
  }

  void _showExportOptions() {
    _tabController.animateTo(4);
  }

  void _refreshData() {
    // Refresh analytics data
  }

  void _exportReport(String format) {
    // Export report in specified format
  }
}