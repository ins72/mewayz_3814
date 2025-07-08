import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../../widgets/custom_icon_widget.dart';

class TemplateAnalyticsWidget extends StatelessWidget {
  final List<Map<String, dynamic>> templates;

  const TemplateAnalyticsWidget({
    Key? key,
    required this.templates,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          // Performance Overview
          _buildPerformanceOverview(),

          const SizedBox(height: 24),

          // Usage Chart
          _buildUsageChart(),

          const SizedBox(height: 24),

          // Top Templates
          _buildTopTemplates(),

          const SizedBox(height: 24),

          // Category Performance
          _buildCategoryPerformance(),
        ]));
  }

  Widget _buildPerformanceOverview() {
    final totalUsage =
        templates.fold<int>(0, (sum, t) => sum + (t['usageCount'] as int));
    final avgEngagement = templates.fold<double>(
            0, (sum, t) => sum + (t['engagementScore'] as double)) /
        templates.length;
    final favoriteCount =
        templates.where((t) => t['isFavorite'] == true).length;

    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text('Template Performance',
          style: GoogleFonts.inter(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: const Color(0xFFF1F1F1))),
      const SizedBox(height: 16),
      Row(children: [
        Expanded(
            child: _buildMetricCard(
                'Total Usage',
                '${(totalUsage / 1000).toStringAsFixed(1)}K',
                Icons.download,
                const Color(0xFF3B82F6))),
        const SizedBox(width: 12),
        Expanded(
            child: _buildMetricCard(
                'Avg Rating',
                avgEngagement.toStringAsFixed(1),
                Icons.star,
                const Color(0xFFF59E0B))),
      ]),
      const SizedBox(height: 12),
      Row(children: [
        Expanded(
            child: _buildMetricCard('Templates', templates.length.toString(),
                Icons.dashboard, const Color(0xFF10B981))),
        const SizedBox(width: 12),
        Expanded(
            child: _buildMetricCard('Favorites', favoriteCount.toString(),
                Icons.favorite, const Color(0xFFEF4444))),
      ]),
    ]);
  }

  Widget _buildUsageChart() {
    final sortedTemplates = List<Map<String, dynamic>>.from(templates);
    sortedTemplates.sort(
        (a, b) => (b['usageCount'] as int).compareTo(a['usageCount'] as int));
    final topTemplates = sortedTemplates.take(5).toList();

    return Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
            color: const Color(0xFF191919),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: const Color(0xFF282828), width: 1)),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text('Usage Statistics',
              style: GoogleFonts.inter(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFFF1F1F1))),
          const SizedBox(height: 16),
          SizedBox(
              height: 200,
              child: BarChart(BarChartData(
                  backgroundColor: Colors.transparent,
                  gridData: FlGridData(
                      show: true,
                      drawVerticalLine: false,
                      getDrawingHorizontalLine: (value) => FlLine(
                          color: const Color(0xFF282828), strokeWidth: 1)),
                  titlesData: FlTitlesData(
                      bottomTitles: AxisTitles(
                          sideTitles: SideTitles(
                              showTitles: true,
                              getTitlesWidget: (value, meta) {
                                final index = value.toInt();
                                if (index >= 0 && index < topTemplates.length) {
                                  return Padding(
                                      padding: const EdgeInsets.only(top: 8),
                                      child: Text(
                                          topTemplates[index]['title']
                                              .toString()
                                              .split(' ')
                                              .first,
                                          style: GoogleFonts.inter(
                                              fontSize: 10,
                                              color: const Color(0xFF7B7B7B))));
                                }
                                return const SizedBox();
                              })),
                      leftTitles: AxisTitles(
                          sideTitles: SideTitles(
                              showTitles: true,
                              getTitlesWidget: (value, meta) {
                                return Text(
                                    '${(value / 1000).toStringAsFixed(0)}K',
                                    style: GoogleFonts.inter(
                                        fontSize: 10,
                                        color: const Color(0xFF7B7B7B)));
                              })),
                      rightTitles: const AxisTitles(
                          sideTitles: SideTitles(showTitles: false)),
                      topTitles: const AxisTitles(
                          sideTitles: SideTitles(showTitles: false))),
                  borderData: FlBorderData(show: false),
                  barGroups: topTemplates.asMap().entries.map((entry) {
                    final index = entry.key;
                    final template = entry.value;
                    return BarChartGroupData(x: index, barRods: [
                      BarChartRodData(
                          toY: (template['usageCount'] as int).toDouble(),
                          color: const Color(0xFF3B82F6),
                          width: 20,
                          borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(4),
                              topRight: Radius.circular(4))),
                    ]);
                  }).toList()))),
        ]));
  }

  Widget _buildTopTemplates() {
    final sortedTemplates = List<Map<String, dynamic>>.from(templates);
    sortedTemplates.sort(
        (a, b) => (b['usageCount'] as int).compareTo(a['usageCount'] as int));

    return Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
            color: const Color(0xFF191919),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: const Color(0xFF282828), width: 1)),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text('Top Performing Templates',
              style: GoogleFonts.inter(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFFF1F1F1))),
          const SizedBox(height: 16),
          ...sortedTemplates.take(3).map((template) {
            return Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Row(children: [
                  Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          color: const Color(0xFF282828)),
                      child: ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.network(template['thumbnail'],
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) =>
                                  const Icon(Icons.image,
                                      color: Color(0xFF7B7B7B))))),
                  const SizedBox(width: 12),
                  Expanded(
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                        Text(template['title'],
                            style: GoogleFonts.inter(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                color: const Color(0xFFF1F1F1))),
                        const SizedBox(height: 4),
                        Text(template['category'].toUpperCase(),
                            style: GoogleFonts.inter(
                                fontSize: 10,
                                fontWeight: FontWeight.w500,
                                color: const Color(0xFF7B7B7B))),
                      ])),
                  Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
                    Text(
                        '${((template['usageCount'] as int) / 1000).toStringAsFixed(1)}K',
                        style: GoogleFonts.inter(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: const Color(0xFF10B981))),
                    const SizedBox(height: 4),
                    Row(mainAxisSize: MainAxisSize.min, children: [
                      const CustomIconWidget(
                          iconName: 'star', color: Color(0xFFF59E0B), size: 12),
                      const SizedBox(width: 2),
                      Text(template['engagementScore'].toString(),
                          style: GoogleFonts.inter(
                              fontSize: 10,
                              fontWeight: FontWeight.w500,
                              color: const Color(0xFF7B7B7B))),
                    ]),
                  ]),
                ]));
          }).toList(),
        ]));
  }

  Widget _buildCategoryPerformance() {
    final categoryStats = <String, Map<String, dynamic>>{};

    for (final template in templates) {
      final category = template['category'] as String;
      if (!categoryStats.containsKey(category)) {
        categoryStats[category] = {
          'count': 0,
          'totalUsage': 0,
          'avgEngagement': 0.0,
        };
      }

      categoryStats[category]!['count'] += 1;
      categoryStats[category]!['totalUsage'] += template['usageCount'] as int;
      categoryStats[category]!['avgEngagement'] +=
          template['engagementScore'] as double;
    }

    categoryStats.forEach((key, value) {
      value['avgEngagement'] = value['avgEngagement'] / value['count'];
    });

    return Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
            color: const Color(0xFF191919),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: const Color(0xFF282828), width: 1)),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text('Category Performance',
              style: GoogleFonts.inter(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFFF1F1F1))),
          const SizedBox(height: 16),
          ...categoryStats.entries.map((entry) {
            final category = entry.key;
            final stats = entry.value;

            return Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Row(children: [
                  Expanded(
                      child: Text(category.toUpperCase(),
                          style: GoogleFonts.inter(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: const Color(0xFFF1F1F1)))),
                  Text('${stats['count']} templates',
                      style: GoogleFonts.inter(
                          fontSize: 12,
                          fontWeight: FontWeight.w400,
                          color: const Color(0xFF7B7B7B))),
                  const SizedBox(width: 16),
                  Text(
                      '${(stats['totalUsage'] / 1000).toStringAsFixed(1)}K uses',
                      style: GoogleFonts.inter(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: const Color(0xFF10B981))),
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
            CustomIconWidget(iconName: 'metric', color: color, size: 20),
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
