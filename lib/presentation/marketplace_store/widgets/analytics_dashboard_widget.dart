
import '../../../core/app_export.dart';

class AnalyticsDashboardWidget extends StatefulWidget {
  final Map<String, dynamic> storeData;
  final List<Map<String, dynamic>> products;
  final List<Map<String, dynamic>> orders;

  const AnalyticsDashboardWidget({
    Key? key,
    required this.storeData,
    required this.products,
    required this.orders,
  }) : super(key: key);

  @override
  State<AnalyticsDashboardWidget> createState() =>
      _AnalyticsDashboardWidgetState();
}

class _AnalyticsDashboardWidgetState extends State<AnalyticsDashboardWidget> {
  String selectedPeriod = '7d';

  final List<Map<String, dynamic>> salesData = [
{"day": "Mon", "sales": 1200},
{"day": "Tue", "sales": 1800},
{"day": "Wed", "sales": 1500},
{"day": "Thu", "sales": 2200},
{"day": "Fri", "sales": 2800},
{"day": "Sat", "sales": 3200},
{"day": "Sun", "sales": 2600},
];

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(4.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Period Selector
          _buildPeriodSelector(),
          SizedBox(height: 2.h),
          // Key Metrics
          _buildKeyMetrics(),
          SizedBox(height: 3.h),
          // Sales Chart
          _buildSalesChart(),
          SizedBox(height: 3.h),
          // Top Products
          _buildTopProducts(),
          SizedBox(height: 3.h),
          // Order Status Distribution
          _buildOrderStatusChart(),
        ],
      ),
    );
  }

  Widget _buildPeriodSelector() {
    return Row(
      children: [
        Text(
          'Analytics',
          style: AppTheme.darkTheme.textTheme.titleLarge,
        ),
        const Spacer(),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
          decoration: BoxDecoration(
            color: AppTheme.surface,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: AppTheme.border),
          ),
          child: DropdownButton<String>(
            value: selectedPeriod,
            underline: const SizedBox(),
            dropdownColor: AppTheme.surface,
            style: AppTheme.darkTheme.textTheme.bodyMedium,
            items: const [
              DropdownMenuItem(value: '7d', child: Text('Last 7 days')),
              DropdownMenuItem(value: '30d', child: Text('Last 30 days')),
              DropdownMenuItem(value: '90d', child: Text('Last 90 days')),
            ],
            onChanged: (value) {
              setState(() {
                selectedPeriod = value!;
              });
            },
          ),
        ),
      ],
    );
  }

  Widget _buildKeyMetrics() {
    return Row(
      children: [
        Expanded(
          child: _buildMetricCard(
            'Total Sales',
            '\$12,450',
            '+15.2%',
            AppTheme.success,
            'trending_up',
          ),
        ),
        SizedBox(width: 3.w),
        Expanded(
          child: _buildMetricCard(
            'Conversion',
            '3.2%',
            '+0.8%',
            AppTheme.accent,
            'analytics',
          ),
        ),
      ],
    );
  }

  Widget _buildMetricCard(
      String title, String value, String change, Color color, String iconName) {
    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppTheme.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: AppTheme.darkTheme.textTheme.bodyMedium,
              ),
              CustomIconWidget(
                iconName: iconName,
                color: color,
                size: 20,
              ),
            ],
          ),
          SizedBox(height: 1.h),
          Text(
            value,
            style: AppTheme.darkTheme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 0.5.h),
          Text(
            change,
            style: AppTheme.darkTheme.textTheme.bodySmall?.copyWith(
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSalesChart() {
    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppTheme.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Sales Overview',
            style: AppTheme.darkTheme.textTheme.titleMedium,
          ),
          SizedBox(height: 2.h),
          SizedBox(
            height: 25.h,
            child: LineChart(
              LineChartData(
                gridData: FlGridData(
                  show: true,
                  drawVerticalLine: false,
                  horizontalInterval: 500,
                  getDrawingHorizontalLine: (value) {
                    return FlLine(
                      color: AppTheme.border,
                      strokeWidth: 1,
                    );
                  },
                ),
                titlesData: FlTitlesData(
                  show: true,
                  rightTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false)),
                  topTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false)),
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
                        if (value.toInt() < salesData.length) {
                          return SideTitleWidget(
                            axisSide: meta.axisSide,
                            child: Text(salesData[value.toInt()]['day'],
                                style: style),
                          );
                        }
                        return const Text('');
                      },
                    ),
                  ),
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      interval: 1000,
                      getTitlesWidget: (double value, TitleMeta meta) {
                        const style = TextStyle(
                          color: AppTheme.secondaryText,
                          fontWeight: FontWeight.w400,
                          fontSize: 12,
                        );
                        return Text('\$${(value / 1000).toStringAsFixed(0)}k',
                            style: style);
                      },
                      reservedSize: 42,
                    ),
                  ),
                ),
                borderData: FlBorderData(show: false),
                minX: 0,
                maxX: (salesData.length - 1).toDouble(),
                minY: 0,
                maxY: 4000,
                lineBarsData: [
                  LineChartBarData(
                    spots: salesData.asMap().entries.map((entry) {
                      return FlSpot(entry.key.toDouble(),
                          entry.value['sales'].toDouble());
                    }).toList(),
                    isCurved: true,
                    gradient: LinearGradient(
                      colors: [
                        AppTheme.accent,
                        AppTheme.accent.withValues(alpha: 0.3)
                      ],
                    ),
                    barWidth: 3,
                    isStrokeCapRound: true,
                    dotData: const FlDotData(show: false),
                    belowBarData: BarAreaData(
                      show: true,
                      gradient: LinearGradient(
                        colors: [
                          AppTheme.accent.withValues(alpha: 0.3),
                          AppTheme.accent.withValues(alpha: 0.1),
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
    );
  }

  Widget _buildTopProducts() {
    final topProducts = widget.products.take(3).toList();

    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppTheme.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Top Products',
            style: AppTheme.darkTheme.textTheme.titleMedium,
          ),
          SizedBox(height: 2.h),
          ...topProducts.asMap().entries.map((entry) {
            final index = entry.key;
            final product = entry.value;
            return Container(
              margin: EdgeInsets.only(
                  bottom: index < topProducts.length - 1 ? 2.h : 0),
              child: Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: CustomImageWidget(
                      imageUrl: product['image'] ?? '',
                      width: 12.w,
                      height: 12.w,
                      fit: BoxFit.cover,
                    ),
                  ),
                  SizedBox(width: 3.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          product['name'] ?? 'Product Name',
                          style: AppTheme.darkTheme.textTheme.bodyMedium,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        SizedBox(height: 0.5.h),
                        Text(
                          '${45 + index * 12} sold',
                          style: AppTheme.darkTheme.textTheme.bodySmall,
                        ),
                      ],
                    ),
                  ),
                  Text(
                    product['price'] ?? '\$0.00',
                    style: AppTheme.darkTheme.textTheme.titleSmall?.copyWith(
                      color: AppTheme.accent,
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
        ],
      ),
    );
  }

  Widget _buildOrderStatusChart() {
    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppTheme.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Order Status',
            style: AppTheme.darkTheme.textTheme.titleMedium,
          ),
          SizedBox(height: 2.h),
          SizedBox(
            height: 20.h,
            child: PieChart(
              PieChartData(
                sections: [
                  PieChartSectionData(
                    color: AppTheme.success,
                    value: 45,
                    title: '45%',
                    radius: 50,
                    titleStyle:
                        AppTheme.darkTheme.textTheme.labelMedium?.copyWith(
                      color: AppTheme.primaryAction,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  PieChartSectionData(
                    color: AppTheme.accent,
                    value: 30,
                    title: '30%',
                    radius: 50,
                    titleStyle:
                        AppTheme.darkTheme.textTheme.labelMedium?.copyWith(
                      color: AppTheme.primaryAction,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  PieChartSectionData(
                    color: AppTheme.warning,
                    value: 15,
                    title: '15%',
                    radius: 50,
                    titleStyle:
                        AppTheme.darkTheme.textTheme.labelMedium?.copyWith(
                      color: AppTheme.primaryAction,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  PieChartSectionData(
                    color: AppTheme.error,
                    value: 10,
                    title: '10%',
                    radius: 50,
                    titleStyle:
                        AppTheme.darkTheme.textTheme.labelMedium?.copyWith(
                      color: AppTheme.primaryAction,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
                centerSpaceRadius: 40,
                sectionsSpace: 2,
              ),
            ),
          ),
          SizedBox(height: 2.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildLegendItem('Delivered', AppTheme.success),
              _buildLegendItem('Shipped', AppTheme.accent),
              _buildLegendItem('Processing', AppTheme.warning),
              _buildLegendItem('Pending', AppTheme.error),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildLegendItem(String label, Color color) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 12,
          height: 12,
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
}