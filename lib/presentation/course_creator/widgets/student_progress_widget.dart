
import '../../../core/app_export.dart';

class StudentProgressWidget extends StatelessWidget {
  final Map<String, dynamic> analytics;

  const StudentProgressWidget({
    Key? key,
    required this.analytics,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(4.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Student Analytics',
            style: AppTheme.darkTheme.textTheme.headlineSmall,
          ),
          SizedBox(height: 3.h),
          _buildOverviewCards(),
          SizedBox(height: 3.h),
          _buildCompletionChart(),
          SizedBox(height: 3.h),
          _buildEngagementChart(),
          SizedBox(height: 3.h),
          _buildRecentActivity(),
        ],
      ),
    );
  }

  Widget _buildOverviewCards() {
    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      crossAxisSpacing: 3.w,
      mainAxisSpacing: 2.h,
      childAspectRatio: 1.5,
      children: [
        _buildMetricCard(
          'Total Students',
          analytics["totalStudents"].toString(),
          'people',
          AppTheme.accent,
        ),
        _buildMetricCard(
          'Completion Rate',
          '${analytics["completionRate"]}%',
          'trending_up',
          AppTheme.success,
        ),
        _buildMetricCard(
          'Average Rating',
          '${analytics["averageRating"]}/5',
          'star',
          AppTheme.warning,
        ),
        _buildMetricCard(
          'Total Revenue',
          analytics["totalRevenue"],
          'attach_money',
          AppTheme.success,
        ),
      ],
    );
  }

  Widget _buildMetricCard(
      String title, String value, String iconName, Color color) {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(3.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CustomIconWidget(
                  iconName: iconName,
                  color: color,
                  size: 24,
                ),
                Container(
                  padding:
                      EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.5.h),
                  decoration: BoxDecoration(
                    color: color.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: CustomIconWidget(
                    iconName: 'trending_up',
                    color: color,
                    size: 12,
                  ),
                ),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  value,
                  style: AppTheme.darkTheme.textTheme.titleLarge?.copyWith(
                    color: color,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  title,
                  style: AppTheme.darkTheme.textTheme.bodySmall,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCompletionChart() {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(4.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Completion Progress',
              style: AppTheme.darkTheme.textTheme.titleMedium,
            ),
            SizedBox(height: 2.h),
            Container(
              height: 30.h,
              child: LineChart(
                LineChartData(
                  gridData: FlGridData(
                    show: true,
                    drawVerticalLine: false,
                    horizontalInterval: 20,
                    getDrawingHorizontalLine: (value) {
                      return FlLine(
                        color: AppTheme.border,
                        strokeWidth: 1,
                      );
                    },
                  ),
                  titlesData: FlTitlesData(
                    show: true,
                    rightTitles:
                        AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    topTitles:
                        AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 30,
                        interval: 1,
                        getTitlesWidget: (double value, TitleMeta meta) {
                          const style = TextStyle(
                            color: AppTheme.secondaryText,
                            fontWeight: FontWeight.w400,
                            fontSize: 12,
                          );
                          Widget text;
                          switch (value.toInt()) {
                            case 0:
                              text = Text('Jan', style: style);
                              break;
                            case 1:
                              text = Text('Feb', style: style);
                              break;
                            case 2:
                              text = Text('Mar', style: style);
                              break;
                            case 3:
                              text = Text('Apr', style: style);
                              break;
                            case 4:
                              text = Text('May', style: style);
                              break;
                            case 5:
                              text = Text('Jun', style: style);
                              break;
                            default:
                              text = Text('', style: style);
                              break;
                          }
                          return SideTitleWidget(
                            axisSide: meta.axisSide,
                            child: text,
                          );
                        },
                      ),
                    ),
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        interval: 20,
                        getTitlesWidget: (double value, TitleMeta meta) {
                          return Text(
                            '${value.toInt()}%',
                            style: TextStyle(
                              color: AppTheme.secondaryText,
                              fontWeight: FontWeight.w400,
                              fontSize: 12,
                            ),
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
                  maxX: 5,
                  minY: 0,
                  maxY: 100,
                  lineBarsData: [
                    LineChartBarData(
                      spots: [
                        FlSpot(0, 20),
                        FlSpot(1, 35),
                        FlSpot(2, 45),
                        FlSpot(3, 60),
                        FlSpot(4, 68),
                        FlSpot(5, 68.5),
                      ],
                      isCurved: true,
                      gradient: LinearGradient(
                        colors: [AppTheme.accent, AppTheme.success],
                      ),
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
                        gradient: LinearGradient(
                          colors: [
                            AppTheme.accent.withValues(alpha: 0.3),
                            AppTheme.success.withValues(alpha: 0.1),
                          ],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEngagementChart() {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(4.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Engagement Metrics',
              style: AppTheme.darkTheme.textTheme.titleMedium,
            ),
            SizedBox(height: 2.h),
            Container(
              height: 25.h,
              child: PieChart(
                PieChartData(
                  pieTouchData: PieTouchData(
                    touchCallback: (FlTouchEvent event, pieTouchResponse) {},
                    enabled: true,
                  ),
                  borderData: FlBorderData(show: false),
                  sectionsSpace: 2,
                  centerSpaceRadius: 8.w,
                  sections: [
                    PieChartSectionData(
                      color: AppTheme.success,
                      value: analytics["engagementRate"],
                      title: '${analytics["engagementRate"]}%',
                      radius: 12.w,
                      titleStyle:
                          AppTheme.darkTheme.textTheme.labelMedium?.copyWith(
                        color: AppTheme.primaryText,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    PieChartSectionData(
                      color: AppTheme.error,
                      value: analytics["dropoffRate"],
                      title: '${analytics["dropoffRate"]}%',
                      radius: 12.w,
                      titleStyle:
                          AppTheme.darkTheme.textTheme.labelMedium?.copyWith(
                        color: AppTheme.primaryText,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    PieChartSectionData(
                      color: AppTheme.border,
                      value: (100 -
                              analytics["engagementRate"] -
                              analytics["dropoffRate"])
                          .toDouble(),
                      title:
                          '${(100 - analytics["engagementRate"] - analytics["dropoffRate"]).toStringAsFixed(1)}%',
                      radius: 12.w,
                      titleStyle:
                          AppTheme.darkTheme.textTheme.labelMedium?.copyWith(
                        color: AppTheme.primaryText,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 2.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildLegendItem('Engaged', AppTheme.success),
                _buildLegendItem('Dropped', AppTheme.error),
                _buildLegendItem('Inactive', AppTheme.border),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLegendItem(String label, Color color) {
    return Row(
      children: [
        Container(
          width: 3.w,
          height: 3.w,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
        SizedBox(width: 1.w),
        Text(
          label,
          style: AppTheme.darkTheme.textTheme.bodySmall,
        ),
      ],
    );
  }

  Widget _buildRecentActivity() {
    final List<Map<String, dynamic>> recentActivities = [
{ "student": "Sarah Johnson",
"action": "Completed Module 1",
"time": "2 hours ago",
"avatar": "https://images.pexels.com/photos/774909/pexels-photo-774909.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1",
},
{ "student": "Mike Chen",
"action": "Started Quiz: Flutter Basics",
"time": "4 hours ago",
"avatar": "https://images.pexels.com/photos/1040880/pexels-photo-1040880.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1",
},
{ "student": "Emma Davis",
"action": "Submitted Assignment 2",
"time": "6 hours ago",
"avatar": "https://images.pexels.com/photos/1130626/pexels-photo-1130626.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1",
},
{ "student": "Alex Rodriguez",
"action": "Posted in Discussion Forum",
"time": "8 hours ago",
"avatar": "https://images.pexels.com/photos/1222271/pexels-photo-1222271.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1",
},
];

    return Card(
      child: Padding(
        padding: EdgeInsets.all(4.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Recent Activity',
                  style: AppTheme.darkTheme.textTheme.titleMedium,
                ),
                TextButton(
                  onPressed: () {
                    // View all activities
                  },
                  child: Text('View All'),
                ),
              ],
            ),
            SizedBox(height: 2.h),
            ...recentActivities
                .map((activity) => _buildActivityItem(activity))
                .toList(),
          ],
        ),
      ),
    );
  }

  Widget _buildActivityItem(Map<String, dynamic> activity) {
    return Padding(
      padding: EdgeInsets.only(bottom: 2.h),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: CustomImageWidget(
              imageUrl: activity["avatar"],
              width: 10.w,
              height: 10.w,
              fit: BoxFit.cover,
            ),
          ),
          SizedBox(width: 3.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                RichText(
                  text: TextSpan(
                    style: AppTheme.darkTheme.textTheme.bodyMedium,
                    children: [
                      TextSpan(
                        text: activity["student"],
                        style: TextStyle(fontWeight: FontWeight.w500),
                      ),
                      TextSpan(text: ' ${activity["action"]}'),
                    ],
                  ),
                ),
                SizedBox(height: 0.5.h),
                Text(
                  activity["time"],
                  style: AppTheme.darkTheme.textTheme.bodySmall,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}