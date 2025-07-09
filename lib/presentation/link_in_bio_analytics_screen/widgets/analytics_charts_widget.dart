
import '../../../core/app_export.dart';

class AnalyticsChartsWidget extends StatelessWidget {
  final String selectedMetric;
  final String dateRange;
  final Function(String) onMetricChanged;

  const AnalyticsChartsWidget({
    super.key,
    required this.selectedMetric,
    required this.dateRange,
    required this.onMetricChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Chart selector
        Container(
          padding: EdgeInsets.all(16.w),
          decoration: BoxDecoration(
            color: AppTheme.surface,
            
            border: Border.all(
              color: AppTheme.border,
              width: 1)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Analytics Charts',
                    style: GoogleFonts.inter(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                      color: AppTheme.primaryText)),
                  Icon(
                    Icons.bar_chart_rounded,
                    color: AppTheme.accent,
                    size: 20.sp),
                ]),
              SizedBox(height: 16.h),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    _buildChartTab('visitor', 'Visitor Trends'),
                    SizedBox(width: 8.w),
                    _buildChartTab('clicks', 'Click Distribution'),
                    SizedBox(width: 8.w),
                    _buildChartTab('traffic', 'Traffic Sources'),
                    SizedBox(width: 8.w),
                    _buildChartTab('devices', 'Device Analytics'),
                  ])),
              SizedBox(height: 20.h),
              _buildSelectedChart(),
            ])),
      ]);
  }

  Widget _buildChartTab(String value, String label) {
    final isSelected = selectedMetric == value;
    return GestureDetector(
      onTap: () => onMetricChanged(value),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
        decoration: BoxDecoration(
          color: isSelected ? AppTheme.accent.withValues(alpha: 0.1) : Colors.transparent,
          
          border: Border.all(
            color: isSelected ? AppTheme.accent : AppTheme.border,
            width: 1)),
        child: Text(
          label,
          style: GoogleFonts.inter(
            fontSize: 12.sp,
            fontWeight: FontWeight.w500,
            color: isSelected ? AppTheme.accent : AppTheme.secondaryText))));
  }

  Widget _buildSelectedChart() {
    switch (selectedMetric) {
      case 'visitor':
        return _buildVisitorTrendsChart();
      case 'clicks':
        return _buildClickDistributionChart();
      case 'traffic':
        return _buildTrafficSourcesChart();
      case 'devices':
        return _buildDeviceAnalyticsChart();
      default:
        return _buildVisitorTrendsChart();
    }
  }

  Widget _buildVisitorTrendsChart() {
    return Container(
      height: 200.h,
      width: double.infinity,
      child: LineChart(
        LineChartData(
          backgroundColor: Colors.transparent,
          gridData: FlGridData(
            show: true,
            drawHorizontalLine: true,
            drawVerticalLine: false,
            horizontalInterval: 1,
            getDrawingHorizontalLine: (value) {
              return FlLine(
                color: AppTheme.border,
                strokeWidth: 1);
            }),
          titlesData: FlTitlesData(
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 40.w,
                getTitlesWidget: (value, meta) {
                  return Text(
                    value.toInt().toString(),
                    style: GoogleFonts.inter(
                      fontSize: 10.sp,
                      color: AppTheme.secondaryText));
                })),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 30.h,
                getTitlesWidget: (value, meta) {
                  const days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
                  if (value.toInt() < days.length) {
                    return Text(
                      days[value.toInt()],
                      style: GoogleFonts.inter(
                        fontSize: 10.sp,
                        color: AppTheme.secondaryText));
                  }
                  return const Text('');
                })),
            topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
            rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false))),
          borderData: FlBorderData(show: false),
          lineBarsData: [
            LineChartBarData(
              spots: [
                const FlSpot(0, 120),
                const FlSpot(1, 145),
                const FlSpot(2, 178),
                const FlSpot(3, 156),
                const FlSpot(4, 189),
                const FlSpot(5, 234),
                const FlSpot(6, 267),
              ],
              isCurved: true,
              color: AppTheme.accent,
              barWidth: 3,
              isStrokeCapRound: true,
              dotData: FlDotData(show: false),
              belowBarData: BarAreaData(
                show: true,
                color: AppTheme.accent.withValues(alpha: 0.1))),
          ],
          minX: 0,
          maxX: 6,
          minY: 0,
          maxY: 300)));
  }

  Widget _buildClickDistributionChart() {
    return Container(
      height: 200.h,
      width: double.infinity,
      child: BarChart(
        BarChartData(
          backgroundColor: Colors.transparent,
          gridData: FlGridData(
            show: true,
            drawHorizontalLine: true,
            drawVerticalLine: false,
            horizontalInterval: 50,
            getDrawingHorizontalLine: (value) {
              return FlLine(
                color: AppTheme.border,
                strokeWidth: 1);
            }),
          titlesData: FlTitlesData(
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 40.w,
                getTitlesWidget: (value, meta) {
                  return Text(
                    value.toInt().toString(),
                    style: GoogleFonts.inter(
                      fontSize: 10.sp,
                      color: AppTheme.secondaryText));
                })),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 30.h,
                getTitlesWidget: (value, meta) {
                  const links = ['IG', 'TW', 'FB', 'LI', 'YT'];
                  if (value.toInt() < links.length) {
                    return Text(
                      links[value.toInt()],
                      style: GoogleFonts.inter(
                        fontSize: 10.sp,
                        color: AppTheme.secondaryText));
                  }
                  return const Text('');
                })),
            topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
            rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false))),
          borderData: FlBorderData(show: false),
          barGroups: [
            BarChartGroupData(x: 0, barRods: [BarChartRodData(toY: 180, color: AppTheme.accent)]),
            BarChartGroupData(x: 1, barRods: [BarChartRodData(toY: 120, color: AppTheme.success)]),
            BarChartGroupData(x: 2, barRods: [BarChartRodData(toY: 98, color: AppTheme.warning)]),
            BarChartGroupData(x: 3, barRods: [BarChartRodData(toY: 67, color: AppTheme.error)]),
            BarChartGroupData(x: 4, barRods: [BarChartRodData(toY: 45, color: AppTheme.primaryAction)]),
          ],
          maxY: 200)));
  }

  Widget _buildTrafficSourcesChart() {
    return Container(
      height: 200.h,
      width: double.infinity,
      child: PieChart(
        PieChartData(
          
          sectionsSpace: 2,
          
          sections: [
            PieChartSectionData(
              color: AppTheme.accent,
              value: 35,
              title: 'Direct\n35%',
              
              titleStyle: GoogleFonts.inter(
                fontSize: 10.sp,
                fontWeight: FontWeight.w500,
                color: AppTheme.primaryText)),
            PieChartSectionData(
              color: AppTheme.success,
              value: 25,
              title: 'Social\n25%',
              
              titleStyle: GoogleFonts.inter(
                fontSize: 10.sp,
                fontWeight: FontWeight.w500,
                color: AppTheme.primaryText)),
            PieChartSectionData(
              color: AppTheme.warning,
              value: 20,
              title: 'Search\n20%',
              
              titleStyle: GoogleFonts.inter(
                fontSize: 10.sp,
                fontWeight: FontWeight.w500,
                color: AppTheme.primaryText)),
            PieChartSectionData(
              color: AppTheme.error,
              value: 20,
              title: 'Other\n20%',
              
              titleStyle: GoogleFonts.inter(
                fontSize: 10.sp,
                fontWeight: FontWeight.w500,
                color: AppTheme.primaryText)),
          ])));
  }

  Widget _buildDeviceAnalyticsChart() {
    return Container(
      height: 200.h,
      width: double.infinity,
      child: PieChart(
        PieChartData(
          
          sectionsSpace: 2,
          
          sections: [
            PieChartSectionData(
              color: AppTheme.accent,
              value: 65,
              title: 'Mobile\n65%',
              
              titleStyle: GoogleFonts.inter(
                fontSize: 10.sp,
                fontWeight: FontWeight.w500,
                color: AppTheme.primaryText)),
            PieChartSectionData(
              color: AppTheme.success,
              value: 25,
              title: 'Desktop\n25%',
              
              titleStyle: GoogleFonts.inter(
                fontSize: 10.sp,
                fontWeight: FontWeight.w500,
                color: AppTheme.primaryText)),
            PieChartSectionData(
              color: AppTheme.warning,
              value: 10,
              title: 'Tablet\n10%',
              
              titleStyle: GoogleFonts.inter(
                fontSize: 10.sp,
                fontWeight: FontWeight.w500,
                color: AppTheme.primaryText)),
          ])));
  }
}