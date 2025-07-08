import 'package:flutter/material.dart';

import '../../core/app_export.dart';
import './widgets/analytics_widget.dart';
import './widgets/automation_builder_widget.dart';
import './widgets/campaign_builder_widget.dart';
import './widgets/campaign_settings_widget.dart';
import './widgets/deliverability_widget.dart';
import './widgets/preview_widget.dart';
import './widgets/recipient_management_widget.dart';
import './widgets/template_library_widget.dart';

class EmailMarketingCampaign extends StatefulWidget {
  const EmailMarketingCampaign({Key? key}) : super(key: key);

  @override
  State<EmailMarketingCampaign> createState() => _EmailMarketingCampaignState();
}

class _EmailMarketingCampaignState extends State<EmailMarketingCampaign>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  int _currentStep = 0;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
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
          'Email Marketing Campaign',
          style: Theme.of(context).appBarTheme.titleTextStyle,
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.analytics_outlined,
                color: AppTheme.primaryText),
            onPressed: () {
              _tabController.animateTo(3);
            },
          ),
          IconButton(
            icon: const Icon(Icons.save_outlined, color: AppTheme.primaryText),
            onPressed: _saveCampaign,
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Create'),
            Tab(text: 'Recipients'),
            Tab(text: 'Automation'),
            Tab(text: 'Analytics'),
          ],
        ),
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(AppTheme.accent),
              ),
            )
          : TabBarView(
              controller: _tabController,
              children: [
                _buildCreateTab(),
                _buildRecipientsTab(),
                _buildAutomationTab(),
                _buildAnalyticsTab(),
              ],
            ),
    );
  }

  Widget _buildCreateTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildCampaignStatusIndicator(),
          SizedBox(height: 24.h),
          _buildStepIndicator(),
          SizedBox(height: 24.h),
          if (_currentStep == 0) ...[
            const TemplateLibraryWidget(),
          ] else if (_currentStep == 1) ...[
            const CampaignBuilderWidget(),
          ] else if (_currentStep == 2) ...[
            const CampaignSettingsWidget(),
          ] else if (_currentStep == 3) ...[
            const PreviewWidget(),
          ],
          SizedBox(height: 24.h),
          _buildNavigationButtons(),
        ],
      ),
    );
  }

  Widget _buildRecipientsTab() {
    return const SingleChildScrollView(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          RecipientManagementWidget(),
        ],
      ),
    );
  }

  Widget _buildAutomationTab() {
    return const SingleChildScrollView(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AutomationBuilderWidget(),
        ],
      ),
    );
  }

  Widget _buildAnalyticsTab() {
    return const SingleChildScrollView(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AnalyticsWidget(),
          SizedBox(height: 24),
          DeliverabilityWidget(),
        ],
      ),
    );
  }

  Widget _buildCampaignStatusIndicator() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppTheme.border),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppTheme.warning.withAlpha(26),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              Icons.edit_outlined,
              color: AppTheme.warning,
              size: 20,
            ),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Campaign Status: Draft',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w500,
                        color: AppTheme.primaryText,
                      ),
                ),
                SizedBox(height: 4.h),
                Text(
                  'Complete all steps to send your campaign',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppTheme.secondaryText,
                      ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: AppTheme.warning.withAlpha(26),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              'DRAFT',
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w600,
                color: AppTheme.warning,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStepIndicator() {
    final steps = [
      'Choose Template',
      'Design Email',
      'Campaign Settings',
      'Preview & Test',
    ];

    return Row(
      children: steps.asMap().entries.map((entry) {
        final index = entry.key;
        final step = entry.value;
        final isActive = index == _currentStep;
        final isCompleted = index < _currentStep;

        return Expanded(
          child: Column(
            children: [
              Row(
                children: [
                  Container(
                    width: 24,
                    height: 24,
                    decoration: BoxDecoration(
                      color: isCompleted
                          ? AppTheme.success
                          : isActive
                              ? AppTheme.accent
                              : AppTheme.border,
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: isCompleted
                          ? Icon(
                              Icons.check_rounded,
                              color: AppTheme.primaryAction,
                              size: 14,
                            )
                          : Text(
                              '${index + 1}',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: isActive
                                    ? AppTheme.primaryAction
                                    : AppTheme.secondaryText,
                              ),
                            ),
                    ),
                  ),
                  if (index < steps.length - 1)
                    Expanded(
                      child: Container(
                        height: 2,
                        color: isCompleted ? AppTheme.success : AppTheme.border,
                      ),
                    ),
                ],
              ),
              SizedBox(height: 8.h),
              Text(
                step,
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w500,
                  color:
                      isActive ? AppTheme.primaryText : AppTheme.secondaryText,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget _buildNavigationButtons() {
    return Row(
      children: [
        if (_currentStep > 0)
          Expanded(
            child: OutlinedButton(
              onPressed: () {
                setState(() {
                  _currentStep--;
                });
              },
              child: const Text('Previous'),
            ),
          ),
        if (_currentStep > 0) SizedBox(width: 12.w),
        Expanded(
          child: ElevatedButton(
            onPressed: () {
              if (_currentStep < 3) {
                setState(() {
                  _currentStep++;
                });
              } else {
                _sendCampaign();
              }
            },
            child: Text(_currentStep == 3 ? 'Send Campaign' : 'Next'),
          ),
        ),
      ],
    );
  }

  void _saveCampaign() {
    setState(() => _isLoading = true);
    // Simulate save operation
    Future.delayed(const Duration(seconds: 1), () {
      if (mounted) {
        setState(() => _isLoading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Campaign saved successfully')),
        );
      }
    });
  }

  void _sendCampaign() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Send Campaign'),
        content: const Text(
            'Are you sure you want to send this campaign to all recipients?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              setState(() => _isLoading = true);
              // Simulate send operation
              Future.delayed(const Duration(seconds: 2), () {
                if (mounted) {
                  setState(() => _isLoading = false);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Campaign sent successfully')),
                  );
                }
              });
            },
            child: const Text('Send'),
          ),
        ],
      ),
    );
  }
}