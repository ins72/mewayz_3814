import 'package:flutter/material.dart';

import '../../../core/app_export.dart';
import '../../../theme/app_theme.dart';
import './template_card_widget.dart';

class TemplateGalleryWidget extends StatefulWidget {
  final String searchQuery;
  final List<String> selectedCategories;
  final List<String> selectedFilters;
  final Function(String) onTemplatePreview;
  final Function(String) onTemplateUse;
  final Function(String) onTemplateCustomize;
  final Function(String) onTemplateAnalytics;

  const TemplateGalleryWidget({
    Key? key,
    required this.searchQuery,
    required this.selectedCategories,
    required this.selectedFilters,
    required this.onTemplatePreview,
    required this.onTemplateUse,
    required this.onTemplateCustomize,
    required this.onTemplateAnalytics,
  }) : super(key: key);

  @override
  State<TemplateGalleryWidget> createState() => _TemplateGalleryWidgetState();
}

class _TemplateGalleryWidgetState extends State<TemplateGalleryWidget> {
  late ScrollController _scrollController;
  bool _isLoading = false;
  List<TemplateData> _templates = [];
  
  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _loadTemplates();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _loadTemplates() {
    // Mock template data - in real app, this would come from API
    _templates = [
      TemplateData(
        id: 'template_1',
        name: 'Creative Portfolio',
        category: 'Artist',
        previewUrl: 'https://images.unsplash.com/photo-1558655146-d09347e92766?w=300&h=600&fit=crop',
        isPremium: false,
        usageCount: 1250,
        rating: 4.8,
        tags: ['Creative', 'Portfolio', 'Modern'],
        isPopular: true,
        isFavorite: false,
        description: 'Perfect for creative professionals and artists',
        features: ['Responsive Design', 'Custom Colors', 'Social Links'],
      ),
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
        id: 'template_3',
        name: 'Fitness Trainer',
        category: 'Fitness',
        previewUrl: 'https://images.unsplash.com/photo-1571019613454-1cb2f99b2d8b?w=300&h=600&fit=crop',
        isPremium: false,
        usageCount: 650,
        rating: 4.7,
        tags: ['Fitness', 'Health', 'Energetic'],
        isPopular: false,
        isFavorite: false,
        description: 'Dynamic template for fitness professionals',
        features: ['Class Booking', 'Progress Tracking', 'Video Integration'],
      ),
      TemplateData(
        id: 'template_4',
        name: 'Restaurant Menu',
        category: 'Restaurant',
        previewUrl: 'https://images.unsplash.com/photo-1514933651103-005eec06c04b?w=300&h=600&fit=crop',
        isPremium: true,
        usageCount: 1100,
        rating: 4.6,
        tags: ['Restaurant', 'Food', 'Menu'],
        isPopular: true,
        isFavorite: false,
        description: 'Elegant template for restaurants and cafes',
        features: ['Menu Display', 'Online Ordering', 'Reviews'],
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
      TemplateData(
        id: 'template_6',
        name: 'Influencer Hub',
        category: 'Influencer',
        previewUrl: 'https://images.unsplash.com/photo-1611224923853-80b023f02d71?w=300&h=600&fit=crop',
        isPremium: false,
        usageCount: 1850,
        rating: 4.8,
        tags: ['Influencer', 'Social', 'Trendy'],
        isPopular: true,
        isFavorite: false,
        description: 'Perfect for social media influencers',
        features: ['Social Feed', 'Collaboration Tools', 'Analytics'],
      ),
    ];
  }

  List<TemplateData> get _filteredTemplates {
    return _templates.where((template) {
      // Search filter
      if (widget.searchQuery.isNotEmpty) {
        final query = widget.searchQuery.toLowerCase();
        if (!template.name.toLowerCase().contains(query) &&
            !template.category.toLowerCase().contains(query) &&
            !template.tags.any((tag) => tag.toLowerCase().contains(query))) {
          return false;
        }
      }
      
      // Category filter
      if (!widget.selectedCategories.contains('All')) {
        if (!widget.selectedCategories.contains(template.category)) {
          return false;
        }
      }
      
      // Additional filters
      for (final filter in widget.selectedFilters) {
        switch (filter) {
          case 'Free':
            if (template.isPremium) return false;
            break;
          case 'Premium':
            if (!template.isPremium) return false;
            break;
          case 'Most Popular':
            if (!template.isPopular) return false;
            break;
          case 'Minimal':
            if (!template.tags.contains('Minimal')) return false;
            break;
          case 'Bold':
            if (!template.tags.contains('Bold')) return false;
            break;
          case 'Creative':
            if (!template.tags.contains('Creative')) return false;
            break;
          case 'Modern':
            if (!template.tags.contains('Modern')) return false;
            break;
          case 'Professional':
            if (!template.tags.contains('Professional')) return false;
            break;
        }
      }
      
      return true;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final filteredTemplates = _filteredTemplates;
    
    if (filteredTemplates.isEmpty) {
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
              'No templates found',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: AppTheme.primaryText,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Try adjusting your search or filters',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: AppTheme.secondaryText,
              ),
            ),
          ],
        ),
      );
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
      itemCount: filteredTemplates.length,
      itemBuilder: (context, index) {
        final template = filteredTemplates[index];
        return TemplateCardWidget(
          template: template,
          onPreview: () => widget.onTemplatePreview(template.id),
          onUse: () => widget.onTemplateUse(template.id),
          onCustomize: () => widget.onTemplateCustomize(template.id),
          onAnalytics: () => widget.onTemplateAnalytics(template.id),
        );
      },
    );
  }
}

class TemplateData {
  final String id;
  final String name;
  final String category;
  final String previewUrl;
  final bool isPremium;
  final int usageCount;
  final double rating;
  final List<String> tags;
  final bool isPopular;
  final bool isFavorite;
  final String description;
  final List<String> features;

  TemplateData({
    required this.id,
    required this.name,
    required this.category,
    required this.previewUrl,
    required this.isPremium,
    required this.usageCount,
    required this.rating,
    required this.tags,
    required this.isPopular,
    required this.isFavorite,
    required this.description,
    required this.features,
  });
  
  String get imageUrl => previewUrl;
}