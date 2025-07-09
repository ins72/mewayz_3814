import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sizer/sizer.dart';

import '../../../widgets/custom_form_field_widget.dart';

class EmailInputWidget extends StatelessWidget {
  final TextEditingController controller;
  final List<String> invitationEmails;
  final Function(String) onAddEmail;
  final Function(String) onRemoveEmail;

  const EmailInputWidget({
    Key? key,
    required this.controller,
    required this.invitationEmails,
    required this.onAddEmail,
    required this.onRemoveEmail,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Team Member Emails',
          style: GoogleFonts.inter(
            fontSize: 16.sp,
            fontWeight: FontWeight.w600,
            color: const Color(0xFFF1F1F1))),
        SizedBox(height: 1.h),
        Text(
          'Add email addresses separated by commas or enter one at a time',
          style: GoogleFonts.inter(
            fontSize: 12.sp,
            color: const Color(0xFFF1F1F1).withAlpha(179))),
        SizedBox(height: 2.h),
        
        // Email input field
        Row(
          children: [
            Expanded(
              child: CustomFormFieldWidget(
                controller: controller,

                keyboardType: TextInputType.emailAddress

)),
            SizedBox(width: 2.w),
            GestureDetector(
              onTap: () {
                if (controller.text.isNotEmpty) {
                  _processEmailInput(controller.text);
                }
              },
              child: Container(
                padding: EdgeInsets.all(3.w),
                decoration: BoxDecoration(
                  color: const Color(0xFFFDFDFD),
                  borderRadius: BorderRadius.circular(8)),
                child: Icon(
                  Icons.add,
                  color: const Color(0xFF141414),
                  size: 5.w))),
          ]),
        SizedBox(height: 2.h),
        
        // Added emails display
        if (invitationEmails.isNotEmpty) ...[
          Text(
            'Added Emails (${invitationEmails.length}):',
            style: GoogleFonts.inter(
              fontSize: 14.sp,
              fontWeight: FontWeight.w500,
              color: const Color(0xFFF1F1F1))),
          SizedBox(height: 1.h),
          Container(
            padding: EdgeInsets.all(3.w),
            decoration: BoxDecoration(
              color: const Color(0xFF191919),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: const Color(0xFF282828),
                width: 1)),
            child: Column(
              children: invitationEmails.map((email) => _buildEmailChip(email)).toList())),
        ] else
          Container(
            padding: EdgeInsets.all(3.w),
            decoration: BoxDecoration(
              color: const Color(0xFF191919),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: const Color(0xFF282828),
                width: 1)),
            child: Row(
              children: [
                Icon(
                  Icons.info_outline,
                  color: const Color(0xFFF1F1F1).withAlpha(128),
                  size: 5.w),
                SizedBox(width: 3.w),
                Expanded(
                  child: Text(
                    'No emails added yet. Add team member emails to send invitations.',
                    style: GoogleFonts.inter(
                      fontSize: 12.sp,
                      color: const Color(0xFFF1F1F1).withAlpha(179)))),
              ])),
      ]);
  }

  Widget _buildEmailChip(String email) {
    return Container(
      margin: EdgeInsets.only(bottom: 1.h),
      padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
      decoration: BoxDecoration(
        color: const Color(0xFF282828),
        borderRadius: BorderRadius.circular(8)),
      child: Row(
        children: [
          Icon(
            Icons.email_outlined,
            color: const Color(0xFFF1F1F1).withAlpha(179),
            size: 4.w),
          SizedBox(width: 2.w),
          Expanded(
            child: Text(
              email,
              style: GoogleFonts.inter(
                fontSize: 12.sp,
                color: const Color(0xFFF1F1F1)))),
          GestureDetector(
            onTap: () => onRemoveEmail(email),
            child: Icon(
              Icons.close,
              color: const Color(0xFFF1F1F1).withAlpha(179),
              size: 4.w)),
        ]));
  }

  void _processEmailInput(String input) {
    // Handle multiple emails separated by commas
    final emails = input.split(',').map((e) => e.trim()).where((e) => e.isNotEmpty);
    
    for (final email in emails) {
      if (_isValidEmail(email)) {
        onAddEmail(email);
      }
    }
  }

  bool _isValidEmail(String email) {
    return RegExp(r'^[^@]+@[^@]+\.[^@]+$').hasMatch(email);
  }
}