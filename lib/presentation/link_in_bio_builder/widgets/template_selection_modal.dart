import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class TemplateSelectionModal extends StatefulWidget {
  final List<Map<String, dynamic>> templates;
  final Function(Map<String, dynamic>) onTemplateSelected;

  const TemplateSelectionModal({
    Key? key,
    required this.templates,
    required this.onTemplateSelected,
  }) : super(key: key);

  @override
  State<TemplateSelectionModal> createState() => _TemplateSelectionModalState();
}

class _TemplateSelectionModalState extends State<TemplateSelectionModal> {
  String _selectedCategory = 'All';
  final List<String> _categories = [
    'All',
    'Minimal',
    'Business',
    'Creative',
    'E-commerce'
  ];

  @override
  Widget build(BuildContext context) {
    return Dialog(
        backgroundColor: AppTheme.surface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Container(
            width: 90.w,
            height: 80.h,
            padding: EdgeInsets.all(4.w),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                Text('Choose Template',
                    style: AppTheme.darkTheme.textTheme.titleLarge
                        ?.copyWith(color: AppTheme.primaryText)),
                IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: CustomIconWidget(
                        iconName: 'close',
                        color: AppTheme.primaryText,
                        size: 24)),
              ]),
              SizedBox(height: 2.h),
              Text('Select a template to get started quickly',
                  style: AppTheme.darkTheme.textTheme.bodyMedium
                      ?.copyWith(color: AppTheme.secondaryText)),
              SizedBox(height: 3.h),
              // Category filter
              Container(
                  height: 5.h,
                  child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: _categories.length,
                      itemBuilder: (context, index) {
                        final category = _categories[index];
                        final isSelected = _selectedCategory == category;
                        return GestureDetector(
                            onTap: () {
                              setState(() {
                                _selectedCategory = category;
                              });
                            },
                            child: Container(
                                margin: EdgeInsets.only(right: 2.w),
                                padding: EdgeInsets.symmetric(
                                    horizontal: 4.w, vertical: 1.h),
                                decoration: BoxDecoration(
                                    color: isSelected
                                        ? AppTheme.accent
                                        : Colors.transparent,
                                    borderRadius: BorderRadius.circular(20),
                                    border: Border.all(
                                        color: isSelected
                                            ? AppTheme.accent
                                            : AppTheme.border)),
                                child: Text(category,
                                    style: AppTheme
                                        .darkTheme.textTheme.bodyMedium
                                        ?.copyWith(
                                            color: isSelected
                                                ? AppTheme.primaryAction
                                                : AppTheme.primaryText))));
                      })),
              SizedBox(height: 3.h),
              // Templates grid
              Expanded(
                  child: GridView.builder(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 4.w,
                          mainAxisSpacing: 2.h,
                          childAspectRatio: 0.75),
                      itemCount: widget.templates.length,
                      itemBuilder: (context, index) {
                        final template = widget.templates[index];
                        return _buildTemplateCard(template);
                      })),
              SizedBox(height: 2.h),
              // Action buttons
              Row(children: [
                Expanded(
                    child: OutlinedButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text('Cancel'))),
                SizedBox(width: 4.w),
                Expanded(
                    child: ElevatedButton(
                        onPressed: () {
                          // Start from blank template
                          Navigator.pop(context);
                          widget.onTemplateSelected({
                            'id': 'blank',
                            'name': 'Blank',
                            'components': [],
                          });
                        },
                        child: const Text('Start Blank'))),
              ]),
            ])));
  }

  Widget _buildTemplateCard(Map<String, dynamic> template) {
    return GestureDetector(
        onTap: () {
          Navigator.pop(context);
          widget.onTemplateSelected(template);
        },
        child: Container(
            decoration: BoxDecoration(
                color: AppTheme.primaryBackground,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppTheme.border)),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Expanded(
                  child: ClipRRect(
                      borderRadius:
                          BorderRadius.vertical(top: Radius.circular(12)),
                      child: Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                              gradient: LinearGradient(
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                  colors: [
                                AppTheme.accent.withAlpha(51),
                                AppTheme.success.withAlpha(51),
                              ])),
                          child: CustomImageWidget(imageUrl: template['imageUrl'] ?? '', fit: BoxFit.cover)))),
              Padding(
                  padding: EdgeInsets.all(3.w),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(template['name'],
                            style: AppTheme.darkTheme.textTheme.titleSmall
                                ?.copyWith(color: AppTheme.primaryText)),
                        SizedBox(height: 1.h),
                        Text('${template['components'].length} components',
                            style: AppTheme.darkTheme.textTheme.bodySmall
                                ?.copyWith(color: AppTheme.secondaryText)),
                      ])),
            ])));
  }
}