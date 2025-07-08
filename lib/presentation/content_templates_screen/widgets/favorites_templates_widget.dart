import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../widgets/custom_icon_widget.dart';
import './template_card_widget.dart';

class FavoritesTemplatesWidget extends StatelessWidget {
  final List<Map<String, dynamic>> favoriteTemplates;
  final Function(Map<String, dynamic>) onTemplatePressed;
  final Function(String) onToggleFavorite;

  const FavoritesTemplatesWidget({
    Key? key,
    required this.favoriteTemplates,
    required this.onTemplatePressed,
    required this.onToggleFavorite,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (favoriteTemplates.isEmpty) {
      return _buildEmptyState();
    }

    return GridView.builder(
        padding: const EdgeInsets.all(16),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 0.8),
        itemCount: favoriteTemplates.length,
        itemBuilder: (context, index) {
          final template = favoriteTemplates[index];
          return TemplateCardWidget(
              template: template,
              onPressed: () => onTemplatePressed(template),
              onFavorite: () => onToggleFavorite(template['id']));
        });
  }

  Widget _buildEmptyState() {
    return Center(
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
      const CustomIconWidget(
          iconName: 'favorite', color: Color(0xFF7B7B7B), size: 48),
      const SizedBox(height: 16),
      Text('No Favorite Templates',
          style: GoogleFonts.inter(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: const Color(0xFFF1F1F1))),
      const SizedBox(height: 8),
      Text('Mark templates as favorites to see them here.',
          textAlign: TextAlign.center,
          style: GoogleFonts.inter(
              fontSize: 14,
              fontWeight: FontWeight.w400,
              color: const Color(0xFF7B7B7B))),
    ]));
  }
}
