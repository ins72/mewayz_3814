import '../../core/app_export.dart';
import '../../services/dynamic_data_service.dart';
import './widgets/content_management_section_widget.dart';
import './widgets/enhanced_quick_post_fab_widget.dart';
import './widgets/hero_analytics_section_widget.dart';
import './widgets/lead_generation_section_widget.dart';
import './widgets/performance_tracking_section_widget.dart';
import './widgets/platform_indicators_widget.dart';

class PremiumSocialMediaHub extends StatefulWidget {
  const PremiumSocialMediaHub({Key? key}) : super(key: key);

  @override
  State<PremiumSocialMediaHub> createState() => _PremiumSocialMediaHubState();
}

class _PremiumSocialMediaHubState extends State<PremiumSocialMediaHub> with TickerProviderStateMixin {
  late TabController _tabController;
  late AnimationController _refreshController;
  bool _isRefreshing = false;
  int _selectedTabIndex = 0;
  
  // Dynamic data from Supabase
  Map<String, dynamic> _socialMediaData = {};
  List<Map<String, dynamic>> _platforms = [];
  bool _isLoading = true;
  String _workspaceId = 'demo-workspace-id'; // This should come from user context

  final DynamicDataService _dataService = DynamicDataService();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    _refreshController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this);
    _tabController.addListener(() {
      setState(() {
        _selectedTabIndex = _tabController.index;
      });
    });
    _loadSocialMediaData();
  }

  @override
  void dispose() {
    _tabController.dispose();
    _refreshController.dispose();
    super.dispose();
  }

  Future<void> _loadSocialMediaData() async {
    try {
      setState(() => _isLoading = true);
      
      final data = await _dataService.getSocialMediaHubData(_workspaceId);
      
      // Transform platforms data or use defaults if no data
      final posts = data['posts'] as List? ?? [];
      final analytics = data['analytics'] as Map<String, dynamic>? ?? {};
      
      setState(() {
        _socialMediaData = data;
        _platforms = _generatePlatformsFromData(posts, analytics);
        _isLoading = false;
      });
    } catch (error) {
      print('Error loading social media data: $error');
      setState(() {
        _isLoading = false;
        _platforms = _getDefaultPlatforms();
      });
    }
  }

  List<Map<String, dynamic>> _generatePlatformsFromData(List posts, Map<String, dynamic> analytics) {
    // Count posts and engagement by platform
    final platformStats = <String, Map<String, dynamic>>{};
    
    for (var post in posts) {
      final platform = post['platform'] ?? 'unknown';
      platformStats[platform] ??= {
        'post_count': 0,
        'total_engagement': 0,
        'total_reach': 0,
      };
      
      platformStats[platform]!['post_count'] += 1;
      platformStats[platform]!['total_engagement'] += (post['engagement_count'] ?? 0);
      platformStats[platform]!['total_reach'] += (post['reach_count'] ?? 0);
    }

    return [
      {
        'name': 'Instagram',
        'icon': Icons.camera_alt,
        'color': const Color(0xFFE1306C),
        'isConnected': platformStats.containsKey('instagram'),
        'followers': _formatNumber(platformStats['instagram']?['total_reach'] ?? 0),
        'engagement': _calculateEngagementRate(
          platformStats['instagram']?['total_engagement'] ?? 0,
          platformStats['instagram']?['total_reach'] ?? 0
        ),
      },
      {
        'name': 'Facebook',
        'icon': Icons.facebook,
        'color': const Color(0xFF1877F2),
        'isConnected': platformStats.containsKey('facebook'),
        'followers': _formatNumber(platformStats['facebook']?['total_reach'] ?? 0),
        'engagement': _calculateEngagementRate(
          platformStats['facebook']?['total_engagement'] ?? 0,
          platformStats['facebook']?['total_reach'] ?? 0
        ),
      },
      {
        'name': 'Twitter',
        'icon': Icons.alternate_email,
        'color': const Color(0xFF1DA1F2),
        'isConnected': platformStats.containsKey('twitter'),
        'followers': _formatNumber(platformStats['twitter']?['total_reach'] ?? 0),
        'engagement': _calculateEngagementRate(
          platformStats['twitter']?['total_engagement'] ?? 0,
          platformStats['twitter']?['total_reach'] ?? 0
        ),
      },
      {
        'name': 'LinkedIn',
        'icon': Icons.business,
        'color': const Color(0xFF0A66C2),
        'isConnected': platformStats.containsKey('linkedin'),
        'followers': _formatNumber(platformStats['linkedin']?['total_reach'] ?? 0),
        'engagement': _calculateEngagementRate(
          platformStats['linkedin']?['total_engagement'] ?? 0,
          platformStats['linkedin']?['total_reach'] ?? 0
        ),
      },
      {
        'name': 'TikTok',
        'icon': Icons.music_note,
        'color': const Color(0xFF000000),
        'isConnected': platformStats.containsKey('tiktok'),
        'followers': _formatNumber(platformStats['tiktok']?['total_reach'] ?? 0),
        'engagement': _calculateEngagementRate(
          platformStats['tiktok']?['total_engagement'] ?? 0,
          platformStats['tiktok']?['total_reach'] ?? 0
        ),
      },
    ];
  }

  List<Map<String, dynamic>> _getDefaultPlatforms() {
    return [
      {
        'name': 'Instagram',
        'icon': Icons.camera_alt,
        'color': const Color(0xFFE1306C),
        'isConnected': false,
        'followers': '0',
        'engagement': '0%',
      },
      {
        'name': 'Facebook',
        'icon': Icons.facebook,
        'color': const Color(0xFF1877F2),
        'isConnected': false,
        'followers': '0',
        'engagement': '0%',
      },
      {
        'name': 'Twitter',
        'icon': Icons.alternate_email,
        'color': const Color(0xFF1DA1F2),
        'isConnected': false,
        'followers': '0',
        'engagement': '0%',
      },
      {
        'name': 'LinkedIn',
        'icon': Icons.business,
        'color': const Color(0xFF0A66C2),
        'isConnected': false,
        'followers': '0',
        'engagement': '0%',
      },
      {
        'name': 'TikTok',
        'icon': Icons.music_note,
        'color': const Color(0xFF000000),
        'isConnected': false,
        'followers': '0',
        'engagement': '0%',
      },
    ];
  }

  String _formatNumber(int number) {
    if (number > 1000000) {
      return '${(number / 1000000).toStringAsFixed(1)}M';
    } else if (number > 1000) {
      return '${(number / 1000).toStringAsFixed(1)}K';
    }
    return number.toString();
  }

  String _calculateEngagementRate(int engagement, int reach) {
    if (reach == 0) return '0%';
    return '${((engagement / reach) * 100).toStringAsFixed(1)}%';
  }

  Future<void> _handleRefresh() async {
    if (_isRefreshing) return;
    
    setState(() {
      _isRefreshing = true;
    });
    
    HapticFeedback.mediumImpact();
    _refreshController.forward();
    
    await _loadSocialMediaData();
    
    _refreshController.reverse();
    setState(() {
      _isRefreshing = false;
    });
    
    HapticFeedback.lightImpact();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF101010),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF101010),
              Color(0xFF0A0A0A),
            ])),
        child: SafeArea(
          child: Column(
            children: [
              // Header with Platform Indicators
              PlatformIndicatorsWidget(
                platforms: _platforms,
                onPlatformSwitch: (platform) {
                  // Handle platform switching
                }),
              
              // Tab Bar Navigation
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: const Color(0xFF191919),
                  borderRadius: BorderRadius.circular(12)),
                child: TabBar(
                  controller: _tabController,
                  indicatorColor: Colors.transparent,
                  labelColor: const Color(0xFF007AFF),
                  unselectedLabelColor: const Color(0xFF8E8E93),
                  labelStyle: GoogleFonts.inter(
                    fontSize: 14,
                    fontWeight: FontWeight.w600),
                  unselectedLabelStyle: GoogleFonts.inter(
                    fontSize: 14,
                    fontWeight: FontWeight.w500),
                  tabs: [
                    _buildTabItem('Dashboard', 0),
                    _buildTabItem('Content', 1),
                    _buildTabItem('Leads', 2),
                    _buildTabItem('Analytics', 3),
                  ])),
              
              // Main Content
              Expanded(
                child: _isLoading
                    ? const Center(
                        child: CircularProgressIndicator(
                          color: Color(0xFF007AFF)))
                    : RefreshIndicator(
                        onRefresh: _handleRefresh,
                        backgroundColor: const Color(0xFF191919),
                        color: const Color(0xFF007AFF),
                        child: TabBarView(
                          controller: _tabController,
                          children: [
                            // Dashboard Tab
                            SingleChildScrollView(
                              physics: const AlwaysScrollableScrollPhysics(),
                              padding: const EdgeInsets.all(16),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  HeroAnalyticsSectionWidget(
                                    isRefreshing: _isRefreshing,
                                    refreshController: _refreshController,
                                    platforms: _platforms),
                                  const SizedBox(height: 24),
                                  Text(
                                    'Quick Actions',
                                    style: GoogleFonts.inter(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.white)),
                                  const SizedBox(height: 12),
                                  _buildQuickActionsGrid(),
                                ])),
                            
                            // Content Tab
                            ContentManagementSectionWidget(),
                            
                            // Leads Tab
                            LeadGenerationSectionWidget(),
                            
                            // Analytics Tab
                            PerformanceTrackingSectionWidget(),
                          ]))),
            ]))),
      floatingActionButton: const EnhancedQuickPostFabWidget());
  }

  Widget _buildTabItem(String title, int index) {
    final isSelected = _selectedTabIndex == index;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: isSelected ? const Color(0xFF007AFF).withAlpha(26) : Colors.transparent,
        borderRadius: BorderRadius.circular(8)),
      child: Text(title));
  }

  Widget _buildQuickActionsGrid() {
    final quickActions = [
      {
        'title': 'Multi-Post',
        'icon': Icons.dynamic_feed,
        'color': const Color(0xFF007AFF),
        'description': 'Post to all platforms',
      },
      {
        'title': 'Templates',
        'icon': Icons.help_outline,
        'color': const Color(0xFF34C759),
        'description': 'Ready-made designs',
      },
      {
        'title': 'Analytics',
        'icon': Icons.analytics,
        'color': const Color(0xFFFF9500),
        'description': 'Performance insights',
      },
      {
        'title': 'Hashtags',
        'icon': Icons.tag,
        'color': const Color(0xFF5856D6),
        'description': 'Research & trends',
      },
      {
        'title': 'Scheduler',
        'icon': Icons.schedule,
        'color': const Color(0xFFFF3B30),
        'description': 'Plan your posts',
      },
      {
        'title': 'Stories',
        'icon': Icons.auto_stories,
        'color': const Color(0xFF32D74B),
        'description': 'Create stories',
      },
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: 1.5),
      itemCount: quickActions.length,
      itemBuilder: (context, index) {
        final action = quickActions[index];
        return _buildQuickActionCard(action);
      });
  }

  Widget _buildQuickActionCard(Map<String, dynamic> action) {
    return GestureDetector(
      onTap: () {
        // Handle quick action
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFF191919),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: const Color(0xFF2C2C2E),
            width: 1)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: (action['color'] as Color).withAlpha(26),
                    borderRadius: BorderRadius.circular(10)),
                  child: Icon(
                    action['icon'] as IconData,
                    color: action['color'] as Color,
                    size: 20)),
                const Spacer(),
                Icon(
                  Icons.arrow_forward_ios,
                  color: const Color(0xFF8E8E93),
                  size: 16),
              ]),
            const SizedBox(height: 12),
            Text(
              action['title'] as String,
              style: GoogleFonts.inter(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.white)),
            const SizedBox(height: 4),
            Text(
              action['description'] as String,
              style: GoogleFonts.inter(
                fontSize: 12,
                color: const Color(0xFF8E8E93))),
          ])));
  }
}