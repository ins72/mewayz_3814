import 'package:flutter/material.dart';

import '../../../core/app_export.dart';

class TemplateLibraryWidget extends StatefulWidget {
  const TemplateLibraryWidget({Key? key}) : super(key: key);

  @override
  State<TemplateLibraryWidget> createState() => _TemplateLibraryWidgetState();
}

class _TemplateLibraryWidgetState extends State<TemplateLibraryWidget> {
  String _selectedCategory = 'All';
  String _selectedTemplate = '';

  final List<String> _categories = [
    'All',
    'Newsletter',
    'Promotional',
    'Welcome',
    'Abandoned Cart',
    'Re-engagement',
    'Event',
    'Survey',
  ];

  @override
  Widget build(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Row(children: [
        Icon(Icons.library_books_outlined, color: AppTheme.accent, size: 20),
        SizedBox(width: 8.w),
        Text('Template Library',
            style: Theme.of(context).textTheme.titleMedium),
      ]),
      SizedBox(height: 16.h),
      _buildCategoryFilter(),
      SizedBox(height: 16.h),
      _buildTemplateGrid(),
    ]);
  }

  Widget _buildCategoryFilter() {
    return SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
            children: _categories.map((category) {
          final isSelected = _selectedCategory == category;
          return Padding(
              padding: const EdgeInsets.only(right: 8),
              child: FilterChip(
                  label: Text(category),
                  selected: isSelected,
                  onSelected: (selected) {
                    setState(() {
                      _selectedCategory = category;
                    });
                  },
                  selectedColor: AppTheme.accent,
                  backgroundColor: AppTheme.surface,
                  labelStyle: TextStyle(
                      color: isSelected
                          ? AppTheme.primaryAction
                          : AppTheme.primaryText)));
        }).toList()));
  }

  Widget _buildTemplateGrid() {
    return GridView.count(
        crossAxisCount: 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        childAspectRatio: 0.75,
        children: [
          _buildTemplateCard(
              'Newsletter Template',
              'Modern newsletter design with sections for articles and updates',
              'assets/images/no-image.jpg',
              'Newsletter'),
          _buildTemplateCard(
              'Promotional Email',
              'Eye-catching template for sales and promotional campaigns',
              'assets/images/no-image.jpg',
              'Promotional'),
          _buildTemplateCard(
              'Welcome Series',
              'Welcoming template for new subscribers and users',
              'assets/images/no-image.jpg',
              'Welcome'),
          _buildTemplateCard(
              'Event Invitation',
              'Professional template for event invitations and announcements',
              'assets/images/no-image.jpg',
              'Event'),
          _buildTemplateCard(
              'Cart Recovery',
              'Effective template to recover abandoned shopping carts',
              'assets/images/no-image.jpg',
              'Abandoned Cart'),
          _buildTemplateCard(
              'Customer Survey',
              'Clean template for gathering customer feedback',
              'assets/images/no-image.jpg',
              'Survey'),
        ]);
  }

  Widget _buildTemplateCard(
      String title, String description, String imagePath, String category) {
    final isSelected = _selectedTemplate == title;

    return GestureDetector(
        onTap: () {
          setState(() {
            _selectedTemplate = title;
          });
        },
        child: Container(
            decoration: BoxDecoration(
                color: AppTheme.surface,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                    color: isSelected ? AppTheme.accent : AppTheme.border,
                    width: isSelected ? 2 : 1)),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Expanded(
                  flex: 3,
                  child: Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                          color: AppTheme.primaryBackground,
                          borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(12),
                              topRight: Radius.circular(12))),
                      child: ClipRRect(
                          borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(12),
                              topRight: Radius.circular(12)),
                          child: Stack(children: [
                            CustomImageWidget(
                                imageUrl: imagePath,
                                width: double.infinity,
                                height: double.infinity,
                                fit: BoxFit.cover),
                            if (isSelected)
                              Container(
                                  decoration: BoxDecoration(
                                      color: AppTheme.accent.withAlpha(26)),
                                  child: Center(
                                      child: Container(
                                          padding: const EdgeInsets.all(8),
                                          decoration: BoxDecoration(
                                              color: AppTheme.accent,
                                              shape: BoxShape.circle),
                                          child: Icon(Icons.check_rounded,
                                              color: AppTheme.primaryAction,
                                              size: 16)))),
                          ])))),
              Expanded(
                  flex: 2,
                  child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(children: [
                              Expanded(
                                  child: Text(title,
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyMedium
                                          ?.copyWith(
                                              fontWeight: FontWeight.w500,
                                              color: AppTheme.primaryText),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis)),
                              Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 6, vertical: 2),
                                  decoration: BoxDecoration(
                                      color: AppTheme.accent.withAlpha(26),
                                      borderRadius: BorderRadius.circular(4)),
                                  child: Text(category,
                                      style: TextStyle(
                                          fontSize: 10,
                                          color: AppTheme.accent,
                                          fontWeight: FontWeight.w500))),
                            ]),
                            SizedBox(height: 6.h),
                            Text(description,
                                style: Theme.of(context)
                                    .textTheme
                                    .bodySmall
                                    ?.copyWith(color: AppTheme.secondaryText),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis),
                            const Spacer(),
                            Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  if (isSelected)
                                    Icon(Icons.check_circle_rounded,
                                        color: AppTheme.accent, size: 16),
                                ]),
                          ]))),
            ])));
  }
}