import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../../widgets/custom_icon_widget.dart';

class HashtagAnalyticsWidget extends StatelessWidget {
  final List<Map<String, dynamic>> hashtags;

  const HashtagAnalyticsWidget({
    Key? key,
    required this.hashtags,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          // Performance Overview
          _buildPerformanceOverview(),

          const SizedBox(height: 24),

          // Engagement Chart
          _buildEngagementChart(),

          const SizedBox(height: 24),

          // Top Performing Hashtags
          _buildTopPerformingHashtags(),

          const SizedBox(height: 24),

          // Competition Analysis
          _buildCompetitionAnalysis(),
        ]));
  }

  Widget _buildPerformanceOverview() {
    final totalUsage =
        hashtags.fold<int>(0, (sum, h) => sum + (h['usageCount'] as int));
    final avgEngagement = hashtags.fold<double>(
            0, (sum, h) => sum + (h['engagementRate'] as double)) /
        hashtags.length;

    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text('Performance Overview',
          style: GoogleFonts.inter(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: const Color(0xFFF1F1F1))),
      const SizedBox(height: 16),
      Row(children: [
        Expanded(
            child: _buildMetricCard(
                'Total Usage',
                '${(totalUsage / 1000000).toStringAsFixed(1)}M',
                Icons.tag,
                const Color(0xFF3B82F6))),
        const SizedBox(width: 12),
        Expanded(
            child: _buildMetricCard(
                'Avg Engagement',
                '${avgEngagement.toStringAsFixed(1)}%',
                Icons.favorite,
                const Color(0xFF10B981))),
      ]),
      const SizedBox(height: 12),
      Row(children: [
        Expanded(
            child: _buildMetricCard('Hashtags', hashtags.length.toString(),
                Icons.numbers, const Color(0xFFF59E0B))),
        const SizedBox(width: 12),
        Expanded(
            child: _buildMetricCard(
                'Trending',
                hashtags.where((h) => h['trend'] == 'Rising').length.toString(),
                Icons.trending_up,
                const Color(0xFF10B981))),
      ]),
    ]);
  }

  Widget _buildEngagementChart() {
    return Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
            color: const Color(0xFF191919),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: const Color(0xFF282828), width: 1)),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text('Engagement vs Usage',
              style: GoogleFonts.inter(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFFF1F1F1))),
          const SizedBox(height: 16),
          SizedBox(
              height: 200,
              child: LineChart(LineChartData(
                  backgroundColor: Colors.transparent,
                  gridData: FlGridData(
                      show: true,
                      drawVerticalLine: true,
                      drawHorizontalLine: true,
                      getDrawingHorizontalLine: (value) => FlLine(
                          color: const Color(0xFF282828), strokeWidth: 1),
                      getDrawingVerticalLine: (value) => FlLine(
                          color: const Color(0xFF282828), strokeWidth: 1)),
                  titlesData: FlTitlesData(
                      bottomTitles: AxisTitles(
                          axisNameWidget: Text('Usage (M)',
                              style: GoogleFonts.inter(
                                  fontSize: 12,
                                  color: const Color(0xFF7B7B7B))),
                          sideTitles: SideTitles(
                              showTitles: true,
                              getTitlesWidget: (value, meta) {
                                return Text('${value.toInt()}M',
                                    style: GoogleFonts.inter(
                                        fontSize: 10,
                                        color: const Color(0xFF7B7B7B)));
                              })),
                      leftTitles: AxisTitles(
                          axisNameWidget: Text('Engagement %',
                              style: GoogleFonts.inter(
                                  fontSize: 12,
                                  color: const Color(0xFF7B7B7B))),
                          sideTitles: SideTitles(
                              showTitles: true,
                              getTitlesWidget: (value, meta) {
                                return Text('${value.toInt()}%',
                                    style: GoogleFonts.inter(
                                        fontSize: 10,
                                        color: const Color(0xFF7B7B7B)));
                              })),
                      rightTitles: const AxisTitles(
                          sideTitles: SideTitles(showTitles: false)),
                      topTitles: const AxisTitles(
                          sideTitles: SideTitles(showTitles: false))),
                  borderData: FlBorderData(
                      show: true,
                      border:
                          Border.all(color: const Color(0xFF282828), width: 1)),
                  lineBarsData: [
                    LineChartBarData(
                        spots: hashtags.asMap().entries.map((entry) {
                          final index = entry.key;
                          final hashtag = entry.value;
                          return FlSpot(
                              (hashtag['usageCount'] as int) / 1000000,
                              hashtag['engagementRate'] as double);
                        }).toList(),
                        isCurved: true,
                        color: const Color(0xFF3B82F6),
                        barWidth: 3,
                        belowBarData: BarAreaData(
                            show: true,
                            color: const Color(0xFF3B82F6).withAlpha(26)),
                        dotData: FlDotData(
                            show: true,
                            getDotPainter: (spot, percent, barData, index) {
                              return FlDotCirclePainter(
                                  radius: 4,
                                  color: const Color(0xFF3B82F6),
                                  strokeWidth: 2,
                                  strokeColor: const Color(0xFF191919));
                            })),
                  ]))),
        ]));
  }

  Widget _buildTopPerformingHashtags() {
    final sortedHashtags = List<Map<String, dynamic>>.from(hashtags);
    sortedHashtags.sort((a, b) => (b['engagementRate'] as double)
        .compareTo(a['engagementRate'] as double));

    return Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
            color: const Color(0xFF191919),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: const Color(0xFF282828), width: 1)),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text('Top Performing Hashtags',
              style: GoogleFonts.inter(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFFF1F1F1))),
          const SizedBox(height: 16),
          ...sortedHashtags.take(3).map((hashtag) {
            return Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Row(children: [
                  Expanded(
                      child: Text(hashtag['hashtag'],
                          style: GoogleFonts.inter(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: const Color(0xFFF1F1F1)))),
                  Text('${hashtag['engagementRate']}%',
                      style: GoogleFonts.inter(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFF10B981))),
                ]));
          }).toList(),
        ]));
  }

  Widget _buildCompetitionAnalysis() {
    final competitionCounts = <String, int>{};
    for (final hashtag in hashtags) {
      final competition = hashtag['competition'] as String;
      competitionCounts[competition] =
          (competitionCounts[competition] ?? 0) + 1;
    }

    return Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
            color: const Color(0xFF191919),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: const Color(0xFF282828), width: 1)),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text('Competition Analysis',
              style: GoogleFonts.inter(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFFF1F1F1))),
          const SizedBox(height: 16),
          ...competitionCounts.entries.map((entry) {
            final competition = entry.key;
            final count = entry.value;
            final percentage = (count / hashtags.length * 100).toInt();

            Color color;
            switch (competition.toLowerCase()) {
              case 'low':
                color = const Color(0xFF10B981);
                break;
              case 'medium':
                color = const Color(0xFFF59E0B);
                break;
              case 'high':
                color = const Color(0xFFEF4444);
                break;
              default:
                color = const Color(0xFF7B7B7B);
            }

            return Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Row(children: [
                  Container(
                      width: 16,
                      height: 16,
                      decoration:
                          BoxDecoration(color: color, shape: BoxShape.circle)),
                  const SizedBox(width: 12),
                  Expanded(
                      child: Text('${competition.toUpperCase()} Competition',
                          style: GoogleFonts.inter(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: const Color(0xFFF1F1F1)))),
                  Text('$count ($percentage%)',
                      style: GoogleFonts.inter(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFF7B7B7B))),
                ]));
          }).toList(),
        ]));
  }

  Widget _buildMetricCard(
      String title, String value, IconData icon, Color color) {
    return Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
            color: const Color(0xFF191919),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: const Color(0xFF282828), width: 1)),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(children: [
            CustomIconWidget(iconName: icon.toString(), color: color, size: 20),
            const SizedBox(width: 8),
            Expanded(
                child: Text(title,
                    style: GoogleFonts.inter(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: const Color(0xFF7B7B7B)))),
          ]),
          const SizedBox(height: 8),
          Text(value,
              style: GoogleFonts.inter(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFFF1F1F1))),
        ]));
  }
}
