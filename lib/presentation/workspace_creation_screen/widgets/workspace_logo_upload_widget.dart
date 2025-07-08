import 'dart:io';

import 'package:flutter/material.dart';

import '../../../core/app_export.dart';

class WorkspaceLogoUploadWidget extends StatelessWidget {
  final File? logoFile;
  final String logoUrl;
  final Function(File?, String) onLogoChanged;

  const WorkspaceLogoUploadWidget({
    Key? key,
    required this.logoFile,
    required this.logoUrl,
    required this.onLogoChanged,
  }) : super(key: key);

  void _showImagePicker(BuildContext context) {
    showModalBottomSheet(
        context: context,
        backgroundColor: AppTheme.surface,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
        builder: (context) => Container(
            padding: EdgeInsets.all(4.w),
            child: Column(mainAxisSize: MainAxisSize.min, children: [
              Center(
                  child: Container(
                      width: 10.w,
                      height: 0.5.h,
                      decoration: BoxDecoration(
                          color: AppTheme.border,
                          borderRadius: BorderRadius.circular(2)))),
              SizedBox(height: 2.h),
              Text('Choose Logo Source',
                  style: AppTheme.darkTheme.textTheme.titleLarge),
              SizedBox(height: 2.h),
              ListTile(
                  leading: const CustomIconWidget(
                      iconName: 'photo_camera',
                      color: AppTheme.primaryText,
                      size: 24),
                  title: const Text('Take Photo'),
                  onTap: () {
                    Navigator.pop(context);
                    _pickImageFromCamera();
                  }),
              ListTile(
                  leading: const CustomIconWidget(
                      iconName: 'photo_library',
                      color: AppTheme.primaryText,
                      size: 24),
                  title: const Text('Choose from Gallery'),
                  onTap: () {
                    Navigator.pop(context);
                    _pickImageFromGallery();
                  }),
              ListTile(
                  leading: const CustomIconWidget(
                      iconName: 'auto_awesome',
                      color: AppTheme.accent,
                      size: 24),
                  title: const Text('Generate Avatar'),
                  onTap: () {
                    Navigator.pop(context);
                    _generateAvatar();
                  }),
              if (logoFile != null || logoUrl.isNotEmpty) ...[
                ListTile(
                    leading: const CustomIconWidget(
                        iconName: 'delete', color: AppTheme.error, size: 24),
                    title: Text('Remove Logo',
                        style: TextStyle(color: AppTheme.error)),
                    onTap: () {
                      Navigator.pop(context);
                      onLogoChanged(null, '');
                    }),
              ],
            ])));
  }

  void _pickImageFromCamera() {
    // Simulate camera image picking
    // In a real app, you would use image_picker package
    final mockFile = File('');
    onLogoChanged(mockFile,
        'https://images.unsplash.com/photo-1552664730-d307ca884978?w=200&h=200&fit=crop');
  }

  void _pickImageFromGallery() {
    // Simulate gallery image picking
    // In a real app, you would use image_picker package
    final mockFile = File('');
    onLogoChanged(mockFile,
        'https://images.unsplash.com/photo-1556742049-0cfed4f6a45d?w=200&h=200&fit=crop');
  }

  void _generateAvatar() {
    // Simulate avatar generation
    final avatarUrls = [
      'https://images.unsplash.com/photo-1552664730-d307ca884978?w=200&h=200&fit=crop',
      'https://images.unsplash.com/photo-1556742049-0cfed4f6a45d?w=200&h=200&fit=crop',
      'https://images.unsplash.com/photo-1513475382585-d06e58bcb0e0?w=200&h=200&fit=crop',
      'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=200&h=200&fit=crop',
    ];

    final randomUrl =
        avatarUrls[DateTime.now().millisecond % avatarUrls.length];
    onLogoChanged(null, randomUrl);
  }

  @override
  Widget build(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text('Workspace Logo', style: AppTheme.darkTheme.textTheme.titleMedium),
      SizedBox(height: 1.h),
      Center(
          child: GestureDetector(
              onTap: () => _showImagePicker(context),
              child: Container(
                  width: 30.w,
                  height: 30.w,
                  decoration: BoxDecoration(
                      color: AppTheme.surface,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: AppTheme.border, width: 2)),
                  child: logoFile != null || logoUrl.isNotEmpty
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(14),
                          child: logoFile != null
                              ? Image.file(logoFile!, fit: BoxFit.cover)
                              : CustomImageWidget(
                                  imageUrl: logoUrl, fit: BoxFit.cover))
                      : Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                              const CustomIconWidget(
                                  iconName: 'add_a_photo',
                                  color: AppTheme.secondaryText,
                                  size: 32),
                              SizedBox(height: 1.h),
                              Text('Add Logo',
                                  style: AppTheme.darkTheme.textTheme.bodySmall
                                      ?.copyWith(
                                          color: AppTheme.secondaryText)),
                            ])))),
      SizedBox(height: 1.h),
      Center(
          child: Text('Tap to upload or generate a logo',
              style: AppTheme.darkTheme.textTheme.bodySmall
                  ?.copyWith(color: AppTheme.secondaryText))),
    ]);
  }
}