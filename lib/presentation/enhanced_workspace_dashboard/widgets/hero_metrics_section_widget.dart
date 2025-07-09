import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:fl_chart/fl_chart.dart';

class HeroMetricsSectionWidget extends StatelessWidget {
  final bool isRefreshing;
  final AnimationController refreshController;

  const HeroMetricsSectionWidget({
    Key? key,
    required this.isRefreshing,
    required this.refreshController,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Performance Overview',
              style: GoogleFonts.inter(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: const Color(0xFF34C759).withAlpha(26),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 6,
                    height: 6,
                    decoration: const BoxDecoration(
                      color: Color(0xFF34C759),
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 6),
                  Text(
                    'Live',
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: const Color(0xFF34C759),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        
        SizedBox(
          height: 180,
          child: ListView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.only(right: 16),
            children: [
              _buildMetricCard(
                title: 'Total Leads',
                value: '2,847',
                change: '+12.5%',
                isPositive: true,
                icon: Icons.people,
                color: const Color(0xFF007AFF),
                sparklineData: [1, 3, 2, 4, 5, 3, 6, 7, 5, 8],
              ),
              _buildMetricCard(
                title: 'Revenue',
                value: '\$45,320',
                change: '+8.2%',
                isPositive: true,
                icon: Icons.attach_money,
                color: const Color(0xFF34C759),
                sparklineData: [2, 4, 3, 5, 6, 4, 7, 8, 6, 9],
              ),
              _buildMetricCard(
                title: 'Social Followers',
                value: '12.4K',
                change: '+15.3%',
                isPositive: true,
                icon: Icons.favorite,
                color: const Color(0xFFFF3B30),
                sparklineData: [3, 5, 4, 6, 7, 5, 8, 9, 7, 10],
              ),
              _buildMetricCard(
                title: 'Course Enrollments',
                value: '384',
                change: '+22.1%',
                isPositive: true,
                icon: Icons.school,
                color: const Color(0xFFFF9500),
                sparklineData: [1, 2, 3, 4, 5, 6, 7, 8, 9, 10],
              ),
              _buildMetricCard(
                title: 'App Downloads',
                value: '1,523',
                change: '+5.7%',
                isPositive: true,
                icon: Icons.download,
                color: const Color(0xFF5856D6),
                sparklineData: [5, 4, 6, 5, 7, 6, 8, 7, 9, 8],
              ),
              _buildMetricCard(
                title: 'Production Status',
                value: '98.5%',
                change: '+1.2%',
                isPositive: true,
                icon: Icons.speed,
                color: const Color(0xFF32D74B),
                sparklineData: [8, 9, 8, 9, 10, 9, 10, 9, 10, 10],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildMetricCard({
    required String title,
    required String value,
    required String change,
    required bool isPositive,
    required IconData icon,
    required Color color,
    required List<double> sparklineData,
  }) {
    return Container(
      width: 200,
      margin: const EdgeInsets.only(right: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF191919),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: const Color(0xFF2C2C2E),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(26),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: color.withAlpha(26),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  icon,
                  color: color,
                  size: 20,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: isPositive 
                      ? const Color(0xFF34C759).withAlpha(26)
                      : const Color(0xFFFF3B30).withAlpha(26),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  change,
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: isPositive ? const Color(0xFF34C759) : const Color(0xFFFF3B30),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            value,
            style: GoogleFonts.inter(
              fontSize: 24,
              fontWeight: FontWeight.w700,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: GoogleFonts.inter(
              fontSize: 14,
              color: const Color(0xFF8E8E93),
            ),
          ),
          const SizedBox(height: 16),
          
          // Sparkline Chart
          SizedBox(
            height: 40,
            child: LineChart(
              LineChartData(
                gridData: const FlGridData(show: false),
                titlesData: const FlTitlesData(show: false),
                borderData: FlBorderData(show: false),
                lineBarsData: [
                  LineChartBarData(
                    spots: sparklineData.asMap().entries.map((e) {
                      return FlSpot(e.key.toDouble(), e.value);
                    }).toList(),
                    isCurved: true,
                    color: color,
                    barWidth: 2,
                    isStrokeCapRound: true,
                    dotData: const FlDotData(show: false),
                    belowBarData: BarAreaData(
                      show: true,
                      color: color.withAlpha(26),
                    ),
                  ),
                ],
                minX: 0,
                maxX: sparklineData.length - 1,
                minY: 0,
                maxY: sparklineData.reduce((a, b) => a > b ? a : b),
              ),
            ),
          ),
        ],
      ),
    );
  }
}