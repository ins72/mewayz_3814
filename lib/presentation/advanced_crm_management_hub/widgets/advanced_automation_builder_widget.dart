
import '../../../core/app_export.dart';

class AdvancedAutomationBuilderWidget extends StatefulWidget {
  final Function(Map<String, dynamic>) onSave;

  const AdvancedAutomationBuilderWidget({
    Key? key,
    required this.onSave,
  }) : super(key: key);

  @override
  State<AdvancedAutomationBuilderWidget> createState() => _AdvancedAutomationBuilderWidgetState();
}

class _AdvancedAutomationBuilderWidgetState extends State<AdvancedAutomationBuilderWidget> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  
  String _selectedTrigger = 'contact_created';
  String _selectedAction = 'send_email';
  List<Map<String, dynamic>> _conditions = [];
  List<Map<String, dynamic>> _actions = [];

  final List<Map<String, String>> _triggerOptions = [
    {'value': 'contact_created', 'label': 'Contact Created'},
    {'value': 'deal_stage_changed', 'label': 'Deal Stage Changed'},
    {'value': 'lead_score_updated', 'label': 'Lead Score Updated'},
    {'value': 'activity_completed', 'label': 'Activity Completed'},
    {'value': 'email_opened', 'label': 'Email Opened'},
    {'value': 'form_submitted', 'label': 'Form Submitted'},
  ];

  final List<Map<String, String>> _actionOptions = [
    {'value': 'send_email', 'label': 'Send Email'},
    {'value': 'create_task', 'label': 'Create Task'},
    {'value': 'update_stage', 'label': 'Update Stage'},
    {'value': 'assign_owner', 'label': 'Assign Owner'},
    {'value': 'add_tag', 'label': 'Add Tag'},
    {'value': 'send_notification', 'label': 'Send Notification'},
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 80.h,
      decoration: BoxDecoration(
        color: AppTheme.surface,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
        border: Border.all(color: AppTheme.border.withAlpha(77)),
      ),
      child: Column(
        children: [
          // Header
          Container(
            padding: EdgeInsets.all(4.w),
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(color: AppTheme.border.withAlpha(51)),
              ),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.precision_manufacturing,
                  color: AppTheme.accent,
                  size: 24,
                ),
                SizedBox(width: 3.w),
                Text(
                  'Automation Builder',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const Spacer(),
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.close, color: AppTheme.secondaryText),
                ),
              ],
            ),
          ),
          
          // Content
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(4.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Basic info
                  _buildSection('Basic Information', [
                    _buildTextField(
                      'Workflow Name',
                      _nameController,
                      'Enter workflow name',
                    ),
                    SizedBox(height: 2.h),
                    _buildTextField(
                      'Description',
                      _descriptionController,
                      'Describe what this workflow does',
                      maxLines: 3,
                    ),
                  ]),
                  
                  SizedBox(height: 3.h),
                  
                  // Trigger configuration
                  _buildSection('Trigger', [
                    _buildDropdown(
                      'When this happens',
                      _selectedTrigger,
                      _triggerOptions,
                      (value) => setState(() => _selectedTrigger = value),
                    ),
                  ]),
                  
                  SizedBox(height: 3.h),
                  
                  // Conditions
                  _buildSection('Conditions', [
                    Text(
                      'Add conditions to filter when this workflow runs',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: AppTheme.secondaryText,
                      ),
                    ),
                    SizedBox(height: 2.h),
                    ..._conditions.map((condition) => _buildConditionCard(condition)),
                    SizedBox(height: 2.h),
                    _buildAddButton('Add Condition', () => _addCondition()),
                  ]),
                  
                  SizedBox(height: 3.h),
                  
                  // Actions
                  _buildSection('Actions', [
                    Text(
                      'Define what happens when conditions are met',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: AppTheme.secondaryText,
                      ),
                    ),
                    SizedBox(height: 2.h),
                    ..._actions.map((action) => _buildActionCard(action)),
                    SizedBox(height: 2.h),
                    _buildAddButton('Add Action', () => _addAction()),
                  ]),
                  
                  SizedBox(height: 4.h),
                  
                  // Preview
                  _buildSection('Preview', [
                    Container(
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
                            'Workflow Preview',
                            style: Theme.of(context).textTheme.titleSmall?.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          SizedBox(height: 2.h),
                          _buildPreviewFlow(),
                        ],
                      ),
                    ),
                  ]),
                ],
              ),
            ),
          ),
          
          // Save button
          Container(
            padding: EdgeInsets.all(4.w),
            decoration: BoxDecoration(
              border: Border(
                top: BorderSide(color: AppTheme.border.withAlpha(51)),
              ),
            ),
            child: ElevatedButton(
              onPressed: _saveWorkflow,
              style: ElevatedButton.styleFrom(
                minimumSize: Size(double.infinity, 6.h),
              ),
              child: const Text('Save Workflow'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSection(String title, List<Widget> children) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: 2.h),
        ...children,
      ],
    );
  }

  Widget _buildTextField(
    String label,
    TextEditingController controller,
    String hint, {
    int maxLines = 1,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(height: 1.h),
        TextField(
          controller: controller,
          maxLines: maxLines,
          decoration: InputDecoration(
            hintText: hint,
            filled: true,
            fillColor: const Color(0xFF191919),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: AppTheme.border.withAlpha(77)),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: AppTheme.border.withAlpha(77)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: AppTheme.accent),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDropdown(
    String label,
    String value,
    List<Map<String, String>> options,
    Function(String) onChanged,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(height: 1.h),
        Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(horizontal: 4.w),
          decoration: BoxDecoration(
            color: const Color(0xFF191919),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppTheme.border.withAlpha(77)),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: value,
              dropdownColor: AppTheme.surface,
              onChanged: (newValue) => onChanged(newValue!),
              items: options.map<DropdownMenuItem<String>>((option) {
                return DropdownMenuItem<String>(
                  value: option['value'],
                  child: Text(
                    option['label']!,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                );
              }).toList(),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildConditionCard(Map<String, dynamic> condition) {
    return Container(
      margin: EdgeInsets.only(bottom: 2.h),
      padding: EdgeInsets.all(3.w),
      decoration: BoxDecoration(
        color: const Color(0xFF191919),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppTheme.border.withAlpha(77)),
      ),
      child: Row(
        children: [
          Icon(
            Icons.filter_alt,
            color: AppTheme.accent,
            size: 20,
          ),
          SizedBox(width: 3.w),
          Expanded(
            child: Text(
              condition['description'] ?? 'Condition',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ),
          IconButton(
            onPressed: () => _removeCondition(condition),
            icon: const Icon(Icons.remove_circle, color: AppTheme.error),
          ),
        ],
      ),
    );
  }

  Widget _buildActionCard(Map<String, dynamic> action) {
    return Container(
      margin: EdgeInsets.only(bottom: 2.h),
      padding: EdgeInsets.all(3.w),
      decoration: BoxDecoration(
        color: const Color(0xFF191919),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppTheme.border.withAlpha(77)),
      ),
      child: Row(
        children: [
          Icon(
            Icons.play_arrow,
            color: AppTheme.success,
            size: 20,
          ),
          SizedBox(width: 3.w),
          Expanded(
            child: Text(
              action['description'] ?? 'Action',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ),
          IconButton(
            onPressed: () => _removeAction(action),
            icon: const Icon(Icons.remove_circle, color: AppTheme.error),
          ),
        ],
      ),
    );
  }

  Widget _buildAddButton(String label, VoidCallback onPressed) {
    return SizedBox(
      width: double.infinity,
      child: OutlinedButton.icon(
        onPressed: onPressed,
        icon: const Icon(Icons.add),
        label: Text(label),
        style: OutlinedButton.styleFrom(
          minimumSize: Size(0, 6.h),
          side: BorderSide(color: AppTheme.border),
        ),
      ),
    );
  }

  Widget _buildPreviewFlow() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Trigger
        _buildPreviewItem(
          'Trigger',
          _triggerOptions.firstWhere(
            (option) => option['value'] == _selectedTrigger,
            orElse: () => {'label': 'Unknown'},
          )['label']!,
          AppTheme.accent,
          Icons.play_arrow,
        ),
        
        // Conditions
        if (_conditions.isNotEmpty) ...[
          SizedBox(height: 2.h),
          _buildPreviewItem(
            'Conditions',
            '${_conditions.length} condition(s)',
            AppTheme.warning,
            Icons.filter_alt,
          ),
        ],
        
        // Actions
        if (_actions.isNotEmpty) ...[
          SizedBox(height: 2.h),
          _buildPreviewItem(
            'Actions',
            '${_actions.length} action(s)',
            AppTheme.success,
            Icons.play_circle,
          ),
        ],
      ],
    );
  }

  Widget _buildPreviewItem(String label, String value, Color color, IconData icon) {
    return Row(
      children: [
        Container(
          padding: EdgeInsets.all(2.w),
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
        SizedBox(width: 3.w),
        Column(
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
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ],
    );
  }

  void _addCondition() {
    setState(() {
      _conditions.add({
        'id': DateTime.now().millisecondsSinceEpoch.toString(),
        'description': 'Lead score is greater than 50',
        'field': 'leadScore',
        'operator': 'greater_than',
        'value': '50',
      });
    });
  }

  void _removeCondition(Map<String, dynamic> condition) {
    setState(() {
      _conditions.remove(condition);
    });
  }

  void _addAction() {
    setState(() {
      _actions.add({
        'id': DateTime.now().millisecondsSinceEpoch.toString(),
        'description': 'Send welcome email',
        'type': 'send_email',
        'template': 'welcome_email',
      });
    });
  }

  void _removeAction(Map<String, dynamic> action) {
    setState(() {
      _actions.remove(action);
    });
  }

  void _saveWorkflow() {
    final workflow = {
      'name': _nameController.text,
      'description': _descriptionController.text,
      'trigger': _selectedTrigger,
      'conditions': _conditions,
      'actions': _actions,
      'isActive': true,
      'createdAt': DateTime.now().toIso8601String(),
    };
    
    widget.onSave(workflow);
    Navigator.pop(context);
  }
}