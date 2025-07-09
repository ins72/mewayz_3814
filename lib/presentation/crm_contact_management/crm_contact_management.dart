import 'dart:async';

import '../../core/app_export.dart';
import './widgets/add_contact_widget.dart';
import './widgets/advanced_filter_widget.dart';
import './widgets/bulk_actions_widget.dart';
import './widgets/contact_analytics_widget.dart';
import './widgets/contact_card_widget.dart';
import './widgets/contact_detail_widget.dart';
import './widgets/crm_header_widget.dart';
import './widgets/crm_stats_widget.dart';
import './widgets/import_contacts_widget.dart';
import './widgets/pipeline_stage_widget.dart';

class CrmContactManagement extends StatefulWidget {
  const CrmContactManagement({Key? key}) : super(key: key);

  @override
  State<CrmContactManagement> createState() => _CrmContactManagementState();
}

class _CrmContactManagementState extends State<CrmContactManagement>
    with TickerProviderStateMixin {
  late TabController _tabController;
  final TextEditingController _searchController = TextEditingController();
  bool _isPipelineView = false;
  bool _isMultiSelectMode = false;
  bool _isRealTimeUpdatesEnabled = true;
  final Set<String> _selectedContacts = {};
  String _selectedFilter = 'All';
  String _selectedSource = 'All';
  String _selectedDateRange = 'All Time';
  String _sortBy = 'Name';
  bool _sortAscending = true;

  // Mock data for contacts
  final List<Map<String, dynamic>> _contacts = [
{ "id": "1",
"name": "Sarah Johnson",
"company": "TechCorp Inc.",
"email": "sarah.johnson@techcorp.com",
"phone": "+1 (555) 123-4567",
"profileImage": "https://cdn.pixabay.com/photo/2015/03/04/22/35/avatar-659652_640.png",
"leadScore": 85,
"stage": "Qualified",
"source": "Website",
"lastActivity": "2 hours ago",
"value": "\$15,000",
"notes": "Interested in enterprise solution",
"tags": ["Hot Lead", "Enterprise"],
"priority": "high",
"activities": [ { "type": "email_open",
"description": "Opened email: Product Demo Invitation",
"timestamp": "2 hours ago" },
{ "type": "website_visit",
"description": "Visited pricing page",
"timestamp": "1 day ago" } ] },
{ "id": "2",
"name": "Michael Chen",
"company": "StartupXYZ",
"email": "m.chen@startupxyz.com",
"phone": "+1 (555) 987-6543",
"profileImage": "https://cdn.pixabay.com/photo/2015/03/04/22/35/avatar-659652_640.png",
"leadScore": 72,
"stage": "Proposal",
"source": "LinkedIn",
"lastActivity": "1 day ago",
"value": "\$8,500",
"notes": "Budget approved, waiting for final decision",
"tags": ["Warm Lead", "SMB"],
"priority": "medium",
"activities": [ { "type": "link_click",
"description": "Clicked proposal link",
"timestamp": "1 day ago" },
{ "type": "email_reply",
"description": "Replied to proposal email",
"timestamp": "2 days ago" } ] },
{ "id": "3",
"name": "Emily Rodriguez",
"company": "Global Solutions",
"email": "emily.r@globalsolutions.com",
"phone": "+1 (555) 456-7890",
"profileImage": "https://cdn.pixabay.com/photo/2015/03/04/22/35/avatar-659652_640.png",
"leadScore": 91,
"stage": "Negotiation",
"source": "Referral",
"lastActivity": "30 minutes ago",
"value": "\$25,000",
"notes": "Ready to close, discussing contract terms",
"tags": ["Hot Lead", "Enterprise", "Priority"],
"priority": "high",
"activities": [ { "type": "meeting",
"description": "Attended contract review meeting",
"timestamp": "30 minutes ago" },
{ "type": "phone_call",
"description": "Discussed pricing options",
"timestamp": "3 hours ago" } ] },
{ "id": "4",
"name": "David Kim",
"company": "Innovation Labs",
"email": "david.kim@innovationlabs.com",
"phone": "+1 (555) 321-0987",
"profileImage": "https://cdn.pixabay.com/photo/2015/03/04/22/35/avatar-659652_640.png",
"leadScore": 58,
"stage": "New",
"source": "Cold Email",
"lastActivity": "3 days ago",
"value": "\$5,000",
"notes": "Initial contact made, needs follow-up",
"tags": ["Cold Lead"],
"priority": "low",
"activities": [ { "type": "email_sent",
"description": "Sent introduction email",
"timestamp": "3 days ago" } ] },
{ "id": "5",
"name": "Lisa Thompson",
"company": "Digital Marketing Pro",
"email": "lisa@digitalmarketingpro.com",
"phone": "+1 (555) 654-3210",
"profileImage": "https://cdn.pixabay.com/photo/2015/03/04/22/35/avatar-659652_640.png",
"leadScore": 79,
"stage": "Demo Scheduled",
"source": "Social Media",
"lastActivity": "5 hours ago",
"value": "\$12,000",
"notes": "Demo scheduled for tomorrow",
"tags": ["Warm Lead", "SMB"],
"priority": "medium",
"activities": [ { "type": "demo_scheduled",
"description": "Scheduled product demo",
"timestamp": "5 hours ago" },
{ "type": "email_open",
"description": "Opened demo confirmation email",
"timestamp": "6 hours ago" } ] }
];

  final List<Map<String, dynamic>> _pipelineStages = [
{ "name": "New",
"count": 12,
"value": "\$45,000",
"color": AppTheme.secondaryText },
{ "name": "Qualified",
"count": 8,
"value": "\$78,000",
"color": AppTheme.accent },
{ "name": "Demo Scheduled",
"count": 5,
"value": "\$35,000",
"color": AppTheme.warning },
{ "name": "Proposal",
"count": 3,
"value": "\$28,000",
"color": AppTheme.success },
{ "name": "Negotiation",
"count": 2,
"value": "\$50,000",
"color": AppTheme.error },
{ "name": "Closed Won",
"count": 15,
"value": "\$125,000",
"color": AppTheme.success },
];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _startRealTimeUpdates();
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  void _startRealTimeUpdates() {
    if (_isRealTimeUpdatesEnabled) {
      // Simulate real-time updates
      Timer.periodic(const Duration(seconds: 30), (timer) {
        if (mounted && _isRealTimeUpdatesEnabled) {
          setState(() {
            // Update lead scores and activities
          });
        } else {
          timer.cancel();
        }
      });
    }
  }

  List<Map<String, dynamic>> get _filteredContacts {
    var filtered = _contacts.where((contact) {
      final matchesSearch = contact['name']
              .toString()
              .toLowerCase()
              .contains(_searchController.text.toLowerCase()) ||
          contact['company']
              .toString()
              .toLowerCase()
              .contains(_searchController.text.toLowerCase()) ||
          contact['email']
              .toString()
              .toLowerCase()
              .contains(_searchController.text.toLowerCase());

      final matchesFilter = _selectedFilter == 'All' ||
          contact['stage'].toString() == _selectedFilter;

      final matchesSource = _selectedSource == 'All' ||
          contact['source'].toString() == _selectedSource;

      return matchesSearch && matchesFilter && matchesSource;
    }).toList();

    // Sort contacts
    filtered.sort((a, b) {
      int comparison = 0;
      switch (_sortBy) {
        case 'Name':
          comparison = a['name'].toString().compareTo(b['name'].toString());
          break;
        case 'Company':
          comparison = a['company'].toString().compareTo(b['company'].toString());
          break;
        case 'Lead Score':
          comparison = a['leadScore'].compareTo(b['leadScore']);
          break;
        case 'Value':
          final aValue = double.tryParse(a['value'].toString().replaceAll(RegExp(r'[^\d.]'), '')) ?? 0;
          final bValue = double.tryParse(b['value'].toString().replaceAll(RegExp(r'[^\d.]'), '')) ?? 0;
          comparison = aValue.compareTo(bValue);
          break;
        case 'Last Activity':
          // Simple comparison for demo purposes
          comparison = a['lastActivity'].toString().compareTo(b['lastActivity'].toString());
          break;
      }
      return _sortAscending ? comparison : -comparison;
    });

    return filtered;
  }

  Color _getLeadScoreColor(int score) {
    if (score >= 80) return AppTheme.success;
    if (score >= 60) return AppTheme.warning;
    return AppTheme.error;
  }

  Color _getPriorityColor(String priority) {
    switch (priority) {
      case 'high':
        return AppTheme.error;
      case 'medium':
        return AppTheme.warning;
      case 'low':
        return AppTheme.success;
      default:
        return AppTheme.secondaryText;
    }
  }

  void _toggleMultiSelect() {
    setState(() {
      _isMultiSelectMode = !_isMultiSelectMode;
      if (!_isMultiSelectMode) {
        _selectedContacts.clear();
      }
    });
  }

  void _toggleContactSelection(String contactId) {
    setState(() {
      _selectedContacts.contains(contactId)
          ? _selectedContacts.remove(contactId)
          : _selectedContacts.add(contactId);
    });
  }

  void _showContactDetail(Map<String, dynamic> contact) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => ContactDetailWidget(
        contact: contact,
        onUpdate: (updatedContact) {
          setState(() {
            final index =
                _contacts.indexWhere((c) => c['id'] == updatedContact['id']);
            if (index != -1) {
              _contacts[index] = updatedContact;
            }
          });
        },
      ),
    );
  }

  void _showAddContact() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => AddContactWidget(
        onAdd: (newContact) {
          setState(() {
            _contacts.add(newContact);
          });
        },
      ),
    );
  }

  void _showBulkActions() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => BulkActionsWidget(
        selectedContacts: _selectedContacts,
        contacts: _contacts,
        onAction: (action) {
          setState(() {
            _isMultiSelectMode = false;
            _selectedContacts.clear();
          });
        },
      ),
    );
  }

  void _showImportContacts() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => ImportContactsWidget(
        onImport: (importedContacts) {
          setState(() {
            _contacts.addAll(importedContacts);
          });
        },
      ),
    );
  }

  void _showAdvancedFilters() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => AdvancedFilterWidget(
        currentFilters: {
          'stage': _selectedFilter,
          'source': _selectedSource,
          'dateRange': _selectedDateRange,
        },
        onApply: (filters) {
          setState(() {
            _selectedFilter = filters['stage'] ?? 'All';
            _selectedSource = filters['source'] ?? 'All';
            _selectedDateRange = filters['dateRange'] ?? 'All Time';
          });
        },
      ),
    );
  }

  Widget _buildSearchAndFilterBar() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
      child: Row(
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: AppTheme.surface,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppTheme.border),
              ),
              child: TextField(
                controller: _searchController,
                style: Theme.of(context).textTheme.bodyMedium,
                decoration: InputDecoration(
                  hintText: 'Search contacts, companies, emails...',
                  hintStyle: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppTheme.secondaryText,
                  ),
                  prefixIcon: const Icon(
                    Icons.search,
                    color: AppTheme.secondaryText,
                    size: 20,
                  ),
                  suffixIcon: _searchController.text.isNotEmpty
                      ? IconButton(
                          icon: const Icon(
                            Icons.clear,
                            color: AppTheme.secondaryText,
                            size: 20,
                          ),
                          onPressed: () {
                            _searchController.clear();
                            setState(() {});
                          },
                        )
                      : null,
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 4.w,
                    vertical: 3.h,
                  ),
                ),
                onChanged: (value) => setState(() {}),
              ),
            ),
          ),
          SizedBox(width: 3.w),
          GestureDetector(
            onTap: _showAdvancedFilters,
            child: Container(
              padding: EdgeInsets.all(3.w),
              decoration: BoxDecoration(
                color: AppTheme.surface,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppTheme.border),
              ),
              child: const Icon(
                Icons.tune,
                color: AppTheme.accent,
                size: 24,
              ),
            ),
          ),
          SizedBox(width: 3.w),
          GestureDetector(
            onTap: _showSortOptions,
            child: Container(
              padding: EdgeInsets.all(3.w),
              decoration: BoxDecoration(
                color: AppTheme.surface,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppTheme.border),
              ),
              child: Icon(
                _sortAscending ? Icons.arrow_upward : Icons.arrow_downward,
                color: AppTheme.accent,
                size: 24,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showSortOptions() {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppTheme.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: EdgeInsets.all(6.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 12.w,
              height: 0.5.h,
              decoration: BoxDecoration(
                color: AppTheme.border,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            SizedBox(height: 4.h),
            Text(
              'Sort Contacts',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            SizedBox(height: 4.h),
            ...['Name', 'Company', 'Lead Score', 'Value', 'Last Activity'].map((option) {
              return ListTile(
                leading: Icon(
                  _sortBy == option ? Icons.check_circle : Icons.circle_outlined,
                  color: _sortBy == option ? AppTheme.accent : AppTheme.secondaryText,
                ),
                title: Text(option),
                trailing: _sortBy == option
                    ? Icon(
                        _sortAscending ? Icons.arrow_upward : Icons.arrow_downward,
                        color: AppTheme.accent,
                      )
                    : null,
                onTap: () {
                  setState(() {
                    if (_sortBy == option) {
                      _sortAscending = !_sortAscending;
                    } else {
                      _sortBy = option;
                      _sortAscending = true;
                    }
                  });
                  Navigator.pop(context);
                },
              );
            }).toList(),
          ],
        ),
      ),
    );
  }

  Widget _buildContactsList() {
    return RefreshIndicator(
      onRefresh: () async {
        // Simulate refresh
        await Future.delayed(const Duration(seconds: 1));
        setState(() {});
      },
      child: _filteredContacts.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.search_off,
                    size: 64,
                    color: AppTheme.secondaryText,
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    'No contacts found',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  SizedBox(height: 2.h),
                  Text(
                    'Try adjusting your search or filters',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: AppTheme.secondaryText,
                    ),
                  ),
                ],
              ),
            )
          : ListView.builder(
              padding: EdgeInsets.symmetric(horizontal: 4.w),
              itemCount: _filteredContacts.length,
              itemBuilder: (context, index) {
                final contact = _filteredContacts[index];
                return ContactCardWidget(
                  contact: contact,
                  isSelected: _selectedContacts.contains(contact['id']),
                  isMultiSelectMode: _isMultiSelectMode,
                  onTap: () => _isMultiSelectMode
                      ? _toggleContactSelection(contact['id'])
                      : _showContactDetail(contact),
                  onLongPress: () => _toggleContactSelection(contact['id']),
                  onQuickAction: (action) => _handleQuickAction(action, contact),
                  leadScoreColor: _getLeadScoreColor(contact['leadScore']),
                  priorityColor: _getPriorityColor(contact['priority']),
                );
              },
            ),
    );
  }

  Widget _buildPipelineView() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
      child: Row(
        children: _pipelineStages.map((stage) {
          final stageContacts = _contacts
              .where((contact) => contact['stage'] == stage['name'])
              .toList();

          return Container(
            width: 70.w,
            margin: EdgeInsets.only(right: 4.w),
            child: PipelineStageWidget(
              stage: stage,
              contacts: stageContacts,
              onContactTap: _showContactDetail,
              onContactMove: (contact, newStage) {
                setState(() {
                  final index =
                      _contacts.indexWhere((c) => c['id'] == contact['id']);
                  if (index != -1) {
                    _contacts[index]['stage'] = newStage;
                  }
                });
              },
            ),
          );
        }).toList(),
      ),
    );
  }

  void _handleQuickAction(String action, Map<String, dynamic> contact) {
    switch (action) {
      case 'call':
        // Implement call functionality
        HapticFeedback.lightImpact();
        break;
      case 'email':
        // Implement email functionality
        HapticFeedback.lightImpact();
        break;
      case 'message':
        // Implement message functionality
        HapticFeedback.lightImpact();
        break;
      case 'meeting':
        // Implement meeting scheduling
        HapticFeedback.lightImpact();
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.primaryBackground,
      appBar: AppBar(
        title: const CrmHeaderWidget(),
        actions: [
          IconButton(
            icon: Icon(
              _isRealTimeUpdatesEnabled ? Icons.sync : Icons.sync_disabled,
              color: _isRealTimeUpdatesEnabled ? AppTheme.success : AppTheme.secondaryText,
            ),
            onPressed: () {
              setState(() {
                _isRealTimeUpdatesEnabled = !_isRealTimeUpdatesEnabled;
              });
              if (_isRealTimeUpdatesEnabled) {
                _startRealTimeUpdates();
              }
            },
          ),
          if (_isMultiSelectMode)
            TextButton(
              onPressed: _showBulkActions,
              child: Text('Actions (${_selectedContacts.length})'),
            )
          else ...[
            IconButton(
              onPressed: _toggleMultiSelect,
              icon: const Icon(
                Icons.checklist,
                color: AppTheme.primaryText,
                size: 24,
              ),
            ),
            IconButton(
              onPressed: _showImportContacts,
              icon: const Icon(
                Icons.upload_file,
                color: AppTheme.primaryText,
                size: 24,
              ),
            ),
            IconButton(
              onPressed: () {
                setState(() {
                  _isPipelineView = !_isPipelineView;
                });
              },
              icon: Icon(
                _isPipelineView ? Icons.list : Icons.view_kanban,
                color: AppTheme.accent,
                size: 24,
              ),
            ),
          ],
        ],
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Contacts'),
            Tab(text: 'Analytics'),
            Tab(text: 'Pipeline'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          // Contacts Tab
          Column(
            children: [
              const CrmStatsWidget(),
              if (!_isPipelineView) _buildSearchAndFilterBar(),
              Expanded(
                child: _isPipelineView ? _buildPipelineView() : _buildContactsList(),
              ),
            ],
          ),
          // Analytics Tab
          const ContactAnalyticsWidget(),
          // Pipeline Tab
          _buildPipelineView(),
        ],
      ),
      floatingActionButton: _isMultiSelectMode
          ? null
          : FloatingActionButton.extended(
              onPressed: _showAddContact,
              backgroundColor: AppTheme.accent,
              foregroundColor: AppTheme.primaryAction,
              icon: const Icon(Icons.person_add),
              label: const Text('Add Contact'),
            ),
    );
  }
}