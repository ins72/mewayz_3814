import '../../core/app_export.dart';
import '../../theme/app_theme.dart';

class LinkInBioBuilder extends StatefulWidget {
  const LinkInBioBuilder({Key? key}) : super(key: key);

  @override
  State<LinkInBioBuilder> createState() => _LinkInBioBuilderState();
}

class _LinkInBioBuilderState extends State<LinkInBioBuilder> {
  String? _selectedTemplate;
  Map<String, dynamic>? _customizations;
  Map<String, dynamic> _bioData = {
    'title': 'Your Name',
    'description': 'Your bio description',
    'links': [],
    'theme': 'default',
    'colors': {
      'primary': '#007AFF',
      'secondary': '#34C759',
      'background': '#FFFFFF',
      'text': '#000000',
    },
  };

  @override
  void initState() {
    super.initState();
    _initializeFromArguments();
  }

  void _initializeFromArguments() {
    final args = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
    if (args != null) {
      _selectedTemplate = args['templateId'];
      _customizations = args['customizations'];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.primaryBackground,
      appBar: AppBar(
        title: Text(
          'Link in Bio Builder',
          style: GoogleFonts.inter(
            color: AppTheme.primaryText,
            fontWeight: FontWeight.w600,
          ),
        ),
        backgroundColor: AppTheme.primaryBackground,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: AppTheme.primaryText),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          TextButton(
            onPressed: _saveBio,
            child: Text(
              'Save',
              style: GoogleFonts.inter(
                color: AppTheme.accent,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
      body: Row(
        children: [
          // Editor Panel
          Expanded(
            flex: 1,
            child: Container(
              color: AppTheme.surface,
              child: Column(
                children: [
                  // Template Selection
                  Container(
                    padding: const EdgeInsets.all(16),
                    child: ElevatedButton(
                      onPressed: _showTemplateSelection,
                      child: const Text('Change Template'),
                    ),
                  ),
                  
                  // Component Editor
                  Expanded(
                    child: ComponentEditorBottomSheet(
                      bioData: _bioData,
                      onDataChanged: (data) {
                        setState(() {
                          _bioData = data;
                        });
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
          
          // Mobile Preview
          Expanded(
            flex: 1,
            child: MobilePreviewWidget(
              bioData: _bioData,
              templateId: _selectedTemplate,
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showQRCode,
        backgroundColor: AppTheme.accent,
        child: const Icon(Icons.qr_code),
      ),
    );
  }

  void _showTemplateSelection() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => TemplateSelectionModal(
        onTemplateSelected: (templateId) {
          setState(() {
            _selectedTemplate = templateId;
          });
          Navigator.pop(context);
        },
      ),
    );
  }

  void _showQRCode() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => QrCodeModal(
        url: 'https://linktr.ee/yourname',
        onDownload: () {
          Navigator.pop(context);
        },
      ),
    );
  }

  void _saveBio() {
    // Save bio data
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Bio saved successfully!'),
        backgroundColor: AppTheme.success,
      ),
    );
  }
}