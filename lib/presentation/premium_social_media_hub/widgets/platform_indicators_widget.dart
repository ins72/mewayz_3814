import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class PlatformIndicatorsWidget extends StatefulWidget {
  final List<Map<String, dynamic>> platforms;
  final Function(String) onPlatformSwitch;

  const PlatformIndicatorsWidget({
    Key? key,
    required this.platforms,
    required this.onPlatformSwitch,
  }) : super(key: key);

  @override
  State<PlatformIndicatorsWidget> createState() => _PlatformIndicatorsWidgetState();
}

class _PlatformIndicatorsWidgetState extends State<PlatformIndicatorsWidget> 
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _slideAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _slideAnimation,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(0, -50 * (1 - _slideAnimation.value)),
          child: Opacity(
            opacity: _slideAnimation.value,
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Social Media Hub',
                        style: GoogleFonts.inter(
                          fontSize: 24,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: const Color(0xFF34C759).withAlpha(26),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              width: 6,
                              height: 6,
                              decoration: const BoxDecoration(
                                color: Color(0xFF34C759),
                                shape: BoxShape.circle,
                              ),
                            ),
                            const SizedBox(width: 6),
                            Text(
                              'All Systems Active',
                              style: GoogleFonts.inter(
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                                color: const Color(0xFF34C759),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  
                  // Platform Connection Status
                  SizedBox(
                    height: 80,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: widget.platforms.length,
                      itemBuilder: (context, index) {
                        final platform = widget.platforms[index];
                        return _buildPlatformCard(platform, index);
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildPlatformCard(Map<String, dynamic> platform, int index) {
    final isConnected = platform['isConnected'] as bool;
    final delay = Duration(milliseconds: 100 * index);
    
    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        return Transform.scale(
          scale: _slideAnimation.value,
          child: Container(
            width: 160,
            margin: const EdgeInsets.only(right: 12),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFF191919),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: isConnected 
                    ? (platform['color'] as Color).withAlpha(77)
                    : const Color(0xFF2C2C2E),
                width: 1,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      width: 32,
                      height: 32,
                      decoration: BoxDecoration(
                        color: isConnected 
                            ? (platform['color'] as Color).withAlpha(26)
                            : const Color(0xFF3A3A3C),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(
                        platform['icon'] as IconData,
                        color: isConnected 
                            ? platform['color'] as Color
                            : const Color(0xFF8E8E93),
                        size: 18,
                      ),
                    ),
                    const Spacer(),
                    Container(
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(
                        color: isConnected 
                            ? const Color(0xFF34C759)
                            : const Color(0xFF8E8E93),
                        shape: BoxShape.circle,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  platform['name'] as String,
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
                if (isConnected) ...[
                  Text(
                    '${platform['followers']} • ${platform['engagement']}',
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      color: const Color(0xFF8E8E93),
                    ),
                  ),
                ] else ...[
                  Text(
                    'Not Connected',
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      color: const Color(0xFF8E8E93),
                    ),
                  ),
                ],
              ],
            ),
          ),
        );
      },
    );
  }
}