import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../theme/app_theme.dart';

class QuietHoursWidget extends StatelessWidget {
  final bool enabled;
  final TimeOfDay startTime;
  final TimeOfDay endTime;
  final String selectedTimezone;
  final Function(bool, TimeOfDay?, TimeOfDay?, String?) onChanged;

  const QuietHoursWidget({
    Key? key,
    required this.enabled,
    required this.startTime,
    required this.endTime,
    required this.selectedTimezone,
    required this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16),
      padding: EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppTheme.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppTheme.primaryBackground,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  Icons.bedtime_outlined,
                  color: AppTheme.accent,
                  size: 20,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Quiet Hours',
                      style: GoogleFonts.inter(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: AppTheme.primaryText,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Set do-not-disturb periods for notifications',
                      style: GoogleFonts.inter(
                        fontSize: 14,
                        color: AppTheme.secondaryText,
                      ),
                    ),
                  ],
                ),
              ),
              Switch(
                value: enabled,
                onChanged: (value) => onChanged(value, null, null, null),
              ),
            ],
          ),

          if (enabled) ...[
            const SizedBox(height: 24),

            // Time Range
            Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppTheme.primaryBackground,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppTheme.border),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Time Range',
                    style: GoogleFonts.inter(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: AppTheme.primaryText,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      // Start Time
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Start Time',
                              style: GoogleFonts.inter(
                                fontSize: 14,
                                color: AppTheme.secondaryText,
                              ),
                            ),
                            const SizedBox(height: 8),
                            InkWell(
                              onTap: () async {
                                final time = await showTimePicker(
                                  context: context,
                                  initialTime: startTime,
                                );
                                if (time != null) {
                                  onChanged(enabled, time, null, null);
                                }
                              },
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 12, vertical: 16),
                                decoration: BoxDecoration(
                                  color: AppTheme.surface,
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(color: AppTheme.border),
                                ),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      startTime.format(context),
                                      style: GoogleFonts.inter(
                                        fontSize: 16,
                                        color: AppTheme.primaryText,
                                      ),
                                    ),
                                    Icon(
                                      Icons.access_time,
                                      color: AppTheme.secondaryText,
                                      size: 16,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 16),
                      // End Time
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'End Time',
                              style: GoogleFonts.inter(
                                fontSize: 14,
                                color: AppTheme.secondaryText,
                              ),
                            ),
                            const SizedBox(height: 8),
                            InkWell(
                              onTap: () async {
                                final time = await showTimePicker(
                                  context: context,
                                  initialTime: endTime,
                                );
                                if (time != null) {
                                  onChanged(enabled, null, time, null);
                                }
                              },
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 12, vertical: 16),
                                decoration: BoxDecoration(
                                  color: AppTheme.surface,
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(color: AppTheme.border),
                                ),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      endTime.format(context),
                                      style: GoogleFonts.inter(
                                        fontSize: 16,
                                        color: AppTheme.primaryText,
                                      ),
                                    ),
                                    Icon(
                                      Icons.access_time,
                                      color: AppTheme.secondaryText,
                                      size: 16,
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
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Timezone
            Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppTheme.primaryBackground,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppTheme.border),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Timezone',
                    style: GoogleFonts.inter(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: AppTheme.primaryText,
                    ),
                  ),
                  const SizedBox(height: 16),
                  DropdownButtonFormField<String>(
                    value: selectedTimezone,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(color: AppTheme.border),
                      ),
                      contentPadding:
                          EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    ),
                    dropdownColor: AppTheme.surface,
                    style: GoogleFonts.inter(
                      color: AppTheme.primaryText,
                      fontSize: 14,
                    ),
                    items: [
                      DropdownMenuItem(
                          value: 'UTC-8 (Pacific Time)',
                          child: Text('UTC-8 (Pacific Time)')),
                      DropdownMenuItem(
                          value: 'UTC-7 (Mountain Time)',
                          child: Text('UTC-7 (Mountain Time)')),
                      DropdownMenuItem(
                          value: 'UTC-6 (Central Time)',
                          child: Text('UTC-6 (Central Time)')),
                      DropdownMenuItem(
                          value: 'UTC-5 (Eastern Time)',
                          child: Text('UTC-5 (Eastern Time)')),
                      DropdownMenuItem(
                          value: 'UTC+0 (GMT)', child: Text('UTC+0 (GMT)')),
                      DropdownMenuItem(
                          value: 'UTC+1 (CET)', child: Text('UTC+1 (CET)')),
                    ],
                    onChanged: (value) {
                      if (value != null) {
                        onChanged(enabled, null, null, value);
                      }
                    },
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Info
            Container(
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppTheme.accent.withAlpha(26),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: AppTheme.accent.withAlpha(77)),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.info_outline,
                    color: AppTheme.accent,
                    size: 16,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Push notifications will be silenced during quiet hours. Critical alerts may still come through.',
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        color: AppTheme.accent,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}
