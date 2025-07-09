import 'package:flutter/material.dart';

import '../../../core/app_export.dart';
import '../../../theme/app_theme.dart';

class TemplatePreviewModalWidget extends StatefulWidget {
  final String templateId;
  final Function(String) onUseTemplate;
  final Function(String) onCustomize;

  const TemplatePreviewModalWidget({
    Key? key,
    required this.templateId,
    required this.onUseTemplate,
    required this.onCustomize,
  }) : super(key: key);

  @override
  State<TemplatePreviewModalWidget> createState() => _TemplatePreviewModalWidgetState();
}

class _TemplatePreviewModalWidgetState extends State<TemplatePreviewModalWidget> {
  bool _isFullscreen = false;
  int _selectedDevice = 0; // 0: mobile, 1: tablet, 2: desktop

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.9,
      decoration: BoxDecoration(
        color: AppTheme.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        children: [
          // Header
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: AppTheme.border,
                  width: 1,
                ),
              ),
            ),
            child: Row(
              children: [
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Icon(
                    Icons.close,
                    color: AppTheme.secondaryText,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Template Preview',
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: AppTheme.primaryText,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        'Creative Portfolio Template',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AppTheme.secondaryText,
                        ),
                      ),
                    ],
                  ),
                ),
                
                // Device selector
                Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: AppTheme.primaryBackground,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      _buildDeviceButton(Icons.phone_android, 0),
                      _buildDeviceButton(Icons.tablet_mac, 1),
                      _buildDeviceButton(Icons.desktop_mac, 2),
                    ],
                  ),
                ),
                
                const SizedBox(width: 12),
                
                // Fullscreen toggle
                GestureDetector(
                  onTap: () => setState(() => _isFullscreen = !_isFullscreen),
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: AppTheme.primaryBackground,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      _isFullscreen ? Icons.fullscreen_exit : Icons.fullscreen,
                      color: AppTheme.primaryText,
                      size: 20,
                    ),
                  ),
                ),
              ],
            ),
          ),
          
          // Preview area
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(16),
              child: Center(
                child: _buildPreviewFrame(),
              ),
            ),
          ),
          
          // Action buttons
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              border: Border(
                top: BorderSide(
                  color: AppTheme.border,
                  width: 1,
                ),
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () => widget.onCustomize(widget.templateId),
                    icon: const Icon(Icons.palette),
                    label: const Text('Customize'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.surface,
                      foregroundColor: AppTheme.primaryText,
                      side: BorderSide(color: AppTheme.border),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () => widget.onUseTemplate(widget.templateId),
                    icon: const Icon(Icons.download),
                    label: const Text('Use Template'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.primaryAction,
                      foregroundColor: AppTheme.primaryBackground,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDeviceButton(IconData icon, int index) {
    final isSelected = _selectedDevice == index;
    
    return GestureDetector(
      onTap: () => setState(() => _selectedDevice = index),
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: isSelected ? AppTheme.accent : Colors.transparent,
          borderRadius: BorderRadius.circular(6),
        ),
        child: Icon(
          icon,
          color: isSelected ? AppTheme.primaryText : AppTheme.secondaryText,
          size: 18,
        ),
      ),
    );
  }

  Widget _buildPreviewFrame() {
    double width;
    double height;
    
    switch (_selectedDevice) {
      case 0: // Mobile
        width = 320;
        height = 568;
        break;
      case 1: // Tablet
        width = 480;
        height = 640;
        break;
      case 2: // Desktop
        width = 800;
        height = 600;
        break;
      default:
        width = 320;
        height = 568;
    }
    
    if (_isFullscreen) {
      width = MediaQuery.of(context).size.width - 32;
      height = MediaQuery.of(context).size.height - 200;
    }
    
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: AppTheme.primaryBackground,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppTheme.border),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Stack(
          children: [
            // Mock preview content
            Container(
              width: double.infinity,
              height: double.infinity,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    AppTheme.accent.withAlpha(51),
                    AppTheme.primaryBackground,
                  ],
                ),
              ),
              child: Column(
                children: [
                  // Header area
                  Container(
                    height: 60,
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 20,
                          backgroundColor: AppTheme.accent,
                          child: Icon(
                            Icons.person,
                            color: AppTheme.primaryText,
                            size: 24,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'John Doe',
                                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                                  color: AppTheme.primaryText,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              Text(
                                'Creative Designer',
                                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                  color: AppTheme.secondaryText,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  
                  // Content area
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        children: [
                          // Mock link buttons
                          _buildMockLinkButton('Portfolio', Icons.work),
                          const SizedBox(height: 12),
                          _buildMockLinkButton('Contact Me', Icons.email),
                          const SizedBox(height: 12),
                          _buildMockLinkButton('Instagram', Icons.photo_camera),
                          const SizedBox(height: 12),
                          _buildMockLinkButton('Shop', Icons.shopping_cart),
                          
                          const Spacer(),
                          
                          // Social links
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              _buildSocialIcon(Icons.facebook),
                              const SizedBox(width: 16),
                              _buildSocialIcon(Icons.camera_alt),
                              const SizedBox(width: 16),
                              _buildSocialIcon(Icons.music_note),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            
            // Interactive overlay
            if (!_isFullscreen)
              Positioned.fill(
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: () => setState(() => _isFullscreen = true),
                    child: Container(
                      alignment: Alignment.center,
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: AppTheme.primaryBackground.withAlpha(204),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Icon(
                          Icons.fullscreen,
                          color: AppTheme.primaryText,
                          size: 24,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildMockLinkButton(String title, IconData icon) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppTheme.border),
      ),
      child: Row(
        children: [
          Icon(icon, color: AppTheme.accent, size: 20),
          const SizedBox(width: 12),
          Text(
            title,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: AppTheme.primaryText,
              fontWeight: FontWeight.w500,
            ),
          ),
          const Spacer(),
          Icon(
            Icons.arrow_forward_ios,
            color: AppTheme.secondaryText,
            size: 16,
          ),
        ],
      ),
    );
  }

  Widget _buildSocialIcon(IconData icon) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppTheme.border),
      ),
      child: Icon(
        icon,
        color: AppTheme.accent,
        size: 20,
      ),
    );
  }
}