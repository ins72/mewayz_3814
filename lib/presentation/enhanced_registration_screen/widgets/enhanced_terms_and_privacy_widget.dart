
import '../../../core/app_export.dart';

class EnhancedTermsAndPrivacyWidget extends StatelessWidget {
  final bool acceptTerms;
  final bool acceptPrivacy;
  final ValueChanged<bool?> onTermsChanged;
  final ValueChanged<bool?> onPrivacyChanged;
  final VoidCallback onTermsOfServiceTap;
  final VoidCallback onPrivacyPolicyTap;

  const EnhancedTermsAndPrivacyWidget({
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
    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: const Color(0xFF191919),
        borderRadius: BorderRadius.circular(3.w),
        border: Border.all(
          color: const Color(0xFF282828),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(2.w),
                decoration: BoxDecoration(
                  color: const Color(0xFF007AFF).withAlpha(26),
                  borderRadius: BorderRadius.circular(2.w),
                ),
                child: const Icon(
                  Icons.security,
                  color: Color(0xFF007AFF),
                  size: 20,
                ),
              ),
              SizedBox(width: 3.w),
              Text(
                'Privacy & Terms Agreement',
                style: GoogleFonts.inter(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          
          SizedBox(height: 4.h),
          
          // Terms of Service Checkbox
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: 6.w,
                height: 6.w,
                child: Transform.scale(
                  scale: 1.2,
                  child: Checkbox(
                    value: acceptTerms,
                    onChanged: onTermsChanged,
                    activeColor: const Color(0xFF007AFF),
                    checkColor: Colors.white,
                    side: BorderSide(
                      color: acceptTerms ? const Color(0xFF007AFF) : const Color(0xFF8E8E93),
                      width: 2,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ),
              ),
              SizedBox(width: 3.w),
              Expanded(
                child: GestureDetector(
                  onTap: () => onTermsChanged(!acceptTerms),
                  child: Padding(
                    padding: EdgeInsets.only(top: 0.5.h),
                    child: RichText(
                      text: TextSpan(
                        text: 'I have read and agree to the ',
                        style: GoogleFonts.inter(
                          fontSize: 14.sp,
                          color: const Color(0xFF8E8E93),
                        ),
                        children: [
                          WidgetSpan(
                            child: GestureDetector(
                              onTap: onTermsOfServiceTap,
                              child: Text(
                                'Terms of Service',
                                style: GoogleFonts.inter(
                                  fontSize: 14.sp,
                                  color: const Color(0xFF007AFF),
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
          
          SizedBox(height: 3.h),
          
          // Privacy Policy Checkbox
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: 6.w,
                height: 6.w,
                child: Transform.scale(
                  scale: 1.2,
                  child: Checkbox(
                    value: acceptPrivacy,
                    onChanged: onPrivacyChanged,
                    activeColor: const Color(0xFF007AFF),
                    checkColor: Colors.white,
                    side: BorderSide(
                      color: acceptPrivacy ? const Color(0xFF007AFF) : const Color(0xFF8E8E93),
                      width: 2,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ),
              ),
              SizedBox(width: 3.w),
              Expanded(
                child: GestureDetector(
                  onTap: () => onPrivacyChanged(!acceptPrivacy),
                  child: Padding(
                    padding: EdgeInsets.only(top: 0.5.h),
                    child: RichText(
                      text: TextSpan(
                        text: 'I have read and agree to the ',
                        style: GoogleFonts.inter(
                          fontSize: 14.sp,
                          color: const Color(0xFF8E8E93),
                        ),
                        children: [
                          WidgetSpan(
                            child: GestureDetector(
                              onTap: onPrivacyPolicyTap,
                              child: Text(
                                'Privacy Policy',
                                style: GoogleFonts.inter(
                                  fontSize: 14.sp,
                                  color: const Color(0xFF007AFF),
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

          SizedBox(height: 3.h),

          // Enhanced combined acceptance checkbox
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: 6.w,
                height: 6.w,
                child: Transform.scale(
                  scale: 1.2,
                  child: Checkbox(
                    value: acceptTerms && acceptPrivacy,
                    onChanged: (value) {
                      if (value == true) {
                        onTermsChanged(true);
                        onPrivacyChanged(true);
                      } else {
                        onTermsChanged(false);
                        onPrivacyChanged(false);
                      }
                    },
                    activeColor: const Color(0xFF007AFF),
                    checkColor: Colors.white,
                    side: BorderSide(
                      color: (acceptTerms && acceptPrivacy) ? const Color(0xFF007AFF) : const Color(0xFF8E8E93),
                      width: 2,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ),
              ),
              SizedBox(width: 3.w),
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    final shouldAcceptAll = !(acceptTerms && acceptPrivacy);
                    onTermsChanged(shouldAcceptAll);
                    onPrivacyChanged(shouldAcceptAll);
                  },
                  child: Padding(
                    padding: EdgeInsets.only(top: 0.5.h),
                    child: RichText(
                      text: TextSpan(
                        text: 'I accept all agreements (both ',
                        style: GoogleFonts.inter(
                          fontSize: 14.sp,
                          color: const Color(0xFF8E8E93),
                        ),
                        children: [
                          WidgetSpan(
                            child: GestureDetector(
                              onTap: onTermsOfServiceTap,
                              child: Text(
                                'Terms',
                                style: GoogleFonts.inter(
                                  fontSize: 14.sp,
                                  color: const Color(0xFF007AFF),
                                  decoration: TextDecoration.underline,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ),
                          TextSpan(
                            text: ' and ',
                            style: GoogleFonts.inter(
                              fontSize: 14.sp,
                              color: const Color(0xFF8E8E93),
                            ),
                          ),
                          WidgetSpan(
                            child: GestureDetector(
                              onTap: onPrivacyPolicyTap,
                              child: Text(
                                'Privacy Policy',
                                style: GoogleFonts.inter(
                                  fontSize: 14.sp,
                                  color: const Color(0xFF007AFF),
                                  decoration: TextDecoration.underline,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ),
                          TextSpan(
                            text: ')',
                            style: GoogleFonts.inter(
                              fontSize: 14.sp,
                              color: const Color(0xFF8E8E93),
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

          SizedBox(height: 3.h),

          // Status indicator
          if (!acceptTerms || !acceptPrivacy) ...[
            Container(
              padding: EdgeInsets.all(3.w),
              decoration: BoxDecoration(
                color: const Color(0xFFEF4444).withAlpha(26),
                borderRadius: BorderRadius.circular(2.w),
                border: Border.all(
                  color: const Color(0xFFEF4444).withAlpha(77),
                ),
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.warning_amber_rounded,
                    color: Color(0xFFEF4444),
                    size: 16,
                  ),
                  SizedBox(width: 2.w),
                  Expanded(
                    child: Text(
                      'Please accept both agreements to proceed with registration',
                      style: GoogleFonts.inter(
                        fontSize: 12.sp,
                        color: const Color(0xFFEF4444),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],

          if (acceptTerms && acceptPrivacy) ...[
            Container(
              padding: EdgeInsets.all(3.w),
              decoration: BoxDecoration(
                color: const Color(0xFF10B981).withAlpha(26),
                borderRadius: BorderRadius.circular(2.w),
                border: Border.all(
                  color: const Color(0xFF10B981).withAlpha(77),
                ),
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.check_circle_outline,
                    color: Color(0xFF10B981),
                    size: 16,
                  ),
                  SizedBox(width: 2.w),
                  Expanded(
                    child: Text(
                      'Great! You\'ve accepted all required agreements',
                      style: GoogleFonts.inter(
                        fontSize: 12.sp,
                        color: const Color(0xFF10B981),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}