import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';


class LeadGenerationSectionWidget extends StatelessWidget {
  const LeadGenerationSectionWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Upgraded Instagram Search
          _buildUpgradedInstagramSearch(context),
          const SizedBox(height: 24),
          
          // Improved Hashtag Research
          _buildImprovedHashtagResearch(context),
          const SizedBox(height: 24),
          
          // Enhanced Analytics
          _buildEnhancedAnalytics(context),
        ],
      ),
    );
  }

  Widget _buildUpgradedInstagramSearch(BuildContext context) {
    return Container(
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
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Instagram Lead Search',
                    style: GoogleFonts.inter(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Advanced filtering with AI insights',
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      color: const Color(0xFF8E8E93),
                    ),
                  ),
                ],
              ),
              GestureDetector(
                onTap: () {
                  // Navigation code removed due to undefined route
                  // Navigator.pushNamed(context, AppRoutes.instagramLeadSearch);
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: const Color(0xFFE1306C),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    'Start Search',
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          
          // Advanced filters preview
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFF1C1C1E),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: const Color(0xFFE1306C).withAlpha(26),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.filter_list,
                            color: Color(0xFFE1306C),
                            size: 14,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            'Location: New York',
                            style: GoogleFonts.inter(
                              fontSize: 12,
                              color: const Color(0xFFE1306C),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: const Color(0xFF007AFF).withAlpha(26),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.people,
                            color: Color(0xFF007AFF),
                            size: 14,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '1K+ Followers',
                            style: GoogleFonts.inter(
                              fontSize: 12,
                              color: const Color(0xFF007AFF),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: const Color(0xFF34C759).withAlpha(26),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.trending_up,
                            color: Color(0xFF34C759),
                            size: 14,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            'High Engagement',
                            style: GoogleFonts.inter(
                              fontSize: 12,
                              color: const Color(0xFF34C759),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFF9500).withAlpha(26),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.business,
                            color: Color(0xFFFF9500),
                            size: 14,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            'Business Profile',
                            style: GoogleFonts.inter(
                              fontSize: 12,
                              color: const Color(0xFFFF9500),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildImprovedHashtagResearch(BuildContext context) {
    return Container(
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
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Hashtag Research',
                    style: GoogleFonts.inter(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Trend analysis with predictive insights',
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      color: const Color(0xFF8E8E93),
                    ),
                  ),
                ],
              ),
              GestureDetector(
                onTap: () {
                  // Navigation code removed due to undefined route
                  // Navigator.pushNamed(context, AppRoutes.hashtagResearchScreen);
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: const Color(0xFF5856D6),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    'Research',
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          
          // Trending hashtags with analysis
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFF1C1C1E),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Trending Now',
                      style: GoogleFonts.inter(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Colors.white,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: const Color(0xFF34C759).withAlpha(26),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        'Live',
                        style: GoogleFonts.inter(
                          fontSize: 12,
                          color: const Color(0xFF34C759),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                
                Column(
                  children: [
                    _buildHashtagTrend('#digitalmarketing', '2.3M', '+15%', true),
                    const SizedBox(height: 8),
                    _buildHashtagTrend('#entrepreneurship', '1.8M', '+8%', true),
                    const SizedBox(height: 8),
                    _buildHashtagTrend('#smallbusiness', '1.5M', '-2%', false),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHashtagTrend(String hashtag, String usage, String trend, bool isPositive) {
    return Row(
      children: [
        Text(
          hashtag,
          style: GoogleFonts.inter(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: const Color(0xFF007AFF),
          ),
        ),
        const Spacer(),
        Text(
          usage,
          style: GoogleFonts.inter(
            fontSize: 12,
            color: const Color(0xFF8E8E93),
          ),
        ),
        const SizedBox(width: 12),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: isPositive 
                ? const Color(0xFF34C759).withAlpha(26)
                : const Color(0xFFFF3B30).withAlpha(26),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            trend,
            style: GoogleFonts.inter(
              fontSize: 12,
              color: isPositive ? const Color(0xFF34C759) : const Color(0xFFFF3B30),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildEnhancedAnalytics(BuildContext context) {
    return Container(
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
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Enhanced Analytics',
                    style: GoogleFonts.inter(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Predictive insights and comparative analysis',
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      color: const Color(0xFF8E8E93),
                    ),
                  ),
                ],
              ),
              GestureDetector(
                onTap: () {
                  // Navigation code removed due to undefined route
                  // Navigator.pushNamed(context, AppRoutes.socialMediaAnalyticsScreen);
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: const Color(0xFF32D74B),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    'View Analytics',
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          
          // Predictive analytics chart
          Container(
            height: 200,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFF1C1C1E),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Engagement Prediction',
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 12),
                
                Expanded(
                  child: LineChart(
                    LineChartData(
                      gridData: FlGridData(
                        show: true,
                        drawHorizontalLine: true,
                        horizontalInterval: 1,
                        getDrawingHorizontalLine: (value) {
                          return FlLine(
                            color: const Color(0xFF2C2C2E),
                            strokeWidth: 1,
                          );
                        },
                      ),
                      titlesData: const FlTitlesData(show: false),
                      borderData: FlBorderData(show: false),
                      lineBarsData: [
                        // Historical data
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
                          color: const Color(0xFF007AFF),
                          barWidth: 3,
                          isStrokeCapRound: true,
                          dotData: const FlDotData(show: false),
                          belowBarData: BarAreaData(
                            show: true,
                            color: const Color(0xFF007AFF).withAlpha(26),
                          ),
                        ),
                        // Predicted data
                        LineChartBarData(
                          spots: [
                            const FlSpot(6, 7),
                            const FlSpot(7, 8),
                            const FlSpot(8, 9),
                            const FlSpot(9, 8.5),
                            const FlSpot(10, 10),
                          ],
                          isCurved: true,
                          color: const Color(0xFF34C759),
                          barWidth: 3,
                          isStrokeCapRound: true,
                          dotData: const FlDotData(show: false),
                          dashArray: [5, 5],
                        ),
                      ],
                      minX: 0,
                      maxX: 10,
                      minY: 0,
                      maxY: 12,
                    ),
                  ),
                ),
                
                const SizedBox(height: 12),
                Row(
                  children: [
                    _buildLegendItem('Historical', const Color(0xFF007AFF), false),
                    const SizedBox(width: 16),
                    _buildLegendItem('Predicted', const Color(0xFF34C759), true),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLegendItem(String label, Color color, bool isDashed) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 16,
          height: 3,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: 6),
        Text(
          label,
          style: GoogleFonts.inter(
            fontSize: 12,
            color: const Color(0xFF8E8E93),
          ),
        ),
      ],
    );
  }
}