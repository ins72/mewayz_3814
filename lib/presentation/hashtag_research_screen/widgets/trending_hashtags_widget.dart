import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../widgets/custom_icon_widget.dart';

class TrendingHashtagsWidget extends StatelessWidget {
  const TrendingHashtagsWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final trendingHashtags = [
      {'hashtag': '#blackfriday', 'growth': '+245%'},
      {'hashtag': '#cybermonday', 'growth': '+180%'},
      {'hashtag': '#holidaysale', 'growth': '+156%'},
      {'hashtag': '#giftguide', 'growth': '+134%'},
      {'hashtag': '#shoplocal', 'growth': '+89%'},
    ];

    return Container(
        margin: const EdgeInsets.all(16),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
            color: const Color(0xFF191919),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: const Color(0xFF282828), width: 1)),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(children: [
            const CustomIconWidget(
                iconName: 'trending', color: Color(0xFFEF4444), size: 20),
            const SizedBox(width: 8),
            Text('Trending Now',
                style: GoogleFonts.inter(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFFF1F1F1))),
          ]),
          const SizedBox(height: 12),
          SizedBox(
              height: 40,
              child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: trendingHashtags.length,
                  itemBuilder: (context, index) {
                    final hashtag = trendingHashtags[index];
                    return Container(
                        margin: const EdgeInsets.only(right: 8),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                            color: const Color(0xFF282828),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                                color: const Color(0xFF10B981).withAlpha(77),
                                width: 1)),
                        child: Row(mainAxisSize: MainAxisSize.min, children: [
                          Text(hashtag['hashtag']!,
                              style: GoogleFonts.inter(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                  color: const Color(0xFFF1F1F1))),
                          const SizedBox(width: 6),
                          Text(hashtag['growth']!,
                              style: GoogleFonts.inter(
                                  fontSize: 10,
                                  fontWeight: FontWeight.w500,
                                  color: const Color(0xFF10B981))),
                        ]));
                  })),
        ]));
  }
}
