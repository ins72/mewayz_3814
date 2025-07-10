import '../../../core/app_export.dart';

class PlanComparisonWidget extends StatefulWidget {
  final Map<String, Map<String, dynamic>> planData;
  final Map<String, dynamic> featureMatrix;
  final List<String> selectedGoals;

  const PlanComparisonWidget({
    Key? key,
    required this.planData,
    required this.featureMatrix,
    required this.selectedGoals,
  }) : super(key: key);

  @override
  State<PlanComparisonWidget> createState() => _PlanComparisonWidgetState();
}

class _PlanComparisonWidgetState extends State<PlanComparisonWidget> {
  List<String> _selectedPlansForComparison = [];

  @override
  void initState() {
    super.initState();
    // Pre-select first 2 plans for comparison
    _selectedPlansForComparison = widget.planData.keys.take(2).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Color(0xFF191919),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppTheme.accent.withAlpha(77),
          width: 1)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            children: [
              Icon(
                Icons.compare_arrows,
                color: AppTheme.accent,
                size: 20),
              SizedBox(width: 8),
              Text(
                'Compare Plans',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: AppTheme.primaryText,
                  fontWeight: FontWeight.w600)),
            ]),
          SizedBox(height: 16),
          
          // Plan selector chips
          Text(
            'Select plans to compare:',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: AppTheme.secondaryText)),
          SizedBox(height: 12),
          
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: widget.planData.keys.map((planName) {
              final isSelected = _selectedPlansForComparison.contains(planName);
              return GestureDetector(
                onTap: () {
                  setState(() {
                    if (isSelected) {
                      _selectedPlansForComparison.remove(planName);
                    } else if (_selectedPlansForComparison.length < 3) {
                      _selectedPlansForComparison.add(planName);
                    }
                  });
                },
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    color: isSelected ? AppTheme.accent : Colors.transparent,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: isSelected ? AppTheme.accent : AppTheme.accent.withAlpha(77),
                      width: 1)),
                  child: Text(
                    planName,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: isSelected ? AppTheme.primaryAction : AppTheme.secondaryText,
                      fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400))));
            }).toList()),
          
          SizedBox(height: 20),
          
          // Comparison table
          if (_selectedPlansForComparison.isNotEmpty)
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: DataTable(
                headingTextStyle: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppTheme.primaryText,
                  fontWeight: FontWeight.w600),
                dataTextStyle: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: AppTheme.secondaryText),
                columns: [
                  DataColumn(label: Text('Feature')),
                  ..._selectedPlansForComparison.map((planName) => 
                    DataColumn(label: Text(planName))),
                ],
                rows: widget.featureMatrix.entries.map((entry) {
                  final featureName = entry.key;
                  final featureData = entry.value as Map<String, dynamic>;
                  
                  return DataRow(
                    cells: [
                      DataCell(
                        Container(
                          constraints: BoxConstraints(maxWidth: 150),
                          child: Text(
                            featureName,
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: AppTheme.primaryText)))),
                      ..._selectedPlansForComparison.map((planName) {
                        final value = featureData[planName];
                        return DataCell(_buildFeatureValue(value));
                      }),
                    ]);
                }).toList())),
          
          // Note about goal alignment
          if (widget.selectedGoals.isNotEmpty) ...[
            SizedBox(height: 16),
            Container(
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                
                borderRadius: BorderRadius.circular(8)),
              child: Row(
                children: [
                  Icon(
                    Icons.info_outline,
                    
                    size: 16),
                  SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Features highlighted in color match your selected goals',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith())),
                ])),
          ],
        ]));
  }

  Widget _buildFeatureValue(dynamic value) {
    if (value is bool) {
      return Container(
        padding: EdgeInsets.all(4),
        child: Icon(
          value ? Icons.check_circle : Icons.cancel,
          color: value ? AppTheme.success : AppTheme.error,
          size: 16));
    } else if (value is String) {
      return Container(
        constraints: BoxConstraints(maxWidth: 80),
        child: Text(
          value,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: AppTheme.secondaryText),
          textAlign: TextAlign.center));
    } else {
      return Container(
        child: Text(
          value?.toString() ?? '-',
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: AppTheme.secondaryText),
          textAlign: TextAlign.center));
    }
  }
}