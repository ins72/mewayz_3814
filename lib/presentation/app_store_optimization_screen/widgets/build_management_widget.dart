import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sizer/sizer.dart';

class BuildManagementWidget extends StatefulWidget {
  const BuildManagementWidget({super.key});

  @override
  State<BuildManagementWidget> createState() => _BuildManagementWidgetState();
}

class _BuildManagementWidgetState extends State<BuildManagementWidget> {
  final TextEditingController _versionController = TextEditingController(text: '1.0.0');
  final TextEditingController _buildController = TextEditingController(text: '1');
  final TextEditingController _releaseNotesController = TextEditingController();

  final List<Map<String, dynamic>> _versionHistory = [
{ 'version': '1.0.0',
'build': '1',
'status': 'current',
'date': '2024-01-15',
'notes': 'Initial release with core features',
},
{ 'version': '0.9.0',
'build': '5',
'status': 'archived',
'date': '2024-01-10',
'notes': 'Beta release for testing',
},
];

  @override
  void dispose() {
    _versionController.dispose();
    _buildController.dispose();
    _releaseNotesController.dispose();
    super.dispose();
  }

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
          Text(
            'Build Management',
            style: GoogleFonts.inter(
              color: Colors.white,
              fontSize: 16.sp,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 3.h),
          Row(
            children: [
              Expanded(
                child: _buildTextField(
                  controller: _versionController,
                  label: 'Version',
                  hint: '1.0.0',
                ),
              ),
              SizedBox(width: 3.w),
              Expanded(
                child: _buildTextField(
                  controller: _buildController,
                  label: 'Build Number',
                  hint: '1',
                ),
              ),
            ],
          ),
          SizedBox(height: 2.h),
          _buildTextField(
            controller: _releaseNotesController,
            label: 'Release Notes',
            hint: 'What\'s new in this version...',
            maxLines: 4,
          ),
          SizedBox(height: 3.h),
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    // Create build
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    padding: EdgeInsets.symmetric(vertical: 2.h),
                  ),
                  child: Text(
                    'Create Build',
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
                    // Archive build
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.grey[700],
                    padding: EdgeInsets.symmetric(vertical: 2.h),
                  ),
                  child: Text(
                    'Archive',
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
          SizedBox(height: 3.h),
          Text(
            'Version History',
            style: GoogleFonts.inter(
              color: Colors.white,
              fontSize: 14.sp,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 2.h),
          ...(_versionHistory.map((version) => _buildVersionItem(version))),
        ],
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    int maxLines = 1,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.inter(
            color: Colors.white,
            fontSize: 14.sp,
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(height: 1.h),
        TextField(
          controller: controller,
          maxLines: maxLines,
          style: GoogleFonts.inter(color: Colors.white),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: GoogleFonts.inter(color: Colors.grey[400]),
            filled: true,
            fillColor: const Color(0xFF2A2A2A),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.0),
              borderSide: BorderSide.none,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildVersionItem(Map<String, dynamic> version) {
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
              color: version['status'] == 'current' ? Colors.green : Colors.grey,
              shape: BoxShape.circle,
            ),
            child: Icon(
              version['status'] == 'current' ? Icons.check : Icons.archive,
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
                      'v${version['version']} (${version['build']})',
                      style: GoogleFonts.inter(
                        color: Colors.white,
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(width: 2.w),
                    if (version['status'] == 'current')
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 1.w, vertical: 0.2.h),
                        decoration: BoxDecoration(
                          color: Colors.green.withAlpha(51),
                          borderRadius: BorderRadius.circular(4.0),
                        ),
                        child: Text(
                          'Current',
                          style: GoogleFonts.inter(
                            color: Colors.green,
                            fontSize: 10.sp,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                  ],
                ),
                SizedBox(height: 0.5.h),
                Text(
                  version['date'],
                  style: GoogleFonts.inter(
                    color: Colors.grey[400],
                    fontSize: 12.sp,
                  ),
                ),
                if (version['notes'] != null) ...[
                  SizedBox(height: 0.5.h),
                  Text(
                    version['notes'],
                    style: GoogleFonts.inter(
                      color: Colors.grey[300],
                      fontSize: 12.sp,
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