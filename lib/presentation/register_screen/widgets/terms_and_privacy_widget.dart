
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
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Terms of Service Checkbox
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Checkbox(
              value: acceptTerms,
              onChanged: onTermsChanged,
              activeColor: AppTheme.accent,
              checkColor: AppTheme.primaryAction,
              side: BorderSide(
                color: acceptTerms ? AppTheme.accent : AppTheme.border,
                width: 2,
              ),
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
                      style: AppTheme.darkTheme.textTheme.bodyMedium?.copyWith(
                        color: AppTheme.secondaryText,
                      ),
                      children: [
                        WidgetSpan(
                          child: GestureDetector(
                            onTap: onTermsOfServiceTap,
                            child: Text(
                              'Terms of Service',
                              style: AppTheme.darkTheme.textTheme.bodyMedium?.copyWith(
                                color: AppTheme.accent,
                                decoration: TextDecoration.underline,
                                fontWeight: FontWeight.w500,
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
        
        SizedBox(height: 2.h),
        
        // Privacy Policy Checkbox
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Checkbox(
              value: acceptPrivacy,
              onChanged: onPrivacyChanged,
              activeColor: AppTheme.accent,
              checkColor: AppTheme.primaryAction,
              side: BorderSide(
                color: acceptPrivacy ? AppTheme.accent : AppTheme.border,
                width: 2,
              ),
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
                      style: AppTheme.darkTheme.textTheme.bodyMedium?.copyWith(
                        color: AppTheme.secondaryText,
                      ),
                      children: [
                        WidgetSpan(
                          child: GestureDetector(
                            onTap: onPrivacyPolicyTap,
                            child: Text(
                              'Privacy Policy',
                              style: AppTheme.darkTheme.textTheme.bodyMedium?.copyWith(
                                color: AppTheme.accent,
                                decoration: TextDecoration.underline,
                                fontWeight: FontWeight.w500,
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

        // Combined Terms and Privacy Agreement (Optional)
        SizedBox(height: 2.h),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Checkbox(
              value: acceptTerms && acceptPrivacy,
              onChanged: (value) {
                // If checking both at once
                if (value == true) {
                  onTermsChanged(true);
                  onPrivacyChanged(true);
                } else {
                  onTermsChanged(false);
                  onPrivacyChanged(false);
                }
              },
              activeColor: AppTheme.accent,
              checkColor: AppTheme.primaryAction,
              side: BorderSide(
                color: (acceptTerms && acceptPrivacy) ? AppTheme.accent : AppTheme.border,
                width: 2,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(4),
              ),
            ),
            Expanded(
              child: GestureDetector(
                onTap: () {
                  final shouldAcceptAll = !(acceptTerms && acceptPrivacy);
                  onTermsChanged(shouldAcceptAll);
                  onPrivacyChanged(shouldAcceptAll);
                },
                child: Padding(
                  padding: EdgeInsets.only(top: 3.w),
                  child: RichText(
                    text: TextSpan(
                      text: 'I agree to both ',
                      style: AppTheme.darkTheme.textTheme.bodyMedium?.copyWith(
                        color: AppTheme.secondaryText,
                      ),
                      children: [
                        WidgetSpan(
                          child: GestureDetector(
                            onTap: onTermsOfServiceTap,
                            child: Text(
                              'Terms of Service',
                              style: AppTheme.darkTheme.textTheme.bodyMedium?.copyWith(
                                color: AppTheme.accent,
                                decoration: TextDecoration.underline,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ),
                        TextSpan(
                          text: ' and ',
                          style: AppTheme.darkTheme.textTheme.bodyMedium?.copyWith(
                            color: AppTheme.secondaryText,
                          ),
                        ),
                        WidgetSpan(
                          child: GestureDetector(
                            onTap: onPrivacyPolicyTap,
                            child: Text(
                              'Privacy Policy',
                              style: AppTheme.darkTheme.textTheme.bodyMedium?.copyWith(
                                color: AppTheme.accent,
                                decoration: TextDecoration.underline,
                                fontWeight: FontWeight.w500,
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

        // Validation Message
        if (!acceptTerms || !acceptPrivacy) ...[
          SizedBox(height: 2.h),
          Container(
            padding: EdgeInsets.all(3.w),
            decoration: BoxDecoration(
              color: AppTheme.error.withAlpha(26),
              borderRadius: BorderRadius.circular(2.w),
              border: Border.all(
                color: AppTheme.error.withAlpha(77),
              ),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.info_outline,
                  color: AppTheme.error,
                  size: 16,
                ),
                SizedBox(width: 2.w),
                Expanded(
                  child: Text(
                    'Please accept both Terms of Service and Privacy Policy to continue',
                    style: AppTheme.darkTheme.textTheme.bodySmall?.copyWith(
                      color: AppTheme.error,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],

        // Success Message
        if (acceptTerms && acceptPrivacy) ...[
          SizedBox(height: 2.h),
          Container(
            padding: EdgeInsets.all(3.w),
            decoration: BoxDecoration(
              color: AppTheme.success.withAlpha(26),
              borderRadius: BorderRadius.circular(2.w),
              border: Border.all(
                color: AppTheme.success.withAlpha(77),
              ),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.check_circle,
                  color: AppTheme.success,
                  size: 16,
                ),
                SizedBox(width: 2.w),
                Expanded(
                  child: Text(
                    'Thank you for accepting our Terms of Service and Privacy Policy',
                    style: AppTheme.darkTheme.textTheme.bodySmall?.copyWith(
                      color: AppTheme.success,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }
}