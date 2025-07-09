import '../../core/app_export.dart';
import './widgets/component_editor_bottom_sheet.dart';
import './widgets/custom_domain_modal.dart';
import './widgets/mobile_preview_widget.dart';
import './widgets/qr_code_modal.dart';
import './widgets/template_selection_modal.dart';

class LinkInBioBuilder extends StatefulWidget {
  const LinkInBioBuilder({Key? key}) : super(key: key);

  @override
  State<LinkInBioBuilder> createState() => _LinkInBioBuilderState();
}

class _LinkInBioBuilderState extends State<LinkInBioBuilder> 
    with TickerProviderStateMixin {
  late TabController _tabController;
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;

  String _selectedTemplate = 'modern';
  String _profileTitle = 'Your Name';
  String _profileDescription = 'Your bio description';
  String _profileImageUrl = 'https://images.unsplash.com/photo-1472099645785-5658abf4ff4e?w=400&h=400&fit=crop&crop=face';
  String _backgroundColor = '#1a1a1a';
  String _accentColor = '#00d4ff';
  String _textColor = '#ffffff';
  bool _isPreviewMode = false;
  bool _hasUnsavedChanges = false;

  final List<Map<String, dynamic>> _linkComponents = [
{ 'id': '1',
'type': 'link',
'title': 'Website',
'url': 'https://example.com',
'icon': 'link',
'isActive': true,
},
{ 'id': '2',
'type': 'link',
'title': 'Instagram',
'url': 'https://instagram.com/username',
'icon': 'camera_alt',
'isActive': true,
},
{ 'id': '3',
'type': 'link',
'title': 'YouTube',
'url': 'https://youtube.com/channel',
'icon': 'play_circle_filled',
'isActive': true,
},
];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _setupAnimations();
  }

  void _setupAnimations() {
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this);

    _scaleAnimation = Tween<double>(
      begin: 0.95,
      end: 1.0).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOutBack));

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOut));

    _animationController.forward();
  }

  @override
  void dispose() {
    _tabController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  void _togglePreview() {
    setState(() {
      _isPreviewMode = !_isPreviewMode;
    });
  }

  void _saveChanges() {
    ButtonService.handleButtonPress('saveChanges', () {
      setState(() {
        _hasUnsavedChanges = false;
      });
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              const Icon(Icons.check_circle, color: Colors.white),
              const SizedBox(width: 8),
              const Text('Changes saved successfully'),
            ]),
          backgroundColor: AppTheme.success,
          behavior: SnackBarBehavior.floating));
    });
  }

  void _publishPage() {
    ButtonService.handleButtonPress('publishPage', () {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          backgroundColor: AppTheme.surface,
          title: Text(
            'Publish Link in Bio',
            style: GoogleFonts.inter(
              color: AppTheme.primaryText,
              fontWeight: FontWeight.w600)),
          content: const Text(
            'Your Link in Bio page is ready to be published. Are you sure you want to continue?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel')),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                _showPublishSuccess();
              },
              child: const Text('Publish')),
          ]));
    });
  }

  void _showPublishSuccess() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppTheme.surface,
        title: Text(
          'Successfully Published!',
          style: GoogleFonts.inter(
            color: AppTheme.success,
            fontWeight: FontWeight.w600)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Your Link in Bio page has been published successfully!'),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppTheme.primaryBackground,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: AppTheme.border)),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      'https://mewayz.link/username',
                      style: TextStyle(
                        color: AppTheme.accent,
                        fontWeight: FontWeight.w500))),
                  IconButton(
                    onPressed: () {
                      Clipboard.setData(const ClipboardData(text: 'https://mewayz.link/username'));
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Link copied to clipboard')));
                    },
                    icon: const Icon(Icons.copy)),
                ])),
          ]),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close')),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _showQRCodeModal();
            },
            child: const Text('Generate QR Code')),
        ]));
  }

  void _showQRCodeModal() {
    showDialog(
      context: context,
      builder: (context) => QRCodeModal(
        url: 'https://mewayz.link/username',
        title: _profileTitle));
  }

  void _showTemplateSelector() {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppTheme.surface,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (context) => TemplateSelectionModal(
        templates: const [],
        onTemplateSelected: (template) {
          setState(() {
            _selectedTemplate = template as String;
            _hasUnsavedChanges = true;
          });
        }));
  }

  void _showCustomDomainModal() {
    showDialog(
      context: context,
      builder: (context) => CustomDomainModal(
        currentDomain: '',
        onDomainUpdate: (domain) {},
      ));
  }

  void _addComponent() {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppTheme.surface,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (context) => ComponentEditorBottomSheet(
        component: {},
        onUpdate: (component) {},
      ));
  }

  void _editComponent(Map<String, dynamic> component) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppTheme.surface,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (context) => ComponentEditorBottomSheet(
        component: component,
        onUpdate: (updatedComponent) {},
      ));
  }

  void _deleteComponent(String componentId) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppTheme.surface,
        title: const Text('Delete Component'),
        content: const Text('Are you sure you want to delete this component?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              setState(() {
                _linkComponents.removeWhere((c) => c['id'] == componentId);
                _hasUnsavedChanges = true;
              });
            },
            style: ElevatedButton.styleFrom(backgroundColor: AppTheme.error),
            child: const Text('Delete')),
        ]));
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (_hasUnsavedChanges) {
          final shouldLeave = await showDialog<bool>(
            context: context,
            builder: (context) => AlertDialog(
              backgroundColor: AppTheme.surface,
              title: const Text('Unsaved Changes'),
              content: const Text('You have unsaved changes. Are you sure you want to leave?'),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context, false),
                  child: const Text('Cancel')),
                ElevatedButton(
                  onPressed: () => Navigator.pop(context, true),
                  style: ElevatedButton.styleFrom(backgroundColor: AppTheme.error),
                  child: const Text('Leave')),
              ]));
          return shouldLeave ?? false;
        }
        return true;
      },
      child: Scaffold(
        backgroundColor: AppTheme.primaryBackground,
        appBar: AppBar(
          backgroundColor: AppTheme.primaryBackground,
          elevation: 0,
          leading: IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.arrow_back_ios, color: AppTheme.primaryText)),
          title: Text(
            'Link in Bio Builder',
            style: GoogleFonts.inter(
              color: AppTheme.primaryText,
              fontWeight: FontWeight.w600)),
          actions: [
            if (_hasUnsavedChanges)
              IconButton(
                onPressed: _saveChanges,
                icon: const Icon(Icons.save, color: AppTheme.accent)),
            IconButton(
              onPressed: _togglePreview,
              icon: Icon(
                _isPreviewMode ? Icons.edit : Icons.visibility,
                color: AppTheme.accent)),
            IconButton(
              onPressed: _publishPage,
              icon: const Icon(Icons.publish, color: AppTheme.success)),
          ]),
        body: AnimatedBuilder(
          animation: _animationController,
          builder: (context, child) {
            return FadeTransition(
              opacity: _fadeAnimation,
              child: ScaleTransition(
                scale: _scaleAnimation,
                child: _isPreviewMode ? _buildPreviewMode() : _buildEditMode()));
          }),
        floatingActionButton: !_isPreviewMode
            ? FloatingActionButton(
                onPressed: _addComponent,
                backgroundColor: AppTheme.accent,
                child: const Icon(Icons.add, color: AppTheme.primaryBackground))
            : null));
  }

  Widget _buildEditMode() {
    return Column(
      children: [
        // Tab Bar
        Container(
          decoration: BoxDecoration(
            color: AppTheme.surface,
            border: Border(
              bottom: BorderSide(color: AppTheme.border, width: 1))),
          child: TabBar(
            controller: _tabController,
            labelColor: AppTheme.primaryText,
            unselectedLabelColor: AppTheme.secondaryText,
            indicatorColor: AppTheme.accent,
            tabs: const [
              Tab(text: 'Design'),
              Tab(text: 'Content'),
              Tab(text: 'Settings'),
            ])),
        
        // Tab Content
        Expanded(
          child: TabBarView(
            controller: _tabController,
            children: [
              _buildDesignTab(),
              _buildContentTab(),
              _buildSettingsTab(),
            ])),
      ]);
  }

  Widget _buildPreviewMode() {
    return Center(
      child: Container(
        width: 300,
        height: 600,
        decoration: BoxDecoration(
          color: AppTheme.surface,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: AppTheme.border),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha(26),
              blurRadius: 20,
              offset: const Offset(0, 10)),
          ]),
        child: MobilePreviewWidget(
          components: _linkComponents,
          pageSettings: {'title': _profileTitle, 'description': _profileDescription},
          selectedComponentId: '',
          onComponentTap: (id) {},
          onComponentLongPress: (id) {},
        )));
  }

  Widget _buildDesignTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Template Selection
          _buildSectionHeader('Template', Icons.palette),
          const SizedBox(height: 12),
          GestureDetector(
            onTap: _showTemplateSelector,
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppTheme.surface,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppTheme.border)),
              child: Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: AppTheme.accent,
                      borderRadius: BorderRadius.circular(8)),
                    child: const Icon(Icons.brush, color: AppTheme.primaryBackground)),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Current Template',
                          style: TextStyle(
                            color: AppTheme.secondaryText,
                            fontSize: 12)),
                        Text(
                          _selectedTemplate.toUpperCase(),
                          style: TextStyle(
                            color: AppTheme.primaryText,
                            fontWeight: FontWeight.w600)),
                      ])),
                  const Icon(Icons.arrow_forward_ios, color: AppTheme.secondaryText),
                ]))),
          
          const SizedBox(height: 24),
          
          // Color Customization
          _buildSectionHeader('Colors', Icons.color_lens),
          const SizedBox(height: 12),
          _buildColorPicker('Background', _backgroundColor, (color) {
            setState(() {
              _backgroundColor = color;
              _hasUnsavedChanges = true;
            });
          }),
          const SizedBox(height: 12),
          _buildColorPicker('Accent', _accentColor, (color) {
            setState(() {
              _accentColor = color;
              _hasUnsavedChanges = true;
            });
          }),
          const SizedBox(height: 12),
          _buildColorPicker('Text', _textColor, (color) {
            setState(() {
              _textColor = color;
              _hasUnsavedChanges = true;
            });
          }),
        ]));
  }

  Widget _buildContentTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Profile Information
          _buildSectionHeader('Profile', Icons.person),
          const SizedBox(height: 12),
          TextFormField(
            initialValue: _profileTitle,
            onChanged: (value) {
              setState(() {
                _profileTitle = value;
                _hasUnsavedChanges = true;
              });
            },
            decoration: InputDecoration(
              labelText: 'Profile Title',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8)),
              filled: true,
              fillColor: AppTheme.surface)),
          const SizedBox(height: 12),
          TextFormField(
            initialValue: _profileDescription,
            onChanged: (value) {
              setState(() {
                _profileDescription = value;
                _hasUnsavedChanges = true;
              });
            },
            maxLines: 3,
            decoration: InputDecoration(
              labelText: 'Profile Description',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8)),
              filled: true,
              fillColor: AppTheme.surface)),
          
          const SizedBox(height: 24),
          
          // Link Components
          _buildSectionHeader('Links', Icons.link),
          const SizedBox(height: 12),
          if (_linkComponents.isEmpty)
            _buildEmptyState()
          else
            ..._linkComponents.asMap().entries.map((entry) {
              final index = entry.key;
              final component = entry.value;
              return _buildLinkComponentTile(component, index);
            }).toList(),
        ]));
  }

  Widget _buildSettingsTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Domain Settings
          _buildSectionHeader('Domain', Icons.language),
          const SizedBox(height: 12),
          GestureDetector(
            onTap: _showCustomDomainModal,
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppTheme.surface,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppTheme.border)),
              child: Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: AppTheme.accent.withAlpha(26),
                      borderRadius: BorderRadius.circular(8)),
                    child: Icon(Icons.language, color: AppTheme.accent)),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Custom Domain',
                          style: TextStyle(
                            color: AppTheme.primaryText,
                            fontWeight: FontWeight.w600)),
                        Text(
                          'Set up your custom domain',
                          style: TextStyle(
                            color: AppTheme.secondaryText,
                            fontSize: 12)),
                      ])),
                  const Icon(Icons.arrow_forward_ios, color: AppTheme.secondaryText),
                ]))),
          
          const SizedBox(height: 24),
          
          // Analytics
          _buildSectionHeader('Analytics', Icons.analytics),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppTheme.surface,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppTheme.border)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: AppTheme.success.withAlpha(26),
                        borderRadius: BorderRadius.circular(8)),
                      child: Icon(Icons.analytics, color: AppTheme.success)),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Page Analytics',
                            style: TextStyle(
                              color: AppTheme.primaryText,
                              fontWeight: FontWeight.w600)),
                          Text(
                            'Track your page performance',
                            style: TextStyle(
                              color: AppTheme.secondaryText,
                              fontSize: 12)),
                        ])),
                  ]),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: _buildAnalyticsCard('Page Views', '1,234', Icons.visibility)),
                    const SizedBox(width: 8),
                    Expanded(
                      child: _buildAnalyticsCard('Link Clicks', '567', Icons.mouse)),
                  ]),
              ])),
        ]));
  }

  Widget _buildSectionHeader(String title, IconData icon) {
    return Row(
      children: [
        Icon(icon, color: AppTheme.accent, size: 20),
        const SizedBox(width: 8),
        Text(
          title,
          style: TextStyle(
            color: AppTheme.primaryText,
            fontSize: 18,
            fontWeight: FontWeight.w600)),
      ]);
  }

  Widget _buildColorPicker(String label, String currentColor, Function(String) onChanged) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppTheme.border)),
      child: Row(
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: Color(int.parse(currentColor.substring(1), radix: 16) + 0xFF000000),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: AppTheme.border))),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              label,
              style: TextStyle(
                color: AppTheme.primaryText,
                fontWeight: FontWeight.w500))),
          Text(
            currentColor.toUpperCase(),
            style: TextStyle(
              color: AppTheme.secondaryText,
              fontFamily: 'monospace')),
        ]));
  }

  Widget _buildEmptyState() {
    return Container(
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppTheme.border)),
      child: Column(
        children: [
          Icon(
            Icons.link_off,
            size: 48,
            color: AppTheme.secondaryText),
          const SizedBox(height: 16),
          Text(
            'No links added yet',
            style: TextStyle(
              color: AppTheme.primaryText,
              fontSize: 18,
              fontWeight: FontWeight.w600)),
          const SizedBox(height: 8),
          Text(
            'Tap the + button to add your first link',
            style: TextStyle(
              color: AppTheme.secondaryText,
              fontSize: 14)),
        ]));
  }

  Widget _buildLinkComponentTile(Map<String, dynamic> component, int index) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppTheme.border)),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: AppTheme.accent.withAlpha(26),
          child: Icon(
            _getIconData(component['icon']),
            color: AppTheme.accent,
            size: 20)),
        title: Text(
          component['title'],
          style: TextStyle(
            color: AppTheme.primaryText,
            fontWeight: FontWeight.w600)),
        subtitle: Text(
          component['url'],
          style: TextStyle(
            color: AppTheme.secondaryText,
            fontSize: 12),
          overflow: TextOverflow.ellipsis),
        trailing: PopupMenuButton(
          itemBuilder: (context) => [
            PopupMenuItem(
              value: 'edit',
              child: Row(
                children: [
                  const Icon(Icons.edit, size: 16),
                  const SizedBox(width: 8),
                  const Text('Edit'),
                ])),
            PopupMenuItem(
              value: 'delete',
              child: Row(
                children: [
                  const Icon(Icons.delete, size: 16, color: Colors.red),
                  const SizedBox(width: 8),
                  const Text('Delete', style: TextStyle(color: Colors.red)),
                ])),
          ],
          onSelected: (value) {
            if (value == 'edit') {
              _editComponent(component);
            } else if (value == 'delete') {
              _deleteComponent(component['id']);
            }
          })));
  }

  Widget _buildAnalyticsCard(String title, String value, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppTheme.primaryBackground,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppTheme.border)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: AppTheme.accent, size: 16),
          const SizedBox(height: 4),
          Text(
            value,
            style: TextStyle(
              color: AppTheme.primaryText,
              fontSize: 18,
              fontWeight: FontWeight.w600)),
          Text(
            title,
            style: TextStyle(
              color: AppTheme.secondaryText,
              fontSize: 12)),
        ]));
  }

  IconData _getIconData(String iconName) {
    switch (iconName) {
      case 'link':
        return Icons.link;
      case 'camera_alt':
        return Icons.camera_alt;
      case 'play_circle_filled':
        return Icons.play_circle_filled;
      case 'email':
        return Icons.email;
      case 'phone':
        return Icons.phone;
      case 'shopping_cart':
        return Icons.shopping_cart;
      default:
        return Icons.link;
    }
  }
}