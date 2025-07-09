import '../../core/app_export.dart';
import './widgets/bulk_posting_history_widget.dart';
import './widgets/content_composer_widget.dart';
import './widgets/cross_posting_rules_widget.dart';
import './widgets/media_upload_widget.dart';
import './widgets/platform_preview_widget.dart';
import './widgets/platform_selector_widget.dart';
import './widgets/scheduling_options_widget.dart';

class MultiPlatformPostingScreen extends StatefulWidget {
  const MultiPlatformPostingScreen({super.key});

  @override
  State<MultiPlatformPostingScreen> createState() => _MultiPlatformPostingScreenState();
}

class _MultiPlatformPostingScreenState extends State<MultiPlatformPostingScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  
  final List<String> _selectedPlatforms = ['instagram', 'facebook'];
  final TextEditingController _contentController = TextEditingController();
  final List<String> _uploadedMedia = [];
  bool _isScheduled = false;
  DateTime? _scheduledTime;
  
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.primaryBackground,
      appBar: AppBar(
        backgroundColor: AppTheme.primaryBackground,
        title: const Text(
          'Multi-Platform Posting',
          style: TextStyle(
            color: AppTheme.primaryText,
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios,
            color: AppTheme.primaryText,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: const Icon(
              Icons.save_outlined,
              color: AppTheme.primaryText,
            ),
            onPressed: _saveAsTemplate,
          ),
          IconButton(
            icon: const Icon(
              Icons.settings_outlined,
              color: AppTheme.primaryText,
            ),
            onPressed: _showPostingSettings,
          ),
        ],
      ),
      body: Column(
        children: [
          // Platform Selector Header
          PlatformSelectorWidget(
            selectedPlatforms: _selectedPlatforms,
            onPlatformToggle: _togglePlatform,
          ),
          
          // Tab Bar
          Container(
            color: AppTheme.primaryBackground,
            child: TabBar(
              controller: _tabController,
              tabs: const [
                Tab(text: 'Compose'),
                Tab(text: 'Preview'),
                Tab(text: 'History'),
              ],
              labelColor: AppTheme.primaryText,
              unselectedLabelColor: AppTheme.secondaryText,
              indicatorColor: AppTheme.accent,
            ),
          ),
          
          // Tab Content
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildComposeTab(),
                _buildPreviewTab(),
                _buildHistoryTab(),
              ],
            ),
          ),
          
          // Bottom Action Bar
          _buildBottomActionBar(),
        ],
      ),
    );
  }

  Widget _buildComposeTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ContentComposerWidget(
            controller: _contentController,
            selectedPlatforms: _selectedPlatforms,
            onContentChanged: _onContentChanged,
          ),
          const SizedBox(height: 16),
          MediaUploadWidget(
            uploadedMedia: _uploadedMedia,
            onMediaAdded: _onMediaAdded,
            onMediaRemoved: _onMediaRemoved,
            onMediaReordered: _onMediaReordered,
          ),
          const SizedBox(height: 16),
          SchedulingOptionsWidget(
            isScheduled: _isScheduled,
            scheduledTime: _scheduledTime,
            onScheduleToggle: _onScheduleToggle,
            onTimeSelected: _onTimeSelected,
          ),
          const SizedBox(height: 16),
          CrossPostingRulesWidget(
            selectedPlatforms: _selectedPlatforms,
            onRuleChanged: _onRuleChanged,
          ),
        ],
      ),
    );
  }

  Widget _buildPreviewTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          PlatformPreviewWidget(
            selectedPlatforms: _selectedPlatforms,
            content: _contentController.text,
            media: _uploadedMedia,
          ),
        ],
      ),
    );
  }

  Widget _buildHistoryTab() {
    return BulkPostingHistoryWidget(
      onRepost: _onRepost,
    );
  }

  Widget _buildBottomActionBar() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(
        color: AppTheme.surface,
        border: Border(
          top: BorderSide(color: AppTheme.border),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: ElevatedButton(
              onPressed: _isScheduled ? _schedulePost : _postNow,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.primaryAction,
                foregroundColor: const Color(0xFF141414),
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text(
                _isScheduled ? 'Schedule Post' : 'Post Now',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          OutlinedButton(
            onPressed: _saveDraft,
            style: OutlinedButton.styleFrom(
              foregroundColor: AppTheme.primaryText,
              side: const BorderSide(color: AppTheme.border),
              padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text('Save Draft'),
          ),
        ],
      ),
    );
  }

  void _togglePlatform(String platform) {
    setState(() {
      if (_selectedPlatforms.contains(platform)) {
        _selectedPlatforms.remove(platform);
      } else {
        _selectedPlatforms.add(platform);
      }
    });
  }

  void _onContentChanged(String content) {
    // Handle content changes
  }

  void _onMediaAdded(String media) {
    setState(() {
      _uploadedMedia.add(media);
    });
  }

  void _onMediaRemoved(String media) {
    setState(() {
      _uploadedMedia.remove(media);
    });
  }

  void _onMediaReordered(List<String> reorderedMedia) {
    setState(() {
      _uploadedMedia.clear();
      _uploadedMedia.addAll(reorderedMedia);
    });
  }

  void _onScheduleToggle(bool isScheduled) {
    setState(() {
      _isScheduled = isScheduled;
    });
  }

  void _onTimeSelected(DateTime time) {
    setState(() {
      _scheduledTime = time;
    });
  }

  void _onRuleChanged(String rule) {
    // Handle cross-posting rule changes
  }

  void _onRepost(Map<String, dynamic> post) {
    // Handle repost functionality
  }

  void _saveAsTemplate() {
    // Save current configuration as template
  }

  void _showPostingSettings() {
    // Show posting settings modal
  }

  void _postNow() {
    // Post immediately to selected platforms
  }

  void _schedulePost() {
    // Schedule post for later
  }

  void _saveDraft() {
    // Save as draft
  }
}