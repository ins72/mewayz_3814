
import '../../../core/app_export.dart';

class TermsAndPrivacyWidget extends StatelessWidget {
  final bool acceptTerms;
  final bool acceptPrivacy;
  final ValueChanged<bool?> onTermsChanged;
  final ValueChanged<bool?> onPrivacyChanged;
  final VoidCallback onTermsOfServiceTap;
  final VoidCallback onPrivacyPolicyTap;

  const TermsAndPrivacyWidget({
    Key? key,
    required this.acceptTerms,
    required this.acceptPrivacy,
    required this.onTermsChanged,
    required this.onPrivacyChanged,
    required this.onTermsOfServiceTap,
    required this.onPrivacyPolicyTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Checkbox(
              value: acceptTerms,
              onChanged: onTermsChanged,
              activeColor: AppTheme.accent,
              checkColor: AppTheme.primaryAction,
              side: const BorderSide(color: AppTheme.border, width: 2),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(4),
              ),
            ),
            Expanded(
              child: GestureDetector(
                onTap: () => onTermsChanged(!acceptTerms),
                child: Padding(
                  padding: EdgeInsets.only(top: 3.w),
                  child: RichText(
                    text: TextSpan(
                      text: 'I agree to the ',
                      style: AppTheme.darkTheme.textTheme.bodySmall?.copyWith(
                        color: AppTheme.secondaryText,
                      ),
                      children: [
                        WidgetSpan(
                          child: GestureDetector(
                            onTap: onTermsOfServiceTap,
                            child: Text(
                              'Terms of Service',
                              style: AppTheme.darkTheme.textTheme.bodySmall
                                  ?.copyWith(
                                color: AppTheme.accent,
                                decoration: TextDecoration.underline,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 1.h),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Checkbox(
              value: acceptPrivacy,
              onChanged: onPrivacyChanged,
              activeColor: AppTheme.accent,
              checkColor: AppTheme.primaryAction,
              side: const BorderSide(color: AppTheme.border, width: 2),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(4),
              ),
            ),
            Expanded(
              child: GestureDetector(
                onTap: () => onPrivacyChanged(!acceptPrivacy),
                child: Padding(
                  padding: EdgeInsets.only(top: 3.w),
                  child: RichText(
                    text: TextSpan(
                      text: 'I agree to the ',
                      style: AppTheme.darkTheme.textTheme.bodySmall?.copyWith(
                        color: AppTheme.secondaryText,
                      ),
                      children: [
                        WidgetSpan(
                          child: GestureDetector(
                            onTap: onPrivacyPolicyTap,
                            child: Text(
                              'Privacy Policy',
                              style: AppTheme.darkTheme.textTheme.bodySmall
                                  ?.copyWith(
                                color: AppTheme.accent,
                                decoration: TextDecoration.underline,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}