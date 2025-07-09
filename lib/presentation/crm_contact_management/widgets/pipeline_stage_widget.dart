
import '../../../core/app_export.dart';

class PipelineStageWidget extends StatelessWidget {
  final Map<String, dynamic> stage;
  final List<Map<String, dynamic>> contacts;
  final Function(Map<String, dynamic>) onContactTap;
  final Function(Map<String, dynamic>, String) onContactMove;

  const PipelineStageWidget({
    Key? key,
    required this.stage,
    required this.contacts,
    required this.onContactTap,
    required this.onContactMove,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppTheme.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildStageHeader(),
          Expanded(
            child: _buildContactsList(),
          ),
        ],
      ),
    );
  }

  Widget _buildStageHeader() {
    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: (stage['color'] as Color).withValues(alpha: 0.1),
        borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
        border: Border(
          bottom: BorderSide(
            color: (stage['color'] as Color).withValues(alpha: 0.3),
          ),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 3.w,
                height: 3.w,
                decoration: BoxDecoration(
                  color: stage['color'] as Color,
                  shape: BoxShape.circle,
                ),
              ),
              SizedBox(width: 2.w),
              Expanded(
                child: Text(
                  stage['name'] ?? '',
                  style: AppTheme.darkTheme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          SizedBox(height: 2.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${stage['count']} contacts',
                    style: AppTheme.darkTheme.textTheme.bodySmall?.copyWith(
                      color: AppTheme.secondaryText,
                    ),
                  ),
                  Text(
                    stage['value'] ?? '',
                    style: AppTheme.darkTheme.textTheme.titleSmall?.copyWith(
                      color: AppTheme.success,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              _buildProgressIndicator(),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildProgressIndicator() {
    final totalContacts = 45; // Mock total contacts
    final progress = (stage['count'] as int) / totalContacts;

    return Container(
      width: 12.w,
      height: 12.w,
      child: Stack(
        children: [
          CircularProgressIndicator(
            value: progress,
            backgroundColor: AppTheme.border,
            valueColor: AlwaysStoppedAnimation<Color>(stage['color'] as Color),
            strokeWidth: 3,
          ),
          Center(
            child: Text(
              '${(progress * 100).toInt()}%',
              style: AppTheme.darkTheme.textTheme.bodySmall?.copyWith(
                fontSize: 8.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContactsList() {
    return DragTarget<Map<String, dynamic>>(
      onAcceptWithDetails: (details) {
        onContactMove(details.data, stage['name'] as String);
      },
      builder: (context, candidateData, rejectedData) {
        return Container(
          decoration: BoxDecoration(
            color: candidateData.isNotEmpty
                ? (stage['color'] as Color).withValues(alpha: 0.05)
                : Colors.transparent,
          ),
          child: ListView.builder(
            padding: EdgeInsets.all(2.w),
            itemCount: contacts.length,
            itemBuilder: (context, index) {
              final contact = contacts[index];
              return _buildContactCard(contact);
            },
          ),
        );
      },
    );
  }

  Widget _buildContactCard(Map<String, dynamic> contact) {
    return Draggable<Map<String, dynamic>>(
      data: contact,
      feedback: Material(
        color: Colors.transparent,
        child: Container(
          width: 60.w,
          child: _buildContactCardContent(contact, isDragging: true),
        ),
      ),
      childWhenDragging: Opacity(
        opacity: 0.5,
        child: _buildContactCardContent(contact),
      ),
      child: GestureDetector(
        onTap: () => onContactTap(contact),
        child: _buildContactCardContent(contact),
      ),
    );
  }

  Widget _buildContactCardContent(Map<String, dynamic> contact,
      {bool isDragging = false}) {
    return Container(
      margin: EdgeInsets.only(bottom: 2.h),
      padding: EdgeInsets.all(3.w),
      decoration: BoxDecoration(
        color: isDragging
            ? AppTheme.primaryBackground
            : AppTheme.primaryBackground.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: isDragging ? AppTheme.accent : AppTheme.border,
          width: isDragging ? 2 : 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 8.w,
                height: 8.w,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: AppTheme.border),
                ),
                child: ClipOval(
                  child: contact['profileImage'] != null
                      ? CustomImageWidget(
                          imageUrl: contact['profileImage'],
                          width: 8.w,
                          height: 8.w,
                          fit: BoxFit.cover,
                        )
                      : Container(
                          color: AppTheme.accent.withValues(alpha: 0.2),
                          child: Center(
                            child: Text(
                              contact['name']?.substring(0, 1).toUpperCase() ??
                                  'U',
                              style: AppTheme.darkTheme.textTheme.bodySmall
                                  ?.copyWith(
                                color: AppTheme.accent,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                ),
              ),
              SizedBox(width: 2.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      contact['name'] ?? '',
                      style: AppTheme.darkTheme.textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w500,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      contact['company'] ?? '',
                      style: AppTheme.darkTheme.textTheme.bodySmall?.copyWith(
                        color: AppTheme.secondaryText,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 1.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                contact['value'] ?? '',
                style: AppTheme.darkTheme.textTheme.bodySmall?.copyWith(
                  color: AppTheme.success,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.5.h),
                decoration: BoxDecoration(
                  color: _getLeadScoreColor(contact['leadScore'])
                      .withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  '${contact['leadScore']}',
                  style: AppTheme.darkTheme.textTheme.bodySmall?.copyWith(
                    color: _getLeadScoreColor(contact['leadScore']),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 1.h),
          Text(
            contact['lastActivity'] ?? '',
            style: AppTheme.darkTheme.textTheme.bodySmall?.copyWith(
              color: AppTheme.secondaryText,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Color _getLeadScoreColor(int score) {
    if (score >= 80) return AppTheme.success;
    if (score >= 60) return AppTheme.warning;
    return AppTheme.error;
  }
}