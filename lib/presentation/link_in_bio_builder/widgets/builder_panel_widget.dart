
import '../../../core/app_export.dart';

class BuilderPanelWidget extends StatelessWidget {
  final List<Map<String, dynamic>> componentLibrary;
  final Function(Map<String, dynamic>) onComponentDrag;

  const BuilderPanelWidget({
    Key? key,
    required this.componentLibrary,
    required this.onComponentDrag,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppTheme.surface,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.all(4.w),
            decoration: BoxDecoration(
              color: AppTheme.primaryBackground,
              border: Border(
                bottom: BorderSide(color: AppTheme.border, width: 1),
              ),
            ),
            child: Text(
              'Components',
              style: AppTheme.darkTheme.textTheme.titleMedium,
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.all(2.w),
              itemCount: componentLibrary.length,
              itemBuilder: (context, index) {
                final component = componentLibrary[index];
                return _buildDraggableComponent(component);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDraggableComponent(Map<String, dynamic> component) {
    return Container(
      margin: EdgeInsets.only(bottom: 2.h),
      child: Draggable<Map<String, dynamic>>(
        data: component,
        feedback: Material(
          color: Colors.transparent,
          child: Container(
            width: 40.w,
            padding: EdgeInsets.all(3.w),
            decoration: BoxDecoration(
              color: AppTheme.accent.withValues(alpha: 0.9),
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: AppTheme.shadowDark,
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                CustomIconWidget(
                  iconName: component['icon'] as String,
                  color: AppTheme.primaryAction,
                  size: 20,
                ),
                SizedBox(width: 2.w),
                Flexible(
                  child: Text(
                    component['name'] as String,
                    style: AppTheme.darkTheme.textTheme.bodyMedium?.copyWith(
                      color: AppTheme.primaryAction,
                      fontWeight: FontWeight.w500,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
        ),
        childWhenDragging: Container(
          padding: EdgeInsets.all(3.w),
          decoration: BoxDecoration(
            color: AppTheme.primaryBackground,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppTheme.border.withValues(alpha: 0.5)),
          ),
          child: Row(
            children: [
              CustomIconWidget(
                iconName: component['icon'] as String,
                color: AppTheme.secondaryText.withValues(alpha: 0.5),
                size: 24,
              ),
              SizedBox(width: 3.w),
              Expanded(
                child: Text(
                  component['name'] as String,
                  style: AppTheme.darkTheme.textTheme.bodyMedium?.copyWith(
                    color: AppTheme.secondaryText.withValues(alpha: 0.5),
                  ),
                ),
              ),
            ],
          ),
        ),
        child: GestureDetector(
          onTap: () => onComponentDrag(component),
          child: Container(
            padding: EdgeInsets.all(3.w),
            decoration: BoxDecoration(
              color: AppTheme.primaryBackground,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppTheme.border),
            ),
            child: Row(
              children: [
                Container(
                  padding: EdgeInsets.all(2.w),
                  decoration: BoxDecoration(
                    color: AppTheme.accent.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: CustomIconWidget(
                    iconName: component['icon'] as String,
                    color: AppTheme.accent,
                    size: 24,
                  ),
                ),
                SizedBox(width: 3.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        component['name'] as String,
                        style:
                            AppTheme.darkTheme.textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      SizedBox(height: 0.5.h),
                      Text(
                        _getComponentDescription(component['type'] as String),
                        style: AppTheme.darkTheme.textTheme.bodySmall,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                CustomIconWidget(
                  iconName: 'drag_indicator',
                  color: AppTheme.secondaryText,
                  size: 20,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String _getComponentDescription(String type) {
    switch (type) {
      case 'text':
        return 'Add headings and paragraphs';
      case 'button':
        return 'Call-to-action buttons';
      case 'image':
        return 'Photos and graphics';
      case 'video':
        return 'Video content';
      case 'product':
        return 'Product showcases';
      case 'form':
        return 'Contact forms';
      case 'social':
        return 'Social media links';
      default:
        return 'Drag to add component';
    }
  }
}