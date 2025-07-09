import '../../../core/app_export.dart';

class EngagementChartWidget extends StatefulWidget {
  final List<String> selectedPlatforms;
  final String dateRange;

  const EngagementChartWidget({
    super.key,
    required this.selectedPlatforms,
    required this.dateRange,
  });

  @override
  State<EngagementChartWidget> createState() => _EngagementChartWidgetState();
}

class _EngagementChartWidgetState extends State<EngagementChartWidget> {
  String _selectedChart = 'engagement';

  @override
  Widget build(BuildContext context) {
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
              const Text(
                'Performance Trends',
                style: TextStyle(
                  color: AppTheme.primaryText,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const Spacer(),
              _buildChartSelector(),
            ],
          ),
          const SizedBox(height: 16),
          _buildChart(),
          const SizedBox(height: 16),
          _buildLegend(),
        ],
      ),
    );
  }

  Widget _buildChartSelector() {
    return Container(
      padding: const EdgeInsets.all(2),
      decoration: BoxDecoration(
        color: AppTheme.primaryBackground,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppTheme.border),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildSelectorButton('Engagement', 'engagement'),
          _buildSelectorButton('Reach', 'reach'),
          _buildSelectorButton('Followers', 'followers'),
        ],
      ),
    );
  }

  Widget _buildSelectorButton(String label, String value) {
    final isSelected = _selectedChart == value;
    
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedChart = value;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: isSelected ? AppTheme.accent : Colors.transparent,
          borderRadius: BorderRadius.circular(6),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? AppTheme.primaryText : AppTheme.secondaryText,
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }

  Widget _buildChart() {
    return Container(
      height: 200,
      decoration: BoxDecoration(
        color: AppTheme.primaryBackground,
        borderRadius: BorderRadius.circular(8),
      ),
      child: LineChart(
        LineChartData(
          gridData: FlGridData(
            show: true,
            drawVerticalLine: false,
            horizontalInterval: 1,
            getDrawingHorizontalLine: (value) {
              return const FlLine(
                color: AppTheme.border,
                strokeWidth: 1,
              );
            },
          ),
          titlesData: FlTitlesData(
            show: true,
            rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 30,
                interval: 1,
                getTitlesWidget: (value, meta) {
                  const style = TextStyle(
                    color: AppTheme.secondaryText,
                    fontSize: 10,
                  );
                  switch (value.toInt()) {
                    case 0:
                      return const Text('Mon', style: style);
                    case 1:
                      return const Text('Tue', style: style);
                    case 2:
                      return const Text('Wed', style: style);
                    case 3:
                      return const Text('Thu', style: style);
                    case 4:
                      return const Text('Fri', style: style);
                    case 5:
                      return const Text('Sat', style: style);
                    case 6:
                      return const Text('Sun', style: style);
                    default:
                      return const Text('', style: style);
                  }
                },
              ),
            ),
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                interval: 1,
                getTitlesWidget: (value, meta) {
                  return Text(
                    value.toInt().toString(),
                    style: const TextStyle(
                      color: AppTheme.secondaryText,
                      fontSize: 10,
                    ),
                  );
                },
                reservedSize: 32,
              ),
            ),
          ),
          borderData: FlBorderData(
            show: false,
          ),
          minX: 0,
          maxX: 6,
          minY: 0,
          maxY: 6,
          lineBarsData: _getChartData(),
        ),
      ),
    );
  }

  List<LineChartBarData> _getChartData() {
    return [
      LineChartBarData(
        spots: [
          const FlSpot(0, 3),
          const FlSpot(1, 1),
          const FlSpot(2, 4),
          const FlSpot(3, 3),
          const FlSpot(4, 2),
          const FlSpot(5, 5),
          const FlSpot(6, 4),
        ],
        isCurved: true,
        color: AppTheme.accent,
        barWidth: 3,
        isStrokeCapRound: true,
        dotData: const FlDotData(show: false),
        belowBarData: BarAreaData(
          show: true,
          color: AppTheme.accent.withAlpha(26),
        ),
      ),
      LineChartBarData(
        spots: [
          const FlSpot(0, 1),
          const FlSpot(1, 3),
          const FlSpot(2, 2),
          const FlSpot(3, 5),
          const FlSpot(4, 4),
          const FlSpot(5, 3),
          const FlSpot(6, 5),
        ],
        isCurved: true,
        color: AppTheme.success,
        barWidth: 3,
        isStrokeCapRound: true,
        dotData: const FlDotData(show: false),
        belowBarData: BarAreaData(
          show: true,
          color: AppTheme.success.withAlpha(26),
        ),
      ),
    ];
  }

  Widget _buildLegend() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildLegendItem('Instagram', AppTheme.accent),
        const SizedBox(width: 24),
        _buildLegendItem('Facebook', AppTheme.success),
        const SizedBox(width: 24),
        _buildLegendItem('Twitter', AppTheme.warning),
      ],
    );
  }

  Widget _buildLegendItem(String label, Color color) {
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
        const SizedBox(width: 6),
        Text(
          label,
          style: const TextStyle(
            color: AppTheme.secondaryText,
            fontSize: 12,
          ),
        ),
      ],
    );
  }
}