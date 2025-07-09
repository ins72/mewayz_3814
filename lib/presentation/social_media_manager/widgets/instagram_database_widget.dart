
import '../../../core/app_export.dart';

class InstagramDatabaseWidget extends StatefulWidget {
  const InstagramDatabaseWidget({Key? key}) : super(key: key);

  @override
  State<InstagramDatabaseWidget> createState() =>
      _InstagramDatabaseWidgetState();
}

class _InstagramDatabaseWidgetState extends State<InstagramDatabaseWidget> {
  final TextEditingController _searchController = TextEditingController();
  RangeValues _followerRange = const RangeValues(1000, 50000);
  RangeValues _engagementRange = const RangeValues(1.0, 10.0);
  String _selectedLocation = '';
  List<String> _selectedHashtags = [];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
            color: AppTheme.surface,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppTheme.border)),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(children: [
            Icon(Icons.camera_alt_rounded, color: AppTheme.accent, size: 20),
            SizedBox(width: 8.w),
            Text('Instagram Database',
                style: Theme.of(context).textTheme.titleMedium),
            const Spacer(),
            TextButton(
                onPressed: () =>
                    Navigator.pushNamed(context, 'instagramLeadSearch'),
                child: Text('View All',
                    style: TextStyle(
                        color: AppTheme.accent, fontWeight: FontWeight.w500))),
          ]),
          SizedBox(height: 16.h),
          TextField(
              controller: _searchController,
              style: Theme.of(context).textTheme.bodyMedium,
              decoration: InputDecoration(
                  hintText: 'Search by username or bio keywords...',
                  prefixIcon:
                      Icon(Icons.search_rounded, color: AppTheme.secondaryText),
                  suffixIcon: IconButton(
                      icon: Icon(Icons.tune_rounded,
                          color: AppTheme.secondaryText),
                      onPressed: _showFilters))),
          SizedBox(height: 16.h),
          _buildFilterChips(),
          SizedBox(height: 16.h),
          _buildSearchResults(),
        ]));
  }

  Widget _buildFilterChips() {
    return SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(children: [
          _buildFilterChip(
              'Followers: ${_followerRange.start.toInt()}K - ${_followerRange.end.toInt()}K',
              Icons.people_outline_rounded),
          SizedBox(width: 8.w),
          _buildFilterChip(
              'Engagement: ${_engagementRange.start.toStringAsFixed(1)}% - ${_engagementRange.end.toStringAsFixed(1)}%',
              Icons.favorite_outline_rounded),
          if (_selectedLocation.isNotEmpty) ...[
            SizedBox(width: 8.w),
            _buildFilterChip(
                'Location: $_selectedLocation', Icons.location_on_outlined),
          ],
          if (_selectedHashtags.isNotEmpty) ...[
            SizedBox(width: 8.w),
            _buildFilterChip(
                'Hashtags: ${_selectedHashtags.length}', Icons.tag_rounded),
          ],
        ]));
  }

  Widget _buildFilterChip(String label, IconData icon) {
    return Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
            color: AppTheme.accent.withAlpha(26),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppTheme.accent.withAlpha(77))),
        child: Row(mainAxisSize: MainAxisSize.min, children: [
          Icon(icon, size: 14, color: AppTheme.accent),
          SizedBox(width: 6.w),
          Text(label,
              style: TextStyle(
                  fontSize: 12,
                  color: AppTheme.accent,
                  fontWeight: FontWeight.w500)),
        ]));
  }

  Widget _buildSearchResults() {
    return Column(children: [
      _buildAccountCard('techinfluencer', 'Tech Influencer',
          'assets/images/no-image.jpg', '25.4K', '4.2%', 'Verified'),
      SizedBox(height: 12.h),
      _buildAccountCard('lifestyleblogger', 'Lifestyle & Travel',
          'assets/images/no-image.jpg', '18.7K', '3.8%', 'Business'),
      SizedBox(height: 12.h),
      _buildAccountCard('fitnessguru', 'Fitness Coach',
          'assets/images/no-image.jpg', '32.1K', '5.1%', 'Creator'),
      SizedBox(height: 16.h),
      Row(mainAxisAlignment: MainAxisAlignment.center, children: [
        TextButton(
            onPressed: () =>
                Navigator.pushNamed(context, 'instagramLeadSearch'),
            child: Text('View All Results',
                style: TextStyle(
                    color: AppTheme.accent, fontWeight: FontWeight.w500))),
        SizedBox(width: 8.w),
        Icon(Icons.arrow_forward_rounded, color: AppTheme.accent, size: 16),
      ]),
    ]);
  }

  Widget _buildAccountCard(
      String username,
      String displayName,
      String profileImage,
      String followers,
      String engagement,
      String accountType) {
    return Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
            color: AppTheme.primaryBackground,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: AppTheme.border)),
        child: Row(children: [
          CircleAvatar(
              radius: 20,
              backgroundColor: AppTheme.border,
              child: ClipOval(
                  child: CustomImageWidget(
                      imageUrl: profileImage,
                      height: 40,
                      width: 40,
                      fit: BoxFit.cover))),
          SizedBox(width: 12.w),
          Expanded(
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                Row(children: [
                  Text('@$username',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w500,
                          color: AppTheme.primaryText)),
                  SizedBox(width: 6.w),
                  Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                          color: AppTheme.accent.withAlpha(26),
                          borderRadius: BorderRadius.circular(4)),
                      child: Text(accountType,
                          style: TextStyle(
                              fontSize: 10,
                              color: AppTheme.accent,
                              fontWeight: FontWeight.w500))),
                ]),
                SizedBox(height: 4.h),
                Text(displayName,
                    style: Theme.of(context)
                        .textTheme
                        .bodySmall
                        ?.copyWith(color: AppTheme.secondaryText)),
                SizedBox(height: 6.h),
                Row(children: [
                  Icon(Icons.people_outline_rounded,
                      size: 12, color: AppTheme.secondaryText),
                  SizedBox(width: 4.w),
                  Text(followers,
                      style: TextStyle(
                          fontSize: 11, color: AppTheme.secondaryText)),
                  SizedBox(width: 12.w),
                  Icon(Icons.favorite_outline_rounded,
                      size: 12, color: AppTheme.secondaryText),
                  SizedBox(width: 4.w),
                  Text(engagement,
                      style: TextStyle(
                          fontSize: 11, color: AppTheme.secondaryText)),
                ]),
              ])),
          IconButton(
              icon: Icon(Icons.more_vert_rounded,
                  color: AppTheme.secondaryText, size: 18),
              onPressed: () {
                // Show account options
              }),
        ]));
  }

  void _showFilters() {
    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        builder: (context) => Container(
            decoration: BoxDecoration(
                color: AppTheme.surface,
                borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20))),
            child: Padding(
                padding: EdgeInsets.only(
                    bottom: MediaQuery.of(context).viewInsets.bottom),
                child: Column(mainAxisSize: MainAxisSize.min, children: [
                  Container(
                      width: 40,
                      height: 4,
                      margin: const EdgeInsets.only(top: 8),
                      decoration: BoxDecoration(
                          color: AppTheme.border,
                          borderRadius: BorderRadius.circular(2))),
                  Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Filter Instagram Accounts',
                                style: Theme.of(context).textTheme.titleMedium),
                            SizedBox(height: 24.h),
                            Text('Follower Count Range',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyMedium
                                    ?.copyWith(fontWeight: FontWeight.w500)),
                            RangeSlider(
                                values: _followerRange,
                                min: 100,
                                max: 1000000,
                                divisions: 100,
                                labels: RangeLabels(
                                    '${_followerRange.start.toInt()}K',
                                    '${_followerRange.end.toInt()}K'),
                                onChanged: (values) {
                                  setState(() {
                                    _followerRange = values;
                                  });
                                }),
                            SizedBox(height: 16.h),
                            Text('Engagement Rate Range',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyMedium
                                    ?.copyWith(fontWeight: FontWeight.w500)),
                            RangeSlider(
                                values: _engagementRange,
                                min: 0.1,
                                max: 20.0,
                                divisions: 199,
                                labels: RangeLabels(
                                    '${_engagementRange.start.toStringAsFixed(1)}%',
                                    '${_engagementRange.end.toStringAsFixed(1)}%'),
                                onChanged: (values) {
                                  setState(() {
                                    _engagementRange = values;
                                  });
                                }),
                            SizedBox(height: 24.h),
                            Row(children: [
                              Expanded(
                                  child: OutlinedButton(
                                      onPressed: () => Navigator.pop(context),
                                      child: const Text('Cancel'))),
                              SizedBox(width: 12.w),
                              Expanded(
                                  child: ElevatedButton(
                                      onPressed: () {
                                        Navigator.pop(context);
                                        // Apply filters
                                      },
                                      child: const Text('Apply Filters'))),
                            ]),
                          ])),
                ]))));
  }
}