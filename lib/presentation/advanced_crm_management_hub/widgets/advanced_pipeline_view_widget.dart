
import '../../../core/app_export.dart';

class AdvancedPipelineViewWidget extends StatefulWidget {
  final List<Map<String, dynamic>> stages;
  final List<Map<String, dynamic>> contacts;
  final Function(String, String) onContactMove;
  final VoidCallback onStageManagement;

  const AdvancedPipelineViewWidget({
    Key? key,
    required this.stages,
    required this.contacts,
    required this.onContactMove,
    required this.onStageManagement,
  }) : super(key: key);

  @override
  State<AdvancedPipelineViewWidget> createState() => _AdvancedPipelineViewWidgetState();
}

class _AdvancedPipelineViewWidgetState extends State<AdvancedPipelineViewWidget> {
  String? _draggedContactId;
  String? _hoveredStageId;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Pipeline header
        Container(
          padding: EdgeInsets.all(4.w),
          decoration: BoxDecoration(
            color: const Color(0xFF191919),
            border: Border(
              bottom: BorderSide(color: AppTheme.border.withAlpha(51)),
            ),
          ),
          child: Row(
            children: [
              Icon(
                Icons.timeline,
                color: AppTheme.accent,
                size: 20,
              ),
              SizedBox(width: 3.w),
              Text(
                'Sales Pipeline',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              const Spacer(),
              IconButton(
                onPressed: widget.onStageManagement,
                icon: const Icon(Icons.settings, color: AppTheme.secondaryText),
              ),
            ],
          ),
        ),
        
        // Pipeline stages
        Expanded(
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: widget.stages.map((stage) {
                final stageContacts = widget.contacts
                    .where((contact) => contact['stage'] == stage['name'])
                    .toList();
                
                return _buildStageColumn(stage, stageContacts);
              }).toList(),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildStageColumn(Map<String, dynamic> stage, List<Map<String, dynamic>> contacts) {
    final isHovered = _hoveredStageId == stage['id'];
    
    return DragTarget<String>(
      onAcceptWithDetails: (details) {
        if (_draggedContactId != null) {
          widget.onContactMove(_draggedContactId!, stage['name']);
        }
        setState(() {
          _draggedContactId = null;
          _hoveredStageId = null;
        });
      },
      onWillAcceptWithDetails: (details) {
        setState(() {
          _hoveredStageId = stage['id'];
        });
        return true;
      },
      onLeave: (data) {
        setState(() {
          _hoveredStageId = null;
        });
      },
      builder: (context, candidateData, rejectedData) {
        return Container(
          width: 80.w,
          margin: EdgeInsets.only(right: 2.w),
          decoration: BoxDecoration(
            color: isHovered ? AppTheme.accent.withAlpha(13) : const Color(0xFF191919),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isHovered ? AppTheme.accent : AppTheme.border.withAlpha(77),
              width: isHovered ? 2 : 1,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Stage header
              Container(
                padding: EdgeInsets.all(4.w),
                decoration: BoxDecoration(
                  color: (stage['color'] as Color).withAlpha(26),
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(12),
                    topRight: Radius.circular(12),
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
                            style: Theme.of(context).textTheme.titleSmall?.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 1.h),
                    Row(
                      children: [
                        Text(
                          '${contacts.length} deals',
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: AppTheme.secondaryText,
                          ),
                        ),
                        const Spacer(),
                        Text(
                          '\$${_formatNumber(stage['value'])}',
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: AppTheme.success,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              
              // Contacts list
              Expanded(
                child: ListView.builder(
                  padding: EdgeInsets.all(2.w),
                  itemCount: contacts.length,
                  itemBuilder: (context, index) {
                    final contact = contacts[index];
                    return _buildContactCard(contact, stage['color'] as Color);
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildContactCard(Map<String, dynamic> contact, Color stageColor) {
    return Draggable<String>(
      data: contact['id'],
      onDragStarted: () {
        setState(() {
          _draggedContactId = contact['id'];
        });
      },
      onDragEnd: (details) {
        setState(() {
          _draggedContactId = null;
        });
      },
      feedback: Material(
        color: Colors.transparent,
        child: Container(
          width: 70.w,
          padding: EdgeInsets.all(3.w),
          decoration: BoxDecoration(
            color: AppTheme.surface,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppTheme.accent),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withAlpha(51),
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: _buildContactCardContent(contact, stageColor),
        ),
      ),
      childWhenDragging: Opacity(
        opacity: 0.5,
        child: _buildContactCardContainer(contact, stageColor),
      ),
      child: _buildContactCardContainer(contact, stageColor),
    );
  }

  Widget _buildContactCardContainer(Map<String, dynamic> contact, Color stageColor) {
    return Container(
      margin: EdgeInsets.only(bottom: 2.h),
      padding: EdgeInsets.all(3.w),
      decoration: BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppTheme.border.withAlpha(77)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(26),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: _buildContactCardContent(contact, stageColor),
    );
  }

  Widget _buildContactCardContent(Map<String, dynamic> contact, Color stageColor) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Contact name and avatar
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
                child: CachedNetworkImage(
                  imageUrl: contact['profileImage'] ?? '',
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
            SizedBox(width: 2.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    contact['name'] ?? '',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    contact['company'] ?? '',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: AppTheme.secondaryText,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
        
        SizedBox(height: 2.h),
        
        // Deal value and lead score
        Row(
          children: [
            Container(
              padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.5.h),
              decoration: BoxDecoration(
                color: AppTheme.success.withAlpha(26),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                '\$${_formatNumber(contact['value'])}',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: AppTheme.success,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            const Spacer(),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.5.h),
              decoration: BoxDecoration(
                color: _getScoreColor(contact['leadScore']).withAlpha(26),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.star,
                    color: _getScoreColor(contact['leadScore']),
                    size: 10,
                  ),
                  SizedBox(width: 1.w),
                  Text(
                    '${contact['leadScore']}',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: _getScoreColor(contact['leadScore']),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        
        SizedBox(height: 2.h),
        
        // Probability and next action
        Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Probability',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: AppTheme.secondaryText,
                    ),
                  ),
                  Text(
                    '${((contact['conversionProbability'] ?? 0) * 100).toInt()}%',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: stageColor,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              width: 1,
              height: 4.h,
              color: AppTheme.border,
            ),
            Expanded(
              child: Padding(
                padding: EdgeInsets.only(left: 2.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Next Action',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppTheme.secondaryText,
                      ),
                    ),
                    Text(
                      contact['nextAction'] ?? '',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        fontWeight: FontWeight.w500,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Color _getScoreColor(dynamic score) {
    if (score is! num) return AppTheme.secondaryText;
    
    if (score >= 80) return AppTheme.success;
    if (score >= 60) return AppTheme.warning;
    return AppTheme.error;
  }

  String _formatNumber(dynamic value) {
    if (value is! num) return '0';
    
    if (value >= 1000000) {
      return '${(value / 1000000).toStringAsFixed(1)}M';
    } else if (value >= 1000) {
      return '${(value / 1000).toStringAsFixed(0)}K';
    } else {
      return value.toString();
    }
  }
}