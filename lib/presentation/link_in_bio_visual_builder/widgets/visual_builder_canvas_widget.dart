import '../../../core/app_export.dart';

class VisualBuilderCanvasWidget extends StatefulWidget {
  final Map<String, dynamic>? currentPage;
  final List<Map<String, dynamic>> components;
  final Map<String, dynamic>? selectedComponent;
  final Function(Map<String, dynamic>) onComponentSelect;
  final Function(String, Map<String, dynamic>) onComponentUpdate;
  final Function(String) onComponentDelete;
  final Function(int, int) onComponentReorder;

  const VisualBuilderCanvasWidget({
    Key? key,
    required this.currentPage,
    required this.components,
    required this.selectedComponent,
    required this.onComponentSelect,
    required this.onComponentUpdate,
    required this.onComponentDelete,
    required this.onComponentReorder,
  }) : super(key: key);

  @override
  State<VisualBuilderCanvasWidget> createState() => _VisualBuilderCanvasWidgetState();
}

class _VisualBuilderCanvasWidgetState extends State<VisualBuilderCanvasWidget> {
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final themeSettings = widget.currentPage?['theme_settings'] as Map<String, dynamic>? ?? {};
    final backgroundColor = Color(int.parse((themeSettings['background_color'] as String? ?? '#ffffff').replaceFirst('#', '0xFF')));

    return Container(
      decoration: BoxDecoration(
        color: AppTheme.surface,
      ),
      child: Column(
        children: [
          // Canvas header
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppTheme.primaryBackground,
              border: Border(
                bottom: BorderSide(
                  color: AppTheme.border,
                  width: 1,
                ),
              ),
            ),
            child: Row(
              children: [
                Text(
                  'Visual Editor',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: AppTheme.primaryText,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: AppTheme.accent.withAlpha(26),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    '${widget.components.length} components',
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      color: AppTheme.accent,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Mobile preview frame
          Expanded(
            child: Center(
              child: Container(
                width: 375,
                height: double.infinity,
                margin: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: backgroundColor,
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(
                    color: AppTheme.border,
                    width: 2,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withAlpha(26),
                      blurRadius: 20,
                      spreadRadius: 0,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    // Mock status bar
                    Container(
                      height: 44,
                      decoration: BoxDecoration(
                        color: backgroundColor,
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(22),
                          topRight: Radius.circular(22),
                        ),
                      ),
                      child: const Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text('9:41', style: TextStyle(fontWeight: FontWeight.w600)),
                          ],
                        ),
                      ),
                    ),

                    // Page content
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          color: backgroundColor,
                        ),
                        child: widget.components.isEmpty
                            ? _buildEmptyState()
                            : ReorderableListView.builder(
                                scrollController: _scrollController,
                                padding: const EdgeInsets.all(16),
                                itemCount: widget.components.length,
                                onReorder: widget.onComponentReorder,
                                itemBuilder: (context, index) {
                                  final component = widget.components[index];
                                  final isSelected = widget.selectedComponent?['id'] == component['id'];

                                  return Container(
                                    key: ValueKey(component['id']),
                                    margin: const EdgeInsets.only(bottom: 8),
                                    child: GestureDetector(
                                      onTap: () => widget.onComponentSelect(component),
                                      child: Container(
                                        decoration: BoxDecoration(
                                          border: isSelected
                                              ? Border.all(
                                                  color: AppTheme.accent,
                                                  width: 2,
                                                )
                                              : null,
                                          borderRadius: BorderRadius.circular(8),
                                        ),
                                        child: Stack(
                                          children: [
                                            Container(
                                              child: Text('Component: ${component['type']}'),
                                            ),
                                            if (isSelected)
                                              Positioned(
                                                top: 8,
                                                right: 8,
                                                child: Row(
                                                  mainAxisSize: MainAxisSize.min,
                                                  children: [
                                                    _buildActionButton(
                                                      icon: Icons.edit,
                                                      onTap: () => widget.onComponentSelect(component),
                                                      color: AppTheme.accent,
                                                    ),
                                                    const SizedBox(width: 4),
                                                    _buildActionButton(
                                                      icon: Icons.delete,
                                                      onTap: () => _showDeleteDialog(component),
                                                      color: Colors.red,
                                                    ),
                                                  ],
                                                ),
                                              ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              ),
                      ),
                    ),

                    // Mock home indicator
                    Container(
                      height: 34,
                      decoration: BoxDecoration(
                        color: backgroundColor,
                        borderRadius: const BorderRadius.only(
                          bottomLeft: Radius.circular(22),
                          bottomRight: Radius.circular(22),
                        ),
                      ),
                      child: Center(
                        child: Container(
                          width: 134,
                          height: 5,
                          decoration: BoxDecoration(
                            color: Colors.black,
                            borderRadius: BorderRadius.circular(2.5),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.add_box_outlined,
            size: 64,
            color: AppTheme.secondaryText,
          ),
          const SizedBox(height: 16),
          Text(
            'No components yet',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: AppTheme.secondaryText,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Add components from the left panel\nto start building your page',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: AppTheme.secondaryText,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required VoidCallback onTap,
    required Color color,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 32,
        height: 32,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(6),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha(51),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Icon(
          icon,
          color: Colors.white,
          size: 18,
        ),
      ),
    );
  }

  void _showDeleteDialog(Map<String, dynamic> component) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Component'),
        content: const Text('Are you sure you want to delete this component? This action cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              widget.onComponentDelete(component['id']);
            },
            style: TextButton.styleFrom(
              foregroundColor: Colors.red,
            ),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}