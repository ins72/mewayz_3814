import '../../core/app_export.dart';

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
                    child: _buildComponentEditor(),
                  ),
                ],
              ),
            ),
          ),
          
          // Mobile Preview
          Expanded(
            flex: 1,
            child: _buildMobilePreview(),
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

  Widget _buildComponentEditor() {
    // TODO: Implement ComponentEditorBottomSheet
    return Container(
      child: Text('Component Editor Placeholder'),
    );
  }

  Widget _buildMobilePreview() {
    // TODO: Implement MobilePreviewWidget
    return Container(
      child: Text('Mobile Preview Placeholder'),
    );
  }

  void _showTemplateSelection() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _buildTemplateSelectionModal(),
    );
  }

  Widget _buildTemplateSelectionModal() {
    // TODO: Implement TemplateSelectionModal
    return Container(
      child: Text('Template Selection Modal Placeholder'),
    );
  }

  void _showQRCode() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _buildQrCodeModal(),
    );
  }

  Widget _buildQrCodeModal() {
    // TODO: Implement QrCodeModal
    return Container(
      child: Text('QR Code Modal Placeholder'),
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