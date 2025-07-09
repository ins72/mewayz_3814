
import '../../../core/app_export.dart';

class DocumentationPreviewWidget extends StatefulWidget {
  final String content;
  final bool isPreviewMode;

  const DocumentationPreviewWidget({
    super.key,
    required this.content,
    required this.isPreviewMode,
  });

  @override
  State<DocumentationPreviewWidget> createState() => _DocumentationPreviewWidgetState();
}

class _DocumentationPreviewWidgetState extends State<DocumentationPreviewWidget> {
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  String _renderMarkdown(String markdown) {
    if (markdown.isEmpty) return '';
    
    // Simple markdown-to-text conversion for preview
    String rendered = markdown;
    
    // Headers
    rendered = rendered.replaceAllMapped(
      RegExp(r'^### (.+)$', multiLine: true),
      (match) => '${match.group(1)}\n',
    );
    rendered = rendered.replaceAllMapped(
      RegExp(r'^## (.+)$', multiLine: true),
      (match) => '${match.group(1)}\n',
    );
    rendered = rendered.replaceAllMapped(
      RegExp(r'^# (.+)$', multiLine: true),
      (match) => '${match.group(1)}\n',
    );
    
    // Bold and italic
    rendered = rendered.replaceAllMapped(
      RegExp(r'\*\*(.+?)\*\*'),
      (match) => match.group(1) ?? '',
    );
    rendered = rendered.replaceAllMapped(
      RegExp(r'\*(.+?)\*'),
      (match) => match.group(1) ?? '',
    );
    
    // Code
    rendered = rendered.replaceAllMapped(
      RegExp(r'`(.+?)`'),
      (match) => match.group(1) ?? '',
    );
    
    // Links
    rendered = rendered.replaceAllMapped(
      RegExp(r'\[(.+?)\]\((.+?)\)'),
      (match) => match.group(1) ?? '',
    );
    
    return rendered;
  }

  Widget _buildPreviewContent() {
    if (widget.content.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.preview_outlined,
              size: 48.sp,
              color: AppTheme.secondaryText.withAlpha(128),
            ),
            SizedBox(height: 2.h),
            Text(
              'Preview will appear here',
              style: GoogleFonts.inter(
                fontSize: 16.sp,
                color: AppTheme.secondaryText,
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(height: 1.h),
            Text(
              'Start typing in the editor to see the preview',
              style: GoogleFonts.inter(
                fontSize: 12.sp,
                color: AppTheme.secondaryText.withAlpha(179),
              ),
            ),
          ],
        ),
      );
    }

    return SingleChildScrollView(
      controller: _scrollController,
      padding: EdgeInsets.all(3.w),
      child: _buildMarkdownContent(widget.content),
    );
  }

  Widget _buildMarkdownContent(String content) {
    final lines = content.split('\n');
    List<Widget> widgets = [];

    for (int i = 0; i < lines.length; i++) {
      final line = lines[i];
      
      if (line.startsWith('# ')) {
        widgets.add(_buildHeader(line.substring(2), 1));
      } else if (line.startsWith('## ')) {
        widgets.add(_buildHeader(line.substring(3), 2));
      } else if (line.startsWith('### ')) {
        widgets.add(_buildHeader(line.substring(4), 3));
      } else if (line.startsWith('- ')) {
        widgets.add(_buildBulletPoint(line.substring(2)));
      } else if (line.trim().startsWith('```')) {
        // Handle code blocks
        final codeLines = <String>[];
        i++; // Skip the opening ```
        while (i < lines.length && !lines[i].trim().startsWith('```')) {
          codeLines.add(lines[i]);
          i++;
        }
        widgets.add(_buildCodeBlock(codeLines.join('\n')));
      } else if (line.isNotEmpty) {
        widgets.add(_buildParagraph(line));
      } else {
        widgets.add(SizedBox(height: 1.h));
      }
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: widgets,
    );
  }

  Widget _buildHeader(String text, int level) {
    final fontSize = level == 1 ? 20.sp : level == 2 ? 18.sp : 16.sp;
    final fontWeight = level == 1 ? FontWeight.w600 : FontWeight.w500;
    
    return Padding(
      padding: EdgeInsets.only(bottom: 1.h, top: level == 1 ? 0 : 1.h),
      child: Text(
        text,
        style: GoogleFonts.inter(
          fontSize: fontSize,
          fontWeight: fontWeight,
          color: AppTheme.primaryText,
        ),
      ),
    );
  }

  Widget _buildParagraph(String text) {
    return Padding(
      padding: EdgeInsets.only(bottom: 1.h),
      child: _buildRichText(text),
    );
  }

  Widget _buildBulletPoint(String text) {
    return Padding(
      padding: EdgeInsets.only(bottom: 0.5.h, left: 2.w),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: EdgeInsets.only(top: 0.8.h, right: 2.w),
            width: 4,
            height: 4,
            decoration: BoxDecoration(
              color: AppTheme.accent,
              shape: BoxShape.circle,
            ),
          ),
          Expanded(child: _buildRichText(text)),
        ],
      ),
    );
  }

  Widget _buildCodeBlock(String code) {
    return Container(
      margin: EdgeInsets.only(bottom: 2.h),
      padding: EdgeInsets.all(2.w),
      decoration: BoxDecoration(
        color: AppTheme.primaryBackground,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: AppTheme.border,
          width: 1,
        ),
      ),
      child: Text(
        code,
        style: GoogleFonts.jetBrainsMono(
          fontSize: 12.sp,
          color: AppTheme.primaryText,
          height: 1.4,
        ),
      ),
    );
  }

  Widget _buildRichText(String text) {
    return Text(
      text,
      style: GoogleFonts.inter(
        fontSize: 14.sp,
        color: AppTheme.primaryText,
        height: 1.6,
      ),
    );
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
            'Preview',
            style: GoogleFonts.inter(
              fontSize: 14.sp,
              fontWeight: FontWeight.w500,
              color: AppTheme.primaryText,
            ),
          ),
          const Spacer(),
          Icon(
            Icons.auto_awesome,
            size: 16.sp,
            color: AppTheme.accent,
          ),
          SizedBox(width: 1.w),
          Text(
            'Live Preview',
            style: GoogleFonts.inter(
              fontSize: 12.sp,
              color: AppTheme.accent,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
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
            child: widget.isPreviewMode
                ? _buildPreviewContent()
                : Container(
                    padding: EdgeInsets.all(3.w),
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.edit_note,
                            size: 48.sp,
                            color: AppTheme.secondaryText.withAlpha(128),
                          ),
                          SizedBox(height: 2.h),
                          Text(
                            'Switch to Preview Mode',
                            style: GoogleFonts.inter(
                              fontSize: 16.sp,
                              color: AppTheme.secondaryText,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          SizedBox(height: 1.h),
                          Text(
                            'Toggle preview in the header to see rendered content',
                            style: GoogleFonts.inter(
                              fontSize: 12.sp,
                              color: AppTheme.secondaryText.withAlpha(179),
                            ),
                            textAlign: TextAlign.center,
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
}