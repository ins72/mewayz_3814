import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/add_content_bottom_sheet_widget.dart';
import './widgets/course_header_widget.dart';
import './widgets/course_module_card_widget.dart';
import './widgets/course_settings_widget.dart';
import './widgets/student_progress_widget.dart';

class CourseCreator extends StatefulWidget {
  const CourseCreator({Key? key}) : super(key: key);

  @override
  State<CourseCreator> createState() => _CourseCreatorState();
}

class _CourseCreatorState extends State<CourseCreator>
    with TickerProviderStateMixin {
  late TabController _tabController;
  final TextEditingController _courseTitleController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  bool _isPreviewMode = false;
  int _selectedModuleIndex = -1;

  // Mock data for course structure
  final List<Map<String, dynamic>> _courseModules = [
    {
      "id": 1,
      "title": "Introduction to Flutter Development",
      "lessonCount": 8,
      "duration": "2h 45m",
      "completionRate": 85.5,
      "isExpanded": false,
      "lessons": [
        {
          "id": 1,
          "title": "Setting up Development Environment",
          "type": "video",
          "duration": "15m",
          "thumbnail":
              "https://images.pexels.com/photos/574071/pexels-photo-574071.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1",
          "isCompleted": true,
          "status": "published"
        },
        {
          "id": 2,
          "title": "Understanding Widgets",
          "type": "video",
          "duration": "22m",
          "thumbnail":
              "https://images.pexels.com/photos/1181244/pexels-photo-1181244.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1",
          "isCompleted": false,
          "status": "draft"
        },
        {
          "id": 3,
          "title": "Basic Layout Concepts",
          "type": "text",
          "duration": "12m",
          "thumbnail": null,
          "isCompleted": false,
          "status": "draft"
        }
      ]
    },
    {
      "id": 2,
      "title": "Advanced Flutter Concepts",
      "lessonCount": 12,
      "duration": "4h 20m",
      "completionRate": 42.3,
      "isExpanded": false,
      "lessons": [
        {
          "id": 4,
          "title": "State Management with Provider",
          "type": "video",
          "duration": "35m",
          "thumbnail":
              "https://images.pexels.com/photos/1181298/pexels-photo-1181298.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1",
          "isCompleted": false,
          "status": "draft"
        },
        {
          "id": 5,
          "title": "Navigation and Routing",
          "type": "quiz",
          "duration": "25m",
          "thumbnail": null,
          "isCompleted": false,
          "status": "draft"
        }
      ]
    },
    {
      "id": 3,
      "title": "Building Real-World Apps",
      "lessonCount": 15,
      "duration": "6h 15m",
      "completionRate": 0.0,
      "isExpanded": false,
      "lessons": [
        {
          "id": 6,
          "title": "Project Setup and Architecture",
          "type": "video",
          "duration": "28m",
          "thumbnail":
              "https://images.pexels.com/photos/1181263/pexels-photo-1181263.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1",
          "isCompleted": false,
          "status": "draft"
        }
      ]
    }
  ];

  final Map<String, dynamic> _courseAnalytics = {
    "totalStudents": 1247,
    "completionRate": 68.5,
    "averageRating": 4.7,
    "totalRevenue": "\$12,450",
    "engagementRate": 82.3,
    "dropoffRate": 15.2
  };

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _courseTitleController.text = "Complete Flutter Development Course";
  }

  @override
  void dispose() {
    _tabController.dispose();
    _courseTitleController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _toggleModuleExpansion(int index) {
    setState(() {
      _courseModules[index]["isExpanded"] =
          !_courseModules[index]["isExpanded"];
    });
  }

  void _showAddContentBottomSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => AddContentBottomSheetWidget(
        onContentTypeSelected: _handleContentTypeSelection,
      ),
    );
  }

  void _handleContentTypeSelection(String contentType) {
    Navigator.pop(context);
    // Handle different content types
    switch (contentType) {
      case 'video':
        _showVideoUploadDialog();
        break;
      case 'text':
        _showTextContentEditor();
        break;
      case 'quiz':
        _showQuizBuilder();
        break;
      case 'assignment':
        _showAssignmentBuilder();
        break;
      case 'discussion':
        _showDiscussionForumBuilder();
        break;
    }
  }

  void _showVideoUploadDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'Upload Video Lesson',
          style: AppTheme.darkTheme.textTheme.titleLarge,
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: double.infinity,
              height: 20.h,
              decoration: BoxDecoration(
                color: AppTheme.surface,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppTheme.border),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CustomIconWidget(
                    iconName: 'video_library',
                    color: AppTheme.accent,
                    size: 48,
                  ),
                  SizedBox(height: 2.h),
                  Text(
                    'Tap to select video file',
                    style: AppTheme.darkTheme.textTheme.bodyMedium,
                  ),
                  SizedBox(height: 1.h),
                  Text(
                    'Max size: 500MB',
                    style: AppTheme.darkTheme.textTheme.bodySmall,
                  ),
                ],
              ),
            ),
            SizedBox(height: 2.h),
            TextField(
              decoration: InputDecoration(
                labelText: 'Lesson Title',
                hintText: 'Enter lesson title',
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              // Handle video upload
            },
            child: Text('Upload'),
          ),
        ],
      ),
    );
  }

  void _showTextContentEditor() {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        child: Container(
          width: 90.w,
          height: 70.h,
          padding: EdgeInsets.all(4.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Create Text Content',
                style: AppTheme.darkTheme.textTheme.titleLarge,
              ),
              SizedBox(height: 2.h),
              TextField(
                decoration: InputDecoration(
                  labelText: 'Content Title',
                  hintText: 'Enter content title',
                ),
              ),
              SizedBox(height: 2.h),
              Expanded(
                child: TextField(
                  maxLines: null,
                  expands: true,
                  textAlignVertical: TextAlignVertical.top,
                  decoration: InputDecoration(
                    labelText: 'Content',
                    hintText: 'Write your content here...',
                    alignLabelWithHint: true,
                  ),
                ),
              ),
              SizedBox(height: 2.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text('Cancel'),
                  ),
                  SizedBox(width: 2.w),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                      // Handle text content save
                    },
                    child: Text('Save'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showQuizBuilder() {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        child: Container(
          width: 90.w,
          height: 70.h,
          padding: EdgeInsets.all(4.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Create Quiz',
                style: AppTheme.darkTheme.textTheme.titleLarge,
              ),
              SizedBox(height: 2.h),
              TextField(
                decoration: InputDecoration(
                  labelText: 'Quiz Title',
                  hintText: 'Enter quiz title',
                ),
              ),
              SizedBox(height: 2.h),
              Expanded(
                child: ListView(
                  children: [
                    _buildQuizQuestionCard(1, "What is Flutter?"),
                    _buildQuizQuestionCard(
                        2, "Which language is used for Flutter?"),
                  ],
                ),
              ),
              SizedBox(height: 2.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton.icon(
                    onPressed: () {
                      // Add new question
                    },
                    icon: CustomIconWidget(
                      iconName: 'add',
                      color: AppTheme.accent,
                      size: 20,
                    ),
                    label: Text('Add Question'),
                  ),
                  Row(
                    children: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: Text('Cancel'),
                      ),
                      SizedBox(width: 2.w),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context);
                          // Handle quiz save
                        },
                        child: Text('Save Quiz'),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildQuizQuestionCard(int questionNumber, String question) {
    return Card(
      margin: EdgeInsets.only(bottom: 2.h),
      child: Padding(
        padding: EdgeInsets.all(3.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Question $questionNumber',
                  style: AppTheme.darkTheme.textTheme.titleMedium,
                ),
                Row(
                  children: [
                    CustomIconWidget(
                      iconName: 'edit',
                      color: AppTheme.secondaryText,
                      size: 20,
                    ),
                    SizedBox(width: 2.w),
                    CustomIconWidget(
                      iconName: 'delete',
                      color: AppTheme.error,
                      size: 20,
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(height: 1.h),
            Text(
              question,
              style: AppTheme.darkTheme.textTheme.bodyMedium,
            ),
            SizedBox(height: 1.h),
            Text(
              'Multiple Choice • 5 points',
              style: AppTheme.darkTheme.textTheme.bodySmall,
            ),
          ],
        ),
      ),
    );
  }

  void _showAssignmentBuilder() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'Create Assignment',
          style: AppTheme.darkTheme.textTheme.titleLarge,
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              decoration: InputDecoration(
                labelText: 'Assignment Title',
                hintText: 'Enter assignment title',
              ),
            ),
            SizedBox(height: 2.h),
            TextField(
              maxLines: 3,
              decoration: InputDecoration(
                labelText: 'Instructions',
                hintText: 'Enter assignment instructions',
              ),
            ),
            SizedBox(height: 2.h),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      labelText: 'Points',
                      hintText: '100',
                    ),
                    keyboardType: TextInputType.number,
                  ),
                ),
                SizedBox(width: 2.w),
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      labelText: 'Due Date',
                      hintText: 'Select date',
                    ),
                    readOnly: true,
                    onTap: () {
                      // Show date picker
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              // Handle assignment save
            },
            child: Text('Create'),
          ),
        ],
      ),
    );
  }

  void _showDiscussionForumBuilder() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'Create Discussion Forum',
          style: AppTheme.darkTheme.textTheme.titleLarge,
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              decoration: InputDecoration(
                labelText: 'Forum Title',
                hintText: 'Enter forum title',
              ),
            ),
            SizedBox(height: 2.h),
            TextField(
              maxLines: 3,
              decoration: InputDecoration(
                labelText: 'Description',
                hintText: 'Enter forum description',
              ),
            ),
            SizedBox(height: 2.h),
            Row(
              children: [
                Checkbox(
                  value: true,
                  onChanged: (value) {},
                ),
                Expanded(
                  child: Text(
                    'Allow students to create topics',
                    style: AppTheme.darkTheme.textTheme.bodyMedium,
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Checkbox(
                  value: false,
                  onChanged: (value) {},
                ),
                Expanded(
                  child: Text(
                    'Require moderation',
                    style: AppTheme.darkTheme.textTheme.bodyMedium,
                  ),
                ),
              ],
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              // Handle forum save
            },
            child: Text('Create'),
          ),
        ],
      ),
    );
  }

  void _showCourseSettings() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => CourseSettingsWidget(),
    );
  }

  void _togglePreviewMode() {
    setState(() {
      _isPreviewMode = !_isPreviewMode;
    });
  }

  double _calculateOverallProgress() {
    if (_courseModules.isEmpty) return 0.0;
    double totalProgress = 0.0;
    for (var module in _courseModules) {
      totalProgress += (module["completionRate"] as double);
    }
    return totalProgress / _courseModules.length;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.primaryBackground,
      body: SafeArea(
        child: Column(
          children: [
            CourseHeaderWidget(
              courseTitleController: _courseTitleController,
              overallProgress: _calculateOverallProgress(),
              isPreviewMode: _isPreviewMode,
              onPreviewToggle: _togglePreviewMode,
              onSettingsPressed: _showCourseSettings,
            ),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  _buildCourseStructureTab(),
                  StudentProgressWidget(analytics: _courseAnalytics),
                  _buildBulkImportTab(),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        color: AppTheme.surface,
        child: TabBar(
          controller: _tabController,
          tabs: [
            Tab(
              icon: CustomIconWidget(
                iconName: 'school',
                color: AppTheme.primaryText,
                size: 24,
              ),
              text: 'Structure',
            ),
            Tab(
              icon: CustomIconWidget(
                iconName: 'analytics',
                color: AppTheme.primaryText,
                size: 24,
              ),
              text: 'Analytics',
            ),
            Tab(
              icon: CustomIconWidget(
                iconName: 'upload_file',
                color: AppTheme.primaryText,
                size: 24,
              ),
              text: 'Import',
            ),
          ],
        ),
      ),
      floatingActionButton: _tabController.index == 0
          ? FloatingActionButton.extended(
              onPressed: _showAddContentBottomSheet,
              icon: CustomIconWidget(
                iconName: 'add',
                color: AppTheme.primaryBackground,
                size: 24,
              ),
              label: Text(
                'Add Content',
                style: TextStyle(
                  color: AppTheme.primaryBackground,
                  fontWeight: FontWeight.w500,
                ),
              ),
            )
          : null,
    );
  }

  Widget _buildCourseStructureTab() {
    return Column(
      children: [
        if (_isPreviewMode)
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(4.w),
            color: AppTheme.accent.withValues(alpha: 0.1),
            child: Row(
              children: [
                CustomIconWidget(
                  iconName: 'visibility',
                  color: AppTheme.accent,
                  size: 20,
                ),
                SizedBox(width: 2.w),
                Text(
                  'Preview Mode - Student View',
                  style: AppTheme.darkTheme.textTheme.bodyMedium?.copyWith(
                    color: AppTheme.accent,
                  ),
                ),
              ],
            ),
          ),
        Expanded(
          child: ListView.builder(
            controller: _scrollController,
            padding: EdgeInsets.all(4.w),
            itemCount: _courseModules.length,
            itemBuilder: (context, index) {
              return CourseModuleCardWidget(
                module: _courseModules[index],
                isExpanded: _courseModules[index]["isExpanded"],
                isPreviewMode: _isPreviewMode,
                onToggleExpansion: () => _toggleModuleExpansion(index),
                onLessonTap: (lessonId) {
                  // Handle lesson tap
                },
                onLessonLongPress: (lessonId) {
                  if (!_isPreviewMode) {
                    _showLessonContextMenu(lessonId);
                  }
                },
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildBulkImportTab() {
    return Padding(
      padding: EdgeInsets.all(4.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Bulk Import Lessons',
            style: AppTheme.darkTheme.textTheme.headlineSmall,
          ),
          SizedBox(height: 2.h),
          Text(
            'Upload a CSV file with lesson data to quickly add multiple lessons to your course.',
            style: AppTheme.darkTheme.textTheme.bodyMedium,
          ),
          SizedBox(height: 3.h),
          Container(
            width: double.infinity,
            height: 25.h,
            decoration: BoxDecoration(
              color: AppTheme.surface,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: AppTheme.border,
                style: BorderStyle.solid,
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
                  'Drop CSV file here or tap to browse',
                  style: AppTheme.darkTheme.textTheme.bodyLarge,
                ),
                SizedBox(height: 1.h),
                Text(
                  'Supported format: CSV',
                  style: AppTheme.darkTheme.textTheme.bodySmall,
                ),
              ],
            ),
          ),
          SizedBox(height: 3.h),
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () {
                    // Download template
                  },
                  icon: CustomIconWidget(
                    iconName: 'download',
                    color: AppTheme.primaryText,
                    size: 20,
                  ),
                  label: Text('Download Template'),
                ),
              ),
              SizedBox(width: 3.w),
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () {
                    // Upload CSV
                  },
                  icon: CustomIconWidget(
                    iconName: 'upload',
                    color: AppTheme.primaryBackground,
                    size: 20,
                  ),
                  label: Text('Upload CSV'),
                ),
              ),
            ],
          ),
          SizedBox(height: 4.h),
          Text(
            'CSV Format Requirements:',
            style: AppTheme.darkTheme.textTheme.titleMedium,
          ),
          SizedBox(height: 1.h),
          _buildFormatRequirement('Module Title', 'Name of the module'),
          _buildFormatRequirement('Lesson Title', 'Name of the lesson'),
          _buildFormatRequirement(
              'Content Type', 'video, text, quiz, assignment'),
          _buildFormatRequirement('Duration', 'Duration in minutes'),
          _buildFormatRequirement(
              'Video URL', 'URL for video content (optional)'),
        ],
      ),
    );
  }

  Widget _buildFormatRequirement(String field, String description) {
    return Padding(
      padding: EdgeInsets.only(bottom: 1.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 1.w,
            height: 1.w,
            margin: EdgeInsets.only(top: 1.h, right: 2.w),
            decoration: BoxDecoration(
              color: AppTheme.accent,
              shape: BoxShape.circle,
            ),
          ),
          Expanded(
            child: RichText(
              text: TextSpan(
                style: AppTheme.darkTheme.textTheme.bodyMedium,
                children: [
                  TextSpan(
                    text: '$field: ',
                    style: TextStyle(fontWeight: FontWeight.w500),
                  ),
                  TextSpan(text: description),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showLessonContextMenu(int lessonId) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: BoxDecoration(
          color: AppTheme.surface,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 10.w,
              height: 0.5.h,
              margin: EdgeInsets.only(top: 2.h),
              decoration: BoxDecoration(
                color: AppTheme.border,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            SizedBox(height: 3.h),
            _buildContextMenuItem('Edit Lesson', 'edit', () {
              Navigator.pop(context);
              // Handle edit
            }),
            _buildContextMenuItem('Duplicate', 'content_copy', () {
              Navigator.pop(context);
              // Handle duplicate
            }),
            _buildContextMenuItem('Preview', 'visibility', () {
              Navigator.pop(context);
              // Handle preview
            }),
            _buildContextMenuItem('Delete', 'delete', () {
              Navigator.pop(context);
              // Handle delete
            }, isDestructive: true),
            SizedBox(height: 2.h),
          ],
        ),
      ),
    );
  }

  Widget _buildContextMenuItem(
    String title,
    String iconName,
    VoidCallback onTap, {
    bool isDestructive = false,
  }) {
    return ListTile(
      leading: CustomIconWidget(
        iconName: iconName,
        color: isDestructive ? AppTheme.error : AppTheme.primaryText,
        size: 24,
      ),
      title: Text(
        title,
        style: AppTheme.darkTheme.textTheme.bodyLarge?.copyWith(
          color: isDestructive ? AppTheme.error : AppTheme.primaryText,
        ),
      ),
      onTap: onTap,
    );
  }
}
