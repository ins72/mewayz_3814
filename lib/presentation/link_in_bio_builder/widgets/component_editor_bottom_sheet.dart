import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class ComponentEditorBottomSheet extends StatefulWidget {
  final Map<String, dynamic> component;
  final Function(Map<String, dynamic>) onUpdate;

  const ComponentEditorBottomSheet({
    Key? key,
    required this.component,
    required this.onUpdate,
  }) : super(key: key);

  @override
  State<ComponentEditorBottomSheet> createState() =>
      _ComponentEditorBottomSheetState();
}

class _ComponentEditorBottomSheetState extends State<ComponentEditorBottomSheet>
    with TickerProviderStateMixin {
  late TabController _tabController;
  late Map<String, dynamic> _editedComponent;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _editedComponent = Map<String, dynamic>.from(widget.component);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _updateProperty(String key, dynamic value) {
    setState(() {
      _editedComponent['defaultProps'][key] = value;
    });
  }

  void _saveChanges() {
    widget.onUpdate(_editedComponent);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 70.h,
      decoration: BoxDecoration(
        color: AppTheme.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        children: [
          _buildHeader(),
          _buildTabBar(),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildContentTab(),
                _buildDesignTab(),
                _buildActionsTab(),
              ],
            ),
          ),
          _buildBottomActions(),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: AppTheme.primaryBackground,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        border: Border(
          bottom: BorderSide(color: AppTheme.border, width: 1),
        ),
      ),
      child: Column(
        children: [
          Container(
            width: 12.w,
            height: 0.5.h,
            decoration: BoxDecoration(
              color: AppTheme.border,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          SizedBox(height: 2.h),
          Row(
            children: [
              CustomIconWidget(
                iconName: _editedComponent['icon'] as String,
                color: AppTheme.accent,
                size: 24,
              ),
              SizedBox(width: 3.w),
              Text(
                'Edit ${_editedComponent['name']}',
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
        ],
      ),
    );
  }

  Widget _buildTabBar() {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.primaryBackground,
        border: Border(
          bottom: BorderSide(color: AppTheme.border, width: 1),
        ),
      ),
      child: TabBar(
        controller: _tabController,
        tabs: const [
          Tab(text: 'Content'),
          Tab(text: 'Design'),
          Tab(text: 'Actions'),
        ],
      ),
    );
  }

  Widget _buildContentTab() {
    final type = _editedComponent['type'] as String;
    final props = _editedComponent['defaultProps'] as Map<String, dynamic>;

    return SingleChildScrollView(
      padding: EdgeInsets.all(4.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (type == 'text') ..._buildTextContentFields(props),
          if (type == 'button') ..._buildButtonContentFields(props),
          if (type == 'image') ..._buildImageContentFields(props),
          if (type == 'video') ..._buildVideoContentFields(props),
          if (type == 'product') ..._buildProductContentFields(props),
          if (type == 'form') ..._buildFormContentFields(props),
          if (type == 'social') ..._buildSocialContentFields(props),
        ],
      ),
    );
  }

  List<Widget> _buildTextContentFields(Map<String, dynamic> props) {
    return [
      Text(
        'Text Content',
        style: AppTheme.darkTheme.textTheme.titleMedium,
      ),
      SizedBox(height: 2.h),
      TextFormField(
        initialValue: props['content'] as String,
        decoration: const InputDecoration(
          labelText: 'Text',
          hintText: 'Enter your text here',
        ),
        maxLines: 3,
        onChanged: (value) => _updateProperty('content', value),
      ),
      SizedBox(height: 2.h),
      Text(
        'Text Alignment',
        style: AppTheme.darkTheme.textTheme.bodyMedium,
      ),
      SizedBox(height: 1.h),
      Row(
        children: ['left', 'center', 'right'].map((alignment) {
          final isSelected = props['alignment'] == alignment;
          return Expanded(
            child: GestureDetector(
              onTap: () => _updateProperty('alignment', alignment),
              child: Container(
                margin: EdgeInsets.only(right: alignment != 'right' ? 2.w : 0),
                padding: EdgeInsets.symmetric(vertical: 1.5.h),
                decoration: BoxDecoration(
                  color: isSelected
                      ? AppTheme.accent.withValues(alpha: 0.2)
                      : AppTheme.primaryBackground,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: isSelected ? AppTheme.accent : AppTheme.border,
                  ),
                ),
                child: Center(
                  child: CustomIconWidget(
                    iconName: alignment == 'left'
                        ? 'format_align_left'
                        : alignment == 'center'
                            ? 'format_align_center'
                            : 'format_align_right',
                    color: isSelected ? AppTheme.accent : AppTheme.primaryText,
                    size: 20,
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    ];
  }

  List<Widget> _buildButtonContentFields(Map<String, dynamic> props) {
    return [
      Text(
        'Button Content',
        style: AppTheme.darkTheme.textTheme.titleMedium,
      ),
      SizedBox(height: 2.h),
      TextFormField(
        initialValue: props['text'] as String,
        decoration: const InputDecoration(
          labelText: 'Button Text',
          hintText: 'Enter button text',
        ),
        onChanged: (value) => _updateProperty('text', value),
      ),
      SizedBox(height: 2.h),
      TextFormField(
        initialValue: props['url'] as String,
        decoration: const InputDecoration(
          labelText: 'Link URL',
          hintText: 'https://example.com',
        ),
        keyboardType: TextInputType.url,
        onChanged: (value) => _updateProperty('url', value),
      ),
    ];
  }

  List<Widget> _buildImageContentFields(Map<String, dynamic> props) {
    return [
      Text(
        'Image Content',
        style: AppTheme.darkTheme.textTheme.titleMedium,
      ),
      SizedBox(height: 2.h),
      TextFormField(
        initialValue: props['url'] as String,
        decoration: const InputDecoration(
          labelText: 'Image URL',
          hintText: 'https://example.com/image.jpg',
        ),
        keyboardType: TextInputType.url,
        onChanged: (value) => _updateProperty('url', value),
      ),
      SizedBox(height: 2.h),
      ElevatedButton.icon(
        onPressed: () {
          // Simulate image upload
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Text('Image upload feature coming soon!'),
              backgroundColor: AppTheme.accent,
            ),
          );
        },
        icon: CustomIconWidget(
          iconName: 'upload',
          color: AppTheme.primaryBackground,
          size: 20,
        ),
        label: const Text('Upload Image'),
      ),
    ];
  }

  List<Widget> _buildVideoContentFields(Map<String, dynamic> props) {
    return [
      Text(
        'Video Content',
        style: AppTheme.darkTheme.textTheme.titleMedium,
      ),
      SizedBox(height: 2.h),
      TextFormField(
        initialValue: props['url'] as String,
        decoration: const InputDecoration(
          labelText: 'Video URL',
          hintText: 'https://example.com/video.mp4',
        ),
        keyboardType: TextInputType.url,
        onChanged: (value) => _updateProperty('url', value),
      ),
      SizedBox(height: 2.h),
      TextFormField(
        initialValue: props['thumbnail'] as String,
        decoration: const InputDecoration(
          labelText: 'Thumbnail URL',
          hintText: 'https://example.com/thumbnail.jpg',
        ),
        keyboardType: TextInputType.url,
        onChanged: (value) => _updateProperty('thumbnail', value),
      ),
      SizedBox(height: 2.h),
      Row(
        children: [
          Text(
            'Autoplay',
            style: AppTheme.darkTheme.textTheme.bodyMedium,
          ),
          const Spacer(),
          Switch(
            value: props['autoplay'] as bool,
            onChanged: (value) => _updateProperty('autoplay', value),
          ),
        ],
      ),
    ];
  }

  List<Widget> _buildProductContentFields(Map<String, dynamic> props) {
    return [
      Text(
        'Product Content',
        style: AppTheme.darkTheme.textTheme.titleMedium,
      ),
      SizedBox(height: 2.h),
      TextFormField(
        initialValue: props['name'] as String,
        decoration: const InputDecoration(
          labelText: 'Product Name',
          hintText: 'Enter product name',
        ),
        onChanged: (value) => _updateProperty('name', value),
      ),
      SizedBox(height: 2.h),
      TextFormField(
        initialValue: props['price'] as String,
        decoration: const InputDecoration(
          labelText: 'Price',
          hintText: '\$99.99',
        ),
        keyboardType: TextInputType.number,
        onChanged: (value) => _updateProperty('price', value),
      ),
      SizedBox(height: 2.h),
      TextFormField(
        initialValue: props['description'] as String,
        decoration: const InputDecoration(
          labelText: 'Description',
          hintText: 'Product description',
        ),
        maxLines: 3,
        onChanged: (value) => _updateProperty('description', value),
      ),
      SizedBox(height: 2.h),
      TextFormField(
        initialValue: props['image'] as String,
        decoration: const InputDecoration(
          labelText: 'Product Image URL',
          hintText: 'https://example.com/product.jpg',
        ),
        keyboardType: TextInputType.url,
        onChanged: (value) => _updateProperty('image', value),
      ),
    ];
  }

  List<Widget> _buildFormContentFields(Map<String, dynamic> props) {
    return [
      Text(
        'Form Content',
        style: AppTheme.darkTheme.textTheme.titleMedium,
      ),
      SizedBox(height: 2.h),
      TextFormField(
        initialValue: props['title'] as String,
        decoration: const InputDecoration(
          labelText: 'Form Title',
          hintText: 'Contact Us',
        ),
        onChanged: (value) => _updateProperty('title', value),
      ),
      SizedBox(height: 2.h),
      TextFormField(
        initialValue: props['submitText'] as String,
        decoration: const InputDecoration(
          labelText: 'Submit Button Text',
          hintText: 'Send Message',
        ),
        onChanged: (value) => _updateProperty('submitText', value),
      ),
    ];
  }

  List<Widget> _buildSocialContentFields(Map<String, dynamic> props) {
    return [
      Text(
        'Social Links',
        style: AppTheme.darkTheme.textTheme.titleMedium,
      ),
      SizedBox(height: 2.h),
      ...(props['platforms'] as List).asMap().entries.map((entry) {
        final index = entry.key;
        final platform = entry.value as Map<String, dynamic>;

        return Container(
          margin: EdgeInsets.only(bottom: 2.h),
          padding: EdgeInsets.all(3.w),
          decoration: BoxDecoration(
            color: AppTheme.primaryBackground,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: AppTheme.border),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                platform['name'] as String,
                style: AppTheme.darkTheme.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(height: 1.h),
              TextFormField(
                initialValue: platform['url'] as String,
                decoration: InputDecoration(
                  labelText: '${platform['name']} URL',
                  hintText:
                      'https://${platform['name'].toString().toLowerCase()}.com/username',
                ),
                keyboardType: TextInputType.url,
                onChanged: (value) {
                  final platforms = List.from(props['platforms'] as List);
                  platforms[index]['url'] = value;
                  _updateProperty('platforms', platforms);
                },
              ),
            ],
          ),
        );
      }).toList(),
    ];
  }

  Widget _buildDesignTab() {
    final type = _editedComponent['type'] as String;
    final props = _editedComponent['defaultProps'] as Map<String, dynamic>;

    return SingleChildScrollView(
      padding: EdgeInsets.all(4.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (type == 'text') ..._buildTextDesignFields(props),
          if (type == 'button') ..._buildButtonDesignFields(props),
          if (type == 'image') ..._buildImageDesignFields(props),
          ..._buildSpacingFields(),
        ],
      ),
    );
  }

  List<Widget> _buildTextDesignFields(Map<String, dynamic> props) {
    return [
      Text(
        'Text Style',
        style: AppTheme.darkTheme.textTheme.titleMedium,
      ),
      SizedBox(height: 2.h),
      Text(
        'Font Size: ${(props['fontSize'] as double).toInt()}px',
        style: AppTheme.darkTheme.textTheme.bodyMedium,
      ),
      Slider(
        value: props['fontSize'] as double,
        min: 12.0,
        max: 32.0,
        divisions: 20,
        onChanged: (value) => _updateProperty('fontSize', value),
      ),
      SizedBox(height: 2.h),
      Row(
        children: [
          Text(
            'Bold Text',
            style: AppTheme.darkTheme.textTheme.bodyMedium,
          ),
          const Spacer(),
          Switch(
            value: props['fontWeight'] == 'bold',
            onChanged: (value) =>
                _updateProperty('fontWeight', value ? 'bold' : 'normal'),
          ),
        ],
      ),
      SizedBox(height: 2.h),
      _buildColorPicker('Text Color', props['color'] as String,
          (color) => _updateProperty('color', color)),
    ];
  }

  List<Widget> _buildButtonDesignFields(Map<String, dynamic> props) {
    return [
      Text(
        'Button Style',
        style: AppTheme.darkTheme.textTheme.titleMedium,
      ),
      SizedBox(height: 2.h),
      _buildColorPicker('Background Color', props['backgroundColor'] as String,
          (color) => _updateProperty('backgroundColor', color)),
      SizedBox(height: 2.h),
      _buildColorPicker('Text Color', props['textColor'] as String,
          (color) => _updateProperty('textColor', color)),
      SizedBox(height: 2.h),
      Text(
        'Border Radius: ${(props['borderRadius'] as double).toInt()}px',
        style: AppTheme.darkTheme.textTheme.bodyMedium,
      ),
      Slider(
        value: props['borderRadius'] as double,
        min: 0.0,
        max: 24.0,
        divisions: 24,
        onChanged: (value) => _updateProperty('borderRadius', value),
      ),
    ];
  }

  List<Widget> _buildImageDesignFields(Map<String, dynamic> props) {
    return [
      Text(
        'Image Style',
        style: AppTheme.darkTheme.textTheme.titleMedium,
      ),
      SizedBox(height: 2.h),
      Text(
        'Border Radius: ${(props['borderRadius'] as double).toInt()}px',
        style: AppTheme.darkTheme.textTheme.bodyMedium,
      ),
      Slider(
        value: props['borderRadius'] as double,
        min: 0.0,
        max: 24.0,
        divisions: 24,
        onChanged: (value) => _updateProperty('borderRadius', value),
      ),
    ];
  }

  Widget _buildColorPicker(
      String label, String currentColor, Function(String) onColorChanged) {
    final colors = [
      '#F1F1F1',
      '#7B7B7B',
      '#3B82F6',
      '#10B981',
      '#EF4444',
      '#F59E0B',
      '#8B5CF6',
      '#EC4899'
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTheme.darkTheme.textTheme.bodyMedium,
        ),
        SizedBox(height: 1.h),
        Wrap(
          spacing: 2.w,
          runSpacing: 1.h,
          children: colors.map((color) {
            final isSelected = color == currentColor;
            return GestureDetector(
              onTap: () => onColorChanged(color),
              child: Container(
                width: 10.w,
                height: 10.w,
                decoration: BoxDecoration(
                  color: Color(int.parse(color.replaceAll('#', '0xFF'))),
                  shape: BoxShape.circle,
                  border: Border.all(
                    color:
                        isSelected ? AppTheme.primaryAction : AppTheme.border,
                    width: isSelected ? 3 : 1,
                  ),
                ),
                child: isSelected
                    ? Center(
                        child: CustomIconWidget(
                          iconName: 'check',
                          color: color == '#F1F1F1'
                              ? AppTheme.primaryBackground
                              : AppTheme.primaryAction,
                          size: 16,
                        ),
                      )
                    : null,
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  List<Widget> _buildSpacingFields() {
    return [
      SizedBox(height: 3.h),
      Text(
        'Spacing',
        style: AppTheme.darkTheme.textTheme.titleMedium,
      ),
      SizedBox(height: 2.h),
      Text(
        'Margin: 16px',
        style: AppTheme.darkTheme.textTheme.bodyMedium,
      ),
      Slider(
        value: 16.0,
        min: 0.0,
        max: 32.0,
        divisions: 32,
        onChanged: (value) {
          // Handle margin change
        },
      ),
    ];
  }

  Widget _buildActionsTab() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(4.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Component Actions',
            style: AppTheme.darkTheme.textTheme.titleMedium,
          ),
          SizedBox(height: 2.h),
          Text(
            'Configure what happens when users interact with this component.',
            style: AppTheme.darkTheme.textTheme.bodySmall,
          ),
          SizedBox(height: 3.h),
          _buildActionOption(
            'Open Link',
            'Navigate to external URL',
            'link',
            true,
          ),
          _buildActionOption(
            'Send Email',
            'Open email client',
            'email',
            false,
          ),
          _buildActionOption(
            'Make Call',
            'Initiate phone call',
            'phone',
            false,
          ),
          _buildActionOption(
            'Download File',
            'Download a file',
            'download',
            false,
          ),
        ],
      ),
    );
  }

  Widget _buildActionOption(
      String title, String description, String action, bool isSelected) {
    return Container(
      margin: EdgeInsets.only(bottom: 2.h),
      child: ListTile(
        contentPadding: EdgeInsets.all(3.w),
        tileColor: isSelected
            ? AppTheme.accent.withValues(alpha: 0.1)
            : AppTheme.primaryBackground,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(
            color: isSelected ? AppTheme.accent : AppTheme.border,
            width: isSelected ? 2 : 1,
          ),
        ),
        leading: Container(
          width: 6.w,
          height: 6.w,
          decoration: BoxDecoration(
            color: isSelected ? AppTheme.accent : AppTheme.border,
            shape: BoxShape.circle,
          ),
          child: isSelected
              ? Center(
                  child: CustomIconWidget(
                    iconName: 'check',
                    color: AppTheme.primaryAction,
                    size: 16,
                  ),
                )
              : null,
        ),
        title: Text(
          title,
          style: AppTheme.darkTheme.textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.w500,
            color: isSelected ? AppTheme.accent : AppTheme.primaryText,
          ),
        ),
        subtitle: Text(
          description,
          style: AppTheme.darkTheme.textTheme.bodySmall,
        ),
        onTap: () {
          // Handle action selection
        },
      ),
    );
  }

  Widget _buildBottomActions() {
    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: AppTheme.primaryBackground,
        border: Border(
          top: BorderSide(color: AppTheme.border, width: 1),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: OutlinedButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
          ),
          SizedBox(width: 4.w),
          Expanded(
            child: ElevatedButton(
              onPressed: _saveChanges,
              child: const Text('Save Changes'),
            ),
          ),
        ],
      ),
    );
  }
}