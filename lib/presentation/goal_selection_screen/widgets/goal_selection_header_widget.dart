
import '../../../core/app_export.dart';

class GoalSelectionHeaderWidget extends StatelessWidget {
  const GoalSelectionHeaderWidget({Key? key}) : super(key: key);

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
          Row(
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
              
              SizedBox(width: 3.w),
              
              // Title
              Text(
                'Goal Selection',
                style: AppTheme.darkTheme.textTheme.titleLarge?.copyWith(
                  color: AppTheme.primaryText,
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          
          SizedBox(height: 3.h),
          
          // Main title
          Text(
            'What do you want to achieve with Mewayz?',
            style: AppTheme.darkTheme.textTheme.headlineSmall?.copyWith(
              color: AppTheme.primaryText,
              fontSize: 20.sp,
              fontWeight: FontWeight.w700,
              height: 1.2,
            ),
          ),
          
          SizedBox(height: 2.h),
          
          // Subtitle
          Text(
            'Select one or more goals to create a personalized setup experience tailored to your needs.',
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