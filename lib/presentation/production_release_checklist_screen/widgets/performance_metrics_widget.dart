import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sizer/sizer.dart';

class PerformanceMetricsWidget extends StatefulWidget {
  const PerformanceMetricsWidget({super.key});

  @override
  State<PerformanceMetricsWidget> createState() => _PerformanceMetricsWidgetState();
}

class _PerformanceMetricsWidgetState extends State<PerformanceMetricsWidget> {
  bool _isExpanded = false;

  final List<Map<String, dynamic>> _performanceMetrics = [
{ 'title': 'App Launch Time',
'value': '2.3s',
'benchmark': '< 3s',
'status': 'passed',
'description': 'Cold start performance',
},
{ 'title': 'Memory Usage',
'value': '87MB',
'benchmark': '< 100MB',
'status': 'passed',
'description': 'Peak memory consumption',
},
{ 'title': 'Battery Consumption',
'value': '5.2%/hour',
'benchmark': '< 8%/hour',
'status': 'passed',
'description': 'Battery drain rate during active use',
},
{ 'title': 'Network Efficiency',
'value': '2.1MB/session',
'benchmark': '< 5MB/session',
'status': 'passed',
'description': 'Average data usage per session',
},
{ 'title': 'CPU Usage',
'value': '15%',
'benchmark': '< 20%',
'status': 'passed',
'description': 'Average CPU utilization',
},
{ 'title': 'App Size',
'value': '45MB',
'benchmark': '< 50MB',
'status': 'passed',
'description': 'Total app bundle size',
},
];

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 2.h),
      decoration: BoxDecoration(
        color: const Color(0xFF191919),
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Column(
        children: [
          InkWell(
            onTap: () {
              setState(() {
                _isExpanded = !_isExpanded;
              });
            },
            child: Container(
              padding: EdgeInsets.all(4.w),
              child: Row(
                children: [
                  Icon(
                    Icons.speed,
                    color: Colors.white,
                    size: 24.sp,
                  ),
                  SizedBox(width: 3.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Performance',
                          style: GoogleFonts.inter(
                            color: Colors.white,
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          '${_getPassedCount()}/${_performanceMetrics.length} benchmarks met',
                          style: GoogleFonts.inter(
                            color: Colors.grey[400],
                            fontSize: 12.sp,
                          ),
                        ),
                      ],
                    ),
                  ),
                  _buildOverallStatus(),
                  SizedBox(width: 3.w),
                  Icon(
                    _isExpanded ? Icons.expand_less : Icons.expand_more,
                    color: Colors.white,
                    size: 24.sp,
                  ),
                ],
              ),
            ),
          ),
          if (_isExpanded) ...[
            const Divider(color: Colors.grey, height: 1),
            Padding(
              padding: EdgeInsets.all(4.w),
              child: Column(
                children: [
                  ...(_performanceMetrics.map((metric) => _buildMetricItem(metric))),
                  SizedBox(height: 2.h),
                  Container(
                    padding: EdgeInsets.all(3.w),
                    decoration: BoxDecoration(
                      color: const Color(0xFF2A2A2A),
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.info_outline,
                              color: Colors.blue,
                              size: 20.sp,
                            ),
                            SizedBox(width: 3.w),
                            Text(
                              'Performance Insights',
                              style: GoogleFonts.inter(
                                color: Colors.white,
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 1.h),
                        Text(
                          'Your app performs well across all metrics. Consider optimizing image compression to reduce app size further.',
                          style: GoogleFonts.inter(
                            color: Colors.grey[400],
                            fontSize: 12.sp,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 2.h),
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            // Run performance test
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green,
                            padding: EdgeInsets.symmetric(vertical: 2.h),
                          ),
                          child: Text(
                            'Run Performance Test',
                            style: GoogleFonts.inter(
                              color: Colors.white,
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 3.w),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            // View detailed report
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.grey[700],
                            padding: EdgeInsets.symmetric(vertical: 2.h),
                          ),
                          child: Text(
                            'Detailed Report',
                            style: GoogleFonts.inter(
                              color: Colors.white,
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildMetricItem(Map<String, dynamic> metric) {
    return Container(
      margin: EdgeInsets.only(bottom: 2.h),
      padding: EdgeInsets.all(3.w),
      decoration: BoxDecoration(
        color: const Color(0xFF2A2A2A),
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Row(
        children: [
          Container(
            width: 6.w,
            height: 6.w,
            decoration: BoxDecoration(
              color: _getStatusColor(metric['status']),
              shape: BoxShape.circle,
            ),
            child: Icon(
              _getStatusIcon(metric['status']),
              color: Colors.white,
              size: 16.sp,
            ),
          ),
          SizedBox(width: 3.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  metric['title'],
                  style: GoogleFonts.inter(
                    color: Colors.white,
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: 0.5.h),
                Text(
                  metric['description'],
                  style: GoogleFonts.inter(
                    color: Colors.grey[400],
                    fontSize: 12.sp,
                  ),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                metric['value'],
                style: GoogleFonts.inter(
                  color: Colors.white,
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: 0.5.h),
              Text(
                'Target: ${metric['benchmark']}',
                style: GoogleFonts.inter(
                  color: Colors.grey[500],
                  fontSize: 11.sp,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildOverallStatus() {
    final failedCount = _performanceMetrics.where((metric) => metric['status'] == 'failed').length;
    final warningCount = _performanceMetrics.where((metric) => metric['status'] == 'warning').length;
    
    Color statusColor;
    IconData statusIcon;
    
    if (failedCount > 0) {
      statusColor = Colors.red;
      statusIcon = Icons.error;
    } else if (warningCount > 0) {
      statusColor = Colors.orange;
      statusIcon = Icons.warning;
    } else {
      statusColor = Colors.green;
      statusIcon = Icons.check_circle;
    }
    
    return Icon(
      statusIcon,
      color: statusColor,
      size: 24.sp,
    );
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'passed':
        return Colors.green;
      case 'failed':
        return Colors.red;
      case 'warning':
        return Colors.orange;
      default:
        return Colors.grey;
    }
  }

  IconData _getStatusIcon(String status) {
    switch (status) {
      case 'passed':
        return Icons.check;
      case 'failed':
        return Icons.error;
      case 'warning':
        return Icons.warning;
      default:
        return Icons.help;
    }
  }

  int _getPassedCount() {
    return _performanceMetrics.where((metric) => metric['status'] == 'passed').length;
  }
}