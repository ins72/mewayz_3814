import '../../core/app_export.dart';
import '../../services/link_in_bio_service.dart';
import './widgets/builder_header_widget.dart';
import './widgets/component_palette_widget.dart';
import './widgets/domain_management_widget.dart';
import './widgets/visual_builder_canvas_widget.dart';

class LinkInBioVisualBuilder extends StatefulWidget {
  const LinkInBioVisualBuilder({Key? key}) : super(key: key);

  @override
  State<LinkInBioVisualBuilder> createState() => _LinkInBioVisualBuilderState();
}

class _LinkInBioVisualBuilderState extends State<LinkInBioVisualBuilder> with TickerProviderStateMixin {
  late TabController _tabController;
  final LinkInBioService _linkService = LinkInBioService();
  
  Map<String, dynamic>? _currentPage;
  List<Map<String, dynamic>> _components = [];
  Map<String, dynamic>? _selectedComponent;
  bool _isPreviewMode = false;
  bool _isLoading = false;
  bool _isSaving = false;
  String? _pageId;

  final Map<String, dynamic> _defaultThemeSettings = {
    'theme': 'modern',
    'background_color': '#ffffff',
    'text_color': '#333333',
    'accent_color': '#007bff',
    'font_family': 'Inter',
    'border_radius': 8,
    'button_style': 'solid',
  };

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    _initializePage();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _initializePage() {
    final arguments = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
    _pageId = arguments?['pageId'] as String?;
    
    if (_pageId != null) {
      _loadExistingPage();
    } else {
      _createNewPage();
    }
  }

  Future<void> _loadExistingPage() async {
    setState(() => _isLoading = true);
    
    try {
      final userId = 'current-user-id'; // Get from auth service
      final pages = await _linkService.getUserLinkPages(userId);
      final page = pages.firstWhere((p) => p['id'] == _pageId);
      final components = await _linkService.getPageComponents(_pageId!);
      
      setState(() {
        _currentPage = page;
        _components = components;
        _isLoading = false;
      });
    } catch (error) {
      setState(() => _isLoading = false);
      _showErrorSnackBar('Failed to load page: $error');
    }
  }

  Future<void> _createNewPage() async {
    setState(() => _isLoading = true);
    
    try {
      final userId = 'current-user-id'; // Get from auth service
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final newPage = await _linkService.createLinkPage(
        userId: userId,
        title: 'New Link Page',
        slug: 'page-$timestamp',
        description: 'My awesome link page',
        themeSettings: _defaultThemeSettings,
      );
      
      setState(() {
        _currentPage = newPage;
        _pageId = newPage['id'];
        _components = [];
        _isLoading = false;
      });
    } catch (error) {
      setState(() => _isLoading = false);
      _showErrorSnackBar('Failed to create page: $error');
    }
  }

  Future<void> _savePage() async {
    if (_currentPage == null) return;
    
    setState(() => _isSaving = true);
    
    try {
      await _linkService.updateLinkPage(
        pageId: _pageId!,
        title: _currentPage!['title'],
        description: _currentPage!['description'],
        slug: _currentPage!['slug'],
        themeSettings: _currentPage!['theme_settings'],
        seoSettings: _currentPage!['seo_settings'],
      );
      
      _showSuccessSnackBar('Page saved successfully!');
    } catch (error) {
      _showErrorSnackBar('Failed to save page: $error');
    } finally {
      setState(() => _isSaving = false);
    }
  }

  Future<void> _publishPage() async {
    if (_currentPage == null) return;
    
    setState(() => _isSaving = true);
    
    try {
      await _linkService.updateLinkPage(
        pageId: _pageId!,
        status: 'published',
      );
      
      setState(() {
        _currentPage!['status'] = 'published';
        _currentPage!['published_at'] = DateTime.now().toIso8601String();
      });
      
      _showSuccessSnackBar('Page published successfully!');
    } catch (error) {
      _showErrorSnackBar('Failed to publish page: $error');
    } finally {
      setState(() => _isSaving = false);
    }
  }

  void _addComponent(String componentType) async {
    if (_pageId == null) return;
    
    final defaultComponentData = _getDefaultComponentData(componentType);
    
    try {
      final component = await _linkService.createPageComponent(
        linkPageId: _pageId!,
        componentType: componentType,
        componentData: defaultComponentData,
        positionOrder: _components.length + 1,
      );
      
      setState(() {
        _components.add(component);
        _selectedComponent = component;
      });
    } catch (error) {
      _showErrorSnackBar('Failed to add component: $error');
    }
  }

  void _updateComponent(String componentId, Map<String, dynamic> data) async {
    try {
      await _linkService.updatePageComponent(
        componentId: componentId,
        componentData: data,
      );
      
      setState(() {
        final index = _components.indexWhere((c) => c['id'] == componentId);
        if (index != -1) {
          _components[index]['component_data'] = data;
        }
      });
    } catch (error) {
      _showErrorSnackBar('Failed to update component: $error');
    }
  }

  void _deleteComponent(String componentId) async {
    try {
      await _linkService.deletePageComponent(componentId);
      
      setState(() {
        _components.removeWhere((c) => c['id'] == componentId);
        if (_selectedComponent?['id'] == componentId) {
          _selectedComponent = null;
        }
      });
    } catch (error) {
      _showErrorSnackBar('Failed to delete component: $error');
    }
  }

  void _reorderComponents(int oldIndex, int newIndex) async {
    if (newIndex > oldIndex) newIndex--;
    
    setState(() {
      final component = _components.removeAt(oldIndex);
      _components.insert(newIndex, component);
    });
    
    try {
      await _linkService.reorderComponents(_pageId!, _components);
    } catch (error) {
      _showErrorSnackBar('Failed to reorder components: $error');
    }
  }

  Map<String, dynamic> _getDefaultComponentData(String componentType) {
    switch (componentType) {
      case 'link_button':
        return {
          'title': 'New Link',
          'url': 'https://example.com',
          'description': 'Click to visit',
        };
      case 'text_block':
        return {
          'text': 'Add your text here',
          'font_size': 16,
          'alignment': 'center',
        };
      case 'image':
        return {
          'url': 'https://via.placeholder.com/400x200',
          'alt_text': 'Image description',
          'link_url': '',
        };
      case 'social_links':
        return {
          'links': [
            {'platform': 'instagram', 'url': '', 'username': ''},
            {'platform': 'twitter', 'url': '', 'username': ''},
          ],
        };
      case 'divider':
        return {
          'style': 'solid',
          'color': '#e0e0e0',
          'thickness': 1,
        };
      case 'spacer':
        return {
          'height': 20,
        };
      default:
        return {};
    }
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
      ),
    );
  }

  void _showSuccessSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.green,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        backgroundColor: AppTheme.primaryBackground,
        body: const Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return Scaffold(
      backgroundColor: AppTheme.primaryBackground,
      body: SafeArea(
        child: Column(
          children: [
            // Header
            BuilderHeaderWidget(
              currentPage: _currentPage,
              isPreviewMode: _isPreviewMode,
              isSaving: _isSaving,
              onPreviewToggle: () => setState(() => _isPreviewMode = !_isPreviewMode),
              onSave: _savePage,
              onPublish: _publishPage,
              onBack: () => Navigator.pop(context),
            ),
            
            // Main content
            Expanded(
              child: _isPreviewMode
                  ? Container(
                      child: Text("Preview Mode"),
                    )
                  : Row(
                      children: [
                        // Left sidebar - Component palette
                        Container(
                          width: 280,
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
                              // Tab bar
                              Container(
                                decoration: BoxDecoration(
                                  border: Border(
                                    bottom: BorderSide(
                                      color: AppTheme.border,
                                      width: 1,
                                    ),
                                  ),
                                ),
                                child: TabBar(
                                  controller: _tabController,
                                  indicatorColor: AppTheme.accent,
                                  labelColor: AppTheme.primaryText,
                                  unselectedLabelColor: AppTheme.secondaryText,
                                  indicatorSize: TabBarIndicatorSize.label,
                                  labelStyle: Theme.of(context).textTheme.labelSmall,
                                  tabs: const [
                                    Tab(text: 'Add'),
                                    Tab(text: 'Edit'),
                                    Tab(text: 'Page'),
                                    Tab(text: 'Domain'),
                                  ],
                                ),
                              ),
                              
                              // Tab content
                              Expanded(
                                child: TabBarView(
                                  controller: _tabController,
                                  children: [
                                    ComponentPaletteWidget(
                                      onComponentAdd: _addComponent,
                                    ),
                                    Container(
                                      child: Text("Property Editor"),
                                    ),
                                    Container(
                                      child: Text("Page Settings"),
                                    ),
                                    DomainManagementWidget(
                                      pageId: _pageId,
                                      currentPage: _currentPage,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        
                        // Main canvas area
                        Expanded(
                          child: VisualBuilderCanvasWidget(
                            currentPage: _currentPage,
                            components: _components,
                            selectedComponent: _selectedComponent,
                            onComponentSelect: (component) {
                              setState(() => _selectedComponent = component);
                            },
                            onComponentUpdate: _updateComponent,
                            onComponentDelete: _deleteComponent,
                            onComponentReorder: _reorderComponents,
                          ),
                        ),
                      ],
                    ),
            ),
          ],
        ),
      ),
    );
  }
}