import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:fl_chart/fl_chart.dart';

class HeroAnalyticsSectionWidget extends StatelessWidget {
  final bool isRefreshing;
  final AnimationController refreshController;
  final List<Map<String, dynamic>> platforms;

  const HeroAnalyticsSectionWidget({
    Key? key,
    required this.isRefreshing,
    required this.refreshController,
    required this.platforms,
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
              'Analytics Overview',
              style: GoogleFonts.inter(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: const Color(0xFF191919),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: const Color(0xFF2C2C2E),
                  width: 1,
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.calendar_today,
                    color: Color(0xFF8E8E93),
                    size: 14,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    'Last 7 days',
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      color: const Color(0xFF8E8E93),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        
        SizedBox(
          height: 200,
          child: ListView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.only(right: 16),
            children: [
              _buildUnifiedMetricsCard(),
              _buildEngagementCard(),
              _buildContentPipelineCard(),
              _buildLeadGenerationCard(),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildUnifiedMetricsCard() {
    final totalFollowers = platforms.fold<int>(0, (sum, platform) {
      if (platform['isConnected'] as bool) {
        final followers = platform['followers'] as String;
        final numStr = followers.replaceAll(RegExp(r'[^\d.]'), '');
        final multiplier = followers.contains('K') ? 1000 : 1;
        return sum + ((double.tryParse(numStr) ?? 0) * multiplier).toInt();
      }
      return sum;
    });

    return Container(
      width: 220,
      margin: const EdgeInsets.only(right: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF191919),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: const Color(0xFF2C2C2E),
          width: 1,
        ),
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
                  color: const Color(0xFF007AFF).withAlpha(26),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.people,
                  color: Color(0xFF007AFF),
                  size: 20,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFF34C759).withAlpha(26),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  '+12.3%',
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: const Color(0xFF34C759),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            '${(totalFollowers / 1000).toStringAsFixed(1)}K',
            style: GoogleFonts.inter(
              fontSize: 24,
              fontWeight: FontWeight.w700,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Total Followers',
            style: GoogleFonts.inter(
              fontSize: 14,
              color: const Color(0xFF8E8E93),
            ),
          ),
          const SizedBox(height: 16),
          
          // Platform breakdown
          Column(
            children: platforms.take(3).map((platform) {
              if (platform['isConnected'] as bool) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Row(
                    children: [
                      Container(
                        width: 16,
                        height: 16,
                        decoration: BoxDecoration(
                          color: platform['color'] as Color,
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          platform['name'] as String,
                          style: GoogleFonts.inter(
                            fontSize: 12,
                            color: const Color(0xFF8E8E93),
                          ),
                        ),
                      ),
                      Text(
                        platform['followers'] as String,
                        style: GoogleFonts.inter(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                );
              }
              return const SizedBox.shrink();
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildEngagementCard() {
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
                  color: const Color(0xFF34C759).withAlpha(26),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.favorite,
                  color: Color(0xFF34C759),
                  size: 20,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFF34C759).withAlpha(26),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  '+8.7%',
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: const Color(0xFF34C759),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            '7.2%',
            style: GoogleFonts.inter(
              fontSize: 24,
              fontWeight: FontWeight.w700,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Avg. Engagement',
            style: GoogleFonts.inter(
              fontSize: 14,
              color: const Color(0xFF8E8E93),
            ),
          ),
          const SizedBox(height: 16),
          
          // Engagement trend chart
          SizedBox(
            height: 50,
            child: LineChart(
              LineChartData(
                gridData: const FlGridData(show: false),
                titlesData: const FlTitlesData(show: false),
                borderData: FlBorderData(show: false),
                lineBarsData: [
                  LineChartBarData(
                    spots: [
                      const FlSpot(0, 3),
                      const FlSpot(1, 4),
                      const FlSpot(2, 3.5),
                      const FlSpot(3, 5),
                      const FlSpot(4, 4.5),
                      const FlSpot(5, 6),
                      const FlSpot(6, 7),
                    ],
                    isCurved: true,
                    color: const Color(0xFF34C759),
                    barWidth: 2,
                    isStrokeCapRound: true,
                    dotData: const FlDotData(show: false),
                    belowBarData: BarAreaData(
                      show: true,
                      color: const Color(0xFF34C759).withAlpha(26),
                    ),
                  ),
                ],
                minX: 0,
                maxX: 6,
                minY: 0,
                maxY: 8,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContentPipelineCard() {
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
                  color: const Color(0xFFFF9500).withAlpha(26),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.schedule,
                  color: Color(0xFFFF9500),
                  size: 20,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFF007AFF).withAlpha(26),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  '24 Scheduled',
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: const Color(0xFF007AFF),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            '142',
            style: GoogleFonts.inter(
              fontSize: 24,
              fontWeight: FontWeight.w700,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Content Pipeline',
            style: GoogleFonts.inter(
              fontSize: 14,
              color: const Color(0xFF8E8E93),
            ),
          ),
          const SizedBox(height: 16),
          
          // Pipeline status
          Column(
            children: [
              _buildPipelineItem('Draft', 42, const Color(0xFF8E8E93)),
              _buildPipelineItem('Scheduled', 24, const Color(0xFF007AFF)),
              _buildPipelineItem('Published', 76, const Color(0xFF34C759)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPipelineItem(String label, int count, Color color) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              label,
              style: GoogleFonts.inter(
                fontSize: 12,
                color: const Color(0xFF8E8E93),
              ),
            ),
          ),
          Text(
            count.toString(),
            style: GoogleFonts.inter(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLeadGenerationCard() {
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
                  color: const Color(0xFF5856D6).withAlpha(26),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.trending_up,
                  color: Color(0xFF5856D6),
                  size: 20,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFF34C759).withAlpha(26),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  '+15.2%',
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: const Color(0xFF34C759),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            '1,847',
            style: GoogleFonts.inter(
              fontSize: 24,
              fontWeight: FontWeight.w700,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Leads Generated',
            style: GoogleFonts.inter(
              fontSize: 14,
              color: const Color(0xFF8E8E93),
            ),
          ),
          const SizedBox(height: 16),
          
          // Lead sources
          Column(
            children: [
              _buildPipelineItem('Instagram', 1247, const Color(0xFFE1306C)),
              _buildPipelineItem('Facebook', 342, const Color(0xFF1877F2)),
              _buildPipelineItem('TikTok', 258, const Color(0xFF000000)),
            ],
          ),
        ],
      ),
    );
  }
}