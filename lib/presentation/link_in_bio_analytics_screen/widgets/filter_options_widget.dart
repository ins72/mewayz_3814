import 'package:flutter/material.dart';

import '../../../core/app_export.dart';

class FilterOptionsWidget extends StatefulWidget {
  final String selectedFilter;
  final String selectedDateRange;
  final Function(String) onFilterChanged;
  final Function(String) onDateRangeChanged;

  const FilterOptionsWidget({
    super.key,
    required this.selectedFilter,
    required this.selectedDateRange,
    required this.onFilterChanged,
    required this.onDateRangeChanged,
  });

  @override
  State<FilterOptionsWidget> createState() => _FilterOptionsWidgetState();
}

class _FilterOptionsWidgetState extends State<FilterOptionsWidget> {
  late String selectedFilter;
  late String selectedDateRange;
  String selectedTrafficSource = 'all';
  String selectedDevice = 'all';
  String selectedLocation = 'all';

  @override
  void initState() {
    super.initState();
    selectedFilter = widget.selectedFilter;
    selectedDateRange = widget.selectedDateRange;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.w),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Filter Analytics',
                style: GoogleFonts.inter(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w600,
                  color: AppTheme.primaryText)),
              IconButton(
                onPressed: () => Navigator.pop(context),
                icon: Icon(
                  Icons.close_rounded,
                  color: AppTheme.secondaryText,
                  size: 24.sp)),
            ]),
          SizedBox(height: 20.h),
          _buildFilterSection(
            'Date Range',
            _buildDateRangeOptions()),
          SizedBox(height: 20.h),
          _buildFilterSection(
            'Traffic Source',
            _buildTrafficSourceOptions()),
          SizedBox(height: 20.h),
          _buildFilterSection(
            'Device Type',
            _buildDeviceOptions()),
          SizedBox(height: 20.h),
          _buildFilterSection(
            'Location',
            _buildLocationOptions()),
          SizedBox(height: 24.h),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () => _resetFilters(),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppTheme.primaryText,
                    side: BorderSide(color: AppTheme.border),
                    padding: EdgeInsets.symmetric(vertical: 12.h),
                    shape: RoundedRectangleBorder()),
                  child: Text(
                    'Reset',
                    style: GoogleFonts.inter(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w500)))),
              SizedBox(width: 12.w),
              Expanded(
                child: ElevatedButton(
                  onPressed: () => _applyFilters(),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.primaryAction,
                    foregroundColor: AppTheme.primaryBackground,
                    padding: EdgeInsets.symmetric(vertical: 12.h),
                    shape: RoundedRectangleBorder()),
                  child: Text(
                    'Apply Filters',
                    style: GoogleFonts.inter(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w500)))),
            ]),
          SizedBox(height: 20.h),
        ]));
  }

  Widget _buildFilterSection(String title, Widget content) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: GoogleFonts.inter(
            fontSize: 14.sp,
            fontWeight: FontWeight.w600,
            color: AppTheme.primaryText)),
        SizedBox(height: 12.h),
        content,
      ]);
  }

  Widget _buildDateRangeOptions() {
    return Wrap(
      spacing: 8.w,
      runSpacing: 8.h,
      children: [
        _buildFilterChip('24h', 'Last 24 Hours', selectedDateRange == '24h', (value) {
          setState(() {
            selectedDateRange = value ? '24h' : 'all';
          });
        }),
        _buildFilterChip('7d', '7 Days', selectedDateRange == '7d', (value) {
          setState(() {
            selectedDateRange = value ? '7d' : 'all';
          });
        }),
        _buildFilterChip('30d', '30 Days', selectedDateRange == '30d', (value) {
          setState(() {
            selectedDateRange = value ? '30d' : 'all';
          });
        }),
        _buildFilterChip('90d', '90 Days', selectedDateRange == '90d', (value) {
          setState(() {
            selectedDateRange = value ? '90d' : 'all';
          });
        }),
      ]);
  }

  Widget _buildTrafficSourceOptions() {
    return Wrap(
      spacing: 8.w,
      runSpacing: 8.h,
      children: [
        _buildFilterChip('direct', 'Direct', selectedTrafficSource == 'direct', (value) {
          setState(() {
            selectedTrafficSource = value ? 'direct' : 'all';
          });
        }),
        _buildFilterChip('social', 'Social Media', selectedTrafficSource == 'social', (value) {
          setState(() {
            selectedTrafficSource = value ? 'social' : 'all';
          });
        }),
        _buildFilterChip('search', 'Search Engine', selectedTrafficSource == 'search', (value) {
          setState(() {
            selectedTrafficSource = value ? 'search' : 'all';
          });
        }),
        _buildFilterChip('referral', 'Referral', selectedTrafficSource == 'referral', (value) {
          setState(() {
            selectedTrafficSource = value ? 'referral' : 'all';
          });
        }),
      ]);
  }

  Widget _buildDeviceOptions() {
    return Wrap(
      spacing: 8.w,
      runSpacing: 8.h,
      children: [
        _buildFilterChip('mobile', 'Mobile', selectedDevice == 'mobile', (value) {
          setState(() {
            selectedDevice = value ? 'mobile' : 'all';
          });
        }),
        _buildFilterChip('desktop', 'Desktop', selectedDevice == 'desktop', (value) {
          setState(() {
            selectedDevice = value ? 'desktop' : 'all';
          });
        }),
        _buildFilterChip('tablet', 'Tablet', selectedDevice == 'tablet', (value) {
          setState(() {
            selectedDevice = value ? 'tablet' : 'all';
          });
        }),
      ]);
  }

  Widget _buildLocationOptions() {
    return Wrap(
      spacing: 8.w,
      runSpacing: 8.h,
      children: [
        _buildFilterChip('us', 'United States', selectedLocation == 'us', (value) {
          setState(() {
            selectedLocation = value ? 'us' : 'all';
          });
        }),
        _buildFilterChip('uk', 'United Kingdom', selectedLocation == 'uk', (value) {
          setState(() {
            selectedLocation = value ? 'uk' : 'all';
          });
        }),
        _buildFilterChip('ca', 'Canada', selectedLocation == 'ca', (value) {
          setState(() {
            selectedLocation = value ? 'ca' : 'all';
          });
        }),
        _buildFilterChip('au', 'Australia', selectedLocation == 'au', (value) {
          setState(() {
            selectedLocation = value ? 'au' : 'all';
          });
        }),
      ]);
  }

  Widget _buildFilterChip(String value, String label, bool isSelected, Function(bool) onChanged) {
    return GestureDetector(
      onTap: () => onChanged(!isSelected),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
        decoration: BoxDecoration(
          color: isSelected ? AppTheme.accent.withValues(alpha: 0.1) : AppTheme.primaryBackground,
          
          border: Border.all(
            color: isSelected ? AppTheme.accent : AppTheme.border,
            width: 1)),
        child: Text(
          label,
          style: GoogleFonts.inter(
            fontSize: 12.sp,
            fontWeight: FontWeight.w500,
            color: isSelected ? AppTheme.accent : AppTheme.secondaryText))));
  }

  void _resetFilters() {
    setState(() {
      selectedFilter = 'all';
      selectedDateRange = '7d';
      selectedTrafficSource = 'all';
      selectedDevice = 'all';
      selectedLocation = 'all';
    });
  }

  void _applyFilters() {
    widget.onFilterChanged(selectedFilter);
    widget.onDateRangeChanged(selectedDateRange);
    Navigator.pop(context);
  }
}