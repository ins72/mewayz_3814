
import '../../core/app_export.dart';
import './widgets/custom_goal_input_widget.dart';
import './widgets/goal_option_card_widget.dart';
import './widgets/goal_selection_header_widget.dart';

class GoalSelectionScreen extends StatefulWidget {
  const GoalSelectionScreen({Key? key}) : super(key: key);

  @override
  State<GoalSelectionScreen> createState() => _GoalSelectionScreenState();
}

class _GoalSelectionScreenState extends State<GoalSelectionScreen>
    with TickerProviderStateMixin {
  late AnimationController _fadeAnimationController;
  late Animation<double> _fadeAnimation;
  
  final OnboardingService _onboardingService = OnboardingService();
  final TextEditingController _customGoalController = TextEditingController();
  
  Set<OnboardingGoal> _selectedGoals = {};
  String? _customGoalDescription;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _setupAnimations();
    _initializeService();
  }

  void _setupAnimations() {
    _fadeAnimationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _fadeAnimationController,
      curve: Curves.easeInOut,
    ));

    _fadeAnimationController.forward();
  }

  Future<void> _initializeService() async {
    try {
      await _onboardingService.initialize();
    } catch (e) {
      _showErrorMessage('Failed to initialize service: $e');
    }
  }

  void _toggleGoal(OnboardingGoal goal) {
    setState(() {
      if (_selectedGoals.contains(goal)) {
        _selectedGoals.remove(goal);
        if (goal == OnboardingGoal.other) {
          _customGoalDescription = null;
          _customGoalController.clear();
        }
      } else {
        _selectedGoals.add(goal);
      }
    });
    
    HapticFeedback.lightImpact();
  }

  void _updateCustomGoal(String value) {
    setState(() {
      _customGoalDescription = value.trim().isNotEmpty ? value.trim() : null;
    });
  }

  Future<void> _continueToSetup() async {
    if (_selectedGoals.isEmpty) {
      _showErrorMessage('Please select at least one goal to continue');
      return;
    }

    if (_selectedGoals.contains(OnboardingGoal.other) && 
        (_customGoalDescription?.isEmpty ?? true)) {
      _showErrorMessage('Please describe your custom goal');
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      await _onboardingService.saveUserGoals(
        _selectedGoals.toList(),
        customGoalDescription: _customGoalDescription,
      );
      
      HapticFeedback.mediumImpact();
      Navigator.pushReplacementNamed(context, AppRoutes.setupProgress);
      
    } catch (e) {
      _showErrorMessage('Failed to save goals: $e');
    }
  }

  void _showErrorMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red[400],
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  void dispose() {
    _fadeAnimationController.dispose();
    _customGoalController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
        systemNavigationBarColor: AppTheme.primaryBackground,
        systemNavigationBarIconBrightness: Brightness.light,
      ),
      child: Scaffold(
        backgroundColor: AppTheme.primaryBackground,
        body: SafeArea(
          child: AnimatedBuilder(
            animation: _fadeAnimation,
            builder: (context, child) {
              return Opacity(
                opacity: _fadeAnimation.value,
                child: Column(
                  children: [
                    // Header
                    GoalSelectionHeaderWidget(),
                    
                    // Goal options
                    Expanded(
                      child: SingleChildScrollView(
                        padding: EdgeInsets.all(4.w),
                        child: Column(
                          children: [
                            // Goal grid
                            _buildGoalGrid(),
                            
                            // Custom goal input
                            if (_selectedGoals.contains(OnboardingGoal.other))
                              ...[
                                SizedBox(height: 3.h),
                                CustomGoalInputWidget(
                                  controller: _customGoalController,
                                  onChanged: _updateCustomGoal,
                                ),
                              ],
                            
                            SizedBox(height: 4.h),
                            
                            // Continue button
                            _buildContinueButton(),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildGoalGrid() {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 3.w,
        mainAxisSpacing: 2.h,
        childAspectRatio: 0.85,
      ),
      itemCount: OnboardingGoal.values.length,
      itemBuilder: (context, index) {
        final goal = OnboardingGoal.values[index];
        final isSelected = _selectedGoals.contains(goal);
        
        return GoalOptionCardWidget(
          goal: goal,
          isSelected: isSelected,
          onTap: () => _toggleGoal(goal),
          animationDelay: Duration(milliseconds: 100 * index),
        );
      },
    );
  }

  Widget _buildContinueButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: _selectedGoals.isEmpty || _isLoading ? null : _continueToSetup,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppTheme.primaryAction,
          foregroundColor: Color(0xFF141414),
          disabledBackgroundColor: AppTheme.surface,
          disabledForegroundColor: AppTheme.secondaryText,
          padding: EdgeInsets.symmetric(vertical: 2.h),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(3.w),
          ),
          elevation: _selectedGoals.isEmpty ? 0 : 2,
        ),
        child: _isLoading
            ? SizedBox(
                height: 20,
                width: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    Color(0xFF141414),
                  ),
                ),
              )
            : Text(
                'Continue to Setup',
                style: AppTheme.darkTheme.textTheme.labelLarge?.copyWith(
                  color: Color(0xFF141414),
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
      ),
    );
  }
}