import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../routes/app_routes.dart';

class EnhancedQuickPostFabWidget extends StatefulWidget {
  const EnhancedQuickPostFabWidget({Key? key}) : super(key: key);

  @override
  State<EnhancedQuickPostFabWidget> createState() => _EnhancedQuickPostFabWidgetState();
}

class _EnhancedQuickPostFabWidgetState extends State<EnhancedQuickPostFabWidget> 
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _rotationAnimation;
  bool _isExpanded = false;

  final List<Map<String, dynamic>> _quickPostOptions = [
{ 'title': 'Story',
'icon': Icons.auto_stories,
'color': const Color(0xFFE1306C),
'route': AppRoutes.home,
},
{ 'title': 'Video',
'icon': Icons.videocam,
'color': const Color(0xFF1877F2),
'route': AppRoutes.home,
},
{ 'title': 'Photo',
'icon': Icons.photo_camera,
'color': const Color(0xFF34C759),
'route': AppRoutes.home,
},
{ 'title': 'Text',
'icon': Icons.text_fields,
'color': const Color(0xFFFF9500),
'route': AppRoutes.home,
},
{ 'title': 'Schedule',
'icon': Icons.schedule,
'color': const Color(0xFF5856D6),
'route': AppRoutes.home,
},
{ 'title': 'Instagram Post',
'icon': Icons.camera_alt,
'route': AppRoutes.multiPlatformPostingScreen,
'color': Colors.pink,
},
{ 'title': 'Twitter Post',
'icon': Icons.message,
'route': AppRoutes.multiPlatformPostingScreen,
'color': Colors.blue,
},
{ 'title': 'LinkedIn Post',
'icon': Icons.work,
'route': AppRoutes.multiPlatformPostingScreen,
'color': Colors.blueAccent,
},
{ 'title': 'Facebook Post',
'icon': Icons.facebook,
'route': AppRoutes.multiPlatformPostingScreen,
'color': Colors.indigo,
},
{ 'title': 'Schedule Post',
'icon': Icons.schedule,
'route': AppRoutes.socialMediaScheduler,
'color': Colors.orange,
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
        
        // Quick Post Options
        ..._quickPostOptions.asMap().entries.map((entry) {
          final index = entry.key;
          final option = entry.value;
          
          return AnimatedBuilder(
            animation: _scaleAnimation,
            builder: (context, child) {
              final double offset = (index + 1) * 70.0;
              return Positioned(
                bottom: offset * _scaleAnimation.value,
                right: 0,
                child: Transform.scale(
                  scale: _scaleAnimation.value,
                  child: _buildQuickPostOption(
                    title: option['title'],
                    icon: option['icon'],
                    color: option['color'],
                    route: option['route'],
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

  Widget _buildQuickPostOption({
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