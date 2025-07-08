import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../widgets/custom_icon_widget.dart';

class HashtagSetsWidget extends StatelessWidget {
  final List<Map<String, dynamic>> savedSets;
  final VoidCallback onCreateSet;
  final Function(Map<String, dynamic>) onEditSet;

  const HashtagSetsWidget({
    Key? key,
    required this.savedSets,
    required this.onCreateSet,
    required this.onEditSet,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          // Header with Create Button
          Row(children: [
            Expanded(
                child: Text('Hashtag Sets',
                    style: GoogleFonts.inter(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFFF1F1F1)))),
            ElevatedButton.icon(
                onPressed: onCreateSet,
                label: Text('Create Set',
                    style: GoogleFonts.inter(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: const Color(0xFF141414))),
                style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFFDFDFD),
                    foregroundColor: const Color(0xFF141414),
                    padding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8)))),
          ]),

          const SizedBox(height: 16),

          // Sets List
          if (savedSets.isEmpty)
            _buildEmptyState()
          else
            ...savedSets.map((set) => _buildSetCard(set)).toList(),
        ]));
  }

  Widget _buildEmptyState() {
    return Container(
        padding: const EdgeInsets.all(32),
        decoration: BoxDecoration(
            color: const Color(0xFF191919),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: const Color(0xFF282828), width: 1)),
        child: Column(children: [
          const CustomIconWidget(
              iconName: 'hashtag', color: Color(0xFF7B7B7B), size: 48),
          const SizedBox(height: 16),
          Text('No Hashtag Sets Yet',
              style: GoogleFonts.inter(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: const Color(0xFFF1F1F1))),
          const SizedBox(height: 8),
          Text(
              'Create your first hashtag set to organize and reuse your favorite hashtags for different campaigns.',
              textAlign: TextAlign.center,
              style: GoogleFonts.inter(
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  color: const Color(0xFF7B7B7B))),
        ]));
  }

  Widget _buildSetCard(Map<String, dynamic> set) {
    return Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
            color: const Color(0xFF191919),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: const Color(0xFF282828), width: 1)),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          // Header
          Row(children: [
            Expanded(
                child: Text(set['name'],
                    style: GoogleFonts.inter(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFFF1F1F1)))),
            PopupMenuButton<String>(
                color: const Color(0xFF191919),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                    side: const BorderSide(color: Color(0xFF282828), width: 1)),
                itemBuilder: (context) => [
                      PopupMenuItem(
                          value: 'edit',
                          child: Row(children: [
                            const CustomIconWidget(
                                iconName: 'edit',
                                color: Color(0xFFF1F1F1),
                                size: 16),
                            const SizedBox(width: 8),
                            Text('Edit',
                                style: GoogleFonts.inter(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w400,
                                    color: const Color(0xFFF1F1F1))),
                          ])),
                      PopupMenuItem(
                          value: 'duplicate',
                          child: Row(children: [
                            const CustomIconWidget(
                                iconName: 'duplicate',
                                color: Color(0xFFF1F1F1),
                                size: 16),
                            const SizedBox(width: 8),
                            Text('Duplicate',
                                style: GoogleFonts.inter(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w400,
                                    color: const Color(0xFFF1F1F1))),
                          ])),
                      PopupMenuItem(
                          value: 'delete',
                          child: Row(children: [
                            const CustomIconWidget(
                                iconName: 'delete',
                                color: Color(0xFFEF4444),
                                size: 16),
                            const SizedBox(width: 8),
                            Text('Delete',
                                style: GoogleFonts.inter(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w400,
                                    color: const Color(0xFFEF4444))),
                          ])),
                    ],
                onSelected: (value) {
                  switch (value) {
                    case 'edit':
                      onEditSet(set);
                      break;
                    case 'duplicate':
                      // Handle duplicate
                      break;
                    case 'delete':
                      // Handle delete
                      break;
                  }
                },
                child: const CustomIconWidget(
                    iconName: 'menu', color: Color(0xFF7B7B7B), size: 20)),
          ]),

          const SizedBox(height: 12),

          // Hashtags
          Wrap(
              spacing: 6,
              runSpacing: 6,
              children: (set['hashtags'] as List<String>).map((hashtag) {
                return Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                        color: const Color(0xFF282828),
                        borderRadius: BorderRadius.circular(6)),
                    child: Text(hashtag,
                        style: GoogleFonts.inter(
                            fontSize: 12,
                            fontWeight: FontWeight.w400,
                            color: const Color(0xFFF1F1F1))));
              }).toList()),

          const SizedBox(height: 12),

          // Footer
          Row(children: [
            const CustomIconWidget(
                iconName: 'clock', color: Color(0xFF7B7B7B), size: 14),
            const SizedBox(width: 4),
            Text('Last used: ${set['lastUsed']}',
                style: GoogleFonts.inter(
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                    color: const Color(0xFF7B7B7B))),
            const Spacer(),
            Text('${(set['hashtags'] as List).length} hashtags',
                style: GoogleFonts.inter(
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                    color: const Color(0xFF7B7B7B))),
          ]),
        ]));
  }
}
