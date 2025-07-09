import '../../../core/app_export.dart';

class ContactInfoWidget extends StatelessWidget {
  const ContactInfoWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppTheme.border.withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Other Ways to Reach Us',
            style: GoogleFonts.inter(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: AppTheme.primaryText,
            ),
          ),
          const SizedBox(height: 16),

          // Contact methods
          _buildContactMethod(
            'Email Support',
            'support@mewayz.com',
            Icons.email_outlined,
            'Available 24/7',
            true,
          ),
          _buildContactMethod(
            'Phone Support',
            '+1 (555) 123-4567',
            Icons.phone_outlined,
            'Mon-Fri 9 AM - 6 PM EST',
            false,
          ),
          _buildContactMethod(
            'Live Chat',
            'Chat with us now',
            Icons.chat_outlined,
            'Available 24/7',
            true,
          ),
          _buildContactMethod(
            'Community Forum',
            'Visit our community',
            Icons.forum_outlined,
            'Get help from the community',
            true,
          ),

          const SizedBox(height: 16),

          // Social media links
          Text(
            'Follow Us',
            style: GoogleFonts.inter(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: AppTheme.primaryText,
            ),
          ),
          const SizedBox(height: 12),

          Row(
            children: [
              _buildSocialIcon(Icons.facebook, 'Facebook'),
              const SizedBox(width: 16),
              _buildSocialIcon(Icons.facebook,
                  'Twitter'), // Using facebook icon as placeholder
              const SizedBox(width: 16),
              _buildSocialIcon(Icons.facebook,
                  'LinkedIn'), // Using facebook icon as placeholder
              const SizedBox(width: 16),
              _buildSocialIcon(Icons.facebook,
                  'Instagram'), // Using facebook icon as placeholder
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildContactMethod(
    String title,
    String value,
    IconData icon,
    String availability,
    bool isAvailable,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.primaryBackground,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppTheme.border.withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppTheme.accent.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              icon,
              color: AppTheme.accent,
              size: 20,
            ),
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
                    fontWeight: FontWeight.w600,
                    color: AppTheme.primaryText,
                  ),
                ),
                Text(
                  value,
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                    color: AppTheme.accent,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Container(
                      width: 6,
                      height: 6,
                      decoration: BoxDecoration(
                        color:
                            isAvailable ? AppTheme.success : AppTheme.warning,
                        borderRadius: BorderRadius.circular(3),
                      ),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      availability,
                      style: GoogleFonts.inter(
                        fontSize: 11,
                        fontWeight: FontWeight.w400,
                        color: AppTheme.secondaryText,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Icon(
            Icons.arrow_forward_ios,
            color: AppTheme.secondaryText,
            size: 12,
          ),
        ],
      ),
    );
  }

  Widget _buildSocialIcon(IconData icon, String platform) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: AppTheme.primaryBackground,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: AppTheme.border.withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: Icon(
        icon,
        color: AppTheme.accent,
        size: 20,
      ),
    );
  }
}