import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sizer/sizer.dart';

class PlatformSectionWidget extends StatefulWidget {
  final String platformName;
  final String platformIcon;
  final List<Map<String, dynamic>> requirements;

  const PlatformSectionWidget({
    super.key,
    required this.platformName,
    required this.platformIcon,
    required this.requirements,
  });

  @override
  State<PlatformSectionWidget> createState() => _PlatformSectionWidgetState();
}

class _PlatformSectionWidgetState extends State<PlatformSectionWidget> {
  bool _isExpanded = false;

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
                    widget.platformIcon == 'ios' ? Icons.phone_iphone : Icons.android,
                    color: Colors.white,
                    size: 24.sp,
                  ),
                  SizedBox(width: 3.w),
                  Expanded(
                    child: Text(
                      widget.platformName,
                      style: GoogleFonts.inter(
                        color: Colors.white,
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
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
                children: widget.requirements.map((requirement) {
                  return _buildRequirementItem(requirement);
                }).toList(),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildRequirementItem(Map<String, dynamic> requirement) {
    return Padding(
      padding: EdgeInsets.only(bottom: 2.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 20.sp,
            height: 20.sp,
            decoration: BoxDecoration(
              color: requirement['completed'] ? Colors.green : Colors.grey,
              shape: BoxShape.circle,
            ),
            child: Icon(
              requirement['completed'] ? Icons.check : Icons.close,
              color: Colors.white,
              size: 14.sp,
            ),
          ),
          SizedBox(width: 3.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  requirement['title'],
                  style: GoogleFonts.inter(
                    color: Colors.white,
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                if (requirement['description'] != null) ...[
                  SizedBox(height: 1.h),
                  Text(
                    requirement['description'],
                    style: GoogleFonts.inter(
                      color: Colors.grey[400],
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}