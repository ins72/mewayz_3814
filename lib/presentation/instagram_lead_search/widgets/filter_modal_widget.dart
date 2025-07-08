import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class FilterModalWidget extends StatefulWidget {
  final Function(List<Map<String, dynamic>>) onFiltersApplied;
  final List<Map<String, dynamic>> currentFilters;

  const FilterModalWidget({
    Key? key,
    required this.onFiltersApplied,
    required this.currentFilters,
  }) : super(key: key);

  @override
  State<FilterModalWidget> createState() => _FilterModalWidgetState();
}

class _FilterModalWidgetState extends State<FilterModalWidget> {
  RangeValues _followerRange = RangeValues(1000, 1000000);
  RangeValues _engagementRange = RangeValues(1.0, 10.0);
  String _selectedLocation = '';
  List<String> _selectedHashtags = [];
  String _selectedAccountType = 'All';
  String _selectedLanguage = 'All';
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _hashtagController = TextEditingController();

  final List<String> _accountTypes = ['All', 'Personal', 'Business', 'Creator'];
  final List<String> _languages = [
    'All',
    'English',
    'Spanish',
    'French',
    'German',
    'Italian'
  ];
  final List<String> _suggestedLocations = [
    'United States',
    'United Kingdom',
    'Canada',
    'Australia',
    'Germany',
    'France',
    'Italy',
    'Spain',
    'Brazil',
    'India',
  ];

  @override
  void initState() {
    super.initState();
    _initializeFilters();
  }

  void _initializeFilters() {
    // Initialize filters based on current filters
    for (var filter in widget.currentFilters) {
      switch (filter['type']) {
        case 'location':
          _selectedLocation = filter['value'] ?? '';
          _locationController.text = _selectedLocation;
          break;
        case 'account_type':
          _selectedAccountType = filter['value'] ?? 'All';
          break;
        case 'language':
          _selectedLanguage = filter['value'] ?? 'All';
          break;
      }
    }
  }

  @override
  void dispose() {
    _locationController.dispose();
    _hashtagController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 90.h,
      decoration: BoxDecoration(
        color: AppTheme.primaryBackground,
        borderRadius: BorderRadius.vertical(top: Radius.circular(5.w)),
      ),
      child: Column(
        children: [
          _buildHeader(),
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 4.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildFollowerRangeSection(),
                  _buildEngagementRateSection(),
                  _buildLocationSection(),
                  _buildHashtagSection(),
                  _buildAccountTypeSection(),
                  _buildLanguageSection(),
                  SizedBox(height: 4.h),
                ],
              ),
            ),
          ),
          _buildActionButtons(),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: AppTheme.border.withValues(alpha: 0.3)),
        ),
      ),
      child: Row(
        children: [
          GestureDetector(
            onTap: () {
              HapticFeedback.selectionClick();
              Navigator.pop(context);
            },
            child: CustomIconWidget(
              iconName: 'close',
              color: AppTheme.primaryText,
              size: 6.w,
            ),
          ),
          Expanded(
            child: Text(
              'Filter Accounts',
              style: AppTheme.darkTheme.textTheme.titleLarge,
              textAlign: TextAlign.center,
            ),
          ),
          GestureDetector(
            onTap: _resetFilters,
            child: Text(
              'Reset',
              style: AppTheme.darkTheme.textTheme.titleMedium?.copyWith(
                color: AppTheme.accent,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFollowerRangeSection() {
    return _buildSection(
      'Follower Count',
      Column(
        children: [
          RangeSlider(
            values: _followerRange,
            min: 100,
            max: 10000000,
            divisions: 100,
            labels: RangeLabels(
              _formatNumber(_followerRange.start.round()),
              _formatNumber(_followerRange.end.round()),
            ),
            onChanged: (values) {
              setState(() {
                _followerRange = values;
              });
            },
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                _formatNumber(_followerRange.start.round()),
                style: AppTheme.darkTheme.textTheme.bodySmall,
              ),
              Text(
                _formatNumber(_followerRange.end.round()),
                style: AppTheme.darkTheme.textTheme.bodySmall,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildEngagementRateSection() {
    return _buildSection(
      'Engagement Rate (%)',
      Column(
        children: [
          RangeSlider(
            values: _engagementRange,
            min: 0.1,
            max: 20.0,
            divisions: 199,
            labels: RangeLabels(
              '${_engagementRange.start.toStringAsFixed(1)}%',
              '${_engagementRange.end.toStringAsFixed(1)}%',
            ),
            onChanged: (values) {
              setState(() {
                _engagementRange = values;
              });
            },
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '${_engagementRange.start.toStringAsFixed(1)}%',
                style: AppTheme.darkTheme.textTheme.bodySmall,
              ),
              Text(
                '${_engagementRange.end.toStringAsFixed(1)}%',
                style: AppTheme.darkTheme.textTheme.bodySmall,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildLocationSection() {
    return _buildSection(
      'Location',
      Column(
        children: [
          TextField(
            controller: _locationController,
            style: AppTheme.darkTheme.textTheme.bodyMedium,
            decoration: InputDecoration(
              hintText: 'Enter location',
              prefixIcon: Padding(
                padding: EdgeInsets.all(3.w),
                child: CustomIconWidget(
                  iconName: 'location_on',
                  color: AppTheme.secondaryText,
                  size: 5.w,
                ),
              ),
            ),
            onChanged: (value) {
              setState(() {
                _selectedLocation = value;
              });
            },
          ),
          SizedBox(height: 2.h),
          Wrap(
            spacing: 2.w,
            runSpacing: 1.h,
            children: _suggestedLocations.map((location) {
              return GestureDetector(
                onTap: () {
                  setState(() {
                    _selectedLocation = location;
                    _locationController.text = location;
                  });
                },
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
                  decoration: BoxDecoration(
                    color: _selectedLocation == location
                        ? AppTheme.accent.withValues(alpha: 0.2)
                        : AppTheme.surface,
                    borderRadius: BorderRadius.circular(2.w),
                    border: Border.all(
                      color: _selectedLocation == location
                          ? AppTheme.accent
                          : AppTheme.border,
                    ),
                  ),
                  child: Text(
                    location,
                    style: AppTheme.darkTheme.textTheme.labelMedium?.copyWith(
                      color: _selectedLocation == location
                          ? AppTheme.accent
                          : AppTheme.primaryText,
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

  Widget _buildHashtagSection() {
    return _buildSection(
      'Hashtags',
      Column(
        children: [
          TextField(
            controller: _hashtagController,
            style: AppTheme.darkTheme.textTheme.bodyMedium,
            decoration: InputDecoration(
              hintText: 'Enter hashtag and press Enter',
              prefixIcon: Padding(
                padding: EdgeInsets.all(3.w),
                child: CustomIconWidget(
                  iconName: 'tag',
                  color: AppTheme.secondaryText,
                  size: 5.w,
                ),
              ),
            ),
            onSubmitted: _addHashtag,
          ),
          if (_selectedHashtags.isNotEmpty) ...[
            SizedBox(height: 2.h),
            Wrap(
              spacing: 2.w,
              runSpacing: 1.h,
              children: _selectedHashtags.map((hashtag) {
                return Container(
                  padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
                  decoration: BoxDecoration(
                    color: AppTheme.accent.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(2.w),
                    border: Border.all(color: AppTheme.accent),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        '#$hashtag',
                        style:
                            AppTheme.darkTheme.textTheme.labelMedium?.copyWith(
                          color: AppTheme.accent,
                        ),
                      ),
                      SizedBox(width: 1.w),
                      GestureDetector(
                        onTap: () => _removeHashtag(hashtag),
                        child: CustomIconWidget(
                          iconName: 'close',
                          color: AppTheme.accent,
                          size: 4.w,
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildAccountTypeSection() {
    return _buildSection(
      'Account Type',
      Wrap(
        spacing: 2.w,
        runSpacing: 1.h,
        children: _accountTypes.map((type) {
          return GestureDetector(
            onTap: () {
              setState(() {
                _selectedAccountType = type;
              });
            },
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
              decoration: BoxDecoration(
                color: _selectedAccountType == type
                    ? AppTheme.accent.withValues(alpha: 0.2)
                    : AppTheme.surface,
                borderRadius: BorderRadius.circular(2.w),
                border: Border.all(
                  color: _selectedAccountType == type
                      ? AppTheme.accent
                      : AppTheme.border,
                ),
              ),
              child: Text(
                type,
                style: AppTheme.darkTheme.textTheme.labelMedium?.copyWith(
                  color: _selectedAccountType == type
                      ? AppTheme.accent
                      : AppTheme.primaryText,
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildLanguageSection() {
    return _buildSection(
      'Language',
      Wrap(
        spacing: 2.w,
        runSpacing: 1.h,
        children: _languages.map((language) {
          return GestureDetector(
            onTap: () {
              setState(() {
                _selectedLanguage = language;
              });
            },
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
              decoration: BoxDecoration(
                color: _selectedLanguage == language
                    ? AppTheme.accent.withValues(alpha: 0.2)
                    : AppTheme.surface,
                borderRadius: BorderRadius.circular(2.w),
                border: Border.all(
                  color: _selectedLanguage == language
                      ? AppTheme.accent
                      : AppTheme.border,
                ),
              ),
              child: Text(
                language,
                style: AppTheme.darkTheme.textTheme.labelMedium?.copyWith(
                  color: _selectedLanguage == language
                      ? AppTheme.accent
                      : AppTheme.primaryText,
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildSection(String title, Widget content) {
    return Container(
      margin: EdgeInsets.only(bottom: 4.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: AppTheme.darkTheme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 2.h),
          content,
        ],
      ),
    );
  }

  Widget _buildActionButtons() {
    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(color: AppTheme.border.withValues(alpha: 0.3)),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: OutlinedButton(
              onPressed: () {
                HapticFeedback.selectionClick();
                Navigator.pop(context);
              },
              child: Text('Cancel'),
            ),
          ),
          SizedBox(width: 4.w),
          Expanded(
            child: ElevatedButton(
              onPressed: _applyFilters,
              child: Text('Apply Filters'),
            ),
          ),
        ],
      ),
    );
  }

  void _addHashtag(String hashtag) {
    if (hashtag.isNotEmpty && !_selectedHashtags.contains(hashtag)) {
      setState(() {
        _selectedHashtags.add(hashtag);
        _hashtagController.clear();
      });
    }
  }

  void _removeHashtag(String hashtag) {
    setState(() {
      _selectedHashtags.remove(hashtag);
    });
  }

  void _resetFilters() {
    HapticFeedback.mediumImpact();
    setState(() {
      _followerRange = RangeValues(1000, 1000000);
      _engagementRange = RangeValues(1.0, 10.0);
      _selectedLocation = '';
      _selectedHashtags.clear();
      _selectedAccountType = 'All';
      _selectedLanguage = 'All';
      _locationController.clear();
      _hashtagController.clear();
    });
  }

  void _applyFilters() {
    HapticFeedback.mediumImpact();
    List<Map<String, dynamic>> filters = [];

    // Add follower range filter
    if (_followerRange.start > 1000 || _followerRange.end < 1000000) {
      filters.add({
        'type': 'follower_range',
        'label':
            '${_formatNumber(_followerRange.start.round())} - ${_formatNumber(_followerRange.end.round())} followers',
        'count': 1,
        'value': _followerRange,
      });
    }

    // Add engagement rate filter
    if (_engagementRange.start > 1.0 || _engagementRange.end < 10.0) {
      filters.add({
        'type': 'engagement',
        'label':
            '${_engagementRange.start.toStringAsFixed(1)}% - ${_engagementRange.end.toStringAsFixed(1)}% engagement',
        'count': 1,
        'value': _engagementRange,
      });
    }

    // Add location filter
    if (_selectedLocation.isNotEmpty) {
      filters.add({
        'type': 'location',
        'label': _selectedLocation,
        'count': 1,
        'value': _selectedLocation,
      });
    }

    // Add hashtag filters
    for (String hashtag in _selectedHashtags) {
      filters.add({
        'type': 'hashtag',
        'label': '#$hashtag',
        'count': 1,
        'value': hashtag,
      });
    }

    // Add account type filter
    if (_selectedAccountType != 'All') {
      filters.add({
        'type': 'account_type',
        'label': _selectedAccountType,
        'count': 1,
        'value': _selectedAccountType,
      });
    }

    // Add language filter
    if (_selectedLanguage != 'All') {
      filters.add({
        'type': 'language',
        'label': _selectedLanguage,
        'count': 1,
        'value': _selectedLanguage,
      });
    }

    widget.onFiltersApplied(filters);
    Navigator.pop(context);
  }

  String _formatNumber(int number) {
    if (number >= 1000000) {
      return '${(number / 1000000).toStringAsFixed(1)}M';
    } else if (number >= 1000) {
      return '${(number / 1000).toStringAsFixed(1)}K';
    }
    return number.toString();
  }
}
