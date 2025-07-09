import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sizer/sizer.dart';

class InvitationProgressWidget extends StatelessWidget {
  final List<String> sentInvitations;
  final List<String> failedInvitations;
  final int totalInvitations;

  const InvitationProgressWidget({
    Key? key,
    required this.sentInvitations,
    required this.failedInvitations,
    required this.totalInvitations,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final successCount = sentInvitations.length;
    final failureCount = failedInvitations.length;
    final successRate = totalInvitations > 0 ? (successCount / totalInvitations) : 0.0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Invitation Progress',
          style: GoogleFonts.inter(
            fontSize: 16.sp,
            fontWeight: FontWeight.w600,
            color: const Color(0xFFF1F1F1),
          ),
        ),
        SizedBox(height: 2.h),
        
        // Progress bar
        Container(
          width: double.infinity,
          height: 1.h,
          decoration: BoxDecoration(
            color: const Color(0xFF282828),
            borderRadius: BorderRadius.circular(4),
          ),
          child: FractionallySizedBox(
            alignment: Alignment.centerLeft,
            widthFactor: successRate,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.green,
                borderRadius: BorderRadius.circular(4),
              ),
            ),
          ),
        ),
        SizedBox(height: 2.h),
        
        // Statistics
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _buildStatCard(
              'Sent',
              successCount.toString(),
              Colors.green,
              Icons.check_circle,
            ),
            _buildStatCard(
              'Failed',
              failureCount.toString(),
              Colors.red,
              Icons.error,
            ),
            _buildStatCard(
              'Total',
              totalInvitations.toString(),
              const Color(0xFFF1F1F1),
              Icons.email,
            ),
          ],
        ),
        SizedBox(height: 2.h),
        
        // Success rate
        Container(
          padding: EdgeInsets.all(3.w),
          decoration: BoxDecoration(
            color: const Color(0xFF191919),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: const Color(0xFF282828),
              width: 1,
            ),
          ),
          child: Row(
            children: [
              Icon(
                Icons.analytics,
                color: const Color(0xFFF1F1F1).withAlpha(179),
                size: 5.w,
              ),
              SizedBox(width: 3.w),
              Text(
                'Success Rate: ${(successRate * 100).toStringAsFixed(1)}%',
                style: GoogleFonts.inter(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w500,
                  color: const Color(0xFFF1F1F1),
                ),
              ),
            ],
          ),
        ),
        
        // Failed invitations details
        if (failedInvitations.isNotEmpty) ...[
          SizedBox(height: 2.h),
          Container(
            padding: EdgeInsets.all(3.w),
            decoration: BoxDecoration(
              color: const Color(0xFF191919),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: Colors.red.withAlpha(77),
                width: 1,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.warning,
                      color: Colors.red,
                      size: 5.w,
                    ),
                    SizedBox(width: 2.w),
                    Text(
                      'Failed Invitations',
                      style: GoogleFonts.inter(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w500,
                        color: Colors.red,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 1.h),
                ...failedInvitations.map((email) => Padding(
                  padding: EdgeInsets.only(bottom: 0.5.h),
                  child: Text(
                    '• $email',
                    style: GoogleFonts.inter(
                      fontSize: 12.sp,
                      color: const Color(0xFFF1F1F1).withAlpha(179),
                    ),
                  ),
                )),
              ],
            ),
          ),
        ],
        
        // Success message
        if (successCount > 0) ...[
          SizedBox(height: 2.h),
          Container(
            padding: EdgeInsets.all(3.w),
            decoration: BoxDecoration(
              color: const Color(0xFF191919),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: Colors.green.withAlpha(77),
                width: 1,
              ),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.check_circle,
                  color: Colors.green,
                  size: 5.w,
                ),
                SizedBox(width: 3.w),
                Expanded(
                  child: Text(
                    'Successfully sent $successCount invitation(s). Team members will receive email invitations with access instructions.',
                    style: GoogleFonts.inter(
                      fontSize: 12.sp,
                      color: const Color(0xFFF1F1F1).withAlpha(204),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildStatCard(String label, String value, Color color, IconData icon) {
    return Container(
      padding: EdgeInsets.all(3.w),
      decoration: BoxDecoration(
        color: const Color(0xFF191919),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: color.withAlpha(77),
          width: 1,
        ),
      ),
      child: Column(
        children: [
          Icon(
            icon,
            color: color,
            size: 6.w,
          ),
          SizedBox(height: 1.h),
          Text(
            value,
            style: GoogleFonts.inter(
              fontSize: 16.sp,
              fontWeight: FontWeight.w700,
              color: color,
            ),
          ),
          SizedBox(height: 0.5.h),
          Text(
            label,
            style: GoogleFonts.inter(
              fontSize: 11.sp,
              color: const Color(0xFFF1F1F1).withAlpha(179),
            ),
          ),
        ],
      ),
    );
  }
}