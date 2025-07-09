import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../routes/app_routes.dart';

class EnhancedFloatingActionButtonWidget extends StatefulWidget {
  const EnhancedFloatingActionButtonWidget({Key? key}) : super(key: key);

  @override
  State<EnhancedFloatingActionButtonWidget> createState() => _EnhancedFloatingActionButtonWidgetState();
}

class _EnhancedFloatingActionButtonWidgetState extends State<EnhancedFloatingActionButtonWidget> 
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _rotationAnimation;
  bool _isExpanded = false;

  final List<Map<String, dynamic>> _quickActions = [
{ 'title': 'New Post',
'icon': Icons.add_photo_alternate,
'color': const Color(0xFF007AFF),
'route': AppRoutes.multiPlatformPostingScreen,
},
{ 'title': 'Add Lead',
'icon': Icons.person_add,
'color': const Color(0xFF34C759),
'route': AppRoutes.crmContactManagement,
},
{ 'title': 'Create QR',
'icon': Icons.qr_code,
'color': const Color(0xFF8E8E93),
'route': AppRoutes.qrCodeGeneratorScreen,
},
{ 'title': 'Schedule',
'icon': Icons.schedule,
'color': const Color(0xFFFF9500),
'route': AppRoutes.socialMediaScheduler,
},
];

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    
    _scaleAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
    
    _rotationAnimation = Tween<double>(
      begin: 0.0,
      end: 0.125,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _toggleMenu() {
    setState(() {
      _isExpanded = !_isExpanded;
    });
    
    if (_isExpanded) {
      _animationController.forward();
    } else {
      _animationController.reverse();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        // Backdrop
        if (_isExpanded)
          GestureDetector(
            onTap: _toggleMenu,
            child: Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              color: Colors.black.withAlpha(77),
            ),
          ),
        
        // Quick Action Buttons
        ..._quickActions.asMap().entries.map((entry) {
          final index = entry.key;
          final action = entry.value;
          
          return AnimatedBuilder(
            animation: _scaleAnimation,
            builder: (context, child) {
              final double offset = (index + 1) * 70.0;
              return Positioned(
                bottom: offset * _scaleAnimation.value,
                right: 0,
                child: Transform.scale(
                  scale: _scaleAnimation.value,
                  child: _buildQuickActionButton(
                    title: action['title'],
                    icon: action['icon'],
                    color: action['color'],
                    route: action['route'],
                  ),
                ),
              );
            },
          );
        }).toList(),
        
        // Main FAB
        FloatingActionButton(
          onPressed: _toggleMenu,
          backgroundColor: const Color(0xFF007AFF),
          child: AnimatedBuilder(
            animation: _rotationAnimation,
            builder: (context, child) {
              return Transform.rotate(
                angle: _rotationAnimation.value * 2 * 3.14159,
                child: Icon(
                  _isExpanded ? Icons.close : Icons.add,
                  color: Colors.white,
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildQuickActionButton({
    required String title,
    required IconData icon,
    required Color color,
    required String route,
  }) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: const Color(0xFF1C1C1E),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: const Color(0xFF2C2C2E),
              width: 1,
            ),
          ),
          child: Text(
            title,
            style: GoogleFonts.inter(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: Colors.white,
            ),
          ),
        ),
        const SizedBox(width: 8),
        GestureDetector(
          onTap: () {
            _toggleMenu();
            Navigator.pushNamed(context, route);
          },
          child: Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: color.withAlpha(77),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Icon(
              icon,
              color: Colors.white,
              size: 24,
            ),
          ),
        ),
      ],
    );
  }
}