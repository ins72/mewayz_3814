import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
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

  // Template data for quick start
  final Map<String, dynamic> _pageSettings = {
    'title': 'My Link in Bio',
    'description': 'All my important links in one place',
    'backgroundColor': '#101010',
    'customDomain': '',
    'isPublished': false,
    'theme': 'dark',
    'favicon': '',
    'analyticsEnabled': true,
  };

  final List<Map<String, dynamic>> _componentLibrary = [
    {
      'id': 'profile_header',
      'name': 'Profile Header',
      'icon': 'account_circle',
      'type': 'profile',
      'category': 'Basic',
      'defaultProps': {
        'name': 'Your Name',
        'bio': 'Your bio here',
        'profileImage':
            'https://images.unsplash.com/photo-1472099645785-5658abf4ff4e?w=400',
        'showVerifiedBadge': false,
      }
    },
    {
      'id': 'link_button',
      'name': 'Link Button',
      'icon': 'link',
      'type': 'button',
      'category': 'Basic',
      'defaultProps': {
        'title': 'Visit My Website',
        'url': 'https://example.com',
        'backgroundColor': '#3B82F6',
        'textColor': '#FFFFFF',
        'borderRadius': 12.0,
        'icon': 'open_in_new',
        'showIcon': true,
      }
    },
    {
      'id': 'social_links',
      'name': 'Social Links',
      'icon': 'share',
      'type': 'social',
      'category': 'Social',
      'defaultProps': {
        'platforms': [
          {
            'name': 'Instagram',
            'url': '',
            'icon': 'camera_alt',
            'color': '#E4405F'
          },
          {
            'name': 'Twitter',
            'url': '',
            'icon': 'alternate_email',
            'color': '#1DA1F2'
          },
          {
            'name': 'LinkedIn',
            'url': '',
            'icon': 'business',
            'color': '#0A66C2'
          },
          {
            'name': 'YouTube',
            'url': '',
            'icon': 'play_circle_filled',
            'color': '#FF0000'
          },
        ],
        'layout': 'horizontal',
        'showLabels': true,
      }
    },
    {
      'id': 'text_block',
      'name': 'Text Block',
      'icon': 'text_fields',
      'type': 'text',
      'category': 'Basic',
      'defaultProps': {
        'content': 'Your text here',
        'fontSize': 16.0,
        'fontWeight': 'normal',
        'color': '#F1F1F1',
        'alignment': 'center',
        'backgroundColor': 'transparent',
        'padding': 16.0,
      }
    },
    {
      'id': 'image_gallery',
      'name': 'Image Gallery',
      'icon': 'photo_library',
      'type': 'gallery',
      'category': 'Media',
      'defaultProps': {
        'images': [
          'https://images.unsplash.com/photo-1557804506-669a67965ba0?w=400',
          'https://images.unsplash.com/photo-1542744173-8e7e53415bb0?w=400',
        ],
        'layout': 'grid',
        'columns': 2,
        'borderRadius': 8.0,
        'spacing': 8.0,
      }
    },
    {
      'id': 'video_embed',
      'name': 'Video Embed',
      'icon': 'play_circle_outline',
      'type': 'video',
      'category': 'Media',
      'defaultProps': {
        'url': 'https://www.youtube.com/watch?v=dQw4w9WgXcQ',
        'thumbnail':
            'https://images.unsplash.com/photo-1574717024653-61fd2cf4d44d?w=400',
        'autoplay': false,
        'showControls': true,
        'aspectRatio': '16:9',
      }
    },
    {
      'id': 'contact_form',
      'name': 'Contact Form',
      'icon': 'contact_mail',
      'type': 'form',
      'category': 'Interactive',
      'defaultProps': {
        'title': 'Get in Touch',
        'fields': [
          {'name': 'name', 'type': 'text', 'label': 'Name', 'required': true},
          {
            'name': 'email',
            'type': 'email',
            'label': 'Email',
            'required': true
          },
          {
            'name': 'message',
            'type': 'textarea',
            'label': 'Message',
            'required': true
          },
        ],
        'submitText': 'Send Message',
        'successMessage': 'Thank you for your message!',
        'backgroundColor': '#191919',
      }
    },
    {
      'id': 'newsletter_signup',
      'name': 'Newsletter Signup',
      'icon': 'mail_outline',
      'type': 'newsletter',
      'category': 'Interactive',
      'defaultProps': {
        'title': 'Subscribe to Newsletter',
        'description': 'Get updates directly to your inbox',
        'buttonText': 'Subscribe',
        'placeholder': 'Enter your email',
        'backgroundColor': '#191919',
        'successMessage': 'Successfully subscribed!',
      }
    },
    {
      'id': 'product_showcase',
      'name': 'Product Showcase',
      'icon': 'shopping_bag',
      'type': 'product',
      'category': 'Commerce',
      'defaultProps': {
        'products': [
          {
            'name': 'Product 1',
            'price': '\$29.99',
            'image':
                'https://images.unsplash.com/photo-1523275335684-37898b6baf30?w=400',
            'description': 'Amazing product description',
            'buyLink': 'https://example.com/buy',
          }
        ],
        'layout': 'grid',
        'showPrices': true,
        'showDescriptions': true,
      }
    },
    {
      'id': 'calendar_booking',
      'name': 'Calendar Booking',
      'icon': 'calendar_today',
      'type': 'booking',
      'category': 'Interactive',
      'defaultProps': {
        'title': 'Book a Meeting',
        'description': 'Schedule a time that works for you',
        'calendarUrl': 'https://calendly.com/your-calendar',
        'buttonText': 'Book Now',
        'backgroundColor': '#191919',
      }
    },
    {
      'id': 'testimonials',
      'name': 'Testimonials',
      'icon': 'format_quote',
      'type': 'testimonials',
      'category': 'Social Proof',
      'defaultProps': {
        'testimonials': [
          {
            'text': 'Amazing service! Highly recommend.',
            'author': 'John Doe',
            'position': 'CEO, Company',
            'avatar':
                'https://images.unsplash.com/photo-1472099645785-5658abf4ff4e?w=400',
          }
        ],
        'layout': 'carousel',
        'showAvatars': true,
        'autoPlay': true,
      }
    },
    {
      'id': 'music_player',
      'name': 'Music Player',
      'icon': 'library_music',
      'type': 'music',
      'category': 'Media',
      'defaultProps': {
        'tracks': [
          {
            'title': 'Track 1',
            'artist': 'Artist Name',
            'url': 'https://example.com/track1.mp3',
            'artwork':
                'https://images.unsplash.com/photo-1493225457124-a3eb161ffa5f?w=400',
          }
        ],
        'showPlaylist': true,
        'autoPlay': false,
        'backgroundColor': '#191919',
      }
    },
  ];

  final List<Map<String, dynamic>> _templates = [
    {
      'id': 'minimal',
      'name': 'Minimal',
      'thumbnail':
          'https://images.unsplash.com/photo-1618005182384-a83a8bd57fbe?w=400',
      'components': [
        {
          'id': '1',
          'type': 'profile',
          'defaultProps': {
            'name': 'Your Name',
            'bio': 'Creative professional',
            'profileImage':
                'https://images.unsplash.com/photo-1472099645785-5658abf4ff4e?w=400',
          }
        },
        {
          'id': '2',
          'type': 'button',
          'defaultProps': {
            'title': 'Visit Portfolio',
            'url': 'https://example.com',
            'backgroundColor': '#3B82F6',
          }
        },
        {
          'id': '3',
          'type': 'social',
          'defaultProps': {
            'platforms': [
              {'name': 'Instagram', 'url': '', 'icon': 'camera_alt'},
              {'name': 'Twitter', 'url': '', 'icon': 'alternate_email'},
            ]
          }
        },
      ]
    },
    {
      'id': 'business',
      'name': 'Business',
      'thumbnail':
          'https://images.unsplash.com/photo-1556761175-b413da4baf72?w=400',
      'components': [
        {
          'id': '1',
          'type': 'profile',
          'defaultProps': {
            'name': 'Business Name',
            'bio': 'Professional services',
            'showVerifiedBadge': true,
          }
        },
        {
          'id': '2',
          'type': 'button',
          'defaultProps': {
            'title': 'Our Services',
            'backgroundColor': '#10B981',
          }
        },
        {
          'id': '3',
          'type': 'booking',
          'defaultProps': {
            'title': 'Schedule Consultation',
          }
        },
        {
          'id': '4',
          'type': 'form',
          'defaultProps': {
            'title': 'Contact Us',
          }
        },
      ]
    },
    {
      'id': 'creator',
      'name': 'Content Creator',
      'thumbnail':
          'https://images.unsplash.com/photo-1611224923853-80b023f02d71?w=400',
      'components': [
        {
          'id': '1',
          'type': 'profile',
          'defaultProps': {
            'name': 'Creator Name',
            'bio': 'Content creator & influencer',
          }
        },
        {
          'id': '2',
          'type': 'video',
          'defaultProps': {
            'url': 'https://www.youtube.com/watch?v=dQw4w9WgXcQ',
          }
        },
        {
          'id': '3',
          'type': 'gallery',
          'defaultProps': {
            'layout': 'grid',
            'columns': 3,
          }
        },
        {
          'id': '4',
          'type': 'social',
          'defaultProps': {
            'platforms': [
              {'name': 'Instagram', 'url': ''},
              {'name': 'YouTube', 'url': ''},
              {'name': 'TikTok', 'url': ''},
            ]
          }
        },
        {
          'id': '5',
          'type': 'newsletter',
          'defaultProps': {
            'title': 'Subscribe for Updates',
          }
        },
      ]
    },
  ];

  @override
  void initState() {
    super.initState();
    _loadDefaultTemplate();
    _startAutoSave();
  }

  void _loadDefaultTemplate() {
    // Load a basic template by default
    setState(() {
      _pageComponents = [
        {
          'id': DateTime.now().millisecondsSinceEpoch.toString(),
          'type': 'profile',
          'defaultProps': {
            'name': 'Your Name',
            'bio': 'Welcome to my Link in Bio',
            'profileImage':
                'https://images.unsplash.com/photo-1472099645785-5658abf4ff4e?w=400',
            'showVerifiedBadge': false,
          }
        },
        {
          'id': (DateTime.now().millisecondsSinceEpoch + 1).toString(),
          'type': 'button',
          'defaultProps': {
            'title': 'Visit My Website',
            'url': 'https://example.com',
            'backgroundColor': '#3B82F6',
            'textColor': '#FFFFFF',
            'borderRadius': 12.0,
            'icon': 'open_in_new',
            'showIcon': true,
          }
        },
      ];
    });
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
        templates: _templates,
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
                _selectedComponentId = '';
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
      builder: (context) => CustomDomainModal(
        currentDomain: _pageSettings['customDomain'],
        onDomainUpdate: (domain) {
          setState(() {
            _pageSettings['customDomain'] = domain;
          });
        },
      ),
    );
  }

  void _showQRCodeGenerator() {
    showDialog(
      context: context,
      builder: (context) => QRCodeModal(
        url: _pageSettings['customDomain'].isNotEmpty
            ? _pageSettings['customDomain']
            : 'https://your-bio-link.com',
        title: _pageSettings['title'],
      ),
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
        setState(() {
          _pageSettings['isPublished'] = true;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                CustomIconWidget(
                  iconName: 'check_circle',
                  color: AppTheme.success,
                  size: 20,
                ),
                SizedBox(width: 2.w),
                const Text('Page published successfully!'),
              ],
            ),
            backgroundColor: AppTheme.success,
            action: SnackBarAction(
              label: 'View Analytics',
              textColor: AppTheme.primaryAction,
              onPressed: () {
                Navigator.pushNamed(context, AppRoutes.analyticsDashboard);
              },
            ),
          ),
        );
      },
    );
  }

  Widget _buildComponentLibrary() {
    return Container(
      width: 80,
      color: AppTheme.surface,
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.all(2.w),
            decoration: BoxDecoration(
              color: AppTheme.primaryBackground,
              border: Border(
                bottom: BorderSide(color: AppTheme.border),
              ),
            ),
            child: Text(
              'Components',
              style: AppTheme.darkTheme.textTheme.titleSmall,
              textAlign: TextAlign.center,
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.symmetric(vertical: 1.h),
              itemCount: _componentLibrary.length,
              itemBuilder: (context, index) {
                final component = _componentLibrary[index];
                return GestureDetector(
                  onTap: () => _addComponent(component),
                  child: Container(
                    margin:
                        EdgeInsets.symmetric(horizontal: 2.w, vertical: 1.h),
                    padding: EdgeInsets.all(2.w),
                    decoration: BoxDecoration(
                      color: AppTheme.primaryBackground,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: AppTheme.border),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        CustomIconWidget(
                          iconName: component['icon'],
                          color: AppTheme.accent,
                          size: 24,
                        ),
                        SizedBox(height: 1.h),
                        Text(
                          component['name'],
                          style: AppTheme.darkTheme.textTheme.labelSmall,
                          textAlign: TextAlign.center,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
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
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Preview',
                style: AppTheme.darkTheme.textTheme.bodySmall,
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
            ],
          ),
          SizedBox(width: 2.w),
          ElevatedButton(
            onPressed: _publishPage,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.accent,
              foregroundColor: AppTheme.primaryAction,
              padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
            ),
            child: Text(_pageSettings['isPublished'] ? 'Update' : 'Publish'),
          ),
          SizedBox(width: 4.w),
        ],
      ),
      body: _isPreviewMode
          ? MobilePreviewWidget(
              components: _pageComponents,
              selectedComponentId: _selectedComponentId,
              pageSettings: _pageSettings,
              onComponentTap: (componentId) {
                setState(() {
                  _selectedComponentId = componentId;
                });
              },
              onComponentLongPress: _showComponentContextMenu,
            )
          : Row(
              children: [
                _buildComponentLibrary(),
                Container(
                  width: 1,
                  color: AppTheme.border,
                ),
                Expanded(
                  child: MobilePreviewWidget(
                    components: _pageComponents,
                    selectedComponentId: _selectedComponentId,
                    pageSettings: _pageSettings,
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
