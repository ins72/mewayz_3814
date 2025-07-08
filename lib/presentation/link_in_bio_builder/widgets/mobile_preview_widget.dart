import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class MobilePreviewWidget extends StatelessWidget {
  final List<Map<String, dynamic>> components;
  final String selectedComponentId;
  final Function(String) onComponentTap;
  final Function(String) onComponentLongPress;

  const MobilePreviewWidget({
    Key? key,
    required this.components,
    required this.selectedComponentId,
    required this.onComponentTap,
    required this.onComponentLongPress,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        color: AppTheme.primaryBackground,
        child: Column(children: [
          Container(
              padding: EdgeInsets.all(4.w),
              decoration: BoxDecoration(
                  color: AppTheme.surface,
                  border: Border(
                      bottom: BorderSide(color: AppTheme.border, width: 1))),
              child: Row(children: [
                Text('Mobile Preview',
                    style: AppTheme.darkTheme.textTheme.titleMedium),
                const Spacer(),
                Container(
                    padding:
                        EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
                    decoration: BoxDecoration(
                        color: AppTheme.accent.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(20)),
                    child: Row(mainAxisSize: MainAxisSize.min, children: [
                      Container(
                          width: 2.w,
                          height: 2.w,
                          decoration: BoxDecoration(
                              color: AppTheme.success, shape: BoxShape.circle)),
                      SizedBox(width: 2.w),
                      Text('Live',
                          style: AppTheme.darkTheme.textTheme.bodySmall
                              ?.copyWith(
                                  color: AppTheme.accent,
                                  fontWeight: FontWeight.w500)),
                    ])),
              ])),
          Expanded(
              child: Center(
                  child: Container(
                      width: 80.w,
                      height: 70.h,
                      decoration: BoxDecoration(
                          color: AppTheme.surface,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: AppTheme.border, width: 2),
                          boxShadow: [
                            BoxShadow(
                                color: AppTheme.shadowDark,
                                blurRadius: 20,
                                offset: const Offset(0, 8)),
                          ]),
                      child: ClipRRect(
                          borderRadius: BorderRadius.circular(18),
                          child: Column(children: [
                            _buildMobileHeader(),
                            Expanded(
                                child: DragTarget<Map<String, dynamic>>(
                                    onAcceptWithDetails: (component) {
                              // Handle component drop
                            }, builder: (context, candidateData, rejectedData) {
                              return Container(
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                      color: candidateData.isNotEmpty
                                          ? AppTheme.accent
                                              .withValues(alpha: 0.1)
                                          : AppTheme.primaryBackground,
                                      border: candidateData.isNotEmpty
                                          ? Border.all(
                                              color: AppTheme.accent,
                                              width: 2,
                                              style: BorderStyle.solid)
                                          : null),
                                  child: components.isEmpty
                                      ? _buildEmptyState()
                                      : _buildComponentList());
                            })),
                          ]))))),
        ]));
  }

  Widget _buildMobileHeader() {
    return Container(
        height: 6.h,
        decoration: BoxDecoration(
            color: AppTheme.surface,
            border: Border(
                bottom:
                    BorderSide(color: AppTheme.border.withValues(alpha: 0.3)))),
        child: Row(children: [
          SizedBox(width: 4.w),
          Container(
              width: 1.5.w,
              height: 1.5.w,
              decoration:
                  BoxDecoration(color: AppTheme.error, shape: BoxShape.circle)),
          SizedBox(width: 2.w),
          Container(
              width: 1.5.w,
              height: 1.5.w,
              decoration: BoxDecoration(
                  color: AppTheme.warning, shape: BoxShape.circle)),
          SizedBox(width: 2.w),
          Container(
              width: 1.5.w,
              height: 1.5.w,
              decoration: BoxDecoration(
                  color: AppTheme.success, shape: BoxShape.circle)),
          const Spacer(),
          Text('yourpage.bio',
              style: AppTheme.darkTheme.textTheme.bodySmall
                  ?.copyWith(color: AppTheme.secondaryText)),
          const Spacer(),
          CustomIconWidget(
              iconName: 'refresh', color: AppTheme.secondaryText, size: 16),
          SizedBox(width: 4.w),
        ]));
  }

  Widget _buildEmptyState() {
    return Center(
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
      Container(
          padding: EdgeInsets.all(6.w),
          decoration: BoxDecoration(
              color: AppTheme.surface,
              shape: BoxShape.circle,
              border: Border.all(
                  color: AppTheme.border, width: 2, style: BorderStyle.solid)),
          child: CustomIconWidget(
              iconName: 'add', color: AppTheme.secondaryText, size: 32)),
      SizedBox(height: 3.h),
      Text('Drag components here',
          style: AppTheme.darkTheme.textTheme.titleMedium
              ?.copyWith(color: AppTheme.secondaryText)),
      SizedBox(height: 1.h),
      Text(
          'Start building your Link in Bio page\nby dragging components from the left panel',
          style: AppTheme.darkTheme.textTheme.bodySmall,
          textAlign: TextAlign.center),
    ]));
  }

  Widget _buildComponentList() {
    return ListView.builder(
        padding: EdgeInsets.all(4.w),
        itemCount: components.length,
        itemBuilder: (context, index) {
          final component = components[index];
          final isSelected = component['id'] == selectedComponentId;

          return GestureDetector(
              onTap: () => onComponentTap(component['id'] as String),
              onLongPress: () =>
                  onComponentLongPress(component['id'] as String),
              child: Container(
                  margin: EdgeInsets.only(bottom: 3.h),
                  decoration: BoxDecoration(
                      border: isSelected
                          ? Border.all(color: AppTheme.accent, width: 2)
                          : null,
                      borderRadius: BorderRadius.circular(12)),
                  child: _buildComponentPreview(component)));
        });
  }

  Widget _buildComponentPreview(Map<String, dynamic> component) {
    final type = component['type'] as String;
    final props = component['defaultProps'] as Map<String, dynamic>;

    switch (type) {
      case 'text':
        return _buildTextPreview(props);
      case 'button':
        return _buildButtonPreview(props);
      case 'image':
        return _buildImagePreview(props);
      case 'video':
        return _buildVideoPreview(props);
      case 'product':
        return _buildProductPreview(props);
      case 'form':
        return _buildFormPreview(props);
      case 'social':
        return _buildSocialPreview(props);
      default:
        return Container();
    }
  }

  Widget _buildTextPreview(Map<String, dynamic> props) {
    return Container(
        padding: EdgeInsets.all(4.w),
        child: Text(props['content'] as String,
            style: AppTheme.darkTheme.textTheme.bodyMedium?.copyWith(
                fontSize: (props['fontSize'] as double).sp,
                fontWeight: props['fontWeight'] == 'bold'
                    ? FontWeight.bold
                    : FontWeight.normal,
                color: Color(int.parse(
                    (props['color'] as String).replaceAll('#', '0xFF')))),
            textAlign: props['alignment'] == 'center'
                ? TextAlign.center
                : props['alignment'] == 'right'
                    ? TextAlign.right
                    : TextAlign.left));
  }

  Widget _buildButtonPreview(Map<String, dynamic> props) {
    return Container(
        padding: EdgeInsets.symmetric(horizontal: 4.w),
        child: ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
                backgroundColor: Color(int.parse(
                    (props['backgroundColor'] as String)
                        .replaceAll('#', '0xFF'))),
                foregroundColor: Color(int.parse(
                    (props['textColor'] as String).replaceAll('#', '0xFF'))),
                padding: EdgeInsets.symmetric(vertical: 2.h),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(
                        props['borderRadius'] as double))),
            child: Text(props['text'] as String,
                style: AppTheme.darkTheme.textTheme.bodyMedium
                    ?.copyWith(fontWeight: FontWeight.w500))));
  }

  Widget _buildImagePreview(Map<String, dynamic> props) {
    return Container(
        padding: EdgeInsets.symmetric(horizontal: 4.w),
        child: Center(
            child: ClipRRect(
                borderRadius:
                    BorderRadius.circular(props['borderRadius'] as double),
                child: CustomImageWidget(
                    imageUrl: props['url'] as String,
                    width: (props['width'] as double).w,
                    height: (props['height'] as double).w,
                    fit: BoxFit.cover))));
  }

  Widget _buildVideoPreview(Map<String, dynamic> props) {
    return Container(
        padding: EdgeInsets.symmetric(horizontal: 4.w),
        child: Stack(alignment: Alignment.center, children: [
          ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: CustomImageWidget(
                  imageUrl: props['thumbnail'] as String,
                  width: double.infinity,
                  height: 25.h,
                  fit: BoxFit.cover)),
          Container(
              padding: EdgeInsets.all(4.w),
              decoration: BoxDecoration(
                  color: AppTheme.primaryBackground.withValues(alpha: 0.8),
                  shape: BoxShape.circle),
              child: CustomIconWidget(
                  iconName: 'play_arrow',
                  color: AppTheme.primaryAction,
                  size: 32)),
        ]));
  }

  Widget _buildProductPreview(Map<String, dynamic> props) {
    return Container(
        padding: EdgeInsets.all(4.w),
        decoration: BoxDecoration(
            color: AppTheme.surface,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppTheme.border)),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: CustomImageWidget(
                  imageUrl: props['image'] as String,
                  width: double.infinity,
                  height: 20.h,
                  fit: BoxFit.cover)),
          SizedBox(height: 2.h),
          Text(props['name'] as String,
              style: AppTheme.darkTheme.textTheme.titleMedium),
          SizedBox(height: 1.h),
          Text(props['price'] as String,
              style: AppTheme.darkTheme.textTheme.bodyLarge?.copyWith(
                  color: AppTheme.accent, fontWeight: FontWeight.bold)),
          SizedBox(height: 1.h),
          Text(props['description'] as String,
              style: AppTheme.darkTheme.textTheme.bodySmall,
              maxLines: 2,
              overflow: TextOverflow.ellipsis),
          SizedBox(height: 2.h),
          SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                  onPressed: () {}, child: const Text('Buy Now'))),
        ]));
  }

  Widget _buildFormPreview(Map<String, dynamic> props) {
    return Container(
        padding: EdgeInsets.all(4.w),
        decoration: BoxDecoration(
            color: AppTheme.surface,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppTheme.border)),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(props['title'] as String,
              style: AppTheme.darkTheme.textTheme.titleMedium),
          SizedBox(height: 2.h),
          ...(props['fields'] as List)
              .map((field) => Container(
                  margin: EdgeInsets.only(bottom: 2.h),
                  child: TextFormField(
                      decoration: InputDecoration(
                          labelStyle: AppTheme
                              .darkTheme.inputDecorationTheme.labelStyle),
                      maxLines: field == 'message' ? 3 : 1)))
              .toList(),
          SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                  onPressed: () {},
                  child: Text(props['submitText'] as String))),
        ]));
  }

  Widget _buildSocialPreview(Map<String, dynamic> props) {
    return Container(
        padding: EdgeInsets.all(4.w),
        child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: (props['platforms'] as List)
                .map((platform) => Container(
                    padding: EdgeInsets.all(3.w),
                    decoration: BoxDecoration(
                        color: AppTheme.surface,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: AppTheme.border)),
                    child: Column(mainAxisSize: MainAxisSize.min, children: [
                      CustomIconWidget(
                          iconName: platform['icon'] as String,
                          color: AppTheme.accent,
                          size: 24),
                      SizedBox(height: 1.h),
                      Text(platform['name'] as String,
                          style: AppTheme.darkTheme.textTheme.bodySmall),
                    ])))
                .toList()));
  }
}