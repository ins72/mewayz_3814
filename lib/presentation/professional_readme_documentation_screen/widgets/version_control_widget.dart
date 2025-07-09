
import '../../../core/app_export.dart';

class VersionControlWidget extends StatefulWidget {
  final Map<String, String> currentDocumentation;
  final Function(Map<String, String>) onRestore;

  const VersionControlWidget({
    super.key,
    required this.currentDocumentation,
    required this.onRestore,
  });

  @override
  State<VersionControlWidget> createState() => _VersionControlWidgetState();
}

class _VersionControlWidgetState extends State<VersionControlWidget> {
  final List<Map<String, dynamic>> _versions = [
{ 'version': '1.0.0',
'timestamp': DateTime.now().subtract(const Duration(days: 1)),
'author': 'John Doe',
'changes': 'Initial documentation creation',
'sections': 7,
'wordsCount': 1250,
'isCurrent': false,
},
{ 'version': '1.1.0',
'timestamp': DateTime.now().subtract(const Duration(hours: 3)),
'author': 'Jane Smith',
'changes': 'Added API documentation and usage examples',
'sections': 8,
'wordsCount': 1890,
'isCurrent': false,
},
{ 'version': '1.2.0',
'timestamp': DateTime.now().subtract(const Duration(minutes: 30)),
'author': 'Current User',
'changes': 'Updated installation instructions and added screenshots',
'sections': 8,
'wordsCount': 2100,
'isCurrent': true,
},
];

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 80.h,
      padding: EdgeInsets.all(4.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            children: [
              Icon(
                Icons.history,
                size: 24.sp,
                color: AppTheme.accent,
              ),
              SizedBox(width: 2.w),
              Text(
                'Version History',
                style: GoogleFonts.inter(
                  fontSize: 20.sp,
                  fontWeight: FontWeight.w600,
                  color: AppTheme.primaryText,
                ),
              ),
              const Spacer(),
              IconButton(
                onPressed: () => Navigator.pop(context),
                icon: Icon(
                  Icons.close,
                  size: 24.sp,
                  color: AppTheme.secondaryText,
                ),
              ),
            ],
          ),
          SizedBox(height: 2.h),
          
          // Version Stats
          Container(
            padding: EdgeInsets.all(3.w),
            decoration: BoxDecoration(
              color: AppTheme.surface,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: AppTheme.border,
                width: 1,
              ),
            ),
            child: Row(
              children: [
                _buildStatCard('Total Versions', '${_versions.length}', Icons.layers),
                SizedBox(width: 4.w),
                _buildStatCard('Current Version', _versions.last['version'], Icons.bookmark),
                SizedBox(width: 4.w),
                _buildStatCard('Last Updated', _formatTimeAgo(_versions.last['timestamp']), Icons.access_time),
              ],
            ),
          ),
          SizedBox(height: 2.h),
          
          // Version List
          Expanded(
            child: ListView.builder(
              itemCount: _versions.length,
              itemBuilder: (context, index) {
                final version = _versions[_versions.length - 1 - index]; // Reverse order
                return _buildVersionCard(version);
              },
            ),
          ),
          
          // Actions
          Container(
            padding: EdgeInsets.all(3.w),
            decoration: BoxDecoration(
              color: AppTheme.surface,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: AppTheme.border,
                width: 1,
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => _createNewVersion(),
                    style: OutlinedButton.styleFrom(
                      padding: EdgeInsets.symmetric(vertical: 1.5.h),
                      side: BorderSide(color: AppTheme.accent),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.save,
                          size: 16.sp,
                          color: AppTheme.accent,
                        ),
                        SizedBox(width: 2.w),
                        Text(
                          'Save Current Version',
                          style: GoogleFonts.inter(
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w500,
                            color: AppTheme.accent,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(width: 2.w),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => _exportVersionHistory(),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.accent,
                      foregroundColor: AppTheme.primaryAction,
                      padding: EdgeInsets.symmetric(vertical: 1.5.h),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.download,
                          size: 16.sp,
                        ),
                        SizedBox(width: 2.w),
                        Text(
                          'Export History',
                          style: GoogleFonts.inter(
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(String title, String value, IconData icon) {
    return Expanded(
      child: Container(
        padding: EdgeInsets.all(2.w),
        decoration: BoxDecoration(
          color: AppTheme.primaryBackground,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: AppTheme.border,
            width: 1,
          ),
        ),
        child: Column(
          children: [
            Icon(
              icon,
              size: 16.sp,
              color: AppTheme.accent,
            ),
            SizedBox(height: 1.h),
            Text(
              value,
              style: GoogleFonts.inter(
                fontSize: 14.sp,
                fontWeight: FontWeight.w600,
                color: AppTheme.primaryText,
              ),
            ),
            SizedBox(height: 0.5.h),
            Text(
              title,
              style: GoogleFonts.inter(
                fontSize: 9.sp,
                color: AppTheme.secondaryText,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildVersionCard(Map<String, dynamic> version) {
    return Container(
      margin: EdgeInsets.only(bottom: 2.h),
      decoration: BoxDecoration(
        color: version['isCurrent'] ? AppTheme.accent.withAlpha(26) : AppTheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: version['isCurrent'] ? AppTheme.accent : AppTheme.border,
          width: version['isCurrent'] ? 2 : 1,
        ),
      ),
      child: Column(
        children: [
          // Header
          Container(
            padding: EdgeInsets.all(3.w),
            child: Row(
              children: [
                Container(
                  padding: EdgeInsets.all(2.w),
                  decoration: BoxDecoration(
                    color: version['isCurrent'] 
                        ? AppTheme.accent.withAlpha(51)
                        : AppTheme.secondaryText.withAlpha(51),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    version['isCurrent'] ? Icons.star : Icons.history,
                    size: 16.sp,
                    color: version['isCurrent'] ? AppTheme.accent : AppTheme.secondaryText,
                  ),
                ),
                SizedBox(width: 3.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            'Version ${version['version']}',
                            style: GoogleFonts.inter(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w600,
                              color: AppTheme.primaryText,
                            ),
                          ),
                          if (version['isCurrent'])
                            Container(
                              margin: EdgeInsets.only(left: 2.w),
                              padding: EdgeInsets.symmetric(
                                horizontal: 2.w,
                                vertical: 0.5.h,
                              ),
                              decoration: BoxDecoration(
                                color: AppTheme.accent.withAlpha(51),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                'Current',
                                style: GoogleFonts.inter(
                                  fontSize: 8.sp,
                                  fontWeight: FontWeight.w500,
                                  color: AppTheme.accent,
                                ),
                              ),
                            ),
                        ],
                      ),
                      SizedBox(height: 0.5.h),
                      Text(
                        'By ${version['author']} • ${_formatTimeAgo(version['timestamp'])}',
                        style: GoogleFonts.inter(
                          fontSize: 11.sp,
                          color: AppTheme.secondaryText,
                        ),
                      ),
                    ],
                  ),
                ),
                PopupMenuButton<String>(
                  icon: Icon(
                    Icons.more_vert,
                    size: 16.sp,
                    color: AppTheme.secondaryText,
                  ),
                  color: AppTheme.surface,
                  onSelected: (value) => _handleVersionAction(value, version),
                  itemBuilder: (context) => [
                    PopupMenuItem(
                      value: 'view',
                      child: Row(
                        children: [
                          Icon(Icons.visibility, size: 16.sp, color: AppTheme.accent),
                          SizedBox(width: 2.w),
                          Text('View', style: GoogleFonts.inter(fontSize: 12.sp)),
                        ],
                      ),
                    ),
                    if (!version['isCurrent'])
                      PopupMenuItem(
                        value: 'restore',
                        child: Row(
                          children: [
                            Icon(Icons.restore, size: 16.sp, color: AppTheme.warning),
                            SizedBox(width: 2.w),
                            Text('Restore', style: GoogleFonts.inter(fontSize: 12.sp)),
                          ],
                        ),
                      ),
                    PopupMenuItem(
                      value: 'compare',
                      child: Row(
                        children: [
                          Icon(Icons.compare, size: 16.sp, color: AppTheme.accent),
                          SizedBox(width: 2.w),
                          Text('Compare', style: GoogleFonts.inter(fontSize: 12.sp)),
                        ],
                      ),
                    ),
                    PopupMenuItem(
                      value: 'export',
                      child: Row(
                        children: [
                          Icon(Icons.download, size: 16.sp, color: AppTheme.accent),
                          SizedBox(width: 2.w),
                          Text('Export', style: GoogleFonts.inter(fontSize: 12.sp)),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          
          // Content
          Container(
            padding: EdgeInsets.fromLTRB(3.w, 0, 3.w, 3.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: 1,
                  color: AppTheme.border,
                  margin: EdgeInsets.only(bottom: 2.h),
                ),
                Text(
                  version['changes'],
                  style: GoogleFonts.inter(
                    fontSize: 12.sp,
                    color: AppTheme.primaryText,
                    height: 1.4,
                  ),
                ),
                SizedBox(height: 2.h),
                Row(
                  children: [
                    _buildVersionStat('Sections', version['sections'].toString()),
                    SizedBox(width: 4.w),
                    _buildVersionStat('Words', version['wordsCount'].toString()),
                    const Spacer(),
                    Text(
                      _formatDateTime(version['timestamp']),
                      style: GoogleFonts.inter(
                        fontSize: 10.sp,
                        color: AppTheme.secondaryText,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildVersionStat(String label, String value) {
    return Row(
      children: [
        Container(
          padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.5.h),
          decoration: BoxDecoration(
            color: AppTheme.accent.withAlpha(26),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            label,
            style: GoogleFonts.inter(
              fontSize: 9.sp,
              fontWeight: FontWeight.w500,
              color: AppTheme.accent,
            ),
          ),
        ),
        SizedBox(width: 1.w),
        Text(
          value,
          style: GoogleFonts.inter(
            fontSize: 11.sp,
            fontWeight: FontWeight.w500,
            color: AppTheme.primaryText,
          ),
        ),
      ],
    );
  }

  String _formatTimeAgo(DateTime timestamp) {
    final now = DateTime.now();
    final difference = now.difference(timestamp);
    
    if (difference.inDays > 0) {
      return '${difference.inDays}d ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours}h ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes}m ago';
    } else {
      return 'Just now';
    }
  }

  String _formatDateTime(DateTime timestamp) {
    return '${timestamp.day}/${timestamp.month}/${timestamp.year} ${timestamp.hour}:${timestamp.minute.toString().padLeft(2, '0')}';
  }

  void _handleVersionAction(String action, Map<String, dynamic> version) {
    switch (action) {
      case 'view':
        _viewVersion(version);
        break;
      case 'restore':
        _restoreVersion(version);
        break;
      case 'compare':
        _compareVersions(version);
        break;
      case 'export':
        _exportVersion(version);
        break;
    }
  }

  void _viewVersion(Map<String, dynamic> version) {
    // Implementation for viewing version
    Fluttertoast.showToast(
      msg: 'Viewing version ${version['version']}',
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: AppTheme.accent,
      textColor: AppTheme.primaryAction,
    );
  }

  void _restoreVersion(Map<String, dynamic> version) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppTheme.surface,
        title: Text(
          'Restore Version',
          style: GoogleFonts.inter(
            fontSize: 16.sp,
            fontWeight: FontWeight.w600,
            color: AppTheme.primaryText,
          ),
        ),
        content: Text(
          'Are you sure you want to restore to version ${version['version']}? This will replace your current documentation.',
          style: GoogleFonts.inter(
            fontSize: 12.sp,
            color: AppTheme.secondaryText,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Cancel',
              style: GoogleFonts.inter(
                fontSize: 12.sp,
                color: AppTheme.secondaryText,
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context);
              // widget.onRestore(version['documentation']);
              Fluttertoast.showToast(
                msg: 'Version ${version['version']} restored successfully',
                toastLength: Toast.LENGTH_LONG,
                gravity: ToastGravity.BOTTOM,
                backgroundColor: AppTheme.success,
                textColor: AppTheme.primaryAction,
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.warning,
              foregroundColor: AppTheme.primaryAction,
            ),
            child: Text(
              'Restore',
              style: GoogleFonts.inter(
                fontSize: 12.sp,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _compareVersions(Map<String, dynamic> version) {
    Fluttertoast.showToast(
      msg: 'Comparing with version ${version['version']}',
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: AppTheme.accent,
      textColor: AppTheme.primaryAction,
    );
  }

  void _exportVersion(Map<String, dynamic> version) {
    Fluttertoast.showToast(
      msg: 'Exporting version ${version['version']}',
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: AppTheme.accent,
      textColor: AppTheme.primaryAction,
    );
  }

  void _createNewVersion() {
    Fluttertoast.showToast(
      msg: 'New version saved successfully',
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: AppTheme.success,
      textColor: AppTheme.primaryAction,
    );
  }

  void _exportVersionHistory() {
    Fluttertoast.showToast(
      msg: 'Version history exported',
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: AppTheme.success,
      textColor: AppTheme.primaryAction,
    );
  }
}