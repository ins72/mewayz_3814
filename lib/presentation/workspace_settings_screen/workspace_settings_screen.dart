import 'package:flutter/material.dart';

import '../../core/app_export.dart';
import './widgets/billing_settings_widget.dart';
import './widgets/branding_settings_widget.dart';
import './widgets/danger_zone_widget.dart';
import './widgets/general_settings_widget.dart';
import './widgets/integrations_settings_widget.dart';
import './widgets/members_settings_widget.dart';
import './widgets/security_settings_widget.dart';

class WorkspaceSettingsScreen extends StatefulWidget {
  const WorkspaceSettingsScreen({super.key});

  @override
  State<WorkspaceSettingsScreen> createState() =>
      _WorkspaceSettingsScreenState();
}

class _WorkspaceSettingsScreenState extends State<WorkspaceSettingsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  bool _hasUnsavedChanges = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 7, vsync: this);
    _tabController.addListener(() {
      if (_tabController.indexIsChanging) {
        _checkUnsavedChanges();
      }
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _checkUnsavedChanges() {
    if (_hasUnsavedChanges) {
      _showUnsavedChangesDialog();
    }
  }

  void _showUnsavedChangesDialog() {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
                title: Text('Unsaved Changes',
                    style: GoogleFonts.inter(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        color: AppTheme.primaryText)),
                content: Text(
                    'You have unsaved changes. Are you sure you want to leave?',
                    style: GoogleFonts.inter(
                        fontSize: 14, color: AppTheme.secondaryText)),
                actions: [
                  TextButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: Text('Cancel',
                          style: GoogleFonts.inter(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: AppTheme.secondaryText))),
                  TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                        setState(() {
                          _hasUnsavedChanges = false;
                        });
                      },
                      child: Text('Leave',
                          style: GoogleFonts.inter(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: AppTheme.error))),
                ]));
  }

  void _saveChanges() {
    // TODO: Implement save functionality
    setState(() {
      _hasUnsavedChanges = false;
    });

    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Settings saved successfully',
            style:
                GoogleFonts.inter(fontSize: 14, color: AppTheme.primaryText)),
        backgroundColor: AppTheme.success));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: AppTheme.primaryBackground,
        appBar: AppBar(
            backgroundColor: AppTheme.primaryBackground,
            elevation: 0,
            leading: IconButton(
                onPressed: () => Navigator.of(context).pop(),
                icon: const CustomIconWidget(
                    iconName: 'back', color: AppTheme.primaryText)),
            title: Text('Workspace Settings',
                style: GoogleFonts.inter(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.primaryText)),
            actions: [
              if (_hasUnsavedChanges)
                Container(
                    margin: const EdgeInsets.only(right: 16),
                    child: ElevatedButton(
                        onPressed: _saveChanges,
                        style: ElevatedButton.styleFrom(
                            backgroundColor: AppTheme.primaryAction,
                            foregroundColor: AppTheme.primaryBackground,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 8),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8))),
                        child: Text('Save',
                            style: GoogleFonts.inter(
                                fontSize: 14, fontWeight: FontWeight.w500)))),
            ],
            bottom: TabBar(
                controller: _tabController,
                isScrollable: true,
                tabAlignment: TabAlignment.start,
                indicatorColor: AppTheme.accent,
                labelColor: AppTheme.primaryText,
                unselectedLabelColor: AppTheme.secondaryText,
                dividerColor: AppTheme.border,
                tabs: [
                  Tab(
                      child: Text('General',
                          style: GoogleFonts.inter(
                              fontSize: 14, fontWeight: FontWeight.w500))),
                  Tab(
                      child: Text('Members',
                          style: GoogleFonts.inter(
                              fontSize: 14, fontWeight: FontWeight.w500))),
                  Tab(
                      child: Text('Billing',
                          style: GoogleFonts.inter(
                              fontSize: 14, fontWeight: FontWeight.w500))),
                  Tab(
                      child: Text('Branding',
                          style: GoogleFonts.inter(
                              fontSize: 14, fontWeight: FontWeight.w500))),
                  Tab(
                      child: Text('Security',
                          style: GoogleFonts.inter(
                              fontSize: 14, fontWeight: FontWeight.w500))),
                  Tab(
                      child: Text('Integrations',
                          style: GoogleFonts.inter(
                              fontSize: 14, fontWeight: FontWeight.w500))),
                  Tab(
                      child: Text('Danger Zone',
                          style: GoogleFonts.inter(
                              fontSize: 14, fontWeight: FontWeight.w500))),
                ])),
        body: TabBarView(controller: _tabController, children: [
          GeneralSettingsWidget(
              onChanged: () => setState(() => _hasUnsavedChanges = true)),
          MembersSettingsWidget(
              onChanged: () => setState(() => _hasUnsavedChanges = true)),
          BillingSettingsWidget(
              onChanged: () => setState(() => _hasUnsavedChanges = true)),
          BrandingSettingsWidget(
              onChanged: () => setState(() => _hasUnsavedChanges = true)),
          SecuritySettingsWidget(
              onChanged: () => setState(() => _hasUnsavedChanges = true)),
          IntegrationsSettingsWidget(
              onChanged: () => setState(() => _hasUnsavedChanges = true)),
          DangerZoneWidget(
              onChanged: () => setState(() => _hasUnsavedChanges = true)),
        ]));
  }
}