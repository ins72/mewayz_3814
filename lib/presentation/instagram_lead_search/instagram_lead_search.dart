import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/export_bottom_sheet_widget.dart';
import './widgets/filter_chip_widget.dart';
import './widgets/filter_modal_widget.dart';
import './widgets/instagram_account_card_widget.dart';
import './widgets/skeleton_card_widget.dart';

class InstagramLeadSearch extends StatefulWidget {
  const InstagramLeadSearch({Key? key}) : super(key: key);

  @override
  State<InstagramLeadSearch> createState() => _InstagramLeadSearchState();
}

class _InstagramLeadSearchState extends State<InstagramLeadSearch> {
  final TextEditingController _searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  bool _isLoading = false;
  bool _isLoadingMore = false;
  List<Map<String, dynamic>> _accounts = [];
  List<Map<String, dynamic>> _activeFilters = [];
  int _currentPage = 1;
  bool _hasMoreData = true;

  @override
  void initState() {
    super.initState();
    _loadInitialData();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _searchController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _loadInitialData() {
    setState(() {
      _isLoading = true;
    });

    // Mock data for Instagram accounts
    _accounts = [
      {
        "id": "1",
        "username": "fitness_guru_mike",
        "profileImage":
            "https://images.pexels.com/photos/1043471/pexels-photo-1043471.jpeg?auto=compress&cs=tinysrgb&w=400",
        "followerCount": 125000,
        "engagementRate": 4.2,
        "bio":
            "💪 Fitness coach & nutritionist | Transform your body in 90 days | DM for coaching",
        "isVerified": true,
        "accountType": "Business",
        "location": "Los Angeles, CA",
        "postsCount": 1250,
        "followingCount": 890,
        "email": "mike@fitnessguru.com",
        "lastPostDate": DateTime.now().subtract(Duration(hours: 2)),
      },
      {
        "id": "2",
        "username": "travel_wanderlust",
        "profileImage":
            "https://images.pexels.com/photos/1239291/pexels-photo-1239291.jpeg?auto=compress&cs=tinysrgb&w=400",
        "followerCount": 89000,
        "engagementRate": 6.8,
        "bio":
            "✈️ Travel blogger | 50+ countries explored | Photography tips & travel guides",
        "isVerified": false,
        "accountType": "Creator",
        "location": "New York, NY",
        "postsCount": 2100,
        "followingCount": 1200,
        "email": "hello@travelwanderlust.com",
        "lastPostDate": DateTime.now().subtract(Duration(hours: 5)),
      },
      {
        "id": "3",
        "username": "foodie_delights",
        "profileImage":
            "https://images.pexels.com/photos/1181690/pexels-photo-1181690.jpeg?auto=compress&cs=tinysrgb&w=400",
        "followerCount": 67000,
        "engagementRate": 5.4,
        "bio":
            "🍕 Food enthusiast | Restaurant reviews | Recipe creator | Foodie adventures",
        "isVerified": false,
        "accountType": "Personal",
        "location": "Chicago, IL",
        "postsCount": 890,
        "followingCount": 450,
        "email": "contact@foodiedelights.com",
        "lastPostDate": DateTime.now().subtract(Duration(hours: 1)),
      },
      {
        "id": "4",
        "username": "tech_innovator",
        "profileImage":
            "https://images.pexels.com/photos/1181244/pexels-photo-1181244.jpeg?auto=compress&cs=tinysrgb&w=400",
        "followerCount": 156000,
        "engagementRate": 3.9,
        "bio":
            "💻 Tech entrepreneur | AI & blockchain insights | Startup mentor | Speaker",
        "isVerified": true,
        "accountType": "Business",
        "location": "San Francisco, CA",
        "postsCount": 567,
        "followingCount": 234,
        "email": "info@techinnovator.com",
        "lastPostDate": DateTime.now().subtract(Duration(hours: 3)),
      },
      {
        "id": "5",
        "username": "fashion_stylist_pro",
        "profileImage":
            "https://images.pexels.com/photos/1181686/pexels-photo-1181686.jpeg?auto=compress&cs=tinysrgb&w=400",
        "followerCount": 203000,
        "engagementRate": 7.2,
        "bio":
            "👗 Fashion stylist | Celebrity clients | Style tips & trends | Book consultations",
        "isVerified": true,
        "accountType": "Business",
        "location": "Miami, FL",
        "postsCount": 1890,
        "followingCount": 678,
        "email": "bookings@fashionstylistpro.com",
        "lastPostDate": DateTime.now().subtract(Duration(minutes: 45)),
      },
    ];

    _activeFilters = [
      {"type": "follower_range", "label": "50K - 200K followers", "count": 1},
      {"type": "engagement", "label": "High engagement", "count": 1},
      {"type": "location", "label": "United States", "count": 1},
    ];

    Future.delayed(Duration(milliseconds: 1500), () {
      setState(() {
        _isLoading = false;
      });
    });
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      if (!_isLoadingMore && _hasMoreData) {
        _loadMoreData();
      }
    }
  }

  void _loadMoreData() {
    setState(() {
      _isLoadingMore = true;
    });

    Future.delayed(Duration(milliseconds: 1000), () {
      if (mounted) {
        setState(() {
          _currentPage++;
          _isLoadingMore = false;
          if (_currentPage >= 3) {
            _hasMoreData = false;
          }
        });
      }
    });
  }

  Future<void> _onRefresh() async {
    HapticFeedback.lightImpact();
    setState(() {
      _currentPage = 1;
      _hasMoreData = true;
    });
    await Future.delayed(Duration(milliseconds: 1000));
    _loadInitialData();
  }

  void _removeFilter(int index) {
    HapticFeedback.selectionClick();
    setState(() {
      _activeFilters.removeAt(index);
    });
  }

  void _showFilterModal() {
    HapticFeedback.mediumImpact();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => FilterModalWidget(
        onFiltersApplied: (filters) {
          setState(() {
            _activeFilters = filters;
          });
        },
        currentFilters: _activeFilters,
      ),
    );
  }

  void _showExportBottomSheet() {
    HapticFeedback.mediumImpact();
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => ExportBottomSheetWidget(
        accounts: _accounts,
      ),
    );
  }

  void _onSearchChanged(String value) {
    // Implement search functionality
  }

  void _onVoiceSearch() {
    HapticFeedback.selectionClick();
    // Implement voice search functionality
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.primaryBackground,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
            _buildSearchBar(),
            if (_activeFilters.isNotEmpty) _buildFilterChips(),
            Expanded(
              child: _buildAccountsList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
      child: Row(
        children: [
          GestureDetector(
            onTap: () {
              HapticFeedback.selectionClick();
              Navigator.pop(context);
            },
            child: Container(
              padding: EdgeInsets.all(2.w),
              child: CustomIconWidget(
                iconName: 'arrow_back',
                color: AppTheme.primaryText,
                size: 6.w,
              ),
            ),
          ),
          Expanded(
            child: Text(
              'Instagram Lead Search',
              style: AppTheme.darkTheme.textTheme.titleLarge,
              textAlign: TextAlign.center,
            ),
          ),
          Row(
            children: [
              GestureDetector(
                onTap: _showFilterModal,
                child: Container(
                  padding: EdgeInsets.all(2.w),
                  child: CustomIconWidget(
                    iconName: 'filter_list',
                    color: AppTheme.primaryText,
                    size: 6.w,
                  ),
                ),
              ),
              SizedBox(width: 2.w),
              GestureDetector(
                onTap: _showExportBottomSheet,
                child: Container(
                  padding: EdgeInsets.all(2.w),
                  child: CustomIconWidget(
                    iconName: 'file_download',
                    color: AppTheme.primaryText,
                    size: 6.w,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
      child: TextField(
        controller: _searchController,
        onChanged: _onSearchChanged,
        style: AppTheme.darkTheme.textTheme.bodyMedium,
        decoration: InputDecoration(
          hintText: 'Search by username, bio, hashtag',
          prefixIcon: Padding(
            padding: EdgeInsets.all(3.w),
            child: CustomIconWidget(
              iconName: 'search',
              color: AppTheme.secondaryText,
              size: 5.w,
            ),
          ),
          suffixIcon: GestureDetector(
            onTap: _onVoiceSearch,
            child: Padding(
              padding: EdgeInsets.all(3.w),
              child: CustomIconWidget(
                iconName: 'mic',
                color: AppTheme.accent,
                size: 5.w,
              ),
            ),
          ),
          filled: true,
          fillColor: AppTheme.surface,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(3.w),
            borderSide: BorderSide(color: AppTheme.border),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(3.w),
            borderSide: BorderSide(color: AppTheme.border),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(3.w),
            borderSide: BorderSide(color: AppTheme.accent, width: 2),
          ),
        ),
      ),
    );
  }

  Widget _buildFilterChips() {
    return Container(
      height: 6.h,
      margin: EdgeInsets.only(bottom: 1.h),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(horizontal: 4.w),
        itemCount: _activeFilters.length,
        itemBuilder: (context, index) {
          return FilterChipWidget(
            filter: _activeFilters[index],
            onRemove: () => _removeFilter(index),
          );
        },
      ),
    );
  }

  Widget _buildAccountsList() {
    if (_isLoading) {
      return ListView.builder(
        padding: EdgeInsets.symmetric(horizontal: 4.w),
        itemCount: 5,
        itemBuilder: (context, index) => SkeletonCardWidget(),
      );
    }

    if (_accounts.isEmpty) {
      return _buildEmptyState();
    }

    return RefreshIndicator(
      onRefresh: _onRefresh,
      color: AppTheme.accent,
      backgroundColor: AppTheme.surface,
      child: ListView.builder(
        controller: _scrollController,
        padding: EdgeInsets.symmetric(horizontal: 4.w),
        itemCount: _accounts.length + (_isLoadingMore ? 1 : 0),
        itemBuilder: (context, index) {
          if (index == _accounts.length) {
            return _isLoadingMore ? SkeletonCardWidget() : SizedBox.shrink();
          }

          return InstagramAccountCardWidget(
            account: _accounts[index],
            onExport: () => _onAccountAction('export', _accounts[index]),
            onSave: () => _onAccountAction('save', _accounts[index]),
            onMessage: () => _onAccountAction('message', _accounts[index]),
            onLongPress: () => _showQuickActions(_accounts[index]),
          );
        },
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CustomIconWidget(
            iconName: 'search_off',
            color: AppTheme.secondaryText,
            size: 20.w,
          ),
          SizedBox(height: 3.h),
          Text(
            'No accounts found',
            style: AppTheme.darkTheme.textTheme.titleLarge,
          ),
          SizedBox(height: 1.h),
          Text(
            'Try adjusting your filters or search terms',
            style: AppTheme.darkTheme.textTheme.bodyMedium?.copyWith(
              color: AppTheme.secondaryText,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 3.h),
          ElevatedButton(
            onPressed: () {
              setState(() {
                _activeFilters.clear();
                _searchController.clear();
              });
              _loadInitialData();
            },
            child: Text('Clear Filters'),
          ),
        ],
      ),
    );
  }

  void _onAccountAction(String action, Map<String, dynamic> account) {
    HapticFeedback.selectionClick();
    String message = '';
    switch (action) {
      case 'export':
        message = 'Exported ${account['username']}';
        break;
      case 'save':
        message = 'Saved ${account['username']}';
        break;
      case 'message':
        message = 'Opening message for ${account['username']}';
        break;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: AppTheme.surface,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _showQuickActions(Map<String, dynamic> account) {
    HapticFeedback.mediumImpact();
    showModalBottomSheet(
      context: context,
      backgroundColor: AppTheme.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(5.w)),
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
                borderRadius: BorderRadius.circular(1.w),
              ),
            ),
            SizedBox(height: 3.h),
            ListTile(
              leading: CustomIconWidget(
                iconName: 'person',
                color: AppTheme.primaryText,
                size: 6.w,
              ),
              title: Text(
                'View Profile',
                style: AppTheme.darkTheme.textTheme.bodyLarge,
              ),
              onTap: () {
                Navigator.pop(context);
                _onAccountAction('view', account);
              },
            ),
            ListTile(
              leading: CustomIconWidget(
                iconName: 'playlist_add',
                color: AppTheme.primaryText,
                size: 6.w,
              ),
              title: Text(
                'Add to List',
                style: AppTheme.darkTheme.textTheme.bodyLarge,
              ),
              onTap: () {
                Navigator.pop(context);
                _onAccountAction('add_to_list', account);
              },
            ),
            ListTile(
              leading: CustomIconWidget(
                iconName: 'block',
                color: AppTheme.error,
                size: 6.w,
              ),
              title: Text(
                'Block',
                style: AppTheme.darkTheme.textTheme.bodyLarge?.copyWith(
                  color: AppTheme.error,
                ),
              ),
              onTap: () {
                Navigator.pop(context);
                _onAccountAction('block', account);
              },
            ),
            SizedBox(height: 2.h),
          ],
        ),
      ),
    );
  }
}
