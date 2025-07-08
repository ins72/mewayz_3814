import 'package:flutter/material.dart';

import '../../../core/app_export.dart';

class AnalyticsWidget extends StatefulWidget {
  const AnalyticsWidget({Key? key}) : super(key: key);

  @override
  State<AnalyticsWidget> createState() => _AnalyticsWidgetState();
}

class _AnalyticsWidgetState extends State<AnalyticsWidget> {
  String _selectedTimeRange = '7d';

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              Icons.analytics_outlined,
              color: AppTheme.accent,
              size: 20,
            ),
            SizedBox(width: 8.w),
            Text(
              'Campaign Analytics',
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ],
        ),
        SizedBox(height: 16.h),
        _buildTimeRangeSelector(),
        SizedBox(height: 16.h),
        _buildMetricsCards(),
        SizedBox(height: 16.h),
        _buildPerformanceChart(),
        SizedBox(height: 16.h),
        _buildDetailedMetrics(),
      ],
    );
  }

  Widget _buildTimeRangeSelector() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          _buildTimeRangeChip('24h', '24 Hours'),
          SizedBox(width: 8.w),
          _buildTimeRangeChip('7d', '7 Days'),
          SizedBox(width: 8.w),
          _buildTimeRangeChip('30d', '30 Days'),
          SizedBox(width: 8.w),
          _buildTimeRangeChip('90d', '90 Days'),
        ],
      ),
    );
  }

  Widget _buildTimeRangeChip(String value, String label) {
    final isSelected = _selectedTimeRange == value;
    return FilterChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (selected) {
        setState(() {
          _selectedTimeRange = value;
        });
      },
      selectedColor: AppTheme.accent,
      backgroundColor: AppTheme.surface,
      labelStyle: TextStyle(
        color: isSelected ? AppTheme.primaryAction : AppTheme.primaryText,
      ),
    );
  }

  Widget _buildMetricsCards() {
    return Row(
      children: [
        Expanded(
          child: _buildMetricCard(
            'Open Rate',
            '24.5%',
            '+2.1%',
            Icons.help_outline,
            AppTheme.accent,
            true,
          ),
        ),
        SizedBox(width: 12.w),
        Expanded(
          child: _buildMetricCard(
            'Click Rate',
            '3.8%',
            '+0.5%',
            Icons.mouse_rounded,
            AppTheme.success,
            true,
          ),
        ),
      ],
    );
  }

  Widget _buildMetricCard(
    String title,
    String value,
    String change,
    IconData icon,
    Color color,
    bool isPositive,
  ) {
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
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: color.withAlpha(26),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  icon,
                  size: 16,
                  color: color,
                ),
              ),
              const Spacer(),
              Icon(
                isPositive
                    ? Icons.trending_up_rounded
                    : Icons.trending_down_rounded,
                size: 16,
                color: isPositive ? AppTheme.success : AppTheme.error,
              ),
            ],
          ),
          SizedBox(height: 12.h),
          Text(
            value,
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: AppTheme.primaryText,
                ),
          ),
          SizedBox(height: 4.h),
          Text(
            title,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: AppTheme.secondaryText,
                ),
          ),
          SizedBox(height: 8.h),
          Text(
            change,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: isPositive ? AppTheme.success : AppTheme.error,
                  fontWeight: FontWeight.w500,
                ),
          ),
        ],
      ),
    );
  }

  Widget _buildPerformanceChart() {
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
          Text(
            'Performance Over Time',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w500,
                ),
          ),
          SizedBox(height: 16.h),
          SizedBox(
            height: 200,
            child: LineChart(
              LineChartData(
                gridData: FlGridData(
                  show: true,
                  drawVerticalLine: false,
                  getDrawingHorizontalLine: (value) => FlLine(
                    color: AppTheme.border,
                    strokeWidth: 1,
                  ),
                ),
                titlesData: FlTitlesData(
                  show: true,
                  rightTitles: AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  topTitles: AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (value, meta) {
                        const style = TextStyle(
                          color: AppTheme.secondaryText,
                          fontWeight: FontWeight.w400,
                          fontSize: 12,
                        );
                        String text = '';
                        switch (value.toInt()) {
                          case 0:
                            text = 'Mon';
                            break;
                          case 1:
                            text = 'Tue';
                            break;
                          case 2:
                            text = 'Wed';
                            break;
                          case 3:
                            text = 'Thu';
                            break;
                          case 4:
                            text = 'Fri';
                            break;
                          case 5:
                            text = 'Sat';
                            break;
                          case 6:
                            text = 'Sun';
                            break;
                        }
                        return SideTitleWidget(
                          axisSide: meta.axisSide,
                          child: Text(text, style: style),
                        );
                      },
                    ),
                  ),
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (value, meta) {
                        const style = TextStyle(
                          color: AppTheme.secondaryText,
                          fontWeight: FontWeight.w400,
                          fontSize: 12,
                        );
                        return SideTitleWidget(
                          axisSide: meta.axisSide,
                          child: Text('${value.toInt()}%', style: style),
                        );
                      },
                      reservedSize: 42,
                    ),
                  ),
                ),
                borderData: FlBorderData(
                  show: true,
                  border: Border.all(color: AppTheme.border),
                ),
                minX: 0,
                maxX: 6,
                minY: 0,
                maxY: 30,
                lineBarsData: [
                  LineChartBarData(
                    spots: const [
                      FlSpot(0, 20),
                      FlSpot(1, 22),
                      FlSpot(2, 25),
                      FlSpot(3, 24),
                      FlSpot(4, 28),
                      FlSpot(5, 26),
                      FlSpot(6, 24),
                    ],
                    isCurved: true,
                    color: AppTheme.accent,
                    barWidth: 3,
                    isStrokeCapRound: true,
                    dotData: FlDotData(
                      show: true,
                      getDotPainter: (spot, percent, barData, index) {
                        return FlDotCirclePainter(
                          radius: 4,
                          color: AppTheme.accent,
                          strokeWidth: 2,
                          strokeColor: AppTheme.surface,
                        );
                      },
                    ),
                    belowBarData: BarAreaData(
                      show: true,
                      color: AppTheme.accent.withAlpha(26),
                    ),
                  ),
                  LineChartBarData(
                    spots: const [
                      FlSpot(0, 3),
                      FlSpot(1, 3.5),
                      FlSpot(2, 4),
                      FlSpot(3, 3.8),
                      FlSpot(4, 4.2),
                      FlSpot(5, 4.1),
                      FlSpot(6, 3.8),
                    ],
                    isCurved: true,
                    color: AppTheme.success,
                    barWidth: 3,
                    isStrokeCapRound: true,
                    dotData: FlDotData(
                      show: true,
                      getDotPainter: (spot, percent, barData, index) {
                        return FlDotCirclePainter(
                          radius: 4,
                          color: AppTheme.success,
                          strokeWidth: 2,
                          strokeColor: AppTheme.surface,
                        );
                      },
                    ),
                    belowBarData: BarAreaData(
                      show: true,
                      color: AppTheme.success.withAlpha(26),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: 16.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildChartLegend('Open Rate', AppTheme.accent),
              SizedBox(width: 24.w),
              _buildChartLegend('Click Rate', AppTheme.success),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildChartLegend(String label, Color color) {
    return Row(
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        SizedBox(width: 8.w),
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: AppTheme.secondaryText,
              ),
        ),
      ],
    );
  }

  Widget _buildDetailedMetrics() {
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
          Text(
            'Detailed Metrics',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w500,
                ),
          ),
          SizedBox(height: 16.h),
          _buildMetricRow('Total Sent', '2,547', null),
          _buildMetricRow('Delivered', '2,489', '97.7%'),
          _buildMetricRow('Bounced', '58', '2.3%'),
          _buildMetricRow('Opened', '610', '24.5%'),
          _buildMetricRow('Clicked', '95', '3.8%'),
          _buildMetricRow('Unsubscribed', '12', '0.5%'),
          _buildMetricRow('Complained', '3', '0.1%'),
        ],
      ),
    );
  }

  Widget _buildMetricRow(String metric, String value, String? percentage) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Expanded(
            child: Text(
              metric,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppTheme.primaryText,
                  ),
            ),
          ),
          Text(
            value,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w500,
                  color: AppTheme.primaryText,
                ),
          ),
          if (percentage != null) ...[
            SizedBox(width: 8.w),
            Text(
              percentage,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppTheme.secondaryText,
                  ),
            ),
          ],
        ],
      ),
    );
  }
}