import 'dart:async';
import 'dart:math' as math;


import '../../core/app_export.dart';
import './widgets/advanced_automation_builder_widget.dart';
import './widgets/advanced_contact_detail_widget.dart';
import './widgets/advanced_contact_list_widget.dart';
import './widgets/advanced_pipeline_view_widget.dart';
import './widgets/advanced_search_widget.dart';
import './widgets/collaboration_widget.dart';
import './widgets/crm_analytics_widget.dart';
import './widgets/crm_header_widget.dart';
import './widgets/pipeline_management_widget.dart';
import './widgets/voice_input_widget.dart';
import './widgets/workflow_automation_widget.dart';

class AdvancedCrmManagementHub extends StatefulWidget {
  const AdvancedCrmManagementHub({Key? key}) : super(key: key);

  @override
  State<AdvancedCrmManagementHub> createState() => _AdvancedCrmManagementHubState();
}

class _AdvancedCrmManagementHubState extends State<AdvancedCrmManagementHub>
    with TickerProviderStateMixin {
  late TabController _tabController;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  
  final TextEditingController _searchController = TextEditingController();
  final StreamController<List<Map<String, dynamic>>> _contactsStreamController = 
      StreamController<List<Map<String, dynamic>>>.broadcast();
  
  bool _isAdvancedSearch = false;
  bool _isPipelineView = false;
  bool _isRealTimeEnabled = true;
  bool _isVoiceInput = false;
  String _activeView = 'contacts';
  String _selectedSearchPreset = 'All';
  Map<String, dynamic> _searchFilters = {};
  Set<String> _selectedContacts = {};
  List<String> _savedSearches = ['Hot Leads', 'Enterprise Deals', 'This Week'];
  
  Timer? _realTimeTimer;
  Timer? _searchDebounceTimer;

  final List<Map<String, dynamic>> _mockContacts = [
{ 'id': '1',
'name': 'Sarah Johnson',
'company': 'TechCorp Inc.',
'email': 'sarah.johnson@techcorp.com',
'phone': '+1 (555) 123-4567',
'profileImage': 'https://images.unsplash.com/photo-1494790108755-2616b84cc2fa?w=400&h=400&fit=crop&crop=face',
'leadScore': 94,
'stage': 'Negotiation',
'source': 'LinkedIn',
'value': 125000,
'priority': 'high',
'lastActivity': DateTime.now().subtract(const Duration(hours: 2)),
'tags': ['Enterprise', 'Hot Lead', 'Decision Maker'],
'notes': 'CEO interested in enterprise solution. Budget approved. Expects proposal by Friday.',
'activities': [ { 'type': 'meeting',
'title': 'Contract negotiation call',
'timestamp': DateTime.now().subtract(const Duration(hours: 2)),
'outcome': 'Positive - ready to proceed' },
{ 'type': 'email',
'title': 'Sent proposal document',
'timestamp': DateTime.now().subtract(const Duration(hours: 6)),
'outcome': 'Opened and reviewed' } ],
'interactions': 47,
'conversionProbability': 0.92,
'nextAction': 'Follow up on contract terms',
'assignedTo': 'John Smith',
'customFields': { 'industry': 'Technology',
'employees': '500+',
'revenue': '50M+' } },
{ 'id': '2',
'name': 'Michael Chen',
'company': 'Innovation Labs',
'email': 'm.chen@innovationlabs.com',
'phone': '+1 (555) 987-6543',
'profileImage': 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=400&h=400&fit=crop&crop=face',
'leadScore': 78,
'stage': 'Qualified',
'source': 'Website',
'value': 85000,
'priority': 'medium',
'lastActivity': DateTime.now().subtract(const Duration(hours: 8)),
'tags': ['SMB', 'Warm Lead', 'Technical'],
'notes': 'CTO evaluating solution. Needs technical deep dive. Scheduled demo for next week.',
'activities': [ { 'type': 'demo',
'title': 'Product demo scheduled',
'timestamp': DateTime.now().subtract(const Duration(hours: 8)),
'outcome': 'Confirmed attendance' } ],
'interactions': 23,
'conversionProbability': 0.65,
'nextAction': 'Prepare technical demo',
'assignedTo': 'Emma Davis',
'customFields': { 'industry': 'Healthcare',
'employees': '50-200',
'revenue': '10M+' } },
{ 'id': '3',
'name': 'Emily Rodriguez',
'company': 'Global Solutions',
'email': 'emily.r@globalsolutions.com',
'phone': '+1 (555) 456-7890',
'profileImage': 'https://images.unsplash.com/photo-1534528741775-53994a69daeb?w=400&h=400&fit=crop&crop=face',
'leadScore': 91,
'stage': 'Proposal',
'source': 'Referral',
'value': 175000,
'priority': 'high',
'lastActivity': DateTime.now().subtract(const Duration(minutes: 30)),
'tags': ['Enterprise', 'Referral', 'Hot Lead'],
'notes': 'Referred by existing client. Very interested. Fast decision maker.',
'activities': [ { 'type': 'call',
'title': 'Discovery call completed',
'timestamp': DateTime.now().subtract(const Duration(minutes: 30)),
'outcome': 'Excellent fit - moving to proposal' } ],
'interactions': 18,
'conversionProbability': 0.88,
'nextAction': 'Send customized proposal',
'assignedTo': 'Michael Brown',
'customFields': { 'industry': 'Finance',
'employees': '1000+',
'revenue': '100M+' } }
];

  final List<Map<String, dynamic>> _pipelineStages = [
{ 'id': 'new',
'name': 'New',
'color': const Color(0xFF6B7280),
'count': 12,
'value': 450000,
'conversionRate': 0.15,
'avgTime': 7 },
{ 'id': 'qualified',
'name': 'Qualified',
'color': const Color(0xFF3B82F6),
'count': 8,
'value': 780000,
'conversionRate': 0.35,
'avgTime': 14 },
{ 'id': 'proposal',
'name': 'Proposal',
'color': const Color(0xFFF59E0B),
'count': 5,
'value': 350000,
'conversionRate': 0.65,
'avgTime': 21 },
{ 'id': 'negotiation',
'name': 'Negotiation',
'color': const Color(0xFF10B981),
'count': 3,
'value': 280000,
'conversionRate': 0.85,
'avgTime': 10 },
{ 'id': 'closed',
'name': 'Closed Won',
'color': const Color(0xFF059669),
'count': 15,
'value': 1250000,
'conversionRate': 1.0,
'avgTime': 0 }
];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    
    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
    
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.1),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOutCubic,
    ));
    
    _initializeRealTimeUpdates();
    _contactsStreamController.add(_mockContacts);
    _animationController.forward();
  }

  @override
  void dispose() {
    _tabController.dispose();
    _animationController.dispose();
    _searchController.dispose();
    _contactsStreamController.close();
    _realTimeTimer?.cancel();
    _searchDebounceTimer?.cancel();
    super.dispose();
  }

  void _initializeRealTimeUpdates() {
    if (_isRealTimeEnabled) {
      _realTimeTimer = Timer.periodic(const Duration(seconds: 30), (timer) {
        if (mounted) {
          _updateRealTimeData();
        }
      });
    }
  }

  void _updateRealTimeData() {
    // Simulate real-time updates
    final updatedContacts = List<Map<String, dynamic>>.from(_mockContacts);
    for (var contact in updatedContacts) {
      // Simulate lead score changes
      final scoreChange = (math.Random().nextDouble() - 0.5) * 5;
      contact['leadScore'] = math.max(0, math.min(100, (contact['leadScore'] as num).toInt() + scoreChange.toInt()));
      
      // Simulate activity updates
      if (math.Random().nextDouble() < 0.3) {
        contact['lastActivity'] = DateTime.now().subtract(
          Duration(minutes: math.Random().nextInt(60))
        );
      }
    }
    
    if (mounted) {
      setState(() {
        _mockContacts.clear();
        _mockContacts.addAll(updatedContacts);
      });
      _contactsStreamController.add(updatedContacts);
    }
  }

  void _onSearchChanged(String query) {
    _searchDebounceTimer?.cancel();
    _searchDebounceTimer = Timer(const Duration(milliseconds: 300), () {
      _performSearch(query);
    });
  }

  void _performSearch(String query) {
    if (query.isEmpty) {
      _contactsStreamController.add(_mockContacts);
      return;
    }
    
    final filtered = _mockContacts.where((contact) {
      return contact['name'].toString().toLowerCase().contains(query.toLowerCase()) ||
             contact['company'].toString().toLowerCase().contains(query.toLowerCase()) ||
             contact['email'].toString().toLowerCase().contains(query.toLowerCase()) ||
             contact['tags'].any((tag) => tag.toString().toLowerCase().contains(query.toLowerCase()));
    }).toList();
    
    _contactsStreamController.add(filtered);
  }

  void _toggleVoiceInput() {
    setState(() {
      _isVoiceInput = !_isVoiceInput;
    });
    
    if (_isVoiceInput) {
      _showVoiceInputModal();
    }
  }

  void _showVoiceInputModal() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => VoiceInputWidget(
        onVoiceResult: (text) {
          _searchController.text = text;
          _onSearchChanged(text);
        },
      ),
    );
  }

  void _showAdvancedContactDetail(Map<String, dynamic> contact) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => AdvancedContactDetailWidget(
        contact: contact,
        onUpdate: (updatedContact) {
          setState(() {
            final index = _mockContacts.indexWhere((c) => c['id'] == updatedContact['id']);
            if (index != -1) {
              _mockContacts[index] = updatedContact;
            }
          });
          _contactsStreamController.add(_mockContacts);
        },
      ),
    );
  }

  void _showAutomationBuilder() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => AdvancedAutomationBuilderWidget(
        onSave: (workflow) {
          // Handle workflow save
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Workflow "${workflow['name']}" saved successfully'),
                backgroundColor: AppTheme.success,
              ),
            );
          }
        },
      ),
    );
  }

  void _showPipelineManagement() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => PipelineManagementWidget(
        stages: _pipelineStages,
        onStageUpdate: (stages) {
          setState(() {
            _pipelineStages.clear();
            _pipelineStages.addAll(stages);
          });
        },
      ),
    );
  }

  void _showCollaborationPanel() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => CollaborationWidget(
        contacts: _mockContacts,
        onUpdate: (updates) {
          // Handle collaboration updates
          if (mounted) {
            setState(() {});
          }
        },
      ),
    );
  }

  Widget _buildTabContent() {
    return TabBarView(
      controller: _tabController,
      children: [
        // Contacts Overview
        SlideTransition(
          position: _slideAnimation,
          child: FadeTransition(
            opacity: _fadeAnimation,
            child: _buildContactsOverview(),
          ),
        ),
        // Pipeline Management
        SlideTransition(
          position: _slideAnimation,
          child: FadeTransition(
            opacity: _fadeAnimation,
            child: AdvancedPipelineViewWidget(
              stages: _pipelineStages,
              contacts: _mockContacts,
              onContactMove: (contactId, newStage) {
                setState(() {
                  final contact = _mockContacts.firstWhere((c) => c['id'] == contactId);
                  contact['stage'] = newStage;
                });
                _contactsStreamController.add(_mockContacts);
              },
              onStageManagement: _showPipelineManagement,
            ),
          ),
        ),
        // Analytics & Insights
        SlideTransition(
          position: _slideAnimation,
          child: FadeTransition(
            opacity: _fadeAnimation,
            child: CrmAnalyticsWidget(
              contacts: _mockContacts,
              stages: _pipelineStages,
            ),
          ),
        ),
        // Automation & Workflows
        SlideTransition(
          position: _slideAnimation,
          child: FadeTransition(
            opacity: _fadeAnimation,
            child: WorkflowAutomationWidget(
              onCreateWorkflow: _showAutomationBuilder,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildContactsOverview() {
    return Column(
      children: [
        // Enhanced Search Bar
        Container(
          margin: EdgeInsets.fromLTRB(4.w, 2.h, 4.w, 1.h),
          child: AdvancedSearchWidget(
            searchController: _searchController,
            isVoiceEnabled: _isVoiceInput,
            savedSearches: _savedSearches,
            selectedPreset: _selectedSearchPreset,
            onSearchChanged: _onSearchChanged,
            onVoiceToggle: _toggleVoiceInput,
            onPresetSelected: (preset) {
              setState(() {
                _selectedSearchPreset = preset;
              });
            },
            onAdvancedFilter: (filters) {
              setState(() {
                _searchFilters = filters;
              });
            },
          ),
        ),
        
        // Contact List
        Expanded(
          child: StreamBuilder<List<Map<String, dynamic>>>(
            stream: _contactsStreamController.stream,
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return const Center(child: CircularProgressIndicator());
              }
              
              final contacts = snapshot.data!;
              return AdvancedContactListWidget(
                contacts: contacts,
                selectedContacts: _selectedContacts,
                onContactTap: _showAdvancedContactDetail,
                onSelectionChanged: (selected) {
                  setState(() {
                    _selectedContacts = selected;
                  });
                },
              );
            },
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF101010),
      appBar: AppBar(
        backgroundColor: const Color(0xFF101010),
        elevation: 0,
        title: const CrmHeaderWidget(),
        actions: [
          // Real-time indicator
          Container(
            margin: EdgeInsets.only(right: 3.w),
            child: GestureDetector(
              onTap: () {
                setState(() {
                  _isRealTimeEnabled = !_isRealTimeEnabled;
                });
                if (_isRealTimeEnabled) {
                  _initializeRealTimeUpdates();
                } else {
                  _realTimeTimer?.cancel();
                }
              },
              child: Container(
                padding: EdgeInsets.all(2.w),
                decoration: BoxDecoration(
                  color: _isRealTimeEnabled ? AppTheme.success.withAlpha(26) : AppTheme.surface,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: _isRealTimeEnabled ? AppTheme.success : AppTheme.border,
                    width: 1,
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(
                        color: _isRealTimeEnabled ? AppTheme.success : AppTheme.secondaryText,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                    SizedBox(width: 2.w),
                    Text(
                      'Live',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: _isRealTimeEnabled ? AppTheme.success : AppTheme.secondaryText,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          
          // Collaboration button
          IconButton(
            onPressed: _showCollaborationPanel,
            icon: Stack(
              children: [
                const Icon(Icons.people, color: AppTheme.accent),
                Positioned(
                  right: 0,
                  top: 0,
                  child: Container(
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: AppTheme.success,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ),
              ],
            ),
          ),
          
          // Menu button
          PopupMenuButton<String>(
            icon: const Icon(Icons.more_vert, color: AppTheme.primaryText),
            color: AppTheme.surface,
            onSelected: (value) {
              switch (value) {
                case 'export':
                  // Handle export
                  break;
                case 'import':
                  // Handle import
                  break;
                case 'settings':
                  // Handle settings
                  break;
              }
            },
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'export',
                child: Row(
                  children: [
                    Icon(Icons.download, color: AppTheme.primaryText),
                    SizedBox(width: 12),
                    Text('Export Data'),
                  ],
                ),
              ),
              const PopupMenuItem(
                value: 'import',
                child: Row(
                  children: [
                    Icon(Icons.upload, color: AppTheme.primaryText),
                    SizedBox(width: 12),
                    Text('Import Contacts'),
                  ],
                ),
              ),
              const PopupMenuItem(
                value: 'settings',
                child: Row(
                  children: [
                    Icon(Icons.settings, color: AppTheme.primaryText),
                    SizedBox(width: 12),
                    Text('CRM Settings'),
                  ],
                ),
              ),
            ],
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(48),
          child: Container(
            decoration: BoxDecoration(
              color: const Color(0xFF191919),
              border: Border(
                top: BorderSide(color: AppTheme.border.withAlpha(51)),
              ),
            ),
            child: TabBar(
              controller: _tabController,
              indicatorColor: AppTheme.accent,
              indicatorWeight: 3,
              labelColor: AppTheme.primaryText,
              unselectedLabelColor: AppTheme.secondaryText,
              labelStyle: Theme.of(context).textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w600,
              ),
              unselectedLabelStyle: Theme.of(context).textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w400,
              ),
              tabs: const [
                Tab(text: 'Contacts'),
                Tab(text: 'Pipeline'),
                Tab(text: 'Analytics'),
                Tab(text: 'Automation'),
              ],
            ),
          ),
        ),
      ),
      body: _buildTabContent(),
      floatingActionButton: _selectedContacts.isEmpty
          ? FloatingActionButton.extended(
              backgroundColor: AppTheme.accent,
              foregroundColor: AppTheme.primaryAction,
              onPressed: () {
                // Handle add contact
              },
              icon: const Icon(Icons.person_add),
              label: const Text('Add Contact'),
            )
          : FloatingActionButton.extended(
              backgroundColor: AppTheme.success,
              foregroundColor: AppTheme.primaryAction,
              onPressed: () {
                // Handle bulk actions
              },
              icon: const Icon(Icons.done_all),
              label: Text('Actions (${_selectedContacts.length})'),
            ),
    );
  }
}