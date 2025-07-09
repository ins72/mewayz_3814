import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sizer/sizer.dart';

class StoreComplianceWidget extends StatefulWidget {
  const StoreComplianceWidget({super.key});

  @override
  State<StoreComplianceWidget> createState() => _StoreComplianceWidgetState();
}

class _StoreComplianceWidgetState extends State<StoreComplianceWidget> {
  bool _isExpanded = false;

  final List<Map<String, dynamic>> _complianceChecks = [
{ 'title': 'App Store Guidelines',
'description': 'Apple App Store Review Guidelines compliance',
'status': 'passed',
'platform': 'ios',
'details': 'All guidelines requirements met',
},
{ 'title': 'Google Play Policy',
'description': 'Google Play Developer Policy compliance',
'status': 'passed',
'platform': 'android',
'details': 'Policy requirements satisfied',
},
{ 'title': 'Content Rating',
'description': 'Age-appropriate content rating',
'status': 'passed',
'platform': 'both',
'details': 'Rated 4+ (iOS) / Everyone (Android)',
},
{ 'title': 'Privacy Compliance',
'description': 'Data collection and privacy policies',
'status': 'passed',
'platform': 'both',
'details': 'Privacy policy updated and compliant',
},
{ 'title': 'Accessibility Standards',
'description': 'Platform accessibility requirements',
'status': 'warning',
'platform': 'both',
'details': 'Minor accessibility improvements needed',
},
{ 'title': 'Trademark Compliance',
'description': 'No trademark violations detected',
'status': 'passed',
'platform': 'both',
'details': 'No trademark conflicts found',
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
                    Icons.store,
                    color: Colors.white,
                    size: 24.sp,
                  ),
                  SizedBox(width: 3.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Store Compliance',
                          style: GoogleFonts.inter(
                            color: Colors.white,
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          '${_getPassedCount()}/${_complianceChecks.length} policies compliant',
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
                  ...(_complianceChecks.map((check) => _buildComplianceItem(check))),
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
                              Icons.lightbulb_outline,
                              color: Colors.yellow,
                              size: 20.sp,
                            ),
                            SizedBox(width: 3.w),
                            Text(
                              'Compliance Tips',
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
                          '• Keep your app metadata up to date\n'
                          '• Regularly review policy updates\n'
                          '• Test your app on multiple devices\n'
                          '• Ensure all features work as described',
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
                            // Run compliance check
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue,
                            padding: EdgeInsets.symmetric(vertical: 2.h),
                          ),
                          child: Text(
                            'Run Compliance Check',
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
                            // View policy updates
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.grey[700],
                            padding: EdgeInsets.symmetric(vertical: 2.h),
                          ),
                          child: Text(
                            'Policy Updates',
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

  Widget _buildComplianceItem(Map<String, dynamic> check) {
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
                        color: _getPlatformColor(check['platform']).withAlpha(51),
                        borderRadius: BorderRadius.circular(4.0),
                      ),
                      child: Text(
                        _getPlatformText(check['platform']),
                        style: GoogleFonts.inter(
                          color: _getPlatformColor(check['platform']),
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
          if (check['status'] == 'warning' || check['status'] == 'failed')
            IconButton(
              onPressed: () {
                // Show compliance guidelines
              },
              icon: const Icon(
                Icons.help_outline,
                color: Colors.orange,
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildOverallStatus() {
    final failedCount = _complianceChecks.where((check) => check['status'] == 'failed').length;
    final warningCount = _complianceChecks.where((check) => check['status'] == 'warning').length;
    
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

  Color _getPlatformColor(String platform) {
    switch (platform) {
      case 'ios':
        return Colors.blue;
      case 'android':
        return Colors.green;
      case 'both':
        return Colors.purple;
      default:
        return Colors.grey;
    }
  }

  String _getPlatformText(String platform) {
    switch (platform) {
      case 'ios':
        return 'iOS';
      case 'android':
        return 'Android';
      case 'both':
        return 'Both';
      default:
        return 'Unknown';
    }
  }

  int _getPassedCount() {
    return _complianceChecks.where((check) => check['status'] == 'passed').length;
  }
}