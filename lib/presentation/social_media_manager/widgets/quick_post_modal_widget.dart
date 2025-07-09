
import '../../../core/app_export.dart';

class QuickPostModalWidget extends StatefulWidget {
  const QuickPostModalWidget({Key? key}) : super(key: key);

  @override
  State<QuickPostModalWidget> createState() => _QuickPostModalWidgetState();
}

class _QuickPostModalWidgetState extends State<QuickPostModalWidget> {
  final TextEditingController _contentController = TextEditingController();
  final List<String> _selectedPlatforms = [];
  bool _schedulePost = false;
  DateTime _scheduledTime = DateTime.now().add(const Duration(hours: 1));

  @override
  void dispose() {
    _contentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.surface,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              margin: const EdgeInsets.only(top: 8),
              decoration: BoxDecoration(
                color: AppTheme.border,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        'Quick Post',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const Spacer(),
                      IconButton(
                        onPressed: () => Navigator.pop(context),
                        icon: const Icon(Icons.close_rounded),
                      ),
                    ],
                  ),
                  SizedBox(height: 16.h),
                  Text(
                    'Select Platforms',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w500,
                        ),
                  ),
                  SizedBox(height: 8.h),
                  _buildPlatformSelector(),
                  SizedBox(height: 16.h),
                  Text(
                    'Content',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w500,
                        ),
                  ),
                  SizedBox(height: 8.h),
                  TextField(
                    controller: _contentController,
                    maxLines: 4,
                    decoration: const InputDecoration(
                      hintText: 'What\'s on your mind?',
                    ),
                  ),
                  SizedBox(height: 16.h),
                  Row(
                    children: [
                      Switch(
                        value: _schedulePost,
                        onChanged: (value) {
                          setState(() {
                            _schedulePost = value;
                          });
                        },
                      ),
                      SizedBox(width: 8.w),
                      Text(
                        'Schedule Post',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ],
                  ),
                  if (_schedulePost) ...[
                    SizedBox(height: 12.h),
                    ListTile(
                      leading:
                          Icon(Icons.schedule_rounded, color: AppTheme.accent),
                      title: Text('Schedule for'),
                      subtitle: Text(
                        '${_scheduledTime.day}/${_scheduledTime.month}/${_scheduledTime.year} at ${_scheduledTime.hour}:${_scheduledTime.minute.toString().padLeft(2, '0')}',
                      ),
                      trailing: Icon(Icons.arrow_forward_ios_rounded, size: 16),
                      onTap: () async {
                        final date = await showDatePicker(
                          context: context,
                          initialDate: _scheduledTime,
                          firstDate: DateTime.now(),
                          lastDate:
                              DateTime.now().add(const Duration(days: 365)),
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
                  ],
                  SizedBox(height: 24.h),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text('Cancel'),
                        ),
                      ),
                      SizedBox(width: 12.w),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: _selectedPlatforms.isNotEmpty &&
                                  _contentController.text.isNotEmpty
                              ? () {
                                  // Handle post creation
                                  Navigator.pop(context);
                                }
                              : null,
                          child: Text(_schedulePost ? 'Schedule' : 'Post Now'),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPlatformSelector() {
    final platforms = [
      {'name': 'Instagram', 'icon': Icons.camera_alt_rounded},
      {'name': 'Facebook', 'icon': Icons.facebook_rounded},
      {'name': 'Twitter', 'icon': Icons.alternate_email_rounded},
      {'name': 'LinkedIn', 'icon': Icons.work_rounded},
    ];

    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: platforms.map((platform) {
        final isSelected = _selectedPlatforms.contains(platform['name']);
        return FilterChip(
          label: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                platform['icon'] as IconData,
                size: 16,
                color: isSelected
                    ? AppTheme.primaryAction
                    : AppTheme.secondaryText,
              ),
              SizedBox(width: 6.w),
              Text(platform['name'] as String),
            ],
          ),
          selected: isSelected,
          onSelected: (selected) {
            setState(() {
              if (selected) {
                _selectedPlatforms.add(platform['name'] as String);
              } else {
                _selectedPlatforms.remove(platform['name']);
              }
            });
          },
          selectedColor: AppTheme.accent,
          backgroundColor: AppTheme.primaryBackground,
          labelStyle: TextStyle(
            color: isSelected ? AppTheme.primaryAction : AppTheme.primaryText,
          ),
        );
      }).toList(),
    );
  }
}