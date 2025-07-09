
import '../../../core/app_export.dart';

class CalendarWidget extends StatefulWidget {
  final DateTime currentMonth;
  final DateTime selectedDate;
  final Map<String, List<Map<String, dynamic>>> scheduledPosts;
  final bool isWeekView;
  final Function(DateTime) onDateSelected;
  final Function(DateTime) onMonthChanged;

  const CalendarWidget({
    Key? key,
    required this.currentMonth,
    required this.selectedDate,
    required this.scheduledPosts,
    required this.isWeekView,
    required this.onDateSelected,
    required this.onMonthChanged,
  }) : super(key: key);

  @override
  State<CalendarWidget> createState() => _CalendarWidgetState();
}

class _CalendarWidgetState extends State<CalendarWidget> {
  DateTime? _draggedDate;
  String? _draggedPostId;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(2.w),
      child: widget.isWeekView ? _buildWeekView() : _buildMonthView(),
    );
  }

  Widget _buildMonthView() {
    final firstDayOfMonth =
        DateTime(widget.currentMonth.year, widget.currentMonth.month, 1);
    final lastDayOfMonth =
        DateTime(widget.currentMonth.year, widget.currentMonth.month + 1, 0);
    final firstDayOfWeek = firstDayOfMonth.weekday % 7;
    final daysInMonth = lastDayOfMonth.day;

    return Column(
      children: [
        // Weekday headers
        _buildWeekdayHeaders(),
        SizedBox(height: 1.h),

        // Calendar grid
        Expanded(
          child: GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 7,
              childAspectRatio: 1.0,
              crossAxisSpacing: 1,
              mainAxisSpacing: 1,
            ),
            itemCount: 42, // 6 weeks * 7 days
            itemBuilder: (context, index) {
              final dayNumber = index - firstDayOfWeek + 1;

              if (dayNumber <= 0 || dayNumber > daysInMonth) {
                return Container(); // Empty cell
              }

              final date = DateTime(widget.currentMonth.year,
                  widget.currentMonth.month, dayNumber);
              final dateKey =
                  '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
              final posts = widget.scheduledPosts[dateKey] ?? [];

              return _buildCalendarDay(date, posts);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildWeekView() {
    final startOfWeek = widget.selectedDate
        .subtract(Duration(days: widget.selectedDate.weekday % 7));

    return Column(
      children: [
        _buildWeekdayHeaders(),
        SizedBox(height: 1.h),
        Expanded(
          child: Row(
            children: List.generate(7, (index) {
              final date = startOfWeek.add(Duration(days: index));
              final dateKey =
                  '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
              final posts = widget.scheduledPosts[dateKey] ?? [];

              return Expanded(
                child: _buildCalendarDay(date, posts),
              );
            }),
          ),
        ),
      ],
    );
  }

  Widget _buildWeekdayHeaders() {
    const weekdays = ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'];

    return Row(
      children: weekdays
          .map((day) => Expanded(
                child: Center(
                  child: Text(
                    day,
                    style: AppTheme.darkTheme.textTheme.labelMedium?.copyWith(
                      color: AppTheme.secondaryText,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ))
          .toList(),
    );
  }

  Widget _buildCalendarDay(DateTime date, List<Map<String, dynamic>> posts) {
    final isToday = _isSameDay(date, DateTime.now());
    final isSelected = _isSameDay(date, widget.selectedDate);
    final isCurrentMonth = date.month == widget.currentMonth.month;

    return DragTarget<Map<String, dynamic>>(
      onAcceptWithDetails: (details) {
        _handlePostDrop(details.data, date);
      },
      builder: (context, candidateData, rejectedData) {
        return GestureDetector(
          onTap: () {
            HapticFeedback.lightImpact();
            widget.onDateSelected(date);
          },
          child: Container(
            margin: EdgeInsets.all(0.5.w),
            decoration: BoxDecoration(
              color: isSelected
                  ? AppTheme.accent.withValues(alpha: 0.2)
                  : candidateData.isNotEmpty
                      ? AppTheme.accent.withValues(alpha: 0.1)
                      : Colors.transparent,
              borderRadius: BorderRadius.circular(8),
              border: isToday
                  ? Border.all(color: AppTheme.accent, width: 2)
                  : isSelected
                      ? Border.all(color: AppTheme.accent, width: 1)
                      : null,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  date.day.toString(),
                  style: AppTheme.darkTheme.textTheme.bodyMedium?.copyWith(
                    color: isCurrentMonth
                        ? (isToday ? AppTheme.accent : AppTheme.primaryText)
                        : AppTheme.secondaryText,
                    fontWeight: isToday ? FontWeight.w600 : FontWeight.w400,
                  ),
                ),
                SizedBox(height: 0.5.h),
                _buildPostIndicators(posts),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildPostIndicators(List<Map<String, dynamic>> posts) {
    if (posts.isEmpty) return const SizedBox.shrink();

    return Wrap(
      spacing: 1,
      runSpacing: 1,
      children: posts.take(3).map((post) {
        return Draggable<Map<String, dynamic>>(
          data: post,
          feedback: Material(
            color: Colors.transparent,
            child: Container(
              width: 4.w,
              height: 4.w,
              decoration: BoxDecoration(
                color: _getPlatformColor(post['platform']),
                shape: BoxShape.circle,
              ),
            ),
          ),
          childWhenDragging: Container(
            width: 2.w,
            height: 2.w,
            decoration: BoxDecoration(
              color: _getPlatformColor(post['platform']).withValues(alpha: 0.3),
              shape: BoxShape.circle,
            ),
          ),
          child: Container(
            width: 2.w,
            height: 2.w,
            decoration: BoxDecoration(
              color: _getPlatformColor(post['platform']),
              shape: BoxShape.circle,
            ),
          ),
        );
      }).toList(),
    );
  }

  void _handlePostDrop(Map<String, dynamic> post, DateTime newDate) {
    HapticFeedback.mediumImpact();

    // Show confirmation dialog
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppTheme.surface,
        title: Text(
          'Move Post',
          style: AppTheme.darkTheme.textTheme.titleMedium,
        ),
        content: Text(
          'Move this post to ${_formatDate(newDate)}?',
          style: AppTheme.darkTheme.textTheme.bodyMedium,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Cancel',
              style: AppTheme.darkTheme.textTheme.labelMedium?.copyWith(
                color: AppTheme.secondaryText,
              ),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _movePost(post, newDate);
            },
            child: Text(
              'Move',
              style: AppTheme.darkTheme.textTheme.labelMedium?.copyWith(
                color: AppTheme.accent,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _movePost(Map<String, dynamic> post, DateTime newDate) {
    // This would typically update the backend
    // For now, we'll just trigger a haptic feedback
    HapticFeedback.lightImpact();
  }

  Color _getPlatformColor(String platform) {
    switch (platform) {
      case 'instagram':
        return const Color(0xFFE4405F);
      case 'facebook':
        return const Color(0xFF1877F2);
      case 'twitter':
        return const Color(0xFF1DA1F2);
      case 'linkedin':
        return const Color(0xFF0A66C2);
      case 'tiktok':
        return const Color(0xFF000000);
      case 'youtube':
        return const Color(0xFFFF0000);
      default:
        return AppTheme.accent;
    }
  }

  bool _isSameDay(DateTime date1, DateTime date2) {
    return date1.year == date2.year &&
        date1.month == date2.month &&
        date1.day == date2.day;
  }

  String _formatDate(DateTime date) {
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec'
    ];
    return '${months[date.month - 1]} ${date.day}';
  }
}