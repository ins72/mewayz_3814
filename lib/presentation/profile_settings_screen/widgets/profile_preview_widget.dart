import 'package:flutter/material.dart';

import '../../../core/app_export.dart';

class ProfilePreviewWidget extends StatelessWidget {
  final String fullName;
  final String displayName;
  final String bio;
  final Map<String, String> socialLinks;

  const ProfilePreviewWidget({
    Key? key,
    required this.fullName,
    required this.displayName,
    required this.bio,
    required this.socialLinks,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.85,
      decoration: BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: Column(
        children: [
          // Handle bar
          Container(
            margin: EdgeInsets.only(top: 12),
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: AppTheme.border,
              borderRadius: BorderRadius.circular(2),
            ),
          ),

          // Header
          Padding(
            padding: EdgeInsets.all(24),
            child: Row(
              children: [
                Text(
                  'Profile Preview',
                  style: GoogleFonts.inter(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.primaryText,
                  ),
                ),
                Spacer(),
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: Icon(
                    Icons.close,
                    color: AppTheme.primaryText,
                  ),
                ),
              ],
            ),
          ),

          // Preview Content
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                children: [
                  // Profile Card
                  Container(
                    padding: EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: AppTheme.primaryBackground,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: AppTheme.border),
                    ),
                    child: Column(
                      children: [
                        // Avatar
                        Container(
                          width: 80,
                          height: 80,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: AppTheme.border,
                              width: 2,
                            ),
                          ),
                          child: ClipOval(
                            child: CustomImageWidget(
                              imageUrl:
                                  'https://images.unsplash.com/photo-1472099645785-5658abf4ff4e?q=80&w=2940&auto=format&fit=crop',
                              width: 80,
                              height: 80,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),

                        const SizedBox(height: 16),

                        // Name and Display Name
                        Text(
                          fullName.isEmpty ? 'Full Name' : fullName,
                          style: GoogleFonts.inter(
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                            color: AppTheme.primaryText,
                          ),
                        ),

                        const SizedBox(height: 4),

                        Text(
                          displayName.isEmpty ? '@username' : '@$displayName',
                          style: GoogleFonts.inter(
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                            color: AppTheme.secondaryText,
                          ),
                        ),

                        const SizedBox(height: 16),

                        // Bio
                        if (bio.isNotEmpty) ...[
                          Text(
                            bio,
                            style: GoogleFonts.inter(
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                              color: AppTheme.primaryText,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 16),
                        ],

                        // Social Links
                        if (socialLinks.isNotEmpty) ...[
                          const SizedBox(height: 16),
                          Wrap(
                            spacing: 12,
                            runSpacing: 12,
                            children: socialLinks.entries.map((entry) {
                              return _buildSocialLinkChip(
                                  entry.key, entry.value);
                            }).toList(),
                          ),
                        ],
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Profile Stats
                  Container(
                    padding: EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: AppTheme.primaryBackground,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: AppTheme.border),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Profile Stats',
                          style: GoogleFonts.inter(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: AppTheme.primaryText,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Row(
                          children: [
                            _buildStatItem('Workspaces', '3'),
                            _buildStatItem('Projects', '12'),
                            _buildStatItem('Connections', '45'),
                          ],
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Recent Activity
                  Container(
                    padding: EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: AppTheme.primaryBackground,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: AppTheme.border),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Recent Activity',
                          style: GoogleFonts.inter(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: AppTheme.primaryText,
                          ),
                        ),
                        const SizedBox(height: 16),
                        _buildActivityItem(
                          'Updated profile information',
                          '2 hours ago',
                          Icons.person,
                        ),
                        _buildActivityItem(
                          'Created new workspace',
                          '1 day ago',
                          Icons.add_business,
                        ),
                        _buildActivityItem(
                          'Joined team collaboration',
                          '3 days ago',
                          Icons.group_add,
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSocialLinkChip(String platform, String value) {
    IconData icon;
    Color color;

    switch (platform) {
      case 'instagram':
        icon = Icons.camera_alt;
        color = Color(0xFFE4405F);
        break;
      case 'twitter':
        icon = Icons.alternate_email;
        color = Color(0xFF1DA1F2);
        break;
      case 'linkedin':
        icon = Icons.business;
        color = Color(0xFF0077B5);
        break;
      case 'youtube':
        icon = Icons.play_circle_fill;
        color = Color(0xFFFF0000);
        break;
      case 'tiktok':
        icon = Icons.music_note;
        color = Color(0xFF000000);
        break;
      case 'website':
        icon = Icons.language;
        color = AppTheme.accent;
        break;
      default:
        icon = Icons.link;
        color = AppTheme.secondaryText;
    }

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: color.withAlpha(26),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            color: color,
            size: 16,
          ),
          const SizedBox(width: 6),
          Text(
            value,
            style: GoogleFonts.inter(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(String label, String value) {
    return Expanded(
      child: Column(
        children: [
          Text(
            value,
            style: GoogleFonts.inter(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: AppTheme.primaryText,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: GoogleFonts.inter(
              fontSize: 12,
              fontWeight: FontWeight.w400,
              color: AppTheme.secondaryText,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActivityItem(String title, String time, IconData icon) {
    return Padding(
      padding: EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Icon(
            icon,
            color: AppTheme.secondaryText,
            size: 20,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: AppTheme.primaryText,
                  ),
                ),
                Text(
                  time,
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                    color: AppTheme.secondaryText,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}