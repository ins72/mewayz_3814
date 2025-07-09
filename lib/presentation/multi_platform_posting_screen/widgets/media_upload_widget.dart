import '../../../core/app_export.dart';

class MediaUploadWidget extends StatelessWidget {
  final List<String> uploadedMedia;
  final Function(String) onMediaAdded;
  final Function(String) onMediaRemoved;
  final Function(List<String>) onMediaReordered;

  const MediaUploadWidget({
    super.key,
    required this.uploadedMedia,
    required this.onMediaAdded,
    required this.onMediaRemoved,
    required this.onMediaReordered,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppTheme.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Text(
                'Media',
                style: TextStyle(
                  color: AppTheme.primaryText,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const Spacer(),
              Text(
                '${uploadedMedia.length}/10',
                style: const TextStyle(
                  color: AppTheme.secondaryText,
                  fontSize: 12,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          if (uploadedMedia.isEmpty) _buildUploadArea() else _buildMediaGrid(),
          const SizedBox(height: 12),
          _buildUploadButtons(),
        ],
      ),
    );
  }

  Widget _buildUploadArea() {
    return Container(
      height: 120,
      decoration: BoxDecoration(
        color: AppTheme.primaryBackground,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: AppTheme.border,
          style: BorderStyle.solid,
        ),
      ),
      child: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.cloud_upload_outlined,
              color: AppTheme.secondaryText,
              size: 32,
            ),
            SizedBox(height: 8),
            Text(
              'Drag & drop or click to upload',
              style: TextStyle(
                color: AppTheme.secondaryText,
                fontSize: 14,
              ),
            ),
            SizedBox(height: 4),
            Text(
              'PNG, JPG, GIF, MP4 up to 100MB',
              style: TextStyle(
                color: AppTheme.secondaryText,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMediaGrid() {
    return ReorderableListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: uploadedMedia.length,
      onReorder: (oldIndex, newIndex) {
        final List<String> newOrder = List.from(uploadedMedia);
        if (oldIndex < newIndex) newIndex--;
        final item = newOrder.removeAt(oldIndex);
        newOrder.insert(newIndex, item);
        onMediaReordered(newOrder);
      },
      itemBuilder: (context, index) {
        final media = uploadedMedia[index];
        return Container(
          key: ValueKey(media),
          margin: const EdgeInsets.only(bottom: 8),
          child: Stack(
            children: [
              Container(
                height: 80,
                decoration: BoxDecoration(
                  color: AppTheme.primaryBackground,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: AppTheme.border),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        color: AppTheme.border,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(
                        Icons.image,
                        color: AppTheme.secondaryText,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'image_$index.jpg',
                            style: const TextStyle(
                              color: AppTheme.primaryText,
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 4),
                          const Text(
                            '2.4 MB',
                            style: TextStyle(
                              color: AppTheme.secondaryText,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      onPressed: () => _showCropOptions(media),
                      icon: const Icon(
                        Icons.crop,
                        color: AppTheme.secondaryText,
                      ),
                    ),
                    IconButton(
                      onPressed: () => onMediaRemoved(media),
                      icon: const Icon(
                        Icons.close,
                        color: AppTheme.error,
                      ),
                    ),
                  ],
                ),
              ),
              Positioned(
                top: 8,
                left: 8,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: AppTheme.primaryBackground.withAlpha(204),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    '${index + 1}',
                    style: const TextStyle(
                      color: AppTheme.primaryText,
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildUploadButtons() {
    return Row(
      children: [
        Expanded(
          child: OutlinedButton.icon(
            onPressed: () => _pickMedia('image'),
            icon: const Icon(Icons.photo_library, size: 18),
            label: const Text('Photos'),
            style: OutlinedButton.styleFrom(
              foregroundColor: AppTheme.primaryText,
              side: const BorderSide(color: AppTheme.border),
              padding: const EdgeInsets.symmetric(vertical: 12),
            ),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: OutlinedButton.icon(
            onPressed: () => _pickMedia('video'),
            icon: const Icon(Icons.videocam, size: 18),
            label: const Text('Videos'),
            style: OutlinedButton.styleFrom(
              foregroundColor: AppTheme.primaryText,
              side: const BorderSide(color: AppTheme.border),
              padding: const EdgeInsets.symmetric(vertical: 12),
            ),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: OutlinedButton.icon(
            onPressed: () => _pickMedia('camera'),
            icon: const Icon(Icons.camera_alt, size: 18),
            label: const Text('Camera'),
            style: OutlinedButton.styleFrom(
              foregroundColor: AppTheme.primaryText,
              side: const BorderSide(color: AppTheme.border),
              padding: const EdgeInsets.symmetric(vertical: 12),
            ),
          ),
        ),
      ],
    );
  }

  void _pickMedia(String type) {
    // Implement media picking logic
    onMediaAdded('media_${uploadedMedia.length + 1}');
  }

  void _showCropOptions(String media) {
    // Show cropping options modal
  }
}