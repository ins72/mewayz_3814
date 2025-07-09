
import '../../../core/app_export.dart';

class ContactDetailWidget extends StatefulWidget {
  final Map<String, dynamic> contact;
  final Function(Map<String, dynamic>) onUpdate;

  const ContactDetailWidget({
    Key? key,
    required this.contact,
    required this.onUpdate,
  }) : super(key: key);

  @override
  State<ContactDetailWidget> createState() => _ContactDetailWidgetState();
}

class _ContactDetailWidgetState extends State<ContactDetailWidget>
    with TickerProviderStateMixin {
  late TabController _tabController;
  final TextEditingController _noteController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 90.h,
      decoration: BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        children: [
          _buildHeader(),
          _buildContactInfo(),
          _buildTabBar(),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildActivityTab(),
                _buildNotesTab(),
                _buildDetailsTab(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: AppTheme.border)),
      ),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: CustomIconWidget(
              iconName: 'close',
              color: AppTheme.secondaryText,
              size: 24,
            ),
          ),
          Expanded(
            child: Center(
              child: Text(
                'Contact Details',
                style: AppTheme.darkTheme.textTheme.titleLarge,
              ),
            ),
          ),
          GestureDetector(
            onTap: _showEditDialog,
            child: CustomIconWidget(
              iconName: 'edit',
              color: AppTheme.accent,
              size: 24,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContactInfo() {
    return Container(
      padding: EdgeInsets.all(4.w),
      child: Row(
        children: [
          Container(
            width: 16.w,
            height: 16.w,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: AppTheme.border),
            ),
            child: ClipOval(
              child: widget.contact['profileImage'] != null
                  ? CustomImageWidget(
                      imageUrl: widget.contact['profileImage'],
                      width: 16.w,
                      height: 16.w,
                      fit: BoxFit.cover,
                    )
                  : Container(
                      color: AppTheme.accent.withValues(alpha: 0.2),
                      child: Center(
                        child: Text(
                          widget.contact['name']
                                  ?.substring(0, 1)
                                  .toUpperCase() ??
                              'U',
                          style:
                              AppTheme.darkTheme.textTheme.titleLarge?.copyWith(
                            color: AppTheme.accent,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
            ),
          ),
          SizedBox(width: 4.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.contact['name'] ?? '',
                  style: AppTheme.darkTheme.textTheme.titleLarge,
                ),
                SizedBox(height: 0.5.h),
                Text(
                  widget.contact['company'] ?? '',
                  style: AppTheme.darkTheme.textTheme.bodyMedium?.copyWith(
                    color: AppTheme.secondaryText,
                  ),
                ),
                SizedBox(height: 1.h),
                Row(
                  children: [
                    _buildStageChip(),
                    SizedBox(width: 2.w),
                    _buildLeadScore(),
                  ],
                ),
              ],
            ),
          ),
          Column(
            children: [
              _buildQuickActionButton('phone', 'call'),
              SizedBox(height: 1.h),
              _buildQuickActionButton('email', 'email'),
              SizedBox(height: 1.h),
              _buildQuickActionButton('message', 'message'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStageChip() {
    Color stageColor;
    switch (widget.contact['stage']) {
      case 'New':
        stageColor = AppTheme.secondaryText;
        break;
      case 'Qualified':
        stageColor = AppTheme.accent;
        break;
      case 'Demo Scheduled':
        stageColor = AppTheme.warning;
        break;
      case 'Proposal':
        stageColor = AppTheme.success;
        break;
      case 'Negotiation':
        stageColor = AppTheme.error;
        break;
      default:
        stageColor = AppTheme.success;
    }

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
      decoration: BoxDecoration(
        color: stageColor.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: stageColor.withValues(alpha: 0.3)),
      ),
      child: Text(
        widget.contact['stage'] ?? '',
        style: AppTheme.darkTheme.textTheme.bodySmall?.copyWith(
          color: stageColor,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Widget _buildLeadScore() {
    final score = widget.contact['leadScore'] as int;
    final color = _getLeadScoreColor(score);

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        'Score: $score',
        style: AppTheme.darkTheme.textTheme.bodySmall?.copyWith(
          color: color,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _buildQuickActionButton(String icon, String action) {
    return GestureDetector(
      onTap: () => _handleQuickAction(action),
      child: Container(
        padding: EdgeInsets.all(2.w),
        decoration: BoxDecoration(
          color: AppTheme.accent.withValues(alpha: 0.2),
          borderRadius: BorderRadius.circular(8),
        ),
        child: CustomIconWidget(
          iconName: icon,
          color: AppTheme.accent,
          size: 20,
        ),
      ),
    );
  }

  Widget _buildTabBar() {
    return Container(
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: AppTheme.border)),
      ),
      child: TabBar(
        controller: _tabController,
        tabs: [
          Tab(text: 'Activity'),
          Tab(text: 'Notes'),
          Tab(text: 'Details'),
        ],
      ),
    );
  }

  Widget _buildActivityTab() {
    final activities = widget.contact['activities'] as List<dynamic>? ?? [];

    return ListView.builder(
      padding: EdgeInsets.all(4.w),
      itemCount: activities.length,
      itemBuilder: (context, index) {
        final activity = activities[index] as Map<String, dynamic>;
        return _buildActivityItem(activity);
      },
    );
  }

  Widget _buildActivityItem(Map<String, dynamic> activity) {
    IconData activityIcon;
    Color activityColor;

    switch (activity['type']) {
      case 'email_open':
        activityIcon = Icons.email_outlined;
        activityColor = AppTheme.accent;
        break;
      case 'website_visit':
        activityIcon = Icons.web;
        activityColor = AppTheme.success;
        break;
      case 'link_click':
        activityIcon = Icons.link;
        activityColor = AppTheme.warning;
        break;
      case 'meeting':
        activityIcon = Icons.event;
        activityColor = AppTheme.error;
        break;
      case 'phone_call':
        activityIcon = Icons.phone;
        activityColor = AppTheme.accent;
        break;
      default:
        activityIcon = Icons.info_outline;
        activityColor = AppTheme.secondaryText;
    }

    return Container(
      margin: EdgeInsets.only(bottom: 3.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.all(2.w),
            decoration: BoxDecoration(
              color: activityColor.withValues(alpha: 0.2),
              shape: BoxShape.circle,
            ),
            child: Icon(
              activityIcon,
              color: activityColor,
              size: 20,
            ),
          ),
          SizedBox(width: 3.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  activity['description'] ?? '',
                  style: AppTheme.darkTheme.textTheme.bodyMedium,
                ),
                SizedBox(height: 0.5.h),
                Text(
                  activity['timestamp'] ?? '',
                  style: AppTheme.darkTheme.textTheme.bodySmall?.copyWith(
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

  Widget _buildNotesTab() {
    return Padding(
      padding: EdgeInsets.all(4.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Notes',
            style: AppTheme.darkTheme.textTheme.titleMedium,
          ),
          SizedBox(height: 2.h),
          Container(
            padding: EdgeInsets.all(3.w),
            decoration: BoxDecoration(
              color: AppTheme.primaryBackground,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: AppTheme.border),
            ),
            child: Text(
              widget.contact['notes'] ?? 'No notes available',
              style: AppTheme.darkTheme.textTheme.bodyMedium,
            ),
          ),
          SizedBox(height: 3.h),
          Text(
            'Add Note',
            style: AppTheme.darkTheme.textTheme.titleSmall,
          ),
          SizedBox(height: 1.h),
          TextField(
            controller: _noteController,
            maxLines: 4,
            decoration: InputDecoration(
              hintText: 'Enter your note here...',
            ),
          ),
          SizedBox(height: 2.h),
          ElevatedButton(
            onPressed: _addNote,
            child: Text('Add Note'),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailsTab() {
    return Padding(
      padding: EdgeInsets.all(4.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildDetailItem('Email', widget.contact['email'] ?? ''),
          _buildDetailItem('Phone', widget.contact['phone'] ?? ''),
          _buildDetailItem('Company', widget.contact['company'] ?? ''),
          _buildDetailItem('Source', widget.contact['source'] ?? ''),
          _buildDetailItem('Value', widget.contact['value'] ?? ''),
          _buildDetailItem(
              'Last Activity', widget.contact['lastActivity'] ?? ''),
          SizedBox(height: 3.h),
          Text(
            'Tags',
            style: AppTheme.darkTheme.textTheme.titleSmall,
          ),
          SizedBox(height: 1.h),
          Wrap(
            spacing: 2.w,
            runSpacing: 1.h,
            children: (widget.contact['tags'] as List<dynamic>? ?? [])
                .map((tag) => _buildTag(tag.toString()))
                .toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailItem(String label, String value) {
    return Container(
      margin: EdgeInsets.only(bottom: 2.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 25.w,
            child: Text(
              label,
              style: AppTheme.darkTheme.textTheme.bodySmall?.copyWith(
                color: AppTheme.secondaryText,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: AppTheme.darkTheme.textTheme.bodyMedium,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTag(String tag) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
      decoration: BoxDecoration(
        color: AppTheme.accent.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppTheme.accent.withValues(alpha: 0.3)),
      ),
      child: Text(
        tag,
        style: AppTheme.darkTheme.textTheme.bodySmall?.copyWith(
          color: AppTheme.accent,
        ),
      ),
    );
  }

  Color _getLeadScoreColor(int score) {
    if (score >= 80) return AppTheme.success;
    if (score >= 60) return AppTheme.warning;
    return AppTheme.error;
  }

  void _handleQuickAction(String action) {
    switch (action) {
      case 'call':
        // Implement call functionality
        break;
      case 'email':
        // Implement email functionality
        break;
      case 'message':
        // Implement message functionality
        break;
    }
  }

  void _addNote() {
    if (_noteController.text.isNotEmpty) {
      // Add note logic here
      _noteController.clear();
    }
  }

  void _showEditDialog() {
    // Show edit contact dialog
  }
}