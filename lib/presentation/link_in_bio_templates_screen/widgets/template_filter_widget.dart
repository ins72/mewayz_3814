import 'package:flutter/material.dart';

import '../../../core/app_export.dart';
import '../../../theme/app_theme.dart';

class TemplateFilterWidget extends StatefulWidget {
  final List<String> selectedFilters;
  final List<String> filterOptions;
  final Function(List<String>) onFiltersChanged;

  const TemplateFilterWidget({
    Key? key,
    required this.selectedFilters,
    required this.filterOptions,
    required this.onFiltersChanged,
  }) : super(key: key);

  @override
  State<TemplateFilterWidget> createState() => _TemplateFilterWidgetState();
}

class _TemplateFilterWidgetState extends State<TemplateFilterWidget> {
  late ScrollController _scrollController;
  
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

  void _toggleFilter(String filter) {
    final newFilters = List<String>.from(widget.selectedFilters);
    
    if (newFilters.contains(filter)) {
      newFilters.remove(filter);
    } else {
      newFilters.add(filter);
    }
    
    widget.onFiltersChanged(newFilters);
  }

  void _clearAllFilters() {
    widget.onFiltersChanged([]);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60,
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
        color: AppTheme.primaryBackground,
        border: Border(
          bottom: BorderSide(
            color: AppTheme.border,
            width: 1,
          ),
        ),
      ),
      child: Row(
        children: [
          const SizedBox(width: 16),
          
          // Filter icon
          Icon(
            Icons.filter_list,
            color: AppTheme.secondaryText,
            size: 20,
          ),
          
          const SizedBox(width: 12),
          
          // Filter chips
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              scrollDirection: Axis.horizontal,
              itemCount: widget.filterOptions.length,
              itemBuilder: (context, index) {
                final filter = widget.filterOptions[index];
                final isSelected = widget.selectedFilters.contains(filter);
                
                return Padding(
                  padding: EdgeInsets.only(right: index == widget.filterOptions.length - 1 ? 0 : 8),
                  child: FilterChip(
                    label: Text(filter),
                    selected: isSelected,
                    onSelected: (_) => _toggleFilter(filter),
                    backgroundColor: AppTheme.surface,
                    selectedColor: AppTheme.accent,
                    checkmarkColor: AppTheme.primaryText,
                    labelStyle: Theme.of(context).textTheme.labelSmall?.copyWith(
                      color: isSelected ? AppTheme.primaryText : AppTheme.secondaryText,
                      fontWeight: isSelected ? FontWeight.w500 : FontWeight.w400,
                    ),
                    side: BorderSide(
                      color: isSelected ? AppTheme.accent : AppTheme.border,
                      width: 1,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  ),
                );
              },
            ),
          ),
          
          // Clear filters button
          if (widget.selectedFilters.isNotEmpty) ...[
            const SizedBox(width: 12),
            GestureDetector(
              onTap: _clearAllFilters,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: AppTheme.surface,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: AppTheme.border),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.clear,
                      size: 16,
                      color: AppTheme.secondaryText,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      'Clear',
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        color: AppTheme.secondaryText,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
          
          const SizedBox(width: 16),
        ],
      ),
    );
  }
}