import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sizer/sizer.dart';

class ChecklistProgressWidget extends StatelessWidget {
  final double completionPercentage;
  final int completedItems;
  final int totalItems;

  const ChecklistProgressWidget({
    super.key,
    required this.completionPercentage,
    required this.completedItems,
    required this.totalItems,
  });

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
                'Production Readiness',
                style: GoogleFonts.inter(
                  color: Colors.white,
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                '${completionPercentage.toInt()}%',
                style: GoogleFonts.inter(
                  color: Colors.white,
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          SizedBox(height: 1.h),
          Text(
            '$completedItems of $totalItems checks completed',
            style: GoogleFonts.inter(
              color: Colors.grey[400],
              fontSize: 14.sp,
            ),
          ),
          SizedBox(height: 2.h),
          LinearProgressIndicator(
            value: completionPercentage / 100,
            backgroundColor: Colors.grey[700],
            valueColor: AlwaysStoppedAnimation<Color>(
              completionPercentage == 100 ? Colors.green : Colors.blue,
            ),
            minHeight: 8.0,
          ),
          SizedBox(height: 2.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildStatusIndicator(
                'Passed',
                completedItems.toString(),
                Colors.green,
              ),
              _buildStatusIndicator(
                'Failed',
                (totalItems - completedItems).toString(),
                Colors.red,
              ),
              _buildStatusIndicator(
                'Remaining',
                (totalItems - completedItems).toString(),
                Colors.orange,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatusIndicator(String label, String count, Color color) {
    return Column(
      children: [
        Text(
          count,
          style: GoogleFonts.inter(
            color: color,
            fontSize: 18.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
        Text(
          label,
          style: GoogleFonts.inter(
            color: Colors.grey[400],
            fontSize: 12.sp,
          ),
        ),
      ],
    );
  }
}