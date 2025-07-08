import 'package:flutter/material.dart';

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

  @override
  void initState() {
    super.initState();
    _loadTemplates();
  }

  void _loadTemplates() {
    setState(() {
      _isLoading = true;
    });

    // Mock data for templates
    _templates = [
      {
        'id': '1',
        'title': 'Sale Announcement',
        'category': 'promotional',
        'platform': ['Instagram', 'Facebook'],
        'industry': 'E-commerce',
        'engagementScore': 4.5,
        'usageCount': 1250,
        'thumbnail':
            'https://images.unsplash.com/photo-1556742049-0cfed4f6a45d?w=400&h=400&fit=crop',
        'colors': ['#FF6B6B', '#4ECDC4', '#45B7D1'],
        'isFavorite': false,
        'description': 'Perfect for announcing sales and promotions',
        'tags': ['sale', 'promo', 'discount'],
      },
      {
        'id': '2',
        'title': 'Motivational Quote',
        'category': 'quotes',
        'platform': ['Instagram', 'LinkedIn'],
        'industry': 'Business',
        'engagementScore': 4.8,
        'usageCount': 2100,
        'thumbnail':
            'https://images.unsplash.com/photo-1484480974693-6ca0a78fb36b?w=400&h=400&fit=crop',
        'colors': ['#F39C12', '#E74C3C', '#9B59B6'],
        'isFavorite': true,
        'description': 'Inspirational quote template for business content',
        'tags': ['quote', 'motivation', 'business'],
      },
      {
        'id': '3',
        'title': 'Product Showcase',
        'category': 'promotional',
        'platform': ['Instagram', 'Facebook', 'Twitter'],
        'industry': 'E-commerce',
        'engagementScore': 4.2,
        'usageCount': 890,
        'thumbnail':
            'https://images.unsplash.com/photo-1441986300917-64674bd600d8?w=400&h=400&fit=crop',
        'colors': ['#2ECC71', '#3498DB', '#E67E22'],
        'isFavorite': false,
        'description': 'Showcase your products with style',
        'tags': ['product', 'showcase', 'ecommerce'],
      },
      {
        'id': '4',
        'title': 'Event Announcement',
        'category': 'announcements',
        'platform': ['Instagram', 'Facebook', 'LinkedIn'],
        'industry': 'Events',
        'engagementScore': 4.6,
        'usageCount': 1450,
        'thumbnail':
            'https://images.unsplash.com/photo-1492684223066-81342ee5ff30?w=400&h=400&fit=crop',
        'colors': ['#8E44AD', '#E74C3C', '#F39C12'],
        'isFavorite': false,
        'description': 'Perfect for event announcements and invitations',
        'tags': ['event', 'announcement', 'invitation'],
      },
      {
        'id': '5',
        'title': 'Instagram Story',
        'category': 'stories',
        'platform': ['Instagram'],
        'industry': 'General',
        'engagementScore': 4.3,
        'usageCount': 3200,
        'thumbnail':
            'https://images.unsplash.com/photo-1611224923853-80b023f02d71?w=400&h=400&fit=crop',
        'colors': ['#FF6B6B', '#4ECDC4', '#45B7D1'],
        'isFavorite': true,
        'description': 'Trendy Instagram story template',
        'tags': ['story', 'instagram', 'trendy'],
      },
      {
        'id': '6',
        'title': 'Holiday Season',
        'category': 'seasonal',
        'platform': ['Instagram', 'Facebook', 'Twitter'],
        'industry': 'Retail',
        'engagementScore': 4.7,
        'usageCount': 1800,
        'thumbnail':
            'https://images.unsplash.com/photo-1512389142860-9c449e58a543?w=400&h=400&fit=crop',
        'colors': ['#C0392B', '#27AE60', '#F39C12'],
        'isFavorite': false,
        'description': 'Holiday-themed template for seasonal campaigns',
        'tags': ['holiday', 'seasonal', 'celebration'],
      },
    ];

    _favoriteTemplates =
        _templates.where((template) => template['isFavorite'] == true).toList();

    Future.delayed(const Duration(milliseconds: 800), () {
      setState(() {
        _isLoading = false;
      });
    });
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

  void _toggleFavorite(String templateId) {
    setState(() {
      final templateIndex =
          _templates.indexWhere((template) => template['id'] == templateId);
      if (templateIndex != -1) {
        _templates[templateIndex]['isFavorite'] =
            !_templates[templateIndex]['isFavorite'];
        _favoriteTemplates = _templates
            .where((template) => template['isFavorite'] == true)
            .toList();
      }
    });
  }

  void _showTemplatePreview(Map<String, dynamic> template) {
    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        builder: (context) => TemplatePreviewModalWidget(
            template: template,
            onUse: () {
              Navigator.pop(context);
              // Handle template usage
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
          (template['platform'] as List).contains(_selectedPlatform);
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
                          TemplateCreatorWidget(onCreateTemplate: (template) {
                            // Handle template creation
                          }),
                        ])),
                      ]))),
        ])),
        floatingActionButton: FloatingActionButton(
            onPressed: () {
              // Quick template creation
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