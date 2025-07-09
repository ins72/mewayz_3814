import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sizer/sizer.dart';

class SecurityChecklistWidget extends StatefulWidget {
  const SecurityChecklistWidget({super.key});

  @override
  State<SecurityChecklistWidget> createState() => _SecurityChecklistWidgetState();
}

class _SecurityChecklistWidgetState extends State<SecurityChecklistWidget> {
  bool _isExpanded = false;

  final List<Map<String, dynamic>> _securityChecks = [
{ 'title': 'Penetration Testing',
'description': 'Security vulnerability assessment',
'status': 'passed',
'details': 'No critical vulnerabilities found',
'severity': 'critical',
},
{ 'title': 'Data Encryption',
'description': 'Data at rest and in transit encryption',
'status': 'passed',
'details': 'AES-256 encryption implemented',
'severity': 'critical',
},
{ 'title': 'Authentication System',
'description': 'User authentication and authorization',
'status': 'passed',
'details': 'Multi-factor authentication enabled',
'severity': 'high',
},
{ 'title': 'API Security',
'description': 'API endpoint security validation',
'status': 'failed',
'details': 'Rate limiting not configured properly',
'severity': 'high',
},
{ 'title': 'Privacy Policy Implementation',
'description': 'Data collection and usage compliance',
'status': 'passed',
'details': 'Privacy policy integrated and functional',
'severity': 'medium',
},
{ 'title': 'Secure Communication',
'description': 'HTTPS and SSL/TLS validation',
'status': 'passed',
'details': 'SSL certificates valid and configured',
'severity': 'high',
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
                    Icons.security,
                    color: Colors.white,
                    size: 24.sp,
                  ),
                  SizedBox(width: 3.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Security & Privacy',
                          style: GoogleFonts.inter(
                            color: Colors.white,
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          '${_getPassedCount()}/${_securityChecks.length} checks passed',
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
                  ...(_securityChecks.map((check) => _buildCheckItem(check))),
                  SizedBox(height: 2.h),
                  Container(
                    padding: EdgeInsets.all(3.w),
                    decoration: BoxDecoration(
                      color: const Color(0xFF2A2A2A),
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.info_outline,
                          color: Colors.blue,
                          size: 20.sp,
                        ),
                        SizedBox(width: 3.w),
                        Expanded(
                          child: Text(
                            'Security scan last performed: ${DateTime.now().subtract(const Duration(hours: 2)).toString().split('.')[0]}',
                            style: GoogleFonts.inter(
                              color: Colors.grey[400],
                              fontSize: 12.sp,
                            ),
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
                            // Run security scan
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red,
                            padding: EdgeInsets.symmetric(vertical: 2.h),
                          ),
                          child: Text(
                            'Run Security Scan',
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
                            // View security report
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.grey[700],
                            padding: EdgeInsets.symmetric(vertical: 2.h),
                          ),
                          child: Text(
                            'Security Report',
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
                        color: _getSeverityColor(check['severity']).withAlpha(51),
                        borderRadius: BorderRadius.circular(4.0),
                      ),
                      child: Text(
                        check['severity'].toUpperCase(),
                        style: GoogleFonts.inter(
                          color: _getSeverityColor(check['severity']),
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
                // Show security fix recommendations
              },
              icon: const Icon(
                Icons.security,
                color: Colors.red,
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildOverallStatus() {
    final failedCount = _securityChecks.where((check) => check['status'] == 'failed').length;
    final pendingCount = _securityChecks.where((check) => check['status'] == 'pending').length;
    
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

  Color _getSeverityColor(String severity) {
    switch (severity) {
      case 'critical':
        return Colors.red;
      case 'high':
        return Colors.orange;
      case 'medium':
        return Colors.yellow;
      case 'low':
        return Colors.green;
      default:
        return Colors.grey;
    }
  }

  int _getPassedCount() {
    return _securityChecks.where((check) => check['status'] == 'passed').length;
  }
}