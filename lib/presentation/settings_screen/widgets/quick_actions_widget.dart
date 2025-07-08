import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/app_export.dart';

class QuickActionsWidget extends StatelessWidget {
  const QuickActionsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: () => _showQuickActionsBottomSheet(context),
      backgroundColor: AppTheme.accent,
      child: const Icon(
        Icons.flash_on,
        color: AppTheme.primaryText,
      ),
    );
  }

  void _showQuickActionsBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppTheme.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Quick Actions',
              style: GoogleFonts.inter(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: AppTheme.primaryText,
              ),
            ),
            const SizedBox(height: 20),
            _buildQuickAction(
              context,
              'Change Password',
              Icons.lock_outline,
              () => Navigator.pop(context),
            ),
            _buildQuickAction(
              context,
              'Notification Settings',
              Icons.notifications_outlined,
              () => Navigator.pop(context),
            ),
            _buildQuickAction(
              context,
              'Billing Information',
              Icons.payment_outlined,
              () => Navigator.pop(context),
            ),
            _buildQuickAction(
              context,
              'Export Data',
              Icons.download_outlined,
              () => Navigator.pop(context),
            ),
            _buildQuickAction(
              context,
              'Contact Support',
              Icons.help_outline,
              () {
                Navigator.pop(context);
                Navigator.pushNamed(context, AppRoutes.contactUsScreen);
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickAction(
    BuildContext context,
    String title,
    IconData icon,
    VoidCallback onTap,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
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
              Icon(
                icon,
                color: AppTheme.accent,
                size: 20,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  title,
                  style: GoogleFonts.inter(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: AppTheme.primaryText,
                  ),
                ),
              ),
              Icon(
                Icons.arrow_forward_ios,
                color: AppTheme.secondaryText,
                size: 12,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
