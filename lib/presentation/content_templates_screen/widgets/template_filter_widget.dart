import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../widgets/custom_icon_widget.dart';

class TemplateFilterWidget extends StatelessWidget {
  final String selectedCategory;
  final String selectedPlatform;
  final String selectedIndustry;
  final Function(String) onCategoryChanged;
  final Function(String) onPlatformChanged;
  final Function(String) onIndustryChanged;

  const TemplateFilterWidget({
    Key? key,
    required this.selectedCategory,
    required this.selectedPlatform,
    required this.selectedIndustry,
    required this.onCategoryChanged,
    required this.onPlatformChanged,
    required this.onIndustryChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        color: const Color(0xFF101010),
        child: Column(children: [
          // Category Filter
          _buildFilterRow(
              'Category',
              selectedCategory,
              [
                'All',
                'promotional',
                'quotes',
                'announcements',
                'stories',
                'seasonal'
              ],
              onCategoryChanged,
              {
                'promotional': Icons.campaign,
                'quotes': Icons.format_quote,
                'announcements': Icons.announcement,
                'stories': Icons.auto_stories,
                'seasonal': Icons.celebration,
              }),

          const SizedBox(height: 8),

          // Platform Filter
          _buildFilterRow(
              'Platform',
              selectedPlatform,
              ['All', 'Instagram', 'Facebook', 'Twitter', 'LinkedIn'],
              onPlatformChanged,
              {
                'Instagram': Icons.camera_alt,
                'Facebook': Icons.facebook,
                'Twitter': Icons.alternate_email,
                'LinkedIn': Icons.business,
              }),

          const SizedBox(height: 8),

          // Industry Filter
          _buildFilterRow(
              'Industry',
              selectedIndustry,
              ['All', 'E-commerce', 'Business', 'Events', 'General', 'Retail'],
              onIndustryChanged,
              {
                'E-commerce': Icons.shopping_cart,
                'Business': Icons.business_center,
                'Events': Icons.event,
                'General': Icons.public,
                'Retail': Icons.store,
              }),
        ]));
  }

  Widget _buildFilterRow(
      String label,
      String selectedValue,
      List<String> options,
      Function(String) onChanged,
      Map<String, IconData> icons) {
    return Row(children: [
      SizedBox(
          width: 70,
          child: Text('$label:',
              style: GoogleFonts.inter(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: const Color(0xFF7B7B7B)))),
      Expanded(
          child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                  children: options.map((option) {
                final isSelected = selectedValue == option;
                final icon = icons[option];

                return GestureDetector(
                    onTap: () => onChanged(option),
                    child: Container(
                        margin: const EdgeInsets.only(right: 8),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                            color: isSelected
                                ? const Color(0xFF3B82F6)
                                : const Color(0xFF191919),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                                color: isSelected
                                    ? const Color(0xFF3B82F6)
                                    : const Color(0xFF282828),
                                width: 1)),
                        child: Row(mainAxisSize: MainAxisSize.min, children: [
                          if (icon != null) ...[
                            CustomIconWidget(
                                iconName: option,
                                size: 12,
                                color: isSelected
                                    ? const Color(0xFFF1F1F1)
                                    : const Color(0xFF7B7B7B)),
                            const SizedBox(width: 4),
                          ],
                          Text(option,
                              style: GoogleFonts.inter(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w500,
                                  color: isSelected
                                      ? const Color(0xFFF1F1F1)
                                      : const Color(0xFF7B7B7B))),
                        ])));
              }).toList()))),
    ]);
  }
}
