import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sizer/sizer.dart';

import './widgets/checklist_progress_widget.dart';
import './widgets/performance_metrics_widget.dart';
import './widgets/security_checklist_widget.dart';
import './widgets/store_compliance_widget.dart';
import './widgets/technical_requirements_widget.dart';
import './widgets/user_experience_checklist_widget.dart';

class ProductionReleaseChecklistScreen extends StatefulWidget {
  const ProductionReleaseChecklistScreen({super.key});

  @override
  State<ProductionReleaseChecklistScreen> createState() => _ProductionReleaseChecklistScreenState();
}

class _ProductionReleaseChecklistScreenState extends State<ProductionReleaseChecklistScreen> {
  // Mock data for overall progress
  final int _totalItems = 25;
  final int _completedItems = 18;
  
  double get _completionPercentage => (_completedItems / _totalItems) * 100;

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
          'Production Release Checklist',
          style: GoogleFonts.inter(
            color: Colors.white,
            fontSize: 18.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, color: Colors.white),
            onPressed: () {
              // Refresh all checks
              setState(() {
                // Trigger refresh
              });
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(4.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Overall progress header
            ChecklistProgressWidget(
              completionPercentage: _completionPercentage,
              completedItems: _completedItems,
              totalItems: _totalItems,
            ),
            SizedBox(height: 3.h),
            
            // Categorized checklist sections
            Text(
              'Readiness Categories',
              style: GoogleFonts.inter(
                color: Colors.white,
                fontSize: 18.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 2.h),
            
            // Technical Requirements
            const TechnicalRequirementsWidget(),
            
            // User Experience
            const UserExperienceChecklistWidget(),
            
            // Security & Privacy
            const SecurityChecklistWidget(),
            
            // Performance
            const PerformanceMetricsWidget(),
            
            // Store Compliance
            const StoreComplianceWidget(),
            
            SizedBox(height: 3.h),
            
            // Action buttons
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
                    'Release Actions',
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
                          onPressed: _completionPercentage == 100 ? () {
                            // Generate release readiness report
                          } : null,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: _completionPercentage == 100 ? Colors.green : Colors.grey,
                            padding: EdgeInsets.symmetric(vertical: 2.h),
                          ),
                          child: Text(
                            'Generate Release Report',
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
                            // Run comprehensive test suite
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue,
                            padding: EdgeInsets.symmetric(vertical: 2.h),
                          ),
                          child: Text(
                            'Run Full Test Suite',
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
                  SizedBox(height: 2.h),
                  if (_completionPercentage < 100) ...[
                    Container(
                      padding: EdgeInsets.all(3.w),
                      decoration: BoxDecoration(
                        color: const Color(0xFF2A2A2A),
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.warning,
                            color: Colors.orange,
                            size: 20.sp,
                          ),
                          SizedBox(width: 3.w),
                          Expanded(
                            child: Text(
                              'Complete all checklist items before generating the release report.',
                              style: GoogleFonts.inter(
                                color: Colors.grey[400],
                                fontSize: 12.sp,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ] else ...[
                    Container(
                      padding: EdgeInsets.all(3.w),
                      decoration: BoxDecoration(
                        color: const Color(0xFF2A2A2A),
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.check_circle,
                            color: Colors.green,
                            size: 20.sp,
                          ),
                          SizedBox(width: 3.w),
                          Expanded(
                            child: Text(
                              'All checks completed! Your app is ready for production release.',
                              style: GoogleFonts.inter(
                                color: Colors.green,
                                fontSize: 12.sp,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}