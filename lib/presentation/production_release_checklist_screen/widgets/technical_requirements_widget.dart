import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sizer/sizer.dart';

class TechnicalRequirementsWidget extends StatefulWidget {
  const TechnicalRequirementsWidget({super.key});

  @override
  State<TechnicalRequirementsWidget> createState() => _TechnicalRequirementsWidgetState();
}

class _TechnicalRequirementsWidgetState extends State<TechnicalRequirementsWidget> {
  bool _isExpanded = false;
  bool _isRunningTests = false;

  final List<Map<String, dynamic>> _technicalChecks = [
{ 'title': 'API Endpoints',
'description': 'All API endpoints responding correctly',
'status': 'passed',
'details': 'All 15 endpoints tested successfully',
},
{ 'title': 'Database Connections',
'description': 'Database connectivity and queries',
'status': 'passed',
'details': 'Connection pool healthy, queries optimized',
},
{ 'title': 'Third-party Integrations',
'description': 'External services and APIs',
'status': 'failed',
'details': 'Payment gateway timeout issues detected',
},
{ 'title': 'Push Notifications',
'description': 'Notification delivery system',
'status': 'passed',
'details': 'iOS and Android push notifications working',
},
{ 'title': 'Offline Functionality',
'description': 'App behavior without internet',
'status': 'pending',
'details': 'Testing in progress',
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
                    Icons.settings,
                    color: Colors.white,
                    size: 24.sp,
                  ),
                  SizedBox(width: 3.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Technical Requirements',
                          style: GoogleFonts.inter(
                            color: Colors.white,
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          '${_getPassedCount()}/${_technicalChecks.length} checks passed',
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
                  ...(_technicalChecks.map((check) => _buildCheckItem(check))),
                  SizedBox(height: 2.h),
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: _isRunningTests ? null : () {
                            setState(() {
                              _isRunningTests = true;
                            });
                            // Simulate test run
                            Future.delayed(const Duration(seconds: 3), () {
                              setState(() {
                                _isRunningTests = false;
                              });
                            });
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue,
                            padding: EdgeInsets.symmetric(vertical: 2.h),
                          ),
                          child: _isRunningTests
                              ? Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    SizedBox(
                                      width: 16.sp,
                                      height: 16.sp,
                                      child: const CircularProgressIndicator(
                                        strokeWidth: 2,
                                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                      ),
                                    ),
                                    SizedBox(width: 2.w),
                                    Text(
                                      'Running Tests...',
                                      style: GoogleFonts.inter(
                                        color: Colors.white,
                                        fontSize: 14.sp,
                                      ),
                                    ),
                                  ],
                                )
                              : Text(
                                  'Run All Tests',
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
                            // Generate report
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.grey[700],
                            padding: EdgeInsets.symmetric(vertical: 2.h),
                          ),
                          child: Text(
                            'Generate Report',
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

  Widget _buildCheckItem(Map<String, dynamic> check) {
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
              color: _getStatusColor(check['status']),
              shape: BoxShape.circle,
            ),
            child: Icon(
              _getStatusIcon(check['status']),
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
                  check['title'],
                  style: GoogleFonts.inter(
                    color: Colors.white,
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: 0.5.h),
                Text(
                  check['description'],
                  style: GoogleFonts.inter(
                    color: Colors.grey[400],
                    fontSize: 12.sp,
                  ),
                ),
                if (check['details'] != null) ...[
                  SizedBox(height: 0.5.h),
                  Text(
                    check['details'],
                    style: GoogleFonts.inter(
                      color: Colors.grey[500],
                      fontSize: 11.sp,
                    ),
                  ),
                ],
              ],
            ),
          ),
          if (check['status'] == 'failed')
            IconButton(
              onPressed: () {
                // Show fix recommendations
              },
              icon: const Icon(
                Icons.build,
                color: Colors.orange,
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildOverallStatus() {
    final failedCount = _technicalChecks.where((check) => check['status'] == 'failed').length;
    final pendingCount = _technicalChecks.where((check) => check['status'] == 'pending').length;
    
    Color statusColor;
    IconData statusIcon;
    
    if (failedCount > 0) {
      statusColor = Colors.red;
      statusIcon = Icons.error;
    } else if (pendingCount > 0) {
      statusColor = Colors.orange;
      statusIcon = Icons.access_time;
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
      case 'pending':
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
      case 'pending':
        return Icons.access_time;
      default:
        return Icons.help;
    }
  }

  int _getPassedCount() {
    return _technicalChecks.where((check) => check['status'] == 'passed').length;
  }
}