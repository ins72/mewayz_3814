
import '../../../core/app_export.dart';
import './setup_step_card_widget.dart';

class SetupChecklistWidget extends StatefulWidget {
  final List<Map<String, dynamic>> steps;
  final Function(String, SetupStepStatus) onStepTap;

  const SetupChecklistWidget({
    Key? key,
    required this.steps,
    required this.onStepTap,
  }) : super(key: key);

  @override
  State<SetupChecklistWidget> createState() => _SetupChecklistWidgetState();
}

class _SetupChecklistWidgetState extends State<SetupChecklistWidget> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header
        Text(
          'Setup Checklist',
          style: AppTheme.darkTheme.textTheme.titleMedium?.copyWith(
            color: AppTheme.primaryText,
            fontSize: 16.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
        
        SizedBox(height: 2.h),
        
        // Steps list
        widget.steps.isEmpty
            ? _buildEmptyState()
            : ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: widget.steps.length,
                separatorBuilder: (context, index) => SizedBox(height: 2.h),
                itemBuilder: (context, index) {
                  final step = widget.steps[index];
                  return SetupStepCardWidget(
                    step: step,
                    onStatusChange: (status) {
                      widget.onStepTap(step['step_key'], status);
                    },
                    animationDelay: Duration(milliseconds: 100 * index),
                  );
                },
              ),
      ],
    );
  }

  Widget _buildEmptyState() {
    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.circular(4.w),
        border: Border.all(
          color: AppTheme.border,
          width: 1,
        ),
      ),
      child: Column(
        children: [
          CustomIconWidget(
            iconName: 'assignment',
            color: AppTheme.secondaryText,
            size: 40,
          ),
          SizedBox(height: 2.h),
          Text(
            'No setup steps found',
            style: AppTheme.darkTheme.textTheme.titleMedium?.copyWith(
              color: AppTheme.primaryText,
              fontSize: 14.sp,
            ),
          ),
          SizedBox(height: 1.h),
          Text(
            'Your setup checklist will appear here based on your selected goals.',
            style: AppTheme.darkTheme.textTheme.bodySmall?.copyWith(
              color: AppTheme.secondaryText,
              fontSize: 11.sp,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}