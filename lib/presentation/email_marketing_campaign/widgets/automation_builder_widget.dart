
import '../../../core/app_export.dart';

class AutomationBuilderWidget extends StatefulWidget {
  const AutomationBuilderWidget({Key? key}) : super(key: key);

  @override
  State<AutomationBuilderWidget> createState() =>
      _AutomationBuilderWidgetState();
}

class _AutomationBuilderWidgetState extends State<AutomationBuilderWidget> {
  String _selectedWorkflow = 'welcome';

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              Icons.auto_awesome_rounded,
              color: AppTheme.accent,
              size: 20,
            ),
            SizedBox(width: 8.w),
            Text(
              'Automation Builder',
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ],
        ),
        SizedBox(height: 16.h),
        _buildWorkflowSelector(),
        SizedBox(height: 16.h),
        _buildWorkflowBuilder(),
        SizedBox(height: 16.h),
        _buildWorkflowPreview(),
      ],
    );
  }

  Widget _buildWorkflowSelector() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppTheme.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Select Workflow Type',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w500,
                ),
          ),
          SizedBox(height: 12.h),
          GridView.count(
            crossAxisCount: 2,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            childAspectRatio: 2.5,
            children: [
              _buildWorkflowCard(
                'welcome',
                'Welcome Series',
                Icons.waving_hand_rounded,
                'Onboard new subscribers',
              ),
              _buildWorkflowCard(
                'abandoned',
                'Abandoned Cart',
                Icons.shopping_cart_rounded,
                'Recover abandoned purchases',
              ),
              _buildWorkflowCard(
                'reengagement',
                'Re-engagement',
                Icons.refresh_rounded,
                'Win back inactive users',
              ),
              _buildWorkflowCard(
                'birthday',
                'Birthday Campaign',
                Icons.cake_rounded,
                'Celebrate subscriber birthdays',
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildWorkflowCard(
      String id, String title, IconData icon, String description) {
    final isSelected = _selectedWorkflow == id;
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedWorkflow = id;
        });
      },
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isSelected
              ? AppTheme.accent.withAlpha(26)
              : AppTheme.primaryBackground,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isSelected ? AppTheme.accent : AppTheme.border,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  icon,
                  color: isSelected ? AppTheme.accent : AppTheme.secondaryText,
                  size: 16,
                ),
                SizedBox(width: 8.w),
                Expanded(
                  child: Text(
                    title,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color:
                          isSelected ? AppTheme.accent : AppTheme.primaryText,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 4.h),
            Text(
              description,
              style: TextStyle(
                fontSize: 10,
                color: AppTheme.secondaryText,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWorkflowBuilder() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppTheme.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                'Workflow Builder',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w500,
                    ),
              ),
              const Spacer(),
              OutlinedButton.icon(
                onPressed: _addWorkflowStep,
                icon: const Icon(Icons.add_rounded),
                label: const Text('Add Step'),
              ),
            ],
          ),
          SizedBox(height: 16.h),
          _buildWorkflowSteps(),
        ],
      ),
    );
  }

  Widget _buildWorkflowSteps() {
    return Column(
      children: [
        _buildWorkflowStep(
          'Trigger',
          'User subscribes',
          Icons.play_arrow_rounded,
          AppTheme.accent,
          isFirst: true,
        ),
        _buildWorkflowConnector(),
        _buildWorkflowStep(
          'Wait',
          'Wait 1 hour',
          Icons.schedule_rounded,
          AppTheme.warning,
        ),
        _buildWorkflowConnector(),
        _buildWorkflowStep(
          'Email',
          'Send welcome email',
          Icons.email_rounded,
          AppTheme.success,
        ),
        _buildWorkflowConnector(),
        _buildWorkflowStep(
          'Condition',
          'If email opened',
          Icons.rule_rounded,
          AppTheme.accent,
        ),
        _buildWorkflowConnector(),
        _buildWorkflowStep(
          'Email',
          'Send follow-up',
          Icons.email_rounded,
          AppTheme.success,
          isLast: true,
        ),
      ],
    );
  }

  Widget _buildWorkflowStep(
    String type,
    String description,
    IconData icon,
    Color color, {
    bool isFirst = false,
    bool isLast = false,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppTheme.primaryBackground,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppTheme.border),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withAlpha(26),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              icon,
              color: color,
              size: 16,
            ),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  type,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: color,
                  ),
                ),
                Text(
                  description,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppTheme.primaryText,
                      ),
                ),
              ],
            ),
          ),
          if (!isFirst && !isLast)
            IconButton(
              icon: Icon(
                Icons.more_vert_rounded,
                color: AppTheme.secondaryText,
                size: 16,
              ),
              onPressed: () {
                // Show step options
              },
            ),
        ],
      ),
    );
  }

  Widget _buildWorkflowConnector() {
    return Container(
      width: 2,
      height: 16,
      margin: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        color: AppTheme.border,
        borderRadius: BorderRadius.circular(1),
      ),
    );
  }

  Widget _buildWorkflowPreview() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppTheme.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                'Workflow Preview',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w500,
                    ),
              ),
              const Spacer(),
              Switch(
                value: true,
                onChanged: (value) {
                  // Toggle workflow status
                },
              ),
              SizedBox(width: 8.w),
              Text(
                'Active',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: AppTheme.success,
                    ),
              ),
            ],
          ),
          SizedBox(height: 16.h),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppTheme.primaryBackground,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: AppTheme.border),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Workflow Statistics',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w500,
                      ),
                ),
                SizedBox(height: 12.h),
                Row(
                  children: [
                    Expanded(
                      child: _buildStatItem('Active Subscribers', '1,247'),
                    ),
                    Expanded(
                      child: _buildStatItem('Completed', '856'),
                    ),
                  ],
                ),
                SizedBox(height: 8.h),
                Row(
                  children: [
                    Expanded(
                      child: _buildStatItem('Open Rate', '32.4%'),
                    ),
                    Expanded(
                      child: _buildStatItem('Click Rate', '5.2%'),
                    ),
                  ],
                ),
              ],
            ),
          ),
          SizedBox(height: 16.h),
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: _testWorkflow,
                  icon: const Icon(Icons.play_arrow_rounded),
                  label: const Text('Test Workflow'),
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: _saveWorkflow,
                  icon: const Icon(Icons.save_outlined),
                  label: const Text('Save Workflow'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          value,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w600,
                color: AppTheme.primaryText,
              ),
        ),
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: AppTheme.secondaryText,
              ),
        ),
      ],
    );
  }

  void _addWorkflowStep() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: BoxDecoration(
          color: AppTheme.surface,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: AppTheme.border,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              SizedBox(height: 16.h),
              Text(
                'Add Workflow Step',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              SizedBox(height: 16.h),
              GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                childAspectRatio: 2,
                children: [
                  _buildStepOption('Email', Icons.email_rounded),
                  _buildStepOption('Wait', Icons.schedule_rounded),
                  _buildStepOption('Condition', Icons.rule_rounded),
                  _buildStepOption('Action', Icons.play_arrow_rounded),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStepOption(String label, IconData icon) {
    return GestureDetector(
      onTap: () {
        Navigator.pop(context);
        // Add step logic
      },
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: AppTheme.primaryBackground,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: AppTheme.border),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: AppTheme.accent,
              size: 20,
            ),
            SizedBox(height: 8.h),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: AppTheme.primaryText,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _testWorkflow() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Workflow test initiated'),
      ),
    );
  }

  void _saveWorkflow() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Workflow saved successfully'),
      ),
    );
  }
}