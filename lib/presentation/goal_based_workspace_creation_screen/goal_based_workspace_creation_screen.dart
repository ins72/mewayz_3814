import '../../core/app_export.dart';
import '../../services/workspace_service.dart';
import './widgets/goal_selection_card_widget.dart';
import './widgets/logo_upload_widget.dart';
import './widgets/privacy_settings_widget.dart';
import './widgets/progress_step_widget.dart';
import './widgets/workspace_settings_widget.dart';

// Define WorkspaceGoal enum
enum WorkspaceGoal {
  socialMediaManagement,
  ecommerceBusiness,
  courseCreation,
  leadGeneration,
  allInOneBusiness,
}

class GoalBasedWorkspaceCreationScreen extends StatefulWidget {
  const GoalBasedWorkspaceCreationScreen({Key? key}) : super(key: key);

  @override
  State<GoalBasedWorkspaceCreationScreen> createState() => _GoalBasedWorkspaceCreationScreenState();
}

class _GoalBasedWorkspaceCreationScreenState extends State<GoalBasedWorkspaceCreationScreen> {
  final PageController _pageController = PageController();
  final WorkspaceService _workspaceService = WorkspaceService();
  
  // Form controllers
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  
  // State variables
  int _currentStep = 0;
  WorkspaceGoal? _selectedGoal;
  String? _logoUrl;
  String _privacyLevel = 'private';
  Map<String, bool> _defaultPermissions = {
    'can_view': true,
    'can_edit': false,
    'can_invite': false,
  };
  Map<String, dynamic> _billingPreferences = {};
  
  bool _isLoading = false;
  bool _canProceed = false;
  
  @override
  void initState() {
    super.initState();
    _workspaceService.initialize();
    _updateCanProceed();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _pageController.dispose();
    super.dispose();
  }

  void _updateCanProceed() {
    setState(() {
      switch (_currentStep) {
        case 0:
          _canProceed = _nameController.text.isNotEmpty && _descriptionController.text.isNotEmpty;
          break;
        case 1:
          _canProceed = _selectedGoal != null;
          break;
        case 2:
          _canProceed = true; // Settings are optional
          break;
        default:
          _canProceed = false;
      }
    });
  }

  Future<void> _nextStep() async {
    if (!_canProceed) return;
    
    if (_currentStep < 2) {
      setState(() {
        _currentStep++;
      });
      await _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut);
      _updateCanProceed();
    } else {
      await _createWorkspace();
    }
  }

  Future<void> _previousStep() async {
    if (_currentStep > 0) {
      setState(() {
        _currentStep--;
      });
      await _pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut);
      _updateCanProceed();
    }
  }

  Future<void> _createWorkspace() async {
    if (_selectedGoal == null) return;
    
    setState(() {
      _isLoading = true;
    });

    try {
      final workspace = await _workspaceService.createWorkspace(
        name: _nameController.text,
        description: _descriptionController.text,
        goal: _selectedGoal!.toString());

      if (workspace != null) {
        // Navigate to team invitation screen
        if (mounted) {
          Navigator.pushReplacementNamed(
            context,
            'team_invitation_screen',
            arguments: {
              'workspace': workspace,
              'goal': _selectedGoal,
            });
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to create workspace: ${e.toString()}'),
            backgroundColor: Colors.red));
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF101010),
      body: SafeArea(
        child: _isLoading
            ? const Center(child: CustomLoadingWidget())
            : Column(
                children: [
                  _buildHeader(),
                  _buildProgressIndicator(),
                  Expanded(
                    child: PageView(
                      controller: _pageController,
                      physics: const NeverScrollableScrollPhysics(),
                      children: [
                        _buildStep1(),
                        _buildStep2(),
                        _buildStep3(),
                      ])),
                  _buildNavigationButtons(),
                ])));
  }

  Widget _buildHeader() {
    return Container(
      padding: EdgeInsets.all(4.w),
      child: Row(
        children: [
          IconButton(
            onPressed: _currentStep > 0 ? _previousStep : () => Navigator.pop(context),
            icon: const Icon(Icons.arrow_back, color: Color(0xFFF1F1F1))),
          SizedBox(width: 2.w),
          Text(
            'Create Workspace',
            style: GoogleFonts.inter(
              fontSize: 20.sp,
              fontWeight: FontWeight.w600,
              color: const Color(0xFFF1F1F1))),
        ]));
  }

  Widget _buildProgressIndicator() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ProgressStepWidget(
            stepNumber: 1,
            title: 'Details',
            isActive: _currentStep == 0,
            isCompleted: _currentStep > 0),
          SizedBox(width: 8.w),
          ProgressStepWidget(
            stepNumber: 2,
            title: 'Goal',
            isActive: _currentStep == 1,
            isCompleted: _currentStep > 1),
          SizedBox(width: 8.w),
          ProgressStepWidget(
            stepNumber: 3,
            title: 'Settings',
            isActive: _currentStep == 2,
            isCompleted: false),
        ]));
  }

  Widget _buildStep1() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(4.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Step 1 of 3',
            style: GoogleFonts.inter(
              fontSize: 12.sp,
              color: const Color(0xFFF1F1F1).withAlpha(179))),
          SizedBox(height: 1.h),
          Text(
            'Workspace Details',
            style: GoogleFonts.inter(
              fontSize: 24.sp,
              fontWeight: FontWeight.w700,
              color: const Color(0xFFF1F1F1))),
          SizedBox(height: 1.h),
          Text(
            'Set up your workspace with basic information and branding.',
            style: GoogleFonts.inter(
              fontSize: 14.sp,
              color: const Color(0xFFF1F1F1).withAlpha(204))),
          SizedBox(height: 4.h),
          
          // Workspace Name
          CustomFormFieldWidget(
            controller: _nameController,

            onChanged: (value) => _updateCanProceed()),
          SizedBox(height: 3.h),
          
          // Description
          CustomFormFieldWidget(
            controller: _descriptionController,

            maxLines: 3,
            onChanged: (value) => _updateCanProceed()),
          SizedBox(height: 3.h),
          
          // Logo Upload
          LogoUploadWidget(
            onLogoChanged: (url) {
              setState(() {
                _logoUrl = url;
              });
            }),
        ]));
  }

  Widget _buildStep2() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(4.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Step 2 of 3',
            style: GoogleFonts.inter(
              fontSize: 12.sp,
              color: const Color(0xFFF1F1F1).withAlpha(179))),
          SizedBox(height: 1.h),
          Text(
            'Choose Your Goal',
            style: GoogleFonts.inter(
              fontSize: 24.sp,
              fontWeight: FontWeight.w700,
              color: const Color(0xFFF1F1F1))),
          SizedBox(height: 1.h),
          Text(
            'Select your primary workspace objective to unlock relevant features.',
            style: GoogleFonts.inter(
              fontSize: 14.sp,
              color: const Color(0xFFF1F1F1).withAlpha(204))),
          SizedBox(height: 4.h),
          
          // Goal Selection Cards
          GoalSelectionCardWidget(
            title: 'Social Media Management',
            description: 'Instagram growth, content scheduling, analytics',
            icon: Icons.campaign,
            features: ['Content Calendar', 'Analytics', 'Scheduling', 'Hashtag Research'],
            recommendedTeamSize: '2-5 members',
            isSelected: _selectedGoal == WorkspaceGoal.socialMediaManagement,
            onTap: () {
              setState(() {
                _selectedGoal = WorkspaceGoal.socialMediaManagement;
              });
              _updateCanProceed();
            }),
          SizedBox(height: 2.h),
          
          GoalSelectionCardWidget(
            title: 'E-commerce Business',
            description: 'Product sales, inventory management, customer support',
            icon: Icons.store,
            features: ['Product Catalog', 'Inventory', 'Orders', 'Analytics'],
            recommendedTeamSize: '3-8 members',
            isSelected: _selectedGoal == WorkspaceGoal.ecommerceBusiness,
            onTap: () {
              setState(() {
                _selectedGoal = WorkspaceGoal.ecommerceBusiness;
              });
              _updateCanProceed();
            }),
          SizedBox(height: 2.h),
          
          GoalSelectionCardWidget(
            title: 'Course Creation',
            description: 'Online education, student management, content delivery',
            icon: Icons.school,
            features: ['Course Builder', 'Student Tracking', 'Assessments', 'Certificates'],
            recommendedTeamSize: '1-4 members',
            isSelected: _selectedGoal == WorkspaceGoal.courseCreation,
            onTap: () {
              setState(() {
                _selectedGoal = WorkspaceGoal.courseCreation;
              });
              _updateCanProceed();
            }),
          SizedBox(height: 2.h),
          
          GoalSelectionCardWidget(
            title: 'Lead Generation',
            description: 'CRM management, email marketing, conversion tracking',
            icon: Icons.trending_up,
            features: ['CRM System', 'Email Marketing', 'Lead Scoring', 'Analytics'],
            recommendedTeamSize: '2-6 members',
            isSelected: _selectedGoal == WorkspaceGoal.leadGeneration,
            onTap: () {
              setState(() {
                _selectedGoal = WorkspaceGoal.leadGeneration;
              });
              _updateCanProceed();
            }),
          SizedBox(height: 2.h),
          
          GoalSelectionCardWidget(
            title: 'All-in-One Business',
            description: 'Comprehensive features for complete business management',
            icon: Icons.business_center,
            features: ['Social Media', 'E-commerce', 'CRM', 'Analytics', 'More'],
            recommendedTeamSize: '5-15 members',
            isSelected: _selectedGoal == WorkspaceGoal.allInOneBusiness,
            onTap: () {
              setState(() {
                _selectedGoal = WorkspaceGoal.allInOneBusiness;
              });
              _updateCanProceed();
            }),
        ]));
  }

  Widget _buildStep3() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(4.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Step 3 of 3',
            style: GoogleFonts.inter(
              fontSize: 12.sp,
              color: const Color(0xFFF1F1F1).withAlpha(179))),
          SizedBox(height: 1.h),
          Text(
            'Workspace Settings',
            style: GoogleFonts.inter(
              fontSize: 24.sp,
              fontWeight: FontWeight.w700,
              color: const Color(0xFFF1F1F1))),
          SizedBox(height: 1.h),
          Text(
            'Configure privacy, permissions, and billing preferences.',
            style: GoogleFonts.inter(
              fontSize: 14.sp,
              color: const Color(0xFFF1F1F1).withAlpha(204))),
          SizedBox(height: 4.h),
          
          // Privacy Settings
          PrivacySettingsWidget(
            privacyLevel: _privacyLevel,
            onPrivacyChanged: (value) {
              setState(() {
                _privacyLevel = value;
              });
            }),
          SizedBox(height: 3.h),
          
          // Workspace Settings
          WorkspaceSettingsWidget(
            defaultPermissions: _defaultPermissions,
            onPermissionsChanged: (permissions) {
              setState(() {
                _defaultPermissions = permissions;
              });
            },
            onBillingPreferencesChanged: (preferences) {
              setState(() {
                _billingPreferences = preferences;
              });
            }),
        ]));
  }

  Widget _buildNavigationButtons() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 5.w),
      child: Row(
        children: [
          if (_currentStep > 0)
            Expanded(
              child: CustomEnhancedButtonWidget(
                buttonId: 'prev_button',
                child: Text('Back'),
                onPressed: _previousStep)),
          if (_currentStep > 0) SizedBox(width: 2.w),
          Expanded(
            child: CustomEnhancedButtonWidget(
              buttonId: 'next_button',
              child: Text(_currentStep < 2 ? 'Next' : 'Create'),
              onPressed: _canProceed ? _nextStep : () {},
              isEnabled: _canProceed,
              isLoading: _isLoading)),
        ]));
  }
}