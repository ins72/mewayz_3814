import '../../../core/app_export.dart';

class CustomMessageWidget extends StatelessWidget {
  final TextEditingController controller;
  final ValueChanged<String> onChanged;

  const CustomMessageWidget({
    Key? key,
    required this.controller,
    required this.onChanged,
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
                Icons.message_outlined,
                color: AppTheme.secondaryText,
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(
                'Custom Message',
                style: GoogleFonts.inter(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: AppTheme.primaryText,
                ),
              ),
              const Spacer(),
              Text(
                'Optional',
                style: GoogleFonts.inter(
                  fontSize: 12,
                  color: AppTheme.secondaryText,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          TextFormField(
            controller: controller,
            onChanged: onChanged,
            maxLines: 4,
            maxLength: 500,
            style: GoogleFonts.inter(
              fontSize: 14,
              color: AppTheme.primaryText,
            ),
            decoration: InputDecoration(
              hintText:
                  'Add a personal message to your invitation...\n\nExample: "Welcome to our team! We\'re excited to have you join us and look forward to working together."',
              hintStyle: GoogleFonts.inter(
                fontSize: 14,
                color: AppTheme.secondaryText,
              ),
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
                borderSide: const BorderSide(color: AppTheme.accent, width: 2),
              ),
              fillColor: AppTheme.primaryBackground,
              filled: true,
              contentPadding: const EdgeInsets.all(16),
              counterStyle: GoogleFonts.inter(
                fontSize: 12,
                color: AppTheme.secondaryText,
              ),
            ),
          ),
        ],
      ),
    );
  }
}