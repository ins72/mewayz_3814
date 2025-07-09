
import '../../../core/app_export.dart';

class AdvancedContactDetailWidget extends StatefulWidget {
  final Map<String, dynamic> contact;
  final Function(Map<String, dynamic>) onUpdate;

  const AdvancedContactDetailWidget({
    Key? key,
    required this.contact,
    required this.onUpdate,
  }) : super(key: key);

  @override
  State<AdvancedContactDetailWidget> createState() => _AdvancedContactDetailWidgetState();
}

class _AdvancedContactDetailWidgetState extends State<AdvancedContactDetailWidget>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late Map<String, dynamic> _contactData;
  bool _isEditing = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    _contactData = Map<String, dynamic>.from(widget.contact);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

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
                // Avatar
                Container(
                  width: 15.w,
                  height: 15.w,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: AppTheme.border),
                  ),
                  child: ClipOval(
                    child: CachedNetworkImage(
                      imageUrl: _contactData['profileImage'] ?? '',
                      fit: BoxFit.cover,
                      placeholder: (context, url) => Container(
                        color: AppTheme.surface,
                        child: Icon(
                          Icons.person,
                          color: AppTheme.secondaryText,
                          size: 6.w,
                        ),
                      ),
                      errorWidget: (context, url, error) => Container(
                        color: AppTheme.surface,
                        child: Icon(
                          Icons.person,
                          color: AppTheme.secondaryText,
                          size: 6.w,
                        ),
                      ),
                    ),
                  ),
                ),
                
                SizedBox(width: 3.w),
                
                // Contact info
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              _contactData['name'] ?? '',
                              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.5.h),
                            decoration: BoxDecoration(
                              color: _getPriorityColor(_contactData['priority']).withAlpha(26),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              _contactData['priority']?.toString().toUpperCase() ?? '',
                              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                color: _getPriorityColor(_contactData['priority']),
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                      Text(
                        _contactData['company'] ?? '',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: AppTheme.secondaryText,
                        ),
                      ),
                      Row(
                        children: [
                          Icon(
                            Icons.star,
                            color: AppTheme.warning,
                            size: 16,
                          ),
                          SizedBox(width: 1.w),
                          Text(
                            'Score: ${_contactData['leadScore']}',
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: AppTheme.warning,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                
                // Actions
                IconButton(
                  onPressed: () {
                    setState(() {
                      _isEditing = !_isEditing;
                    });
                  },
                  icon: Icon(
                    _isEditing ? Icons.save : Icons.edit,
                    color: AppTheme.accent,
                  ),
                ),
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.close, color: AppTheme.secondaryText),
                ),
              ],
            ),
          ),
          
          // Tab bar
          Container(
            decoration: BoxDecoration(
              color: const Color(0xFF191919),
              border: Border(
                bottom: BorderSide(color: AppTheme.border.withAlpha(51)),
              ),
            ),
            child: TabBar(
              controller: _tabController,
              indicatorColor: AppTheme.accent,
              labelColor: AppTheme.primaryText,
              unselectedLabelColor: AppTheme.secondaryText,
              labelStyle: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
              tabs: const [
                Tab(text: 'Details'),
                Tab(text: 'Activity'),
                Tab(text: 'Notes'),
                Tab(text: 'Tasks'),
              ],
            ),
          ),
          
          // Tab content
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildDetailsTab(),
                _buildActivityTab(),
                _buildNotesTab(),
                _buildTasksTab(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailsTab() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(4.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildDetailCard('Contact Information', [
            _buildDetailItem('Email', _contactData['email'], Icons.email),
            _buildDetailItem('Phone', _contactData['phone'], Icons.phone),
            _buildDetailItem('Company', _contactData['company'], Icons.business),
            _buildDetailItem('Source', _contactData['source'], Icons.source),
          ]),
          
          SizedBox(height: 3.h),
          
          _buildDetailCard('Deal Information', [
            _buildDetailItem('Stage', _contactData['stage'], Icons.timeline),
            _buildDetailItem('Value', '\$${_contactData['value']?.toString() ?? '0'}', Icons.attach_money),
            _buildDetailItem('Lead Score', '${_contactData['leadScore']}', Icons.star),
            _buildDetailItem('Probability', '${(_contactData['conversionProbability'] ?? 0) * 100}%', Icons.trending_up),
          ]),
          
          SizedBox(height: 3.h),
          
          _buildDetailCard('Tags', [
            Wrap(
              spacing: 2.w,
              runSpacing: 1.h,
              children: (_contactData['tags'] as List<dynamic>? ?? []).map((tag) {
                return Container(
                  padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
                  decoration: BoxDecoration(
                    color: AppTheme.accent.withAlpha(26),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: AppTheme.accent.withAlpha(77)),
                  ),
                  child: Text(
                    tag.toString(),
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: AppTheme.accent,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                );
              }).toList(),
            ),
          ]),
        ],
      ),
    );
  }

  Widget _buildActivityTab() {
    final activities = _contactData['activities'] as List<dynamic>? ?? [];
    
    return ListView.builder(
      padding: EdgeInsets.all(4.w),
      itemCount: activities.length,
      itemBuilder: (context, index) {
        final activity = activities[index];
        return Container(
          margin: EdgeInsets.only(bottom: 3.h),
          padding: EdgeInsets.all(4.w),
          decoration: BoxDecoration(
            color: const Color(0xFF191919),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppTheme.border.withAlpha(77)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: EdgeInsets.all(2.w),
                    decoration: BoxDecoration(
                      color: _getActivityColor(activity['type']).withAlpha(26),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      _getActivityIcon(activity['type']),
                      color: _getActivityColor(activity['type']),
                      size: 16,
                    ),
                  ),
                  SizedBox(width: 3.w),
                  Expanded(
                    child: Text(
                      activity['title'] ?? '',
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  Text(
                    _formatTimestamp(activity['timestamp']),
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: AppTheme.secondaryText,
                    ),
                  ),
                ],
              ),
              if (activity['outcome'] != null) ...[
                SizedBox(height: 2.h),
                Text(
                  activity['outcome'],
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppTheme.secondaryText,
                  ),
                ),
              ],
            ],
          ),
        );
      },
    );
  }

  Widget _buildNotesTab() {
    return Padding(
      padding: EdgeInsets.all(4.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
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
                  'Notes',
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: 2.h),
                Text(
                  _contactData['notes'] ?? 'No notes available',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppTheme.secondaryText,
                  ),
                ),
              ],
            ),
          ),
          
          SizedBox(height: 3.h),
          
          ElevatedButton.icon(
            onPressed: () {
              // Add note functionality
            },
            icon: const Icon(Icons.add),
            label: const Text('Add Note'),
            style: ElevatedButton.styleFrom(
              minimumSize: Size(double.infinity, 6.h),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTasksTab() {
    return Padding(
      padding: EdgeInsets.all(4.w),
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.all(4.w),
            decoration: BoxDecoration(
              color: const Color(0xFF191919),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppTheme.border.withAlpha(77)),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.task_alt,
                  color: AppTheme.accent,
                  size: 20,
                ),
                SizedBox(width: 3.w),
                Expanded(
                  child: Text(
                    _contactData['nextAction'] ?? 'No next action',
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
          
          SizedBox(height: 3.h),
          
          ElevatedButton.icon(
            onPressed: () {
              // Add task functionality
            },
            icon: const Icon(Icons.add_task),
            label: const Text('Add Task'),
            style: ElevatedButton.styleFrom(
              minimumSize: Size(double.infinity, 6.h),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailCard(String title, List<Widget> children) {
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
            title,
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 2.h),
          ...children,
        ],
      ),
    );
  }

  Widget _buildDetailItem(String label, String value, IconData icon) {
    return Padding(
      padding: EdgeInsets.only(bottom: 2.h),
      child: Row(
        children: [
          Icon(
            icon,
            color: AppTheme.secondaryText,
            size: 16,
          ),
          SizedBox(width: 3.w),
          Text(
            '$label: ',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: AppTheme.secondaryText,
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Color _getPriorityColor(String? priority) {
    switch (priority?.toLowerCase()) {
      case 'high':
        return AppTheme.error;
      case 'medium':
        return AppTheme.warning;
      case 'low':
        return AppTheme.success;
      default:
        return AppTheme.secondaryText;
    }
  }

  Color _getActivityColor(String? type) {
    switch (type?.toLowerCase()) {
      case 'meeting':
        return AppTheme.accent;
      case 'call':
        return AppTheme.success;
      case 'email':
        return AppTheme.warning;
      case 'demo':
        return AppTheme.accent;
      default:
        return AppTheme.secondaryText;
    }
  }

  IconData _getActivityIcon(String? type) {
    switch (type?.toLowerCase()) {
      case 'meeting':
        return Icons.meeting_room;
      case 'call':
        return Icons.phone;
      case 'email':
        return Icons.email;
      case 'demo':
        return Icons.play_circle;
      default:
        return Icons.event;
    }
  }

  String _formatTimestamp(dynamic timestamp) {
    if (timestamp is DateTime) {
      final now = DateTime.now();
      final diff = now.difference(timestamp);
      
      if (diff.inHours < 24) {
        return '${diff.inHours}h ago';
      } else {
        return '${diff.inDays}d ago';
      }
    }
    return '';
  }
}