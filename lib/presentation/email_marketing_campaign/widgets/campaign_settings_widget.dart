
import '../../../core/app_export.dart';

class CampaignSettingsWidget extends StatefulWidget {
  const CampaignSettingsWidget({Key? key}) : super(key: key);

  @override
  State<CampaignSettingsWidget> createState() => _CampaignSettingsWidgetState();
}

class _CampaignSettingsWidgetState extends State<CampaignSettingsWidget> {
  final TextEditingController _campaignNameController = TextEditingController();
  final TextEditingController _fromNameController = TextEditingController();
  final TextEditingController _fromEmailController = TextEditingController();
  final TextEditingController _replyToController = TextEditingController();

  bool _enableAbTesting = false;
  bool _enableSendTimeOptimization = false;
  bool _enableDeliveryTracking = true;
  String _selectedTimezone = 'UTC';
  DateTime _scheduledTime = DateTime.now();

  @override
  void dispose() {
    _campaignNameController.dispose();
    _fromNameController.dispose();
    _fromEmailController.dispose();
    _replyToController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              Icons.settings_outlined,
              color: AppTheme.accent,
              size: 20,
            ),
            SizedBox(width: 8.w),
            Text(
              'Campaign Settings',
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ],
        ),
        SizedBox(height: 16.h),
        _buildBasicSettings(),
        SizedBox(height: 16.h),
        _buildSenderSettings(),
        SizedBox(height: 16.h),
        _buildDeliverySettings(),
        SizedBox(height: 16.h),
        _buildAdvancedSettings(),
      ],
    );
  }

  Widget _buildBasicSettings() {
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
            'Basic Settings',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w500,
                ),
          ),
          SizedBox(height: 12.h),
          TextField(
            controller: _campaignNameController,
            decoration: const InputDecoration(
              labelText: 'Campaign Name',
              hintText: 'Enter campaign name',
            ),
          ),
          SizedBox(height: 12.h),
          DropdownButtonFormField<String>(
            value: _selectedTimezone,
            decoration: const InputDecoration(
              labelText: 'Timezone',
            ),
            items: [
              'UTC',
              'EST',
              'PST',
              'CST',
              'MST',
            ].map((timezone) {
              return DropdownMenuItem(
                value: timezone,
                child: Text(timezone),
              );
            }).toList(),
            onChanged: (value) {
              setState(() {
                _selectedTimezone = value!;
              });
            },
          ),
        ],
      ),
    );
  }

  Widget _buildSenderSettings() {
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
            'Sender Information',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w500,
                ),
          ),
          SizedBox(height: 12.h),
          TextField(
            controller: _fromNameController,
            decoration: const InputDecoration(
              labelText: 'From Name',
              hintText: 'Enter sender name',
            ),
          ),
          SizedBox(height: 12.h),
          TextField(
            controller: _fromEmailController,
            decoration: const InputDecoration(
              labelText: 'From Email',
              hintText: 'Enter sender email',
            ),
          ),
          SizedBox(height: 12.h),
          TextField(
            controller: _replyToController,
            decoration: const InputDecoration(
              labelText: 'Reply-To Email',
              hintText: 'Enter reply-to email',
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDeliverySettings() {
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
            'Delivery Settings',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w500,
                ),
          ),
          SizedBox(height: 12.h),
          ListTile(
            leading: Icon(Icons.schedule_rounded, color: AppTheme.accent),
            title: const Text('Schedule Delivery'),
            subtitle: Text(
              'Send at: ${_scheduledTime.day}/${_scheduledTime.month}/${_scheduledTime.year} ${_scheduledTime.hour}:${_scheduledTime.minute.toString().padLeft(2, '0')}',
            ),
            trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 16),
            onTap: () async {
              final date = await showDatePicker(
                context: context,
                initialDate: _scheduledTime,
                firstDate: DateTime.now(),
                lastDate: DateTime.now().add(const Duration(days: 365)),
              );
              if (date != null) {
                final time = await showTimePicker(
                  context: context,
                  initialTime: TimeOfDay.fromDateTime(_scheduledTime),
                );
                if (time != null) {
                  setState(() {
                    _scheduledTime = DateTime(
                      date.year,
                      date.month,
                      date.day,
                      time.hour,
                      time.minute,
                    );
                  });
                }
              }
            },
          ),
          SwitchListTile(
            title: const Text('Send Time Optimization'),
            subtitle: const Text('AI-powered optimal sending time'),
            value: _enableSendTimeOptimization,
            onChanged: (value) {
              setState(() {
                _enableSendTimeOptimization = value;
              });
            },
          ),
          SwitchListTile(
            title: const Text('Delivery Tracking'),
            subtitle: const Text('Track email delivery and engagement'),
            value: _enableDeliveryTracking,
            onChanged: (value) {
              setState(() {
                _enableDeliveryTracking = value;
              });
            },
          ),
        ],
      ),
    );
  }

  Widget _buildAdvancedSettings() {
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
            'Advanced Settings',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w500,
                ),
          ),
          SizedBox(height: 12.h),
          SwitchListTile(
            title: const Text('A/B Testing'),
            subtitle: const Text('Test different subject lines and content'),
            value: _enableAbTesting,
            onChanged: (value) {
              setState(() {
                _enableAbTesting = value;
              });
            },
          ),
          if (_enableAbTesting) ...[
            SizedBox(height: 12.h),
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
                    'A/B Test Configuration',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w500,
                        ),
                  ),
                  SizedBox(height: 8.h),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          'Test Type',
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ),
                      DropdownButton<String>(
                        value: 'Subject Line',
                        items: ['Subject Line', 'Content', 'Send Time']
                            .map((item) => DropdownMenuItem(
                                  value: item,
                                  child: Text(item),
                                ))
                            .toList(),
                        onChanged: (value) {},
                      ),
                    ],
                  ),
                  SizedBox(height: 8.h),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          'Test Size',
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ),
                      Text(
                        '20%',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: AppTheme.accent,
                            ),
                      ),
                    ],
                  ),
                  Slider(
                    value: 0.2,
                    min: 0.1,
                    max: 0.5,
                    divisions: 8,
                    label: '20%',
                    onChanged: (value) {},
                  ),
                ],
              ),
            ),
          ],
          SizedBox(height: 12.h),
          ExpansionTile(
            title: const Text('Custom Headers'),
            subtitle: const Text('Add custom email headers'),
            children: [
              Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            decoration: const InputDecoration(
                              labelText: 'Header Name',
                              hintText: 'X-Custom-Header',
                            ),
                          ),
                        ),
                        SizedBox(width: 12.w),
                        Expanded(
                          child: TextField(
                            decoration: const InputDecoration(
                              labelText: 'Header Value',
                              hintText: 'Header value',
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 12.h),
                    Align(
                      alignment: Alignment.centerRight,
                      child: ElevatedButton.icon(
                        onPressed: () {
                          // Add custom header
                        },
                        icon: const Icon(Icons.add_rounded),
                        label: const Text('Add Header'),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}