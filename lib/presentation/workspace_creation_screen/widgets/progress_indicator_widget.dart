import 'package:flutter/material.dart';

import '../../../core/app_export.dart';

class WorkspaceProgressIndicatorWidget extends StatelessWidget {
  final int currentStep;
  final int totalSteps;

  const WorkspaceProgressIndicatorWidget({
    Key? key,
    required this.currentStep,
    required this.totalSteps,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Step ${currentStep + 1} of $totalSteps',
              style: AppTheme.darkTheme.textTheme.bodyMedium?.copyWith(
                color: AppTheme.secondaryText,
              ),
            ),
            Text(
              '${((currentStep + 1) / totalSteps * 100).round()}%',
              style: AppTheme.darkTheme.textTheme.bodyMedium?.copyWith(
                color: AppTheme.accent,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        SizedBox(height: 1.h),
        LinearProgressIndicator(
          value: (currentStep + 1) / totalSteps,
          backgroundColor: AppTheme.border,
          valueColor: const AlwaysStoppedAnimation<Color>(AppTheme.accent),
        ),
        SizedBox(height: 2.h),
        Row(
          children: List.generate(totalSteps, (index) {
            final isCompleted = index < currentStep;
            final isCurrent = index == currentStep;

            return Expanded(
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      height: 0.5.h,
                      decoration: BoxDecoration(
                        color: isCompleted || isCurrent
                            ? AppTheme.accent
                            : AppTheme.border,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                  if (index < totalSteps - 1) SizedBox(width: 1.w),
                ],
              ),
            );
          }),
        ),
      ],
    );
  }
}