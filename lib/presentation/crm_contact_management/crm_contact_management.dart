import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/add_contact_widget.dart';
import './widgets/bulk_actions_widget.dart';
import './widgets/contact_card_widget.dart';
import './widgets/contact_detail_widget.dart';
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
  final Set<String> _selectedContacts = {};
  String _selectedFilter = 'All';
  String _selectedSource = 'All';
  String _selectedDateRange = 'All Time';

  // Mock data for contacts
  final List<Map<String, dynamic>> _contacts = [
    {
      "id": "1",
      "name": "Sarah Johnson",
      "company": "TechCorp Inc.",
      "email": "sarah.johnson@techcorp.com",
      "phone": "+1 (555) 123-4567",
      "profileImage":
          "https://cdn.pixabay.com/photo/2015/03/04/22/35/avatar-659652_640.png",
      "leadScore": 85,
      "stage": "Qualified",
      "source": "Website",
      "lastActivity": "2 hours ago",
      "value": "\$15,000",
      "notes": "Interested in enterprise solution",
      "tags": ["Hot Lead", "Enterprise"],
      "activities": [
        {
          "type": "email_open",
          "description": "Opened email: Product Demo Invitation",
          "timestamp": "2 hours ago"
        },
        {
          "type": "website_visit",
          "description": "Visited pricing page",
          "timestamp": "1 day ago"
        }
      ]
    },
    {
      "id": "2",
      "name": "Michael Chen",
      "company": "StartupXYZ",
      "email": "m.chen@startupxyz.com",
      "phone": "+1 (555) 987-6543",
      "profileImage":
          "https://cdn.pixabay.com/photo/2015/03/04/22/35/avatar-659652_640.png",
      "leadScore": 72,
      "stage": "Proposal",
      "source": "LinkedIn",
      "lastActivity": "1 day ago",
      "value": "\$8,500",
      "notes": "Budget approved, waiting for final decision",
      "tags": ["Warm Lead", "SMB"],
      "activities": [
        {
          "type": "link_click",
          "description": "Clicked proposal link",
          "timestamp": "1 day ago"
        },
        {
          "type": "email_reply",
          "description": "Replied to proposal email",
          "timestamp": "2 days ago"
        }
      ]
    },
    {
      "id": "3",
      "name": "Emily Rodriguez",
      "company": "Global Solutions",
      "email": "emily.r@globalsolutions.com",
      "phone": "+1 (555) 456-7890",
      "profileImage":
          "https://cdn.pixabay.com/photo/2015/03/04/22/35/avatar-659652_640.png",
      "leadScore": 91,
      "stage": "Negotiation",
      "source": "Referral",
      "lastActivity": "30 minutes ago",
      "value": "\$25,000",
      "notes": "Ready to close, discussing contract terms",
      "tags": ["Hot Lead", "Enterprise", "Priority"],
      "activities": [
        {
          "type": "meeting",
          "description": "Attended contract review meeting",
          "timestamp": "30 minutes ago"
        },
        {
          "type": "phone_call",
          "description": "Discussed pricing options",
          "timestamp": "3 hours ago"
        }
      ]
    },
    {
      "id": "4",
      "name": "David Kim",
      "company": "Innovation Labs",
      "email": "david.kim@innovationlabs.com",
      "phone": "+1 (555) 321-0987",
      "profileImage":
          "https://cdn.pixabay.com/photo/2015/03/04/22/35/avatar-659652_640.png",
      "leadScore": 58,
      "stage": "New",
      "source": "Cold Email",
      "lastActivity": "3 days ago",
      "value": "\$5,000",
      "notes": "Initial contact made, needs follow-up",
      "tags": ["Cold Lead"],
      "activities": [
        {
          "type": "email_sent",
          "description": "Sent introduction email",
          "timestamp": "3 days ago"
        }
      ]
    },
    {
      "id": "5",
      "name": "Lisa Thompson",
      "company": "Digital Marketing Pro",
      "email": "lisa@digitalmarketingpro.com",
      "phone": "+1 (555) 654-3210",
      "profileImage":
          "https://cdn.pixabay.com/photo/2015/03/04/22/35/avatar-659652_640.png",
      "leadScore": 79,
      "stage": "Demo Scheduled",
      "source": "Social Media",
      "lastActivity": "5 hours ago",
      "value": "\$12,000",
      "notes": "Demo scheduled for tomorrow",
      "tags": ["Warm Lead", "SMB"],
      "activities": [
        {
          "type": "demo_scheduled",
          "description": "Scheduled product demo",
          "timestamp": "5 hours ago"
        },
        {
          "type": "email_open",
          "description": "Opened demo confirmation email",
          "timestamp": "6 hours ago"
        }
      ]
    }
  ];

  final List<Map<String, dynamic>> _pipelineStages = [
    {
      "name": "New",
      "count": 12,
      "value": "\$45,000",
      "color": AppTheme.secondaryText
    },
    {
      "name": "Qualified",
      "count": 8,
      "value": "\$78,000",
      "color": AppTheme.accent
    },
    {
      "name": "Demo Scheduled",
      "count": 5,
      "value": "\$35,000",
      "color": AppTheme.warning
    },
    {
      "name": "Proposal",
      "count": 3,
      "value": "\$28,000",
      "color": AppTheme.success
    },
    {
      "name": "Negotiation",
      "count": 2,
      "value": "\$50,000",
      "color": AppTheme.error
    },
    {
      "name": "Closed Won",
      "count": 15,
      "value": "\$125,000",
      "color": AppTheme.success
    },
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  List<Map<String, dynamic>> get _filteredContacts {
    return _contacts.where((contact) {
      final matchesSearch = contact['name']
              .toString()
              .toLowerCase()
              .contains(_searchController.text.toLowerCase()) ||
          contact['company']
              .toString()
              .toLowerCase()
              .contains(_searchController.text.toLowerCase());

      final matchesFilter = _selectedFilter == 'All' ||
          contact['stage'].toString() == _selectedFilter;

      final matchesSource = _selectedSource == 'All' ||
          contact['source'].toString() == _selectedSource;

      return matchesSearch && matchesFilter && matchesSource;
    }).toList();
  }

  Color _getLeadScoreColor(int score) {
    if (score >= 80) return AppTheme.success;
    if (score >= 60) return AppTheme.warning;
    return AppTheme.error;
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

  Widget _buildSearchBar() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
      decoration: BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppTheme.border),
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _searchController,
              style: AppTheme.darkTheme.textTheme.bodyMedium,
              decoration: InputDecoration(
                hintText: 'Search contacts...',
                hintStyle: AppTheme.darkTheme.textTheme.bodyMedium?.copyWith(
                  color: AppTheme.secondaryText,
                ),
                prefixIcon: CustomIconWidget(
                  iconName: 'search',
                  color: AppTheme.secondaryText,
                  size: 20,
                ),
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(vertical: 2.h),
              ),
              onChanged: (value) => setState(() {}),
            ),
          ),
          GestureDetector(
            onTap: () {
              // Voice search functionality
            },
            child: Container(
              padding: EdgeInsets.all(2.w),
              child: CustomIconWidget(
                iconName: 'mic',
                color: AppTheme.accent,
                size: 20,
              ),
            ),
          ),
          GestureDetector(
            onTap: _showFilterOptions,
            child: Container(
              padding: EdgeInsets.all(2.w),
              child: CustomIconWidget(
                iconName: 'filter_list',
                color: AppTheme.accent,
                size: 20,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showFilterOptions() {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppTheme.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: EdgeInsets.all(4.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Filter Contacts',
              style: AppTheme.darkTheme.textTheme.titleLarge,
            ),
            SizedBox(height: 3.h),
            _buildFilterSection(
                'Lead Status',
                _selectedFilter,
                [
                  'All',
                  'New',
                  'Qualified',
                  'Demo Scheduled',
                  'Proposal',
                  'Negotiation',
                  'Closed Won'
                ],
                (value) => setState(() => _selectedFilter = value)),
            SizedBox(height: 2.h),
            _buildFilterSection(
                'Source',
                _selectedSource,
                [
                  'All',
                  'Website',
                  'LinkedIn',
                  'Referral',
                  'Cold Email',
                  'Social Media'
                ],
                (value) => setState(() => _selectedSource = value)),
            SizedBox(height: 2.h),
            _buildFilterSection(
                'Date Range',
                _selectedDateRange,
                [
                  'All Time',
                  'Today',
                  'This Week',
                  'This Month',
                  'Last 30 Days'
                ],
                (value) => setState(() => _selectedDateRange = value)),
            SizedBox(height: 3.h),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      setState(() {
                        _selectedFilter = 'All';
                        _selectedSource = 'All';
                        _selectedDateRange = 'All Time';
                      });
                      Navigator.pop(context);
                    },
                    child: Text('Clear All'),
                  ),
                ),
                SizedBox(width: 4.w),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text('Apply'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterSection(String title, String selectedValue,
      List<String> options, Function(String) onChanged) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: AppTheme.darkTheme.textTheme.titleSmall,
        ),
        SizedBox(height: 1.h),
        Wrap(
          spacing: 2.w,
          children: options.map((option) {
            final isSelected = selectedValue == option;
            return GestureDetector(
              onTap: () => onChanged(option),
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
                decoration: BoxDecoration(
                  color: isSelected ? AppTheme.accent : Colors.transparent,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: isSelected ? AppTheme.accent : AppTheme.border,
                  ),
                ),
                child: Text(
                  option,
                  style: AppTheme.darkTheme.textTheme.bodySmall?.copyWith(
                    color: isSelected
                        ? AppTheme.primaryAction
                        : AppTheme.primaryText,
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildContactsList() {
    return RefreshIndicator(
      onRefresh: () async {
        // Simulate refresh
        await Future.delayed(Duration(seconds: 1));
      },
      child: ListView.builder(
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
        break;
      case 'email':
        // Implement email functionality
        break;
      case 'message':
        // Implement message functionality
        break;
      case 'meeting':
        // Implement meeting scheduling
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.primaryBackground,
      appBar: AppBar(
        title: Text('CRM Contacts'),
        actions: [
          if (_isMultiSelectMode)
            TextButton(
              onPressed: _showBulkActions,
              child: Text('Actions (${_selectedContacts.length})'),
            )
          else ...[
            IconButton(
              onPressed: _toggleMultiSelect,
              icon: CustomIconWidget(
                iconName: 'checklist',
                color: AppTheme.primaryText,
                size: 24,
              ),
            ),
            IconButton(
              onPressed: _showImportContacts,
              icon: CustomIconWidget(
                iconName: 'upload_file',
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
              icon: CustomIconWidget(
                iconName: _isPipelineView ? 'list' : 'view_kanban',
                color: AppTheme.accent,
                size: 24,
              ),
            ),
          ],
        ],
      ),
      body: Column(
        children: [
          if (!_isPipelineView) _buildSearchBar(),
          Expanded(
            child:
                _isPipelineView ? _buildPipelineView() : _buildContactsList(),
          ),
        ],
      ),
      floatingActionButton: _isMultiSelectMode
          ? null
          : FloatingActionButton(
              onPressed: _showAddContact,
              child: CustomIconWidget(
                iconName: 'add',
                color: AppTheme.primaryBackground,
                size: 24,
              ),
            ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: 6,
        onTap: (index) {
          final routes = [
            AppRoutes.workspaceDashboard,
            AppRoutes.instagramLeadSearch,
            AppRoutes.socialMediaScheduler,
            AppRoutes.linkInBioBuilder,
            AppRoutes.courseCreator,
            AppRoutes.marketplaceStore,
            AppRoutes.crmContactManagement,
            AppRoutes.analyticsDashboard,
          ];
          if (index < routes.length) {
            Navigator.pushNamed(context, routes[index]);
          }
        },
        items: [
          BottomNavigationBarItem(
            icon: CustomIconWidget(
                iconName: 'home', color: AppTheme.secondaryText, size: 20),
            activeIcon: CustomIconWidget(
                iconName: 'home', color: AppTheme.accent, size: 20),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: CustomIconWidget(
                iconName: 'search', color: AppTheme.secondaryText, size: 20),
            activeIcon: CustomIconWidget(
                iconName: 'search', color: AppTheme.accent, size: 20),
            label: 'Search',
          ),
          BottomNavigationBarItem(
            icon: CustomIconWidget(
                iconName: 'schedule', color: AppTheme.secondaryText, size: 20),
            activeIcon: CustomIconWidget(
                iconName: 'schedule', color: AppTheme.accent, size: 20),
            label: 'Schedule',
          ),
          BottomNavigationBarItem(
            icon: CustomIconWidget(
                iconName: 'link', color: AppTheme.secondaryText, size: 20),
            activeIcon: CustomIconWidget(
                iconName: 'link', color: AppTheme.accent, size: 20),
            label: 'Bio',
          ),
          BottomNavigationBarItem(
            icon: CustomIconWidget(
                iconName: 'school', color: AppTheme.secondaryText, size: 20),
            activeIcon: CustomIconWidget(
                iconName: 'school', color: AppTheme.accent, size: 20),
            label: 'Courses',
          ),
          BottomNavigationBarItem(
            icon: CustomIconWidget(
                iconName: 'store', color: AppTheme.secondaryText, size: 20),
            activeIcon: CustomIconWidget(
                iconName: 'store', color: AppTheme.accent, size: 20),
            label: 'Store',
          ),
          BottomNavigationBarItem(
            icon: CustomIconWidget(
                iconName: 'contacts', color: AppTheme.accent, size: 20),
            activeIcon: CustomIconWidget(
                iconName: 'contacts', color: AppTheme.accent, size: 20),
            label: 'CRM',
          ),
          BottomNavigationBarItem(
            icon: CustomIconWidget(
                iconName: 'analytics', color: AppTheme.secondaryText, size: 20),
            activeIcon: CustomIconWidget(
                iconName: 'analytics', color: AppTheme.accent, size: 20),
            label: 'Analytics',
          ),
        ],
      ),
    );
  }
}
