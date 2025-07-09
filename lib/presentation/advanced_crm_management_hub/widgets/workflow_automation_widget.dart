
import '../../../core/app_export.dart';

class WorkflowAutomationWidget extends StatefulWidget {
  final VoidCallback onCreateWorkflow;

  const WorkflowAutomationWidget({
    Key? key,
    required this.onCreateWorkflow,
  }) : super(key: key);

  @override
  State<WorkflowAutomationWidget> createState() => _WorkflowAutomationWidgetState();
}

class _WorkflowAutomationWidgetState extends State<WorkflowAutomationWidget> {
  final List<Map<String, dynamic>> _workflows = [
{ 'id': '1',
'name': 'Welcome New Leads',
'description': 'Automatically send welcome email to new leads',
'trigger': 'Contact Created',
'actions': ['Send Email', 'Assign Owner', 'Add to Sequence'],
'isActive': true,
'runsToday': 12,
'totalRuns': 247,
'lastRun': DateTime.now().subtract(const Duration(minutes: 15)),
'successRate': 0.96,
'createdAt': DateTime.now().subtract(const Duration(days: 30)),
},
{ 'id': '2',
'name': 'Hot Lead Notification',
'description': 'Notify sales team when lead score exceeds 80',
'trigger': 'Lead Score Updated',
'actions': ['Send Notification', 'Create Task', 'Update Priority'],
'isActive': true,
'runsToday': 8,
'totalRuns': 156,
'lastRun': DateTime.now().subtract(const Duration(hours: 2)),
'successRate': 0.92,
'createdAt': DateTime.now().subtract(const Duration(days: 15)),
},
{ 'id': '3',
'name': 'Deal Stage Progression',
'description': 'Auto-update deal stages based on activities',
'trigger': 'Activity Completed',
'actions': ['Update Stage', 'Calculate Score', 'Schedule Follow-up'],
'isActive': false,
'runsToday': 0,
'totalRuns': 89,
'lastRun': DateTime.now().subtract(const Duration(days: 3)),
'successRate': 0.88,
'createdAt': DateTime.now().subtract(const Duration(days: 7)),
},
];

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(4.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            children: [
              Icon(
                Icons.precision_manufacturing,
                color: AppTheme.accent,
                size: 20,
              ),
              SizedBox(width: 3.w),
              Text(
                'Workflow Automation',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              const Spacer(),
              ElevatedButton.icon(
                onPressed: widget.onCreateWorkflow,
                icon: const Icon(Icons.add, size: 16),
                label: const Text('Create'),
                style: ElevatedButton.styleFrom(
                  minimumSize: Size(0, 5.h),
                ),
              ),
            ],
          ),
          
          SizedBox(height: 3.h),
          
          // Automation overview
          _buildAutomationOverview(),
          
          SizedBox(height: 3.h),
          
          // Workflows list
          _buildWorkflowsList(),
          
          SizedBox(height: 3.h),
          
          // Quick templates
          _buildQuickTemplates(),
        ],
      ),
    );
  }

  Widget _buildAutomationOverview() {
    final activeWorkflows = _workflows.where((w) => w['isActive'] == true).length;
    final totalRuns = _workflows.fold<int>(
      0,
      (sum, workflow) => sum + (workflow['runsToday'] as int),
    );
    final avgSuccessRate = _workflows.isEmpty
        ? 0.0
        : _workflows.fold<double>(
            0,
            (sum, workflow) => sum + (workflow['successRate'] as double),
          ) / _workflows.length;
    
    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: const Color(0xFF191919),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppTheme.border.withAlpha(77)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Automation Overview',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 3.h),
          
          Row(
            children: [
              Expanded(
                child: _buildOverviewCard(
                  'Active Workflows',
                  '$activeWorkflows',
                  Icons.play_circle,
                  AppTheme.success,
                ),
              ),
              SizedBox(width: 3.w),
              Expanded(
                child: _buildOverviewCard(
                  'Runs Today',
                  '$totalRuns',
                  Icons.refresh,
                  AppTheme.accent,
                ),
              ),
            ],
          ),
          
          SizedBox(height: 2.h),
          
          Row(
            children: [
              Expanded(
                child: _buildOverviewCard(
                  'Success Rate',
                  '${(avgSuccessRate * 100).toInt()}%',
                  Icons.check_circle,
                  AppTheme.success,
                ),
              ),
              SizedBox(width: 3.w),
              Expanded(
                child: _buildOverviewCard(
                  'Time Saved',
                  '${totalRuns * 5}min',
                  Icons.timer,
                  AppTheme.warning,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildOverviewCard(String title, String value, IconData icon, Color color) {
    return Container(
      padding: EdgeInsets.all(3.w),
      decoration: BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppTheme.border.withAlpha(77)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                icon,
                color: color,
                size: 16,
              ),
              SizedBox(width: 2.w),
              Text(
                title,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: AppTheme.secondaryText,
                ),
              ),
            ],
          ),
          SizedBox(height: 1.h),
          Text(
            value,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w700,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWorkflowsList() {
    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: const Color(0xFF191919),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppTheme.border.withAlpha(77)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Your Workflows',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 2.h),
          
          // Workflows
          ..._workflows.map((workflow) => _buildWorkflowCard(workflow)).toList(),
        ],
      ),
    );
  }

  Widget _buildWorkflowCard(Map<String, dynamic> workflow) {
    final isActive = workflow['isActive'] as bool;
    
    return Container(
      margin: EdgeInsets.only(bottom: 3.h),
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isActive ? AppTheme.accent.withAlpha(77) : AppTheme.border.withAlpha(77),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(2.w),
                decoration: BoxDecoration(
                  color: (isActive ? AppTheme.success : AppTheme.secondaryText).withAlpha(26),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Icon(
                  isActive ? Icons.play_circle : Icons.pause_circle,
                  color: isActive ? AppTheme.success : AppTheme.secondaryText,
                  size: 16,
                ),
              ),
              SizedBox(width: 3.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      workflow['name'] ?? '',
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      workflow['description'] ?? '',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppTheme.secondaryText,
                      ),
                    ),
                  ],
                ),
              ),
              Switch(
                value: isActive,
                onChanged: (value) {
                  setState(() {
                    workflow['isActive'] = value;
                  });
                },
                activeColor: AppTheme.success,
              ),
            ],
          ),
          
          SizedBox(height: 2.h),
          
          // Trigger and actions
          Row(
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 1.h),
                decoration: BoxDecoration(
                  color: AppTheme.accent.withAlpha(26),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.play_arrow,
                      color: AppTheme.accent,
                      size: 12,
                    ),
                    SizedBox(width: 1.w),
                    Text(
                      workflow['trigger'] ?? '',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppTheme.accent,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(width: 2.w),
              Icon(
                Icons.arrow_forward,
                color: AppTheme.secondaryText,
                size: 16,
              ),
              SizedBox(width: 2.w),
              Expanded(
                child: Wrap(
                  spacing: 1.w,
                  children: (workflow['actions'] as List<dynamic>).map((action) {
                    return Container(
                      padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.5.h),
                      decoration: BoxDecoration(
                        color: AppTheme.success.withAlpha(26),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        action.toString(),
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AppTheme.success,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ],
          ),
          
          SizedBox(height: 2.h),
          
          // Statistics
          Row(
            children: [
              _buildStatistic('Runs Today', '${workflow['runsToday']}'),
              SizedBox(width: 4.w),
              _buildStatistic('Total Runs', '${workflow['totalRuns']}'),
              SizedBox(width: 4.w),
              _buildStatistic('Success Rate', '${(workflow['successRate'] * 100).toInt()}%'),
              const Spacer(),
              _buildStatistic('Last Run', _formatTimestamp(workflow['lastRun'])),
            ],
          ),
          
          SizedBox(height: 2.h),
          
          // Actions
          Row(
            children: [
              TextButton.icon(
                onPressed: () => _editWorkflow(workflow),
                icon: const Icon(Icons.edit, size: 16),
                label: const Text('Edit'),
                style: TextButton.styleFrom(
                  foregroundColor: AppTheme.accent,
                  minimumSize: Size(0, 4.h),
                ),
              ),
              SizedBox(width: 2.w),
              TextButton.icon(
                onPressed: () => _duplicateWorkflow(workflow),
                icon: const Icon(Icons.copy, size: 16),
                label: const Text('Duplicate'),
                style: TextButton.styleFrom(
                  foregroundColor: AppTheme.secondaryText,
                  minimumSize: Size(0, 4.h),
                ),
              ),
              const Spacer(),
              TextButton.icon(
                onPressed: () => _deleteWorkflow(workflow),
                icon: const Icon(Icons.delete, size: 16),
                label: const Text('Delete'),
                style: TextButton.styleFrom(
                  foregroundColor: AppTheme.error,
                  minimumSize: Size(0, 4.h),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatistic(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: AppTheme.secondaryText,
          ),
        ),
        Text(
          value,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  Widget _buildQuickTemplates() {
    final templates = [
      {
        'name': 'Lead Nurturing',
        'description': 'Automated email sequence for new leads',
        'icon': Icons.email,
        'color': AppTheme.accent,
      },
      {
        'name': 'Deal Alerts',
        'description': 'Notifications for deal stage changes',
        'icon': Icons.notifications,
        'color': AppTheme.warning,
      },
      {
        'name': 'Follow-up Reminders',
        'description': 'Automatic task creation for follow-ups',
        'icon': Icons.schedule,
        'color': AppTheme.success,
      },
      {
        'name': 'Lead Scoring',
        'description': 'Auto-update lead scores based on activities',
        'icon': Icons.star,
        'color': AppTheme.error,
      },
    ];
    
    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: const Color(0xFF191919),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppTheme.border.withAlpha(77)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Quick Templates',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 2.h),
          
          // Template grid
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 3.w,
              mainAxisSpacing: 2.h,
              childAspectRatio: 1.2,
            ),
            itemCount: templates.length,
            itemBuilder: (context, index) {
              final template = templates[index];
              return _buildTemplateCard(template);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildTemplateCard(Map<String, dynamic> template) {
    return GestureDetector(
      onTap: () => _useTemplate(template),
      child: Container(
        padding: EdgeInsets.all(3.w),
        decoration: BoxDecoration(
          color: AppTheme.surface,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: AppTheme.border.withAlpha(77)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: EdgeInsets.all(2.w),
              decoration: BoxDecoration(
                color: (template['color'] as Color).withAlpha(26),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                template['icon'] as IconData,
                color: template['color'] as Color,
                size: 20,
              ),
            ),
            SizedBox(height: 2.h),
            Text(
              template['name'] as String,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 1.h),
            Text(
              template['description'] as String,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: AppTheme.secondaryText,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  String _formatTimestamp(DateTime timestamp) {
    final now = DateTime.now();
    final diff = now.difference(timestamp);
    
    if (diff.inMinutes < 60) {
      return '${diff.inMinutes}m ago';
    } else if (diff.inHours < 24) {
      return '${diff.inHours}h ago';
    } else {
      return '${diff.inDays}d ago';
    }
  }

  void _editWorkflow(Map<String, dynamic> workflow) {
    // Handle workflow editing
  }

  void _duplicateWorkflow(Map<String, dynamic> workflow) {
    // Handle workflow duplication
  }

  void _deleteWorkflow(Map<String, dynamic> workflow) {
    setState(() {
      _workflows.remove(workflow);
    });
  }

  void _useTemplate(Map<String, dynamic> template) {
    // Handle template usage
    widget.onCreateWorkflow();
  }
}