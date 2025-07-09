import '../../../core/app_export.dart';

class TemplateSearchWidget extends StatefulWidget {
  final String searchQuery;
  final Function(String) onSearchChanged;

  const TemplateSearchWidget({
    Key? key,
    required this.searchQuery,
    required this.onSearchChanged,
  }) : super(key: key);

  @override
  State<TemplateSearchWidget> createState() => _TemplateSearchWidgetState();
}

class _TemplateSearchWidgetState extends State<TemplateSearchWidget> {
  late TextEditingController _searchController;
  late FocusNode _searchFocusNode;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController(text: widget.searchQuery);
    _searchFocusNode = FocusNode();
  }

  @override
  void dispose() {
    _searchController.dispose();
    _searchFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 48,
      decoration: BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: _searchFocusNode.hasFocus ? AppTheme.accent : AppTheme.border,
          width: 1,
        ),
      ),
      child: Row(
        children: [
          const SizedBox(width: 12),
          Icon(
            Icons.search,
            color: AppTheme.secondaryText,
            size: 20,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: TextField(
              controller: _searchController,
              focusNode: _searchFocusNode,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: AppTheme.primaryText,
              ),
              decoration: InputDecoration(
                hintText: 'Search templates by name, category, or style...',
                hintStyle: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppTheme.secondaryText,
                ),
                border: InputBorder.none,
                contentPadding: EdgeInsets.zero,
              ),
              onChanged: widget.onSearchChanged,
            ),
          ),
          if (_searchController.text.isNotEmpty)
            GestureDetector(
              onTap: () {
                _searchController.clear();
                widget.onSearchChanged('');
              },
              child: Container(
                padding: const EdgeInsets.all(4),
                child: Icon(
                  Icons.clear,
                  color: AppTheme.secondaryText,
                  size: 18,
                ),
              ),
            ),
          const SizedBox(width: 12),
        ],
      ),
    );
  }
}