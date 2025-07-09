
import '../../../core/app_export.dart';

class WorkspacePreviewWidget extends StatelessWidget {
  final String workspaceName;
  final String description;
  final String industry;
  final String privacyLevel;
  final List<Map<String, String>> teamMembers;
  final String selectedTemplate;
  final String logoUrl;

  const WorkspacePreviewWidget({
    Key? key,
    required this.workspaceName,
    required this.description,
    required this.industry,
    required this.privacyLevel,
    required this.teamMembers,
    required this.selectedTemplate,
    required this.logoUrl,
  }) : super(key: key);

  String _getPrivacyLabel(String privacy) {
    switch (privacy) {
      case 'public':
        return 'Public';
      case 'private':
        return 'Private';
      case 'invite_only':
        return 'Invite Only';
      default:
        return 'Private';
    }
  }

  String _getTemplateLabel(String template) {
    switch (template) {
      case 'blank':
        return 'Blank Workspace';
      case 'marketing':
        return 'Marketing Agency';
      case 'ecommerce':
        return 'E-commerce Store';
      case 'education':
        return 'Educational Platform';
      case 'consulting':
        return 'Consulting Business';
      default:
        return 'Blank Workspace';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.all(4.w),
        decoration: BoxDecoration(
            color: AppTheme.surface,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppTheme.border)),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(children: [
            const CustomIconWidget(
                iconName: 'preview', color: AppTheme.accent, size: 24),
            SizedBox(width: 2.w),
            Text('Workspace Preview',
                style: AppTheme.darkTheme.textTheme.titleMedium
                    ?.copyWith(color: AppTheme.accent)),
          ]),
          SizedBox(height: 3.h),

          // Workspace Header
          Row(children: [
            Container(
                width: 15.w,
                height: 15.w,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: AppTheme.primaryBackground),
                child: logoUrl.isNotEmpty
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: CustomImageWidget(
                            imageUrl: logoUrl, fit: BoxFit.cover))
                    : const Center(
                        child: CustomIconWidget(
                            iconName: 'business',
                            color: AppTheme.secondaryText,
                            size: 32))),
            SizedBox(width: 4.w),
            Expanded(
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                  Text(
                      workspaceName.isNotEmpty
                          ? workspaceName
                          : 'Workspace Name',
                      style: AppTheme.darkTheme.textTheme.titleLarge),
                  if (description.isNotEmpty) ...[
                    SizedBox(height: 0.5.h),
                    Text(description,
                        style: AppTheme.darkTheme.textTheme.bodySmall
                            ?.copyWith(color: AppTheme.secondaryText),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis),
                  ],
                ])),
          ]),

          SizedBox(height: 3.h),

          // Workspace Details
          _buildDetailRow('Industry', industry),
          _buildDetailRow('Privacy', _getPrivacyLabel(privacyLevel)),
          _buildDetailRow('Template', _getTemplateLabel(selectedTemplate)),
          _buildDetailRow('Team Members', '${teamMembers.length} invited'),

          if (teamMembers.isNotEmpty) ...[
            SizedBox(height: 2.h),
            Text('Team Members',
                style: AppTheme.darkTheme.textTheme.titleSmall),
            SizedBox(height: 1.h),
            SizedBox(
                height: 6.h,
                child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemCount: teamMembers.length > 5 ? 5 : teamMembers.length,
                    separatorBuilder: (context, index) => SizedBox(width: 2.w),
                    itemBuilder: (context, index) {
                      if (index == 4 && teamMembers.length > 5) {
                        return Container(
                            width: 6.h,
                            height: 6.h,
                            decoration: BoxDecoration(
                                color: AppTheme.accent.withAlpha(51),
                                borderRadius: BorderRadius.circular(6.h)),
                            child: Center(
                                child: Text('+${teamMembers.length - 4}',
                                    style: AppTheme
                                        .darkTheme.textTheme.labelSmall
                                        ?.copyWith(
                                            color: AppTheme.accent,
                                            fontWeight: FontWeight.w600))));
                      }

                      return Container(
                          width: 6.h,
                          height: 6.h,
                          decoration: BoxDecoration(
                              color: AppTheme.accent.withAlpha(51),
                              borderRadius: BorderRadius.circular(6.h)),
                          child: Center(
                              child: Text(
                                  teamMembers[index]['email']?[0]
                                          .toUpperCase() ??
                                      '?',
                                  style: AppTheme.darkTheme.textTheme.titleSmall
                                      ?.copyWith(
                                          color: AppTheme.accent,
                                          fontWeight: FontWeight.w600))));
                    })),
          ],
        ]));
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
        padding: EdgeInsets.only(bottom: 1.h),
        child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
          SizedBox(
              width: 30.w,
              child: Text(label,
                  style: AppTheme.darkTheme.textTheme.bodySmall
                      ?.copyWith(color: AppTheme.secondaryText))),
          Expanded(
              child:
                  Text(value, style: AppTheme.darkTheme.textTheme.bodySmall)),
        ]));
  }
}