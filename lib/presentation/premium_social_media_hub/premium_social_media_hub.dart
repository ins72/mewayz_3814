import '../../core/app_export.dart';
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

  final List<Map<String, dynamic>> _platforms = [
{ 'name': 'Instagram',
'icon': Icons.camera_alt,
'color': const Color(0xFFE1306C),
'isConnected': true,
'followers': '45.2K',
'engagement': '8.4%',
},
{ 'name': 'Facebook',
'icon': Icons.facebook,
'color': const Color(0xFF1877F2),
'isConnected': true,
'followers': '23.1K',
'engagement': '5.2%',
},
{ 'name': 'Twitter',
'icon': Icons.alternate_email,
'color': const Color(0xFF1DA1F2),
'isConnected': true,
'followers': '12.8K',
'engagement': '6.7%',
},
{ 'name': 'LinkedIn',
'icon': Icons.business,
'color': const Color(0xFF0A66C2),
'isConnected': false,
'followers': '0',
'engagement': '0%',
},
{ 'name': 'TikTok',
'icon': Icons.music_note,
'color': const Color(0xFF000000),
'isConnected': true,
'followers': '8.5K',
'engagement': '12.3%',
},
];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    _refreshController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    _tabController.addListener(() {
      setState(() {
        _selectedTabIndex = _tabController.index;
      });
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    _refreshController.dispose();
    super.dispose();
  }

  Future<void> _handleRefresh() async {
    if (_isRefreshing) return;
    
    setState(() {
      _isRefreshing = true;
    });
    
    HapticFeedback.mediumImpact();
    _refreshController.forward();
    
    await Future.delayed(const Duration(seconds: 2));
    
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
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Header with Platform Indicators
              PlatformIndicatorsWidget(
                platforms: _platforms,
                onPlatformSwitch: (platform) {
                  // Handle platform switching
                },
              ),
              
              // Tab Bar Navigation
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: const Color(0xFF191919),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: TabBar(
                  controller: _tabController,
                  indicatorColor: Colors.transparent,
                  labelColor: const Color(0xFF007AFF),
                  unselectedLabelColor: const Color(0xFF8E8E93),
                  labelStyle: GoogleFonts.inter(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                  unselectedLabelStyle: GoogleFonts.inter(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                  tabs: [
                    _buildTabItem('Dashboard', 0),
                    _buildTabItem('Content', 1),
                    _buildTabItem('Leads', 2),
                    _buildTabItem('Analytics', 3),
                  ],
                ),
              ),
              
              // Main Content
              Expanded(
                child: RefreshIndicator(
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
                              platforms: _platforms,
                            ),
                            const SizedBox(height: 24),
                            Text(
                              'Quick Actions',
                              style: GoogleFonts.inter(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(height: 12),
                            _buildQuickActionsGrid(),
                          ],
                        ),
                      ),
                      
                      // Content Tab
                      const ContentManagementSectionWidget(),
                      
                      // Leads Tab
                      const LeadGenerationSectionWidget(),
                      
                      // Analytics Tab
                      const PerformanceTrackingSectionWidget(),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: const EnhancedQuickPostFabWidget(),
    );
  }

  Widget _buildTabItem(String title, int index) {
    final isSelected = _selectedTabIndex == index;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: isSelected ? const Color(0xFF007AFF).withAlpha(26) : Colors.transparent,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(title),
    );
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
        childAspectRatio: 1.5,
      ),
      itemCount: quickActions.length,
      itemBuilder: (context, index) {
        final action = quickActions[index];
        return _buildQuickActionCard(action);
      },
    );
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
            width: 1,
          ),
        ),
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
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(
                    action['icon'] as IconData,
                    color: action['color'] as Color,
                    size: 20,
                  ),
                ),
                const Spacer(),
                Icon(
                  Icons.arrow_forward_ios,
                  color: const Color(0xFF8E8E93),
                  size: 16,
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              action['title'] as String,
              style: GoogleFonts.inter(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              action['description'] as String,
              style: GoogleFonts.inter(
                fontSize: 12,
                color: const Color(0xFF8E8E93),
              ),
            ),
          ],
        ),
      ),
    );
  }
}