
import '../../../core/app_export.dart';

class AdvancedSearchWidget extends StatefulWidget {
  final TextEditingController searchController;
  final bool isVoiceEnabled;
  final List<String> savedSearches;
  final String selectedPreset;
  final Function(String) onSearchChanged;
  final VoidCallback onVoiceToggle;
  final Function(String) onPresetSelected;
  final Function(Map<String, dynamic>) onAdvancedFilter;

  const AdvancedSearchWidget({
    Key? key,
    required this.searchController,
    required this.isVoiceEnabled,
    required this.savedSearches,
    required this.selectedPreset,
    required this.onSearchChanged,
    required this.onVoiceToggle,
    required this.onPresetSelected,
    required this.onAdvancedFilter,
  }) : super(key: key);

  @override
  State<AdvancedSearchWidget> createState() => _AdvancedSearchWidgetState();
}

class _AdvancedSearchWidgetState extends State<AdvancedSearchWidget> {
  bool _isAdvancedMode = false;
  Map<String, dynamic> _filters = {};

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Main search bar
        Container(
          decoration: BoxDecoration(
            color: const Color(0xFF191919),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppTheme.border.withAlpha(77)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withAlpha(26),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            children: [
              // Search icon
              Padding(
                padding: EdgeInsets.all(4.w),
                child: const Icon(
                  Icons.search,
                  color: AppTheme.accent,
                  size: 20,
                ),
              ),
              
              // Search input
              Expanded(
                child: TextField(
                  controller: widget.searchController,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppTheme.primaryText,
                  ),
                  decoration: InputDecoration(
                    hintText: 'Search contacts, companies, deals...',
                    hintStyle: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: AppTheme.secondaryText,
                    ),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(vertical: 3.h),
                  ),
                  onChanged: widget.onSearchChanged,
                ),
              ),
              
              // Voice input button
              GestureDetector(
                onTap: widget.onVoiceToggle,
                child: Container(
                  padding: EdgeInsets.all(3.w),
                  decoration: BoxDecoration(
                    color: widget.isVoiceEnabled 
                        ? AppTheme.accent.withAlpha(26) 
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    widget.isVoiceEnabled ? Icons.mic : Icons.mic_none,
                    color: widget.isVoiceEnabled ? AppTheme.accent : AppTheme.secondaryText,
                    size: 20,
                  ),
                ),
              ),
              
              // Advanced filter button
              GestureDetector(
                onTap: () {
                  setState(() {
                    _isAdvancedMode = !_isAdvancedMode;
                  });
                },
                child: Container(
                  padding: EdgeInsets.all(3.w),
                  decoration: BoxDecoration(
                    color: _isAdvancedMode 
                        ? AppTheme.accent.withAlpha(26) 
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    Icons.tune,
                    color: _isAdvancedMode ? AppTheme.accent : AppTheme.secondaryText,
                    size: 20,
                  ),
                ),
              ),
              
              SizedBox(width: 2.w),
            ],
          ),
        ),
        
        // Saved search presets
        if (widget.savedSearches.isNotEmpty) ...[
          SizedBox(height: 2.h),
          SizedBox(
            height: 4.h,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: widget.savedSearches.length + 1,
              itemBuilder: (context, index) {
                if (index == 0) {
                  return _buildPresetChip('All', widget.selectedPreset == 'All');
                }
                
                final preset = widget.savedSearches[index - 1];
                return _buildPresetChip(preset, widget.selectedPreset == preset);
              },
            ),
          ),
        ],
        
        // Advanced filters
        if (_isAdvancedMode) ...[
          SizedBox(height: 2.h),
          _buildAdvancedFilters(),
        ],
      ],
    );
  }

  Widget _buildPresetChip(String label, bool isSelected) {
    return Container(
      margin: EdgeInsets.only(right: 2.w),
      child: GestureDetector(
        onTap: () => widget.onPresetSelected(label),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
          decoration: BoxDecoration(
            color: isSelected ? AppTheme.accent : const Color(0xFF191919),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: isSelected ? AppTheme.accent : AppTheme.border,
              width: 1,
            ),
          ),
          child: Text(
            label,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: isSelected ? AppTheme.primaryAction : AppTheme.secondaryText,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAdvancedFilters() {
    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: const Color(0xFF191919),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppTheme.border.withAlpha(77)),
      ),
      child: Column(
        children: [
          // Filter header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Advanced Filters',
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              TextButton(
                onPressed: () {
                  setState(() {
                    _filters.clear();
                  });
                  widget.onAdvancedFilter(_filters);
                },
                child: const Text('Clear All'),
              ),
            ],
          ),
          
          SizedBox(height: 2.h),
          
          // Filter options
          Wrap(
            spacing: 2.w,
            runSpacing: 1.h,
            children: [
              _buildFilterTag('Lead Score', Icons.star, 'High (80+)'),
              _buildFilterTag('Stage', Icons.timeline, 'Negotiation'),
              _buildFilterTag('Source', Icons.source, 'LinkedIn'),
              _buildFilterTag('Value', Icons.attach_money, '\$50K+'),
              _buildFilterTag('Priority', Icons.priority_high, 'High'),
              _buildFilterTag('Activity', Icons.schedule, 'This Week'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFilterTag(String label, IconData icon, String value) {
    final isActive = _filters.containsKey(label.toLowerCase());
    
    return GestureDetector(
      onTap: () {
        setState(() {
          if (isActive) {
            _filters.remove(label.toLowerCase());
          } else {
            _filters[label.toLowerCase()] = value;
          }
        });
        widget.onAdvancedFilter(_filters);
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
        decoration: BoxDecoration(
          color: isActive ? AppTheme.accent.withAlpha(26) : AppTheme.surface,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isActive ? AppTheme.accent : AppTheme.border,
            width: 1,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 16,
              color: isActive ? AppTheme.accent : AppTheme.secondaryText,
            ),
            SizedBox(width: 2.w),
            Text(
              isActive ? '$label: $value' : label,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: isActive ? AppTheme.accent : AppTheme.secondaryText,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}