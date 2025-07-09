
import '../../core/app_export.dart';
import './widgets/ab_testing_results_widget.dart';
import './widgets/analytics_charts_widget.dart';
import './widgets/analytics_header_widget.dart';
import './widgets/conversion_funnel_widget.dart';
import './widgets/export_options_widget.dart';
import './widgets/filter_options_widget.dart';
import './widgets/geographic_analytics_widget.dart';
import './widgets/link_performance_widget.dart';
import './widgets/metrics_cards_widget.dart';
import './widgets/real_time_tracking_widget.dart';

class LinkInBioAnalyticsScreen extends StatefulWidget {
  const LinkInBioAnalyticsScreen({super.key});

  @override
  State<LinkInBioAnalyticsScreen> createState() => _LinkInBioAnalyticsScreenState();
}

class _LinkInBioAnalyticsScreenState extends State<LinkInBioAnalyticsScreen> {
  String selectedDateRange = '7d';
  String selectedMetric = 'all';
  String selectedFilter = 'all';
  bool isExporting = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.primaryBackground,
      appBar: AppBar(
        title: Text(
          'Link in Bio Analytics',
          style: GoogleFonts.inter(
            fontSize: 18.sp,
            fontWeight: FontWeight.w600,
            color: AppTheme.primaryText)),
        backgroundColor: AppTheme.primaryBackground,
        elevation: 0,
        actions: [
          IconButton(
            onPressed: () => _showExportOptions(),
            icon: Icon(
              Icons.download_rounded,
              color: AppTheme.primaryText,
              size: 24.sp)),
          IconButton(
            onPressed: () => _showFilterOptions(),
            icon: Icon(
              Icons.filter_alt_rounded,
              color: AppTheme.primaryText,
              size: 24.sp)),
        ]),
      body: RefreshIndicator(
        onRefresh: _refreshData,
        color: AppTheme.accent,
        backgroundColor: AppTheme.surface,
        child: SingleChildScrollView(
          padding: EdgeInsets.all(16.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Analytics Header with Date Range
              AnalyticsHeaderWidget(
                selectedDateRange: selectedDateRange,
                onDateRangeChanged: (range) {
                  setState(() {
                    selectedDateRange = range;
                  });
                }),
              SizedBox(height: 20.h),

              // Key Metrics Cards
              MetricsCardsWidget(
                dateRange: selectedDateRange),
              SizedBox(height: 24.h),

              // Analytics Charts Section
              AnalyticsChartsWidget(
                selectedMetric: selectedMetric,
                dateRange: selectedDateRange,
                onMetricChanged: (metric) {
                  setState(() {
                    selectedMetric = metric;
                  });
                }),
              SizedBox(height: 24.h),

              // Link Performance Table
              LinkPerformanceWidget(
                dateRange: selectedDateRange,
                filter: selectedFilter),
              SizedBox(height: 24.h),

              // Geographic Analytics
              GeographicAnalyticsWidget(
                dateRange: selectedDateRange),
              SizedBox(height: 24.h),

              // Real-time Tracking
              RealTimeTrackingWidget(),
              SizedBox(height: 24.h),

              // Conversion Funnel
              ConversionFunnelWidget(
                dateRange: selectedDateRange),
              SizedBox(height: 24.h),

              // A/B Testing Results
              ABTestingResultsWidget(
                dateRange: selectedDateRange),
              SizedBox(height: 80.h),
            ]))));
  }

  void _showExportOptions() {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppTheme.surface,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(),
      ),
      builder: (context) => ExportOptionsWidget(
        onExport: (format, metrics) {
          _exportData(format, metrics);
        }),
    );
  }

  void _showFilterOptions() {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppTheme.surface,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(),
      ),
      builder: (context) => FilterOptionsWidget(
        selectedFilter: selectedFilter,
        selectedDateRange: selectedDateRange,
        onFilterChanged: (filter) {
          setState(() {
            selectedFilter = filter;
          });
        },
        onDateRangeChanged: (range) {
          setState(() {
            selectedDateRange = range;
          });
        }),
    );
  }

  Future<void> _exportData(String format, List<String> metrics) async {
    setState(() {
      isExporting = true;
    });

    try {
      // Simulate export process
      await Future.delayed(const Duration(seconds: 2));
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Analytics exported successfully in $format format',
              style: GoogleFonts.inter(
                fontSize: 14.sp,
                color: AppTheme.primaryText)),
            backgroundColor: AppTheme.success.withValues(alpha: 0.9),
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder()));
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Export failed. Please try again.',
              style: GoogleFonts.inter(
                fontSize: 14.sp,
                color: AppTheme.primaryText)),
            backgroundColor: AppTheme.error.withValues(alpha: 0.9),
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder()));
      }
    } finally {
      if (mounted) {
        setState(() {
          isExporting = false;
        });
      }
    }
  }

  Future<void> _refreshData() async {
    await Future.delayed(const Duration(seconds: 1));
    setState(() {
      // Trigger rebuild to refresh data
    });
  }
}