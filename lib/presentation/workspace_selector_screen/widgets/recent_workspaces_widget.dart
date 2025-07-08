import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../theme/app_theme.dart';

class RecentWorkspacesWidget extends StatelessWidget {
  final List<Map<String, dynamic>> workspaces;
  final Function(String) onWorkspaceTap;

  const RecentWorkspacesWidget({
    Key? key,
    required this.workspaces,
    required this.onWorkspaceTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Recent Workspaces',
          style: AppTheme.darkTheme.textTheme.titleMedium,
        ),
        SizedBox(height: 1.h),
        SizedBox(
          height: 10.h,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: workspaces.length,
            separatorBuilder: (context, index) => SizedBox(width: 3.w),
            itemBuilder: (context, index) {
              final workspace = workspaces[index];
              return GestureDetector(
                onTap: () => onWorkspaceTap(workspace['id']),
                child: Container(
                  width: 20.w,
                  padding: EdgeInsets.all(2.w),
                  decoration: BoxDecoration(
                    color: AppTheme.surface,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppTheme.border, width: 1),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 8.w,
                        height: 8.w,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(6),
                          image: DecorationImage(
                            image: NetworkImage(workspace['logoUrl']),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      SizedBox(height: 1.h),
                      Text(
                        workspace['name'],
                        style: AppTheme.darkTheme.textTheme.labelSmall,
                        textAlign: TextAlign.center,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
