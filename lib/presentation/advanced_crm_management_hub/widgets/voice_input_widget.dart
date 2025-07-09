import 'package:sizer/sizer.dart';
import 'dart:math' as math;

import '../../../core/app_export.dart';
import '../../../theme/app_theme.dart';

class VoiceInputWidget extends StatefulWidget {
  final Function(String) onVoiceResult;

  const VoiceInputWidget({
    Key? key,
    required this.onVoiceResult,
  }) : super(key: key);

  @override
  State<VoiceInputWidget> createState() => _VoiceInputWidgetState();
}

class _VoiceInputWidgetState extends State<VoiceInputWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _pulseAnimation;
  late Animation<double> _scaleAnimation;
  
  bool _isListening = false;
  String _recognizedText = '';
  double _soundLevel = 0.0;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );
    
    _pulseAnimation = Tween<double>(
      begin: 1.0,
      end: 1.2,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
    
    _scaleAnimation = Tween<double>(
      begin: 0.8,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.elasticOut,
    ));
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _startListening() {
    setState(() {
      _isListening = true;
      _recognizedText = '';
    });
    
    _animationController.repeat(reverse: true);
    
    // Simulate voice recognition
    Future.delayed(const Duration(seconds: 3), () {
      if (_isListening) {
        _stopListening();
        const sampleTexts = [
          'Find high priority contacts',
          'Show me Enterprise deals',
          'Filter by negotiation stage',
          'Search Sarah Johnson',
          'Hot leads this week',
        ];
        final randomText = sampleTexts[math.Random().nextInt(sampleTexts.length)];
        widget.onVoiceResult(randomText);
      }
    });
  }

  void _stopListening() {
    setState(() {
      _isListening = false;
    });
    _animationController.stop();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60.h,
      decoration: BoxDecoration(
        color: AppTheme.surface,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
        border: Border.all(color: AppTheme.border.withAlpha(77)),
      ),
      child: Column(
        children: [
          // Drag handle
          Container(
            margin: EdgeInsets.only(top: 2.h),
            width: 12.w,
            height: 4,
            decoration: BoxDecoration(
              color: AppTheme.border,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          
          // Header
          Padding(
            padding: EdgeInsets.all(4.w),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Voice Input',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.close, color: AppTheme.secondaryText),
                ),
              ],
            ),
          ),
          
          // Voice animation
          Expanded(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  AnimatedBuilder(
                    animation: _animationController,
                    builder: (context, child) {
                      return Container(
                        width: 30.w,
                        height: 30.w,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: _isListening 
                              ? AppTheme.accent.withAlpha(26)
                              : AppTheme.surface,
                          border: Border.all(
                            color: _isListening ? AppTheme.accent : AppTheme.border,
                            width: _isListening ? 2 : 1,
                          ),
                        ),
                        child: Transform.scale(
                          scale: _isListening ? _pulseAnimation.value : 1.0,
                          child: Icon(
                            _isListening ? Icons.mic : Icons.mic_none,
                            size: 12.w,
                            color: _isListening ? AppTheme.accent : AppTheme.secondaryText,
                          ),
                        ),
                      );
                    },
                  ),
                  
                  SizedBox(height: 4.h),
                  
                  Text(
                    _isListening ? 'Listening...' : 'Tap to speak',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: _isListening ? AppTheme.accent : AppTheme.secondaryText,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  
                  SizedBox(height: 1.h),
                  
                  Text(
                    _isListening 
                        ? 'Say something about your CRM search'
                        : 'Try: "Find high priority contacts"',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: AppTheme.secondaryText,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  
                  if (_recognizedText.isNotEmpty) ...[
                    SizedBox(height: 3.h),
                    Container(
                      padding: EdgeInsets.all(4.w),
                      decoration: BoxDecoration(
                        color: AppTheme.accent.withAlpha(26),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: AppTheme.accent.withAlpha(77)),
                      ),
                      child: Text(
                        _recognizedText,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: AppTheme.accent,
                          fontWeight: FontWeight.w500,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
          
          // Action buttons
          Padding(
            padding: EdgeInsets.all(4.w),
            child: Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: _isListening ? _stopListening : _startListening,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _isListening ? AppTheme.error : AppTheme.accent,
                      foregroundColor: AppTheme.primaryAction,
                      minimumSize: Size(0, 6.h),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          _isListening ? Icons.stop : Icons.mic,
                          size: 20,
                        ),
                        SizedBox(width: 2.w),
                        Text(_isListening ? 'Stop Listening' : 'Start Listening'),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}