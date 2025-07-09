
import '../../../core/app_export.dart';

class SkeletonCardWidget extends StatefulWidget {
  const SkeletonCardWidget({Key? key}) : super(key: key);

  @override
  State<SkeletonCardWidget> createState() => _SkeletonCardWidgetState();
}

class _SkeletonCardWidgetState extends State<SkeletonCardWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: Duration(milliseconds: 1500),
      vsync: this,
    );
    _animation = Tween<double>(begin: 0.3, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
    _animationController.repeat(reverse: true);
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Container(
          margin: EdgeInsets.only(bottom: 2.h),
          padding: EdgeInsets.all(4.w),
          decoration: BoxDecoration(
            color: AppTheme.surface,
            borderRadius: BorderRadius.circular(3.w),
            border: Border.all(color: AppTheme.border.withValues(alpha: 0.3)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSkeletonProfileHeader(),
              SizedBox(height: 2.h),
              _buildSkeletonStats(),
              SizedBox(height: 2.h),
              _buildSkeletonBio(),
              SizedBox(height: 3.h),
              _buildSkeletonButtons(),
            ],
          ),
        );
      },
    );
  }

  Widget _buildSkeletonProfileHeader() {
    return Row(
      children: [
        _buildSkeletonContainer(15.w, 15.w, isCircle: true),
        SizedBox(width: 3.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSkeletonContainer(30.w, 2.h),
              SizedBox(height: 1.h),
              _buildSkeletonContainer(20.w, 1.5.h),
            ],
          ),
        ),
        _buildSkeletonContainer(15.w, 3.h),
      ],
    );
  }

  Widget _buildSkeletonStats() {
    return Row(
      children: [
        _buildSkeletonStatItem(),
        SizedBox(width: 6.w),
        _buildSkeletonStatItem(),
        SizedBox(width: 6.w),
        _buildSkeletonStatItem(),
        Spacer(),
        _buildSkeletonContainer(15.w, 4.h),
      ],
    );
  }

  Widget _buildSkeletonStatItem() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSkeletonContainer(8.w, 1.5.h),
        SizedBox(height: 0.5.h),
        _buildSkeletonContainer(12.w, 1.h),
      ],
    );
  }

  Widget _buildSkeletonBio() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSkeletonContainer(90.w, 1.5.h),
        SizedBox(height: 0.5.h),
        _buildSkeletonContainer(70.w, 1.5.h),
      ],
    );
  }

  Widget _buildSkeletonButtons() {
    return Row(
      children: [
        Expanded(child: _buildSkeletonContainer(double.infinity, 5.h)),
        SizedBox(width: 3.w),
        Expanded(child: _buildSkeletonContainer(double.infinity, 5.h)),
        SizedBox(width: 3.w),
        Expanded(child: _buildSkeletonContainer(double.infinity, 5.h)),
      ],
    );
  }

  Widget _buildSkeletonContainer(double width, double height,
      {bool isCircle = false}) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: AppTheme.border.withValues(alpha: _animation.value * 0.5),
        borderRadius: isCircle
            ? BorderRadius.circular(width / 2)
            : BorderRadius.circular(2.w),
      ),
    );
  }
}