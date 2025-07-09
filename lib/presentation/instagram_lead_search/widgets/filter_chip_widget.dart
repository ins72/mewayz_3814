
import '../../../core/app_export.dart';

class FilterChipWidget extends StatelessWidget {
  final Map<String, dynamic> filter;
  final VoidCallback onRemove;

  const FilterChipWidget({
    Key? key,
    required this.filter,
    required this.onRemove,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(right: 2.w),
      child: GestureDetector(
        onTap: () {
          HapticFeedback.selectionClick();
          onRemove();
        },
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
          decoration: BoxDecoration(
            color: AppTheme.surface,
            borderRadius: BorderRadius.circular(6.w),
            border: Border.all(color: AppTheme.accent.withValues(alpha: 0.5)),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                filter['label'] ?? '',
                style: AppTheme.darkTheme.textTheme.labelMedium?.copyWith(
                  color: AppTheme.primaryText,
                  fontWeight: FontWeight.w500,
                ),
              ),
              if (filter['count'] != null && filter['count'] > 0) ...[
                SizedBox(width: 1.w),
                Container(
                  padding:
                      EdgeInsets.symmetric(horizontal: 1.5.w, vertical: 0.5.h),
                  decoration: BoxDecoration(
                    color: AppTheme.accent,
                    borderRadius: BorderRadius.circular(2.w),
                  ),
                  child: Text(
                    '${filter['count']}',
                    style: AppTheme.darkTheme.textTheme.labelSmall?.copyWith(
                      color: AppTheme.primaryBackground,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
              SizedBox(width: 2.w),
              CustomIconWidget(
                iconName: 'close',
                color: AppTheme.secondaryText,
                size: 4.w,
              ),
            ],
          ),
        ),
      ),
    );
  }
}