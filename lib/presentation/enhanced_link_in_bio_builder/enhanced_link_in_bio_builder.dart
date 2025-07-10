import '../../core/app_export.dart';
import '../../services/link_in_bio_service.dart';

class EnhancedLinkInBioBuilder extends StatefulWidget {
  const EnhancedLinkInBioBuilder({Key? key}) : super(key: key);

  @override
  State<EnhancedLinkInBioBuilder> createState() => _EnhancedLinkInBioBuilderState();
}

class _EnhancedLinkInBioBuilderState extends State<EnhancedLinkInBioBuilder> with TickerProviderStateMixin {
  late TabController _tabController;
  final LinkInBioService _linkService = LinkInBioService();
  
  Map<String, dynamic>? _currentPage;
  List<Map<String, dynamic>> _components = [];
  Map<String, dynamic>? _selectedComponent;
  bool _isPreviewMode = false;
  bool _isLoading = false;
  bool _isSaving = false;
  String? _pageId;
  String _selectedDevice = 'mobile';
  bool _showSnapGuides = true;
  bool _showAnalytics = false;
  bool _showTemplateGallery = false;
  bool _showDomainSettings = false;
  bool _showExportOptions = false;
  Map<String, dynamic> _abTestingVariants = {};
  Map<String, dynamic> _performanceMetrics = {};
  Map<String, dynamic> _customCSS = {};

  final Map<String, dynamic> _defaultThemeSettings = {
    'theme': 'modern',
    'background_color': '#101010',
    'text_color': '#F5F5F5',
    'accent_color': '#3B82F6',
    'font_family': 'Inter',
    'border_radius': 12,
    'button_style': 'solid',
    'animations_enabled': true,
    'hover_effects': true,
    'mobile_optimized': true,
    'accessibility_features': true,
  };

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 6, vsync: this);
    _initializePage();
    _loadPerformanceMetrics();
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
        title: 'New Enhanced Link Page',
        slug: 'enhanced-page-$timestamp',
        description: 'Professional link-in-bio page with advanced features',
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

  Future<void> _loadPerformanceMetrics() async {
    try {
      final metrics = await _linkService.getPageAnalytics(_pageId ?? '');
      setState(() {
        _performanceMetrics = metrics;
      });
    } catch (error) {
      // Handle error silently for now
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
      case 'advanced_text_block':
        return {
          'text': 'Add your rich text here',
          'font_size': 16,
          'alignment': 'center',
          'formatting': {'bold': false, 'italic': false, 'underline': false},
          'animations': {'type': 'fadeIn', 'duration': 500},
          'responsive_settings': {
            'mobile': {'font_size': 16},
            'tablet': {'font_size': 18},
            'desktop': {'font_size': 20},
          },
        };
      case 'interactive_button':
        return {
          'title': 'New Interactive Button',
          'url': 'https://example.com',
          'description': 'Click to visit',
          'hover_effects': true,
          'animation_type': 'pulse',
          'tracking_enabled': true,
        };
      case 'media_gallery':
        return {
          'images': [
            {'url': 'https://images.unsplash.com/photo-1557683304-673a23048d34?w=400', 'alt': 'Gallery image 1'},
            {'url': 'https://images.unsplash.com/photo-1557683311-eac922347aa1?w=400', 'alt': 'Gallery image 2'},
          ],
          'lightbox_enabled': true,
          'auto_play': false,
          'transition_effect': 'slide',
        };
      case 'product_showcase':
        return {
          'products': [
            {
              'name': 'Sample Product',
              'price': '\$29.99',
              'image': 'https://images.unsplash.com/photo-1560472354-b33ff0c44a43?w=400',
              'checkout_url': 'https://checkout.example.com',
            },
          ],
          'checkout_integration': true,
          'payment_methods': ['stripe', 'paypal'],
        };
      case 'contact_form':
        return {
          'fields': [
            {'name': 'name', 'type': 'text', 'required': true, 'label': 'Name'},
            {'name': 'email', 'type': 'email', 'required': true, 'label': 'Email'},
            {'name': 'message', 'type': 'textarea', 'required': true, 'label': 'Message'},
          ],
          'crm_sync': true,
          'auto_response': true,
        };
      case 'social_media_feed':
        return {
          'platforms': ['instagram', 'twitter'],
          'feed_type': 'grid',
          'post_count': 6,
          'auto_refresh': true,
        };
      case 'countdown_timer':
        return {
          'end_date': DateTime.now().add(Duration(days: 30)).toIso8601String(),
          'title': 'Special Offer Ends In',
          'style': 'modern',
          'show_seconds': true,
        };
      case 'testimonial_carousel':
        return {
          'testimonials': [
            {
              'name': 'John Doe',
              'text': 'Amazing service!',
              'rating': 5,
              'image': 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=100',
            },
          ],
          'auto_play': true,
          'show_ratings': true,
        };
      default:
        return {};
    }
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: AppTheme.error,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _showSuccessSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: AppTheme.success,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        backgroundColor: Color(0xFF101010),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(color: AppTheme.accent),
              SizedBox(height: 16),
              Text(
                'Loading Enhanced Builder...',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppTheme.primaryText,
                ),
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: Color(0xFF101010),
      body: SafeArea(
        child: Column(
          children: [
            // Enhanced Header
            Container(
              padding: EdgeInsets.all(16),
              child: Text('Header Placeholder'),
            ),
            
            // Main content
            Expanded(
              child: _isPreviewMode
                  ? Container(
                      child: Text('Mobile Preview Placeholder'),
                    )
                  : Row(
                      children: [
                        // Left sidebar - Enhanced component palette
                        Container(
                          width: 320,
                          decoration: BoxDecoration(
                            color: Color(0xFF191919),
                            border: Border(
                              right: BorderSide(
                                color: AppTheme.border,
                                width: 1,
                              ),
                            ),
                          ),
                          child: Column(
                            children: [
                              // Enhanced Tab bar
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
                                  isScrollable: true,
                                  tabs: const [
                                    Tab(text: 'Components'),
                                    Tab(text: 'Properties'),
                                    Tab(text: 'Templates'),
                                    Tab(text: 'Domain'),
                                    Tab(text: 'Analytics'),
                                    Tab(text: 'Export'),
                                  ],
                                ),
                              ),
                              
                              // Enhanced Tab content
                              Expanded(
                                child: TabBarView(
                                  controller: _tabController,
                                  children: [
                                    Container(child: Text('Component Palette Placeholder')),
                                    Container(child: Text('Property Panel Placeholder')),
                                    Container(child: Text('Template Gallery Placeholder')),
                                    Container(child: Text('Domain Management Placeholder')),
                                    Container(child: Text('Analytics Integration Placeholder')),
                                    Container(child: Text('Export Functionality Placeholder')),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        
                        // Main canvas area with enhanced drag-drop
                        Expanded(
                          child: Container(
                            child: Text('Drag and Drop Area Placeholder'),
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