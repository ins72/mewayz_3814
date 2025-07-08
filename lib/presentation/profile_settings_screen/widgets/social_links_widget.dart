import 'package:flutter/material.dart';

import '../../../core/app_export.dart';

class SocialLinksWidget extends StatelessWidget {
  final Map<String, String> socialLinks;
  final ValueChanged<Map<String, String>> onLinksChanged;

  const SocialLinksWidget({
    Key? key,
    required this.socialLinks,
    required this.onLinksChanged,
  }) : super(key: key);

  void _updateLink(String platform, String value) {
    final updatedLinks = Map<String, String>.from(socialLinks);
    if (value.trim().isEmpty) {
      updatedLinks.remove(platform);
    } else {
      updatedLinks[platform] = value.trim();
    }
    onLinksChanged(updatedLinks);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(24),
      margin: EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppTheme.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Social Media Links',
            style: GoogleFonts.inter(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: AppTheme.primaryText,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Connect your social media accounts to enhance your profile',
            style: GoogleFonts.inter(
              fontSize: 14,
              fontWeight: FontWeight.w400,
              color: AppTheme.secondaryText,
            ),
          ),
          const SizedBox(height: 24),
          _buildSocialLinkField(
            platform: 'instagram',
            label: 'Instagram',
            icon: Icons.camera_alt,
            color: Color(0xFFE4405F),
            placeholder: '@username',
            validator: (value) {
              if (value != null && value.isNotEmpty && !value.startsWith('@')) {
                return 'Instagram handle must start with @';
              }
              return null;
            },
          ),
          const SizedBox(height: 20),
          _buildSocialLinkField(
            platform: 'twitter',
            label: 'Twitter',
            icon: Icons.alternate_email,
            color: Color(0xFF1DA1F2),
            placeholder: '@username',
            validator: (value) {
              if (value != null && value.isNotEmpty && !value.startsWith('@')) {
                return 'Twitter handle must start with @';
              }
              return null;
            },
          ),
          const SizedBox(height: 20),
          _buildSocialLinkField(
            platform: 'linkedin',
            label: 'LinkedIn',
            icon: Icons.business,
            color: Color(0xFF0077B5),
            placeholder: 'your-profile-name',
            validator: (value) {
              if (value != null && value.isNotEmpty && value.contains(' ')) {
                return 'LinkedIn profile name cannot contain spaces';
              }
              return null;
            },
          ),
          const SizedBox(height: 20),
          _buildSocialLinkField(
            platform: 'youtube',
            label: 'YouTube',
            icon: Icons.play_circle_fill,
            color: Color(0xFFFF0000),
            placeholder: 'channel-name',
            validator: (value) {
              if (value != null && value.isNotEmpty && value.contains(' ')) {
                return 'YouTube channel name cannot contain spaces';
              }
              return null;
            },
          ),
          const SizedBox(height: 20),
          _buildSocialLinkField(
            platform: 'tiktok',
            label: 'TikTok',
            icon: Icons.music_note,
            color: Color(0xFF000000),
            placeholder: '@username',
            validator: (value) {
              if (value != null && value.isNotEmpty && !value.startsWith('@')) {
                return 'TikTok handle must start with @';
              }
              return null;
            },
          ),
          const SizedBox(height: 20),
          _buildSocialLinkField(
            platform: 'website',
            label: 'Website',
            icon: Icons.language,
            color: AppTheme.accent,
            placeholder: 'https://yourwebsite.com',
            validator: (value) {
              if (value != null && value.isNotEmpty) {
                if (!RegExp(r'^https?://').hasMatch(value)) {
                  return 'Website URL must start with http:// or https://';
                }
              }
              return null;
            },
          ),
        ],
      ),
    );
  }

  Widget _buildSocialLinkField({
    required String platform,
    required String label,
    required IconData icon,
    required Color color,
    required String placeholder,
    String? Function(String?)? validator,
  }) {
    final controller = TextEditingController(text: socialLinks[platform] ?? '');

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              icon,
              color: color,
              size: 20,
            ),
            const SizedBox(width: 8),
            Text(
              label,
              style: GoogleFonts.inter(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: AppTheme.primaryText,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          style: GoogleFonts.inter(
            fontSize: 16,
            fontWeight: FontWeight.w400,
            color: AppTheme.primaryText,
          ),
          validator: validator,
          onChanged: (value) => _updateLink(platform, value),
          decoration: InputDecoration(
            hintText: placeholder,
            hintStyle: GoogleFonts.inter(
              fontSize: 16,
              fontWeight: FontWeight.w400,
              color: AppTheme.secondaryText.withAlpha(179),
            ),
            fillColor: AppTheme.primaryBackground,
            filled: true,
            contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: AppTheme.border),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: AppTheme.border),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: color, width: 2),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: AppTheme.error),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: AppTheme.error, width: 2),
            ),
          ),
        ),
      ],
    );
  }
}