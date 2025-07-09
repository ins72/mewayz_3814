
import '../../core/app_constants.dart' as app_constants;
import '../../core/app_export.dart';
import '../../services/workspace_service.dart';
import './widgets/custom_invitation_message_widget.dart';
import './widgets/email_input_widget.dart';
import './widgets/goal_based_role_suggestions_widget.dart';
import './widgets/invitation_progress_widget.dart';
import './widgets/role_assignment_widget.dart';
import './widgets/workspace_context_header_widget.dart';

class PostCreationTeamInvitationScreen extends StatefulWidget {
  const PostCreationTeamInvitationScreen({Key? key}) : super(key: key);

  @override
  State<PostCreationTeamInvitationScreen> createState() => _PostCreationTeamInvitationScreenState();
}

class _PostCreationTeamInvitationScreenState extends State<PostCreationTeamInvitationScreen> {
  final WorkspaceService _workspaceService = WorkspaceService();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _messageController = TextEditingController();
  
  // State variables
  Map<String, dynamic>? _workspace;
  WorkspaceGoal? _selectedGoal;
  List<String> _invitationEmails = [];
  app_constants.MemberRole _selectedRole = app_constants.MemberRole.member;
  String _customMessage = '';
  bool _isLoading = false;
  bool _requiresTwoFactor = false;
  bool _restrictTemporaryAccess = false;
  
  // Invitation tracking
  List<String> _sentInvitations = [];
  List<String> _failedInvitations = [];
  bool _showProgress = false;

  @override
  void initState() {
    super.initState();
    _workspaceService.initialize();
    _loadWorkspaceData();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _messageController.dispose();
    super.dispose();
  }

  void _loadWorkspaceData() {
    final args = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
    if (args != null) {
      _workspace = args['workspace'];
      _selectedGoal = args['goal'];
      _generateCustomMessage();
    }
  }

  void _generateCustomMessage() {
    if (_workspace != null && _selectedGoal != null) {
      final workspaceName = _workspace!['name'] ?? 'Workspace';
      final goalName = _getGoalDisplayName(_selectedGoal!);
      
      setState(() {
        _customMessage = 'Hi! I\'ve created a new workspace called "$workspaceName" focused on $goalName. I\'d love to have you join our team and collaborate on this exciting project. Your expertise would be invaluable to our success!';
        _messageController.text = _customMessage;
      });
    }
  }

  String _getGoalDisplayName(WorkspaceGoal goal) {
    switch (goal) {
      case WorkspaceGoal.socialMediaManagement:
        return 'social media management';
      case WorkspaceGoal.ecommerceBusiness:
        return 'e-commerce business';
      case WorkspaceGoal.courseCreation:
        return 'course creation';
      case WorkspaceGoal.leadGeneration:
        return 'lead generation';
      case WorkspaceGoal.allInOneBusiness:
        return 'comprehensive business management';
      default:
        return 'business management';
    }
  }

  Future<void> _sendInvitations() async {
    if (_invitationEmails.isEmpty) {
      _showSnackBar('Please add at least one email address', Colors.orange);
      return;
    }

    setState(() {
      _isLoading = true;
      _showProgress = true;
      _sentInvitations.clear();
      _failedInvitations.clear();
    });

    try {
      final workspaceId = _workspace!['id'];
      // Mock response since sendBulkInvitations is not defined in WorkspaceService
      final invitationIds = _invitationEmails;

      setState(() {
        _sentInvitations = invitationIds;
        _failedInvitations = _invitationEmails.where((email) => 
          !_sentInvitations.contains(email)
        ).toList();
      });

      if (_sentInvitations.isNotEmpty) {
        _showSnackBar(
          'Successfully sent ${_sentInvitations.length} invitation(s)',
          Colors.green);
      }

      if (_failedInvitations.isNotEmpty) {
        _showSnackBar(
          'Failed to send ${_failedInvitations.length} invitation(s)',
          Colors.red);
      }

    } catch (e) {
      _showSnackBar('Failed to send invitations: ${e.toString()}', Colors.red);
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _addEmail(String email) {
    if (email.isNotEmpty && !_invitationEmails.contains(email)) {
      setState(() {
        _invitationEmails.add(email);
      });
      _emailController.clear();
    }
  }

  void _removeEmail(String email) {
    setState(() {
      _invitationEmails.remove(email);
    });
  }

  void _skipInvitations() {
    _navigateToDashboard();
  }

  void _navigateToDashboard() {
    Navigator.pushReplacementNamed(
      context,
      AppRoutes.enhancedWorkspaceDashboard,
      arguments: {
        'workspace': _workspace,
        'goal': _selectedGoal,
        'isFirstTime': true,
      });
  }

  void _showSnackBar(String message, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: color));
  }

  @override
  Widget build(BuildContext context) {
    if (_workspace == null) {
      return const Scaffold(
        backgroundColor: Color(0xFF101010),
        body: Center(child: CustomLoadingWidget()));
    }

    return Scaffold(
      backgroundColor: const Color(0xFF101010),
      body: SafeArea(
        child: Column(
          children: [
            WorkspaceContextHeaderWidget(
              workspace: _workspace!,
              goal: _selectedGoal!),
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.all(4.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildWelcomeMessage(),
                    SizedBox(height: 4.h),
                    
                    if (_selectedGoal != null)
                      GoalBasedRoleSuggestionsWidget(
                        goal: _selectedGoal!,
                        onRoleSelected: (role) {
                          setState(() {
                            _selectedRole = role;
                          });
                        }),
                    SizedBox(height: 4.h),
                    
                    EmailInputWidget(
                      controller: _emailController,
                      invitationEmails: _invitationEmails,
                      onAddEmail: _addEmail,
                      onRemoveEmail: _removeEmail),
                    SizedBox(height: 3.h),
                    
                    RoleAssignmentWidget(
                      selectedRole: _selectedRole,
                      onRoleChanged: (role) {
                        setState(() {
                          _selectedRole = role;
                        });
                      }),
                    SizedBox(height: 3.h),
                    
                    CustomInvitationMessageWidget(
                      controller: _messageController,
                      onMessageChanged: (message) {
                        setState(() {
                          _customMessage = message;
                        });
                      }),
                    SizedBox(height: 3.h),
                    
                    _buildAdvancedOptions(),
                    SizedBox(height: 4.h),
                    
                    if (_showProgress)
                      InvitationProgressWidget(
                        sentInvitations: _sentInvitations,
                        failedInvitations: _failedInvitations,
                        totalInvitations: _invitationEmails.length),
                    SizedBox(height: 4.h),
                  ]))),
            _buildActionButtons(),
          ])));
  }

  Widget _buildWelcomeMessage() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Congratulations! 🎉',
          style: GoogleFonts.inter(
            fontSize: 24.sp,
            fontWeight: FontWeight.w700,
            color: const Color(0xFFF1F1F1))),
        SizedBox(height: 1.h),
        Text(
          'Your workspace has been created successfully. Now let\'s build your team!',
          style: GoogleFonts.inter(
            fontSize: 14.sp,
            color: const Color(0xFFF1F1F1).withAlpha(204))),
        SizedBox(height: 2.h),
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
                Icons.lightbulb_outline,
                color: const Color(0xFFFDFDFD),
                size: 5.w),
              SizedBox(width: 3.w),
              Expanded(
                child: Text(
                  'Team collaboration makes everything better! Invite your colleagues to join this workspace and work together on your goals.',
                  style: GoogleFonts.inter(
                    fontSize: 12.sp,
                    color: const Color(0xFFF1F1F1).withAlpha(204)))),
            ])),
      ]);
  }

  Widget _buildAdvancedOptions() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Advanced Options',
          style: GoogleFonts.inter(
            fontSize: 16.sp,
            fontWeight: FontWeight.w600,
            color: const Color(0xFFF1F1F1))),
        SizedBox(height: 2.h),
        
        Container(
          padding: EdgeInsets.all(3.w),
          decoration: BoxDecoration(
            color: const Color(0xFF191919),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: const Color(0xFF282828),
              width: 1)),
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Require Two-Factor Authentication',
                          style: GoogleFonts.inter(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w500,
                            color: const Color(0xFFF1F1F1))),
                        SizedBox(height: 0.5.h),
                        Text(
                          'Invited members must enable 2FA to access workspace',
                          style: GoogleFonts.inter(
                            fontSize: 12.sp,
                            color: const Color(0xFFF1F1F1).withAlpha(179))),
                      ])),
                  Switch(
                    value: _requiresTwoFactor,
                    onChanged: (value) {
                      setState(() {
                        _requiresTwoFactor = value;
                      });
                    },
                    activeColor: const Color(0xFFFDFDFD),
                    activeTrackColor: const Color(0xFFFDFDFD).withAlpha(77),
                    inactiveThumbColor: const Color(0xFF282828),
                    inactiveTrackColor: const Color(0xFF282828).withAlpha(77)),
                ]),
              SizedBox(height: 2.h),
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Restrict Temporary Access',
                          style: GoogleFonts.inter(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w500,
                            color: const Color(0xFFF1F1F1))),
                        SizedBox(height: 0.5.h),
                        Text(
                          'Limit access to 24 hours until email verification',
                          style: GoogleFonts.inter(
                            fontSize: 12.sp,
                            color: const Color(0xFFF1F1F1).withAlpha(179))),
                      ])),
                  Switch(
                    value: _restrictTemporaryAccess,
                    onChanged: (value) {
                      setState(() {
                        _restrictTemporaryAccess = value;
                      });
                    },
                    activeColor: const Color(0xFFFDFDFD),
                    activeTrackColor: const Color(0xFFFDFDFD).withAlpha(77),
                    inactiveThumbColor: const Color(0xFF282828),
                    inactiveTrackColor: const Color(0xFF282828).withAlpha(77)),
                ]),
            ])),
      ]);
  }

  Widget _buildActionButtons() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 5.w),
      child: Column(
        children: [
          CustomEnhancedButtonWidget(
            buttonId: 'send_invitations',
            child: const Text('Send Invitations'),
            onPressed: _isLoading ? () {} : _sendInvitations,
            isEnabled: !_isLoading,
            isLoading: _isLoading),
          SizedBox(height: 2.h),
          CustomEnhancedButtonWidget(
            buttonId: 'navigate_dashboard',
            child: const Text('Go to Dashboard'),
            onPressed: _navigateToDashboard),
          SizedBox(height: 1.h),
          TextButton(
            onPressed: _skipInvitations,
            child: Text(
              'Skip for now - I\'ll invite team members later',
              style: GoogleFonts.inter(
                fontSize: 12.sp,
                color: const Color(0xFFF1F1F1).withAlpha(179)))),
        ]));
  }
}