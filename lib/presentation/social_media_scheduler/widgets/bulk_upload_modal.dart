import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../core/app_export.dart';

class BulkUploadModal extends StatefulWidget {
  final Function(List<Map<String, dynamic>>) onBulkUpload;

  const BulkUploadModal({
    Key? key,
    required this.onBulkUpload,
  }) : super(key: key);

  @override
  State<BulkUploadModal> createState() => _BulkUploadModalState();
}

class _BulkUploadModalState extends State<BulkUploadModal> {
  bool _isUploading = false;
  bool _hasFile = false;
  String? _fileName;

  // Mock CSV data for preview
  final List<Map<String, dynamic>> _previewData = [
{ 'platform': 'instagram',
'content': 'Check out our new product launch! 🚀 #newproduct #launch',
'date': '2024-01-20',
'time': '09:00',
'imageUrl': 'https://images.unsplash.com/photo-1556742049-0cfed4f6a45d?w=400',
},
{ 'platform': 'facebook',
'content': 'Join us for our webinar tomorrow at 2 PM EST!',
'date': '2024-01-21',
'time': '14:00',
'imageUrl': null,
},
{ 'platform': 'twitter',
'content': 'Exciting news coming soon! Stay tuned 👀 #comingsoon',
'date': '2024-01-22',
'time': '11:30',
'imageUrl': null,
},
];

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 85.h,
      decoration: BoxDecoration(
        color: AppTheme.surface,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: Column(
        children: [
          _buildHeader(),
          Expanded(
            child: _hasFile ? _buildPreviewSection() : _buildUploadSection(),
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
        border: Border(
          bottom: BorderSide(color: AppTheme.border, width: 1),
        ),
      ),
      child: Row(
        children: [
          IconButton(
            onPressed: () => Navigator.pop(context),
            icon: CustomIconWidget(
              iconName: 'close',
              color: AppTheme.primaryText,
              size: 24,
            ),
          ),
          Expanded(
            child: Text(
              'Bulk Upload',
              style: AppTheme.darkTheme.textTheme.titleLarge,
              textAlign: TextAlign.center,
            ),
          ),
          SizedBox(width: 48), // Balance the close button
        ],
      ),
    );
  }

  Widget _buildUploadSection() {
    return Padding(
      padding: EdgeInsets.all(4.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Upload CSV File',
            style: AppTheme.darkTheme.textTheme.titleMedium,
          ),
          SizedBox(height: 1.h),
          Text(
            'Upload a CSV file with your posts to schedule them in bulk',
            style: AppTheme.darkTheme.textTheme.bodyMedium?.copyWith(
              color: AppTheme.secondaryText,
            ),
          ),
          SizedBox(height: 4.h),

          // Upload area
          GestureDetector(
            onTap: _selectFile,
            child: Container(
              width: double.infinity,
              height: 25.h,
              decoration: BoxDecoration(
                color: AppTheme.primaryBackground,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: AppTheme.border,
                  style: BorderStyle.solid,
                  width: 2,
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CustomIconWidget(
                    iconName: 'cloud_upload',
                    color: AppTheme.accent,
                    size: 48,
                  ),
                  SizedBox(height: 2.h),
                  Text(
                    'Tap to select CSV file',
                    style: AppTheme.darkTheme.textTheme.titleMedium?.copyWith(
                      color: AppTheme.accent,
                    ),
                  ),
                  SizedBox(height: 1.h),
                  Text(
                    'or drag and drop here',
                    style: AppTheme.darkTheme.textTheme.bodyMedium?.copyWith(
                      color: AppTheme.secondaryText,
                    ),
                  ),
                ],
              ),
            ),
          ),

          SizedBox(height: 4.h),

          // Template download section
          Container(
            padding: EdgeInsets.all(4.w),
            decoration: BoxDecoration(
              color: AppTheme.primaryBackground,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppTheme.border),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    CustomIconWidget(
                      iconName: 'download',
                      color: AppTheme.accent,
                      size: 24,
                    ),
                    SizedBox(width: 3.w),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Download Template',
                            style: AppTheme.darkTheme.textTheme.labelLarge,
                          ),
                          Text(
                            'Get the CSV template with required columns',
                            style: AppTheme.darkTheme.textTheme.bodySmall
                                ?.copyWith(
                              color: AppTheme.secondaryText,
                            ),
                          ),
                        ],
                      ),
                    ),
                    TextButton(
                      onPressed: _downloadTemplate,
                      child: Text(
                        'Download',
                        style:
                            AppTheme.darkTheme.textTheme.labelMedium?.copyWith(
                          color: AppTheme.accent,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          SizedBox(height: 3.h),

          // Required format info
          Text(
            'Required CSV Format:',
            style: AppTheme.darkTheme.textTheme.labelLarge,
          ),
          SizedBox(height: 1.h),
          Container(
            padding: EdgeInsets.all(3.w),
            decoration: BoxDecoration(
              color: AppTheme.primaryBackground,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: AppTheme.border),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildFormatRow(
                    'platform', 'instagram, facebook, twitter, etc.'),
                _buildFormatRow('content', 'Your post content'),
                _buildFormatRow('date', 'YYYY-MM-DD format'),
                _buildFormatRow('time', 'HH:MM format (24-hour)'),
                _buildFormatRow('imageUrl', 'Image URL (optional)'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFormatRow(String column, String description) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 0.5.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 20.w,
            child: Text(
              column,
              style: AppTheme.darkTheme.textTheme.bodySmall?.copyWith(
                color: AppTheme.accent,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Expanded(
            child: Text(
              description,
              style: AppTheme.darkTheme.textTheme.bodySmall,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPreviewSection() {
    return Column(
      children: [
        // File info
        Container(
          padding: EdgeInsets.all(4.w),
          decoration: BoxDecoration(
            color: AppTheme.accent.withValues(alpha: 0.1),
            border: Border(
              bottom: BorderSide(color: AppTheme.border, width: 1),
            ),
          ),
          child: Row(
            children: [
              CustomIconWidget(
                iconName: 'description',
                color: AppTheme.accent,
                size: 24,
              ),
              SizedBox(width: 3.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _fileName ?? 'posts.csv',
                      style: AppTheme.darkTheme.textTheme.labelLarge,
                    ),
                    Text(
                      '${_previewData.length} posts found',
                      style: AppTheme.darkTheme.textTheme.bodySmall?.copyWith(
                        color: AppTheme.secondaryText,
                      ),
                    ),
                  ],
                ),
              ),
              TextButton(
                onPressed: () {
                  setState(() {
                    _hasFile = false;
                    _fileName = null;
                  });
                },
                child: Text(
                  'Change',
                  style: AppTheme.darkTheme.textTheme.labelMedium?.copyWith(
                    color: AppTheme.accent,
                  ),
                ),
              ),
            ],
          ),
        ),

        // Preview list
        Expanded(
          child: ListView.builder(
            padding: EdgeInsets.all(4.w),
            itemCount: _previewData.length,
            itemBuilder: (context, index) {
              final post = _previewData[index];
              return _buildPreviewCard(post, index);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildPreviewCard(Map<String, dynamic> post, int index) {
    final platformColor = _getPlatformColor(post['platform']);

    return Container(
      margin: EdgeInsets.only(bottom: 2.h),
      decoration: BoxDecoration(
        color: AppTheme.primaryBackground,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppTheme.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Container(
            padding: EdgeInsets.all(4.w),
            decoration: BoxDecoration(
              color: platformColor.withValues(alpha: 0.1),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(12),
                topRight: Radius.circular(12),
              ),
            ),
            child: Row(
              children: [
                Container(
                  width: 8.w,
                  height: 8.w,
                  decoration: BoxDecoration(
                    color: platformColor,
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: CustomIconWidget(
                      iconName: _getPlatformIcon(post['platform']),
                      color: AppTheme.primaryAction,
                      size: 16,
                    ),
                  ),
                ),
                SizedBox(width: 3.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        post['platform'].toString().toUpperCase(),
                        style:
                            AppTheme.darkTheme.textTheme.labelMedium?.copyWith(
                          color: platformColor,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        '${post['date']} • ${post['time']}',
                        style: AppTheme.darkTheme.textTheme.bodySmall,
                      ),
                    ],
                  ),
                ),
                Text(
                  '#${index + 1}',
                  style: AppTheme.darkTheme.textTheme.labelSmall?.copyWith(
                    color: AppTheme.secondaryText,
                  ),
                ),
              ],
            ),
          ),

          // Content
          Padding(
            padding: EdgeInsets.all(4.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (post['imageUrl'] != null) ...[
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: CustomImageWidget(
                      imageUrl: post['imageUrl'],
                      width: double.infinity,
                      height: 15.h,
                      fit: BoxFit.cover,
                    ),
                  ),
                  SizedBox(height: 2.h),
                ],
                Text(
                  post['content'],
                  style: AppTheme.darkTheme.textTheme.bodyMedium,
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomActions() {
    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(color: AppTheme.border, width: 1),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: OutlinedButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Cancel'),
            ),
          ),
          SizedBox(width: 4.w),
          Expanded(
            child: ElevatedButton(
              onPressed: _hasFile ? _uploadPosts : _selectFile,
              child: _isUploading
                  ? SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(
                          AppTheme.primaryBackground,
                        ),
                      ),
                    )
                  : Text(_hasFile ? 'Upload Posts' : 'Select File'),
            ),
          ),
        ],
      ),
    );
  }

  void _selectFile() {
    HapticFeedback.lightImpact();
    // In a real app, this would open file picker
    setState(() {
      _hasFile = true;
      _fileName = 'social_media_posts.csv';
    });
  }

  void _downloadTemplate() {
    HapticFeedback.lightImpact();
    // In a real app, this would download the CSV template
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Template downloaded to Downloads folder'),
        backgroundColor: AppTheme.success,
      ),
    );
  }

  void _uploadPosts() async {
    setState(() {
      _isUploading = true;
    });

    // Simulate upload process
    await Future.delayed(const Duration(seconds: 2));

    // Convert preview data to the format expected by the parent
    final posts = _previewData.map((post) {
      final dateKey = post['date'];
      return {
        'id': DateTime.now().millisecondsSinceEpoch.toString() +
            post.hashCode.toString(),
        'platform': post['platform'],
        'content': post['content'],
        'imageUrl': post['imageUrl'],
        'scheduledTime': post['time'],
        'status': 'scheduled',
        'engagement': {'likes': 0, 'comments': 0, 'shares': 0},
        'dateKey': dateKey,
      };
    }).toList();

    widget.onBulkUpload(posts);

    setState(() {
      _isUploading = false;
    });

    Navigator.pop(context);

    HapticFeedback.mediumImpact();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${posts.length} posts uploaded successfully'),
        backgroundColor: AppTheme.success,
      ),
    );
  }

  Color _getPlatformColor(String platform) {
    switch (platform) {
      case 'instagram':
        return const Color(0xFFE4405F);
      case 'facebook':
        return const Color(0xFF1877F2);
      case 'twitter':
        return const Color(0xFF1DA1F2);
      case 'linkedin':
        return const Color(0xFF0A66C2);
      case 'tiktok':
        return const Color(0xFF000000);
      case 'youtube':
        return const Color(0xFFFF0000);
      default:
        return AppTheme.accent;
    }
  }

  String _getPlatformIcon(String platform) {
    switch (platform) {
      case 'instagram':
        return 'camera_alt';
      case 'facebook':
        return 'facebook';
      case 'twitter':
        return 'alternate_email';
      case 'linkedin':
        return 'business';
      case 'tiktok':
        return 'music_note';
      case 'youtube':
        return 'play_circle_filled';
      default:
        return 'public';
    }
  }
}