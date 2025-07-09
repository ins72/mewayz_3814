
import '../../core/app_export.dart';
import './widgets/component_editor_bottom_sheet.dart';
import './widgets/mobile_preview_widget.dart';

class LinkInBioBuilder extends StatefulWidget {
  const LinkInBioBuilder({Key? key}) : super(key: key);

  @override
  State<LinkInBioBuilder> createState() => _LinkInBioBuilderState();
}

class _LinkInBioBuilderState extends State<LinkInBioBuilder> {
  String _selectedTemplate = 'modern';
  Color _primaryColor = AppTheme.accent;
  Color _backgroundColor = AppTheme.primaryBackground;
  String _profileImage = '';
  String _displayName = 'Your Name';
  String _bio = 'Tell your story in a few words';
  bool _isPreviewMode = false;
  bool _showTemplateModal = false;
  bool _showDomainModal = false;
  bool _showQRModal = false;
  String _selectedComponent = '';

  final List<Map<String, dynamic>> _linkComponents = [
{ 'type': 'link',
'title': 'My Website',
'url': 'https://yourwebsite.com',
'icon': 'language',
'enabled': true,
},
{ 'type': 'social',
'title': 'Instagram',
'url': 'https://instagram.com/yourusername',
'icon': 'camera_alt',
'enabled': true,
},
{ 'type': 'contact',
'title': 'Contact Me',
'url': 'mailto:contact@yourmail.com',
'icon': 'email',
'enabled': true,
},
];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.primaryBackground,
      appBar: _buildAppBar(),
      body: _isPreviewMode ? _buildPreviewMode() : _buildEditorMode(),
      bottomNavigationBar: _buildBottomActionBar());
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: AppTheme.primaryBackground,
      elevation: 0,
      leading: IconButton(
        icon: CustomIconWidget(
          iconName: 'arrow_back',
          color: AppTheme.primaryText,
          size: 24),
        onPressed: () => Navigator.pop(context)),
      title: Text(
        'Link in Bio Builder',
        style: AppTheme.darkTheme.textTheme.titleLarge?.copyWith(
          color: AppTheme.primaryText,
          fontWeight: FontWeight.w600)),
      actions: [
        IconButton(
          icon: CustomIconWidget(
            iconName: _isPreviewMode ? 'edit' : 'visibility',
            color: AppTheme.primaryText,
            size: 24),
          onPressed: () {
            setState(() {
              _isPreviewMode = !_isPreviewMode;
            });
          }),
        IconButton(
          icon: CustomIconWidget(
            iconName: 'more_vert',
            color: AppTheme.primaryText,
            size: 24),
          onPressed: () => _showOptionsMenu()),
      ]);
  }

  Widget _buildPreviewMode() {
    return Center(
      child: Container(
        width: 90.w,
        height: 80.h,
        decoration: BoxDecoration(
          color: AppTheme.surface,
          borderRadius: BorderRadius.circular(AppTheme.radiusL),
          border: Border.all(
            color: AppTheme.border,
            width: 2)),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(AppTheme.radiusL),
          child: MobilePreviewWidget(
            components: _linkComponents,
            pageSettings: {
              'primaryColor': _primaryColor,
              'backgroundColor': _backgroundColor,
              'profileImage': _profileImage,
              'displayName': _displayName,
              'bio': _bio,
              'template': _selectedTemplate,
            },
            selectedComponentId: _selectedComponent,
            onComponentTap: (id) {},
            onComponentLongPress: (id) {},
          ))));
  }

  Widget _buildEditorMode() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(4.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildProfileSection(),
          SizedBox(height: 4.h),
          _buildAppearanceSection(),
          SizedBox(height: 4.h),
          _buildLinksSection(),
          SizedBox(height: 4.h),
          _buildTemplatesSection(),
          SizedBox(height: 8.h),
        ]));
  }

  Widget _buildProfileSection() {
    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.circular(AppTheme.radiusM),
        border: Border.all(
          color: AppTheme.border.withAlpha(26),
          width: 1)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CustomIconWidget(
                iconName: 'person',
                color: AppTheme.accent,
                size: 24),
              SizedBox(width: 3.w),
              Text(
                'Profile',
                style: AppTheme.darkTheme.textTheme.titleMedium?.copyWith(
                  color: AppTheme.primaryText,
                  fontWeight: FontWeight.w600)),
            ]),
          SizedBox(height: 3.h),
          Center(
            child: GestureDetector(
              onTap: () => _selectProfileImage(),
              child: Container(
                width: 20.w,
                height: 20.w,
                decoration: BoxDecoration(
                  color: AppTheme.surfaceVariant,
                  borderRadius: BorderRadius.circular(10.w),
                  border: Border.all(
                    color: AppTheme.accent,
                    width: 2)),
                child: _profileImage.isEmpty
                    ? Center(
                        child: CustomIconWidget(
                          iconName: 'add_a_photo',
                          color: AppTheme.accent,
                          size: 32))
                    : ClipRRect(
                        borderRadius: BorderRadius.circular(10.w),
                        child: CustomImageWidget(
                          imageUrl: _profileImage,
                          width: 20.w,
                          height: 20.w,
                          fit: BoxFit.cover))))),
          SizedBox(height: 3.h),
          TextFormField(
            initialValue: _displayName,
            decoration: InputDecoration(
              labelText: 'Display Name',
              prefixIcon: CustomIconWidget(
                iconName: 'badge',
                color: AppTheme.secondaryText,
                size: 20)),
            style: AppTheme.darkTheme.textTheme.bodyMedium,
            onChanged: (value) {
              setState(() {
                _displayName = value;
              });
            }),
          SizedBox(height: 2.h),
          TextFormField(
            initialValue: _bio,
            maxLines: 3,
            decoration: InputDecoration(
              labelText: 'Bio',
              prefixIcon: CustomIconWidget(
                iconName: 'description',
                color: AppTheme.secondaryText,
                size: 20)),
            style: AppTheme.darkTheme.textTheme.bodyMedium,
            onChanged: (value) {
              setState(() {
                _bio = value;
              });
            }),
        ]));
  }

  Widget _buildAppearanceSection() {
    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.circular(AppTheme.radiusM),
        border: Border.all(
          color: AppTheme.border.withAlpha(26),
          width: 1)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CustomIconWidget(
                iconName: 'palette',
                color: AppTheme.accent,
                size: 24),
              SizedBox(width: 3.w),
              Text(
                'Appearance',
                style: AppTheme.darkTheme.textTheme.titleMedium?.copyWith(
                  color: AppTheme.primaryText,
                  fontWeight: FontWeight.w600)),
            ]),
          SizedBox(height: 3.h),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Primary Color',
                      style: AppTheme.darkTheme.textTheme.bodyMedium?.copyWith(
                        color: AppTheme.primaryText)),
                    SizedBox(height: 1.h),
                    GestureDetector(
                      onTap: () => _showColorPicker(true),
                      child: Container(
                        width: 12.w,
                        height: 6.h,
                        decoration: BoxDecoration(
                          color: _primaryColor,
                          borderRadius: BorderRadius.circular(AppTheme.radiusS),
                          border: Border.all(
                            color: AppTheme.border,
                            width: 1)))),
                  ])),
              SizedBox(width: 4.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Background',
                      style: AppTheme.darkTheme.textTheme.bodyMedium?.copyWith(
                        color: AppTheme.primaryText)),
                    SizedBox(height: 1.h),
                    GestureDetector(
                      onTap: () => _showColorPicker(false),
                      child: Container(
                        width: 12.w,
                        height: 6.h,
                        decoration: BoxDecoration(
                          color: _backgroundColor,
                          borderRadius: BorderRadius.circular(AppTheme.radiusS),
                          border: Border.all(
                            color: AppTheme.border,
                            width: 1)))),
                  ])),
            ]),
        ]));
  }

  Widget _buildLinksSection() {
    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.circular(AppTheme.radiusM),
        border: Border.all(
          color: AppTheme.border.withAlpha(26),
          width: 1)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CustomIconWidget(
                iconName: 'link',
                color: AppTheme.accent,
                size: 24),
              SizedBox(width: 3.w),
              Text(
                'Links',
                style: AppTheme.darkTheme.textTheme.titleMedium?.copyWith(
                  color: AppTheme.primaryText,
                  fontWeight: FontWeight.w600)),
              const Spacer(),
              IconButton(
                icon: CustomIconWidget(
                  iconName: 'add',
                  color: AppTheme.accent,
                  size: 24),
                onPressed: () => _addNewLink()),
            ]),
          SizedBox(height: 2.h),
          ..._linkComponents.asMap().entries.map((entry) {
            final index = entry.key;
            final component = entry.value;
            return _buildLinkItem(component, index);
          }),
        ]));
  }

  Widget _buildLinkItem(Map<String, dynamic> component, int index) {
    return Container(
      margin: EdgeInsets.only(bottom: 2.h),
      padding: EdgeInsets.all(3.w),
      decoration: BoxDecoration(
        color: AppTheme.surfaceVariant,
        borderRadius: BorderRadius.circular(AppTheme.radiusS),
        border: Border.all(
          color: AppTheme.border.withAlpha(26),
          width: 1)),
      child: Row(
        children: [
          CustomIconWidget(
            iconName: component['icon'] ?? 'link',
            color: AppTheme.accent,
            size: 20),
          SizedBox(width: 3.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  component['title'] ?? 'Link',
                  style: AppTheme.darkTheme.textTheme.bodyMedium?.copyWith(
                    color: AppTheme.primaryText,
                    fontWeight: FontWeight.w500)),
                Text(
                  component['url'] ?? '',
                  style: AppTheme.darkTheme.textTheme.bodySmall?.copyWith(
                    color: AppTheme.secondaryText),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis),
              ])),
          Switch(
            value: component['enabled'] ?? false,
            onChanged: (value) {
              setState(() {
                _linkComponents[index]['enabled'] = value;
              });
            },
            activeColor: AppTheme.accent),
          IconButton(
            icon: CustomIconWidget(
              iconName: 'edit',
              color: AppTheme.secondaryText,
              size: 20),
            onPressed: () => _editLink(index)),
        ]));
  }

  Widget _buildTemplatesSection() {
    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.circular(AppTheme.radiusM),
        border: Border.all(
          color: AppTheme.border.withAlpha(26),
          width: 1)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CustomIconWidget(
                iconName: 'design_services',
                color: AppTheme.accent,
                size: 24),
              SizedBox(width: 3.w),
              Text(
                'Templates',
                style: AppTheme.darkTheme.textTheme.titleMedium?.copyWith(
                  color: AppTheme.primaryText,
                  fontWeight: FontWeight.w600)),
              const Spacer(),
              TextButton(
                onPressed: () {
                  setState(() {
                    _showTemplateModal = true;
                  });
                },
                child: Text(
                  'Browse All',
                  style: AppTheme.darkTheme.textTheme.bodyMedium?.copyWith(
                    color: AppTheme.accent,
                    fontWeight: FontWeight.w500))),
            ]),
          SizedBox(height: 2.h),
          Text(
            'Current: $_selectedTemplate',
            style: AppTheme.darkTheme.textTheme.bodyMedium?.copyWith(
              color: AppTheme.secondaryText)),
        ]));
  }

  Widget _buildBottomActionBar() {
    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: AppTheme.surface,
        border: Border(
          top: BorderSide(
            color: AppTheme.border.withAlpha(26),
            width: 1))),
      child: Row(
        children: [
          Expanded(
            child: ElevatedButton(
              onPressed: () => _publishPage(),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.accent,
                foregroundColor: AppTheme.primaryAction,
                padding: EdgeInsets.symmetric(vertical: 2.h),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppTheme.radiusM))),
              child: Text(
                'Publish',
                style: AppTheme.darkTheme.textTheme.labelLarge?.copyWith(
                  color: AppTheme.primaryAction,
                  fontWeight: FontWeight.w600)))),
          SizedBox(width: 4.w),
          ElevatedButton(
            onPressed: () => _sharePreview(),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.surfaceVariant,
              foregroundColor: AppTheme.primaryText,
              padding: EdgeInsets.symmetric(
                horizontal: 4.w,
                vertical: 2.h),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppTheme.radiusM))),
            child: CustomIconWidget(
              iconName: 'share',
              color: AppTheme.primaryText,
              size: 20)),
        ]));
  }

  void _showOptionsMenu() {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppTheme.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(AppTheme.radiusXl),
          topRight: Radius.circular(AppTheme.radiusXl))),
      builder: (context) => Container(
        padding: EdgeInsets.all(4.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: CustomIconWidget(
                iconName: 'qr_code',
                color: AppTheme.accent,
                size: 24),
              title: Text(
                'Generate QR Code',
                style: AppTheme.darkTheme.textTheme.bodyMedium?.copyWith(
                  color: AppTheme.primaryText)),
              onTap: () {
                Navigator.pop(context);
                setState(() {
                  _showQRModal = true;
                });
              }),
            ListTile(
              leading: CustomIconWidget(
                iconName: 'domain',
                color: AppTheme.accent,
                size: 24),
              title: Text(
                'Custom Domain',
                style: AppTheme.darkTheme.textTheme.bodyMedium?.copyWith(
                  color: AppTheme.primaryText)),
              onTap: () {
                Navigator.pop(context);
                setState(() {
                  _showDomainModal = true;
                });
              }),
            ListTile(
              leading: CustomIconWidget(
                iconName: 'analytics',
                color: AppTheme.accent,
                size: 24),
              title: Text(
                'View Analytics',
                style: AppTheme.darkTheme.textTheme.bodyMedium?.copyWith(
                  color: AppTheme.primaryText)),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, '/link-in-bio-analytics-screen');
              }),
            SizedBox(height: 2.h),
          ])));
  }

  void _selectProfileImage() {
    // Implementation for image selection
    setState(() {
      _profileImage = 'https://images.unsplash.com/photo-1472099645785-5658abf4ff4e?q=80&w=1000&auto=format&fit=crop';
    });
  }

  void _showColorPicker(bool isPrimary) {
    // Implementation for color picker
    final colors = [
      AppTheme.accent,
      AppTheme.success,
      AppTheme.warning,
      AppTheme.error,
      Colors.purple,
      Colors.pink,
      Colors.orange,
      Colors.teal,
    ];

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppTheme.surface,
        title: Text(
          'Select Color',
          style: AppTheme.darkTheme.textTheme.titleMedium?.copyWith(
            color: AppTheme.primaryText)),
        content: Wrap(
          spacing: 2.w,
          runSpacing: 2.w,
          children: colors.map((color) {
            return GestureDetector(
              onTap: () {
                setState(() {
                  if (isPrimary) {
                    _primaryColor = color;
                  } else {
                    _backgroundColor = color;
                  }
                });
                Navigator.pop(context);
              },
              child: Container(
                width: 12.w,
                height: 6.h,
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: BorderRadius.circular(AppTheme.radiusS),
                  border: Border.all(
                    color: AppTheme.border,
                    width: 1))));
          }).toList())));
  }

  void _addNewLink() {
    setState(() {
      _linkComponents.add({
        'type': 'link',
        'title': 'New Link',
        'url': 'https://example.com',
        'icon': 'link',
        'enabled': true,
      });
    });
  }

  void _editLink(int index) {
    setState(() {
      _selectedComponent = index.toString();
    });
    // Show component editor bottom sheet
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => ComponentEditorBottomSheet(
        component: _linkComponents[index],
        onUpdate: (updatedComponent) {
          setState(() {
            _linkComponents[index] = updatedComponent;
          });
        }));
  }

  void _publishPage() {
    // Implementation for publishing
    Fluttertoast.showToast(
      msg: 'Page published successfully!',
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: AppTheme.success,
      textColor: AppTheme.primaryAction);
  }

  void _sharePreview() {
    // Implementation for sharing preview
    Fluttertoast.showToast(
      msg: 'Preview link copied to clipboard!',
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: AppTheme.accent,
      textColor: AppTheme.primaryAction);
  }
}