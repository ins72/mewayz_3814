import '../../../core/app_export.dart';

class PipelineManagementWidget extends StatefulWidget {
  final List<Map<String, dynamic>> stages;
  final Function(List<Map<String, dynamic>>) onStageUpdate;

  const PipelineManagementWidget({
    Key? key,
    required this.stages,
    required this.onStageUpdate,
  }) : super(key: key);

  @override
  State<PipelineManagementWidget> createState() => _PipelineManagementWidgetState();
}

class _PipelineManagementWidgetState extends State<PipelineManagementWidget> {
  late List<Map<String, dynamic>> _stages;
  bool _isEditing = false;

  @override
  void initState() {
    super.initState();
    _stages = List<Map<String, dynamic>>.from(widget.stages);
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
                Icon(
                  Icons.timeline,
                  color: AppTheme.accent,
                  size: 24,
                ),
                SizedBox(width: 3.w),
                Text(
                  'Pipeline Management',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const Spacer(),
                IconButton(
                  onPressed: () {
                    setState(() {
                      _isEditing = !_isEditing;
                    });
                  },
                  icon: Icon(
                    _isEditing ? Icons.done : Icons.edit,
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
          
          // Content
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(4.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Pipeline overview
                  _buildPipelineOverview(),
                  
                  SizedBox(height: 3.h),
                  
                  // Stages management
                  _buildStagesManagement(),
                  
                  SizedBox(height: 3.h),
                  
                  // Stage analytics
                  _buildStageAnalytics(),
                  
                  SizedBox(height: 3.h),
                  
                  // Quick actions
                  _buildQuickActions(),
                ],
              ),
            ),
          ),
          
          // Save button
          if (_isEditing)
            Container(
              padding: EdgeInsets.all(4.w),
              decoration: BoxDecoration(
                border: Border(
                  top: BorderSide(color: AppTheme.border.withAlpha(51)),
                ),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {
                        setState(() {
                          _stages = List<Map<String, dynamic>>.from(widget.stages);
                          _isEditing = false;
                        });
                      },
                      child: const Text('Cancel'),
                    ),
                  ),
                  SizedBox(width: 3.w),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        widget.onStageUpdate(_stages);
                        setState(() {
                          _isEditing = false;
                        });
                      },
                      child: const Text('Save Changes'),
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildPipelineOverview() {
    final totalValue = _stages.fold<double>(
      0,
      (sum, stage) => sum + (stage['value'] as num? ?? 0).toDouble(),
    );
    final totalDeals = _stages.fold<int>(
      0,
      (sum, stage) => sum + (stage['count'] as int? ?? 0),
    );
    
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
            'Pipeline Overview',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 3.h),
          
          Row(
            children: [
              Expanded(
                child: _buildOverviewCard(
                  'Total Value',
                  '\$${_formatNumber(totalValue)}',
                  Icons.attach_money,
                  AppTheme.success,
                ),
              ),
              SizedBox(width: 3.w),
              Expanded(
                child: _buildOverviewCard(
                  'Total Deals',
                  '$totalDeals',
                  Icons.business_center,
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
                  'Avg Deal Size',
                  '\$${_formatNumber(totalDeals > 0 ? totalValue / totalDeals : 0)}',
                  Icons.trending_up,
                  AppTheme.warning,
                ),
              ),
              SizedBox(width: 3.w),
              Expanded(
                child: _buildOverviewCard(
                  'Win Rate',
                  '${_calculateWinRate()}%',
                  Icons.emoji_events,
                  AppTheme.success,
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

  Widget _buildStagesManagement() {
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
          Row(
            children: [
              Text(
                'Pipeline Stages',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              const Spacer(),
              if (_isEditing)
                IconButton(
                  onPressed: _addNewStage,
                  icon: const Icon(Icons.add, color: AppTheme.accent),
                ),
            ],
          ),
          SizedBox(height: 2.h),
          
          // Stages list
          ReorderableListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            onReorder: _isEditing ? (oldIndex, newIndex) => _reorderStages(oldIndex, newIndex) : (oldIndex, newIndex) {},
            itemCount: _stages.length,
            itemBuilder: (context, index) {
              final stage = _stages[index];
              return _buildStageCard(stage, index);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildStageCard(Map<String, dynamic> stage, int index) {
    return Container(
      key: ValueKey(stage['id']),
      margin: EdgeInsets.only(bottom: 2.h),
      padding: EdgeInsets.all(3.w),
      decoration: BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppTheme.border.withAlpha(77)),
      ),
      child: Row(
        children: [
          // Drag handle
          if (_isEditing)
            Icon(
              Icons.drag_handle,
              color: AppTheme.secondaryText,
              size: 20,
            ),
          
          if (_isEditing) SizedBox(width: 2.w),
          
          // Stage color
          Container(
            width: 4.w,
            height: 4.w,
            decoration: BoxDecoration(
              color: stage['color'] as Color,
              shape: BoxShape.circle,
            ),
          ),
          
          SizedBox(width: 3.w),
          
          // Stage info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  stage['name'] ?? '',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Row(
                  children: [
                    Text(
                      '${stage['count']} deals',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppTheme.secondaryText,
                      ),
                    ),
                    Text(
                      ' • ',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppTheme.secondaryText,
                      ),
                    ),
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
          
          // Stage metrics
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '${stage['conversionRate'] * 100}%',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: AppTheme.accent,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                '${stage['avgTime']} days',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: AppTheme.secondaryText,
                ),
              ),
            ],
          ),
          
          // Actions
          if (_isEditing) ...[
            SizedBox(width: 2.w),
            PopupMenuButton<String>(
              icon: const Icon(Icons.more_vert, color: AppTheme.secondaryText),
              color: AppTheme.surface,
              onSelected: (value) {
                switch (value) {
                  case 'edit':
                    _editStage(stage);
                    break;
                  case 'delete':
                    _deleteStage(stage);
                    break;
                }
              },
              itemBuilder: (context) => [
                const PopupMenuItem(
                  value: 'edit',
                  child: Row(
                    children: [
                      Icon(Icons.edit, color: AppTheme.accent),
                      SizedBox(width: 8),
                      Text('Edit Stage'),
                    ],
                  ),
                ),
                const PopupMenuItem(
                  value: 'delete',
                  child: Row(
                    children: [
                      Icon(Icons.delete, color: AppTheme.error),
                      SizedBox(width: 8),
                      Text('Delete Stage'),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildStageAnalytics() {
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
            'Stage Analytics',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 2.h),
          
          // Conversion rates
          ..._stages.map((stage) {
            final conversionRate = stage['conversionRate'] as double;
            return _buildAnalyticsBar(
              stage['name'],
              conversionRate,
              stage['color'] as Color,
            );
          }).toList(),
        ],
      ),
    );
  }

  Widget _buildAnalyticsBar(String stageName, double conversionRate, Color color) {
    return Container(
      margin: EdgeInsets.only(bottom: 2.h),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  stageName,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              Text(
                '${(conversionRate * 100).toInt()}%',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: color,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          SizedBox(height: 1.h),
          LinearProgressIndicator(
            value: conversionRate,
            backgroundColor: AppTheme.border,
            valueColor: AlwaysStoppedAnimation<Color>(color),
            minHeight: 6,
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActions() {
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
            'Quick Actions',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 2.h),
          
          // Action buttons
          Row(
            children: [
              Expanded(
                child: _buildActionButton(
                  'Import Template',
                  Icons.download,
                  AppTheme.accent,
                  () => _importTemplate(),
                ),
              ),
              SizedBox(width: 3.w),
              Expanded(
                child: _buildActionButton(
                  'Export Pipeline',
                  Icons.upload,
                  AppTheme.success,
                  () => _exportPipeline(),
                ),
              ),
            ],
          ),
          
          SizedBox(height: 2.h),
          
          Row(
            children: [
              Expanded(
                child: _buildActionButton(
                  'Reset to Default',
                  Icons.refresh,
                  AppTheme.warning,
                  () => _resetToDefault(),
                ),
              ),
              SizedBox(width: 3.w),
              Expanded(
                child: _buildActionButton(
                  'Archive Pipeline',
                  Icons.archive,
                  AppTheme.error,
                  () => _archivePipeline(),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton(String label, IconData icon, Color color, VoidCallback onPressed) {
    return ElevatedButton.icon(
      onPressed: onPressed,
      icon: Icon(icon, size: 16),
      label: Text(label),
      style: ElevatedButton.styleFrom(
        backgroundColor: color.withAlpha(26),
        foregroundColor: color,
        elevation: 0,
        minimumSize: Size(0, 5.h),
      ),
    );
  }

  void _reorderStages(int oldIndex, int newIndex) {
    setState(() {
      if (newIndex > oldIndex) {
        newIndex -= 1;
      }
      final stage = _stages.removeAt(oldIndex);
      _stages.insert(newIndex, stage);
    });
  }

  void _addNewStage() {
    setState(() {
      _stages.add({
        'id': DateTime.now().millisecondsSinceEpoch.toString(),
        'name': 'New Stage',
        'color': AppTheme.accent,
        'count': 0,
        'value': 0,
        'conversionRate': 0.0,
        'avgTime': 0,
      });
    });
  }

  void _editStage(Map<String, dynamic> stage) {
    // Handle stage editing
  }

  void _deleteStage(Map<String, dynamic> stage) {
    setState(() {
      _stages.remove(stage);
    });
  }

  void _importTemplate() {
    // Handle import template
  }

  void _exportPipeline() {
    // Handle export pipeline
  }

  void _resetToDefault() {
    // Handle reset to default
  }

  void _archivePipeline() {
    // Handle archive pipeline
  }

  int _calculateWinRate() {
    final totalDeals = _stages.fold<int>(
      0,
      (sum, stage) => sum + (stage['count'] as int? ?? 0),
    );
    
    final wonDeals = _stages
        .where((stage) => stage['name'] == 'Closed Won')
        .fold<int>(
          0,
          (sum, stage) => sum + (stage['count'] as int? ?? 0),
        );
    
    return totalDeals > 0 ? ((wonDeals / totalDeals) * 100).round() : 0;
  }

  String _formatNumber(double value) {
    if (value >= 1000000) {
      return '${(value / 1000000).toStringAsFixed(1)}M';
    } else if (value >= 1000) {
      return '${(value / 1000).toStringAsFixed(0)}K';
    } else {
      return value.toStringAsFixed(0);
    }
  }
}