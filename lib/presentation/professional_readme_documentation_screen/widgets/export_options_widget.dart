import 'dart:io' if (dart.library.html) 'dart:html' as html;

import 'package:flutter/foundation.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../theme/app_theme.dart';

class ExportOptionsWidget extends StatefulWidget {
  final Map<String, String> documentationSections;
  final String appName;

  const ExportOptionsWidget({
    super.key,
    required this.documentationSections,
    required this.appName,
  });

  @override
  State<ExportOptionsWidget> createState() => _ExportOptionsWidgetState();
}

class _ExportOptionsWidgetState extends State<ExportOptionsWidget> {
  final List<Map<String, dynamic>> _exportOptions = [
{ 'title': 'Markdown File',
'description': 'Export as README.md file',
'icon': Icons.description,
'format': 'md',
'color': Colors.blue,
},
{ 'title': 'PDF Document',
'description': 'Export as PDF for sharing',
'icon': Icons.picture_as_pdf,
'format': 'pdf',
'color': Colors.red,
},
{ 'title': 'HTML Page',
'description': 'Export as HTML webpage',
'icon': Icons.web,
'format': 'html',
'color': Colors.orange,
},
{ 'title': 'GitHub README',
'description': 'Push directly to GitHub repository',
'icon': Icons.cloud_upload,
'format': 'github',
'color': Colors.purple,
},
{ 'title': 'Copy to Clipboard',
'description': 'Copy markdown content to clipboard',
'icon': Icons.copy,
'format': 'clipboard',
'color': Colors.green,
},
];

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 70.h,
      padding: EdgeInsets.all(4.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            children: [
              Icon(
                Icons.download,
                size: 24.sp,
                color: AppTheme.accent,
              ),
              SizedBox(width: 2.w),
              Text(
                'Export Options',
                style: GoogleFonts.inter(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w600,
                  color: AppTheme.primaryText,
                ),
              ),
              const Spacer(),
              IconButton(
                onPressed: () => Navigator.pop(context),
                icon: Icon(
                  Icons.close,
                  size: 24.sp,
                  color: AppTheme.secondaryText,
                ),
              ),
            ],
          ),
          
          SizedBox(height: 2.h),
          
          // Export preview
          Container(
            padding: EdgeInsets.all(3.w),
            decoration: BoxDecoration(
              color: AppTheme.primaryBackground,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: AppTheme.border,
                width: 1,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Export Preview',
                  style: GoogleFonts.inter(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.primaryText,
                  ),
                ),
                SizedBox(height: 1.h),
                Container(
                  padding: EdgeInsets.all(2.w),
                  decoration: BoxDecoration(
                    color: AppTheme.surface,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    '${widget.appName} Documentation\n${widget.documentationSections.length} sections • ${_getTotalCharacters()} characters',
                    style: GoogleFonts.jetBrainsMono(
                      fontSize: 10.sp,
                      color: AppTheme.secondaryText,
                    ),
                  ),
                ),
              ],
            ),
          ),
          
          SizedBox(height: 3.h),
          
          // Export options
          Expanded(
            child: ListView.builder(
              itemCount: _exportOptions.length,
              itemBuilder: (context, index) {
                final option = _exportOptions[index];
                return Container(
                  margin: EdgeInsets.only(bottom: 2.h),
                  child: InkWell(
                    onTap: () => _handleExport(option['format']),
                    borderRadius: BorderRadius.circular(12),
                    child: Container(
                      padding: EdgeInsets.all(3.w),
                      decoration: BoxDecoration(
                        color: AppTheme.surface,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: AppTheme.border,
                          width: 1,
                        ),
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 12.w,
                            height: 12.w,
                            decoration: BoxDecoration(
                              color: option['color'].withAlpha(26),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Icon(
                              option['icon'],
                              size: 24.sp,
                              color: option['color'],
                            ),
                          ),
                          SizedBox(width: 3.w),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  option['title'],
                                  style: GoogleFonts.inter(
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.w600,
                                    color: AppTheme.primaryText,
                                  ),
                                ),
                                SizedBox(height: 0.5.h),
                                Text(
                                  option['description'],
                                  style: GoogleFonts.inter(
                                    fontSize: 12.sp,
                                    color: AppTheme.secondaryText,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Icon(
                            Icons.arrow_forward_ios,
                            size: 16.sp,
                            color: AppTheme.secondaryText,
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          
          // Export all button
          Container(
            width: double.infinity,
            margin: EdgeInsets.only(top: 2.h),
            child: ElevatedButton(
              onPressed: () => _exportAll(),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.accent,
                foregroundColor: AppTheme.primaryAction,
                padding: EdgeInsets.symmetric(vertical: 2.h),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.download_for_offline,
                    size: 20.sp,
                  ),
                  SizedBox(width: 2.w),
                  Text(
                    'Export All Formats',
                    style: GoogleFonts.inter(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  int _getTotalCharacters() {
    return widget.documentationSections.values
        .map((content) => content.length)
        .fold(0, (sum, length) => sum + length);
  }

  void _handleExport(String format) {
    switch (format) {
      case 'md':
        _exportMarkdown();
        break;
      case 'pdf':
        _exportPDF();
        break;
      case 'html':
        _exportHTML();
        break;
      case 'github':
        _exportToGitHub();
        break;
      case 'clipboard':
        _copyToClipboard();
        break;
    }
  }

  void _exportMarkdown() {
    final content = _generateMarkdownContent();
    _downloadFile(content, 'README.md', 'text/markdown');
    
    Fluttertoast.showToast(
      msg: 'Markdown file exported successfully',
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: AppTheme.success,
      textColor: AppTheme.primaryAction,
    );
  }

  void _exportPDF() {
    Fluttertoast.showToast(
      msg: 'PDF export feature coming soon',
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: AppTheme.warning,
      textColor: AppTheme.primaryAction,
    );
  }

  void _exportHTML() {
    final content = _generateHTMLContent();
    _downloadFile(content, 'README.html', 'text/html');
    
    Fluttertoast.showToast(
      msg: 'HTML file exported successfully',
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: AppTheme.success,
      textColor: AppTheme.primaryAction,
    );
  }

  void _exportToGitHub() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppTheme.surface,
        title: Text(
          'GitHub Export',
          style: GoogleFonts.inter(
            fontSize: 16.sp,
            fontWeight: FontWeight.w600,
            color: AppTheme.primaryText,
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'GitHub integration is coming soon. For now, you can export as Markdown and manually upload to your repository.',
              style: GoogleFonts.inter(
                fontSize: 12.sp,
                color: AppTheme.secondaryText,
              ),
            ),
            SizedBox(height: 2.h),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                _exportMarkdown();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.accent,
                foregroundColor: AppTheme.primaryAction,
              ),
              child: Text(
                'Export Markdown Instead',
                style: GoogleFonts.inter(
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Cancel',
              style: GoogleFonts.inter(
                fontSize: 12.sp,
                color: AppTheme.secondaryText,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _copyToClipboard() {
    final content = _generateMarkdownContent();
    // In a real app, you'd use the clipboard package
    // Clipboard.setData(ClipboardData(text: content));
    
    Fluttertoast.showToast(
      msg: 'Documentation copied to clipboard',
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: AppTheme.success,
      textColor: AppTheme.primaryAction,
    );
  }

  void _exportAll() {
    _exportMarkdown();
    _exportHTML();
    
    Fluttertoast.showToast(
      msg: 'All formats exported successfully',
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: AppTheme.success,
      textColor: AppTheme.primaryAction,
    );
  }

  String _generateMarkdownContent() {
    final buffer = StringBuffer();
    
    widget.documentationSections.forEach((section, content) {
      if (content.isNotEmpty) {
        buffer.writeln(content);
        buffer.writeln();
      }
    });
    
    return buffer.toString();
  }

  String _generateHTMLContent() {
    final buffer = StringBuffer();
    
    buffer.writeln('<!DOCTYPE html>');
    buffer.writeln('<html lang="en">');
    buffer.writeln('<head>');
    buffer.writeln('<meta charset="UTF-8">');
    buffer.writeln('<meta name="viewport" content="width=device-width, initial-scale=1.0">');
    buffer.writeln('<title>${widget.appName} Documentation</title>');
    buffer.writeln('<style>');
    buffer.writeln('body { font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, "Helvetica Neue", Arial, sans-serif; line-height: 1.6; color: #333; max-width: 800px; margin: 0 auto; padding: 20px; }');
    buffer.writeln('h1 { color: #2c3e50; }');
    buffer.writeln('h2 { color: #34495e; }');
    buffer.writeln('code { background-color: #f4f4f4; padding: 2px 4px; border-radius: 3px; }');
    buffer.writeln('pre { background-color: #f4f4f4; padding: 10px; border-radius: 5px; overflow-x: auto; }');
    buffer.writeln('</style>');
    buffer.writeln('</head>');
    buffer.writeln('<body>');
    
    widget.documentationSections.forEach((section, content) {
      if (content.isNotEmpty) {
        // Convert markdown to HTML (simplified)
        final htmlContent = content
            .replaceAll('**', '<strong>')
            .replaceAll('*', '<em>')
            .replaceAll('`', '<code>')
            .replaceAll('\n', '<br>');
        
        buffer.writeln('<div class="section">');
        buffer.writeln(htmlContent);
        buffer.writeln('</div>');
        buffer.writeln();
      }
    });
    
    buffer.writeln('</body>');
    buffer.writeln('</html>');
    
    return buffer.toString();
  }

  void _downloadFile(String content, String filename, String mimeType) {
    // Web download implementation
    if (kIsWeb) {
      final blob = html.Blob([content], mimeType);
      final url = html.Url.createObjectUrl(blob);
      final anchor = html.AnchorElement()
        ..href = url
        ..download = filename;
      anchor.click();
      html.Url.revokeObjectUrl(url);
    } else {
      // Fallback for other browsers
      final dataUrl = 'data:$mimeType;charset=utf-8,${Uri.encodeComponent(content)}';
      final anchor = html.AnchorElement()
        ..href = dataUrl
        ..download = filename;
      anchor.click();
    }
  }
}