import 'package:flutter/material.dart';

import '../../core/app_export.dart';
import './widgets/favorites_templates_widget.dart';
import './widgets/template_analytics_widget.dart';
import './widgets/template_categories_widget.dart';
import './widgets/template_filter_widget.dart';
import './widgets/template_gallery_widget.dart';
import './widgets/template_preview_modal_widget.dart';
import './widgets/template_quick_customize_widget.dart';
import './widgets/template_search_widget.dart';

class LinkInBioTemplatesScreen extends StatefulWidget {
  const LinkInBioTemplatesScreen({Key? key}) : super(key: key);

  @override
  State<LinkInBioTemplatesScreen> createState() => _LinkInBioTemplatesScreenState();
}

class _LinkInBioTemplatesScreenState extends State<LinkInBioTemplatesScreen> with TickerProviderStateMixin {
  late TabController _tabController;
  late ScrollController _scrollController;
  
  String _searchQuery = '';
  List<String> _selectedCategories = [];
  List<String> _selectedFilters = [];
  bool _showFavorites = false;
  String _selectedTemplate = '';
  
  final List<String> _categories = [
    'All',
    'Influencer',
    'Business',
    'Artist',
    'Fitness',
    'Restaurant',
    'E-commerce',
    'Creative',
    'Personal',
    'Event',
    'Music',
    'Photography',
    'Travel',
    'Food',
    'Tech',
    'Health',
  ];

  final List<String> _filterOptions = [
    'Free',
    'Premium',
    'Most Popular',
    'Recent',
    'Minimal',
    'Bold',
    'Creative',
    'Modern',
    'Professional',
    'Colorful',
    'Dark Theme',
    'Light Theme',
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _scrollController = ScrollController();
    _selectedCategories = ['All'];
  }

  @override
  void dispose() {
    _tabController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _showTemplatePreview(String templateId) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => TemplatePreviewModalWidget(
        templateId: templateId,
        onUseTemplate: (id) {
          Navigator.pop(context);
          _useTemplate(id);
        },
        onCustomize: (id) {
          Navigator.pop(context);
          _customizeTemplate(id);
        },
      ),
    );
  }

  void _useTemplate(String templateId) {
    // Navigate to bio builder with template
    Navigator.pushNamed(
      context,
      AppRoutes.linkInBioBuilder,
      arguments: {'templateId': templateId},
    );
  }

  void _customizeTemplate(String templateId) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => TemplateQuickCustomizeWidget(
        templateId: templateId,
        onApplyChanges: (id, customizations) {
          Navigator.pop(context);
          _applyCustomizations(id, customizations);
        },
      ),
    );
  }

  void _applyCustomizations(String templateId, Map<String, dynamic> customizations) {
    // Apply customizations and navigate to bio builder
    Navigator.pushNamed(
      context,
      AppRoutes.linkInBioBuilder,
      arguments: {
        'templateId': templateId,
        'customizations': customizations,
      },
    );
  }

  void _showTemplateAnalytics(String templateId) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => TemplateAnalyticsWidget(
        templateId: templateId,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.primaryBackground,
      body: SafeArea(
        child: Column(
          children: [
            // Header with back button and search
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppTheme.primaryBackground,
                border: Border(
                  bottom: BorderSide(
                    color: AppTheme.border,
                    width: 1,
                  ),
                ),
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: AppTheme.surface,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: const Icon(
                            Icons.arrow_back_ios,
                            color: AppTheme.primaryText,
                            size: 18,
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Text(
                        'Link in Bio Templates',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          color: AppTheme.primaryText,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const Spacer(),
                      GestureDetector(
                        onTap: () => setState(() => _showFavorites = !_showFavorites),
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: _showFavorites ? AppTheme.accent : AppTheme.surface,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Icon(
                            Icons.favorite,
                            color: _showFavorites ? AppTheme.primaryText : AppTheme.secondaryText,
                            size: 18,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  // Search bar
                  TemplateSearchWidget(
                    searchQuery: _searchQuery,
                    onSearchChanged: (query) {
                      setState(() => _searchQuery = query);
                    },
                  ),
                ],
              ),
            ),
            
            // Tab bar for browsing modes
            Container(
              color: AppTheme.primaryBackground,
              child: TabBar(
                controller: _tabController,
                indicatorColor: AppTheme.accent,
                labelColor: AppTheme.primaryText,
                unselectedLabelColor: AppTheme.secondaryText,
                indicatorSize: TabBarIndicatorSize.label,
                labelStyle: Theme.of(context).textTheme.labelLarge?.copyWith(
                  fontWeight: FontWeight.w500,
                ),
                tabs: const [
                  Tab(text: 'Browse'),
                  Tab(text: 'Categories'),
                  Tab(text: 'Favorites'),
                ],
              ),
            ),
            
            // Content area
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  // Browse tab
                  Column(
                    children: [
                      // Filters
                      TemplateFilterWidget(
                        selectedFilters: _selectedFilters,
                        filterOptions: _filterOptions,
                        onFiltersChanged: (filters) {
                          setState(() => _selectedFilters = filters);
                        },
                      ),
                      
                      // Template gallery
                      Expanded(
                        child: TemplateGalleryWidget(
                          searchQuery: _searchQuery,
                          selectedCategories: _selectedCategories,
                          selectedFilters: _selectedFilters,
                          onTemplatePreview: _showTemplatePreview,
                          onTemplateUse: _useTemplate,
                          onTemplateCustomize: _customizeTemplate,
                          onTemplateAnalytics: _showTemplateAnalytics,
                        ),
                      ),
                    ],
                  ),
                  
                  // Categories tab
                  TemplateCategoriesWidget(
                    categories: _categories,
                    selectedCategories: _selectedCategories,
                    onCategorySelected: (category) {
                      setState(() {
                        if (category == 'All') {
                          _selectedCategories = ['All'];
                        } else {
                          _selectedCategories.remove('All');
                          if (_selectedCategories.contains(category)) {
                            _selectedCategories.remove(category);
                          } else {
                            _selectedCategories.add(category);
                          }
                          if (_selectedCategories.isEmpty) {
                            _selectedCategories = ['All'];
                          }
                        }
                      });
                    },
                    onTemplatePreview: _showTemplatePreview,
                    onTemplateUse: _useTemplate,
                  ),
                  
                  // Favorites tab
                  FavoritesTemplatesWidget(
                    searchQuery: _searchQuery,
                    onTemplatePreview: _showTemplatePreview,
                    onTemplateUse: _useTemplate,
                    onTemplateCustomize: _customizeTemplate,
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