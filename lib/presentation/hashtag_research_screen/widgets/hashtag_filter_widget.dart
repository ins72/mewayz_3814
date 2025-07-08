import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../widgets/custom_icon_widget.dart';

class HashtagFilterWidget extends StatelessWidget {
  final String selectedFilter;
  final String selectedPlatform;
  final Function(String) onFilterChanged;
  final Function(String) onPlatformChanged;

  const HashtagFilterWidget({
    Key? key,
    required this.selectedFilter,
    required this.selectedPlatform,
    required this.onFilterChanged,
    required this.onPlatformChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        color: const Color(0xFF101010),
        child: Column(children: [
          // Platform Selection
          Row(children: [
            Text('Platform: ',
                style: GoogleFonts.inter(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: const Color(0xFF7B7B7B))),
            Expanded(
                child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(children: [
                      _buildPlatformChip('Instagram', Icons.camera_alt),
                      _buildPlatformChip('Twitter', Icons.alternate_email),
                      _buildPlatformChip('TikTok', Icons.music_note),
                      _buildPlatformChip('LinkedIn', Icons.business),
                      _buildPlatformChip('YouTube', Icons.play_circle),
                    ]))),
          ]),

          const SizedBox(height: 12),

          // Filter Chips
          Row(children: [
            Text('Filter: ',
                style: GoogleFonts.inter(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: const Color(0xFF7B7B7B))),
            Expanded(
                child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(children: [
                      _buildFilterChip('All'),
                      _buildFilterChip('Trending'),
                      _buildFilterChip('Niche'),
                      _buildFilterChip('Branded'),
                      _buildFilterChip('Low Competition'),
                      _buildFilterChip('High Engagement'),
                    ]))),
          ]),
        ]));
  }

  Widget _buildPlatformChip(String platform, IconData icon) {
    final isSelected = selectedPlatform == platform;

    return GestureDetector(
      onTap: () => onPlatformChanged(platform),
      child: Container(
        margin: const EdgeInsets.only(right: 8),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: isSelected
              ? const Color(0xFF3B82F6)
              : const Color(0xFF191919),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isSelected
                ? const Color(0xFF3B82F6)
                : const Color(0xFF282828),
            width: 1,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            CustomIconWidget(
              iconName: platform.toLowerCase(),
              size: 14,
              color: isSelected
                  ? const Color(0xFFF1F1F1)
                  : const Color(0xFF7B7B7B),
            ),
            const SizedBox(width: 4),
            Text(
              platform,
              style: GoogleFonts.inter(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: isSelected
                    ? const Color(0xFFF1F1F1)
                    : const Color(0xFF7B7B7B),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterChip(String label) {
    final isSelected = selectedFilter == label;
    
    return GestureDetector(
      onTap: () => onFilterChanged(label),
      child: Container(
        margin: const EdgeInsets.only(right: 8),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: isSelected
              ? const Color(0xFF3B82F6)
              : const Color(0xFF191919),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isSelected
                ? const Color(0xFF3B82F6)
                : const Color(0xFF282828),
            width: 1,
          ),
        ),
        child: Text(
          label,
          style: GoogleFonts.inter(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: isSelected
                ? const Color(0xFFF1F1F1)
                : const Color(0xFF7B7B7B),
          ),
        ),
      ),
    );
  }
}