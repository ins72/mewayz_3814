import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sizer/sizer.dart';

class AppMetadataEditorWidget extends StatefulWidget {
  const AppMetadataEditorWidget({super.key});

  @override
  State<AppMetadataEditorWidget> createState() => _AppMetadataEditorWidgetState();
}

class _AppMetadataEditorWidgetState extends State<AppMetadataEditorWidget> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _subtitleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _keywordsController = TextEditingController();
  
  String _selectedLanguage = 'English';
  final List<String> _languages = ['English', 'Spanish', 'French', 'German', 'Italian'];

  @override
  void dispose() {
    _titleController.dispose();
    _subtitleController.dispose();
    _descriptionController.dispose();
    _keywordsController.dispose();
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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'App Metadata Editor',
                style: GoogleFonts.inter(
                  color: Colors.white,
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
              DropdownButton<String>(
                value: _selectedLanguage,
                dropdownColor: const Color(0xFF2A2A2A),
                icon: const Icon(Icons.arrow_drop_down, color: Colors.white),
                style: GoogleFonts.inter(color: Colors.white),
                items: _languages.map((String language) {
                  return DropdownMenuItem<String>(
                    value: language,
                    child: Text(language),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    _selectedLanguage = newValue!;
                  });
                },
              ),
            ],
          ),
          SizedBox(height: 3.h),
          _buildTextField(
            controller: _titleController,
            label: 'App Title',
            maxLength: 50,
            hint: 'Enter your app title...',
          ),
          SizedBox(height: 2.h),
          _buildTextField(
            controller: _subtitleController,
            label: 'Subtitle',
            maxLength: 30,
            hint: 'Enter subtitle...',
          ),
          SizedBox(height: 2.h),
          _buildTextField(
            controller: _descriptionController,
            label: 'Description',
            maxLength: 4000,
            hint: 'Enter app description...',
            maxLines: 5,
          ),
          SizedBox(height: 2.h),
          _buildTextField(
            controller: _keywordsController,
            label: 'Keywords',
            maxLength: 100,
            hint: 'Enter keywords separated by commas...',
          ),
          SizedBox(height: 3.h),
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    // Save metadata
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    padding: EdgeInsets.symmetric(vertical: 2.h),
                  ),
                  child: Text(
                    'Save Metadata',
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
                    // Preview metadata
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.grey[700],
                    padding: EdgeInsets.symmetric(vertical: 2.h),
                  ),
                  child: Text(
                    'Preview',
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
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required int maxLength,
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
          maxLength: maxLength,
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
            counterStyle: GoogleFonts.inter(color: Colors.grey[400]),
          ),
        ),
      ],
    );
  }
}