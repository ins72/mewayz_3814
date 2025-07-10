
import '../../core/app_export.dart';
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
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _messageController = TextEditingController();
  
  MemberRole _selectedRole = MemberRole.contributor;
  
  final List<String> _invitedEmails = [];
  final List<String> _sentInvitations = [];
  final List<String> _failedInvitations = [];
  
  @override
  void dispose() {
    _emailController.dispose();
    _messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
      appBar: AppBar(
        
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: AppTheme.primaryText),
          onPressed: () => Navigator.pop(context)),
        title: Text(
          'Invite Team Member',
          style: AppTheme.darkTheme.textTheme.headlineSmall?.copyWith(
            color: AppTheme.primaryText,
            fontWeight: FontWeight.w600))),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(5.w),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Workspace Context Header
              WorkspaceContextHeaderWidget(
                workspaceName: 'Workspace Name',
                workspaceDescription: 'Description',
                teamSize: '5',
                onEditWorkspace: () {},
                goal: WorkspaceGoal.socialMediaManagement),
              
              SizedBox(height: 6.w),
              
              // Email Input
              EmailInputWidget(
                controller: _emailController,
                invitationEmails: _invitedEmails,
                onAddEmail: (email) {
                  setState(() {
                    _invitedEmails.add(email);
                  });
                },
                onRemoveEmail: (email) {
                  setState(() {
                    _invitedEmails.remove(email);
                  });
                }),
              
              SizedBox(height: 6.w),
              
              // Role Assignment
              RoleAssignmentWidget(
                selectedRole: _selectedRole,
                onRoleChanged: (role) {
                  setState(() {
                    _selectedRole = role;
                  });
                }),
              
              SizedBox(height: 6.w),
              
              // Goal-Based Role Suggestions
              GoalBasedRoleSuggestionsWidget(
                goal: WorkspaceGoal.socialMediaManagement,
                onRoleSelected: (role) {
                  setState(() {
                    _selectedRole = role;
                  });
                }),
              
              SizedBox(height: 6.w),
              
              // Custom Invitation Message
              CustomInvitationMessageWidget(
                controller: _messageController,
                onMessageChanged: (message) {
                  // Handle message change
                }),
              
              SizedBox(height: 6.w),
              
              // Invitation Progress
              InvitationProgressWidget(
                totalInvitations: _invitedEmails.length,
                sentInvitations: _sentInvitations,
                failedInvitations: _failedInvitations),
              
              SizedBox(height: 8.w),
              
              // Send Invitation Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _invitedEmails.isNotEmpty ? _sendInvitations : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.accent,
                    
                    padding: EdgeInsets.symmetric(vertical: 4.w),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(2.w))),
                  child: Text(
                    'Send ${_invitedEmails.length} Invitation${_invitedEmails.length == 1 ? '' : 's'}',
                    style: AppTheme.darkTheme.textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.w600)))),
            ]))));
  }

  void _sendInvitations() {
    if (_formKey.currentState?.validate() ?? false) {
      // Show loading indicator
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => Center(
          child: CircularProgressIndicator(
            color: AppTheme.accent)));

      // Simulate API call
      Future.delayed(Duration(seconds: 2), () {
        Navigator.pop(context); // Close loading dialog
        
        // Update invitation status
        setState(() {
          _sentInvitations.addAll(_invitedEmails);
          _failedInvitations.clear();
        });
        
        // Show success message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Invitations sent successfully!'),
            backgroundColor: Colors.green));
        
        // Go back to previous screen
        Navigator.pop(context);
      });
    }
  }
}