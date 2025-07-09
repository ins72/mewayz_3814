import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sizer/sizer.dart';

class SubmissionChecklistWidget extends StatefulWidget {
  const SubmissionChecklistWidget({super.key});

  @override
  State<SubmissionChecklistWidget> createState() => _SubmissionChecklistWidgetState();
}

class _SubmissionChecklistWidgetState extends State<SubmissionChecklistWidget> {
  final List<Map<String, dynamic>> _checklistItems = [
{'title': 'App Metadata Complete', 'completed': true},
{'title': 'Screenshots Uploaded', 'completed': false},
{'title': 'Privacy Policy Compliance', 'completed': false},
{'title': 'Content Rating Assessment', 'completed': false},
{'title': 'Developer Account Verification', 'completed': true},
{'title': 'Build Upload Ready', 'completed': false},
];

  double get _completionPercentage {
    final completed = _checklistItems.where((item) => item['completed'] == true).length;
    return (completed / _checklistItems.length) * 100;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: const Color(0xFF101010),
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Submission Progress',
                style: GoogleFonts.inter(
                  color: Colors.white,
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                '${_completionPercentage.toInt()}%',
                style: GoogleFonts.inter(
                  color: Colors.white,
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          SizedBox(height: 2.h),
          LinearProgressIndicator(
            value: _completionPercentage / 100,
            backgroundColor: Colors.grey[700],
            valueColor: AlwaysStoppedAnimation<Color>(
              _completionPercentage == 100 ? Colors.green : Colors.blue,
            ),
            minHeight: 8.0,
          ),
          SizedBox(height: 3.h),
          ...(_checklistItems.map((item) => _buildChecklistItem(item))),
        ],
      ),
    );
  }

  Widget _buildChecklistItem(Map<String, dynamic> item) {
    return Padding(
      padding: EdgeInsets.only(bottom: 1.h),
      child: Row(
        children: [
          Icon(
            item['completed'] ? Icons.check_circle : Icons.radio_button_unchecked,
            color: item['completed'] ? Colors.green : Colors.grey,
            size: 20.sp,
          ),
          SizedBox(width: 3.w),
          Expanded(
            child: Text(
              item['title'],
              style: GoogleFonts.inter(
                color: Colors.white,
                fontSize: 14.sp,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
        ],
      ),
    );
  }
}