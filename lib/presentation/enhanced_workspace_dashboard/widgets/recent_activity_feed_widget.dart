import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cached_network_image/cached_network_image.dart';

class RecentActivityFeedWidget extends StatelessWidget {
  const RecentActivityFeedWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final activities = [
      {
        'type': 'post',
        'title': 'New Instagram post scheduled',
        'description': 'Product launch announcement for 2:00 PM',
        'time': '2 minutes ago',
        'avatar': 'https://images.unsplash.com/photo-1494790108755-2616b612b47c?w=150&h=150&fit=crop&crop=face',
        'icon': Icons.schedule,
        'color': const Color(0xFF007AFF),
      },
      {
        'type': 'lead',
        'title': 'New lead generated',
        'description': 'Sarah Johnson from Instagram campaign',
        'time': '15 minutes ago',
        'avatar': 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=150&h=150&fit=crop&crop=face',
        'icon': Icons.person_add,
        'color': const Color(0xFF34C759),
      },
      {
        'type': 'sale',
        'title': 'Course purchase completed',
        'description': 'Digital Marketing Masterclass - \$299',
        'time': '1 hour ago',
        'avatar': 'https://images.unsplash.com/photo-1573496359142-b8d87734a5a2?w=150&h=150&fit=crop&crop=face',
        'icon': Icons.shopping_cart,
        'color': const Color(0xFFFF9500),
      },
      {
        'type': 'analytics',
        'title': 'Weekly report ready',
        'description': 'Social media performance summary',
        'time': '2 hours ago',
        'avatar': 'https://images.unsplash.com/photo-1472099645785-5658abf4ff4e?w=150&h=150&fit=crop&crop=face',
        'icon': Icons.bar_chart,
        'color': const Color(0xFF5856D6),
      },
      {
        'type': 'team',
        'title': 'Team member joined',
        'description': 'Alex Rodriguez added to Marketing team',
        'time': '3 hours ago',
        'avatar': 'https://images.unsplash.com/photo-1519244703995-f4e0f30006d5?w=150&h=150&fit=crop&crop=face',
        'icon': Icons.group_add,
        'color': const Color(0xFFFF3B30),
      },
      {
        'type': 'automation',
        'title': 'Email sequence completed',
        'description': 'Welcome series sent to 47 new subscribers',
        'time': '4 hours ago',
        'avatar': 'https://images.unsplash.com/photo-1438761681033-6461ffad8d80?w=150&h=150&fit=crop&crop=face',
        'icon': Icons.auto_awesome,
        'color': const Color(0xFF32D74B),
      },
    ];

    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF191919),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: const Color(0xFF2C2C2E),
          width: 1,
        ),
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Recent Activity',
                  style: GoogleFonts.inter(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
                Text(
                  'View All',
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    color: const Color(0xFF007AFF),
                  ),
                ),
              ],
            ),
          ),
          const Divider(color: Color(0xFF2C2C2E), height: 1),
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: activities.length,
            separatorBuilder: (context, index) => const Divider(
              color: Color(0xFF2C2C2E),
              height: 1,
            ),
            itemBuilder: (context, index) {
              final activity = activities[index];
              return _buildActivityItem(activity);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildActivityItem(Map<String, dynamic> activity) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Stack(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(
                    color: const Color(0xFF2C2C2E),
                    width: 2,
                  ),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(22),
                  child: CachedNetworkImage(
                    imageUrl: activity['avatar'],
                    fit: BoxFit.cover,
                    placeholder: (context, url) => Container(
                      color: const Color(0xFF3A3A3C),
                      child: const Icon(
                        Icons.person,
                        color: Color(0xFF8E8E93),
                      ),
                    ),
                    errorWidget: (context, url, error) => Container(
                      color: const Color(0xFF3A3A3C),
                      child: const Icon(
                        Icons.person,
                        color: Color(0xFF8E8E93),
                      ),
                    ),
                  ),
                ),
              ),
              Positioned(
                bottom: 0,
                right: 0,
                child: Container(
                  width: 20,
                  height: 20,
                  decoration: BoxDecoration(
                    color: activity['color'],
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: const Color(0xFF191919),
                      width: 2,
                    ),
                  ),
                  child: Icon(
                    activity['icon'],
                    size: 12,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  activity['title'],
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  activity['description'],
                  style: GoogleFonts.inter(
                    fontSize: 13,
                    color: const Color(0xFF8E8E93),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Text(
            activity['time'],
            style: GoogleFonts.inter(
              fontSize: 12,
              color: const Color(0xFF8E8E93),
            ),
          ),
        ],
      ),
    );
  }
}