import 'package:flutter/material.dart';

import '../../core/app_export.dart';
import '../crm_contact_management/widgets/bulk_actions_widget.dart';
import './widgets/team_member_card_widget.dart';

class UsersTeamManagementScreen extends StatefulWidget {
  const UsersTeamManagementScreen({Key? key}) : super(key: key);

  @override
  State<UsersTeamManagementScreen> createState() =>
      _UsersTeamManagementScreenState();
}

class _UsersTeamManagementScreenState extends State<UsersTeamManagementScreen>
    with TickerProviderStateMixin {
  late TabController _tabController;
  final TextEditingController _searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  bool isLoading = false;
  bool isRefreshing = false;
  bool isMultiSelectMode = false;
  Set<String> selectedMembers = {};
  String searchQuery = '';
  String selectedRoleFilter = 'All';
  String selectedStatusFilter = 'All';
  String selectedActivityFilter = 'All';

  final List<Map<String, dynamic>> teamMembers = [
{ "id": "1",
"name": "Sarah Johnson",
"email": "sarah.johnson@company.com",
"role": "Admin",
"status": "Active",
"lastLogin": "2 minutes ago",
"isOnline": true,
"profileImage": "https://images.unsplash.com/photo-1494790108755-2616b9a75e20?w=150&h=150&fit=crop&crop=face",
"joinedDate": "2023-01-15",
"permissions": ["All Access"],
"activityScore": 98,
"deviceType": "Mobile",
"location": "New York, USA",
"lastActivity": "Viewed dashboard",
"sessionsCount": 45,
"featuresUsed": ["Dashboard", "CRM", "Analytics", "Social Media"],
},
{ "id": "2",
"name": "Michael Rodriguez",
"email": "michael.rodriguez@company.com",
"role": "Editor",
"status": "Active",
"lastLogin": "15 minutes ago",
"isOnline": true,
"profileImage": "https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=150&h=150&fit=crop&crop=face",
"joinedDate": "2023-02-20",
"permissions": ["Content Management", "Social Media", "CRM"],
"activityScore": 85,
"deviceType": "Desktop",
"location": "Los Angeles, USA",
"lastActivity": "Created social media post",
"sessionsCount": 32,
"featuresUsed": ["Social Media", "CRM", "Email Marketing"],
},
{ "id": "3",
"name": "Emma Davis",
"email": "emma.davis@company.com",
"role": "Viewer",
"status": "Inactive",
"lastLogin": "2 days ago",
"isOnline": false,
"profileImage": "https://images.unsplash.com/photo-1534528741775-53994a69daeb?w=150&h=150&fit=crop&crop=face",
"joinedDate": "2023-03-10",
"permissions": ["Read Only"],
"activityScore": 42,
"deviceType": "Mobile",
"location": "Chicago, USA",
"lastActivity": "Viewed analytics",
"sessionsCount": 18,
"featuresUsed": ["Analytics", "Dashboard"],
},
{ "id": "4",
"name": "David Wilson",
"email": "david.wilson@company.com",
"role": "Owner",
"status": "Active",
"lastLogin": "1 hour ago",
"isOnline": false,
"profileImage": "https://images.unsplash.com/photo-1472099645785-5658abf4ff4e?w=150&h=150&fit=crop&crop=face",
"joinedDate": "2023-01-01",
"permissions": ["Full Access", "Admin Rights"],
"activityScore": 95,
"deviceType": "Desktop",
"location": "San Francisco, USA",
"lastActivity": "Updated workspace settings",
"sessionsCount": 67,
"featuresUsed": ["All Features"],
},
{ "id": "5",
"name": "Jennifer Brown",
"email": "jennifer.brown@company.com",
"role": "Editor",
"status": "Pending",
"lastLogin": "Never",
"isOnline": false,
"profileImage": "https://images.unsplash.com/photo-1544005313-94ddf0286df2?w=150&h=150&fit=crop&crop=face",
"joinedDate": "2023-04-01",
"permissions": ["Content Management"],
"activityScore": 0,
"deviceType": "Unknown",
"location": "Boston, USA",
"lastActivity": "Invitation sent",
"sessionsCount": 0,
"featuresUsed": [],
},
];

  final List<Map<String, dynamic>> pendingInvitations = [
{ "id": "inv_1",
"email": "alex.smith@company.com",
"role": "Editor",
"invitedBy": "Sarah Johnson",
"invitedDate": "2023-04-15",
"status": "Pending",
"expiresAt": "2023-04-22",
},
{ "id": "inv_2",
"email": "lisa.chen@company.com",
"role": "Viewer",
"invitedBy": "David Wilson",
"invitedDate": "2023-04-14",
"status": "Pending",
"expiresAt": "2023-04-21",
},
];

  final List<Map<String, dynamic>> recentActivities = [
{ "id": "act_1",
"userId": "1",
"userName": "Sarah Johnson",
"action": "Updated user permissions",
"target": "Michael Rodriguez",
"timestamp": "5 minutes ago",
"type": "permission_change",
"details": "Added Analytics access",
},
{ "id": "act_2",
"userId": "4",
"userName": "David Wilson",
"action": "Invited new member",
"target": "alex.smith@company.com",
"timestamp": "1 hour ago",
"type": "invitation",
"details": "Editor role assigned",
},
{ "id": "act_3",
"userId": "2",
"userName": "Michael Rodriguez",
"action": "Logged in",
"target": "Mobile Device",
"timestamp": "2 hours ago",
"type": "login",
"details": "From Los Angeles, USA",
},
];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    _searchController.addListener(_onSearchChanged);
    _loadTeamMembers();
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    setState(() {
      searchQuery = _searchController.text;
    });
  }

  Future<void> _loadTeamMembers() async {
    setState(() {
      isLoading = true;
    });

    // Simulate API call
    await Future.delayed(const Duration(seconds: 1));

    setState(() {
      isLoading = false;
    });
  }

  Future<void> _handleRefresh() async {
    setState(() {
      isRefreshing = true;
    });

    await Future.delayed(const Duration(seconds: 2));

    setState(() {
      isRefreshing = false;
    });
  }

  void _toggleMultiSelectMode() {
    setState(() {
      isMultiSelectMode = !isMultiSelectMode;
      if (!isMultiSelectMode) {
        selectedMembers.clear();
      }
    });
  }

  void _toggleMemberSelection(String memberId) {
    setState(() {
      if (selectedMembers.contains(memberId)) {
        selectedMembers.remove(memberId);
      } else {
        selectedMembers.add(memberId);
      }
    });
  }

  void _showAddMemberModal() {
    showModalBottomSheet(
        context: context,
        backgroundColor: AppTheme.surface,
        isScrollControlled: true,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
        builder: (context) => Container());
  }

  void _showFilterBottomSheet() {
    showModalBottomSheet(
        context: context,
        backgroundColor: AppTheme.surface,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
        builder: (context) => Container());
  }

  void _showMemberProfile(Map<String, dynamic> member) {
    showModalBottomSheet(
        context: context,
        backgroundColor: AppTheme.surface,
        isScrollControlled: true,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
        builder: (context) => Container());
  }

  void _showSuccessMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(message),
        backgroundColor: AppTheme.success,
        behavior: SnackBarBehavior.floating));
  }

  List<Map<String, dynamic>> get filteredMembers {
    return teamMembers.where((member) {
      bool matchesSearch = member['name']
              .toString()
              .toLowerCase()
              .contains(searchQuery.toLowerCase()) ||
          member['email']
              .toString()
              .toLowerCase()
              .contains(searchQuery.toLowerCase());

      bool matchesRole =
          selectedRoleFilter == 'All' || member['role'] == selectedRoleFilter;

      bool matchesStatus = selectedStatusFilter == 'All' ||
          member['status'] == selectedStatusFilter;

      bool matchesActivity = selectedActivityFilter == 'All' ||
          _matchesActivityFilter(member, selectedActivityFilter);

      return matchesSearch && matchesRole && matchesStatus && matchesActivity;
    }).toList();
  }

  bool _matchesActivityFilter(Map<String, dynamic> member, String filter) {
    switch (filter) {
      case 'Online':
        return member['isOnline'] == true;
      case 'Offline':
        return member['isOnline'] == false;
      case 'Recent':
        return member['lastLogin'] == '2 minutes ago' ||
            member['lastLogin'] == '15 minutes ago';
      case 'Inactive':
        return member['lastLogin'] == '2 days ago' ||
            member['lastLogin'] == 'Never';
      default:
        return true;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: AppTheme.primaryBackground,
        appBar: AppBar(
            backgroundColor: AppTheme.primaryBackground,
            elevation: 0,
            title: Text('Team Management',
                style: AppTheme.darkTheme.textTheme.titleLarge),
            actions: [
              if (isMultiSelectMode)
                IconButton(
                    onPressed: _toggleMultiSelectMode,
                    icon: CustomIconWidget(
                        iconName: 'close',
                        color: AppTheme.primaryText,
                        size: 24))
              else ...[
                IconButton(
                    onPressed: _showAddMemberModal,
                    icon: CustomIconWidget(
                        iconName: 'person_add',
                        color: AppTheme.primaryText,
                        size: 24)),
                IconButton(
                    onPressed: _toggleMultiSelectMode,
                    icon: CustomIconWidget(
                        iconName: 'checklist',
                        color: AppTheme.primaryText,
                        size: 24)),
              ],
            ],
            bottom: TabBar(
                controller: _tabController,
                indicatorColor: AppTheme.accent,
                labelColor: AppTheme.primaryText,
                unselectedLabelColor: AppTheme.secondaryText,
                tabs: const [
                  Tab(text: "Members"),
                  Tab(text: "Activity"),
                  Tab(text: "Permissions"),
                  Tab(text: "Invitations"),
                ])),
        body: Stack(children: [
          Column(children: [
            // Search Bar
            Container(
                color: AppTheme.primaryBackground,
                padding: EdgeInsets.all(4.w),
                child: Container()),

            // Tab Content
            Expanded(
                child: TabBarView(controller: _tabController, children: [
              _buildMembersTab(),
              _buildActivityTab(),
              _buildPermissionsTab(),
              _buildInvitationsTab(),
            ])),
          ]),

          // Bulk Actions Bar
          if (isMultiSelectMode && selectedMembers.isNotEmpty)
            Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: BulkActionsWidget(
                  contacts: [],
                  selectedContacts: {},
                  onAction: (action) {},
                )),
        ]));
  }

  Widget _buildMembersTab() {
    if (isLoading) {
      return const Center(
          child: CircularProgressIndicator(color: AppTheme.accent));
    }

    final filtered = filteredMembers;

    if (filtered.isEmpty) {
      return Center(
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        CustomIconWidget(
            iconName: 'people_outline',
            color: AppTheme.secondaryText,
            size: 48),
        SizedBox(height: 2.h),
        Text(
            searchQuery.isNotEmpty ? "No members found" : "No team members yet",
            style: AppTheme.darkTheme.textTheme.titleMedium
                ?.copyWith(color: AppTheme.secondaryText)),
        SizedBox(height: 1.h),
        Text(
            searchQuery.isNotEmpty
                ? "Try adjusting your search or filters"
                : "Add team members to get started",
            style: AppTheme.darkTheme.textTheme.bodyMedium
                ?.copyWith(color: AppTheme.secondaryText)),
      ]));
    }

    return RefreshIndicator(
        onRefresh: _handleRefresh,
        color: AppTheme.accent,
        backgroundColor: AppTheme.surface,
        child: ListView.separated(
            controller: _scrollController,
            padding: EdgeInsets.all(4.w),
            itemCount: filtered.length,
            separatorBuilder: (context, index) => SizedBox(height: 1.h),
            itemBuilder: (context, index) {
              final member = filtered[index];
              return TeamMemberCardWidget(
                  member: member,
                  isSelected: selectedMembers.contains(member['id']),
                  isMultiSelectMode: isMultiSelectMode,
                  onTap: () {
                    if (isMultiSelectMode) {
                      _toggleMemberSelection(member['id']);
                    } else {
                      _showMemberProfile(member);
                    }
                  },
                  onLongPress: () {
                    if (!isMultiSelectMode) {
                      _toggleMultiSelectMode();
                    }
                    _toggleMemberSelection(member['id']);
                  },
                  onRoleChange: (newRole) {
                    // Handle role change
                    _showSuccessMessage("Role changed to $newRole");
                  },
                  onSuspend: () {
                    // Handle suspend
                    _showSuccessMessage("${member['name']} suspended");
                  },
                  onRemove: () {
                    // Handle remove
                    _showSuccessMessage("${member['name']} removed");
                  },
                  onSendMessage: () {
                    // Handle send message
                    _showSuccessMessage("Message sent to ${member['name']}");
                  },
                  onResetPassword: () {
                    // Handle reset password
                    _showSuccessMessage(
                        "Password reset link sent to ${member['name']}");
                  },
                  onViewActivity: () {
                    // Handle view activity
                    _showSuccessMessage(
                        "Viewing activity for ${member['name']}");
                  });
            }));
  }

  Widget _buildActivityTab() {
    return RefreshIndicator(
        onRefresh: _handleRefresh,
        color: AppTheme.accent,
        backgroundColor: AppTheme.surface,
        child: SingleChildScrollView(
            padding: EdgeInsets.all(4.w), child: Container()));
  }

  Widget _buildPermissionsTab() {
    return RefreshIndicator(
        onRefresh: _handleRefresh,
        color: AppTheme.accent,
        backgroundColor: AppTheme.surface,
        child: SingleChildScrollView(
            padding: EdgeInsets.all(4.w), child: Container()));
  }

  Widget _buildInvitationsTab() {
    return RefreshIndicator(
        onRefresh: _handleRefresh,
        color: AppTheme.accent,
        backgroundColor: AppTheme.surface,
        child: SingleChildScrollView(
            padding: EdgeInsets.all(4.w), child: Container()));
  }
}