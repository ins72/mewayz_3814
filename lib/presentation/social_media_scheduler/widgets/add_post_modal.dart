import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class AddPostModal extends StatefulWidget {
  final Function(Map<String, dynamic>) onPostScheduled;

  const AddPostModal({
    Key? key,
    required this.onPostScheduled,
  }) : super(key: key);

  @override
  State<AddPostModal> createState() => _AddPostModalState();
}

class _AddPostModalState extends State<AddPostModal> {
  int _currentStep = 0;
  final PageController _pageController = PageController();

  // Form data
  final Set<String> _selectedPlatforms = {};
  final TextEditingController _contentController = TextEditingController();
  String? _selectedImageUrl;
  DateTime _scheduledDate = DateTime.now();
  TimeOfDay _scheduledTime = TimeOfDay.now();
  bool _useAIOptimalTime = false;

  final List<String> _availablePlatforms = [
    'instagram',
    'facebook',
    'twitter',
    'linkedin',
    'tiktok',
    'youtube'
  ];

  final List<String> _sampleImages = [
    'https://images.unsplash.com/photo-1556742049-0cfed4f6a45d?w=400',
    'https://images.unsplash.com/photo-1551288049-bebda4e38f71?w=400',
    'https://images.unsplash.com/photo-1460925895917-afdab827c52f?w=400',
    'https://images.unsplash.com/photo-1557804506-669a67965ba0?w=400',
    'https://images.unsplash.com/photo-1542744173-8e7e53415bb0?w=400',
  ];

  final List<String> _hashtagSuggestions = [
    '#business',
    '#marketing',
    '#socialmedia',
    '#entrepreneur',
    '#startup',
    '#success',
    '#motivation',
    '#innovation',
    '#leadership',
    '#growth'
  ];

  @override
  void dispose() {
    _contentController.dispose();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 90.h,
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
          _buildStepIndicator(),
          Expanded(
            child: PageView(
              controller: _pageController,
              onPageChanged: (index) {
                setState(() {
                  _currentStep = index;
                });
              },
              children: [
                _buildPlatformSelection(),
                _buildContentComposer(),
                _buildSchedulingOptions(),
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
              'Create Post',
              style: AppTheme.darkTheme.textTheme.titleLarge,
              textAlign: TextAlign.center,
            ),
          ),
          SizedBox(width: 48), // Balance the close button
        ],
      ),
    );
  }

  Widget _buildStepIndicator() {
    return Container(
      padding: EdgeInsets.all(4.w),
      child: Row(
        children: List.generate(3, (index) {
          final isActive = index <= _currentStep;
          final isCompleted = index < _currentStep;

          return Expanded(
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    height: 4,
                    decoration: BoxDecoration(
                      color: isActive ? AppTheme.accent : AppTheme.border,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                if (index < 2) SizedBox(width: 2.w),
              ],
            ),
          );
        }),
      ),
    );
  }

  Widget _buildPlatformSelection() {
    return Padding(
      padding: EdgeInsets.all(4.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Select Platforms',
            style: AppTheme.darkTheme.textTheme.titleMedium,
          ),
          SizedBox(height: 1.h),
          Text(
            'Choose where you want to publish this post',
            style: AppTheme.darkTheme.textTheme.bodyMedium?.copyWith(
              color: AppTheme.secondaryText,
            ),
          ),
          SizedBox(height: 3.h),
          Expanded(
            child: GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 1.5,
                crossAxisSpacing: 3.w,
                mainAxisSpacing: 2.h,
              ),
              itemCount: _availablePlatforms.length,
              itemBuilder: (context, index) {
                final platform = _availablePlatforms[index];
                final isSelected = _selectedPlatforms.contains(platform);

                return GestureDetector(
                  onTap: () {
                    HapticFeedback.lightImpact();
                    setState(() {
                      if (isSelected) {
                        _selectedPlatforms.remove(platform);
                      } else {
                        _selectedPlatforms.add(platform);
                      }
                    });
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: isSelected
                          ? _getPlatformColor(platform).withValues(alpha: 0.1)
                          : AppTheme.primaryBackground,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: isSelected
                            ? _getPlatformColor(platform)
                            : AppTheme.border,
                        width: isSelected ? 2 : 1,
                      ),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: 12.w,
                          height: 12.w,
                          decoration: BoxDecoration(
                            color: _getPlatformColor(platform),
                            shape: BoxShape.circle,
                          ),
                          child: Center(
                            child: CustomIconWidget(
                              iconName: _getPlatformIcon(platform),
                              color: AppTheme.primaryAction,
                              size: 24,
                            ),
                          ),
                        ),
                        SizedBox(height: 1.h),
                        Text(
                          platform.toUpperCase(),
                          style: AppTheme.darkTheme.textTheme.labelMedium
                              ?.copyWith(
                            color: isSelected
                                ? _getPlatformColor(platform)
                                : AppTheme.primaryText,
                            fontWeight: FontWeight.w600,
                          ),
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

  Widget _buildContentComposer() {
    return Padding(
      padding: EdgeInsets.all(4.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Create Content',
            style: AppTheme.darkTheme.textTheme.titleMedium,
          ),
          SizedBox(height: 1.h),
          Text(
            'Add your content and media',
            style: AppTheme.darkTheme.textTheme.bodyMedium?.copyWith(
              color: AppTheme.secondaryText,
            ),
          ),
          SizedBox(height: 3.h),

          // Image selection
          Text(
            'Add Image (Optional)',
            style: AppTheme.darkTheme.textTheme.labelLarge,
          ),
          SizedBox(height: 1.h),
          SizedBox(
            height: 12.h,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: _sampleImages.length + 1,
              itemBuilder: (context, index) {
                if (index == 0) {
                  return GestureDetector(
                    onTap: () {
                      // In a real app, this would open image picker
                      HapticFeedback.lightImpact();
                    },
                    child: Container(
                      width: 20.w,
                      margin: EdgeInsets.only(right: 2.w),
                      decoration: BoxDecoration(
                        color: AppTheme.primaryBackground,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                            color: AppTheme.border, style: BorderStyle.solid),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CustomIconWidget(
                            iconName: 'add_photo_alternate',
                            color: AppTheme.secondaryText,
                            size: 24,
                          ),
                          SizedBox(height: 0.5.h),
                          Text(
                            'Add',
                            style: AppTheme.darkTheme.textTheme.labelSmall,
                          ),
                        ],
                      ),
                    ),
                  );
                }

                final imageUrl = _sampleImages[index - 1];
                final isSelected = _selectedImageUrl == imageUrl;

                return GestureDetector(
                  onTap: () {
                    HapticFeedback.lightImpact();
                    setState(() {
                      _selectedImageUrl = isSelected ? null : imageUrl;
                    });
                  },
                  child: Container(
                    width: 20.w,
                    margin: EdgeInsets.only(right: 2.w),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: isSelected ? AppTheme.accent : AppTheme.border,
                        width: isSelected ? 2 : 1,
                      ),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: CustomImageWidget(
                        imageUrl: imageUrl,
                        width: 20.w,
                        height: 12.h,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),

          SizedBox(height: 3.h),

          // Content input
          Text(
            'Caption',
            style: AppTheme.darkTheme.textTheme.labelLarge,
          ),
          SizedBox(height: 1.h),
          Container(
            constraints: BoxConstraints(minHeight: 15.h),
            child: TextField(
              controller: _contentController,
              maxLines: null,
              decoration: InputDecoration(
                hintText: 'Write your caption here...',
                suffixIcon: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Padding(
                      padding: EdgeInsets.all(2.w),
                      child: Text(
                        '${_contentController.text.length}/2200',
                        style: AppTheme.darkTheme.textTheme.bodySmall,
                      ),
                    ),
                  ],
                ),
              ),
              onChanged: (value) {
                setState(() {});
              },
            ),
          ),

          SizedBox(height: 2.h),

          // Hashtag suggestions
          Text(
            'Suggested Hashtags',
            style: AppTheme.darkTheme.textTheme.labelLarge,
          ),
          SizedBox(height: 1.h),
          Wrap(
            spacing: 2.w,
            runSpacing: 1.h,
            children: _hashtagSuggestions.map((hashtag) {
              return GestureDetector(
                onTap: () {
                  HapticFeedback.lightImpact();
                  _contentController.text += ' $hashtag';
                  setState(() {});
                },
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
                  decoration: BoxDecoration(
                    color: AppTheme.primaryBackground,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: AppTheme.border),
                  ),
                  child: Text(
                    hashtag,
                    style: AppTheme.darkTheme.textTheme.bodySmall?.copyWith(
                      color: AppTheme.accent,
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildSchedulingOptions() {
    return Padding(
      padding: EdgeInsets.all(4.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Schedule Post',
            style: AppTheme.darkTheme.textTheme.titleMedium,
          ),
          SizedBox(height: 1.h),
          Text(
            'Choose when to publish your post',
            style: AppTheme.darkTheme.textTheme.bodyMedium?.copyWith(
              color: AppTheme.secondaryText,
            ),
          ),
          SizedBox(height: 3.h),

          // AI optimal time toggle
          Container(
            padding: EdgeInsets.all(4.w),
            decoration: BoxDecoration(
              color: AppTheme.primaryBackground,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppTheme.border),
            ),
            child: Row(
              children: [
                CustomIconWidget(
                  iconName: 'auto_awesome',
                  color: AppTheme.accent,
                  size: 24,
                ),
                SizedBox(width: 3.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'AI Optimal Time',
                        style: AppTheme.darkTheme.textTheme.labelLarge,
                      ),
                      Text(
                        'Let AI choose the best time to post',
                        style: AppTheme.darkTheme.textTheme.bodySmall?.copyWith(
                          color: AppTheme.secondaryText,
                        ),
                      ),
                    ],
                  ),
                ),
                Switch(
                  value: _useAIOptimalTime,
                  onChanged: (value) {
                    setState(() {
                      _useAIOptimalTime = value;
                    });
                  },
                ),
              ],
            ),
          ),

          if (!_useAIOptimalTime) ...[
            SizedBox(height: 3.h),

            // Date selection
            Text(
              'Date',
              style: AppTheme.darkTheme.textTheme.labelLarge,
            ),
            SizedBox(height: 1.h),
            GestureDetector(
              onTap: () async {
                final date = await showDatePicker(
                  context: context,
                  initialDate: _scheduledDate,
                  firstDate: DateTime.now(),
                  lastDate: DateTime.now().add(const Duration(days: 365)),
                );
                if (date != null) {
                  setState(() {
                    _scheduledDate = date;
                  });
                }
              },
              child: Container(
                padding: EdgeInsets.all(4.w),
                decoration: BoxDecoration(
                  color: AppTheme.primaryBackground,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppTheme.border),
                ),
                child: Row(
                  children: [
                    CustomIconWidget(
                      iconName: 'calendar_today',
                      color: AppTheme.secondaryText,
                      size: 20,
                    ),
                    SizedBox(width: 3.w),
                    Text(
                      _formatDate(_scheduledDate),
                      style: AppTheme.darkTheme.textTheme.bodyMedium,
                    ),
                    const Spacer(),
                    CustomIconWidget(
                      iconName: 'chevron_right',
                      color: AppTheme.secondaryText,
                      size: 20,
                    ),
                  ],
                ),
              ),
            ),

            SizedBox(height: 2.h),

            // Time selection
            Text(
              'Time',
              style: AppTheme.darkTheme.textTheme.labelLarge,
            ),
            SizedBox(height: 1.h),
            GestureDetector(
              onTap: () async {
                final time = await showTimePicker(
                  context: context,
                  initialTime: _scheduledTime,
                );
                if (time != null) {
                  setState(() {
                    _scheduledTime = time;
                  });
                }
              },
              child: Container(
                padding: EdgeInsets.all(4.w),
                decoration: BoxDecoration(
                  color: AppTheme.primaryBackground,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppTheme.border),
                ),
                child: Row(
                  children: [
                    CustomIconWidget(
                      iconName: 'access_time',
                      color: AppTheme.secondaryText,
                      size: 20,
                    ),
                    SizedBox(width: 3.w),
                    Text(
                      _scheduledTime.format(context),
                      style: AppTheme.darkTheme.textTheme.bodyMedium,
                    ),
                    const Spacer(),
                    CustomIconWidget(
                      iconName: 'chevron_right',
                      color: AppTheme.secondaryText,
                      size: 20,
                    ),
                  ],
                ),
              ),
            ),
          ],

          SizedBox(height: 3.h),

          // Preview section
          Text(
            'Preview',
            style: AppTheme.darkTheme.textTheme.labelLarge,
          ),
          SizedBox(height: 1.h),
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
                    Text(
                      'Platforms: ',
                      style: AppTheme.darkTheme.textTheme.bodySmall?.copyWith(
                        color: AppTheme.secondaryText,
                      ),
                    ),
                    Text(
                      _selectedPlatforms.join(', ').toUpperCase(),
                      style: AppTheme.darkTheme.textTheme.bodySmall?.copyWith(
                        color: AppTheme.accent,
                      ),
                    ),
                  ],
                ),
                if (_contentController.text.isNotEmpty) ...[
                  SizedBox(height: 1.h),
                  Text(
                    _contentController.text,
                    style: AppTheme.darkTheme.textTheme.bodyMedium,
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
                if (_selectedImageUrl != null) ...[
                  SizedBox(height: 1.h),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: CustomImageWidget(
                      imageUrl: _selectedImageUrl!,
                      width: double.infinity,
                      height: 15.h,
                      fit: BoxFit.cover,
                    ),
                  ),
                ],
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
          if (_currentStep > 0) ...[
            Expanded(
              child: OutlinedButton(
                onPressed: () {
                  _pageController.previousPage(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                  );
                },
                child: Text('Back'),
              ),
            ),
            SizedBox(width: 4.w),
          ],
          Expanded(
            child: ElevatedButton(
              onPressed: _canProceed() ? _handleNextOrSchedule : null,
              child: Text(_currentStep == 2 ? 'Schedule Post' : 'Next'),
            ),
          ),
        ],
      ),
    );
  }

  bool _canProceed() {
    switch (_currentStep) {
      case 0:
        return _selectedPlatforms.isNotEmpty;
      case 1:
        return _contentController.text.isNotEmpty;
      case 2:
        return true;
      default:
        return false;
    }
  }

  void _handleNextOrSchedule() {
    if (_currentStep < 2) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      _schedulePost();
    }
  }

  void _schedulePost() {
    final dateKey =
        '${_scheduledDate.year}-${_scheduledDate.month.toString().padLeft(2, '0')}-${_scheduledDate.day.toString().padLeft(2, '0')}';

    final postData = {
      'id': DateTime.now().millisecondsSinceEpoch.toString(),
      'platform':
          _selectedPlatforms.first, // For simplicity, using first platform
      'content': _contentController.text,
      'imageUrl': _selectedImageUrl,
      'scheduledTime': _scheduledTime.format(context),
      'status': 'scheduled',
      'engagement': {'likes': 0, 'comments': 0, 'shares': 0},
      'dateKey': dateKey,
    };

    widget.onPostScheduled(postData);
    Navigator.pop(context);

    HapticFeedback.mediumImpact();
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

  String _formatDate(DateTime date) {
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec'
    ];
    return '${months[date.month - 1]} ${date.day}, ${date.year}';
  }
}
