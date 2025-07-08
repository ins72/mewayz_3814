import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import './widgets/hashtag_analytics_widget.dart';
import './widgets/hashtag_card_widget.dart';
import './widgets/hashtag_filter_widget.dart';
import './widgets/hashtag_generator_widget.dart';
import './widgets/hashtag_search_bar_widget.dart';
import './widgets/hashtag_sets_widget.dart';
import './widgets/trending_hashtags_widget.dart';

class HashtagResearchScreen extends StatefulWidget {
  const HashtagResearchScreen({Key? key}) : super(key: key);

  @override
  State<HashtagResearchScreen> createState() => _HashtagResearchScreenState();
}

class _HashtagResearchScreenState extends State<HashtagResearchScreen> {
  String _selectedFilter = 'All';
  String _selectedPlatform = 'Instagram';
  String _searchQuery = '';
  bool _isLoading = false;
  List<Map<String, dynamic>> _hashtags = [];
  List<Map<String, dynamic>> _savedSets = [];

  @override
  void initState() {
    super.initState();
    _loadHashtags();
  }

  void _loadHashtags() {
    setState(() {
      _isLoading = true;
    });

    // Mock data for hashtags
    _hashtags = [
      {
        'hashtag': '#marketing',
        'usageCount': 2450000,
        'engagementRate': 3.2,
        'difficulty': 'High',
        'trend': 'Rising',
        'relatedHashtags': [
          '#digitalmarketing',
          '#marketingstrategy',
          '#branding'
        ],
        'recentPosts': 156000,
        'competition': 'high',
      },
      {
        'hashtag': '#entrepreneur',
        'usageCount': 1850000,
        'engagementRate': 4.1,
        'difficulty': 'Medium',
        'trend': 'Stable',
        'relatedHashtags': ['#startup', '#business', '#entrepreneurship'],
        'recentPosts': 89000,
        'competition': 'medium',
      },
      {
        'hashtag': '#smallbusiness',
        'usageCount': 950000,
        'engagementRate': 5.8,
        'difficulty': 'Low',
        'trend': 'Rising',
        'relatedHashtags': ['#localbusiness', '#entrepreneur', '#startup'],
        'recentPosts': 45000,
        'competition': 'low',
      },
      {
        'hashtag': '#contentcreator',
        'usageCount': 1200000,
        'engagementRate': 4.5,
        'difficulty': 'Medium',
        'trend': 'Rising',
        'relatedHashtags': ['#content', '#creator', '#socialmedia'],
        'recentPosts': 78000,
        'competition': 'medium',
      },
      {
        'hashtag': '#socialmediamarketing',
        'usageCount': 890000,
        'engagementRate': 3.8,
        'difficulty': 'High',
        'trend': 'Stable',
        'relatedHashtags': ['#socialmedia', '#marketing', '#digital'],
        'recentPosts': 52000,
        'competition': 'high',
      },
    ];

    _savedSets = [
      {
        'name': 'Marketing Campaign',
        'hashtags': ['#marketing', '#digitalmarketing', '#campaign'],
        'lastUsed': '2 hours ago',
      },
      {
        'name': 'Entrepreneur Posts',
        'hashtags': ['#entrepreneur', '#startup', '#business'],
        'lastUsed': '1 day ago',
      },
    ];

    Future.delayed(const Duration(milliseconds: 800), () {
      setState(() {
        _isLoading = false;
      });
    });
  }

  void _onSearchChanged(String query) {
    setState(() {
      _searchQuery = query;
    });
  }

  void _onFilterChanged(String filter) {
    setState(() {
      _selectedFilter = filter;
    });
  }

  void _onPlatformChanged(String platform) {
    setState(() {
      _selectedPlatform = platform;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color(0xFF101010),
        appBar: AppBar(
            backgroundColor: const Color(0xFF101010),
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () => Navigator.pop(context),
            ),
            title: Text('Hashtag Research',
                style: GoogleFonts.inter(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFFF1F1F1))),
            actions: [
              IconButton(
                icon: const Icon(Icons.share),
                onPressed: () {
                  // Export functionality
                },
              ),
              IconButton(
                icon: const Icon(Icons.more_vert),
                onPressed: () {
                  // More options
                },
              ),
            ]),
        body: SafeArea(
            child: Column(children: [
          // Search Bar
          HashtagSearchBarWidget(
              onSearchChanged: _onSearchChanged,
              onVoiceSearch: () {
                // Voice search functionality
              }),

          // Filter and Platform Selection
          HashtagFilterWidget(
              selectedFilter: _selectedFilter,
              selectedPlatform: _selectedPlatform,
              onFilterChanged: _onFilterChanged,
              onPlatformChanged: _onPlatformChanged),

          // Main Content
          Expanded(
              child: _isLoading
                  ? const Center(
                      child:
                          CircularProgressIndicator(color: Color(0xFF3B82F6)))
                  : DefaultTabController(
                      length: 4,
                      child: Column(children: [
                        Container(
                            color: const Color(0xFF101010),
                            child: TabBar(
                                indicatorColor: const Color(0xFF3B82F6),
                                labelColor: const Color(0xFFF1F1F1),
                                unselectedLabelColor: const Color(0xFF7B7B7B),
                                labelStyle: GoogleFonts.inter(
                                    fontSize: 14, fontWeight: FontWeight.w500),
                                tabs: const [
                                  Tab(text: 'Research'),
                                  Tab(text: 'Sets'),
                                  Tab(text: 'Analytics'),
                                  Tab(text: 'Generator'),
                                ])),
                        Expanded(
                            child: TabBarView(children: [
                          // Research Tab
                          Column(children: [
                            // Trending Section
                            TrendingHashtagsWidget(),

                            // Results List
                            Expanded(
                                child: ListView.builder(
                                    padding: const EdgeInsets.all(16),
                                    itemCount: _hashtags.length,
                                    itemBuilder: (context, index) {
                                      final hashtag = _hashtags[index];
                                      return HashtagCardWidget(
                                          hashtag: hashtag,
                                          onSave: () {
                                            // Save hashtag
                                          },
                                          onAddToSet: () {
                                            // Add to set
                                          },
                                          onLongPress: () {
                                            // Show quick actions
                                          });
                                    })),
                          ]),

                          // Sets Tab
                          HashtagSetsWidget(
                              savedSets: _savedSets,
                              onCreateSet: () {
                                // Create new set
                              },
                              onEditSet: (set) {
                                // Edit set
                              }),

                          // Analytics Tab
                          HashtagAnalyticsWidget(hashtags: _hashtags),

                          // Generator Tab
                          HashtagGeneratorWidget(onGenerate: (description) {
                            // Generate hashtags
                          }),
                        ])),
                      ]))),
        ])));
  }
}
