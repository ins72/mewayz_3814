import '../../../core/app_export.dart';

class AudienceInsightsWidget extends StatelessWidget {
  final List<String> selectedPlatforms;
  final String dateRange;

  const AudienceInsightsWidget({
    super.key,
    required this.selectedPlatforms,
    required this.dateRange,
  });

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
          const Text(
            'Audience Insights',
            style: TextStyle(
              color: AppTheme.primaryText,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 16),
          _buildAudienceOverview(),
          const SizedBox(height: 16),
          _buildAudienceBreakdown(),
        ],
      ),
    );
  }

  Widget _buildAudienceOverview() {
    return Row(
      children: [
        Expanded(
          child: _buildOverviewCard(
            'Total Followers',
            '25.4K',
            '+12.5%',
            Icons.people,
            AppTheme.accent,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildOverviewCard(
            'Engagement Rate',
            '8.2%',
            '+2.1%',
            Icons.favorite,
            AppTheme.success,
          ),
        ),
      ],
    );
  }

  Widget _buildOverviewCard(
    String title,
    String value,
    String change,
    IconData icon,
    Color color,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.primaryBackground,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppTheme.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: color, size: 20),
              const Spacer(),
              Text(
                change,
                style: const TextStyle(
                  color: AppTheme.success,
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: const TextStyle(
              color: AppTheme.primaryText,
              fontSize: 20,
              fontWeight: FontWeight.w700,
            ),
          ),
          Text(
            title,
            style: const TextStyle(
              color: AppTheme.secondaryText,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAudienceBreakdown() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Audience Breakdown',
          style: TextStyle(
            color: AppTheme.primaryText,
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _buildGenderChart(),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildAgeChart(),
            ),
          ],
        ),
        const SizedBox(height: 16),
        _buildLocationBreakdown(),
      ],
    );
  }

  Widget _buildGenderChart() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Gender',
          style: TextStyle(
            color: AppTheme.secondaryText,
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          height: 120,
          child: PieChart(
            PieChartData(
              sections: [
                PieChartSectionData(
                  color: AppTheme.accent,
                  value: 55,
                  title: '55%',
                  radius: 40,
                  titleStyle: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.primaryText,
                  ),
                ),
                PieChartSectionData(
                  color: AppTheme.success,
                  value: 43,
                  title: '43%',
                  radius: 40,
                  titleStyle: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.primaryText,
                  ),
                ),
                PieChartSectionData(
                  color: AppTheme.warning,
                  value: 2,
                  title: '2%',
                  radius: 40,
                  titleStyle: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.primaryText,
                  ),
                ),
              ],
              sectionsSpace: 2,
              centerSpaceRadius: 20,
            ),
          ),
        ),
        const SizedBox(height: 8),
        _buildChartLegend([
          {'label': 'Female', 'color': AppTheme.accent},
          {'label': 'Male', 'color': AppTheme.success},
          {'label': 'Other', 'color': AppTheme.warning},
        ]),
      ],
    );
  }

  Widget _buildAgeChart() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Age Groups',
          style: TextStyle(
            color: AppTheme.secondaryText,
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          height: 120,
          child: BarChart(
            BarChartData(
              alignment: BarChartAlignment.spaceAround,
              maxY: 50,
              barTouchData: BarTouchData(enabled: false),
              titlesData: FlTitlesData(
                show: true,
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    getTitlesWidget: (value, meta) {
                      const style = TextStyle(
                        color: AppTheme.secondaryText,
                        fontSize: 10,
                      );
                      switch (value.toInt()) {
                        case 0:
                          return const Text('18-24', style: style);
                        case 1:
                          return const Text('25-34', style: style);
                        case 2:
                          return const Text('35-44', style: style);
                        case 3:
                          return const Text('45+', style: style);
                        default:
                          return const Text('', style: style);
                      }
                    },
                  ),
                ),
                leftTitles: const AxisTitles(
                  sideTitles: SideTitles(showTitles: false),
                ),
                topTitles: const AxisTitles(
                  sideTitles: SideTitles(showTitles: false),
                ),
                rightTitles: const AxisTitles(
                  sideTitles: SideTitles(showTitles: false),
                ),
              ),
              borderData: FlBorderData(show: false),
              barGroups: [
                BarChartGroupData(
                  x: 0,
                  barRods: [
                    BarChartRodData(
                      toY: 35,
                      color: AppTheme.accent,
                      width: 16,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ],
                ),
                BarChartGroupData(
                  x: 1,
                  barRods: [
                    BarChartRodData(
                      toY: 42,
                      color: AppTheme.success,
                      width: 16,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ],
                ),
                BarChartGroupData(
                  x: 2,
                  barRods: [
                    BarChartRodData(
                      toY: 18,
                      color: AppTheme.warning,
                      width: 16,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ],
                ),
                BarChartGroupData(
                  x: 3,
                  barRods: [
                    BarChartRodData(
                      toY: 5,
                      color: AppTheme.error,
                      width: 16,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildLocationBreakdown() {
    final locations = [
      {'country': 'United States', 'percentage': 35.2, 'color': AppTheme.accent},
      {'country': 'United Kingdom', 'percentage': 18.7, 'color': AppTheme.success},
      {'country': 'Canada', 'percentage': 12.3, 'color': AppTheme.warning},
      {'country': 'Australia', 'percentage': 8.9, 'color': AppTheme.error},
      {'country': 'Others', 'percentage': 24.9, 'color': AppTheme.secondaryText},
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Top Locations',
          style: TextStyle(
            color: AppTheme.secondaryText,
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 8),
        ...locations.map((location) {
          return Container(
            margin: const EdgeInsets.only(bottom: 8),
            child: Row(
              children: [
                Container(
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: location['color'] as Color,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    location['country'] as String,
                    style: const TextStyle(
                      color: AppTheme.primaryText,
                      fontSize: 12,
                    ),
                  ),
                ),
                Text(
                  '${location['percentage']}%',
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
      ],
    );
  }

  Widget _buildChartLegend(List<Map<String, dynamic>> items) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: items.map((item) {
        return Padding(
          padding: const EdgeInsets.only(right: 12),
          child: Row(
            children: [
              Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  color: item['color'] as Color,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
              const SizedBox(width: 4),
              Text(
                item['label'] as String,
                style: const TextStyle(
                  color: AppTheme.secondaryText,
                  fontSize: 10,
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
}