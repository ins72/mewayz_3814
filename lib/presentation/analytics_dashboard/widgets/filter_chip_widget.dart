import 'package:flutter/material.dart';

import '../../../core/app_export.dart';

class FilterChipWidget extends StatelessWidget {
  final String label;
  final bool isSelected;
  final ValueChanged<bool> onSelected;

  const FilterChipWidget({
    Key? key,
    required this.label,
    required this.isSelected,
    required this.onSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FilterChip(
      label: Text(
        label,
        style: AppTheme.darkTheme.textTheme.bodySmall?.copyWith(
          color: isSelected ? AppTheme.primaryBackground : AppTheme.primaryText,
          fontWeight: isSelected ? FontWeight.w500 : FontWeight.w400,
        ),
      ),
      selected: isSelected,
      onSelected: onSelected,
      backgroundColor: AppTheme.surface,
      selectedColor: AppTheme.accent,
      checkmarkColor: AppTheme.primaryBackground,
      side: BorderSide(
        color: isSelected ? AppTheme.accent : AppTheme.border,
        width: 1,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
    );
  }
}