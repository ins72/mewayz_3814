
import '../../../core/app_export.dart';

class CourseModuleCardWidget extends StatelessWidget {
  final Map<String, dynamic> module;
  final bool isExpanded;
  final bool isPreviewMode;
  final VoidCallback onToggleExpansion;
  final Function(int) onLessonTap;
  final Function(int) onLessonLongPress;

  const CourseModuleCardWidget({
    Key? key,
    required this.module,
    required this.isExpanded,
    required this.isPreviewMode,
    required this.onToggleExpansion,
    required this.onLessonTap,
    required this.onLessonLongPress,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final lessons = (module["lessons"] as List?) ?? [];

    return Card(
      margin: EdgeInsets.only(bottom: 2.h),
      child: Column(
        children: [
          ListTile(
            leading: !isPreviewMode
                ? CustomIconWidget(
                    iconName: 'drag_handle',
                    color: AppTheme.secondaryText,
                    size: 24,
                  )
                : null,
            title: Text(
              module["title"] ?? '',
              style: AppTheme.darkTheme.textTheme.titleMedium,
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 1.h),
                Row(
                  children: [
                    CustomIconWidget(
                      iconName: 'play_lesson',
                      color: AppTheme.secondaryText,
                      size: 16,
                    ),
                    SizedBox(width: 1.w),
                    Text(
                      '${module["lessonCount"]} lessons',
                      style: AppTheme.darkTheme.textTheme.bodySmall,
                    ),
                    SizedBox(width: 4.w),
                    CustomIconWidget(
                      iconName: 'schedule',
                      color: AppTheme.secondaryText,
                      size: 16,
                    ),
                    SizedBox(width: 1.w),
                    Text(
                      module["duration"] ?? '',
                      style: AppTheme.darkTheme.textTheme.bodySmall,
                    ),
                  ],
                ),
                SizedBox(height: 1.h),
                Row(
                  children: [
                    Expanded(
                      child: LinearProgressIndicator(
                        value: (module["completionRate"] as double) / 100,
                        backgroundColor: AppTheme.border,
                        valueColor: AlwaysStoppedAnimation<Color>(
                          _getProgressColor(module["completionRate"] as double),
                        ),
                      ),
                    ),
                    SizedBox(width: 2.w),
                    Text(
                      '${(module["completionRate"] as double).toStringAsFixed(1)}%',
                      style: AppTheme.darkTheme.textTheme.bodySmall,
                    ),
                  ],
                ),
              ],
            ),
            trailing: CustomIconWidget(
              iconName: isExpanded ? 'expand_less' : 'expand_more',
              color: AppTheme.primaryText,
              size: 24,
            ),
            onTap: onToggleExpansion,
          ),
          if (isExpanded) ...[
            Divider(color: AppTheme.border, height: 1),
            ...lessons
                .map<Widget>((lesson) => _buildLessonTile(lesson))
                .toList(),
          ],
        ],
      ),
    );
  }

  Widget _buildLessonTile(Map<String, dynamic> lesson) {
    return ListTile(
      contentPadding: EdgeInsets.only(left: 12.w, right: 4.w),
      leading: _buildLessonThumbnail(lesson),
      title: Text(
        lesson["title"] ?? '',
        style: AppTheme.darkTheme.textTheme.bodyLarge,
      ),
      subtitle: Row(
        children: [
          _buildLessonTypeChip(lesson["type"] ?? ''),
          SizedBox(width: 2.w),
          Text(
            lesson["duration"] ?? '',
            style: AppTheme.darkTheme.textTheme.bodySmall,
          ),
          Spacer(),
          _buildLessonStatusIndicator(lesson["status"] ?? ''),
        ],
      ),
      trailing: lesson["isCompleted"] == true
          ? CustomIconWidget(
              iconName: 'check_circle',
              color: AppTheme.success,
              size: 20,
            )
          : null,
      onTap: () => onLessonTap(lesson["id"] ?? 0),
      onLongPress: () => onLessonLongPress(lesson["id"] ?? 0),
    );
  }

  Widget _buildLessonThumbnail(Map<String, dynamic> lesson) {
    if (lesson["thumbnail"] != null) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: CustomImageWidget(
          imageUrl: lesson["thumbnail"],
          width: 12.w,
          height: 8.w,
          fit: BoxFit.cover,
        ),
      );
    }

    return Container(
      width: 12.w,
      height: 8.w,
      decoration: BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppTheme.border),
      ),
      child: CustomIconWidget(
        iconName: _getLessonTypeIcon(lesson["type"] ?? ''),
        color: AppTheme.accent,
        size: 20,
      ),
    );
  }

  Widget _buildLessonTypeChip(String type) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.5.h),
      decoration: BoxDecoration(
        color: _getLessonTypeColor(type).withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        type.toUpperCase(),
        style: AppTheme.darkTheme.textTheme.labelSmall?.copyWith(
          color: _getLessonTypeColor(type),
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Widget _buildLessonStatusIndicator(String status) {
    Color statusColor;
    String statusText;

    switch (status) {
      case 'published':
        statusColor = AppTheme.success;
        statusText = 'Published';
        break;
      case 'draft':
        statusColor = AppTheme.warning;
        statusText = 'Draft';
        break;
      default:
        statusColor = AppTheme.secondaryText;
        statusText = 'Unknown';
    }

    return Container(
      width: 2.w,
      height: 2.w,
      decoration: BoxDecoration(
        color: statusColor,
        shape: BoxShape.circle,
      ),
    );
  }

  String _getLessonTypeIcon(String type) {
    switch (type) {
      case 'video':
        return 'play_circle_filled';
      case 'text':
        return 'article';
      case 'quiz':
        return 'quiz';
      case 'assignment':
        return 'assignment';
      case 'discussion':
        return 'forum';
      default:
        return 'help';
    }
  }

  Color _getLessonTypeColor(String type) {
    switch (type) {
      case 'video':
        return AppTheme.accent;
      case 'text':
        return AppTheme.success;
      case 'quiz':
        return AppTheme.warning;
      case 'assignment':
        return Color(0xFF8B5CF6);
      case 'discussion':
        return Color(0xFFEC4899);
      default:
        return AppTheme.secondaryText;
    }
  }

  Color _getProgressColor(double progress) {
    if (progress >= 80) return AppTheme.success;
    if (progress >= 50) return AppTheme.warning;
    return AppTheme.accent;
  }
}