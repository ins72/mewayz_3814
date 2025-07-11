import '../../core/app_export.dart';
import '../../services/workspace_service.dart';
import './widgets/goal_summary_header_widget.dart';
import './widgets/plan_comparison_widget.dart';

class GoalBasedSubscriptionPricingScreen extends StatefulWidget {
  const GoalBasedSubscriptionPricingScreen({Key? key}) : super(key: key);

  @override
  State<GoalBasedSubscriptionPricingScreen> createState() => _GoalBasedSubscriptionPricingScreenState();
}

class _GoalBasedSubscriptionPricingScreenState extends State<GoalBasedSubscriptionPricingScreen> with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  
  final WorkspaceService _workspaceService = WorkspaceService();
  
  List<String> _selectedGoals = [];
  String _recommendedPlan = 'Launch';
  Map<String, dynamic> _pricingData = {};
  Map<String, dynamic> _featureMatrix = {};
  String _selectedPlan = '';
  bool _isAnnualBilling = false;
  bool _isLoading = false;
  bool _isProcessingPayment = false;
  bool _showComparison = false;
  bool _showCustomBundle = false;
  bool _showSuccess = false;
  Map<String, dynamic> _customBundleData = {};
  String _promoCode = '';
  double _discountAmount = 0.0;

  final Map<String, Map<String, dynamic>> _planData = {
    'Launch': {
      'price_monthly': 5,
      'price_annual': 50,
      'features': [
        'Custom Link-in-Bio',
        'Basic Analytics (Lite)',
        'Community Support',
        'Mobile Optimization',
        'Basic Templates',
      ],
      'goals': ['Launch Your Presence'],
      'color': Color(0xFF10B981),
      'description': 'Perfect for creators starting their online journey',
      'ideal_for': 'New creators starting out',
      'limits': {
        'pages': 1,
        'links': 10,
        'monthly_views': 1000,
      },
    },
    'Growth': {
      'price_monthly': 15,
      'price_annual': 150,
      'features': [
        'Custom Link-in-Bio',
        'Social Post Scheduler (2 platforms)',
        'Standard Analytics',
        'Email Capture & Lead Gen',
        'Traffic Source Breakdown',
        'Priority Support',
        'Advanced Templates',
      ],
      'goals': ['Launch Your Presence', 'Grow Your Reach'],
      'color': Color(0xFF3B82F6),
      'description': 'Ideal for creators ready to scale their audience',
      'ideal_for': 'Creators growing an audience',
      'limits': {
        'pages': 3,
        'links': 50,
        'monthly_views': 10000,
      },
    },
    'Pro': {
      'price_monthly': 35,
      'price_annual': 350,
      'features': [
        'All Growth Features',
        'Product Storefront & Checkout',
        'Full Analytics with Export',
        'Auto-Tagging & Smart Insights',
        'Priority Support + Success Calls',
        'A/B Testing',
        'Custom Domain',
        'White-label Options',
      ],
      'goals': ['Launch Your Presence', 'Grow Your Reach', 'Monetize & Analyze'],
      'color': Color(0xFFF59E0B),
      'description': 'Complete solution for serious creators and businesses',
      'ideal_for': 'Power users and monetizers',
      'limits': {
        'pages': 10,
        'links': 'unlimited',
        'monthly_views': 100000,
      },
    },
  };

  final Map<String, Map<String, dynamic>> _goalData = {
    'Launch Your Presence': {
      'icon': '🚀',
      'description': 'Build and share your link-in-bio, start posting',
      'outcome': 'Online presence established',
      'color': Color(0xFF10B981),
    },
    'Grow Your Reach': {
      'icon': '📈',
      'description': 'Schedule content, track link clicks, build audience',
      'outcome': 'Traffic and follower growth',
      'color': Color(0xFF3B82F6),
    },
    'Monetize & Analyze': {
      'icon': '💰',
      'description': 'Sell digital products, capture leads, export data',
      'outcome': 'Revenue & insights',
      'color': Color(0xFFF59E0B),
    },
  };

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: Duration(milliseconds: 800),
      vsync: this);
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut));
    _slideAnimation = Tween<Offset>(
      begin: Offset(0, 0.3),
      end: Offset.zero).animate(CurvedAnimation(parent: _animationController, curve: Curves.easeOutCubic));
    
    _initializePricingData();
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _initializePricingData() {
    final arguments = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
    _selectedGoals = (arguments?['selectedGoals'] as List<dynamic>?)?.cast<String>() ?? [];
    
    _calculateRecommendedPlan();
    _calculateCustomBundle();
    _buildFeatureMatrix();
    
    setState(() {
      _selectedPlan = _recommendedPlan;
    });
  }

  void _calculateRecommendedPlan() {
    if (_selectedGoals.isEmpty) {
      _recommendedPlan = 'Launch';
      return;
    }
    
    if (_selectedGoals.length == 1 && _selectedGoals.contains('Launch Your Presence')) {
      _recommendedPlan = 'Launch';
    } else if (_selectedGoals.length == 2 && 
               _selectedGoals.contains('Launch Your Presence') && 
               _selectedGoals.contains('Grow Your Reach')) {
      _recommendedPlan = 'Growth';
    } else if (_selectedGoals.length >= 3 || _selectedGoals.contains('Monetize & Analyze')) {
      _recommendedPlan = 'Pro';
    } else {
      _recommendedPlan = 'Growth';
    }
  }

  void _calculateCustomBundle() {
    if (_selectedGoals.length < 2) return;
    
    // Calculate custom bundle for non-linear goal combinations
    if (_selectedGoals.contains('Launch Your Presence') && 
        _selectedGoals.contains('Monetize & Analyze') &&
        !_selectedGoals.contains('Grow Your Reach')) {
      _customBundleData = {
        'name': 'Launch + Monetize Bundle',
        'price_monthly': 25,
        'price_annual': 250,
        'features': [
          'Custom Link-in-Bio',
          'Basic Analytics',
          'Product Storefront & Checkout',
          'Email Capture',
          'Payment Processing',
          'Priority Support',
        ],
        'savings': 15,
        'description': 'Perfect for creators ready to monetize without the growth tools',
      };
      _showCustomBundle = true;
    }
  }

  void _buildFeatureMatrix() {
    _featureMatrix = {
      'Custom Link-in-Bio': {
        'Launch': true,
        'Growth': true,
        'Pro': true,
      },
      'Social Post Scheduler': {
        'Launch': false,
        'Growth': true,
        'Pro': true,
      },
      'Analytics Dashboard': {
        'Launch': 'Lite',
        'Growth': 'Standard',
        'Pro': 'Full w/Export',
      },
      'Product Storefront & Checkout': {
        'Launch': false,
        'Growth': false,
        'Pro': true,
      },
      'Email Capture (Lead Gen)': {
        'Launch': false,
        'Growth': true,
        'Pro': true,
      },
      'Traffic Source Breakdown': {
        'Launch': false,
        'Growth': true,
        'Pro': true,
      },
      'Auto-Tagging / Smart Insights': {
        'Launch': false,
        'Growth': false,
        'Pro': true,
      },
      'Support': {
        'Launch': 'Community',
        'Growth': 'Priority',
        'Pro': 'Priority + Success Calls',
      },
    };
  }

  Future<void> _processPayment(String planName) async {
    setState(() => _isProcessingPayment = true);
    
    try {
      // Simulate payment processing
      await Future.delayed(Duration(seconds: 2));
      
      // Create workspace with selected plan
      final workspaceData = await _workspaceService.createWorkspace(
        name: 'My Workspace',
        description: 'Created from subscription plan',
        goal: _selectedGoals.isNotEmpty ? _selectedGoals.first : 'General');
      
      setState(() {
        _showSuccess = true;
        _isProcessingPayment = false;
      });
      
      // Navigate to dashboard after success animation
      Future.delayed(Duration(seconds: 3), () {
        Navigator.pushNamedAndRemoveUntil(
          context,
          'workspaceDashboard',
          (route) => false,
          arguments: {
            'workspaceId': workspaceData?['id'],
            'selectedGoals': _selectedGoals,
            'plan': planName,
          });
      });
      
    } catch (error) {
      setState(() => _isProcessingPayment = false);
      _showErrorSnackBar('Payment failed: $error');
    }
  }

  void _applyPromoCode(String code) {
    // Mock promo code validation
    if (code.toLowerCase() == 'mewayz2025') {
      setState(() {
        _promoCode = code;
        _discountAmount = _isAnnualBilling ? 50.0 : 5.0;
      });
      _showSuccessSnackBar('Promo code applied! You saved \$${_discountAmount.toStringAsFixed(0)}');
    } else {
      _showErrorSnackBar('Invalid promo code');
    }
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: AppTheme.error,
        behavior: SnackBarBehavior.floating));
  }

  void _showSuccessSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: AppTheme.success,
        behavior: SnackBarBehavior.floating));
  }

  @override
  Widget build(BuildContext context) {
    if (_showSuccess) {
      return Scaffold(
        body: Center(
          child: Text('Subscription Success!'),
        ),
      );
    }

    return Scaffold(
      backgroundColor: Color(0xFF101010),
      body: SafeArea(
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: SlideTransition(
            position: _slideAnimation,
            child: Column(
              children: [
                // Goal Summary Header
                GoalSummaryHeaderWidget(
                  selectedGoals: _selectedGoals,
                  goalData: _goalData,
                  recommendedPlan: _recommendedPlan,
                  onBack: () => Navigator.pop(context)),
                
                // Scrollable content
                Expanded(
                  child: SingleChildScrollView(
                    padding: EdgeInsets.all(16),
                    child: Column(
                      children: [
                        // Pricing Hero Section
                        Container(
                          child: Text('Pricing Hero Section'),
                        ),
                        
                        SizedBox(height: 24),
                        
                        // Annual/Monthly Toggle
                        Container(
                          padding: EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            color: Color(0xFF191919),
                            borderRadius: BorderRadius.circular(12)),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              _buildBillingToggle('Monthly', !_isAnnualBilling),
                              _buildBillingToggle('Annual (Save 20%)', _isAnnualBilling),
                            ])),
                        
                        SizedBox(height: 32),
                        
                        // Pricing Tier Cards
                        Column(
                          children: _planData.entries.map((entry) {
                            final planName = entry.key;
                            final planInfo = entry.value;
                            final isRecommended = planName == _recommendedPlan;
                            final isSelected = planName == _selectedPlan;
                            
                            return Padding(
                              padding: EdgeInsets.only(bottom: 16),
                              child: Card(
                                child: ListTile(
                                  title: Text(planName),
                                  subtitle: Text('Plan details'),
                                  onTap: () {
                                    setState(() => _selectedPlan = planName);
                                  },
                                ),
                              ));
                          }).toList()),
                        
                        // Custom Bundle (if applicable)
                        if (_showCustomBundle) ...[
                          SizedBox(height: 24),
                          Card(
                            child: ListTile(
                              title: Text('Custom Bundle'),
                              onTap: () => _processPayment('Custom Bundle'),
                            ),
                          ),
                        ],
                        
                        SizedBox(height: 32),
                        
                        // Feature Matrix
                        Container(
                          child: Text('Feature Matrix'),
                        ),
                        
                        // Plan Comparison Tool
                        if (_showComparison) ...[
                          SizedBox(height: 24),
                          PlanComparisonWidget(
                            planData: _planData,
                            featureMatrix: _featureMatrix,
                            selectedGoals: _selectedGoals),
                        ],
                        
                        SizedBox(height: 32),
                        
                        // Payment Section
                        Container(
                          child: Text('Payment Section'),
                        ),
                        
                        SizedBox(height: 24),
                        
                        // Free Trial Notice
                        Container(
                          padding: EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Color(0xFF191919),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: AppTheme.success.withAlpha(77))),
                          child: Row(
                            children: [
                              Icon(
                                Icons.schedule,
                                color: AppTheme.success,
                                size: 20),
                              SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      '14-Day Free Trial',
                                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                                        color: AppTheme.success,
                                        fontWeight: FontWeight.w600)),
                                    SizedBox(height: 4),
                                    Text(
                                      'No commitment. Cancel anytime during trial.',
                                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                        color: AppTheme.secondaryText)),
                                  ])),
                            ])),
                        
                        SizedBox(height: 32),
                      ]))),
              ])))));
  }

  Widget _buildBillingToggle(String label, bool isSelected) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _isAnnualBilling = label.contains('Annual');
          _discountAmount = 0.0; // Reset discount when switching billing
          _promoCode = '';
        });
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? AppTheme.accent : Colors.transparent,
          borderRadius: BorderRadius.circular(8)),
        child: Text(
          label,
          style: Theme.of(context).textTheme.labelMedium?.copyWith(
            color: isSelected ? AppTheme.primaryAction : AppTheme.secondaryText,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400))));
  }
}