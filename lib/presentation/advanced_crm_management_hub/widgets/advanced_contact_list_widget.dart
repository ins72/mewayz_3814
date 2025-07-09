
import '../../../core/app_export.dart';

class AdvancedContactListWidget extends StatefulWidget {
  final List<Map<String, dynamic>> contacts;
  final Set<String> selectedContacts;
  final Function(Map<String, dynamic>) onContactTap;
  final Function(Set<String>) onSelectionChanged;

  const AdvancedContactListWidget({
    Key? key,
    required this.contacts,
    required this.selectedContacts,
    required this.onContactTap,
    required this.onSelectionChanged,
  }) : super(key: key);

  @override
  State<AdvancedContactListWidget> createState() => _AdvancedContactListWidgetState();
}

class _AdvancedContactListWidgetState extends State<AdvancedContactListWidget> {
  String _sortBy = 'name';
  bool _isAscending = true;

  @override
  Widget build(BuildContext context) {
    final sortedContacts = _sortContacts(widget.contacts);

    return Column(
      children: [
        // Header with sorting and selection
        Container(
          padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
          decoration: BoxDecoration(
            color: const Color(0xFF191919),
            border: Border(
              bottom: BorderSide(color: AppTheme.border.withAlpha(51)),
            ),
          ),
          child: Row(
            children: [
              // Selection info
              if (widget.selectedContacts.isNotEmpty)
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
                  decoration: BoxDecoration(
                    color: AppTheme.accent.withAlpha(26),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Text(
                    '${widget.selectedContacts.length} selected',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: AppTheme.accent,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              
              const Spacer(),
              
              // Sort dropdown
              PopupMenuButton<String>(
                icon: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.sort, color: AppTheme.secondaryText, size: 16),
                    SizedBox(width: 1.w),
                    Text(
                      'Sort',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppTheme.secondaryText,
                      ),
                    ),
                  ],
                ),
                color: AppTheme.surface,
                onSelected: (value) {
                  setState(() {
                    if (_sortBy == value) {
                      _isAscending = !_isAscending;
                    } else {
                      _sortBy = value;
                      _isAscending = true;
                    }
                  });
                },
                itemBuilder: (context) => [
                  _buildSortMenuItem('Name', 'name'),
                  _buildSortMenuItem('Company', 'company'),
                  _buildSortMenuItem('Lead Score', 'leadScore'),
                  _buildSortMenuItem('Stage', 'stage'),
                  _buildSortMenuItem('Value', 'value'),
                  _buildSortMenuItem('Last Activity', 'lastActivity'),
                ],
              ),
            ],
          ),
        ),
        
        // Contact list
        Expanded(
          child: ListView.builder(
            padding: EdgeInsets.all(2.w),
            itemCount: sortedContacts.length,
            itemBuilder: (context, index) {
              final contact = sortedContacts[index];
              final isSelected = widget.selectedContacts.contains(contact['id']);
              
              return _buildContactCard(contact, isSelected);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildContactCard(Map<String, dynamic> contact, bool isSelected) {
    return Container(
      margin: EdgeInsets.only(bottom: 2.h),
      decoration: BoxDecoration(
        color: isSelected ? AppTheme.accent.withAlpha(26) : const Color(0xFF191919),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isSelected ? AppTheme.accent : AppTheme.border.withAlpha(77),
          width: isSelected ? 2 : 1,
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: () => widget.onContactTap(contact),
          onLongPress: () => _toggleSelection(contact['id']),
          child: Padding(
            padding: EdgeInsets.all(4.w),
            child: Row(
              children: [
                // Selection checkbox
                GestureDetector(
                  onTap: () => _toggleSelection(contact['id']),
                  child: Container(
                    width: 5.w,
                    height: 5.w,
                    decoration: BoxDecoration(
                      color: isSelected ? AppTheme.accent : Colors.transparent,
                      borderRadius: BorderRadius.circular(4),
                      border: Border.all(
                        color: isSelected ? AppTheme.accent : AppTheme.border,
                        width: 2,
                      ),
                    ),
                    child: isSelected
                        ? Icon(
                            Icons.check,
                            color: AppTheme.primaryAction,
                            size: 3.w,
                          )
                        : null,
                  ),
                ),
                
                SizedBox(width: 3.w),
                
                // Avatar
                Container(
                  width: 12.w,
                  height: 12.w,
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
                              contact['name'] ?? '',
                              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.5.h),
                            decoration: BoxDecoration(
                              color: _getStageColor(contact['stage']).withAlpha(26),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              contact['stage'] ?? '',
                              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                color: _getStageColor(contact['stage']),
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                      
                      SizedBox(height: 0.5.h),
                      
                      Text(
                        contact['company'] ?? '',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AppTheme.secondaryText,
                        ),
                      ),
                      
                      SizedBox(height: 1.h),
                      
                      Row(
                        children: [
                          // Lead score
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
                                  size: 12,
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
                          
                          SizedBox(width: 2.w),
                          
                          // Deal value
                          Text(
                            '\$${_formatNumber(contact['value'])}',
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: AppTheme.success,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          
                          const Spacer(),
                          
                          // Last activity
                          Text(
                            _formatTimestamp(contact['lastActivity']),
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: AppTheme.secondaryText,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                
                // Priority indicator
                Container(
                  width: 4,
                  height: 8.w,
                  decoration: BoxDecoration(
                    color: _getPriorityColor(contact['priority']),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  PopupMenuItem<String> _buildSortMenuItem(String label, String value) {
    final isSelected = _sortBy == value;
    return PopupMenuItem(
      value: value,
      child: Row(
        children: [
          Icon(
            isSelected
                ? (_isAscending ? Icons.arrow_upward : Icons.arrow_downward)
                : Icons.sort,
            color: isSelected ? AppTheme.accent : AppTheme.secondaryText,
            size: 16,
          ),
          SizedBox(width: 2.w),
          Text(
            label,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: isSelected ? AppTheme.accent : AppTheme.primaryText,
            ),
          ),
        ],
      ),
    );
  }

  void _toggleSelection(String contactId) {
    final newSelection = Set<String>.from(widget.selectedContacts);
    if (newSelection.contains(contactId)) {
      newSelection.remove(contactId);
    } else {
      newSelection.add(contactId);
    }
    widget.onSelectionChanged(newSelection);
  }

  List<Map<String, dynamic>> _sortContacts(List<Map<String, dynamic>> contacts) {
    final sorted = List<Map<String, dynamic>>.from(contacts);
    
    sorted.sort((a, b) {
      dynamic aValue = a[_sortBy];
      dynamic bValue = b[_sortBy];
      
      if (aValue == null && bValue == null) return 0;
      if (aValue == null) return 1;
      if (bValue == null) return -1;
      
      int comparison;
      
      if (aValue is num && bValue is num) {
        comparison = aValue.compareTo(bValue);
      } else if (aValue is DateTime && bValue is DateTime) {
        comparison = aValue.compareTo(bValue);
      } else {
        comparison = aValue.toString().compareTo(bValue.toString());
      }
      
      return _isAscending ? comparison : -comparison;
    });
    
    return sorted;
  }

  Color _getStageColor(String? stage) {
    switch (stage?.toLowerCase()) {
      case 'new':
        return AppTheme.secondaryText;
      case 'qualified':
        return AppTheme.accent;
      case 'proposal':
        return AppTheme.warning;
      case 'negotiation':
        return AppTheme.success;
      case 'closed':
        return AppTheme.success;
      default:
        return AppTheme.secondaryText;
    }
  }

  Color _getScoreColor(dynamic score) {
    if (score is! num) return AppTheme.secondaryText;
    
    if (score >= 80) return AppTheme.success;
    if (score >= 60) return AppTheme.warning;
    return AppTheme.error;
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

  String _formatTimestamp(dynamic timestamp) {
    if (timestamp is DateTime) {
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
    return '';
  }
}