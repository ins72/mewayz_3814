import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../core/app_export.dart';
import './widgets/analytics_cards_widget.dart';
import './widgets/content_calendar_widget.dart';
import './widgets/instagram_database_widget.dart';
import './widgets/platform_connection_widget.dart';
import './widgets/quick_actions_grid_widget.dart';
import './widgets/quick_post_modal_widget.dart';
import './widgets/recent_activity_widget.dart';

class SocialMediaManager extends StatefulWidget {
  const SocialMediaManager({Key? key}) : super(key: key);

  @override
  State<SocialMediaManager> createState() => _SocialMediaManagerState();
}

class _SocialMediaManagerState extends State<SocialMediaManager>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _refreshData() async {
    if (mounted) {
      setState(() => _isLoading = true);
      // Simulate API call
      await Future.delayed(const Duration(seconds: 2));
      // Haptic feedback
      HapticFeedback.lightImpact();
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  void _showQuickPostModal() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const QuickPostModalWidget(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.primaryBackground,
      appBar: AppBar(
        backgroundColor: AppTheme.primaryBackground,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: AppTheme.primaryText),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Social Media Manager',
          style: Theme.of(context).appBarTheme.titleTextStyle,
        ),
        actions: [
          IconButton(
            icon:
                const Icon(Icons.refresh_rounded, color: AppTheme.primaryText),
            onPressed: _refreshData,
          ),
          IconButton(
            icon: const Icon(Icons.notifications_outlined,
                color: AppTheme.primaryText),
            onPressed: () {
              // Navigate to notifications
            },
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Overview'),
            Tab(text: 'Analytics'),
            Tab(text: 'Content'),
          ],
        ),
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(AppTheme.accent),
              ),
            )
          : RefreshIndicator(
              onRefresh: _refreshData,
              color: AppTheme.accent,
              backgroundColor: AppTheme.surface,
              child: TabBarView(
                controller: _tabController,
                children: [
                  _buildOverviewTab(),
                  _buildAnalyticsTab(),
                  _buildContentTab(),
                ],
              ),
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showQuickPostModal,
        backgroundColor: AppTheme.primaryAction,
        foregroundColor: AppTheme.primaryBackground,
        child: const Icon(Icons.add_rounded),
      ),
    );
  }

  Widget _buildOverviewTab() {
    return SingleChildScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const PlatformConnectionWidget(),
          SizedBox(height: 24.h),
          const AnalyticsCardsWidget(),
          SizedBox(height: 24.h),
          const QuickActionsGridWidget(),
          SizedBox(height: 24.h),
          const InstagramDatabaseWidget(),
          SizedBox(height: 24.h),
          const ContentCalendarWidget(),
          SizedBox(height: 24.h),
          const RecentActivityWidget(),
          SizedBox(height: 100.h), // Extra space for FAB
        ],
      ),
    );
  }

  Widget _buildAnalyticsTab() {
    return SingleChildScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Analytics Overview',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          SizedBox(height: 16.h),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: AppTheme.surface,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppTheme.border),
            ),
            child: Column(
              children: [
                Icon(
                  Icons.analytics_outlined,
                  size: 48,
                  color: AppTheme.secondaryText,
                ),
                SizedBox(height: 16.h),
                Text(
                  'Detailed Analytics',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                SizedBox(height: 8.h),
                Text(
                  'Comprehensive social media analytics and performance tracking coming soon',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: AppTheme.secondaryText,
                      ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContentTab() {
    return SingleChildScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Content Management',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          SizedBox(height: 16.h),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: AppTheme.surface,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppTheme.border),
            ),
            child: Column(
              children: [
                Icon(
                  Icons.content_copy_outlined,
                  size: 48,
                  color: AppTheme.secondaryText,
                ),
                SizedBox(height: 16.h),
                Text(
                  'Content Library',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                SizedBox(height: 8.h),
                Text(
                  'Manage your content library, templates, and scheduled posts',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: AppTheme.secondaryText,
                      ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}