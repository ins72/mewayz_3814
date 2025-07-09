import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sizer/sizer.dart';

import '../../../widgets/custom_form_field_widget.dart';

class CustomInvitationMessageWidget extends StatelessWidget {
  final TextEditingController controller;
  final Function(String) onMessageChanged;

  const CustomInvitationMessageWidget({
    Key? key,
    required this.controller,
    required this.onMessageChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Custom Invitation Message',
          style: GoogleFonts.inter(
            fontSize: 16.sp,
            fontWeight: FontWeight.w600,
            color: const Color(0xFFF1F1F1))),
        SizedBox(height: 1.h),
        Text(
          'Personalize your invitation with a custom message',
          style: GoogleFonts.inter(
            fontSize: 12.sp,
            color: const Color(0xFFF1F1F1).withAlpha(179))),
        SizedBox(height: 2.h),
        
        CustomFormFieldWidget(
          controller: controller,

          maxLines: 4,
          onChanged: onMessageChanged),
        SizedBox(height: 2.h),
        
        // Message preview
        Container(
          padding: EdgeInsets.all(3.w),
          decoration: BoxDecoration(
            color: const Color(0xFF191919),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: const Color(0xFF282828),
              width: 1)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.preview,
                    color: const Color(0xFFF1F1F1).withAlpha(179),
                    size: 4.w),
                  SizedBox(width: 2.w),
                  Text(
                    'Message Preview',
                    style: GoogleFonts.inter(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w500,
                      color: const Color(0xFFF1F1F1))),
                ]),
              SizedBox(height: 1.h),
              Container(
                padding: EdgeInsets.all(3.w),
                decoration: BoxDecoration(
                  color: const Color(0xFF282828),
                  borderRadius: BorderRadius.circular(8)),
                child: Text(
                  controller.text.isEmpty 
                      ? 'Your invitation message will appear here...'
                      : controller.text,
                  style: GoogleFonts.inter(
                    fontSize: 12.sp,
                    color: controller.text.isEmpty 
                        ? const Color(0xFFF1F1F1).withAlpha(128)
                        : const Color(0xFFF1F1F1).withAlpha(204),
                    fontStyle: controller.text.isEmpty 
                        ? FontStyle.italic 
                        : FontStyle.normal))),
            ])),
        SizedBox(height: 1.h),
        
        // Quick message templates
        Text(
          'Quick Templates:',
          style: GoogleFonts.inter(
            fontSize: 12.sp,
            fontWeight: FontWeight.w500,
            color: const Color(0xFFF1F1F1))),
        SizedBox(height: 1.h),
        
        Wrap(
          spacing: 2.w,
          runSpacing: 1.h,
          children: [
            _buildTemplateChip('Professional', 'I would like to invite you to collaborate on our workspace project.'),
            _buildTemplateChip('Friendly', 'Hey! Want to join our awesome team workspace? We\'d love to have you on board!'),
            _buildTemplateChip('Brief', 'Join our workspace and let\'s build something amazing together!'),
          ]),
      ]);
  }

  Widget _buildTemplateChip(String label, String message) {
    return GestureDetector(
      onTap: () {
        controller.text = message;
        onMessageChanged(message);
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
        decoration: BoxDecoration(
          color: const Color(0xFF282828),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: const Color(0xFF282828),
            width: 1)),
        child: Text(
          label,
          style: GoogleFonts.inter(
            fontSize: 11.sp,
            color: const Color(0xFFF1F1F1).withAlpha(204)))));
  }
}