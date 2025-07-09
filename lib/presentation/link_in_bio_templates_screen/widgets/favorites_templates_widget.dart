import 'package:flutter/material.dart';

import '../../../core/app_export.dart';
import '../../../theme/app_theme.dart';
import './template_card_widget.dart';
import './template_gallery_widget.dart';

class FavoritesTemplatesWidget extends StatefulWidget {
  final String searchQuery;
  final Function(String) onTemplatePreview;
  final Function(String) onTemplateUse;
  final Function(String) onTemplateCustomize;

  const FavoritesTemplatesWidget({
    Key? key,
    required this.searchQuery,
    required this.onTemplatePreview,
    required this.onTemplateUse,
    required this.onTemplateCustomize,
  }) : super(key: key);

  @override
  State<FavoritesTemplatesWidget> createState() => _FavoritesTemplatesWidgetState();
}

class _FavoritesTemplatesWidgetState extends State<FavoritesTemplatesWidget> {
  late ScrollController _scrollController;
  List<TemplateData> _favoriteTemplates = [];

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _loadFavoriteTemplates();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _loadFavoriteTemplates() {
    // Mock favorite templates data
    _favoriteTemplates = [
      TemplateData(
        id: 'template_2',
        name: 'Business Professional',
        category: 'Business',
        previewUrl: 'https://images.unsplash.com/photo-1460925895917-afdab827c52f?w=300&h=600&fit=crop',
        isPremium: true,
        usageCount: 890,
        rating: 4.9,
        tags: ['Professional', 'Business', 'Clean'],
        isPopular: true,
        isFavorite: true,
        description: 'Clean and professional template for business',
        features: ['Contact Form', 'Analytics', 'Custom Domain'],
      ),
      TemplateData(
        id: 'template_5',
        name: 'E-commerce Store',
        category: 'E-commerce',
        previewUrl: 'https://images.unsplash.com/photo-1472851294608-062f824d29cc?w=300&h=600&fit=crop',
        isPremium: true,
        usageCount: 2100,
        rating: 4.9,
        tags: ['E-commerce', 'Shopping', 'Store'],
        isPopular: true,
        isFavorite: true,
        description: 'Complete e-commerce template with payment integration',
        features: ['Product Catalog', 'Shopping Cart', 'Payment Gateway'],
      ),
    ];
  }

  List<TemplateData> get _filteredFavorites {
    if (widget.searchQuery.isEmpty) {
      return _favoriteTemplates;
    }
    
    return _favoriteTemplates.where((template) {
      final query = widget.searchQuery.toLowerCase();
      return template.name.toLowerCase().contains(query) ||
             template.category.toLowerCase().contains(query) ||
             template.tags.any((tag) => tag.toLowerCase().contains(query));
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final filteredFavorites = _filteredFavorites;

    if (_favoriteTemplates.isEmpty) {
      return _buildEmptyState();
    }

    if (filteredFavorites.isEmpty) {
      return _buildNoResultsState();
    }

    return GridView.builder(
      controller: _scrollController,
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 0.7,
      ),
      itemCount: filteredFavorites.length,
      itemBuilder: (context, index) {
        final template = filteredFavorites[index];
        return TemplateCardWidget(
          template: template,
          onPreview: () => widget.onTemplatePreview(template.id),
          onUse: () => widget.onTemplateUse(template.id),
          onCustomize: () => widget.onTemplateCustomize(template.id),
          onAnalytics: () {
            // Handle analytics
          },
        );
      },
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: AppTheme.surface,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(
              Icons.favorite_border,
              size: 64,
              color: AppTheme.secondaryText,
            ),
          ),
          const SizedBox(height: 24),
          Text(
            'No Favorite Templates',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              color: AppTheme.primaryText,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Start adding templates to your favorites\nto see them here',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: AppTheme.secondaryText,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: () {
              // Switch to browse tab
              DefaultTabController.of(context).animateTo(0);
            },
            icon: const Icon(Icons.explore),
            label: const Text('Browse Templates'),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.accent,
              foregroundColor: AppTheme.primaryText,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNoResultsState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.search_off,
            size: 64,
            color: AppTheme.secondaryText,
          ),
          const SizedBox(height: 16),
          Text(
            'No Matching Favorites',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: AppTheme.primaryText,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Try adjusting your search query',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: AppTheme.secondaryText,
            ),
          ),
        ],
      ),
    );
  }
}