import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../theme/app_theme.dart';

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

class _ComponentEditorBottomSheetState
    extends State<ComponentEditorBottomSheet> {
  late Map<String, dynamic> _editedComponent;
  late TextEditingController _titleController;
  late TextEditingController _urlController;
  late TextEditingController _contentController;

  @override
  void initState() {
    super.initState();
    _editedComponent = Map<String, dynamic>.from(widget.component);
    _titleController = TextEditingController(
      text: _editedComponent['defaultProps']['title'] ??
          _editedComponent['defaultProps']['name'] ??
          _editedComponent['defaultProps']['content'] ??
          '',
    );
    _urlController = TextEditingController(
      text: _editedComponent['defaultProps']['url'] ?? '',
    );
    _contentController = TextEditingController(
      text: _editedComponent['defaultProps']['content'] ?? '',
    );
  }

  @override
  void dispose() {
    _titleController.dispose();
    _urlController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  void _updateComponent() {
    widget.onUpdate(_editedComponent);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 80.h,
      decoration: BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        children: [
          // Handle bar
          Container(
            width: 12.w,
            height: 0.5.h,
            margin: EdgeInsets.only(top: 2.h),
            decoration: BoxDecoration(
              color: AppTheme.border,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          SizedBox(height: 2.h),
          // Header
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 4.w),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Edit ${_getComponentTypeName()}',
                  style: AppTheme.darkTheme.textTheme.titleLarge?.copyWith(
                    color: AppTheme.primaryText,
                  ),
                ),
                Row(
                  children: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: Text(
                        'Cancel',
                        style: TextStyle(color: AppTheme.secondaryText),
                      ),
                    ),
                    SizedBox(width: 2.w),
                    ElevatedButton(
                      onPressed: _updateComponent,
                      child: const Text('Save'),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Divider(color: AppTheme.border),
          // Content
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(4.w),
              child: _buildEditor(),
            ),
          ),
        ],
      ),
    );
  }

  String _getComponentTypeName() {
    switch (_editedComponent['type']) {
      case 'profile':
        return 'Profile Header';
      case 'button':
        return 'Button';
      case 'social':
        return 'Social Links';
      case 'text':
        return 'Text Block';
      case 'gallery':
        return 'Image Gallery';
      case 'video':
        return 'Video';
      case 'form':
        return 'Contact Form';
      case 'newsletter':
        return 'Newsletter';
      case 'product':
        return 'Product Showcase';
      case 'booking':
        return 'Calendar Booking';
      case 'testimonials':
        return 'Testimonials';
      case 'music':
        return 'Music Player';
      default:
        return 'Component';
    }
  }

  Widget _buildEditor() {
    switch (_editedComponent['type']) {
      case 'profile':
        return _buildProfileEditor();
      case 'button':
        return _buildButtonEditor();
      case 'social':
        return _buildSocialEditor();
      case 'text':
        return _buildTextEditor();
      case 'gallery':
        return _buildGalleryEditor();
      case 'video':
        return _buildVideoEditor();
      case 'form':
        return _buildFormEditor();
      case 'newsletter':
        return _buildNewsletterEditor();
      case 'product':
        return _buildProductEditor();
      case 'booking':
        return _buildBookingEditor();
      case 'testimonials':
        return _buildTestimonialsEditor();
      case 'music':
        return _buildMusicEditor();
      default:
        return _buildGenericEditor();
    }
  }

  Widget _buildProfileEditor() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildTextField('Name', _titleController, (value) {
          setState(() {
            _editedComponent['defaultProps']['name'] = value;
          });
        }),
        SizedBox(height: 2.h),
        _buildTextField('Bio', _contentController, (value) {
          setState(() {
            _editedComponent['defaultProps']['bio'] = value;
          });
        }),
        SizedBox(height: 2.h),
        _buildTextField('Profile Image URL', _urlController, (value) {
          setState(() {
            _editedComponent['defaultProps']['profileImage'] = value;
          });
        }),
        SizedBox(height: 2.h),
        _buildSwitchTile(
          'Show Verified Badge',
          _editedComponent['defaultProps']['showVerifiedBadge'] ?? false,
          (value) {
            setState(() {
              _editedComponent['defaultProps']['showVerifiedBadge'] = value;
            });
          },
        ),
      ],
    );
  }

  Widget _buildButtonEditor() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildTextField('Button Text', _titleController, (value) {
          setState(() {
            _editedComponent['defaultProps']['title'] = value;
          });
        }),
        SizedBox(height: 2.h),
        _buildTextField('URL', _urlController, (value) {
          setState(() {
            _editedComponent['defaultProps']['url'] = value;
          });
        }),
        SizedBox(height: 2.h),
        _buildColorPicker(
          'Background Color',
          _editedComponent['defaultProps']['backgroundColor'],
          (color) {
            setState(() {
              _editedComponent['defaultProps']['backgroundColor'] = color;
            });
          },
        ),
        SizedBox(height: 2.h),
        _buildColorPicker(
          'Text Color',
          _editedComponent['defaultProps']['textColor'],
          (color) {
            setState(() {
              _editedComponent['defaultProps']['textColor'] = color;
            });
          },
        ),
        SizedBox(height: 2.h),
        _buildSlider(
          'Border Radius',
          _editedComponent['defaultProps']['borderRadius'],
          0,
          30,
          (value) {
            setState(() {
              _editedComponent['defaultProps']['borderRadius'] = value;
            });
          },
        ),
        SizedBox(height: 2.h),
        _buildSwitchTile(
          'Show Icon',
          _editedComponent['defaultProps']['showIcon'] ?? true,
          (value) {
            setState(() {
              _editedComponent['defaultProps']['showIcon'] = value;
            });
          },
        ),
      ],
    );
  }

  Widget _buildSocialEditor() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Layout',
          style: AppTheme.darkTheme.textTheme.titleMedium?.copyWith(
            color: AppTheme.primaryText,
          ),
        ),
        SizedBox(height: 1.h),
        _buildDropdown(
          _editedComponent['defaultProps']['layout'],
          ['horizontal', 'vertical'],
          (value) {
            setState(() {
              _editedComponent['defaultProps']['layout'] = value;
            });
          },
        ),
        SizedBox(height: 2.h),
        _buildSwitchTile(
          'Show Labels',
          _editedComponent['defaultProps']['showLabels'] ?? true,
          (value) {
            setState(() {
              _editedComponent['defaultProps']['showLabels'] = value;
            });
          },
        ),
        SizedBox(height: 2.h),
        Text(
          'Social Platforms',
          style: AppTheme.darkTheme.textTheme.titleMedium?.copyWith(
            color: AppTheme.primaryText,
          ),
        ),
        SizedBox(height: 1.h),
        ..._buildSocialPlatformEditors(),
      ],
    );
  }

  Widget _buildTextEditor() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildTextField('Content', _contentController, (value) {
          setState(() {
            _editedComponent['defaultProps']['content'] = value;
          });
        }),
        SizedBox(height: 2.h),
        _buildSlider(
          'Font Size',
          _editedComponent['defaultProps']['fontSize'],
          12,
          32,
          (value) {
            setState(() {
              _editedComponent['defaultProps']['fontSize'] = value;
            });
          },
        ),
        SizedBox(height: 2.h),
        _buildDropdown(
          _editedComponent['defaultProps']['fontWeight'],
          ['normal', 'bold'],
          (value) {
            setState(() {
              _editedComponent['defaultProps']['fontWeight'] = value;
            });
          },
        ),
        SizedBox(height: 2.h),
        _buildDropdown(
          _editedComponent['defaultProps']['alignment'],
          ['left', 'center', 'right'],
          (value) {
            setState(() {
              _editedComponent['defaultProps']['alignment'] = value;
            });
          },
        ),
        SizedBox(height: 2.h),
        _buildColorPicker(
          'Text Color',
          _editedComponent['defaultProps']['color'],
          (color) {
            setState(() {
              _editedComponent['defaultProps']['color'] = color;
            });
          },
        ),
      ],
    );
  }

  Widget _buildGalleryEditor() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSlider(
          'Columns',
          _editedComponent['defaultProps']['columns'].toDouble(),
          1,
          4,
          (value) {
            setState(() {
              _editedComponent['defaultProps']['columns'] = value.toInt();
            });
          },
        ),
        SizedBox(height: 2.h),
        _buildSlider(
          'Spacing',
          _editedComponent['defaultProps']['spacing'],
          0,
          20,
          (value) {
            setState(() {
              _editedComponent['defaultProps']['spacing'] = value;
            });
          },
        ),
        SizedBox(height: 2.h),
        _buildSlider(
          'Border Radius',
          _editedComponent['defaultProps']['borderRadius'],
          0,
          20,
          (value) {
            setState(() {
              _editedComponent['defaultProps']['borderRadius'] = value;
            });
          },
        ),
      ],
    );
  }

  Widget _buildVideoEditor() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildTextField('Video URL', _urlController, (value) {
          setState(() {
            _editedComponent['defaultProps']['url'] = value;
          });
        }),
        SizedBox(height: 2.h),
        _buildTextField(
            'Thumbnail URL',
            TextEditingController(
              text: _editedComponent['defaultProps']['thumbnail'] ?? '',
            ), (value) {
          setState(() {
            _editedComponent['defaultProps']['thumbnail'] = value;
          });
        }),
        SizedBox(height: 2.h),
        _buildSwitchTile(
          'Autoplay',
          _editedComponent['defaultProps']['autoplay'] ?? false,
          (value) {
            setState(() {
              _editedComponent['defaultProps']['autoplay'] = value;
            });
          },
        ),
        SizedBox(height: 2.h),
        _buildSwitchTile(
          'Show Controls',
          _editedComponent['defaultProps']['showControls'] ?? true,
          (value) {
            setState(() {
              _editedComponent['defaultProps']['showControls'] = value;
            });
          },
        ),
      ],
    );
  }

  Widget _buildFormEditor() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildTextField('Form Title', _titleController, (value) {
          setState(() {
            _editedComponent['defaultProps']['title'] = value;
          });
        }),
        SizedBox(height: 2.h),
        _buildTextField(
            'Submit Button Text',
            TextEditingController(
              text: _editedComponent['defaultProps']['submitText'] ??
                  'Send Message',
            ), (value) {
          setState(() {
            _editedComponent['defaultProps']['submitText'] = value;
          });
        }),
        SizedBox(height: 2.h),
        _buildTextField(
            'Success Message',
            TextEditingController(
              text: _editedComponent['defaultProps']['successMessage'] ??
                  'Thank you!',
            ), (value) {
          setState(() {
            _editedComponent['defaultProps']['successMessage'] = value;
          });
        }),
        SizedBox(height: 2.h),
        _buildColorPicker(
          'Background Color',
          _editedComponent['defaultProps']['backgroundColor'],
          (color) {
            setState(() {
              _editedComponent['defaultProps']['backgroundColor'] = color;
            });
          },
        ),
      ],
    );
  }

  Widget _buildNewsletterEditor() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildTextField('Title', _titleController, (value) {
          setState(() {
            _editedComponent['defaultProps']['title'] = value;
          });
        }),
        SizedBox(height: 2.h),
        _buildTextField(
            'Description',
            TextEditingController(
              text: _editedComponent['defaultProps']['description'] ?? '',
            ), (value) {
          setState(() {
            _editedComponent['defaultProps']['description'] = value;
          });
        }),
        SizedBox(height: 2.h),
        _buildTextField(
            'Button Text',
            TextEditingController(
              text:
                  _editedComponent['defaultProps']['buttonText'] ?? 'Subscribe',
            ), (value) {
          setState(() {
            _editedComponent['defaultProps']['buttonText'] = value;
          });
        }),
        SizedBox(height: 2.h),
        _buildTextField(
            'Placeholder',
            TextEditingController(
              text: _editedComponent['defaultProps']['placeholder'] ??
                  'Enter your email',
            ), (value) {
          setState(() {
            _editedComponent['defaultProps']['placeholder'] = value;
          });
        }),
      ],
    );
  }

  Widget _buildProductEditor() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildDropdown(
          _editedComponent['defaultProps']['layout'],
          ['grid', 'list'],
          (value) {
            setState(() {
              _editedComponent['defaultProps']['layout'] = value;
            });
          },
        ),
        SizedBox(height: 2.h),
        _buildSwitchTile(
          'Show Prices',
          _editedComponent['defaultProps']['showPrices'] ?? true,
          (value) {
            setState(() {
              _editedComponent['defaultProps']['showPrices'] = value;
            });
          },
        ),
        SizedBox(height: 2.h),
        _buildSwitchTile(
          'Show Descriptions',
          _editedComponent['defaultProps']['showDescriptions'] ?? true,
          (value) {
            setState(() {
              _editedComponent['defaultProps']['showDescriptions'] = value;
            });
          },
        ),
      ],
    );
  }

  Widget _buildBookingEditor() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildTextField('Title', _titleController, (value) {
          setState(() {
            _editedComponent['defaultProps']['title'] = value;
          });
        }),
        SizedBox(height: 2.h),
        _buildTextField(
            'Description',
            TextEditingController(
              text: _editedComponent['defaultProps']['description'] ?? '',
            ), (value) {
          setState(() {
            _editedComponent['defaultProps']['description'] = value;
          });
        }),
        SizedBox(height: 2.h),
        _buildTextField('Calendar URL', _urlController, (value) {
          setState(() {
            _editedComponent['defaultProps']['calendarUrl'] = value;
          });
        }),
        SizedBox(height: 2.h),
        _buildTextField(
            'Button Text',
            TextEditingController(
              text:
                  _editedComponent['defaultProps']['buttonText'] ?? 'Book Now',
            ), (value) {
          setState(() {
            _editedComponent['defaultProps']['buttonText'] = value;
          });
        }),
      ],
    );
  }

  Widget _buildTestimonialsEditor() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildDropdown(
          _editedComponent['defaultProps']['layout'],
          ['carousel', 'grid'],
          (value) {
            setState(() {
              _editedComponent['defaultProps']['layout'] = value;
            });
          },
        ),
        SizedBox(height: 2.h),
        _buildSwitchTile(
          'Show Avatars',
          _editedComponent['defaultProps']['showAvatars'] ?? true,
          (value) {
            setState(() {
              _editedComponent['defaultProps']['showAvatars'] = value;
            });
          },
        ),
        SizedBox(height: 2.h),
        _buildSwitchTile(
          'Auto Play',
          _editedComponent['defaultProps']['autoPlay'] ?? true,
          (value) {
            setState(() {
              _editedComponent['defaultProps']['autoPlay'] = value;
            });
          },
        ),
      ],
    );
  }

  Widget _buildMusicEditor() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSwitchTile(
          'Show Playlist',
          _editedComponent['defaultProps']['showPlaylist'] ?? true,
          (value) {
            setState(() {
              _editedComponent['defaultProps']['showPlaylist'] = value;
            });
          },
        ),
        SizedBox(height: 2.h),
        _buildSwitchTile(
          'Auto Play',
          _editedComponent['defaultProps']['autoPlay'] ?? false,
          (value) {
            setState(() {
              _editedComponent['defaultProps']['autoPlay'] = value;
            });
          },
        ),
        SizedBox(height: 2.h),
        _buildColorPicker(
          'Background Color',
          _editedComponent['defaultProps']['backgroundColor'],
          (color) {
            setState(() {
              _editedComponent['defaultProps']['backgroundColor'] = color;
            });
          },
        ),
      ],
    );
  }

  Widget _buildGenericEditor() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Component Type: ${_editedComponent['type']}',
          style: AppTheme.darkTheme.textTheme.bodyMedium?.copyWith(
            color: AppTheme.secondaryText,
          ),
        ),
        SizedBox(height: 2.h),
        Text(
          'This component type doesn\'t have specific editing options yet.',
          style: AppTheme.darkTheme.textTheme.bodyMedium?.copyWith(
            color: AppTheme.secondaryText,
          ),
        ),
      ],
    );
  }

  Widget _buildTextField(String label, TextEditingController controller,
      Function(String) onChanged) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTheme.darkTheme.textTheme.titleSmall?.copyWith(
            color: AppTheme.primaryText,
          ),
        ),
        SizedBox(height: 1.h),
        TextFormField(
          controller: controller,
          onChanged: onChanged,
          style: AppTheme.darkTheme.textTheme.bodyMedium,
          decoration: InputDecoration(
            hintText: 'Enter $label',
            filled: true,
            fillColor: AppTheme.primaryBackground,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: AppTheme.border),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildColorPicker(
      String label, String currentColor, Function(String) onChanged) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTheme.darkTheme.textTheme.titleSmall?.copyWith(
            color: AppTheme.primaryText,
          ),
        ),
        SizedBox(height: 1.h),
        Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: Color(int.parse(currentColor.replaceFirst('#', '0xFF'))),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: AppTheme.border),
              ),
            ),
            SizedBox(width: 3.w),
            Expanded(
              child: TextFormField(
                initialValue: currentColor,
                onChanged: onChanged,
                decoration: InputDecoration(
                  hintText: '#000000',
                  filled: true,
                  fillColor: AppTheme.primaryBackground,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(color: AppTheme.border),
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildSlider(String label, double value, double min, double max,
      Function(double) onChanged) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: AppTheme.darkTheme.textTheme.titleSmall?.copyWith(
                color: AppTheme.primaryText,
              ),
            ),
            Text(
              value.toStringAsFixed(0),
              style: AppTheme.darkTheme.textTheme.bodyMedium?.copyWith(
                color: AppTheme.secondaryText,
              ),
            ),
          ],
        ),
        SizedBox(height: 1.h),
        Slider(
          value: value,
          min: min,
          max: max,
          onChanged: onChanged,
          activeColor: AppTheme.accent,
          inactiveColor: AppTheme.border,
        ),
      ],
    );
  }

  Widget _buildDropdown(
      String currentValue, List<String> options, Function(String) onChanged) {
    return DropdownButtonFormField<String>(
      value: currentValue,
      onChanged: (value) => onChanged(value!),
      items: options.map((option) {
        return DropdownMenuItem(
          value: option,
          child: Text(
            option,
            style: AppTheme.darkTheme.textTheme.bodyMedium,
          ),
        );
      }).toList(),
      decoration: InputDecoration(
        filled: true,
        fillColor: AppTheme.primaryBackground,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: AppTheme.border),
        ),
      ),
      dropdownColor: AppTheme.surface,
    );
  }

  Widget _buildSwitchTile(String title, bool value, Function(bool) onChanged) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: AppTheme.darkTheme.textTheme.titleSmall?.copyWith(
            color: AppTheme.primaryText,
          ),
        ),
        Switch(
          value: value,
          onChanged: onChanged,
          activeColor: AppTheme.accent,
        ),
      ],
    );
  }

  List<Widget> _buildSocialPlatformEditors() {
    final platforms = _editedComponent['defaultProps']['platforms'] as List;
    return platforms.map<Widget>((platform) {
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
              platform['name'],
              style: AppTheme.darkTheme.textTheme.titleSmall?.copyWith(
                color: AppTheme.primaryText,
              ),
            ),
            SizedBox(height: 1.h),
            TextFormField(
              initialValue: platform['url'],
              onChanged: (value) {
                setState(() {
                  platform['url'] = value;
                });
              },
              decoration: InputDecoration(
                hintText: 'Enter ${platform['name']} URL',
                filled: true,
                fillColor: AppTheme.surface,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: AppTheme.border),
                ),
              ),
            ),
          ],
        ),
      );
    }).toList();
  }
}
