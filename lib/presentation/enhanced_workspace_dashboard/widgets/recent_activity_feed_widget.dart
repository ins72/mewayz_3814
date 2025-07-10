import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cached_network_image/cached_network_image.dart';

class RecentActivityFeedWidget extends StatelessWidget {
  final List<Map<String, dynamic>> activities;

  const RecentActivityFeedWidget({
    Key? key,
    this.activities = const [],
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // If no activities from database, show empty state
    if (activities.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(32),
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
            Icon(
              Icons.timeline,
              color: const Color(0xFF8E8E93),
              size: 48,
            ),
            const SizedBox(height: 16),
            Text(
              'No Recent Activity',
              style: GoogleFonts.inter(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Activity will appear here as your team works',
              style: GoogleFonts.inter(
                fontSize: 14,
                color: const Color(0xFF8E8E93),
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    }

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
    // Get icon data based on activity type
    final iconData = _getIconDataForActivity(activity);
    
    // Format time from database timestamp
    final timeString = _formatActivityTime(activity);
    
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
                  child: activity['avatar_url'] != null
                    ? CachedNetworkImage(
                        imageUrl: activity['avatar_url'],
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
                      )
                    : Container(
                        color: const Color(0xFF3A3A3C),
                        child: const Icon(
                          Icons.person,
                          color: Color(0xFF8E8E93),
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
                    color: iconData['color'],
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: const Color(0xFF191919),
                      width: 2,
                    ),
                  ),
                  child: Icon(
                    iconData['icon'],
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
                  activity['title'] ?? 'Unknown Activity',
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  activity['description'] ?? '',
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
            timeString,
            style: GoogleFonts.inter(
              fontSize: 12,
              color: const Color(0xFF8E8E93),
            ),
          ),
        ],
      ),
    );
  }

  Map<String, dynamic> _getIconDataForActivity(Map<String, dynamic> activity) {
    final activityType = activity['activity_type'] ?? '';
    
    // Use icon_name and icon_color from database if available
    if (activity['icon_name'] != null && activity['icon_color'] != null) {
      return {
        'icon': _getIconByName(activity['icon_name']),
        'color': _parseColor(activity['icon_color']),
      };
    }
    
    // Fallback to activity type mapping
    switch (activityType) {
      case 'post':
        return {'icon': Icons.schedule, 'color': const Color(0xFF007AFF)};
      case 'lead':
        return {'icon': Icons.person_add, 'color': const Color(0xFF34C759)};
      case 'sale':
        return {'icon': Icons.shopping_cart, 'color': const Color(0xFFFF9500)};
      case 'analytics':
        return {'icon': Icons.bar_chart, 'color': const Color(0xFF5856D6)};
      case 'team':
        return {'icon': Icons.group_add, 'color': const Color(0xFFFF3B30)};
      case 'automation':
        return {'icon': Icons.auto_awesome, 'color': const Color(0xFF32D74B)};
      default:
        return {'icon': Icons.circle, 'color': const Color(0xFF8E8E93)};
    }
  }

  IconData _getIconByName(String iconName) {
    switch (iconName) {
      case 'schedule':
        return Icons.schedule;
      case 'person_add':
        return Icons.person_add;
      case 'shopping_cart':
        return Icons.shopping_cart;
      case 'bar_chart':
        return Icons.bar_chart;
      case 'group_add':
        return Icons.group_add;
      case 'auto_awesome':
        return Icons.auto_awesome;
      default:
        return Icons.circle;
    }
  }

  Color _parseColor(String colorString) {
    try {
      // Remove # if present
      if (colorString.startsWith('#')) {
        colorString = colorString.substring(1);
      }
      
      // Parse hex color
      if (colorString.length == 6) {
        return Color(int.parse('FF$colorString', radix: 16));
      } else if (colorString.length == 8) {
        return Color(int.parse(colorString, radix: 16));
      }
    } catch (e) {
      // Fallback to default color if parsing fails
    }
    
    return const Color(0xFF8E8E93);
  }

  String _formatActivityTime(Map<String, dynamic> activity) {
    try {
      // Handle different time formats from database
      if (activity['time'] != null) {
        // If time is already formatted in minutes
        final timeValue = activity['time'];
        if (timeValue is num) {
          final minutes = timeValue.toInt();
          if (minutes < 60) {
            return '${minutes}m ago';
          } else {
            final hours = (minutes / 60).floor();
            return '${hours}h ago';
          }
        }
      }
      
      // If created_at timestamp is available
      if (activity['created_at'] != null) {
        final createdAt = DateTime.tryParse(activity['created_at'].toString());
        if (createdAt != null) {
          final now = DateTime.now();
          final difference = now.difference(createdAt);
          
          if (difference.inMinutes < 60) {
            return '${difference.inMinutes}m ago';
          } else if (difference.inHours < 24) {
            return '${difference.inHours}h ago';
          } else {
            return '${difference.inDays}d ago';
          }
        }
      }
    } catch (e) {
      // Fallback if parsing fails
    }
    
    return 'Just now';
  }
}