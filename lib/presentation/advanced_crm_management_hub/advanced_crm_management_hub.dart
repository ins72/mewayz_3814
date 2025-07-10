import 'dart:async';


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

  // Remove hard-coded data - now loaded from Supabase
  List<Map<String, dynamic>> _contacts = [];
  bool _isLoading = false;
  final DataService _dataService = DataService();

  final List<Map<String, dynamic>> _pipelineStages = [
{ 'id': 'new',
'name': 'New',
'color': const Color(0xFF6B7280),
'count': 0,
'value': 0,
'conversionRate': 0.15,
'avgTime': 7 },
{ 'id': 'qualified',
'name': 'Qualified',
'color': const Color(0xFF3B82F6),
'count': 0,
'value': 0,
'conversionRate': 0.35,
'avgTime': 14 },
{ 'id': 'proposal',
'name': 'Proposal',
'color': const Color(0xFFF59E0B),
'count': 0,
'value': 0,
'conversionRate': 0.65,
'avgTime': 21 },
{ 'id': 'negotiation',
'name': 'Negotiation',
'color': const Color(0xFF10B981),
'count': 0,
'value': 0,
'conversionRate': 0.85,
'avgTime': 10 },
{ 'id': 'closed',
'name': 'Closed Won',
'color': const Color(0xFF059669),
'count': 0,
'value': 0,
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
    
    _initializeData();
    _initializeRealTimeUpdates();
    _animationController.forward();
  }

  // Initialize data from Supabase
  Future<void> _initializeData() async {
    setState(() => _isLoading = true);
    
    try {
      await _dataService.initialize();
      await _loadContactsFromSupabase();
      _updatePipelineStages();
    } catch (e) {
      ErrorHandler.handleError('Failed to initialize CRM data: $e');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  // Load contacts from Supabase
  Future<void> _loadContactsFromSupabase() async {
    try {
      final contacts = await _dataService.getContacts();
      setState(() {
        _contacts = contacts;
      });
      _contactsStreamController.add(_contacts);
    } catch (e) {
      ErrorHandler.handleError('Failed to load contacts: $e');
    }
  }

  // Update pipeline stages with real counts from Supabase data
  void _updatePipelineStages() {
    final stageStats = <String, Map<String, dynamic>>{};
    
    for (final contact in _contacts) {
      final stage = contact['stage'] ?? 'new';
      if (!stageStats.containsKey(stage)) {
        stageStats[stage] = {'count': 0, 'value': 0.0};
      }
      
      stageStats[stage]!['count'] = (stageStats[stage]!['count'] as int) + 1;
      stageStats[stage]!['value'] = (stageStats[stage]!['value'] as double) + 
                                   (contact['deal_value'] as num? ?? 0).toDouble();
    }
    
    // Update pipeline stages with real data
    for (final stage in _pipelineStages) {
      final stageId = stage['id'] as String;
      final stats = stageStats[stageId];
      if (stats != null) {
        stage['count'] = stats['count'];
        stage['value'] = stats['value'];
      }
    }
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
    // Refresh data from Supabase
    _loadContactsFromSupabase();
  }

  void _onSearchChanged(String query) {
    _searchDebounceTimer?.cancel();
    _searchDebounceTimer = Timer(const Duration(milliseconds: 300), () {
      _performSearch(query);
    });
  }

  void _performSearch(String query) {
    if (query.isEmpty) {
      _contactsStreamController.add(_contacts);
      return;
    }
    
    final filtered = _contacts.where((contact) {
      return contact['name'].toString().toLowerCase().contains(query.toLowerCase()) ||
             contact['company'].toString().toLowerCase().contains(query.toLowerCase()) ||
             contact['email'].toString().toLowerCase().contains(query.toLowerCase()) ||
             (contact['tags'] as List?)?.any((tag) => tag.toString().toLowerCase().contains(query.toLowerCase())) == true;
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
        onUpdate: (updatedContact) async {
          try {
            await _dataService.updateContact(updatedContact['id'], updatedContact);
            await _loadContactsFromSupabase();
            _updatePipelineStages();
          } catch (e) {
            ErrorHandler.handleError('Failed to update contact: $e');
          }
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
        contacts: _contacts,
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
    if (_isLoading) {
      return const Center(
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(AppTheme.accent),
        ),
      );
    }

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
              contacts: _contacts,
              onContactMove: (contactId, newStage) async {
                try {
                  await _dataService.updateContact(contactId, {'stage': newStage});
                  await _loadContactsFromSupabase();
                  _updatePipelineStages();
                } catch (e) {
                  ErrorHandler.handleError('Failed to move contact: $e');
                }
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
              contacts: _contacts,
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
              
              if (contacts.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.people_outline,
                        size: 64,
                        color: AppTheme.secondaryText,
                      ),
                      SizedBox(height: 16),
                      Text(
                        'No contacts found',
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: AppTheme.secondaryText,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        'Add your first contact to get started',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: AppTheme.secondaryText,
                        ),
                      ),
                    ],
                  ),
                );
              }
              
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
            onSelected: (value) async {
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
              onPressed: () async {
                // Handle add contact - could show a form modal
                // For now, just refresh data
                await _loadContactsFromSupabase();
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