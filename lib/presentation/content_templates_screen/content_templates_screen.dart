import '../../core/app_export.dart';
import './widgets/favorites_templates_widget.dart';
import './widgets/template_analytics_widget.dart';
import './widgets/template_card_widget.dart';
import './widgets/template_creator_widget.dart';
import './widgets/template_filter_widget.dart';
import './widgets/template_preview_modal_widget.dart';

class ContentTemplatesScreen extends StatefulWidget {
  const ContentTemplatesScreen({Key? key}) : super(key: key);

  @override
  State<ContentTemplatesScreen> createState() => _ContentTemplatesScreenState();
}

class _ContentTemplatesScreenState extends State<ContentTemplatesScreen> {
  String _selectedCategory = 'All';
  String _selectedPlatform = 'All';
  String _selectedIndustry = 'All';
  String _searchQuery = '';
  bool _isLoading = false;
  List<Map<String, dynamic>> _templates = [];
  List<Map<String, dynamic>> _favoriteTemplates = [];

  // Add data service
  final DataService _dataService = DataService();

  @override
  void initState() {
    super.initState();
    _loadTemplates();
  }

  void _loadTemplates() async {
    setState(() {
      _isLoading = true;
    });

    try {
      await _dataService.initialize();
      final templates = await _dataService.getTemplates(_selectedCategory);
      
      setState(() {
        _templates = templates;
        _favoriteTemplates = _templates
            .where((template) => template['is_favorite'] == true)
            .toList();
      });
    } catch (e) {
      ErrorHandler.handleError('Failed to load templates: $e');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _onSearchChanged(String query) {
    setState(() {
      _searchQuery = query;
    });
  }

  void _onCategoryChanged(String category) {
    setState(() {
      _selectedCategory = category;
    });
    _loadTemplates(); // Reload templates for new category
  }

  void _onPlatformChanged(String platform) {
    setState(() {
      _selectedPlatform = platform;
    });
  }

  void _onIndustryChanged(String industry) {
    setState(() {
      _selectedIndustry = industry;
    });
  }

  void _toggleFavorite(String templateId) async {
    setState(() {
      final templateIndex =
          _templates.indexWhere((template) => template['id'] == templateId);
      if (templateIndex != -1) {
        _templates[templateIndex]['is_favorite'] =
            !_templates[templateIndex]['is_favorite'];
        _favoriteTemplates = _templates
            .where((template) => template['is_favorite'] == true)
            .toList();
      }
    });

    // Update in Supabase (would need to add this method to the service)
    try {
      await _dataService.trackEvent('template_favorite_toggled', {
        'template_id': templateId,
        'is_favorite': _templates.firstWhere((t) => t['id'] == templateId)['is_favorite'],
      });
    } catch (e) {
      ErrorHandler.handleError('Failed to update favorite status: $e');
    }
  }

  void _showTemplatePreview(Map<String, dynamic> template) {
    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        builder: (context) => TemplatePreviewModalWidget(
            template: template,
            onUse: () async {
              Navigator.pop(context);
              // Track template usage
              await _dataService.trackEvent('template_used', {
                'template_id': template['id'],
                'template_type': template['template_type'],
              });
            },
            onFavorite: () {
              _toggleFavorite(template['id']);
            }));
  }

  List<Map<String, dynamic>> get filteredTemplates {
    return _templates.where((template) {
      final matchesSearch = _searchQuery.isEmpty ||
          template['title']
              .toLowerCase()
              .contains(_searchQuery.toLowerCase()) ||
          template['description']
              .toLowerCase()
              .contains(_searchQuery.toLowerCase());

      final matchesCategory = _selectedCategory == 'All' ||
          template['category'] == _selectedCategory;
      final matchesPlatform = _selectedPlatform == 'All' ||
          (template['platform'] as List?)?.contains(_selectedPlatform) == true;
      final matchesIndustry = _selectedIndustry == 'All' ||
          template['industry'] == _selectedIndustry;

      return matchesSearch &&
          matchesCategory &&
          matchesPlatform &&
          matchesIndustry;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color(0xFF101010),
        appBar: AppBar(
            backgroundColor: const Color(0xFF101010),
            leading: IconButton(
              onPressed: () => Navigator.pop(context),
              icon: const Icon(Icons.arrow_back),
            ),
            title: Text('Content Templates',
                style: GoogleFonts.inter(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFFF1F1F1))),
            actions: [
              IconButton(
                  icon: const Icon(Icons.search),
                  onPressed: () {
                    // Show search
                  }),
              IconButton(
                  icon: const Icon(Icons.more_vert),
                  onPressed: () {
                    // More options
                  }),
            ]),
        body: SafeArea(
            child: Column(children: [
          // Search Bar
          Container(
              padding: const EdgeInsets.all(16),
              child: TextField(
                  onChanged: _onSearchChanged,
                  style: GoogleFonts.inter(
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                      color: const Color(0xFFF1F1F1)),
                  decoration: InputDecoration(
                      hintText: 'Search templates...',
                      hintStyle: GoogleFonts.inter(
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                          color: const Color(0xFF7B7B7B)),
                      prefixIcon: const Padding(
                          padding: EdgeInsets.all(12),
                          child: CustomIconWidget(
                              iconName: 'search',
                              color: Color(0xFF7B7B7B),
                              size: 20)),
                      filled: true,
                      fillColor: const Color(0xFF191919),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(
                              color: Color(0xFF282828), width: 1)),
                      enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(
                              color: Color(0xFF282828), width: 1)),
                      focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(
                              color: Color(0xFF3B82F6), width: 2))))),

          // Filters
          TemplateFilterWidget(
              selectedCategory: _selectedCategory,
              selectedPlatform: _selectedPlatform,
              selectedIndustry: _selectedIndustry,
              onCategoryChanged: _onCategoryChanged,
              onPlatformChanged: _onPlatformChanged,
              onIndustryChanged: _onIndustryChanged),

          // Main Content
          Expanded(
              child: _isLoading
                  ? const Center(
                      child:
                          CircularProgressIndicator(color: Color(0xFF3B82F6)))
                  : DefaultTabController(
                      length: 4,
                      child: Column(children: [
                        Container(
                            color: const Color(0xFF101010),
                            child: TabBar(
                                indicatorColor: const Color(0xFF3B82F6),
                                labelColor: const Color(0xFFF1F1F1),
                                unselectedLabelColor: const Color(0xFF7B7B7B),
                                labelStyle: GoogleFonts.inter(
                                    fontSize: 14, fontWeight: FontWeight.w500),
                                tabs: const [
                                  Tab(text: 'All'),
                                  Tab(text: 'Favorites'),
                                  Tab(text: 'Analytics'),
                                  Tab(text: 'Creator'),
                                ])),
                        Expanded(
                            child: TabBarView(children: [
                          // All Templates
                          _buildTemplateGrid(filteredTemplates),

                          // Favorites
                          FavoritesTemplatesWidget(
                              favoriteTemplates: _favoriteTemplates,
                              onTemplatePressed: _showTemplatePreview,
                              onToggleFavorite: _toggleFavorite),

                          // Analytics
                          TemplateAnalyticsWidget(templates: _templates),

                          // Template Creator
                          TemplateCreatorWidget(onCreateTemplate: (template) async {
                            // Handle template creation
                            try {
                              await _dataService.saveTemplate(template);
                              _loadTemplates(); // Refresh templates
                              if (mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text('Template created successfully')),
                                );
                              }
                            } catch (e) {
                              ErrorHandler.handleError('Failed to create template: $e');
                            }
                          }),
                        ])),
                      ]))),
        ])),
        floatingActionButton: FloatingActionButton(
            onPressed: () async {
              // Quick template creation
              await _dataService.trackEvent('template_create_button_pressed', {});
            },
            backgroundColor: const Color(0xFFFDFDFD),
            child: const CustomIconWidget(
                iconName: 'add', color: Color(0xFF141414))));
  }

  Widget _buildTemplateGrid(List<Map<String, dynamic>> templates) {
    if (templates.isEmpty) {
      return Center(
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        const CustomIconWidget(
            iconName: 'empty', color: Color(0xFF7B7B7B), size: 48),
        const SizedBox(height: 16),
        Text('No templates found',
            style: GoogleFonts.inter(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: const Color(0xFFF1F1F1))),
        const SizedBox(height: 8),
        Text('Try adjusting your filters or search query',
            style: GoogleFonts.inter(
                fontSize: 14,
                fontWeight: FontWeight.w400,
                color: const Color(0xFF7B7B7B))),
        const SizedBox(height: 16),
        ElevatedButton(
          onPressed: () {
            _loadTemplates();
          },
          child: const Text('Refresh Templates'),
        ),
      ]));
    }

    return GridView.builder(
        padding: const EdgeInsets.all(16),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 0.8),
        itemCount: templates.length,
        itemBuilder: (context, index) {
          final template = templates[index];
          return TemplateCardWidget(
              template: template,
              onPressed: () => _showTemplatePreview(template),
              onFavorite: () => _toggleFavorite(template['id']));
        });
  }
}