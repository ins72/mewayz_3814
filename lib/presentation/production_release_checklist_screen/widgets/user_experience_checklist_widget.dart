import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sizer/sizer.dart';

class UserExperienceChecklistWidget extends StatefulWidget {
  const UserExperienceChecklistWidget({super.key});

  @override
  State<UserExperienceChecklistWidget> createState() => _UserExperienceChecklistWidgetState();
}

class _UserExperienceChecklistWidgetState extends State<UserExperienceChecklistWidget> {
  bool _isExpanded = false;

  final List<Map<String, dynamic>> _uxChecks = [
{ 'title': 'WCAG Accessibility Guidelines',
'description': 'Web Content Accessibility Guidelines compliance',
'status': 'passed',
'details': 'All accessibility standards met',
'priority': 'high',
},
{ 'title': 'Responsive Design',
'description': 'UI adapts to different screen sizes',
'status': 'passed',
'details': 'Tested on 12 different device sizes',
'priority': 'high',
},
{ 'title': 'User Flow Testing',
'description': 'Critical user journeys validated',
'status': 'failed',
'details': 'Checkout flow has 3 usability issues',
'priority': 'high',
},
{ 'title': 'Error Handling',
'description': 'Graceful error messages and recovery',
'status': 'passed',
'details': 'All error scenarios handled properly',
'priority': 'medium',
},
{ 'title': 'Loading States',
'description': 'Loading indicators and skeleton screens',
'status': 'passed',
'details': 'Loading states implemented across app',
'priority': 'medium',
},
{ 'title': 'Keyboard Navigation',
'description': 'App navigable using keyboard only',
'status': 'pending',
'details': 'Testing in progress',
'priority': 'medium',
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
                    Icons.person,
                    color: Colors.white,
                    size: 24.sp,
                  ),
                  SizedBox(width: 3.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'User Experience',
                          style: GoogleFonts.inter(
                            color: Colors.white,
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          '${_getPassedCount()}/${_uxChecks.length} checks passed',
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
                  ...(_uxChecks.map((check) => _buildCheckItem(check))),
                  SizedBox(height: 2.h),
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            // Run UX audit
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.purple,
                            padding: EdgeInsets.symmetric(vertical: 2.h),
                          ),
                          child: Text(
                            'Run UX Audit',
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
                            // View recommendations
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.grey[700],
                            padding: EdgeInsets.symmetric(vertical: 2.h),
                          ),
                          child: Text(
                            'View Recommendations',
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
                Row(
                  children: [
                    Text(
                      check['title'],
                      style: GoogleFonts.inter(
                        color: Colors.white,
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(width: 2.w),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 1.w, vertical: 0.2.h),
                      decoration: BoxDecoration(
                        color: _getPriorityColor(check['priority']).withAlpha(51),
                        borderRadius: BorderRadius.circular(4.0),
                      ),
                      child: Text(
                        check['priority'].toUpperCase(),
                        style: GoogleFonts.inter(
                          color: _getPriorityColor(check['priority']),
                          fontSize: 10.sp,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
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
                // Show UX improvement suggestions
              },
              icon: const Icon(
                Icons.lightbulb_outline,
                color: Colors.orange,
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildOverallStatus() {
    final failedCount = _uxChecks.where((check) => check['status'] == 'failed').length;
    final pendingCount = _uxChecks.where((check) => check['status'] == 'pending').length;
    
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

  Color _getPriorityColor(String priority) {
    switch (priority) {
      case 'high':
        return Colors.red;
      case 'medium':
        return Colors.orange;
      case 'low':
        return Colors.green;
      default:
        return Colors.grey;
    }
  }

  int _getPassedCount() {
    return _uxChecks.where((check) => check['status'] == 'passed').length;
  }
}