
import '../../core/app_export.dart';
import './widgets/empty_workspace_widget.dart';
import './widgets/recent_workspaces_widget.dart';
import './widgets/workspace_card_widget.dart';
import './widgets/workspace_search_bar_widget.dart';

class WorkspaceSelectorScreen extends StatefulWidget {
  const WorkspaceSelectorScreen({Key? key}) : super(key: key);

  @override
  State<WorkspaceSelectorScreen> createState() =>
      _WorkspaceSelectorScreenState();
}

class _WorkspaceSelectorScreenState extends State<WorkspaceSelectorScreen> {
  final TextEditingController _searchController = TextEditingController();
  bool _isLoading = false;
  bool _isRefreshing = false;
  String _searchQuery = '';
  String? _selectedWorkspaceId;

  final List<Map<String, dynamic>> _workspaces = [
{ 'id': '1',
'name': 'Digital Marketing Agency',
'description': 'Complete digital marketing solutions',
'memberCount': 12,
'role': 'Owner',
'isActive': true,
'lastActivity': '2 minutes ago',
'unreadNotifications': 5,
'logoUrl': 'https://images.unsplash.com/photo-1552664730-d307ca884978?w=100&h=100&fit=crop',
'isRecent': true,
},
{ 'id': '2',
'name': 'E-commerce Store',
'description': 'Online retail business management',
'memberCount': 8,
'role': 'Admin',
'isActive': false,
'lastActivity': '1 hour ago',
'unreadNotifications': 2,
'logoUrl': 'https://images.unsplash.com/photo-1556742049-0cfed4f6a45d?w=100&h=100&fit=crop',
'isRecent': true,
},
{ 'id': '3',
'name': 'Course Creator Hub',
'description': 'Educational content creation',
'memberCount': 15,
'role': 'Editor',
'isActive': false,
'lastActivity': '3 hours ago',
'unreadNotifications': 0,
'logoUrl': 'https://images.unsplash.com/photo-1513475382585-d06e58bcb0e0?w=100&h=100&fit=crop',
'isRecent': false,
},
{ 'id': '4',
'name': 'Freelance Business',
'description': 'Personal freelance projects',
'memberCount': 3,
'role': 'Owner',
'isActive': false,
'lastActivity': '1 day ago',
'unreadNotifications': 1,
'logoUrl': 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=100&h=100&fit=crop',
'isRecent': true,
},
{ 'id': '5',
'name': 'Consulting Firm',
'description': 'Business consulting services',
'memberCount': 6,
'role': 'Viewer',
'isActive': false,
'lastActivity': '2 days ago',
'unreadNotifications': 0,
'logoUrl': 'https://images.unsplash.com/photo-1454165804606-c3d57bc86b40?w=100&h=100&fit=crop',
'isRecent': false,
},
];

  List<Map<String, dynamic>> get _filteredWorkspaces {
    if (_searchQuery.isEmpty) {
      return _workspaces;
    }
    return _workspaces.where((workspace) {
      return workspace['name']
              .toLowerCase()
              .contains(_searchQuery.toLowerCase()) ||
          workspace['description']
              .toLowerCase()
              .contains(_searchQuery.toLowerCase());
    }).toList();
  }

  List<Map<String, dynamic>> get _recentWorkspaces {
    return _workspaces
        .where((workspace) => workspace['isRecent'] == true)
        .toList();
  }

  @override
  void initState() {
    super.initState();
    _selectedWorkspaceId =
        _workspaces.firstWhere((w) => w['isActive'] == true)['id'];
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _handleRefresh() async {
    setState(() {
      _isRefreshing = true;
    });

    // Simulate API call
    await Future.delayed(const Duration(seconds: 2));

    setState(() {
      _isRefreshing = false;
    });

    if (mounted) {
      HapticFeedback.lightImpact();
    }
  }

  void _selectWorkspace(String workspaceId) {
    setState(() {
      _selectedWorkspaceId = workspaceId;
      _isLoading = true;
    });

    // Simulate workspace switch
    Future.delayed(const Duration(milliseconds: 800), () {
      if (mounted) {
        // Update active workspace
        for (var workspace in _workspaces) {
          workspace['isActive'] = workspace['id'] == workspaceId;
        }

        setState(() {
          _isLoading = false;
        });

        HapticFeedback.selectionClick();
        Navigator.pushReplacementNamed(context, AppRoutes.workspaceDashboard);
      }
    });
  }

  void _showWorkspaceContextMenu(Map<String, dynamic> workspace) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppTheme.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: EdgeInsets.all(4.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 10.w,
                height: 0.5.h,
                decoration: BoxDecoration(
                  color: AppTheme.border,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            SizedBox(height: 2.h),
            Text(
              workspace['name'],
              style: AppTheme.darkTheme.textTheme.titleLarge,
            ),
            SizedBox(height: 2.h),
            ListTile(
              leading: const CustomIconWidget(
                iconName: 'settings',
                color: AppTheme.primaryText,
                size: 24,
              ),
              title: const Text('Workspace Settings'),
              onTap: () {
                Navigator.pop(context);
                // Navigate to workspace settings
              },
            ),
            if (workspace['role'] == 'Owner') ...[
              ListTile(
                leading: const CustomIconWidget(
                  iconName: 'content_copy',
                  color: AppTheme.primaryText,
                  size: 24,
                ),
                title: const Text('Duplicate Workspace'),
                onTap: () {
                  Navigator.pop(context);
                  // Handle duplicate workspace
                },
              ),
            ],
            if (workspace['role'] != 'Owner') ...[
              ListTile(
                leading: const CustomIconWidget(
                  iconName: 'exit_to_app',
                  color: AppTheme.error,
                  size: 24,
                ),
                title: Text(
                  'Leave Workspace',
                  style: TextStyle(color: AppTheme.error),
                ),
                onTap: () {
                  Navigator.pop(context);
                  // Handle leave workspace
                },
              ),
            ],
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.primaryBackground,
      appBar: AppBar(
        backgroundColor: AppTheme.primaryBackground,
        elevation: 0,
        title: const Text('Select Workspace'),
        leading: IconButton(
          icon: const CustomIconWidget(
            iconName: 'close',
            color: AppTheme.primaryText,
            size: 24,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: const CustomIconWidget(
              iconName: 'add',
              color: AppTheme.primaryText,
              size: 24,
            ),
            onPressed: () {
              Navigator.pushNamed(context, AppRoutes.workspaceCreationScreen);
            },
          ),
        ],
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(
                color: AppTheme.accent,
              ),
            )
          : RefreshIndicator(
              onRefresh: _handleRefresh,
              color: AppTheme.accent,
              backgroundColor: AppTheme.surface,
              child: Column(
                children: [
                  // Search Bar
                  Padding(
                    padding: EdgeInsets.all(4.w),
                    child: WorkspaceSearchBarWidget(
                      controller: _searchController,
                      onChanged: (value) {
                        setState(() {
                          _searchQuery = value;
                        });
                      },
                    ),
                  ),

                  // Recent Workspaces Section
                  if (_searchQuery.isEmpty && _recentWorkspaces.isNotEmpty) ...[
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 4.w),
                      child: RecentWorkspacesWidget(
                        workspaces: _recentWorkspaces,
                        onWorkspaceTap: _selectWorkspace,
                      ),
                    ),
                    SizedBox(height: 2.h),
                  ],

                  // All Workspaces Section
                  Expanded(
                    child: _filteredWorkspaces.isEmpty
                        ? const EmptyWorkspaceWidget()
                        : ListView.separated(
                            padding: EdgeInsets.symmetric(horizontal: 4.w),
                            itemCount: _filteredWorkspaces.length,
                            separatorBuilder: (context, index) =>
                                SizedBox(height: 1.h),
                            itemBuilder: (context, index) {
                              final workspace = _filteredWorkspaces[index];
                              return WorkspaceCardWidget(
                                workspace: workspace,
                                isSelected:
                                    workspace['id'] == _selectedWorkspaceId,
                                onTap: () => _selectWorkspace(workspace['id']),
                                onLongPress: () =>
                                    _showWorkspaceContextMenu(workspace),
                              );
                            },
                          ),
                  ),
                ],
              ),
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, AppRoutes.workspaceCreationScreen);
        },
        backgroundColor: AppTheme.primaryAction,
        child: const CustomIconWidget(
          iconName: 'add',
          color: AppTheme.primaryBackground,
          size: 24,
        ),
      ),
    );
  }
}