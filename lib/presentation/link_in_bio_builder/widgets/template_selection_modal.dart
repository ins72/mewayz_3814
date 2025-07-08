import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class TemplateSelectionModal extends StatefulWidget {
  final Function(Map<String, dynamic>) onTemplateSelected;

  const TemplateSelectionModal({
    Key? key,
    required this.onTemplateSelected,
  }) : super(key: key);

  @override
  State<TemplateSelectionModal> createState() => _TemplateSelectionModalState();
}

class _TemplateSelectionModalState extends State<TemplateSelectionModal> {
  String _selectedCategory = 'All';

  final List<String> _categories = [
    'All',
    'Restaurant',
    'Fitness',
    'Beauty',
    'Business',
    'Creative',
    'E-commerce',
  ];

  final List<Map<String, dynamic>> _templates = [
    {
      'id': 'restaurant_1',
      'name': 'Modern Restaurant',
      'category': 'Restaurant',
      'thumbnail':
          'https://images.unsplash.com/photo-1517248135467-4c7edcad34c4?w=400',
      'components': [
        {
          'id': '1',
          'type': 'text',
          'defaultProps': {
            'content': 'Welcome to Bella Vista',
            'fontSize': 24.0,
            'fontWeight': 'bold',
            'color': '#F1F1F1',
            'alignment': 'center',
          }
        },
        {
          'id': '2',
          'type': 'image',
          'defaultProps': {
            'url':
                'https://images.unsplash.com/photo-1517248135467-4c7edcad34c4?w=400',
            'width': 100.0,
            'height': 60.0,
            'borderRadius': 12.0,
          }
        },
        {
          'id': '3',
          'type': 'button',
          'defaultProps': {
            'text': 'View Menu',
            'backgroundColor': '#3B82F6',
            'textColor': '#FFFFFF',
            'borderRadius': 12.0,
            'action': 'link',
            'url': '',
          }
        },
      ]
    },
    {
      'id': 'fitness_1',
      'name': 'Fitness Studio',
      'category': 'Fitness',
      'thumbnail':
          'https://images.unsplash.com/photo-1571019613454-1cb2f99b2d8b?w=400',
      'components': [
        {
          'id': '1',
          'type': 'text',
          'defaultProps': {
            'content': 'Transform Your Body',
            'fontSize': 22.0,
            'fontWeight': 'bold',
            'color': '#F1F1F1',
            'alignment': 'center',
          }
        },
        {
          'id': '2',
          'type': 'video',
          'defaultProps': {
            'url':
                'https://sample-videos.com/zip/10/mp4/SampleVideo_1280x720_1mb.mp4',
            'thumbnail':
                'https://images.unsplash.com/photo-1571019613454-1cb2f99b2d8b?w=400',
            'autoplay': false,
          }
        },
        {
          'id': '3',
          'type': 'button',
          'defaultProps': {
            'text': 'Book Session',
            'backgroundColor': '#10B981',
            'textColor': '#FFFFFF',
            'borderRadius': 12.0,
            'action': 'link',
            'url': '',
          }
        },
      ]
    },
    {
      'id': 'beauty_1',
      'name': 'Beauty Salon',
      'category': 'Beauty',
      'thumbnail':
          'https://images.unsplash.com/photo-1560066984-138dadb4c035?w=400',
      'components': [
        {
          'id': '1',
          'type': 'text',
          'defaultProps': {
            'content': 'Glow Beauty Studio',
            'fontSize': 20.0,
            'fontWeight': 'bold',
            'color': '#F1F1F1',
            'alignment': 'center',
          }
        },
        {
          'id': '2',
          'type': 'image',
          'defaultProps': {
            'url':
                'https://images.unsplash.com/photo-1560066984-138dadb4c035?w=400',
            'width': 100.0,
            'height': 50.0,
            'borderRadius': 12.0,
          }
        },
        {
          'id': '3',
          'type': 'social',
          'defaultProps': {
            'platforms': [
              {'name': 'Instagram', 'url': '', 'icon': 'camera_alt'},
              {'name': 'Facebook', 'url': '', 'icon': 'facebook'},
            ]
          }
        },
      ]
    },
    {
      'id': 'business_1',
      'name': 'Professional Services',
      'category': 'Business',
      'thumbnail':
          'https://images.unsplash.com/photo-1497366216548-37526070297c?w=400',
      'components': [
        {
          'id': '1',
          'type': 'text',
          'defaultProps': {
            'content': 'Professional Consulting',
            'fontSize': 18.0,
            'fontWeight': 'bold',
            'color': '#F1F1F1',
            'alignment': 'center',
          }
        },
        {
          'id': '2',
          'type': 'contact_form',
          'defaultProps': {
            'title': 'Get in Touch',
            'fields': ['name', 'email', 'message'],
            'submitText': 'Send Message',
          }
        },
      ]
    },
    {
      'id': 'creative_1',
      'name': 'Creative Portfolio',
      'category': 'Creative',
      'thumbnail':
          'https://images.unsplash.com/photo-1541961017774-22349e4a1262?w=400',
      'components': [
        {
          'id': '1',
          'type': 'text',
          'defaultProps': {
            'content': 'Creative Designer',
            'fontSize': 24.0,
            'fontWeight': 'bold',
            'color': '#F1F1F1',
            'alignment': 'center',
          }
        },
        {
          'id': '2',
          'type': 'image',
          'defaultProps': {
            'url':
                'https://images.unsplash.com/photo-1541961017774-22349e4a1262?w=400',
            'width': 100.0,
            'height': 70.0,
            'borderRadius': 8.0,
          }
        },
        {
          'id': '3',
          'type': 'button',
          'defaultProps': {
            'text': 'View Portfolio',
            'backgroundColor': '#8B5CF6',
            'textColor': '#FFFFFF',
            'borderRadius': 12.0,
            'action': 'link',
            'url': '',
          }
        },
      ]
    },
    {
      'id': 'ecommerce_1',
      'name': 'Online Store',
      'category': 'E-commerce',
      'thumbnail':
          'https://images.unsplash.com/photo-1556742049-0cfed4f6a45d?w=400',
      'components': [
        {
          'id': '1',
          'type': 'text',
          'defaultProps': {
            'content': 'Shop Collection',
            'fontSize': 22.0,
            'fontWeight': 'bold',
            'color': '#F1F1F1',
            'alignment': 'center',
          }
        },
        {
          'id': '2',
          'type': 'product',
          'defaultProps': {
            'name': 'Featured Product',
            'price': '\$49.99',
            'image':
                'https://images.unsplash.com/photo-1556742049-0cfed4f6a45d?w=400',
            'description': 'Premium quality product',
            'buyLink': '',
          }
        },
      ]
    },
  ];

  List<Map<String, dynamic>> get _filteredTemplates {
    if (_selectedCategory == 'All') {
      return _templates;
    }
    return _templates
        .where((template) => template['category'] == _selectedCategory)
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        width: 90.w,
        height: 80.h,
        decoration: BoxDecoration(
          color: AppTheme.surface,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          children: [
            _buildHeader(),
            _buildCategoryTabs(),
            Expanded(
              child: _buildTemplateGrid(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: AppTheme.primaryBackground,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
        border: Border(
          bottom: BorderSide(color: AppTheme.border, width: 1),
        ),
      ),
      child: Row(
        children: [
          Text(
            'Choose Template',
            style: AppTheme.darkTheme.textTheme.titleLarge,
          ),
          const Spacer(),
          IconButton(
            onPressed: () => Navigator.pop(context),
            icon: CustomIconWidget(
              iconName: 'close',
              color: AppTheme.primaryText,
              size: 24,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryTabs() {
    return Container(
      height: 6.h,
      padding: EdgeInsets.symmetric(vertical: 1.h),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(horizontal: 4.w),
        itemCount: _categories.length,
        itemBuilder: (context, index) {
          final category = _categories[index];
          final isSelected = category == _selectedCategory;

          return GestureDetector(
            onTap: () {
              setState(() {
                _selectedCategory = category;
              });
            },
            child: Container(
              margin: EdgeInsets.only(right: 2.w),
              padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
              decoration: BoxDecoration(
                color: isSelected ? AppTheme.accent : Colors.transparent,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: isSelected ? AppTheme.accent : AppTheme.border,
                ),
              ),
              child: Text(
                category,
                style: AppTheme.darkTheme.textTheme.bodyMedium?.copyWith(
                  color: isSelected
                      ? AppTheme.primaryAction
                      : AppTheme.primaryText,
                  fontWeight: isSelected ? FontWeight.w500 : FontWeight.w400,
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildTemplateGrid() {
    return GridView.builder(
      padding: EdgeInsets.all(4.w),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 3.w,
        mainAxisSpacing: 3.w,
        childAspectRatio: 0.8,
      ),
      itemCount: _filteredTemplates.length,
      itemBuilder: (context, index) {
        final template = _filteredTemplates[index];
        return _buildTemplateCard(template);
      },
    );
  }

  Widget _buildTemplateCard(Map<String, dynamic> template) {
    return GestureDetector(
      onTap: () {
        Navigator.pop(context);
        widget.onTemplateSelected(template);
      },
      child: Container(
        decoration: BoxDecoration(
          color: AppTheme.primaryBackground,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppTheme.border),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 3,
              child: ClipRRect(
                borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(12)),
                child: CustomImageWidget(
                  imageUrl: template['thumbnail'] as String,
                  width: double.infinity,
                  height: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Expanded(
              flex: 1,
              child: Container(
                padding: EdgeInsets.all(3.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      template['name'] as String,
                      style: AppTheme.darkTheme.textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w500,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: 0.5.h),
                    Text(
                      template['category'] as String,
                      style: AppTheme.darkTheme.textTheme.bodySmall,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
