import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sizer/sizer.dart';

import '../social_media_scheduler/widgets/add_post_modal.dart';
import '../social_media_scheduler/widgets/bulk_upload_modal.dart';
import '../social_media_scheduler/widgets/day_posts_bottom_sheet.dart';
import '../social_media_scheduler/widgets/platform_status_widget.dart';
import './widgets/calendar_widget.dart';

class SocialMediaSchedulerScreen extends StatefulWidget {
  const SocialMediaSchedulerScreen({Key? key}) : super(key: key);

  @override
  State<SocialMediaSchedulerScreen> createState() =>
      _SocialMediaSchedulerScreenState();
}

class _SocialMediaSchedulerScreenState extends State<SocialMediaSchedulerScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  bool _isMonthView = true;
  DateTime _selectedDate = DateTime.now();
  final List<Map<String, dynamic>> _scheduledPosts = [];
  final List<Map<String, dynamic>> _platforms = [
{ 'name': 'Instagram',
'connected': true,
'color': Colors.pink,
'icon': Icons.camera_alt },
{ 'name': 'Facebook',
'connected': true,
'color': Colors.blue,
'icon': Icons.facebook },
{ 'name': 'Twitter',
'connected': false,
'color': Colors.lightBlue,
'icon': Icons.alternate_email },
{ 'name': 'LinkedIn',
'connected': true,
'color': Colors.indigo,
'icon': Icons.business },
{ 'name': 'TikTok',
'connected': false,
'color': Colors.black,
'icon': Icons.music_note },
{ 'name': 'YouTube',
'connected': true,
'color': Colors.red,
'icon': Icons.play_arrow },
];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _loadScheduledPosts();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _loadScheduledPosts() {
    // Mock data for scheduled posts
    setState(() {
      _scheduledPosts.addAll([
        {
          'id': '1',
          'platform': 'Instagram',
          'content': 'Check out our new product launch! #NewProduct #Launch',
          'media':
              'https://images.pexels.com/photos/267389/pexels-photo-267389.jpeg',
          'scheduledDate': DateTime.now().add(Duration(days: 1)),
          'status': 'scheduled',
          'color': Colors.pink,
        },
        {
          'id': '2',
          'platform': 'Facebook',
          'content':
              'Join us for our upcoming webinar on digital marketing strategies.',
          'media':
              'https://images.pexels.com/photos/3184292/pexels-photo-3184292.jpeg',
          'scheduledDate': DateTime.now().add(Duration(days: 2)),
          'status': 'scheduled',
          'color': Colors.blue,
        },
        {
          'id': '3',
          'platform': 'LinkedIn',
          'content':
              'Sharing insights on the latest industry trends and best practices.',
          'media': null,
          'scheduledDate': DateTime.now().add(Duration(days: 3)),
          'status': 'scheduled',
          'color': Colors.indigo,
        },
      ]);
    });
  }

  void _showAddPostModal() {
    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        builder: (context) => AddPostModal(onPostScheduled: (postData) {
              setState(() {
                _scheduledPosts.add(postData);
              });
              HapticFeedback.lightImpact();
            }));
  }

  void _showBulkUploadModal() {
    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        builder: (context) => BulkUploadModal(onBulkUpload: (posts) {
              setState(() {
                _scheduledPosts.addAll(posts);
              });
            }));
  }

  void _showDayPosts(DateTime date) {
    final dayPosts = _scheduledPosts.where((post) {
      final postDate = post['scheduledDate'] as DateTime;
      return postDate.year == date.year &&
          postDate.month == date.month &&
          postDate.day == date.day;
    }).toList();

    if (dayPosts.isNotEmpty) {
      showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          backgroundColor: Colors.transparent,
          builder: (context) => DayPostsBottomSheet(
              date: date,
              posts: dayPosts,
              onDeletePost: (_) {},
              onEditPost: (_) {},
              onRetryPost: (_) {}));
    }
  }

  void _togglePlatformConnection(int index) {
    setState(() {
      _platforms[index]['connected'] = !_platforms[index]['connected'];
    });
    HapticFeedback.selectionClick();
  }

  Widget _buildHeader() {
    return Container(
        padding: EdgeInsets.fromLTRB(4.w, 2.h, 4.w, 1.h),
        decoration: BoxDecoration(
            color: Color(0xFF191919),
            border:
                Border(bottom: BorderSide(color: Color(0xFF282828), width: 1))),
        child: Row(children: [
          IconButton(
              onPressed: () => Navigator.pop(context),
              icon: Icon(Icons.arrow_back_ios,
                  color: Color(0xFFF1F1F1), size: 20.sp)),
          SizedBox(width: 2.w),
          Text('Social Media Scheduler',
              style: GoogleFonts.inter(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFFF1F1F1))),
          Spacer(),
          IconButton(
              onPressed: _showBulkUploadModal,
              icon: Icon(Icons.upload_file,
                  color: Color(0xFFF1F1F1), size: 20.sp)),
        ]));
  }

  Widget _buildViewToggle() {
    return Container(
        margin: EdgeInsets.fromLTRB(4.w, 2.h, 4.w, 1.h),
        child: Row(children: [
          Container(
              decoration: BoxDecoration(
                  color: Color(0xFF191919),
                  borderRadius: BorderRadius.circular(8.sp),
                  border: Border.all(color: Color(0xFF282828), width: 1)),
              child: Row(children: [
                GestureDetector(
                    onTap: () {
                      setState(() {
                        _isMonthView = true;
                      });
                      HapticFeedback.selectionClick();
                    },
                    child: Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: 4.w, vertical: 1.h),
                        decoration: BoxDecoration(
                            color: _isMonthView
                                ? Color(0xFFDDDDDD)
                                : Colors.transparent,
                            borderRadius: BorderRadius.circular(6.sp)),
                        child: Text('Month',
                            style: GoogleFonts.inter(
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w500,
                                color: _isMonthView
                                    ? Color(0xFF141414)
                                    : Color(0xFFF1F1F1))))),
                GestureDetector(
                    onTap: () {
                      setState(() {
                        _isMonthView = false;
                      });
                      HapticFeedback.selectionClick();
                    },
                    child: Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: 4.w, vertical: 1.h),
                        decoration: BoxDecoration(
                            color: !_isMonthView
                                ? Color(0xFFDDDDDD)
                                : Colors.transparent,
                            borderRadius: BorderRadius.circular(6.sp)),
                        child: Text('Week',
                            style: GoogleFonts.inter(
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w500,
                                color: !_isMonthView
                                    ? Color(0xFF141414)
                                    : Color(0xFFF1F1F1))))),
              ])),
          Spacer(),
          GestureDetector(
              onTap: () {
                setState(() {
                  _selectedDate = DateTime.now();
                });
                HapticFeedback.selectionClick();
              },
              child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
                  decoration: BoxDecoration(
                      color: Color(0xFF191919),
                      borderRadius: BorderRadius.circular(8.sp),
                      border: Border.all(color: Color(0xFF282828), width: 1)),
                  child: Text('Today',
                      style: GoogleFonts.inter(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w500,
                          color: Color(0xFFF1F1F1))))),
        ]));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color(0xFF101010),
        body: Column(children: [
          _buildHeader(),
          _buildViewToggle(),
          Expanded(
              child: RefreshIndicator(
                  onRefresh: () async {
                    await Future.delayed(Duration(milliseconds: 500));
                    _loadScheduledPosts();
                    HapticFeedback.lightImpact();
                  },
                  backgroundColor: Color(0xFF191919),
                  color: Color(0xFFF1F1F1),
                  child: SingleChildScrollView(
                      physics: AlwaysScrollableScrollPhysics(),
                      child: Column(children: [
                        CalendarWidget(
                            isMonthView: _isMonthView,
                            selectedDate: _selectedDate,
                            scheduledPosts: _scheduledPosts,
                            onDateSelected: (date) {
                              setState(() {
                                _selectedDate = date;
                              });
                              _showDayPosts(date);
                            }),
                        SizedBox(height: 3.h),
                        PlatformStatusWidget(
                            platformStatus: _platforms.asMap().map((index, platform) => 
                                MapEntry(platform['name'] as String, platform)),
                            onToggleConnection: (String platformName) {
                              int index = _platforms.indexWhere((platform) =>
                                  platform['name'] == platformName);
                              if (index != -1) {
                                _togglePlatformConnection(index);
                              }
                            }),
                        SizedBox(height: 10.h),
                      ])))),
        ]),
        floatingActionButton: FloatingActionButton(
            onPressed: _showAddPostModal,
            backgroundColor: Color(0xFFFDFDFD),
            child: Icon(Icons.add, color: Color(0xFF141414), size: 24.sp)));
  }
}