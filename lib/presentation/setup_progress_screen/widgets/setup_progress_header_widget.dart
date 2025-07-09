
import '../../../core/app_export.dart';

class SetupProgressHeaderWidget extends StatelessWidget {
  final VoidCallback onSkip;

  const SetupProgressHeaderWidget({
    Key? key,
    required this.onSkip,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: AppTheme.primaryBackground,
        border: Border(
          bottom: BorderSide(
            color: AppTheme.border,
            width: 1,
          ),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Back button
              IconButton(
                onPressed: () => Navigator.pop(context),
                icon: Icon(
                  Icons.arrow_back_ios,
                  color: AppTheme.primaryText,
                  size: 20,
                ),
                padding: EdgeInsets.zero,
                constraints: BoxConstraints.tight(Size(24, 24)),
              ),
              
              // Skip button
              TextButton(
                onPressed: onSkip,
                style: TextButton.styleFrom(
                  foregroundColor: AppTheme.secondaryText,
                  padding: EdgeInsets.symmetric(
                    horizontal: 4.w,
                    vertical: 1.h,
                  ),
                ),
                child: Text(
                  'Skip for Now',
                  style: AppTheme.darkTheme.textTheme.labelLarge?.copyWith(
                    color: AppTheme.secondaryText,
                    fontSize: 12.sp,
                  ),
                ),
              ),
            ],
          ),
          
          SizedBox(height: 2.h),
          
          // Title
          Text(
            'Let\'s set up your Mewayz',
            style: AppTheme.darkTheme.textTheme.headlineSmall?.copyWith(
              color: AppTheme.primaryText,
              fontSize: 20.sp,
              fontWeight: FontWeight.w700,
              height: 1.2,
            ),
          ),
          
          SizedBox(height: 1.h),
          
          // Subtitle
          Text(
            'Complete these steps to get the most out of your platform',
            style: AppTheme.darkTheme.textTheme.bodyMedium?.copyWith(
              color: AppTheme.secondaryText,
              fontSize: 12.sp,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }
}