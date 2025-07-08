import 'package:flutter/material.dart';

import '../../../core/app_export.dart';

class AvatarUploadWidget extends StatefulWidget {
  final VoidCallback? onImageChanged;

  const AvatarUploadWidget({
    Key? key,
    this.onImageChanged,
  }) : super(key: key);

  @override
  State<AvatarUploadWidget> createState() => _AvatarUploadWidgetState();
}

class _AvatarUploadWidgetState extends State<AvatarUploadWidget> {
  String? _selectedImage;

  void _showImageSourceDialog() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        padding: EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: AppTheme.surface,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: AppTheme.border,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'Update Profile Picture',
              style: GoogleFonts.inter(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: AppTheme.primaryText,
              ),
            ),
            const SizedBox(height: 24),
            _buildImageSourceOption(
              icon: Icons.camera_alt,
              title: 'Take Photo',
              onTap: () {
                Navigator.pop(context);
                _selectImageFromCamera();
              },
            ),
            const SizedBox(height: 16),
            _buildImageSourceOption(
              icon: Icons.photo_library,
              title: 'Choose from Gallery',
              onTap: () {
                Navigator.pop(context);
                _selectImageFromGallery();
              },
            ),
            const SizedBox(height: 16),
            _buildImageSourceOption(
              icon: Icons.person,
              title: 'Generate Avatar',
              onTap: () {
                Navigator.pop(context);
                _generateAvatar();
              },
            ),
            if (_selectedImage != null) ...[
              const SizedBox(height: 16),
              _buildImageSourceOption(
                icon: Icons.delete,
                title: 'Remove Photo',
                onTap: () {
                  Navigator.pop(context);
                  _removeImage();
                },
                isDestructive: true,
              ),
            ],
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildImageSourceOption({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    bool isDestructive = false,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isDestructive
              ? AppTheme.error.withAlpha(26)
              : AppTheme.primaryBackground,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isDestructive ? AppTheme.error : AppTheme.border,
          ),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              color: isDestructive ? AppTheme.error : AppTheme.primaryText,
              size: 24,
            ),
            const SizedBox(width: 16),
            Text(
              title,
              style: GoogleFonts.inter(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: isDestructive ? AppTheme.error : AppTheme.primaryText,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _selectImageFromCamera() {
    // TODO: Implement camera selection
    setState(() {
      _selectedImage =
          'https://images.unsplash.com/photo-1472099645785-5658abf4ff4e?q=80&w=2940&auto=format&fit=crop';
    });
    widget.onImageChanged?.call();
  }

  void _selectImageFromGallery() {
    // TODO: Implement gallery selection
    setState(() {
      _selectedImage =
          'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?q=80&w=2940&auto=format&fit=crop';
    });
    widget.onImageChanged?.call();
  }

  void _generateAvatar() {
    // TODO: Implement avatar generation
    setState(() {
      _selectedImage =
          'https://images.unsplash.com/photo-1535713875002-d1d0cf377fde?q=80&w=2940&auto=format&fit=crop';
    });
    widget.onImageChanged?.call();
  }

  void _removeImage() {
    setState(() {
      _selectedImage = null;
    });
    widget.onImageChanged?.call();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(24),
      child: Column(
        children: [
          Stack(
            children: [
              // Avatar
              Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: AppTheme.border,
                    width: 3,
                  ),
                ),
                child: ClipOval(
                  child: _selectedImage != null
                      ? CustomImageWidget(
                          imageUrl: _selectedImage,
                          width: 120,
                          height: 120,
                          fit: BoxFit.cover,
                        )
                      : Container(
                          color: AppTheme.surface,
                          child: Icon(
                            Icons.person,
                            size: 60,
                            color: AppTheme.secondaryText,
                          ),
                        ),
                ),
              ),

              // Camera overlay
              Positioned(
                right: 0,
                bottom: 0,
                child: GestureDetector(
                  onTap: _showImageSourceDialog,
                  child: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: AppTheme.primaryAction,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: AppTheme.primaryBackground,
                        width: 3,
                      ),
                    ),
                    child: Icon(
                      Icons.camera_alt,
                      size: 20,
                      color: AppTheme.primaryBackground,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            'Upload Profile Picture',
            style: GoogleFonts.inter(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: AppTheme.primaryText,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Choose a photo that represents you professionally',
            style: GoogleFonts.inter(
              fontSize: 14,
              fontWeight: FontWeight.w400,
              color: AppTheme.secondaryText,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}