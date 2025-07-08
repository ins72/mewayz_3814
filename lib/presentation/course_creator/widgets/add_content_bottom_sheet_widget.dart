import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class AddContentBottomSheetWidget extends StatelessWidget {
  final Function(String) onContentTypeSelected;

  const AddContentBottomSheetWidget({
    Key? key,
    required this.onContentTypeSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 10.w,
            height: 0.5.h,
            margin: EdgeInsets.only(top: 2.h),
            decoration: BoxDecoration(
              color: AppTheme.border,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          SizedBox(height: 3.h),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 4.w),
            child: Text(
              'Add Content',
              style: AppTheme.darkTheme.textTheme.titleLarge,
            ),
          ),
          SizedBox(height: 3.h),
          _buildContentTypeOption(
            'Video Lesson',
            'Upload video content with player controls',
            'video_library',
            () => onContentTypeSelected('video'),
          ),
          _buildContentTypeOption(
            'Text Content',
            'Create rich text lessons with formatting',
            'article',
            () => onContentTypeSelected('text'),
          ),
          _buildContentTypeOption(
            'Quiz',
            'Build interactive quizzes with multiple question types',
            'quiz',
            () => onContentTypeSelected('quiz'),
          ),
          _buildContentTypeOption(
            'Assignment',
            'Create assignments with file submissions',
            'assignment',
            () => onContentTypeSelected('assignment'),
          ),
          _buildContentTypeOption(
            'Discussion Forum',
            'Add discussion topics for student interaction',
            'forum',
            () => onContentTypeSelected('discussion'),
          ),
          SizedBox(height: 2.h),
        ],
      ),
    );
  }

  Widget _buildContentTypeOption(
    String title,
    String description,
    String iconName,
    VoidCallback onTap,
  ) {
    return ListTile(
      leading: Container(
        width: 12.w,
        height: 12.w,
        decoration: BoxDecoration(
          color: AppTheme.accent.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(12),
        ),
        child: CustomIconWidget(
          iconName: iconName,
          color: AppTheme.accent,
          size: 24,
        ),
      ),
      title: Text(
        title,
        style: AppTheme.darkTheme.textTheme.titleMedium,
      ),
      subtitle: Text(
        description,
        style: AppTheme.darkTheme.textTheme.bodySmall,
      ),
      trailing: CustomIconWidget(
        iconName: 'arrow_forward_ios',
        color: AppTheme.secondaryText,
        size: 16,
      ),
      onTap: onTap,
    );
  }
}
