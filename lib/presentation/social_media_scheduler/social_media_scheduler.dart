
import '../../core/app_export.dart';
import '../../services/dynamic_data_service.dart';
import './widgets/add_post_modal.dart';
import './widgets/bulk_upload_modal.dart';
import './widgets/calendar_widget.dart';
import './widgets/day_posts_bottom_sheet.dart';
import './widgets/platform_status_widget.dart';

class SocialMediaScheduler extends StatefulWidget {
  const SocialMediaScheduler({Key? key}) : super(key: key);

  @override
  State<SocialMediaScheduler> createState() => _SocialMediaSchedulerState();
}

class _SocialMediaSchedulerState extends State<SocialMediaScheduler>
    with TickerProviderStateMixin {
  late TabController _tabController;
  DateTime _selectedDate = DateTime.now();
  DateTime _currentMonth = DateTime.now();
  bool _isWeekView = false;
  bool _isLoading = true;

  // Dynamic data from Supabase
  Map<String, List<Map<String, dynamic>>> _scheduledPosts = {};
  Map<String, Map<String, dynamic>> _platformStatus = {};
  String _workspaceId = 'demo-workspace-id'; // This should come from user context

  final DynamicDataService _dataService = DynamicDataService();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _loadSchedulerData();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _loadSchedulerData() async {
    try {
      setState(() => _isLoading = true);
      
      final data = await _dataService.getSocialMediaSchedulerData(_workspaceId);
      
      final posts = data['posts'] as List? ?? [];
      final platforms = data['platforms'] as List? ?? [];
      
      // Group posts by date
      final groupedPosts = <String, List<Map<String, dynamic>>>{};
      for (var post in posts) {
        final scheduledFor = post['scheduled_for'] ?? post['created_at'];
        if (scheduledFor != null) {
          final date = DateTime.parse(scheduledFor);
          final dateKey = '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
          
          groupedPosts[dateKey] ??= [];
          groupedPosts[dateKey]!.add({
            'id': post['id'],
            'platform': post['platform'],
            'content': post['content'],
            'imageUrl': post['media_urls']?.isNotEmpty == true ? post['media_urls'][0] : null,
            'scheduledTime': _formatTime(date),
            'status': post['status'] ?? 'scheduled',
            'engagement': {
              'likes': post['likes_count'] ?? 0,
              'comments': post['comments_count'] ?? 0,
              'shares': post['shares_count'] ?? 0,
            }
          });
        }
      }
      
      // Process platform status
      final platformStatusData = <String, Map<String, dynamic>>{};
      for (var platform in platforms) {
        platformStatusData[platform['platform_name']] = {
          'connected': platform['is_active'] ?? false,
          'account': platform['account_name'],
        };
      }
      
      // Add default platforms if not present
      final defaultPlatforms = ['instagram', 'facebook', 'twitter', 'linkedin', 'tiktok', 'youtube'];
      for (var platform in defaultPlatforms) {
        platformStatusData[platform] ??= {
          'connected': false,
          'account': null,
        };
      }
      
      setState(() {
        _scheduledPosts = groupedPosts;
        _platformStatus = platformStatusData;
        _isLoading = false;
      });
    } catch (error) {
      print('Error loading scheduler data: $error');
      setState(() {
        _isLoading = false;
        _scheduledPosts = {};
        _platformStatus = _getDefaultPlatformStatus();
      });
    }
  }

  Map<String, Map<String, dynamic>> _getDefaultPlatformStatus() {
    return {
      'instagram': {'connected': false, 'account': null},
      'facebook': {'connected': false, 'account': null},
      'twitter': {'connected': false, 'account': null},
      'linkedin': {'connected': false, 'account': null},
      'tiktok': {'connected': false, 'account': null},
      'youtube': {'connected': false, 'account': null},
    };
  }

  String _formatTime(DateTime dateTime) {
    final hour = dateTime.hour;
    final minute = dateTime.minute.toString().padLeft(2, '0');
    final period = hour >= 12 ? 'PM' : 'AM';
    final displayHour = hour > 12 ? hour - 12 : (hour == 0 ? 12 : hour);
    return '$displayHour:$minute $period';
  }

  void _onDateSelected(DateTime date) {
    setState(() {
      _selectedDate = date;
    });
    _showDayPostsBottomSheet(date);
  }

  void _showDayPostsBottomSheet(DateTime date) {
    final dateKey =
        '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
    final posts = _scheduledPosts[dateKey] ?? [];

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => DayPostsBottomSheet(
        date: date,
        posts: posts,
        onEditPost: _editPost,
        onDeletePost: _deletePost,
        onRetryPost: _retryPost,
      ),
    );
  }

  void _showAddPostModal() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => AddPostModal(
        onPostScheduled: _addScheduledPost,
      ),
    );
  }

  void _showBulkUploadModal() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => BulkUploadModal(
        onBulkUpload: _handleBulkUpload,
      ),
    );
  }

  void _addScheduledPost(Map<String, dynamic> postData) {
    final dateKey = postData['dateKey'] as String;
    setState(() {
      if (_scheduledPosts[dateKey] == null) {
        _scheduledPosts[dateKey] = [];
      }
      _scheduledPosts[dateKey]!.add(postData);
    });
  }

  void _editPost(String postId) {
    // Find and edit post logic
    HapticFeedback.lightImpact();
    // Implementation for editing post
  }

  void _deletePost(String postId) {
    HapticFeedback.mediumImpact();
    setState(() {
      _scheduledPosts.forEach((key, posts) {
        posts.removeWhere((post) => post['id'] == postId);
      });
    });
  }

  void _retryPost(String postId) {
    HapticFeedback.lightImpact();
    setState(() {
      _scheduledPosts.forEach((key, posts) {
        for (var post in posts) {
          if (post['id'] == postId) {
            post['status'] = 'scheduled';
            break;
          }
        }
      });
    });
  }

  void _handleBulkUpload(List<Map<String, dynamic>> posts) {
    setState(() {
      for (var post in posts) {
        final dateKey = post['dateKey'] as String;
        if (_scheduledPosts[dateKey] == null) {
          _scheduledPosts[dateKey] = [];
        }
        _scheduledPosts[dateKey]!.add(post);
      }
    });
  }

  void _togglePlatformConnection(String platform) {
    setState(() {
      _platformStatus[platform]!['connected'] =
          !_platformStatus[platform]!['connected'];
    });
  }

  Future<void> _refreshData() async {
    await _loadSchedulerData();
  }

  void _goToToday() {
    setState(() {
      _selectedDate = DateTime.now();
      _currentMonth = DateTime.now();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.primaryBackground,
      appBar: AppBar(
        backgroundColor: AppTheme.primaryBackground,
        elevation: 0,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: CustomIconWidget(
            iconName: 'arrow_back',
            color: AppTheme.primaryText,
            size: 24,
          ),
        ),
        title: Text(
          'Social Media Scheduler',
          style: AppTheme.darkTheme.textTheme.titleLarge,
        ),
        actions: [
          IconButton(
            onPressed: _showBulkUploadModal,
            icon: CustomIconWidget(
              iconName: 'upload_file',
              color: AppTheme.primaryText,
              size: 24,
            ),
          ),
          IconButton(
            onPressed: () {
              // Navigate to analytics
              Navigator.pushNamed(context, '/analytics-dashboard');
            },
            icon: CustomIconWidget(
              iconName: 'analytics',
              color: AppTheme.primaryText,
              size: 24,
            ),
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Calendar'),
            Tab(text: 'Posts'),
          ],
        ),
      ),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(
                color: AppTheme.accent,
              ),
            )
          : RefreshIndicator(
              onRefresh: _refreshData,
              color: AppTheme.accent,
              backgroundColor: AppTheme.surface,
              child: TabBarView(
                controller: _tabController,
                children: [
                  _buildCalendarView(),
                  _buildPostsView(),
                ],
              ),
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddPostModal,
        backgroundColor: AppTheme.primaryAction,
        foregroundColor: AppTheme.primaryBackground,
        child: CustomIconWidget(
          iconName: 'add',
          color: AppTheme.primaryBackground,
          size: 24,
        ),
      ),
    );
  }

  Widget _buildCalendarView() {
    return Column(
      children: [
        // Calendar header controls
        Container(
          padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
          decoration: BoxDecoration(
            color: AppTheme.surface,
            border: Border(
              bottom: BorderSide(
                color: AppTheme.border,
                width: 1,
              ),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  IconButton(
                    onPressed: () {
                      setState(() {
                        _currentMonth = DateTime(
                          _currentMonth.year,
                          _currentMonth.month - 1,
                        );
                      });
                    },
                    icon: CustomIconWidget(
                      iconName: 'chevron_left',
                      color: AppTheme.primaryText,
                      size: 24,
                    ),
                  ),
                  Text(
                    '${_getMonthName(_currentMonth.month)} ${_currentMonth.year}',
                    style: AppTheme.darkTheme.textTheme.titleMedium,
                  ),
                  IconButton(
                    onPressed: () {
                      setState(() {
                        _currentMonth = DateTime(
                          _currentMonth.year,
                          _currentMonth.month + 1,
                        );
                      });
                    },
                    icon: CustomIconWidget(
                      iconName: 'chevron_right',
                      color: AppTheme.primaryText,
                      size: 24,
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  TextButton(
                    onPressed: _goToToday,
                    child: Text(
                      'Today',
                      style: AppTheme.darkTheme.textTheme.labelLarge?.copyWith(
                        color: AppTheme.accent,
                      ),
                    ),
                  ),
                  SizedBox(width: 2.w),
                  Container(
                    decoration: BoxDecoration(
                      color: AppTheme.surface,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: AppTheme.border),
                    ),
                    child: Row(
                      children: [
                        _buildViewToggleButton('Month', !_isWeekView),
                        _buildViewToggleButton('Week', _isWeekView),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),

        // Calendar widget
        Expanded(
          flex: 3,
          child: CalendarWidget(
            currentMonth: _currentMonth,
            selectedDate: _selectedDate,
            scheduledPosts: _scheduledPosts,
            isWeekView: _isWeekView,
            onDateSelected: _onDateSelected,
            onMonthChanged: (month) {
              setState(() {
                _currentMonth = month;
              });
            },
          ),
        ),

        // Platform status section
        Container(
          height: 12.h,
          padding: EdgeInsets.symmetric(vertical: 1.h),
          decoration: BoxDecoration(
            color: AppTheme.surface,
            border: Border(
              top: BorderSide(
                color: AppTheme.border,
                width: 1,
              ),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 4.w),
                child: Text(
                  'Connected Platforms',
                  style: AppTheme.darkTheme.textTheme.titleSmall,
                ),
              ),
              SizedBox(height: 1.h),
              Expanded(
                child: PlatformStatusWidget(
                  platformStatus: _platformStatus,
                  onToggleConnection: _togglePlatformConnection,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildPostsView() {
    final allPosts = <Map<String, dynamic>>[];
    _scheduledPosts.forEach((date, posts) {
      for (var post in posts) {
        allPosts.add({
          ...post,
          'date': date,
        });
      }
    });

    allPosts.sort((a, b) {
      final aDate = DateTime.parse(a['date']);
      final bDate = DateTime.parse(b['date']);
      return aDate.compareTo(bDate);
    });

    return allPosts.isEmpty
        ? _buildEmptyState()
        : ListView.builder(
            padding: EdgeInsets.all(4.w),
            itemCount: allPosts.length,
            itemBuilder: (context, index) {
              final post = allPosts[index];
              return _buildPostCard(post);
            },
          );
  }

  Widget _buildPostCard(Map<String, dynamic> post) {
    final platformColor = _getPlatformColor(post['platform']);
    final statusColor = _getStatusColor(post['status']);

    return Container(
      margin: EdgeInsets.only(bottom: 3.h),
      decoration: BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppTheme.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Post header
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
                        '${post['date']} • ${post['scheduledTime']}',
                        style: AppTheme.darkTheme.textTheme.bodySmall,
                      ),
                    ],
                  ),
                ),
                Container(
                  padding:
                      EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.5.h),
                  decoration: BoxDecoration(
                    color: statusColor.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    post['status'].toString().toUpperCase(),
                    style: AppTheme.darkTheme.textTheme.labelSmall?.copyWith(
                      color: statusColor,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Post content
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
                      height: 20.h,
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
                SizedBox(height: 2.h),

                // Engagement metrics
                if (post['status'] == 'posted') ...[
                  Row(
                    children: [
                      _buildEngagementMetric(
                        'favorite',
                        post['engagement']['likes'].toString(),
                      ),
                      SizedBox(width: 4.w),
                      _buildEngagementMetric(
                        'comment',
                        post['engagement']['comments'].toString(),
                      ),
                      SizedBox(width: 4.w),
                      _buildEngagementMetric(
                        'share',
                        post['engagement']['shares'].toString(),
                      ),
                    ],
                  ),
                ] else if (post['status'] == 'failed') ...[
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          'Post failed to publish',
                          style:
                              AppTheme.darkTheme.textTheme.bodySmall?.copyWith(
                            color: AppTheme.error,
                          ),
                        ),
                      ),
                      TextButton(
                        onPressed: () => _retryPost(post['id']),
                        child: Text(
                          'Retry',
                          style: AppTheme.darkTheme.textTheme.labelMedium
                              ?.copyWith(
                            color: AppTheme.accent,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEngagementMetric(String iconName, String value) {
    return Row(
      children: [
        CustomIconWidget(
          iconName: iconName,
          color: AppTheme.secondaryText,
          size: 16,
        ),
        SizedBox(width: 1.w),
        Text(
          value,
          style: AppTheme.darkTheme.textTheme.bodySmall,
        ),
      ],
    );
  }

  Widget _buildViewToggleButton(String text, bool isSelected) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _isWeekView = text == 'Week';
        });
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
        decoration: BoxDecoration(
          color: isSelected ? AppTheme.accent : Colors.transparent,
          borderRadius: BorderRadius.circular(6),
        ),
        child: Text(
          text,
          style: AppTheme.darkTheme.textTheme.labelMedium?.copyWith(
            color: isSelected ? AppTheme.primaryAction : AppTheme.secondaryText,
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CustomIconWidget(
            iconName: 'calendar_today',
            color: AppTheme.secondaryText,
            size: 64,
          ),
          SizedBox(height: 2.h),
          Text(
            'No posts scheduled',
            style: AppTheme.darkTheme.textTheme.titleMedium?.copyWith(
              color: AppTheme.secondaryText,
            ),
          ),
          SizedBox(height: 1.h),
          Text(
            'Create your first post to get started',
            style: AppTheme.darkTheme.textTheme.bodyMedium?.copyWith(
              color: AppTheme.secondaryText,
            ),
          ),
          SizedBox(height: 3.h),
          ElevatedButton(
            onPressed: _showAddPostModal,
            child: Text('Create Post'),
          ),
        ],
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

  Color _getStatusColor(String status) {
    switch (status) {
      case 'scheduled':
        return AppTheme.warning;
      case 'posted':
        return AppTheme.success;
      case 'failed':
        return AppTheme.error;
      default:
        return AppTheme.secondaryText;
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

  String _getMonthName(int month) {
    const months = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December'
    ];
    return months[month - 1];
  }
}