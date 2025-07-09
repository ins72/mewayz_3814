
import '../../../core/app_export.dart';

class DocumentationEditorWidget extends StatefulWidget {
  final String content;
  final Function(String) onContentChanged;
  final String selectedSection;

  const DocumentationEditorWidget({
    super.key,
    required this.content,
    required this.onContentChanged,
    required this.selectedSection,
  });

  @override
  State<DocumentationEditorWidget> createState() => _DocumentationEditorWidgetState();
}

class _DocumentationEditorWidgetState extends State<DocumentationEditorWidget> {
  late TextEditingController _textController;
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _textController = TextEditingController(text: widget.content);
    _textController.addListener(_onTextChanged);
  }

  @override
  void didUpdateWidget(DocumentationEditorWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.content != widget.content) {
      _textController.text = widget.content;
    }
  }

  @override
  void dispose() {
    _textController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _onTextChanged() {
    widget.onContentChanged(_textController.text);
  }

  void _insertMarkdown(String prefix, String suffix) {
    final text = _textController.text;
    final selection = _textController.selection;
    
    if (selection.isValid) {
      final selectedText = selection.textInside(text);
      final newText = text.replaceRange(
        selection.start,
        selection.end,
        '$prefix$selectedText$suffix',
      );
      
      _textController.text = newText;
      _textController.selection = TextSelection.collapsed(
        offset: selection.start + prefix.length + selectedText.length,
      );
    }
  }

  Widget _buildToolbar() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 1.h),
      decoration: BoxDecoration(
        color: AppTheme.surface,
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
            'Editor',
            style: GoogleFonts.inter(
              fontSize: 14.sp,
              fontWeight: FontWeight.w500,
              color: AppTheme.primaryText,
            ),
          ),
          const Spacer(),
          _buildToolbarButton(
            icon: Icons.format_bold,
            tooltip: 'Bold',
            onPressed: () => _insertMarkdown('**', '**'),
          ),
          SizedBox(width: 1.w),
          _buildToolbarButton(
            icon: Icons.format_italic,
            tooltip: 'Italic',
            onPressed: () => _insertMarkdown('*', '*'),
          ),
          SizedBox(width: 1.w),
          _buildToolbarButton(
            icon: Icons.code,
            tooltip: 'Code',
            onPressed: () => _insertMarkdown('`', '`'),
          ),
          SizedBox(width: 1.w),
          _buildToolbarButton(
            icon: Icons.link,
            tooltip: 'Link',
            onPressed: () => _insertMarkdown('[', '](url)'),
          ),
          SizedBox(width: 1.w),
          _buildToolbarButton(
            icon: Icons.format_list_bulleted,
            tooltip: 'Bullet List',
            onPressed: () => _insertMarkdown('- ', ''),
          ),
          SizedBox(width: 1.w),
          _buildToolbarButton(
            icon: Icons.format_list_numbered,
            tooltip: 'Numbered List',
            onPressed: () => _insertMarkdown('1. ', ''),
          ),
        ],
      ),
    );
  }

  Widget _buildToolbarButton({
    required IconData icon,
    required String tooltip,
    required VoidCallback onPressed,
  }) {
    return Tooltip(
      message: tooltip,
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(8),
        child: Container(
          padding: EdgeInsets.all(1.w),
          decoration: BoxDecoration(
            color: Colors.transparent,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            icon,
            size: 20.sp,
            color: AppTheme.secondaryText,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppTheme.border,
          width: 1,
        ),
      ),
      child: Column(
        children: [
          _buildToolbar(),
          Expanded(
            child: Container(
              padding: EdgeInsets.all(3.w),
              child: TextField(
                controller: _textController,
                focusNode: _focusNode,
                maxLines: null,
                expands: true,
                textAlignVertical: TextAlignVertical.top,
                style: GoogleFonts.jetBrainsMono(
                  fontSize: 12.sp,
                  color: AppTheme.primaryText,
                  height: 1.6,
                ),
                decoration: InputDecoration(
                  hintText: 'Write your ${widget.selectedSection} documentation here...\n\nSupported Markdown:\n• **Bold text**\n• *Italic text*\n• `Code snippets`\n• [Links](url)\n• - Bullet points\n• 1. Numbered lists\n• # Headers',
                  hintStyle: GoogleFonts.jetBrainsMono(
                    fontSize: 12.sp,
                    color: AppTheme.secondaryText.withAlpha(153),
                    height: 1.6,
                  ),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.zero,
                ),
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
            decoration: BoxDecoration(
              color: AppTheme.primaryBackground,
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(12),
                bottomRight: Radius.circular(12),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Lines: ${_textController.text.split('\n').length}',
                  style: GoogleFonts.inter(
                    fontSize: 10.sp,
                    color: AppTheme.secondaryText,
                  ),
                ),
                Text(
                  'Characters: ${_textController.text.length}',
                  style: GoogleFonts.inter(
                    fontSize: 10.sp,
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
}