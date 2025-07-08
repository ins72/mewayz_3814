import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/builder_panel_widget.dart';
import './widgets/component_editor_bottom_sheet.dart';
import './widgets/custom_domain_modal.dart';
import './widgets/mobile_preview_widget.dart';
import './widgets/qr_code_modal.dart';
import './widgets/template_selection_modal.dart';

class LinkInBioBuilder extends StatefulWidget {
  const LinkInBioBuilder({Key? key}) : super(key: key);

  @override
  State<LinkInBioBuilder> createState() => _LinkInBioBuilderState();
}

class _LinkInBioBuilderState extends State<LinkInBioBuilder>
    with TickerProviderStateMixin {
  bool _isPreviewMode = false;
  bool _isAutoSaving = false;
  String _selectedComponentId = '';
  List<Map<String, dynamic>> _pageComponents = [];
  List<List<Map<String, dynamic>>> _undoStack = [];
  List<List<Map<String, dynamic>>> _redoStack = [];

  final List<Map<String, dynamic>> _componentLibrary = [
    {
      'id': 'text_block',
      'name': 'Text Block',
      'icon': 'text_fields',
      'type': 'text',
      'defaultProps': {
        'content': 'Your text here',
        'fontSize': 16.0,
        'fontWeight': 'normal',
        'color': '#F1F1F1',
        'alignment': 'center',
      }
    },
    {
      'id': 'button',
      'name': 'Button',
      'icon': 'smart_button',
      'type': 'button',
      'defaultProps': {
        'text': 'Click Me',
        'backgroundColor': '#3B82F6',
        'textColor': '#FFFFFF',
        'borderRadius': 12.0,
        'action': 'link',
        'url': '',
      }
    },
    {
      'id': 'image',
      'name': 'Image',
      'icon': 'image',
      'type': 'image',
      'defaultProps': {
        'url':
            'https://images.unsplash.com/photo-1557804506-669a67965ba0?w=400',
        'width': 100.0,
        'height': 100.0,
        'borderRadius': 8.0,
      }
    },
    {
      'id': 'video',
      'name': 'Video',
      'icon': 'play_circle',
      'type': 'video',
      'defaultProps': {
        'url':
            'https://sample-videos.com/zip/10/mp4/SampleVideo_1280x720_1mb.mp4',
        'thumbnail':
            'https://images.unsplash.com/photo-1574717024653-61fd2cf4d44d?w=400',
        'autoplay': false,
      }
    },
    {
      'id': 'product_showcase',
      'name': 'Product',
      'icon': 'shopping_bag',
      'type': 'product',
      'defaultProps': {
        'name': 'Product Name',
        'price': '\$99.99',
        'image':
            'https://images.unsplash.com/photo-1523275335684-37898b6baf30?w=400',
        'description': 'Product description',
        'buyLink': '',
      }
    },
    {
      'id': 'contact_form',
      'name': 'Contact Form',
      'icon': 'contact_mail',
      'type': 'form',
      'defaultProps': {
        'title': 'Get in Touch',
        'fields': ['name', 'email', 'message'],
        'submitText': 'Send Message',
      }
    },
    {
      'id': 'social_links',
      'name': 'Social Links',
      'icon': 'share',
      'type': 'social',
      'defaultProps': {
        'platforms': [
          {'name': 'Instagram', 'url': '', 'icon': 'camera_alt'},
          {'name': 'Twitter', 'url': '', 'icon': 'alternate_email'},
          {'name': 'LinkedIn', 'url': '', 'icon': 'business'},
        ]
      }
    },
  ];

  @override
  void initState() {
    super.initState();
    _startAutoSave();
  }

  void _startAutoSave() {
    Future.delayed(const Duration(seconds: 30), () {
      if (mounted) {
        _autoSave();
        _startAutoSave();
      }
    });
  }

  void _autoSave() {
    setState(() {
      _isAutoSaving = true;
    });

    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        setState(() {
          _isAutoSaving = false;
        });
      }
    });
  }

  void _addComponent(Map<String, dynamic> component) {
    setState(() {
      _undoStack.add(List<Map<String, dynamic>>.from(_pageComponents));
      _redoStack.clear();

      final newComponent = Map<String, dynamic>.from(component);
      newComponent['id'] = DateTime.now().millisecondsSinceEpoch.toString();
      _pageComponents.add(newComponent);
    });
  }

  void _removeComponent(String componentId) {
    setState(() {
      _undoStack.add(List<Map<String, dynamic>>.from(_pageComponents));
      _redoStack.clear();
      _pageComponents.removeWhere((comp) => comp['id'] == componentId);
      if (_selectedComponentId == componentId) {
        _selectedComponentId = '';
      }
    });
  }

  void _duplicateComponent(String componentId) {
    final component =
        _pageComponents.firstWhere((comp) => comp['id'] == componentId);
    final duplicated = Map<String, dynamic>.from(component);
    duplicated['id'] = DateTime.now().millisecondsSinceEpoch.toString();

    setState(() {
      _undoStack.add(List<Map<String, dynamic>>.from(_pageComponents));
      _redoStack.clear();
      final index =
          _pageComponents.indexWhere((comp) => comp['id'] == componentId);
      _pageComponents.insert(index + 1, duplicated);
    });
  }

  void _moveComponent(String componentId, bool moveUp) {
    final index =
        _pageComponents.indexWhere((comp) => comp['id'] == componentId);
    if ((moveUp && index > 0) ||
        (!moveUp && index < _pageComponents.length - 1)) {
      setState(() {
        _undoStack.add(List<Map<String, dynamic>>.from(_pageComponents));
        _redoStack.clear();
        final component = _pageComponents.removeAt(index);
        _pageComponents.insert(moveUp ? index - 1 : index + 1, component);
      });
    }
  }

  void _undo() {
    if (_undoStack.isNotEmpty) {
      setState(() {
        _redoStack.add(List<Map<String, dynamic>>.from(_pageComponents));
        _pageComponents = _undoStack.removeLast();
      });
    }
  }

  void _redo() {
    if (_redoStack.isNotEmpty) {
      setState(() {
        _undoStack.add(List<Map<String, dynamic>>.from(_pageComponents));
        _pageComponents = _redoStack.removeLast();
      });
    }
  }

  void _showTemplateSelection() {
    showDialog(
      context: context,
      builder: (context) => TemplateSelectionModal(
        onTemplateSelected: (template) {
          _showConfirmationDialog(
            'Apply Template',
            'This will replace your current design. Continue?',
            () {
              setState(() {
                _undoStack
                    .add(List<Map<String, dynamic>>.from(_pageComponents));
                _redoStack.clear();
                _pageComponents = List.from(template['components']);
              });
            },
          );
        },
      ),
    );
  }

  void _showCustomDomainSetup() {
    showDialog(
      context: context,
      builder: (context) => const CustomDomainModal(),
    );
  }

  void _showQRCodeGenerator() {
    showDialog(
      context: context,
      builder: (context) => const QRCodeModal(),
    );
  }

  void _showComponentEditor(String componentId) {
    final component =
        _pageComponents.firstWhere((comp) => comp['id'] == componentId);
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => ComponentEditorBottomSheet(
        component: component,
        onUpdate: (updatedComponent) {
          setState(() {
            _undoStack.add(List<Map<String, dynamic>>.from(_pageComponents));
            _redoStack.clear();
            final index =
                _pageComponents.indexWhere((comp) => comp['id'] == componentId);
            _pageComponents[index] = updatedComponent;
          });
        },
      ),
    );
  }

  void _showConfirmationDialog(
      String title, String message, VoidCallback onConfirm) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppTheme.surface,
        title: Text(
          title,
          style: AppTheme.darkTheme.textTheme.titleLarge,
        ),
        content: Text(
          message,
          style: AppTheme.darkTheme.textTheme.bodyMedium,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Cancel',
              style: TextStyle(color: AppTheme.secondaryText),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              onConfirm();
            },
            child: const Text('Confirm'),
          ),
        ],
      ),
    );
  }

  void _publishPage() {
    _showConfirmationDialog(
      'Publish Page',
      'Your Link in Bio page will be live and accessible to visitors.',
      () {
        // Simulate publish process
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Page published successfully!'),
            backgroundColor: AppTheme.success,
            action: SnackBarAction(
              label: 'View Analytics',
              textColor: AppTheme.primaryAction,
              onPressed: () {
                Navigator.pushNamed(context, '/analytics-dashboard');
              },
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.primaryBackground,
      appBar: AppBar(
        backgroundColor: AppTheme.primaryBackground,
        elevation: 0,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: CustomIconWidget(
            iconName: 'arrow_back',
            color: AppTheme.primaryText,
            size: 24,
          ),
        ),
        title: Row(
          children: [
            Text(
              'Link in Bio Builder',
              style: AppTheme.darkTheme.textTheme.titleLarge,
            ),
            SizedBox(width: 2.w),
            _isAutoSaving
                ? SizedBox(
                    width: 4.w,
                    height: 4.w,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor:
                          AlwaysStoppedAnimation<Color>(AppTheme.accent),
                    ),
                  )
                : CustomIconWidget(
                    iconName: 'check_circle',
                    color: AppTheme.success,
                    size: 20,
                  ),
          ],
        ),
        actions: [
          IconButton(
            onPressed: _showCustomDomainSetup,
            icon: CustomIconWidget(
              iconName: 'settings',
              color: AppTheme.primaryText,
              size: 24,
            ),
          ),
          Switch(
            value: _isPreviewMode,
            onChanged: (value) {
              setState(() {
                _isPreviewMode = value;
              });
            },
            activeColor: AppTheme.accent,
          ),
          SizedBox(width: 2.w),
          ElevatedButton(
            onPressed: _publishPage,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.accent,
              foregroundColor: AppTheme.primaryAction,
              padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
            ),
            child: const Text('Publish'),
          ),
          SizedBox(width: 4.w),
        ],
      ),
      body: _isPreviewMode
          ? MobilePreviewWidget(
              components: _pageComponents,
              selectedComponentId: _selectedComponentId,
              onComponentTap: (componentId) {
                setState(() {
                  _selectedComponentId = componentId;
                });
              },
              onComponentLongPress: _showComponentContextMenu,
            )
          : Row(
              children: [
                Expanded(
                  flex: 1,
                  child: BuilderPanelWidget(
                    componentLibrary: _componentLibrary,
                    onComponentDrag: _addComponent,
                  ),
                ),
                Container(
                  width: 1,
                  color: AppTheme.border,
                ),
                Expanded(
                  flex: 1,
                  child: MobilePreviewWidget(
                    components: _pageComponents,
                    selectedComponentId: _selectedComponentId,
                    onComponentTap: (componentId) {
                      setState(() {
                        _selectedComponentId = componentId;
                      });
                    },
                    onComponentLongPress: _showComponentContextMenu,
                  ),
                ),
              ],
            ),
      bottomNavigationBar: Container(
        height: 8.h,
        decoration: BoxDecoration(
          color: AppTheme.surface,
          border: Border(
            top: BorderSide(color: AppTheme.border, width: 1),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            IconButton(
              onPressed: _undoStack.isNotEmpty ? _undo : null,
              icon: CustomIconWidget(
                iconName: 'undo',
                color: _undoStack.isNotEmpty
                    ? AppTheme.primaryText
                    : AppTheme.secondaryText,
                size: 24,
              ),
            ),
            IconButton(
              onPressed: _redoStack.isNotEmpty ? _redo : null,
              icon: CustomIconWidget(
                iconName: 'redo',
                color: _redoStack.isNotEmpty
                    ? AppTheme.primaryText
                    : AppTheme.secondaryText,
                size: 24,
              ),
            ),
            IconButton(
              onPressed: _showTemplateSelection,
              icon: CustomIconWidget(
                iconName: 'dashboard',
                color: AppTheme.primaryText,
                size: 24,
              ),
            ),
            IconButton(
              onPressed: _showQRCodeGenerator,
              icon: CustomIconWidget(
                iconName: 'qr_code',
                color: AppTheme.primaryText,
                size: 24,
              ),
            ),
            if (_selectedComponentId.isNotEmpty)
              IconButton(
                onPressed: () => _showComponentEditor(_selectedComponentId),
                icon: CustomIconWidget(
                  iconName: 'edit',
                  color: AppTheme.accent,
                  size: 24,
                ),
              ),
          ],
        ),
      ),
    );
  }

  void _showComponentContextMenu(String componentId) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppTheme.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: EdgeInsets.all(4.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
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
            ListTile(
              leading: CustomIconWidget(
                iconName: 'edit',
                color: AppTheme.primaryText,
                size: 24,
              ),
              title: Text(
                'Edit Component',
                style: AppTheme.darkTheme.textTheme.bodyLarge,
              ),
              onTap: () {
                Navigator.pop(context);
                _showComponentEditor(componentId);
              },
            ),
            ListTile(
              leading: CustomIconWidget(
                iconName: 'content_copy',
                color: AppTheme.primaryText,
                size: 24,
              ),
              title: Text(
                'Duplicate',
                style: AppTheme.darkTheme.textTheme.bodyLarge,
              ),
              onTap: () {
                Navigator.pop(context);
                _duplicateComponent(componentId);
              },
            ),
            ListTile(
              leading: CustomIconWidget(
                iconName: 'keyboard_arrow_up',
                color: AppTheme.primaryText,
                size: 24,
              ),
              title: Text(
                'Move Up',
                style: AppTheme.darkTheme.textTheme.bodyLarge,
              ),
              onTap: () {
                Navigator.pop(context);
                _moveComponent(componentId, true);
              },
            ),
            ListTile(
              leading: CustomIconWidget(
                iconName: 'keyboard_arrow_down',
                color: AppTheme.primaryText,
                size: 24,
              ),
              title: Text(
                'Move Down',
                style: AppTheme.darkTheme.textTheme.bodyLarge,
              ),
              onTap: () {
                Navigator.pop(context);
                _moveComponent(componentId, false);
              },
            ),
            ListTile(
              leading: CustomIconWidget(
                iconName: 'delete',
                color: AppTheme.error,
                size: 24,
              ),
              title: Text(
                'Delete',
                style: AppTheme.darkTheme.textTheme.bodyLarge?.copyWith(
                  color: AppTheme.error,
                ),
              ),
              onTap: () {
                Navigator.pop(context);
                _removeComponent(componentId);
              },
            ),
            SizedBox(height: 2.h),
          ],
        ),
      ),
    );
  }
}
