
import '../../../core/app_export.dart';

class WorkspaceSearchBarWidget extends StatelessWidget {
  final TextEditingController controller;
  final Function(String) onChanged;

  const WorkspaceSearchBarWidget({
    Key? key,
    required this.controller,
    required this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppTheme.border, width: 1),
      ),
      child: TextField(
        controller: controller,
        onChanged: onChanged,
        style: AppTheme.darkTheme.textTheme.bodyMedium,
        decoration: InputDecoration(
          hintText: 'Search workspaces...',
          hintStyle: AppTheme.darkTheme.textTheme.bodyMedium?.copyWith(
            color: AppTheme.secondaryText,
          ),
          prefixIcon: const CustomIconWidget(
            iconName: 'search',
            color: AppTheme.secondaryText,
            size: 20,
          ),
          suffixIcon: controller.text.isNotEmpty
              ? IconButton(
                  icon: const CustomIconWidget(
                    iconName: 'clear',
                    color: AppTheme.secondaryText,
                    size: 20,
                  ),
                  onPressed: () {
                    controller.clear();
                    onChanged('');
                  },
                )
              : null,
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
        ),
      ),
    );
  }
}