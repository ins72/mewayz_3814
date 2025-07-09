import '../../../core/app_export.dart';

class PendingInvitationsWidget extends StatelessWidget {
  final List<Map<String, dynamic>> invitations;
  final Function(Map<String, dynamic>) onResend;
  final Function(Map<String, dynamic>) onRevoke;

  const PendingInvitationsWidget({
    Key? key,
    required this.invitations,
    required this.onResend,
    required this.onRevoke,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppTheme.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.pending_actions,
                color: AppTheme.secondaryText,
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(
                'Pending Invitations',
                style: GoogleFonts.inter(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: AppTheme.primaryText,
                ),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: AppTheme.warning.withAlpha(51),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  '${invitations.length}',
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: AppTheme.warning,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ...invitations
              .map((invitation) => _buildInvitationCard(invitation))
              .toList(),
        ],
      ),
    );
  }

  Widget _buildInvitationCard(Map<String, dynamic> invitation) {
    final status = invitation['status'] as String;
    final sentDate = invitation['sentDate'] as DateTime;
    final timeAgo = _getTimeAgo(sentDate);

    Color statusColor;
    IconData statusIcon;

    switch (status) {
      case 'pending':
        statusColor = AppTheme.warning;
        statusIcon = Icons.schedule;
        break;
      case 'accepted':
        statusColor = AppTheme.success;
        statusIcon = Icons.check_circle;
        break;
      case 'expired':
        statusColor = AppTheme.error;
        statusIcon = Icons.error;
        break;
      default:
        statusColor = AppTheme.secondaryText;
        statusIcon = Icons.help;
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.primaryBackground,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppTheme.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 16,
                backgroundColor: AppTheme.accent.withAlpha(51),
                child: Text(
                  invitation['email'].toString().substring(0, 1).toUpperCase(),
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: AppTheme.accent,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      invitation['email'],
                      style: GoogleFonts.inter(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: AppTheme.primaryText,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: AppTheme.surface,
                            borderRadius: BorderRadius.circular(4),
                            border: Border.all(color: AppTheme.border),
                          ),
                          child: Text(
                            invitation['role'],
                            style: GoogleFonts.inter(
                              fontSize: 10,
                              color: AppTheme.secondaryText,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Icon(
                          statusIcon,
                          size: 12,
                          color: statusColor,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          status.toUpperCase(),
                          style: GoogleFonts.inter(
                            fontSize: 10,
                            fontWeight: FontWeight.w500,
                            color: statusColor,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              PopupMenuButton<String>(
                icon: Icon(
                  Icons.more_vert,
                  color: AppTheme.secondaryText,
                  size: 18,
                ),
                color: AppTheme.surface,
                onSelected: (value) {
                  if (value == 'resend') {
                    onResend(invitation);
                  } else if (value == 'revoke') {
                    onRevoke(invitation);
                  }
                },
                itemBuilder: (context) => [
                  PopupMenuItem(
                    value: 'resend',
                    child: Row(
                      children: [
                        Icon(Icons.refresh, size: 16, color: AppTheme.accent),
                        const SizedBox(width: 8),
                        Text(
                          'Resend',
                          style: GoogleFonts.inter(
                            fontSize: 14,
                            color: AppTheme.primaryText,
                          ),
                        ),
                      ],
                    ),
                  ),
                  PopupMenuItem(
                    value: 'revoke',
                    child: Row(
                      children: [
                        Icon(Icons.cancel, size: 16, color: AppTheme.error),
                        const SizedBox(width: 8),
                        Text(
                          'Revoke',
                          style: GoogleFonts.inter(
                            fontSize: 14,
                            color: AppTheme.error,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            'Sent $timeAgo',
            style: GoogleFonts.inter(
              fontSize: 12,
              color: AppTheme.secondaryText,
            ),
          ),
        ],
      ),
    );
  }

  String _getTimeAgo(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inDays > 0) {
      return '${difference.inDays} day${difference.inDays == 1 ? '' : 's'} ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} hour${difference.inHours == 1 ? '' : 's'} ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes} minute${difference.inMinutes == 1 ? '' : 's'} ago';
    } else {
      return 'Just now';
    }
  }
}