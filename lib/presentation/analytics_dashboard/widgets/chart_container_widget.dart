import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class ChartContainerWidget extends StatelessWidget {
  final String title;
  final Widget child;
  final VoidCallback? onTap;

  const ChartContainerWidget({
    Key? key,
    required this.title,
    required this.child,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.all(4.w),
        decoration: BoxDecoration(
          color: AppTheme.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: AppTheme.border,
            width: 1,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  title,
                  style: AppTheme.darkTheme.textTheme.titleMedium,
                ),
                if (onTap != null)
                  CustomIconWidget(
                    iconName: 'fullscreen',
                    color: AppTheme.secondaryText,
                    size: 20,
                  ),
              ],
            ),
            SizedBox(height: 2.h),
            child,
          ],
        ),
      ),
    );
  }
}
