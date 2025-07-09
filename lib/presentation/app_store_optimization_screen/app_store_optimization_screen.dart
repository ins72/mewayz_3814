import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sizer/sizer.dart';

import './widgets/app_metadata_editor_widget.dart';
import './widgets/build_management_widget.dart';
import './widgets/platform_section_widget.dart';
import './widgets/privacy_compliance_widget.dart';
import './widgets/screenshot_manager_widget.dart';
import './widgets/submission_checklist_widget.dart';

class AppStoreOptimizationScreen extends StatefulWidget {
  const AppStoreOptimizationScreen({super.key});

  @override
  State<AppStoreOptimizationScreen> createState() => _AppStoreOptimizationScreenState();
}

class _AppStoreOptimizationScreenState extends State<AppStoreOptimizationScreen> {
  final List<Map<String, dynamic>> _iosRequirements = [
{ 'title': 'App Metadata',
'description': 'Title, description, keywords completed',
'completed': true,
},
{ 'title': 'Screenshots & Videos',
'description': 'Required screenshots uploaded',
'completed': false,
},
{ 'title': 'Privacy Policy',
'description': 'Privacy policy URL provided',
'completed': true,
},
{ 'title': 'Content Rating',
'description': 'Age rating questionnaire completed',
'completed': false,
},
];

  final List<Map<String, dynamic>> _androidRequirements = [
{ 'title': 'Store Listing',
'description': 'App details and description',
'completed': true,
},
{ 'title': 'Graphic Assets',
'description': 'Screenshots and feature graphic',
'completed': false,
},
{ 'title': 'Content Rating',
'description': 'IARC rating questionnaire',
'completed': false,
},
{ 'title': 'Privacy Policy',
'description': 'Privacy policy compliance',
'completed': true,
},
];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF101010),
      appBar: AppBar(
        backgroundColor: const Color(0xFF101010),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'App Store Optimization',
          style: GoogleFonts.inter(
            color: Colors.white,
            fontSize: 18.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.help_outline, color: Colors.white),
            onPressed: () {
              // Show help dialog
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(4.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header with submission progress
            const SubmissionChecklistWidget(),
            SizedBox(height: 3.h),
            
            // Platform sections
            Text(
              'Platform Preparation',
              style: GoogleFonts.inter(
                color: Colors.white,
                fontSize: 18.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 2.h),
            
            PlatformSectionWidget(
              platformName: 'iOS App Store',
              platformIcon: 'ios',
              requirements: _iosRequirements,
            ),
            
            PlatformSectionWidget(
              platformName: 'Google Play Store',
              platformIcon: 'android',
              requirements: _androidRequirements,
            ),
            
            SizedBox(height: 3.h),
            
            // App Metadata Editor
            const AppMetadataEditorWidget(),
            SizedBox(height: 3.h),
            
            // Screenshot Manager
            const ScreenshotManagerWidget(),
            SizedBox(height: 3.h),
            
            // Privacy Compliance
            const PrivacyComplianceWidget(),
            SizedBox(height: 3.h),
            
            // Build Management
            const BuildManagementWidget(),
            SizedBox(height: 3.h),
            
            // Submission Actions
            Container(
              padding: EdgeInsets.all(4.w),
              decoration: BoxDecoration(
                color: const Color(0xFF191919),
                borderRadius: BorderRadius.circular(12.0),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Submission Actions',
                    style: GoogleFonts.inter(
                      color: Colors.white,
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: 2.h),
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            // Run pre-submission validation
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.orange,
                            padding: EdgeInsets.symmetric(vertical: 2.h),
                          ),
                          child: Text(
                            'Validate Submission',
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
                            // Export submission materials
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green,
                            padding: EdgeInsets.symmetric(vertical: 2.h),
                          ),
                          child: Text(
                            'Export Materials',
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
        ),
      ),
    );
  }
}