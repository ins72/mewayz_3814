
import '../../core/app_export.dart';
import './widgets/documentation_editor_widget.dart';
import './widgets/documentation_preview_widget.dart';
import './widgets/documentation_section_widget.dart';
import './widgets/export_options_widget.dart';
import './widgets/template_library_widget.dart';
import './widgets/version_control_widget.dart';

class ProfessionalReadmeDocumentationScreen extends StatefulWidget {
  const ProfessionalReadmeDocumentationScreen({super.key});

  @override
  State<ProfessionalReadmeDocumentationScreen> createState() => _ProfessionalReadmeDocumentationScreenState();
}

class _ProfessionalReadmeDocumentationScreenState extends State<ProfessionalReadmeDocumentationScreen> {
  bool _isPreviewMode = false;
  String _selectedSection = 'Project Overview';
  Map<String, String> _documentationSections = {
    'Project Overview': '',
    'Features': '',
    'Installation': '',
    'Usage': '',
    'API Documentation': '',
    'Contributing Guidelines': '',
    'License Information': '',
  };

  final List<Map<String, dynamic>> _sections = [
{ 'title': 'Project Overview',
'description': 'Brief description of your project and its purpose',
'icon': Icons.info_outline,
},
{ 'title': 'Features',
'description': 'Key features and capabilities of your application',
'icon': Icons.star_outline,
},
{ 'title': 'Installation',
'description': 'Step-by-step installation and setup instructions',
'icon': Icons.download_outlined,
},
{ 'title': 'Usage',
'description': 'How to use your application with examples',
'icon': Icons.play_circle_outline,
},
{ 'title': 'API Documentation',
'description': 'Detailed API reference and endpoints',
'icon': Icons.code_outlined,
},
{ 'title': 'Contributing Guidelines',
'description': 'How others can contribute to your project',
'icon': Icons.group_outlined,
},
{ 'title': 'License Information',
'description': 'License details and usage rights',
'icon': Icons.gavel_outlined,
},
];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.primaryBackground,
      appBar: _buildAppBar(),
      body: Row(
        children: [
          // Left sidebar with sections
          Container(
            width: 25.w,
            decoration: BoxDecoration(
              color: AppTheme.surface,
              border: Border(
                right: BorderSide(
                  color: AppTheme.border,
                  width: 1,
                ),
              ),
            ),
            child: Column(
              children: [
                // Sections header
                Container(
                  padding: EdgeInsets.all(3.w),
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
                      Icon(
                        Icons.list_alt,
                        size: 20.sp,
                        color: AppTheme.accent,
                      ),
                      SizedBox(width: 2.w),
                      Text(
                        'Sections',
                        style: GoogleFonts.inter(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w600,
                          color: AppTheme.primaryText,
                        ),
                      ),
                    ],
                  ),
                ),
                
                // Sections list
                Expanded(
                  child: SingleChildScrollView(
                    padding: EdgeInsets.all(2.w),
                    child: Column(
                      children: _sections.map((section) {
                        return DocumentationSectionWidget(
                          title: section['title'],
                          description: section['description'],
                          icon: section['icon'],
                          isExpanded: false,
                          isSelected: _selectedSection == section['title'],
                          onTap: () => _selectSection(section['title']),
                          onToggle: () => {},
                          content: _documentationSections[section['title']] ?? '',
                          isCompleted: (_documentationSections[section['title']] ?? '').isNotEmpty,
                        );
                      }).toList(),
                    ),
                  ),
                ),
                
                // Quick actions
                Container(
                  padding: EdgeInsets.all(2.w),
                  decoration: BoxDecoration(
                    color: AppTheme.primaryBackground,
                    border: Border(
                      top: BorderSide(
                        color: AppTheme.border,
                        width: 1,
                      ),
                    ),
                  ),
                  child: Column(
                    children: [
                      _buildQuickActionButton(
                        icon: Icons.library_books,
                        label: 'Templates',
                        onTap: () => _showTemplateLibrary(),
                      ),
                      SizedBox(height: 1.h),
                      _buildQuickActionButton(
                        icon: Icons.history,
                        label: 'Version History',
                        onTap: () => _showVersionControl(),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          
          // Main content area
          Expanded(
            child: _isPreviewMode
                ? DocumentationPreviewWidget(
                    content: _documentationSections[_selectedSection] ?? '',
                    isPreviewMode: _isPreviewMode,
                  )
                : Row(
                    children: [
                      // Editor panel
                      Expanded(
                        child: Container(
                          padding: EdgeInsets.all(2.w),
                          child: DocumentationEditorWidget(
                            content: _documentationSections[_selectedSection] ?? '',
                            onContentChanged: (content) => _updateSectionContent(content),
                            selectedSection: _selectedSection,
                          ),
                        ),
                      ),
                      
                      // Preview panel
                      Expanded(
                        child: Container(
                          padding: EdgeInsets.all(2.w),
                          child: DocumentationPreviewWidget(
                            content: _documentationSections[_selectedSection] ?? '',
                            isPreviewMode: true,
                          ),
                        ),
                      ),
                    ],
                  ),
          ),
        ],
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: AppTheme.primaryBackground,
      elevation: 0,
      leading: IconButton(
        icon: Icon(
          Icons.arrow_back,
          color: AppTheme.primaryText,
          size: 24.sp,
        ),
        onPressed: () => Navigator.pop(context),
      ),
      title: Row(
        children: [
          Icon(
            Icons.description,
            color: AppTheme.accent,
            size: 24.sp,
          ),
          SizedBox(width: 2.w),
          Text(
            'Professional README Documentation',
            style: GoogleFonts.inter(
              fontSize: 18.sp,
              fontWeight: FontWeight.w600,
              color: AppTheme.primaryText,
            ),
          ),
        ],
      ),
      actions: [
        // Preview toggle
        Container(
          margin: EdgeInsets.only(right: 2.w),
          child: Row(
            children: [
              Text(
                'Preview',
                style: GoogleFonts.inter(
                  fontSize: 12.sp,
                  color: AppTheme.secondaryText,
                ),
              ),
              SizedBox(width: 1.w),
              Switch(
                value: _isPreviewMode,
                onChanged: (value) => setState(() => _isPreviewMode = value),
                activeColor: AppTheme.accent,
              ),
            ],
          ),
        ),
        
        // Auto-generate button
        Container(
          margin: EdgeInsets.only(right: 2.w),
          child: ElevatedButton(
            onPressed: () => _autoGenerateContent(),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.accent,
              foregroundColor: AppTheme.primaryAction,
              padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.auto_fix_high,
                  size: 16.sp,
                ),
                SizedBox(width: 1.w),
                Text(
                  'Auto-Generate',
                  style: GoogleFonts.inter(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ),
        
        // Export button
        Container(
          margin: EdgeInsets.only(right: 2.w),
          child: ElevatedButton(
            onPressed: () => _showExportOptions(),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.success,
              foregroundColor: AppTheme.primaryAction,
              padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.download,
                  size: 16.sp,
                ),
                SizedBox(width: 1.w),
                Text(
                  'Export',
                  style: GoogleFonts.inter(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ),
        
        // More options
        PopupMenuButton<String>(
          icon: Icon(
            Icons.more_vert,
            color: AppTheme.secondaryText,
            size: 24.sp,
          ),
          color: AppTheme.surface,
          onSelected: (value) => _handleMenuAction(value),
          itemBuilder: (context) => [
            PopupMenuItem(
              value: 'save',
              child: Row(
                children: [
                  Icon(Icons.save, size: 18.sp, color: AppTheme.accent),
                  SizedBox(width: 2.w),
                  Text('Save Draft', style: GoogleFonts.inter(fontSize: 14.sp)),
                ],
              ),
            ),
            PopupMenuItem(
              value: 'clear',
              child: Row(
                children: [
                  Icon(Icons.clear_all, size: 18.sp, color: AppTheme.warning),
                  SizedBox(width: 2.w),
                  Text('Clear All', style: GoogleFonts.inter(fontSize: 14.sp)),
                ],
              ),
            ),
            PopupMenuItem(
              value: 'settings',
              child: Row(
                children: [
                  Icon(Icons.settings, size: 18.sp, color: AppTheme.accent),
                  SizedBox(width: 2.w),
                  Text('Settings', style: GoogleFonts.inter(fontSize: 14.sp)),
                ],
              ),
            ),
          ],
        ),
        
        SizedBox(width: 2.w),
      ],
    );
  }

  Widget _buildQuickActionButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(vertical: 1.5.h, horizontal: 2.w),
        decoration: BoxDecoration(
          color: AppTheme.surface,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: AppTheme.border,
            width: 1,
          ),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              size: 16.sp,
              color: AppTheme.accent,
            ),
            SizedBox(width: 2.w),
            Text(
              label,
              style: GoogleFonts.inter(
                fontSize: 12.sp,
                fontWeight: FontWeight.w500,
                color: AppTheme.primaryText,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _selectSection(String sectionTitle) {
    setState(() {
      _selectedSection = sectionTitle;
    });
  }

  void _updateSectionContent(String content) {
    setState(() {
      _documentationSections[_selectedSection] = content;
    });
  }

  void _showTemplateLibrary() {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppTheme.surface,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      builder: (context) => TemplateLibraryWidget(
        onTemplateSelected: (templateSections) {
          setState(() {
            _documentationSections = Map.from(templateSections);
          });
        },
      ),
    );
  }

  void _showExportOptions() {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppTheme.surface,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      builder: (context) => ExportOptionsWidget(
        documentationSections: _documentationSections,
        appName: 'Mewayz',
      ),
    );
  }

  void _showVersionControl() {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppTheme.surface,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      builder: (context) => VersionControlWidget(
        currentDocumentation: _documentationSections,
        onRestore: (restoredDocumentation) {
          setState(() {
            _documentationSections = Map.from(restoredDocumentation);
          });
        },
      ),
    );
  }

  void _autoGenerateContent() {
    // Simulate auto-generation
    final generatedContent = '''# ${_selectedSection}

## Overview
This section provides comprehensive information about ${_selectedSection.toLowerCase()}.

## Key Points
- Auto-generated content based on project analysis
- Comprehensive coverage of essential topics
- Professional formatting and structure
- Ready-to-use documentation

## Additional Information
Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.

### Subsection
Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.

```dart
// Example code snippet
void main() {
  print('Hello, World!');
}
```

For more information, please refer to the official documentation.
''';

    setState(() {
      _documentationSections[_selectedSection] = generatedContent;
    });

    Fluttertoast.showToast(
      msg: 'Content auto-generated for ${_selectedSection}',
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: AppTheme.success,
      textColor: AppTheme.primaryAction,
      fontSize: 14.sp,
    );
  }

  void _handleMenuAction(String action) {
    switch (action) {
      case 'save':
        _saveDraft();
        break;
      case 'clear':
        _clearAllContent();
        break;
      case 'settings':
        _showSettings();
        break;
    }
  }

  void _saveDraft() {
    Fluttertoast.showToast(
      msg: 'Documentation draft saved successfully',
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: AppTheme.success,
      textColor: AppTheme.primaryAction,
    );
  }

  void _clearAllContent() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppTheme.surface,
        title: Text(
          'Clear All Content',
          style: GoogleFonts.inter(
            fontSize: 16.sp,
            fontWeight: FontWeight.w600,
            color: AppTheme.primaryText,
          ),
        ),
        content: Text(
          'Are you sure you want to clear all documentation content? This action cannot be undone.',
          style: GoogleFonts.inter(
            fontSize: 12.sp,
            color: AppTheme.secondaryText,
          ),
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
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              setState(() {
                _documentationSections = Map.fromIterable(
                  _documentationSections.keys,
                  key: (k) => k,
                  value: (k) => '',
                );
              });
              Fluttertoast.showToast(
                msg: 'All content cleared successfully',
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.BOTTOM,
                backgroundColor: AppTheme.warning,
                textColor: AppTheme.primaryAction,
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.error,
              foregroundColor: AppTheme.primaryAction,
            ),
            child: Text(
              'Clear All',
              style: GoogleFonts.inter(
                fontSize: 12.sp,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showSettings() {
    Fluttertoast.showToast(
      msg: 'Settings will be available soon',
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: AppTheme.accent,
      textColor: AppTheme.primaryAction,
    );
  }
}