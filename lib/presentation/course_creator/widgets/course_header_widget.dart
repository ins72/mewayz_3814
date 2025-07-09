
import '../../../core/app_export.dart';

class CourseHeaderWidget extends StatelessWidget {
  final TextEditingController courseTitleController;
  final double overallProgress;
  final bool isPreviewMode;
  final VoidCallback onPreviewToggle;
  final VoidCallback onSettingsPressed;

  const CourseHeaderWidget({
    Key? key,
    required this.courseTitleController,
    required this.overallProgress,
    required this.isPreviewMode,
    required this.onPreviewToggle,
    required this.onSettingsPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: AppTheme.surface,
        boxShadow: [
          BoxShadow(
            color: AppTheme.shadowDark,
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              GestureDetector(
                onTap: () => Navigator.pop(context),
                child: CustomIconWidget(
                  iconName: 'arrow_back',
                  color: AppTheme.primaryText,
                  size: 24,
                ),
              ),
              SizedBox(width: 4.w),
              Expanded(
                child: TextField(
                  controller: courseTitleController,
                  style: AppTheme.darkTheme.textTheme.titleLarge,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: 'Course Title',
                    hintStyle:
                        AppTheme.darkTheme.textTheme.titleLarge?.copyWith(
                      color: AppTheme.secondaryText,
                    ),
                    contentPadding: EdgeInsets.zero,
                  ),
                ),
              ),
              IconButton(
                onPressed: onPreviewToggle,
                icon: CustomIconWidget(
                  iconName: isPreviewMode ? 'edit' : 'visibility',
                  color: isPreviewMode ? AppTheme.accent : AppTheme.primaryText,
                  size: 24,
                ),
              ),
              IconButton(
                onPressed: onSettingsPressed,
                icon: CustomIconWidget(
                  iconName: 'settings',
                  color: AppTheme.primaryText,
                  size: 24,
                ),
              ),
            ],
          ),
          SizedBox(height: 2.h),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Course Progress',
                      style: AppTheme.darkTheme.textTheme.bodySmall,
                    ),
                    SizedBox(height: 0.5.h),
                    LinearProgressIndicator(
                      value: overallProgress / 100,
                      backgroundColor: AppTheme.border,
                      valueColor:
                          AlwaysStoppedAnimation<Color>(AppTheme.accent),
                    ),
                  ],
                ),
              ),
              SizedBox(width: 4.w),
              Text(
                '${overallProgress.toStringAsFixed(1)}%',
                style: AppTheme.darkTheme.textTheme.titleMedium?.copyWith(
                  color: AppTheme.accent,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}