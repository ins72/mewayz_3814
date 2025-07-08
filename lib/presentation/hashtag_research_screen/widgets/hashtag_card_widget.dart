import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../widgets/custom_icon_widget.dart';

class HashtagCardWidget extends StatelessWidget {
  final Map<String, dynamic> hashtag;
  final VoidCallback onSave;
  final VoidCallback onAddToSet;
  final VoidCallback onLongPress;

  const HashtagCardWidget({
    Key? key,
    required this.hashtag,
    required this.onSave,
    required this.onAddToSet,
    required this.onLongPress,
  }) : super(key: key);

  Color _getCompetitionColor(String competition) {
    switch (competition.toLowerCase()) {
      case 'low':
        return const Color(0xFF10B981);
      case 'medium':
        return const Color(0xFFF59E0B);
      case 'high':
        return const Color(0xFFEF4444);
      default:
        return const Color(0xFF7B7B7B);
    }
  }

  IconData _getTrendIcon(String trend) {
    switch (trend.toLowerCase()) {
      case 'rising':
        return Icons.trending_up;
      case 'falling':
        return Icons.trending_down;
      case 'stable':
        return Icons.trending_flat;
      default:
        return Icons.trending_flat;
    }
  }

  Color _getTrendColor(String trend) {
    switch (trend.toLowerCase()) {
      case 'rising':
        return const Color(0xFF10B981);
      case 'falling':
        return const Color(0xFFEF4444);
      case 'stable':
        return const Color(0xFF7B7B7B);
      default:
        return const Color(0xFF7B7B7B);
    }
  }

  String _formatNumber(int number) {
    if (number >= 1000000) {
      return '${(number / 1000000).toStringAsFixed(1)}M';
    } else if (number >= 1000) {
      return '${(number / 1000).toStringAsFixed(1)}K';
    }
    return number.toString();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onLongPress: () {
          HapticFeedback.lightImpact();
          onLongPress();
        },
        child: Container(
            margin: const EdgeInsets.only(bottom: 12),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
                color: const Color(0xFF191919),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFF282828), width: 1)),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              // Header Row
              Row(children: [
                // Hashtag
                Expanded(
                    child: Row(children: [
                  Text(hashtag['hashtag'],
                      style: GoogleFonts.inter(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFFF1F1F1))),
                  const SizedBox(width: 8),
                  Icon(_getTrendIcon(hashtag['trend']),
                      size: 16, color: _getTrendColor(hashtag['trend'])),
                ])),

                // Action Buttons
                Row(children: [
                  IconButton(
                    onPressed: () {
                      Clipboard.setData(
                          ClipboardData(text: hashtag['hashtag']));
                      HapticFeedback.lightImpact();
                    },
                    icon: const Icon(Icons.copy),
                  ),
                  IconButton(
                    onPressed: () {
                      HapticFeedback.lightImpact();
                      onSave();
                    },
                    icon: const Icon(Icons.save),
                  ),
                  IconButton(
                    onPressed: () {
                      HapticFeedback.lightImpact();
                      onAddToSet();
                    },
                    icon: const Icon(Icons.add),
                  ),
                ]),
              ]),

              const SizedBox(height: 12),

              // Metrics Row
              Row(children: [
                // Usage Count
                _buildMetric(
                    'Usage', _formatNumber(hashtag['usageCount']), Icons.tag),

                const SizedBox(width: 24),

                // Engagement Rate
                _buildMetric('Engagement', '${hashtag['engagementRate']}%',
                    Icons.favorite),

                const SizedBox(width: 24),

                // Recent Posts
                _buildMetric('Recent', _formatNumber(hashtag['recentPosts']),
                    Icons.schedule),
              ]),

              const SizedBox(height: 12),

              // Competition and Difficulty
              Row(children: [
                // Competition Level
                Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                        color: _getCompetitionColor(hashtag['competition'])
                            .withAlpha(26),
                        borderRadius: BorderRadius.circular(6),
                        border: Border.all(
                            color: _getCompetitionColor(hashtag['competition']),
                            width: 1)),
                    child: Text(
                        '${hashtag['competition'].toUpperCase()} COMPETITION',
                        style: GoogleFonts.inter(
                            fontSize: 10,
                            fontWeight: FontWeight.w500,
                            color:
                                _getCompetitionColor(hashtag['competition'])))),

                const SizedBox(width: 8),

                // Difficulty
                Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                        color: const Color(0xFF282828),
                        borderRadius: BorderRadius.circular(6)),
                    child: Text(hashtag['difficulty'].toUpperCase(),
                        style: GoogleFonts.inter(
                            fontSize: 10,
                            fontWeight: FontWeight.w500,
                            color: const Color(0xFF7B7B7B)))),
              ]),

              const SizedBox(height: 12),

              // Related Hashtags
              if (hashtag['relatedHashtags'] != null &&
                  hashtag['relatedHashtags'].isNotEmpty) ...[
                Text('Related Hashtags',
                    style: GoogleFonts.inter(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: const Color(0xFF7B7B7B))),
                const SizedBox(height: 6),
                Wrap(
                    spacing: 6,
                    runSpacing: 4,
                    children: (hashtag['relatedHashtags'] as List<String>)
                        .take(3)
                        .map((tag) {
                      return Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                              color: const Color(0xFF282828),
                              borderRadius: BorderRadius.circular(6)),
                          child: Text(tag,
                              style: GoogleFonts.inter(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w400,
                                  color: const Color(0xFFF1F1F1))));
                    }).toList()),
              ],
            ])));
  }

  Widget _buildMetric(String label, String value, IconData icon) {
    return Row(children: [
      CustomIconWidget(
          iconName: icon.toString(), size: 14, color: const Color(0xFF7B7B7B)),
      const SizedBox(width: 4),
      Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(value,
            style: GoogleFonts.inter(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: const Color(0xFFF1F1F1))),
        Text(label,
            style: GoogleFonts.inter(
                fontSize: 10,
                fontWeight: FontWeight.w400,
                color: const Color(0xFF7B7B7B))),
      ]),
    ]);
  }
}
