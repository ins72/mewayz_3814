import 'package:flutter/material.dart';

import '../../../core/app_export.dart';

class WorkspaceTemplateWidget extends StatelessWidget {
  final List<Map<String, dynamic>> templates;
  final String selectedTemplate;
  final Function(String) onTemplateChanged;

  const WorkspaceTemplateWidget({
    Key? key,
    required this.templates,
    required this.selectedTemplate,
    required this.onTemplateChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(4.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Choose a template',
            style: AppTheme.darkTheme.textTheme.headlineSmall,
          ),
          SizedBox(height: 1.h),
          Text(
            'Select a pre-configured template to get started quickly.',
            style: AppTheme.darkTheme.textTheme.bodyMedium?.copyWith(
              color: AppTheme.secondaryText,
            ),
          ),
          SizedBox(height: 4.h),
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: templates.length,
            separatorBuilder: (context, index) => SizedBox(height: 2.h),
            itemBuilder: (context, index) {
              final template = templates[index];
              final isSelected = template['id'] == selectedTemplate;

              return GestureDetector(
                onTap: () => onTemplateChanged(template['id']),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  padding: EdgeInsets.all(4.w),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? AppTheme.accent.withAlpha(26)
                        : AppTheme.surface,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: isSelected ? AppTheme.accent : AppTheme.border,
                      width: isSelected ? 2 : 1,
                    ),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 15.w,
                        height: 15.w,
                        decoration: BoxDecoration(
                          color: isSelected
                              ? AppTheme.accent.withAlpha(51)
                              : AppTheme.primaryBackground,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Center(
                          child: CustomIconWidget(
                            iconName: template['icon'],
                            color: isSelected
                                ? AppTheme.accent
                                : AppTheme.secondaryText,
                            size: 32,
                          ),
                        ),
                      ),
                      SizedBox(width: 4.w),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              template['name'],
                              style: AppTheme.darkTheme.textTheme.titleMedium
                                  ?.copyWith(
                                color: isSelected
                                    ? AppTheme.accent
                                    : AppTheme.primaryText,
                              ),
                            ),
                            SizedBox(height: 0.5.h),
                            Text(
                              template['description'],
                              style: AppTheme.darkTheme.textTheme.bodySmall
                                  ?.copyWith(
                                color: AppTheme.secondaryText,
                              ),
                            ),
                            SizedBox(height: 1.h),
                            Wrap(
                              spacing: 2.w,
                              runSpacing: 0.5.h,
                              children: (template['features'] as List<String>)
                                  .map((feature) {
                                return Container(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 2.w, vertical: 0.5.h),
                                  decoration: BoxDecoration(
                                    color: isSelected
                                        ? AppTheme.accent.withAlpha(51)
                                        : AppTheme.border.withAlpha(128),
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  child: Text(
                                    feature,
                                    style: AppTheme
                                        .darkTheme.textTheme.labelSmall
                                        ?.copyWith(
                                      color: isSelected
                                          ? AppTheme.accent
                                          : AppTheme.secondaryText,
                                    ),
                                  ),
                                );
                              }).toList(),
                            ),
                          ],
                        ),
                      ),
                      if (isSelected) ...[
                        SizedBox(width: 2.w),
                        const CustomIconWidget(
                          iconName: 'check_circle',
                          color: AppTheme.accent,
                          size: 24,
                        ),
                      ],
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}