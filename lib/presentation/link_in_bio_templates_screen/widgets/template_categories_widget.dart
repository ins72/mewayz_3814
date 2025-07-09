import 'package:flutter/material.dart';

import '../../../core/app_export.dart';
import '../../../theme/app_theme.dart';

class TemplateCategoriesWidget extends StatefulWidget {
  final List<String> categories;
  final List<String> selectedCategories;
  final Function(String) onCategorySelected;
  final Function(String) onTemplatePreview;
  final Function(String) onTemplateUse;

  const TemplateCategoriesWidget({
    Key? key,
    required this.categories,
    required this.selectedCategories,
    required this.onCategorySelected,
    required this.onTemplatePreview,
    required this.onTemplateUse,
  }) : super(key: key);

  @override
  State<TemplateCategoriesWidget> createState() => _TemplateCategoriesWidgetState();
}

class _TemplateCategoriesWidgetState extends State<TemplateCategoriesWidget> {
  late ScrollController _scrollController;

  final Map<String, IconData> _categoryIcons = {
    'All': Icons.grid_view,
    'Influencer': Icons.star,
    'Business': Icons.business,
    'Artist': Icons.palette,
    'Fitness': Icons.fitness_center,
    'Restaurant': Icons.restaurant,
    'E-commerce': Icons.shopping_cart,
    'Creative': Icons.brush,
    'Personal': Icons.person,
    'Event': Icons.event,
    'Music': Icons.music_note,
    'Photography': Icons.photo_camera,
    'Travel': Icons.flight,
    'Food': Icons.fastfood,
    'Tech': Icons.computer,
    'Health': Icons.health_and_safety,
  };

  final Map<String, int> _categoryTemplateCounts = {
    'All': 156,
    'Influencer': 24,
    'Business': 18,
    'Artist': 22,
    'Fitness': 12,
    'Restaurant': 15,
    'E-commerce': 20,
    'Creative': 16,
    'Personal': 14,
    'Event': 10,
    'Music': 8,
    'Photography': 11,
    'Travel': 9,
    'Food': 7,
    'Tech': 13,
    'Health': 6,
  };

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      controller: _scrollController,
      padding: const EdgeInsets.all(16),
      itemCount: widget.categories.length,
      itemBuilder: (context, index) {
        final category = widget.categories[index];
        final isSelected = widget.selectedCategories.contains(category);
        final icon = _categoryIcons[category] ?? Icons.category;
        final count = _categoryTemplateCounts[category] ?? 0;

        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: GestureDetector(
            onTap: () => widget.onCategorySelected(category),
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: isSelected ? AppTheme.accent.withAlpha(26) : AppTheme.surface,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: isSelected ? AppTheme.accent : AppTheme.border,
                  width: 1,
                ),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: isSelected ? AppTheme.accent : AppTheme.primaryBackground,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(
                      icon,
                      color: isSelected ? AppTheme.primaryText : AppTheme.accent,
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          category,
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            color: AppTheme.primaryText,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '$count templates',
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: AppTheme.secondaryText,
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (isSelected)
                    Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: AppTheme.accent,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Icon(
                        Icons.check,
                        color: AppTheme.primaryText,
                        size: 16,
                      ),
                    )
                  else
                    Icon(
                      Icons.arrow_forward_ios,
                      color: AppTheme.secondaryText,
                      size: 16,
                    ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}