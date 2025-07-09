
import '../../../core/app_export.dart';

class AdvancedFilterWidget extends StatefulWidget {
  final Map<String, String> currentFilters;
  final Function(Map<String, String>) onApply;

  const AdvancedFilterWidget({
    Key? key,
    required this.currentFilters,
    required this.onApply,
  }) : super(key: key);

  @override
  State<AdvancedFilterWidget> createState() => _AdvancedFilterWidgetState();
}

class _AdvancedFilterWidgetState extends State<AdvancedFilterWidget> {
  late Map<String, String> _filters;

  @override
  void initState() {
    super.initState();
    _filters = Map.from(widget.currentFilters);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 90.h,
      decoration: const BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.all(4.w),
            decoration: const BoxDecoration(
              border: Border(
                bottom: BorderSide(color: AppTheme.border),
              ),
            ),
            child: Row(
              children: [
                Text(
                  'Advanced Filters',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const Spacer(),
                TextButton(
                  onPressed: () {
                    setState(() {
                      _filters = {
                        'stage': 'All',
                        'source': 'All',
                        'dateRange': 'All Time',
                        'priority': 'All',
                        'leadScore': 'All',
                      };
                    });
                  },
                  child: const Text('Reset All'),
                ),
              ],
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(4.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildFilterSection(
                    'Lead Stage',
                    _filters['stage'] ?? 'All',
                    [
                      'All',
                      'New',
                      'Qualified',
                      'Demo Scheduled',
                      'Proposal',
                      'Negotiation',
                      'Closed Won',
                      'Closed Lost'
                    ],
                    (value) => setState(() => _filters['stage'] = value),
                  ),
                  SizedBox(height: 6.h),
                  _buildFilterSection(
                    'Lead Source',
                    _filters['source'] ?? 'All',
                    [
                      'All',
                      'Website',
                      'LinkedIn',
                      'Referral',
                      'Cold Email',
                      'Social Media',
                      'Trade Show',
                      'Direct Mail'
                    ],
                    (value) => setState(() => _filters['source'] = value),
                  ),
                  SizedBox(height: 6.h),
                  _buildFilterSection(
                    'Date Range',
                    _filters['dateRange'] ?? 'All Time',
                    [
                      'All Time',
                      'Today',
                      'This Week',
                      'This Month',
                      'Last 30 Days',
                      'Last 90 Days',
                      'This Quarter',
                      'This Year'
                    ],
                    (value) => setState(() => _filters['dateRange'] = value),
                  ),
                  SizedBox(height: 6.h),
                  _buildFilterSection(
                    'Priority Level',
                    _filters['priority'] ?? 'All',
                    ['All', 'High', 'Medium', 'Low'],
                    (value) => setState(() => _filters['priority'] = value),
                  ),
                  SizedBox(height: 6.h),
                  _buildFilterSection(
                    'Lead Score Range',
                    _filters['leadScore'] ?? 'All',
                    ['All', '80-100', '60-79', '40-59', '20-39', '0-19'],
                    (value) => setState(() => _filters['leadScore'] = value),
                  ),
                ],
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.all(4.w),
            decoration: const BoxDecoration(
              border: Border(
                top: BorderSide(color: AppTheme.border),
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Cancel'),
                  ),
                ),
                SizedBox(width: 4.w),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      widget.onApply(_filters);
                      Navigator.pop(context);
                    },
                    child: const Text('Apply Filters'),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterSection(String title, String selectedValue, List<String> options, Function(String) onChanged) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: 3.h),
        Wrap(
          spacing: 2.w,
          runSpacing: 2.h,
          children: options.map((option) {
            final isSelected = selectedValue == option;
            return GestureDetector(
              onTap: () => onChanged(option),
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
                decoration: BoxDecoration(
                  color: isSelected ? AppTheme.accent : AppTheme.surfaceVariant,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: isSelected ? AppTheme.accent : AppTheme.border,
                  ),
                ),
                child: Text(
                  option,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: isSelected ? AppTheme.primaryAction : AppTheme.primaryText,
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}