import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class MobilePreviewWidget extends StatelessWidget {
  final List<Map<String, dynamic>> components;
  final String selectedComponentId;
  final Map<String, dynamic> pageSettings;
  final Function(String) onComponentTap;
  final Function(String) onComponentLongPress;

  const MobilePreviewWidget({
    Key? key,
    required this.components,
    required this.selectedComponentId,
    required this.pageSettings,
    required this.onComponentTap,
    required this.onComponentLongPress,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.all(4.w),
        child: Center(
            child: Container(
                width: 80.w,
                height: 85.h,
                decoration: BoxDecoration(
                    color: Color(int.parse(pageSettings['backgroundColor']
                        .replaceFirst('#', '0xFF'))),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: AppTheme.border, width: 2)),
                child: Column(children: [
                  // Phone status bar simulation
                  Container(
                      height: 4.h,
                      decoration: BoxDecoration(
                          color: AppTheme.primaryBackground,
                          borderRadius:
                              BorderRadius.vertical(top: Radius.circular(18))),
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                                margin: EdgeInsets.only(left: 4.w),
                                child: Text('9:41',
                                    style: AppTheme
                                        .darkTheme.textTheme.bodySmall
                                        ?.copyWith(
                                            color: AppTheme.primaryText,
                                            fontWeight: FontWeight.w600))),
                            Row(children: [
                              CustomIconWidget(
                                  iconName: 'signal_cellular_4_bar',
                                  color: AppTheme.primaryText,
                                  size: 16),
                              SizedBox(width: 1.w),
                              CustomIconWidget(
                                  iconName: 'wifi',
                                  color: AppTheme.primaryText,
                                  size: 16),
                              SizedBox(width: 1.w),
                              CustomIconWidget(
                                  iconName: 'battery_full',
                                  color: AppTheme.primaryText,
                                  size: 16),
                              SizedBox(width: 4.w),
                            ]),
                          ])),
                  // Scrollable content area
                  Expanded(
                      child: Container(
                          decoration: BoxDecoration(
                              color: Color(int.parse(
                                  pageSettings['backgroundColor']
                                      .replaceFirst('#', '0xFF'))),
                              borderRadius: BorderRadius.vertical(
                                  bottom: Radius.circular(18))),
                          child: components.isEmpty
                              ? Center(
                                  child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                      CustomIconWidget(
                                          iconName: 'add_circle_outline',
                                          color: AppTheme.secondaryText,
                                          size: 48),
                                      SizedBox(height: 2.h),
                                      Text('Add components to get started',
                                          style: AppTheme
                                              .darkTheme.textTheme.bodyMedium
                                              ?.copyWith(
                                                  color:
                                                      AppTheme.secondaryText),
                                          textAlign: TextAlign.center),
                                    ]))
                              : ListView.builder(
                                  padding: EdgeInsets.all(4.w),
                                  itemCount: components.length,
                                  itemBuilder: (context, index) {
                                    final component = components[index];
                                    final isSelected =
                                        component['id'] == selectedComponentId;

                                    return GestureDetector(
                                        onTap: () =>
                                            onComponentTap(component['id']),
                                        onLongPress: () => onComponentLongPress(
                                            component['id']),
                                        child: Container(
                                            margin:
                                                EdgeInsets.only(bottom: 3.h),
                                            decoration: BoxDecoration(
                                                border: isSelected
                                                    ? Border.all(
                                                        color: AppTheme.accent,
                                                        width: 2)
                                                    : null,
                                                borderRadius:
                                                    BorderRadius.circular(8)),
                                            child: _buildComponent(component)));
                                  }))),
                ]))));
  }

  Widget _buildComponent(Map<String, dynamic> component) {
    switch (component['type']) {
      case 'profile':
        return _buildProfileComponent(component);
      case 'button':
        return _buildButtonComponent(component);
      case 'social':
        return _buildSocialComponent(component);
      case 'text':
        return _buildTextComponent(component);
      case 'gallery':
        return _buildGalleryComponent(component);
      case 'video':
        return _buildVideoComponent(component);
      case 'form':
        return _buildFormComponent(component);
      case 'newsletter':
        return _buildNewsletterComponent(component);
      case 'product':
        return _buildProductComponent(component);
      case 'booking':
        return _buildBookingComponent(component);
      case 'testimonials':
        return _buildTestimonialsComponent(component);
      case 'music':
        return _buildMusicComponent(component);
      default:
        return Container(
            padding: EdgeInsets.all(4.w),
            decoration: BoxDecoration(
                color: AppTheme.surface,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: AppTheme.border)),
            child: Text('Unknown component type: ${component['type']}',
                style: AppTheme.darkTheme.textTheme.bodyMedium
                    ?.copyWith(color: AppTheme.secondaryText)));
    }
  }

  Widget _buildProfileComponent(Map<String, dynamic> component) {
    final props = component['defaultProps'];
    return Container(
        padding: EdgeInsets.all(4.w),
        child: Column(children: [
          CircleAvatar(
              radius: 40, backgroundImage: NetworkImage(props['profileImage'])),
          SizedBox(height: 2.h),
          Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            Text(props['name'],
                style: AppTheme.darkTheme.textTheme.headlineSmall?.copyWith(
                    color: AppTheme.primaryText, fontWeight: FontWeight.w600)),
            if (props['showVerifiedBadge'])
              Container(
                  margin: EdgeInsets.only(left: 2.w),
                  child: CustomIconWidget(
                      iconName: 'verified', color: AppTheme.accent, size: 20)),
          ]),
          SizedBox(height: 1.h),
          Text(props['bio'],
              style: AppTheme.darkTheme.textTheme.bodyMedium
                  ?.copyWith(color: AppTheme.secondaryText),
              textAlign: TextAlign.center),
        ]));
  }

  Widget _buildButtonComponent(Map<String, dynamic> component) {
    final props = component['defaultProps'];
    return Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(horizontal: 4.w),
        child: ElevatedButton(
            onPressed: () {
              // Handle button press
            },
            style: ElevatedButton.styleFrom(
                backgroundColor: Color(int.parse(
                    props['backgroundColor'].replaceFirst('#', '0xFF'))),
                foregroundColor: Color(
                    int.parse(props['textColor'].replaceFirst('#', '0xFF'))),
                padding: EdgeInsets.symmetric(vertical: 3.h),
                shape: RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.circular(props['borderRadius']))),
            child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              if (props['showIcon'])
                Container(
                    margin: EdgeInsets.only(right: 2.w),
                    child: CustomIconWidget(
                        iconName: props['icon'],
                        color: Color(int.parse(
                            props['textColor'].replaceFirst('#', '0xFF'))),
                        size: 20)),
              Text(props['title'],
                  style: AppTheme.darkTheme.textTheme.bodyLarge?.copyWith(
                      color: Color(int.parse(
                          props['textColor'].replaceFirst('#', '0xFF'))),
                      fontWeight: FontWeight.w500)),
            ])));
  }

  Widget _buildSocialComponent(Map<String, dynamic> component) {
    final props = component['defaultProps'];
    final platforms = props['platforms'] as List;

    return Container(
        padding: EdgeInsets.symmetric(horizontal: 4.w),
        child: props['layout'] == 'horizontal'
            ? Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: platforms
                    .map((platform) => _buildSocialIcon(platform, props))
                    .toList())
            : Column(
                children: platforms
                    .map((platform) => _buildSocialIcon(platform, props))
                    .toList()));
  }

  Widget _buildSocialIcon(
      Map<String, dynamic> platform, Map<String, dynamic> props) {
    return Container(
        margin: EdgeInsets.symmetric(vertical: 1.h),
        child: Column(children: [
          CircleAvatar(
              radius: 20,
              backgroundColor:
                  Color(int.parse(platform['color'].replaceFirst('#', '0xFF'))),
              child: CustomIconWidget(
                  iconName: platform['icon'],
                  color: AppTheme.primaryAction,
                  size: 20)),
          if (props['showLabels']) ...[
            SizedBox(height: 1.h),
            Text(platform['name'],
                style: AppTheme.darkTheme.textTheme.bodySmall
                    ?.copyWith(color: AppTheme.secondaryText)),
          ],
        ]));
  }

  Widget _buildTextComponent(Map<String, dynamic> component) {
    final props = component['defaultProps'];
    return Container(
        width: double.infinity,
        padding: EdgeInsets.all(props['padding']),
        decoration: BoxDecoration(
            color: props['backgroundColor'] == 'transparent'
                ? Colors.transparent
                : Color(int.parse(
                    props['backgroundColor'].replaceFirst('#', '0xFF'))),
            borderRadius: BorderRadius.circular(8)),
        child: Text(props['content'],
            style: AppTheme.darkTheme.textTheme.bodyMedium?.copyWith(
                color:
                    Color(int.parse(props['color'].replaceFirst('#', '0xFF'))),
                fontSize: props['fontSize'],
                fontWeight: props['fontWeight'] == 'bold'
                    ? FontWeight.bold
                    : FontWeight.normal),
            textAlign: props['alignment'] == 'center'
                ? TextAlign.center
                : TextAlign.left));
  }

  Widget _buildGalleryComponent(Map<String, dynamic> component) {
    final props = component['defaultProps'];
    final images = props['images'] as List;

    return Container(
        padding: EdgeInsets.symmetric(horizontal: 4.w),
        child: GridView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: props['columns'],
                crossAxisSpacing: props['spacing'],
                mainAxisSpacing: props['spacing']),
            itemCount: images.length,
            itemBuilder: (context, index) {
              return ClipRRect(
                  borderRadius: BorderRadius.circular(props['borderRadius']),
                  child: CustomImageWidget(imageUrl: '', fit: BoxFit.cover));
            }));
  }

  Widget _buildVideoComponent(Map<String, dynamic> component) {
    final props = component['defaultProps'];
    return Container(
        padding: EdgeInsets.symmetric(horizontal: 4.w),
        child: ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: AspectRatio(
                aspectRatio: 16 / 9,
                child: Stack(children: [
                  CustomImageWidget(imageUrl: '', fit: BoxFit.cover),
                  Center(
                      child: CircleAvatar(
                          radius: 30,
                          backgroundColor:
                              AppTheme.primaryAction.withAlpha(204),
                          child: CustomIconWidget(
                              iconName: 'play_arrow',
                              color: AppTheme.primaryBackground,
                              size: 32))),
                ]))));
  }

  Widget _buildFormComponent(Map<String, dynamic> component) {
    final props = component['defaultProps'];
    return Container(
        padding: EdgeInsets.all(4.w),
        decoration: BoxDecoration(
            color: Color(
                int.parse(props['backgroundColor'].replaceFirst('#', '0xFF'))),
            borderRadius: BorderRadius.circular(8)),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(props['title'],
              style: AppTheme.darkTheme.textTheme.titleMedium
                  ?.copyWith(color: AppTheme.primaryText)),
          SizedBox(height: 2.h),
          ...props['fields'].map<Widget>((field) => Container(
              margin: EdgeInsets.only(bottom: 2.h),
              child: TextFormField(
                  enabled: false,
                  decoration: InputDecoration(
                      labelText: field['label'],
                      hintText: 'Enter ${field['label'].toLowerCase()}',
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8)))))),
          SizedBox(height: 1.h),
          ElevatedButton(
              onPressed: null,
              child: Text(props['submitText']),
              style: ElevatedButton.styleFrom(
                  minimumSize: Size(double.infinity, 50))),
        ]));
  }

  Widget _buildNewsletterComponent(Map<String, dynamic> component) {
    final props = component['defaultProps'];
    return Container(
        padding: EdgeInsets.all(4.w),
        decoration: BoxDecoration(
            color: Color(
                int.parse(props['backgroundColor'].replaceFirst('#', '0xFF'))),
            borderRadius: BorderRadius.circular(8)),
        child: Column(children: [
          Text(props['title'],
              style: AppTheme.darkTheme.textTheme.titleMedium
                  ?.copyWith(color: AppTheme.primaryText)),
          SizedBox(height: 1.h),
          Text(props['description'],
              style: AppTheme.darkTheme.textTheme.bodyMedium
                  ?.copyWith(color: AppTheme.secondaryText),
              textAlign: TextAlign.center),
          SizedBox(height: 2.h),
          Row(children: [
            Expanded(
                child: TextFormField(
                    enabled: false,
                    decoration: InputDecoration(
                        hintText: props['placeholder'],
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8))))),
            SizedBox(width: 2.w),
            ElevatedButton(onPressed: null, child: Text(props['buttonText'])),
          ]),
        ]));
  }

  Widget _buildProductComponent(Map<String, dynamic> component) {
    final props = component['defaultProps'];
    final products = props['products'] as List;

    return Container(
        padding: EdgeInsets.symmetric(horizontal: 4.w),
        child: Column(
            children: products
                .map<Widget>((product) => Container(
                    margin: EdgeInsets.only(bottom: 2.h),
                    decoration: BoxDecoration(
                        color: AppTheme.surface,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: AppTheme.border)),
                    child: Row(children: [
                      ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: CustomImageWidget(
                              imageUrl: '',
                              width: 80,
                              height: 80,
                              fit: BoxFit.cover)),
                      SizedBox(width: 3.w),
                      Expanded(
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                            Text(product['name'],
                                style: AppTheme.darkTheme.textTheme.titleSmall
                                    ?.copyWith(color: AppTheme.primaryText)),
                            if (props['showPrices']) ...[
                              SizedBox(height: 1.h),
                              Text(product['price'],
                                  style: AppTheme.darkTheme.textTheme.bodyMedium
                                      ?.copyWith(
                                          color: AppTheme.accent,
                                          fontWeight: FontWeight.w600)),
                            ],
                            if (props['showDescriptions']) ...[
                              SizedBox(height: 1.h),
                              Text(product['description'],
                                  style: AppTheme.darkTheme.textTheme.bodySmall
                                      ?.copyWith(color: AppTheme.secondaryText),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis),
                            ],
                          ])),
                    ])))
                .toList()));
  }

  Widget _buildBookingComponent(Map<String, dynamic> component) {
    final props = component['defaultProps'];
    return Container(
        padding: EdgeInsets.all(4.w),
        decoration: BoxDecoration(
            color: Color(
                int.parse(props['backgroundColor'].replaceFirst('#', '0xFF'))),
            borderRadius: BorderRadius.circular(8)),
        child: Column(children: [
          CustomIconWidget(
              iconName: 'calendar_today', color: AppTheme.accent, size: 32),
          SizedBox(height: 2.h),
          Text(props['title'],
              style: AppTheme.darkTheme.textTheme.titleMedium
                  ?.copyWith(color: AppTheme.primaryText)),
          SizedBox(height: 1.h),
          Text(props['description'],
              style: AppTheme.darkTheme.textTheme.bodyMedium
                  ?.copyWith(color: AppTheme.secondaryText),
              textAlign: TextAlign.center),
          SizedBox(height: 2.h),
          ElevatedButton(
              onPressed: null,
              child: Text(props['buttonText']),
              style: ElevatedButton.styleFrom(
                  minimumSize: Size(double.infinity, 50))),
        ]));
  }

  Widget _buildTestimonialsComponent(Map<String, dynamic> component) {
    final props = component['defaultProps'];
    final testimonials = props['testimonials'] as List;

    return Container(
        padding: EdgeInsets.symmetric(horizontal: 4.w),
        child: Column(
            children: testimonials
                .map<Widget>((testimonial) => Container(
                    margin: EdgeInsets.only(bottom: 2.h),
                    padding: EdgeInsets.all(4.w),
                    decoration: BoxDecoration(
                        color: AppTheme.surface,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: AppTheme.border)),
                    child: Column(children: [
                      CustomIconWidget(
                          iconName: 'format_quote',
                          color: AppTheme.accent,
                          size: 24),
                      SizedBox(height: 2.h),
                      Text(testimonial['text'],
                          style: AppTheme.darkTheme.textTheme.bodyMedium
                              ?.copyWith(
                                  color: AppTheme.primaryText,
                                  fontStyle: FontStyle.italic),
                          textAlign: TextAlign.center),
                      SizedBox(height: 2.h),
                      Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            if (props['showAvatars'])
                              CircleAvatar(
                                  radius: 16,
                                  backgroundImage:
                                      NetworkImage(testimonial['avatar'])),
                            SizedBox(width: 2.w),
                            Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(testimonial['author'],
                                      style: AppTheme
                                          .darkTheme.textTheme.bodySmall
                                          ?.copyWith(
                                              color: AppTheme.primaryText,
                                              fontWeight: FontWeight.w600)),
                                  Text(testimonial['position'],
                                      style: AppTheme
                                          .darkTheme.textTheme.bodySmall
                                          ?.copyWith(
                                              color: AppTheme.secondaryText)),
                                ]),
                          ]),
                    ])))
                .toList()));
  }

  Widget _buildMusicComponent(Map<String, dynamic> component) {
    final props = component['defaultProps'];
    final tracks = props['tracks'] as List;

    return Container(
        padding: EdgeInsets.all(4.w),
        decoration: BoxDecoration(
            color: Color(
                int.parse(props['backgroundColor'].replaceFirst('#', '0xFF'))),
            borderRadius: BorderRadius.circular(8)),
        child: Column(
            children: tracks
                .map<Widget>((track) => Container(
                    margin: EdgeInsets.only(bottom: 2.h),
                    decoration: BoxDecoration(
                        color: AppTheme.surface,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: AppTheme.border)),
                    child: ListTile(
                        leading: ClipRRect(
                            borderRadius: BorderRadius.circular(4),
                            child: CustomImageWidget(
                                imageUrl: '',
                                width: 40,
                                height: 40,
                                fit: BoxFit.cover)),
                        title: Text(track['title'],
                            style: AppTheme.darkTheme.textTheme.bodyMedium
                                ?.copyWith(color: AppTheme.primaryText)),
                        subtitle: Text(track['artist'],
                            style: AppTheme.darkTheme.textTheme.bodySmall
                                ?.copyWith(color: AppTheme.secondaryText)),
                        trailing: CustomIconWidget(iconName: 'play_arrow', color: AppTheme.accent, size: 24))))
                .toList()));
  }
}
