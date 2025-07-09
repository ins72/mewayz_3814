
import '../../core/app_export.dart';
import './widgets/calendar_header_widget.dart';
import './widgets/content_filter_widget.dart';

class ContentCalendarScreen extends StatefulWidget {
  const ContentCalendarScreen({Key? key}) : super(key: key);

  @override
  State<ContentCalendarScreen> createState() => _ContentCalendarScreenState();
}

class _ContentCalendarScreenState extends State<ContentCalendarScreen> {
  CalendarView _currentView = CalendarView.month;
  DateTime _selectedDate = DateTime.now();
  String _selectedFilter = 'All';
  bool _showDailyPanel = false;

  final List<String> _platforms = [
    'All',
    'Instagram',
    'Facebook',
    'Twitter',
    'LinkedIn',
    'TikTok'
  ];
  final List<ContentPost> _posts = [
    ContentPost(
        id: '1',
        platform: 'Instagram',
        content: 'Check out our new product launch! 🚀',
        scheduledDate: DateTime.now().add(const Duration(days: 1)),
        status: PostStatus.scheduled,
        mediaType: MediaType.image,
        thumbnailUrl:
            'https://images.unsplash.com/photo-1560472354-b33ff0c44a43?w=400',
        engagementPrediction: 85),
    ContentPost(
        id: '2',
        platform: 'Facebook',
        content: 'Join our community for exclusive updates',
        scheduledDate: DateTime.now().add(const Duration(days: 2)),
        status: PostStatus.draft,
        mediaType: MediaType.video,
        thumbnailUrl:
            'https://images.unsplash.com/photo-1611224923853-80b023f02d71?w=400',
        engagementPrediction: 72),
    ContentPost(
        id: '3',
        platform: 'Twitter',
        content: 'Breaking: New features coming soon! #Innovation',
        scheduledDate: DateTime.now().add(const Duration(days: 3)),
        status: PostStatus.scheduled,
        mediaType: MediaType.text,
        thumbnailUrl: null,
        engagementPrediction: 63),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color(0xFF101010),
        body: SafeArea(
            child: Stack(children: [
          Column(children: [
            // Header with navigation and filters
            Container(
                padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
                decoration: const BoxDecoration(
                    color: Color(0xFF191919),
                    border: Border(
                        bottom:
                            BorderSide(color: Color(0xFF282828), width: 1))),
                child: Column(children: [
                  // Top navigation
                  Row(children: [
                    GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: Container(
                            padding: EdgeInsets.all(2.w),
                            decoration: BoxDecoration(
                                color: const Color(0xFF282828),
                                borderRadius: BorderRadius.circular(8)),
                            child: const CustomIconWidget(
                                iconName: 'back',
                                size: 20,
                                color: Color(0xFFF1F1F1)))),
                    SizedBox(width: 3.w),
                    Text('Content Calendar',
                        style: GoogleFonts.inter(
                            fontSize: 18.sp,
                            fontWeight: FontWeight.w600,
                            color: const Color(0xFFF1F1F1))),
                    const Spacer(),
                    // View toggle buttons
                    CalendarHeaderWidget(
                        currentView: _currentView,
                        onViewChanged: (view) {
                          setState(() {
                            _currentView = view;
                          });
                        }),
                  ]),
                  SizedBox(height: 2.h),
                  // Filter row
                  ContentFilterWidget(
                      platforms: _platforms,
                      selectedFilter: _selectedFilter,
                      onFilterChanged: (filter) {
                        setState(() {
                          _selectedFilter = filter;
                        });
                      }),
                ])),

            // Calendar content
            Expanded(
                child: Row(children: [
              // Main calendar view
              Expanded(
                  flex: _showDailyPanel ? 2 : 1,
                  child: Container(
                    // Placeholder for CalendarGridWidget
                    child: Center(child: Text('Calendar Grid Placeholder')),
                  )),

              // Daily posts panel
              if (_showDailyPanel)
                Container(
                    width: 80.w,
                    decoration: const BoxDecoration(
                        color: Color(0xFF191919),
                        border: Border(
                            left: BorderSide(
                                color: Color(0xFF282828), width: 1))),
                    child: Container(
                      // Placeholder for DailyPostsPanelWidget
                      child:
                          Center(child: Text('Daily Posts Panel Placeholder')),
                    )),
            ])),
          ]),

          // Floating action button
          Positioned(
              bottom: 3.h,
              right: 4.w,
              child: FloatingActionButton(
                  onPressed: () => _showAddContentModal(context),
                  backgroundColor: const Color(0xFFFDFDFD),
                  child: const CustomIconWidget(
                      iconName: 'add', size: 28, color: Color(0xFF141414)))),
        ])));
  }

  List<ContentPost> _getFilteredPosts() {
    if (_selectedFilter == 'All') return _posts;
    return _posts.where((post) => post.platform == _selectedFilter).toList();
  }

  List<ContentPost> _getPostsForDate(DateTime date) {
    return _posts.where((post) {
      return post.scheduledDate.day == date.day &&
          post.scheduledDate.month == date.month &&
          post.scheduledDate.year == date.year;
    }).toList();
  }

  void _handlePostDragUpdate(String postId, DateTime newDate) {
    setState(() {
      final postIndex = _posts.indexWhere((post) => post.id == postId);
      if (postIndex != -1) {
        _posts[postIndex] = _posts[postIndex].copyWith(scheduledDate: newDate);
      }
    });
  }

  void _handlePostEdit(ContentPost post) {
    _showAddContentModal(context, editingPost: post);
  }

  void _handlePostDelete(String postId) {
    setState(() {
      _posts.removeWhere((post) => post.id == postId);
    });
  }

  void _showAddContentModal(BuildContext context, {ContentPost? editingPost}) {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: Text('Add Content'),
              content: Text('Content modal placeholder'),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text('Close'),
                ),
              ],
            ));
  }
}

enum CalendarView { month, week, day }

enum PostStatus { draft, scheduled, published, failed }

enum MediaType { text, image, video, carousel }

class ContentPost {
  final String id;
  final String platform;
  final String content;
  final DateTime scheduledDate;
  final PostStatus status;
  final MediaType mediaType;
  final String? thumbnailUrl;
  final int engagementPrediction;

  ContentPost({
    required this.id,
    required this.platform,
    required this.content,
    required this.scheduledDate,
    required this.status,
    required this.mediaType,
    this.thumbnailUrl,
    required this.engagementPrediction,
  });

  ContentPost copyWith({
    String? id,
    String? platform,
    String? content,
    DateTime? scheduledDate,
    PostStatus? status,
    MediaType? mediaType,
    String? thumbnailUrl,
    int? engagementPrediction,
  }) {
    return ContentPost(
        id: id ?? this.id,
        platform: platform ?? this.platform,
        content: content ?? this.content,
        scheduledDate: scheduledDate ?? this.scheduledDate,
        status: status ?? this.status,
        mediaType: mediaType ?? this.mediaType,
        thumbnailUrl: thumbnailUrl ?? this.thumbnailUrl,
        engagementPrediction:
            engagementPrediction ?? this.engagementPrediction);
  }
}