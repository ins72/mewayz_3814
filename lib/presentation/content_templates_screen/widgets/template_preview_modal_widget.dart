import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../widgets/custom_icon_widget.dart';
import '../../../widgets/custom_image_widget.dart';

class TemplatePreviewModalWidget extends StatelessWidget {
  final Map<String, dynamic> template;
  final VoidCallback onUse;
  final VoidCallback onFavorite;

  const TemplatePreviewModalWidget({
    Key? key,
    required this.template,
    required this.onUse,
    required this.onFavorite,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        height: MediaQuery.of(context).size.height * 0.8,
        decoration: const BoxDecoration(
            color: Color(0xFF191919),
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20), topRight: Radius.circular(20))),
        child: Column(children: [
          // Header
          Container(
              padding: const EdgeInsets.all(16),
              child: Row(children: [
                Expanded(
                    child: Text(template['title'],
                        style: GoogleFonts.inter(
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                            color: const Color(0xFFF1F1F1)))),
                IconButton(
                    onPressed: onFavorite, icon: const Icon(Icons.favorite)),
                IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.close)),
              ])),

          // Content
          Expanded(
              child: SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Template Preview
                        ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: CustomImageWidget(
                                width: double.infinity,
                                height: 300,
                                fit: BoxFit.cover,
                                imageUrl: template['imageUrl'] ?? '')),

                        const SizedBox(height: 16),

                        // Description
                        Text('Description',
                            style: GoogleFonts.inter(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: const Color(0xFFF1F1F1))),
                        const SizedBox(height: 8),
                        Text(template['description'],
                            style: GoogleFonts.inter(
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                                color: const Color(0xFF7B7B7B))),

                        const SizedBox(height: 16),

                        // Metrics
                        Row(children: [
                          Expanded(
                              child: _buildMetricCard(
                                  'Engagement',
                                  template['engagementScore'].toString(),
                                  Icons.star,
                                  const Color(0xFFF59E0B))),
                          const SizedBox(width: 12),
                          Expanded(
                              child: _buildMetricCard(
                                  'Usage',
                                  '${(template['usageCount'] / 1000).toStringAsFixed(1)}K',
                                  Icons.download,
                                  const Color(0xFF3B82F6))),
                        ]),

                        const SizedBox(height: 16),

                        // Platform Support
                        Text('Platform Support',
                            style: GoogleFonts.inter(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: const Color(0xFFF1F1F1))),
                        const SizedBox(height: 8),
                        Wrap(
                            spacing: 8,
                            runSpacing: 8,
                            children: (template['platform'] as List<String>)
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
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 12, vertical: 8),
                                  decoration: BoxDecoration(
                                      color: const Color(0xFF282828),
                                      borderRadius: BorderRadius.circular(8)),
                                  child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        CustomIconWidget(
                                            iconName: platform.toLowerCase(),
                                            color: const Color(0xFFF1F1F1),
                                            size: 16),
                                        const SizedBox(width: 6),
                                        Text(platform,
                                            style: GoogleFonts.inter(
                                                fontSize: 12,
                                                fontWeight: FontWeight.w500,
                                                color:
                                                    const Color(0xFFF1F1F1))),
                                      ]));
                            }).toList()),

                        const SizedBox(height: 16),

                        // Color Palette
                        Text('Color Palette',
                            style: GoogleFonts.inter(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: const Color(0xFFF1F1F1))),
                        const SizedBox(height: 8),
                        Row(
                            children: (template['colors'] as List<String>)
                                .map((color) {
                          return Container(
                              width: 40,
                              height: 40,
                              margin: const EdgeInsets.only(right: 8),
                              decoration: BoxDecoration(
                                  color: Color(
                                      int.parse(color.replaceAll('#', '0xFF'))),
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                      color: const Color(0xFF282828),
                                      width: 2)));
                        }).toList()),

                        const SizedBox(height: 16),

                        // Tags
                        Text('Tags',
                            style: GoogleFonts.inter(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: const Color(0xFFF1F1F1))),
                        const SizedBox(height: 8),
                        Wrap(
                            spacing: 6,
                            runSpacing: 6,
                            children:
                                (template['tags'] as List<String>).map((tag) {
                              return Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8, vertical: 4),
                                  decoration: BoxDecoration(
                                      color: const Color(0xFF282828),
                                      borderRadius: BorderRadius.circular(6)),
                                  child: Text('#$tag',
                                      style: GoogleFonts.inter(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w400,
                                          color: const Color(0xFFF1F1F1))));
                            }).toList()),
                      ]))),

          // Action Buttons
          Container(
              padding: const EdgeInsets.all(16),
              child: Row(children: [
                Expanded(
                    child: OutlinedButton(
                        onPressed: () {
                          // Customize template
                        },
                        style: OutlinedButton.styleFrom(
                            side: const BorderSide(
                                color: Color(0xFF282828), width: 1),
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12))),
                        child: Text('Customize',
                            style: GoogleFonts.inter(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                color: const Color(0xFFF1F1F1))))),
                const SizedBox(width: 12),
                Expanded(
                    child: ElevatedButton(
                        onPressed: onUse,
                        style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFFDFDFD),
                            foregroundColor: const Color(0xFF141414),
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12))),
                        child: Text('Use Template',
                            style: GoogleFonts.inter(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                color: const Color(0xFF141414))))),
              ])),
        ]));
  }

  Widget _buildMetricCard(
      String label, String value, IconData icon, Color color) {
    return Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
            color: const Color(0xFF282828),
            borderRadius: BorderRadius.circular(12)),
        child: Column(children: [
          CustomIconWidget(
              iconName: label.toLowerCase(), color: color, size: 24),
          const SizedBox(height: 8),
          Text(value,
              style: GoogleFonts.inter(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFFF1F1F1))),
          const SizedBox(height: 4),
          Text(label,
              style: GoogleFonts.inter(
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                  color: const Color(0xFF7B7B7B))),
        ]));
  }
}
