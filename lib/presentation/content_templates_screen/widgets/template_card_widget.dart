import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../widgets/custom_icon_widget.dart';
import '../../../widgets/custom_image_widget.dart';

class TemplateCardWidget extends StatelessWidget {
  final Map<String, dynamic> template;
  final VoidCallback onPressed;
  final VoidCallback onFavorite;

  const TemplateCardWidget({
    Key? key,
    required this.template,
    required this.onPressed,
    required this.onFavorite,
  }) : super(key: key);

  Color _getCategoryColor(String category) {
    switch (category.toLowerCase()) {
      case 'promotional':
        return const Color(0xFFEF4444);
      case 'quotes':
        return const Color(0xFF8B5CF6);
      case 'announcements':
        return const Color(0xFF3B82F6);
      case 'stories':
        return const Color(0xFFEC4899);
      case 'seasonal':
        return const Color(0xFF10B981);
      default:
        return const Color(0xFF7B7B7B);
    }
  }

  String _formatNumber(int number) {
    if (number >= 1000) {
      return '${(number / 1000).toStringAsFixed(1)}K';
    }
    return number.toString();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: onPressed,
        child: Container(
            decoration: BoxDecoration(
                color: const Color(0xFF191919),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFF282828), width: 1)),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              // Template Thumbnail
              Expanded(
                  flex: 3,
                  child: Stack(children: [
                    ClipRRect(
                        borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(12),
                            topRight: Radius.circular(12)),
                        child: CustomImageWidget(
                            imageUrl: template['imageUrl'] ?? '',
                            width: double.infinity,
                            height: double.infinity,
                            fit: BoxFit.cover)),

                    // Category Badge
                    Positioned(
                        top: 8,
                        left: 8,
                        child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 6, vertical: 3),
                            decoration: BoxDecoration(
                                color: _getCategoryColor(template['category']),
                                borderRadius: BorderRadius.circular(4)),
                            child: Text(template['category'].toUpperCase(),
                                style: GoogleFonts.inter(
                                    fontSize: 8,
                                    fontWeight: FontWeight.w600,
                                    color: const Color(0xFFF1F1F1))))),

                    // Favorite Button
                    Positioned(
                        top: 8,
                        right: 8,
                        child: GestureDetector(
                            onTap: onFavorite,
                            child: Container(
                                padding: const EdgeInsets.all(4),
                                decoration: BoxDecoration(
                                    color:
                                        const Color(0xFF000000).withAlpha(153),
                                    shape: BoxShape.circle),
                                child: CustomIconWidget(
                                    iconName: 'favorite',
                                    color: template['isFavorite']
                                        ? const Color(0xFFEF4444)
                                        : const Color(0xFFF1F1F1),
                                    size: 16)))),

                    // Platform Icons
                    Positioned(
                        bottom: 8,
                        right: 8,
                        child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: (template['platform'] as List<String>)
                                .take(3)
                                .map((platform) {
                              IconData icon;
                              switch (platform.toLowerCase()) {
                                case 'instagram':
                                  icon = Icons.camera_alt;
                                  break;
                                case 'facebook':
                                  icon = Icons.facebook;
                                  break;
                                case 'twitter':
                                  icon = Icons.alternate_email;
                                  break;
                                case 'linkedin':
                                  icon = Icons.business;
                                  break;
                                default:
                                  icon = Icons.public;
                              }

                              return Container(
                                  margin: const EdgeInsets.only(left: 2),
                                  padding: const EdgeInsets.all(3),
                                  decoration: BoxDecoration(
                                      color: const Color(0xFF000000)
                                          .withAlpha(153),
                                      shape: BoxShape.circle),
                                  child: CustomIconWidget(
                                      iconName: platform.toLowerCase(),
                                      color: const Color(0xFFF1F1F1),
                                      size: 12));
                            }).toList())),
                  ])),

              // Template Info
              Expanded(
                  flex: 2,
                  child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Title
                            Text(template['title'],
                                style: GoogleFonts.inter(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    color: const Color(0xFFF1F1F1)),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis),

                            const SizedBox(height: 4),

                            // Description
                            Text(template['description'],
                                style: GoogleFonts.inter(
                                    fontSize: 11,
                                    fontWeight: FontWeight.w400,
                                    color: const Color(0xFF7B7B7B)),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis),

                            const Spacer(),

                            // Metrics
                            Row(children: [
                              // Engagement Score
                              Row(children: [
                                const CustomIconWidget(
                                    iconName: 'star',
                                    color: Color(0xFFF59E0B),
                                    size: 12),
                                const SizedBox(width: 2),
                                Text(template['engagementScore'].toString(),
                                    style: GoogleFonts.inter(
                                        fontSize: 10,
                                        fontWeight: FontWeight.w500,
                                        color: const Color(0xFFF1F1F1))),
                              ]),

                              const SizedBox(width: 12),

                              // Usage Count
                              Row(children: [
                                const CustomIconWidget(
                                    iconName: 'use_count',
                                    color: Color(0xFF7B7B7B),
                                    size: 12),
                                const SizedBox(width: 2),
                                Text(_formatNumber(template['usageCount']),
                                    style: GoogleFonts.inter(
                                        fontSize: 10,
                                        fontWeight: FontWeight.w500,
                                        color: const Color(0xFF7B7B7B))),
                              ]),
                            ]),

                            const SizedBox(height: 6),

                            // Color Palette
                            Row(children: [
                              ...(template['colors'] as List<String>)
                                  .take(3)
                                  .map((color) {
                                return Container(
                                    width: 12,
                                    height: 12,
                                    margin: const EdgeInsets.only(right: 4),
                                    decoration: BoxDecoration(
                                        color: Color(int.parse(
                                            color.replaceAll('#', '0xFF'))),
                                        shape: BoxShape.circle,
                                        border: Border.all(
                                            color: const Color(0xFF282828),
                                            width: 1)));
                              }).toList(),

                              const Spacer(),

                              // Industry
                              Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 6, vertical: 2),
                                  decoration: BoxDecoration(
                                      color: const Color(0xFF282828),
                                      borderRadius: BorderRadius.circular(4)),
                                  child: Text(template['industry'],
                                      style: GoogleFonts.inter(
                                          fontSize: 8,
                                          fontWeight: FontWeight.w500,
                                          color: const Color(0xFF7B7B7B)))),
                            ]),
                          ]))),
            ])));
  }
}
