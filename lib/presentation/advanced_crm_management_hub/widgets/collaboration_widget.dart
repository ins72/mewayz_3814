
import '../../../core/app_export.dart';

class CollaborationWidget extends StatefulWidget {
  final List<Map<String, dynamic>> contacts;
  final Function(Map<String, dynamic>) onUpdate;

  const CollaborationWidget({
    Key? key,
    required this.contacts,
    required this.onUpdate,
  }) : super(key: key);

  @override
  State<CollaborationWidget> createState() => _CollaborationWidgetState();
}

class _CollaborationWidgetState extends State<CollaborationWidget>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  final List<Map<String, dynamic>> _teamMembers = [
{ 'id': '1',
'name': 'John Smith',
'role': 'Sales Manager',
'avatar': 'https://images.unsplash.com/photo-1472099645785-5658abf4ff4e?w=400&h=400&fit=crop&crop=face',
'status': 'online',
'activeContacts': 15,
'lastSeen': DateTime.now().subtract(const Duration(minutes: 5)),
},
{ 'id': '2',
'name': 'Emma Davis',
'role': 'Sales Rep',
'avatar': 'https://images.unsplash.com/photo-1494790108755-2616b84cc2fa?w=400&h=400&fit=crop&crop=face',
'status': 'online',
'activeContacts': 12,
'lastSeen': DateTime.now().subtract(const Duration(minutes: 2)),
},
{ 'id': '3',
'name': 'Michael Brown',
'role': 'Account Executive',
'avatar': 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=400&h=400&fit=crop&crop=face',
'status': 'away',
'activeContacts': 8,
'lastSeen': DateTime.now().subtract(const Duration(hours: 1)),
},
];

  final List<Map<String, dynamic>> _recentActivities = [
{ 'id': '1',
'user': 'John Smith',
'action': 'updated lead score for',
'contact': 'Sarah Johnson',
'timestamp': DateTime.now().subtract(const Duration(minutes: 10)),
'type': 'update',
},
{ 'id': '2',
'user': 'Emma Davis',
'action': 'scheduled demo with',
'contact': 'Michael Chen',
'timestamp': DateTime.now().subtract(const Duration(minutes: 25)),
'type': 'schedule',
},
{ 'id': '3',
'user': 'Michael Brown',
'action': 'sent proposal to',
'contact': 'Emily Rodriguez',
'timestamp': DateTime.now().subtract(const Duration(hours: 1)),
'type': 'communication',
},
];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 75.h,
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
                  Icons.people,
                  color: AppTheme.accent,
                  size: 24,
                ),
                SizedBox(width: 3.w),
                Text(
                  'Team Collaboration',
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
              tabs: const [
                Tab(text: 'Team'),
                Tab(text: 'Activity'),
                Tab(text: 'Assignments'),
              ],
            ),
          ),
          
          // Tab content
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildTeamTab(),
                _buildActivityTab(),
                _buildAssignmentsTab(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTeamTab() {
    return ListView.builder(
      padding: EdgeInsets.all(4.w),
      itemCount: _teamMembers.length,
      itemBuilder: (context, index) {
        final member = _teamMembers[index];
        return _buildTeamMemberCard(member);
      },
    );
  }

  Widget _buildTeamMemberCard(Map<String, dynamic> member) {
    return Container(
      margin: EdgeInsets.only(bottom: 3.h),
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: const Color(0xFF191919),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppTheme.border.withAlpha(77)),
      ),
      child: Row(
        children: [
          // Avatar with status indicator
          Stack(
            children: [
              Container(
                width: 15.w,
                height: 15.w,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: AppTheme.border),
                ),
                child: ClipOval(
                  child: CachedNetworkImage(
                    imageUrl: member['avatar'] ?? '',
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
              Positioned(
                bottom: 0,
                right: 0,
                child: Container(
                  width: 4.w,
                  height: 4.w,
                  decoration: BoxDecoration(
                    color: _getStatusColor(member['status']),
                    shape: BoxShape.circle,
                    border: Border.all(color: AppTheme.surface, width: 2),
                  ),
                ),
              ),
            ],
          ),
          
          SizedBox(width: 3.w),
          
          // Member info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  member['name'] ?? '',
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  member['role'] ?? '',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppTheme.secondaryText,
                  ),
                ),
                SizedBox(height: 1.h),
                Row(
                  children: [
                    Icon(
                      Icons.person_outline,
                      color: AppTheme.accent,
                      size: 14,
                    ),
                    SizedBox(width: 1.w),
                    Text(
                      '${member['activeContacts']} active contacts',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppTheme.accent,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          
          // Actions
          Column(
            children: [
              IconButton(
                onPressed: () => _startCollaboration(member),
                icon: const Icon(Icons.message, color: AppTheme.accent),
              ),
              IconButton(
                onPressed: () => _assignContact(member),
                icon: const Icon(Icons.assignment, color: AppTheme.success),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildActivityTab() {
    return ListView.builder(
      padding: EdgeInsets.all(4.w),
      itemCount: _recentActivities.length,
      itemBuilder: (context, index) {
        final activity = _recentActivities[index];
        return _buildActivityCard(activity);
      },
    );
  }

  Widget _buildActivityCard(Map<String, dynamic> activity) {
    return Container(
      margin: EdgeInsets.only(bottom: 2.h),
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: const Color(0xFF191919),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppTheme.border.withAlpha(77)),
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(2.w),
            decoration: BoxDecoration(
              color: _getActivityTypeColor(activity['type']).withAlpha(26),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              _getActivityTypeIcon(activity['type']),
              color: _getActivityTypeColor(activity['type']),
              size: 16,
            ),
          ),
          
          SizedBox(width: 3.w),
          
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                RichText(
                  text: TextSpan(
                    style: Theme.of(context).textTheme.bodyMedium,
                    children: [
                      TextSpan(
                        text: activity['user'],
                        style: const TextStyle(
                          color: AppTheme.accent,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      TextSpan(
                        text: ' ${activity['action']} ',
                        style: const TextStyle(color: AppTheme.primaryText),
                      ),
                      TextSpan(
                        text: activity['contact'],
                        style: const TextStyle(
                          color: AppTheme.success,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 1.h),
                Text(
                  _formatTimestamp(activity['timestamp']),
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppTheme.secondaryText,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAssignmentsTab() {
    return Padding(
      padding: EdgeInsets.all(4.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Quick Assignments',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 2.h),
          
          // Assignment actions
          _buildAssignmentAction(
            'Bulk Assign Contacts',
            'Assign multiple contacts to team members',
            Icons.assignment_ind,
            () => _bulkAssignContacts(),
          ),
          
          SizedBox(height: 2.h),
          
          _buildAssignmentAction(
            'Load Balance',
            'Distribute contacts evenly among team',
            Icons.balance,
            () => _loadBalanceContacts(),
          ),
          
          SizedBox(height: 2.h),
          
          _buildAssignmentAction(
            'Territory Assignment',
            'Assign based on geographic territories',
            Icons.map,
            () => _territoryAssignment(),
          ),
          
          SizedBox(height: 3.h),
          
          Text(
            'Current Assignments',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 2.h),
          
          // Assignment summary
          Expanded(
            child: ListView.builder(
              itemCount: _teamMembers.length,
              itemBuilder: (context, index) {
                final member = _teamMembers[index];
                return _buildAssignmentSummary(member);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAssignmentAction(
    String title,
    String description,
    IconData icon,
    VoidCallback onTap,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(4.w),
        decoration: BoxDecoration(
          color: const Color(0xFF191919),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppTheme.border.withAlpha(77)),
        ),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(3.w),
              decoration: BoxDecoration(
                color: AppTheme.accent.withAlpha(26),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                icon,
                color: AppTheme.accent,
                size: 20,
              ),
            ),
            SizedBox(width: 3.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    description,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: AppTheme.secondaryText,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(Icons.chevron_right, color: AppTheme.secondaryText),
          ],
        ),
      ),
    );
  }

  Widget _buildAssignmentSummary(Map<String, dynamic> member) {
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
          Container(
            width: 10.w,
            height: 10.w,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: AppTheme.border),
            ),
            child: ClipOval(
              child: CachedNetworkImage(
                imageUrl: member['avatar'] ?? '',
                fit: BoxFit.cover,
                placeholder: (context, url) => Container(
                  color: AppTheme.surface,
                  child: Icon(
                    Icons.person,
                    color: AppTheme.secondaryText,
                    size: 4.w,
                  ),
                ),
                errorWidget: (context, url, error) => Container(
                  color: AppTheme.surface,
                  child: Icon(
                    Icons.person,
                    color: AppTheme.secondaryText,
                    size: 4.w,
                  ),
                ),
              ),
            ),
          ),
          SizedBox(width: 3.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  member['name'] ?? '',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  '${member['activeContacts']} contacts assigned',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppTheme.secondaryText,
                  ),
                ),
              ],
            ),
          ),
          Text(
            '${((member['activeContacts'] / 35) * 100).toInt()}%',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: AppTheme.success,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Color _getStatusColor(String? status) {
    switch (status?.toLowerCase()) {
      case 'online':
        return AppTheme.success;
      case 'away':
        return AppTheme.warning;
      case 'busy':
        return AppTheme.error;
      default:
        return AppTheme.secondaryText;
    }
  }

  Color _getActivityTypeColor(String? type) {
    switch (type?.toLowerCase()) {
      case 'update':
        return AppTheme.accent;
      case 'schedule':
        return AppTheme.success;
      case 'communication':
        return AppTheme.warning;
      default:
        return AppTheme.secondaryText;
    }
  }

  IconData _getActivityTypeIcon(String? type) {
    switch (type?.toLowerCase()) {
      case 'update':
        return Icons.update;
      case 'schedule':
        return Icons.schedule;
      case 'communication':
        return Icons.message;
      default:
        return Icons.event;
    }
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

  void _startCollaboration(Map<String, dynamic> member) {
    // Handle collaboration start
  }

  void _assignContact(Map<String, dynamic> member) {
    // Handle contact assignment
  }

  void _bulkAssignContacts() {
    // Handle bulk assignment
  }

  void _loadBalanceContacts() {
    // Handle load balancing
  }

  void _territoryAssignment() {
    // Handle territory assignment
  }
}