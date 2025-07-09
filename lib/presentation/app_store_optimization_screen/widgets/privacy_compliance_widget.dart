import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sizer/sizer.dart';

class PrivacyComplianceWidget extends StatefulWidget {
  const PrivacyComplianceWidget({super.key});

  @override
  State<PrivacyComplianceWidget> createState() => _PrivacyComplianceWidgetState();
}

class _PrivacyComplianceWidgetState extends State<PrivacyComplianceWidget> {
  final List<Map<String, dynamic>> _complianceItems = [
{ 'title': 'Privacy Policy',
'description': 'Upload and verify your privacy policy',
'status': 'completed',
'required': true,
},
{ 'title': 'Data Collection Disclosure',
'description': 'Specify what data your app collects',
'status': 'pending',
'required': true,
},
{ 'title': 'Third-party SDK Audit',
'description': 'Review all third-party integrations',
'status': 'pending',
'required': true,
},
{ 'title': 'GDPR Compliance',
'description': 'Ensure GDPR compliance for EU users',
'status': 'completed',
'required': true,
},
{ 'title': 'CCPA Compliance',
'description': 'California Consumer Privacy Act compliance',
'status': 'pending',
'required': false,
},
];

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: const Color(0xFF191919),
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Privacy & Compliance',
                style: GoogleFonts.inter(
                  color: Colors.white,
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.5.h),
                decoration: BoxDecoration(
                  color: _getOverallStatusColor().withAlpha(51),
                  borderRadius: BorderRadius.circular(6.0),
                ),
                child: Text(
                  _getOverallStatusText(),
                  style: GoogleFonts.inter(
                    color: _getOverallStatusColor(),
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 3.h),
          ...(_complianceItems.map((item) => _buildComplianceItem(item))),
          SizedBox(height: 3.h),
          ElevatedButton(
            onPressed: () {
              // Run compliance check
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue,
              padding: EdgeInsets.symmetric(vertical: 2.h),
              minimumSize: Size(double.infinity, 0),
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
        ],
      ),
    );
  }

  Widget _buildComplianceItem(Map<String, dynamic> item) {
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
              color: _getStatusColor(item['status']),
              shape: BoxShape.circle,
            ),
            child: Icon(
              _getStatusIcon(item['status']),
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
                      item['title'],
                      style: GoogleFonts.inter(
                        color: Colors.white,
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    if (item['required']) ...[
                      SizedBox(width: 2.w),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 1.w, vertical: 0.2.h),
                        decoration: BoxDecoration(
                          color: Colors.red.withAlpha(51),
                          borderRadius: BorderRadius.circular(4.0),
                        ),
                        child: Text(
                          'Required',
                          style: GoogleFonts.inter(
                            color: Colors.red,
                            fontSize: 10.sp,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
                SizedBox(height: 0.5.h),
                Text(
                  item['description'],
                  style: GoogleFonts.inter(
                    color: Colors.grey[400],
                    fontSize: 12.sp,
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: () {
              // Handle compliance item action
            },
            icon: const Icon(
              Icons.arrow_forward_ios,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'completed':
        return Colors.green;
      case 'pending':
        return Colors.orange;
      case 'failed':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  IconData _getStatusIcon(String status) {
    switch (status) {
      case 'completed':
        return Icons.check;
      case 'pending':
        return Icons.access_time;
      case 'failed':
        return Icons.error;
      default:
        return Icons.help;
    }
  }

  Color _getOverallStatusColor() {
    final requiredItems = _complianceItems.where((item) => item['required']).toList();
    final completedRequired = requiredItems.where((item) => item['status'] == 'completed').length;
    
    if (completedRequired == requiredItems.length) {
      return Colors.green;
    } else if (completedRequired > 0) {
      return Colors.orange;
    }
    return Colors.red;
  }

  String _getOverallStatusText() {
    final requiredItems = _complianceItems.where((item) => item['required']).toList();
    final completedRequired = requiredItems.where((item) => item['status'] == 'completed').length;
    
    if (completedRequired == requiredItems.length) {
      return 'Compliant';
    } else if (completedRequired > 0) {
      return 'In Progress';
    }
    return 'Not Compliant';
  }
}