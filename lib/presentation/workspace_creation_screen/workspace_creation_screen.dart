import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../core/app_export.dart';
import './widgets/progress_indicator_widget.dart';
import './widgets/team_invitation_widget.dart';
import './widgets/workspace_preview_widget.dart';
import './widgets/workspace_settings_widget.dart';
import './widgets/workspace_setup_step_widget.dart';
import './widgets/workspace_template_widget.dart';

class WorkspaceCreationScreen extends StatefulWidget {
  const WorkspaceCreationScreen({Key? key}) : super(key: key);

  @override
  State<WorkspaceCreationScreen> createState() =>
      _WorkspaceCreationScreenState();
}

class _WorkspaceCreationScreenState extends State<WorkspaceCreationScreen> {
  final PageController _pageController = PageController();
  int _currentStep = 0;
  final int _totalSteps = 4;
  bool _isLoading = false;

  // Step 1: Basic Information
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  String _selectedIndustry = 'Marketing & Advertising';
  File? _logoFile;
  String _logoUrl = '';

  // Step 2: Workspace Settings
  String _privacyLevel = 'private';
  String _defaultPermissions = 'editor';
  String _billingPlan = 'free';

  // Step 3: Team Invitations
  final List<Map<String, String>> _teamMembers = [];
  final TextEditingController _emailController = TextEditingController();
  String _selectedRole = 'editor';

  // Step 4: Template Selection
  String _selectedTemplate = 'blank';

  final List<String> _industries = [
    'Marketing & Advertising',
    'E-commerce & Retail',
    'Education & Training',
    'Healthcare & Medical',
    'Technology & Software',
    'Consulting & Services',
    'Real Estate',
    'Finance & Banking',
    'Media & Entertainment',
    'Non-profit & Charity',
    'Other',
  ];

  final List<Map<String, dynamic>> _templates = [
{ 'id': 'blank',
'name': 'Blank Workspace',
'description': 'Start with a clean workspace',
'icon': 'add_circle_outline',
'features': ['Basic dashboard', 'Team management', 'Settings'],
},
{ 'id': 'marketing',
'name': 'Marketing Agency',
'description': 'Perfect for digital marketing agencies',
'icon': 'campaign',
'features': ['Social media tools', 'Lead generation', 'Analytics'],
},
{ 'id': 'ecommerce',
'name': 'E-commerce Store',
'description': 'Complete e-commerce solution',
'icon': 'shopping_cart',
'features': ['Product catalog', 'Order management', 'Payment processing'],
},
{ 'id': 'education',
'name': 'Educational Platform',
'description': 'Create and sell online courses',
'icon': 'school',
'features': ['Course creation', 'Student management', 'Certificates'],
},
{ 'id': 'consulting',
'name': 'Consulting Business',
'description': 'Manage consulting projects',
'icon': 'business_center',
'features': ['Project tracking', 'Client management', 'Invoicing'],
},
];

  @override
  void dispose() {
    _pageController.dispose();
    _nameController.dispose();
    _descriptionController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  bool _canProceedToNextStep() {
    switch (_currentStep) {
      case 0:
        return _nameController.text.isNotEmpty;
      case 1:
        return true; // Settings step is always valid
      case 2:
        return true; // Team invitation is optional
      case 3:
        return true; // Template selection is always valid
      default:
        return false;
    }
  }

  void _nextStep() {
    if (_currentStep < _totalSteps - 1 && _canProceedToNextStep()) {
      setState(() {
        _currentStep++;
      });
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void _previousStep() {
    if (_currentStep > 0) {
      setState(() {
        _currentStep--;
      });
      _pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void _addTeamMember() {
    if (_emailController.text.isNotEmpty &&
        _isValidEmail(_emailController.text)) {
      setState(() {
        _teamMembers.add({
          'email': _emailController.text,
          'role': _selectedRole,
        });
        _emailController.clear();
      });
    }
  }

  void _removeTeamMember(int index) {
    setState(() {
      _teamMembers.removeAt(index);
    });
  }

  bool _isValidEmail(String email) {
    return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email);
  }

  Future<void> _createWorkspace() async {
    setState(() {
      _isLoading = true;
    });

    try {
      // Simulate API call
      await Future.delayed(const Duration(seconds: 3));

      if (mounted) {
        HapticFeedback.selectionClick();

        // Show success message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
                'Workspace "${_nameController.text}" created successfully!'),
            backgroundColor: AppTheme.success,
            behavior: SnackBarBehavior.floating,
          ),
        );

        // Navigate to workspace dashboard
        Navigator.pushNamedAndRemoveUntil(
          context,
          AppRoutes.workspaceDashboard,
          (route) => false,
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to create workspace: ${e.toString()}'),
            backgroundColor: AppTheme.error,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  String _getStepTitle() {
    switch (_currentStep) {
      case 0:
        return 'Basic Information';
      case 1:
        return 'Workspace Settings';
      case 2:
        return 'Invite Team Members';
      case 3:
        return 'Choose Template';
      default:
        return 'Workspace Setup';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.primaryBackground,
      appBar: AppBar(
        backgroundColor: AppTheme.primaryBackground,
        elevation: 0,
        title: Text(_getStepTitle()),
        leading: IconButton(
          icon: const CustomIconWidget(
            iconName: 'arrow_back',
            color: AppTheme.primaryText,
            size: 24,
          ),
          onPressed:
              _currentStep > 0 ? _previousStep : () => Navigator.pop(context),
        ),
        actions: [
          TextButton(
            onPressed: _currentStep == 2 ? _nextStep : null,
            child: Text(
              _currentStep == 2 ? 'Skip' : '',
              style: TextStyle(
                color: _currentStep == 2 ? AppTheme.accent : Colors.transparent,
              ),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          // Progress Indicator
          Padding(
            padding: EdgeInsets.all(4.w),
            child: WorkspaceProgressIndicatorWidget(
              currentStep: _currentStep,
              totalSteps: _totalSteps,
            ),
          ),

          // Step Content
          Expanded(
            child: _isLoading
                ? const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CircularProgressIndicator(
                          color: AppTheme.accent,
                        ),
                        SizedBox(height: 16),
                        Text(
                          'Creating your workspace...',
                          style: TextStyle(
                            color: AppTheme.primaryText,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  )
                : PageView(
                    controller: _pageController,
                    physics: const NeverScrollableScrollPhysics(),
                    children: [
                      // Step 1: Basic Information
                      WorkspaceSetupStepWidget(
                        nameController: _nameController,
                        descriptionController: _descriptionController,
                        selectedIndustry: _selectedIndustry,
                        industries: _industries,
                        logoFile: _logoFile,
                        logoUrl: _logoUrl,
                        onIndustryChanged: (value) {
                          setState(() {
                            _selectedIndustry = value;
                          });
                        },
                        onLogoChanged: (file, url) {
                          setState(() {
                            _logoFile = file;
                            _logoUrl = url;
                          });
                        },
                      ),

                      // Step 2: Workspace Settings
                      WorkspaceSettingsWidget(
                        privacyLevel: _privacyLevel,
                        defaultPermissions: _defaultPermissions,
                        billingPlan: _billingPlan,
                        onPrivacyChanged: (value) {
                          setState(() {
                            _privacyLevel = value;
                          });
                        },
                        onPermissionsChanged: (value) {
                          setState(() {
                            _defaultPermissions = value;
                          });
                        },
                        onBillingChanged: (value) {
                          setState(() {
                            _billingPlan = value;
                          });
                        },
                      ),

                      // Step 3: Team Invitations
                      TeamInvitationWidget(
                        teamMembers: _teamMembers,
                        emailController: _emailController,
                        selectedRole: _selectedRole,
                        onRoleChanged: (value) {
                          setState(() {
                            _selectedRole = value;
                          });
                        },
                        onAddMember: _addTeamMember,
                        onRemoveMember: _removeTeamMember,
                      ),

                      // Step 4: Template Selection & Preview
                      Column(
                        children: [
                          Expanded(
                            child: WorkspaceTemplateWidget(
                              templates: _templates,
                              selectedTemplate: _selectedTemplate,
                              onTemplateChanged: (value) {
                                setState(() {
                                  _selectedTemplate = value;
                                });
                              },
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.all(4.w),
                            child: WorkspacePreviewWidget(
                              workspaceName: _nameController.text,
                              description: _descriptionController.text,
                              industry: _selectedIndustry,
                              privacyLevel: _privacyLevel,
                              teamMembers: _teamMembers,
                              selectedTemplate: _selectedTemplate,
                              logoUrl: _logoUrl,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
          ),

          // Bottom Navigation
          if (!_isLoading) ...[
            Container(
              padding: EdgeInsets.all(4.w),
              decoration: BoxDecoration(
                color: AppTheme.surface,
                border: Border(
                  top: BorderSide(color: AppTheme.border, width: 1),
                ),
              ),
              child: Row(
                children: [
                  if (_currentStep > 0) ...[
                    Expanded(
                      child: OutlinedButton(
                        onPressed: _previousStep,
                        style: OutlinedButton.styleFrom(
                          padding: EdgeInsets.symmetric(vertical: 2.h),
                          side: const BorderSide(color: AppTheme.border),
                        ),
                        child: const Text('Previous'),
                      ),
                    ),
                    SizedBox(width: 4.w),
                  ],
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _canProceedToNextStep()
                          ? (_currentStep == _totalSteps - 1
                              ? _createWorkspace
                              : _nextStep)
                          : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.primaryAction,
                        foregroundColor: AppTheme.primaryBackground,
                        padding: EdgeInsets.symmetric(vertical: 2.h),
                      ),
                      child: Text(
                        _currentStep == _totalSteps - 1
                            ? 'Create Workspace'
                            : 'Next',
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                        ),
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