import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sizer/sizer.dart';

import '../../../widgets/custom_icon_widget.dart';

class ContentFilterWidget extends StatelessWidget {
  final List<String> platforms;
  final String selectedFilter;
  final Function(String) onFilterChanged;

  const ContentFilterWidget({
    Key? key,
    required this.platforms,
    required this.selectedFilter,
    required this.onFilterChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(children: [
      // Filter chips
      Expanded(
          child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                  children: platforms.map((platform) {
                final isSelected = selectedFilter == platform;
                return Container(
                    margin: EdgeInsets.only(right: 2.w),
                    child: GestureDetector(
                        onTap: () => onFilterChanged(platform),
                        child: Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 3.w, vertical: 1.h),
                            decoration: BoxDecoration(
                                color: isSelected
                                    ? const Color(0xFFFDFDFD)
                                    : const Color(0xFF282828),
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(
                                    color: isSelected
                                        ? const Color(0xFFFDFDFD)
                                        : const Color(0xFF282828),
                                    width: 1)),
                            child:
                                Row(mainAxisSize: MainAxisSize.min, children: [
                              if (platform != 'All') ...[
                                CustomIconWidget(
                                    iconName: _getPlatformIcon(platform),
                                    size: 16,
                                    color: isSelected
                                        ? const Color(0xFF141414)
                                        : const Color(0xFFF1F1F1)),
                                SizedBox(width: 1.w),
                              ],
                              Text(platform,
                                  style: GoogleFonts.inter(
                                      fontSize: 12.sp,
                                      fontWeight: FontWeight.w500,
                                      color: isSelected
                                          ? const Color(0xFF141414)
                                          : const Color(0xFFF1F1F1))),
                            ]))));
              }).toList()))),

      // Bulk actions button
      GestureDetector(
          onTap: () => _showBulkActionsMenu(context),
          child: Container(
              padding: EdgeInsets.all(2.w),
              decoration: BoxDecoration(
                  color: const Color(0xFF282828),
                  borderRadius: BorderRadius.circular(8)),
              child: const CustomIconWidget(
                  iconName: 'more_vert', size: 20, color: Color(0xFFF1F1F1)))),
    ]);
  }

  String _getPlatformIcon(String platform) {
    switch (platform) {
      case 'Instagram':
        return 'camera_alt';
      case 'Facebook':
        return 'facebook';
      case 'Twitter':
        return 'alternate_email';
      case 'LinkedIn':
        return 'business';
      case 'TikTok':
        return 'music_note';
      default:
        return 'public';
    }
  }

  void _showBulkActionsMenu(BuildContext context) {
    showModalBottomSheet(
        context: context,
        backgroundColor: const Color(0xFF191919),
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
        builder: (context) => Container(
            padding: EdgeInsets.all(4.w),
            child: Column(mainAxisSize: MainAxisSize.min, children: [
              // Handle bar
              Container(
                  width: 12.w,
                  height: 0.5.h,
                  decoration: BoxDecoration(
                      color: const Color(0xFF282828),
                      borderRadius: BorderRadius.circular(10))),
              SizedBox(height: 3.h),

              // Bulk actions
              _buildBulkActionItem('Import from CSV', 'upload_file', () {
                Navigator.pop(context);
                // TODO: Implement CSV import
              }),
              _buildBulkActionItem('Export Calendar', 'download', () {
                Navigator.pop(context);
                // TODO: Implement export
              }),
              _buildBulkActionItem('Schedule Multiple', 'schedule', () {
                Navigator.pop(context);
                // TODO: Implement bulk scheduling
              }),
              _buildBulkActionItem('Template Library', 'library_books', () {
                Navigator.pop(context);
                // TODO: Open template library
              }),

              SizedBox(height: 2.h),
            ])));
  }

  Widget _buildBulkActionItem(
      String title, String iconName, VoidCallback onTap) {
    return GestureDetector(
        onTap: onTap,
        child: Container(
            padding: EdgeInsets.symmetric(vertical: 2.h),
            child: Row(children: [
              CustomIconWidget(
                  iconName: iconName, size: 24, color: const Color(0xFFF1F1F1)),
              SizedBox(width: 4.w),
              Text(title,
                  style: GoogleFonts.inter(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w500,
                      color: const Color(0xFFF1F1F1))),
            ])));
  }
}
