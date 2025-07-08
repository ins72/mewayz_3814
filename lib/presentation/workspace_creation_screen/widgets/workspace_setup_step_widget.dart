import 'dart:io';

import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import './workspace_logo_upload_widget.dart';

class WorkspaceSetupStepWidget extends StatelessWidget {
  final TextEditingController nameController;
  final TextEditingController descriptionController;
  final String selectedIndustry;
  final List<String> industries;
  final File? logoFile;
  final String logoUrl;
  final Function(String) onIndustryChanged;
  final Function(File?, String) onLogoChanged;

  const WorkspaceSetupStepWidget({
    Key? key,
    required this.nameController,
    required this.descriptionController,
    required this.selectedIndustry,
    required this.industries,
    required this.logoFile,
    required this.logoUrl,
    required this.onIndustryChanged,
    required this.onLogoChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(4.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Let\'s set up your workspace',
            style: AppTheme.darkTheme.textTheme.headlineSmall,
          ),
          SizedBox(height: 1.h),
          Text(
            'Provide basic information about your workspace to get started.',
            style: AppTheme.darkTheme.textTheme.bodyMedium?.copyWith(
              color: AppTheme.secondaryText,
            ),
          ),
          SizedBox(height: 4.h),

          // Logo Upload
          WorkspaceLogoUploadWidget(
            logoFile: logoFile,
            logoUrl: logoUrl,
            onLogoChanged: onLogoChanged,
          ),

          SizedBox(height: 4.h),

          // Workspace Name
          Text(
            'Workspace Name *',
            style: AppTheme.darkTheme.textTheme.titleMedium,
          ),
          SizedBox(height: 1.h),
          TextField(
            controller: nameController,
            style: AppTheme.darkTheme.textTheme.bodyMedium,
            decoration: InputDecoration(
              hintText: 'Enter workspace name',
              filled: true,
              fillColor: AppTheme.surface,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: AppTheme.border),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: AppTheme.border),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: AppTheme.accent, width: 2),
              ),
            ),
          ),

          SizedBox(height: 3.h),

          // Description
          Text(
            'Description',
            style: AppTheme.darkTheme.textTheme.titleMedium,
          ),
          SizedBox(height: 1.h),
          TextField(
            controller: descriptionController,
            style: AppTheme.darkTheme.textTheme.bodyMedium,
            maxLines: 3,
            decoration: InputDecoration(
              hintText: 'Tell us about your workspace...',
              filled: true,
              fillColor: AppTheme.surface,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: AppTheme.border),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: AppTheme.border),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: AppTheme.accent, width: 2),
              ),
            ),
          ),

          SizedBox(height: 3.h),

          // Industry Selection
          Text(
            'Industry',
            style: AppTheme.darkTheme.textTheme.titleMedium,
          ),
          SizedBox(height: 1.h),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
            decoration: BoxDecoration(
              color: AppTheme.surface,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppTheme.border),
            ),
            child: DropdownButton<String>(
              value: selectedIndustry,
              onChanged: (String? newValue) {
                if (newValue != null) {
                  onIndustryChanged(newValue);
                }
              },
              items: industries.map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(
                    value,
                    style: AppTheme.darkTheme.textTheme.bodyMedium,
                  ),
                );
              }).toList(),
              isExpanded: true,
              underline: Container(),
              dropdownColor: AppTheme.surface,
              icon: const CustomIconWidget(
                iconName: 'keyboard_arrow_down',
                color: AppTheme.secondaryText,
                size: 24,
              ),
            ),
          ),

          SizedBox(height: 4.h),

          // Tips Section
          Container(
            padding: EdgeInsets.all(4.w),
            decoration: BoxDecoration(
              color: AppTheme.accent.withAlpha(26),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppTheme.accent.withAlpha(51)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const CustomIconWidget(
                      iconName: 'lightbulb',
                      color: AppTheme.accent,
                      size: 20,
                    ),
                    SizedBox(width: 2.w),
                    Text(
                      'Tips for naming your workspace',
                      style: AppTheme.darkTheme.textTheme.titleSmall?.copyWith(
                        color: AppTheme.accent,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 1.h),
                Text(
                  '• Use a clear, descriptive name\n• Keep it short and memorable\n• Avoid special characters\n• Make it relevant to your business',
                  style: AppTheme.darkTheme.textTheme.bodySmall?.copyWith(
                    color: AppTheme.primaryText,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
