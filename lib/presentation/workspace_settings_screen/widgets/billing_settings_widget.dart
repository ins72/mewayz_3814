import 'package:flutter/material.dart';

import '../../../core/app_export.dart';

class BillingSettingsWidget extends StatefulWidget {
  final VoidCallback onChanged;

  const BillingSettingsWidget({
    super.key,
    required this.onChanged,
  });

  @override
  State<BillingSettingsWidget> createState() => _BillingSettingsWidgetState();
}

class _BillingSettingsWidgetState extends State<BillingSettingsWidget> {
  String _currentPlan = 'Professional';
  String _billingCycle = 'Monthly';
  bool _autoRenewal = true;

  final List<Plan> _plans = [
    Plan(
      name: 'Free',
      price: 0,
      currency: 'USD',
      features: [
        'Up to 5 team members',
        '10GB storage',
        'Basic analytics',
        'Email support',
      ],
      isPopular: false,
    ),
    Plan(
      name: 'Professional',
      price: 29,
      currency: 'USD',
      features: [
        'Up to 25 team members',
        '100GB storage',
        'Advanced analytics',
        'Priority support',
        'Custom integrations',
      ],
      isPopular: true,
    ),
    Plan(
      name: 'Enterprise',
      price: 99,
      currency: 'USD',
      features: [
        'Unlimited team members',
        '1TB storage',
        'Advanced security',
        '24/7 phone support',
        'Custom branding',
        'API access',
      ],
      isPopular: false,
    ),
  ];

  final List<Invoice> _invoices = [
    Invoice(
      id: 'INV-2024-001',
      amount: 29.00,
      currency: 'USD',
      date: DateTime.now().subtract(const Duration(days: 30)),
      status: 'Paid',
      downloadUrl: 'https://example.com/invoice-001.pdf',
    ),
    Invoice(
      id: 'INV-2024-002',
      amount: 29.00,
      currency: 'USD',
      date: DateTime.now().subtract(const Duration(days: 60)),
      status: 'Paid',
      downloadUrl: 'https://example.com/invoice-002.pdf',
    ),
    Invoice(
      id: 'INV-2024-003',
      amount: 29.00,
      currency: 'USD',
      date: DateTime.now().subtract(const Duration(days: 90)),
      status: 'Paid',
      downloadUrl: 'https://example.com/invoice-003.pdf',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildCurrentPlanSection(),
          const SizedBox(height: 24),
          _buildAvailablePlansSection(),
          const SizedBox(height: 24),
          _buildBillingCycleSection(),
          const SizedBox(height: 24),
          _buildPaymentMethodSection(),
          const SizedBox(height: 24),
          _buildBillingHistorySection(),
        ],
      ),
    );
  }

  Widget _buildCurrentPlanSection() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppTheme.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Current Plan',
            style: GoogleFonts.inter(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: AppTheme.primaryText,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: AppTheme.accent.withAlpha(26),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  _currentPlan,
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: AppTheme.accent,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Text(
                '\$29/month',
                style: GoogleFonts.inter(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: AppTheme.primaryText,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Icon(
                _autoRenewal ? Icons.check_circle : Icons.cancel,
                color: _autoRenewal ? AppTheme.success : AppTheme.warning,
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(
                _autoRenewal ? 'Auto-renewal enabled' : 'Auto-renewal disabled',
                style: GoogleFonts.inter(
                  fontSize: 14,
                  color: AppTheme.secondaryText,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              ElevatedButton(
                onPressed: () {
                  // TODO: Implement upgrade plan
                  widget.onChanged();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.primaryAction,
                  foregroundColor: AppTheme.primaryBackground,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: Text(
                  'Upgrade Plan',
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              TextButton(
                onPressed: () {
                  // TODO: Implement cancel subscription
                  widget.onChanged();
                },
                child: Text(
                  'Cancel Subscription',
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: AppTheme.error,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAvailablePlansSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Available Plans',
          style: GoogleFonts.inter(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: AppTheme.primaryText,
          ),
        ),
        const SizedBox(height: 16),
        ...(_plans.map((plan) => _buildPlanCard(plan)).toList()),
      ],
    );
  }

  Widget _buildPlanCard(Plan plan) {
    final isCurrentPlan = plan.name == _currentPlan;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isCurrentPlan ? AppTheme.accent : AppTheme.border,
          width: isCurrentPlan ? 2 : 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                plan.name,
                style: GoogleFonts.inter(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: AppTheme.primaryText,
                ),
              ),
              const SizedBox(width: 8),
              if (plan.isPopular)
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppTheme.accent.withAlpha(26),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    'Most Popular',
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: AppTheme.accent,
                    ),
                  ),
                ),
              const Spacer(),
              Text(
                plan.price == 0 ? 'Free' : '\$${plan.price}/month',
                style: GoogleFonts.inter(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: AppTheme.primaryText,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ...plan.features.map((feature) => Padding(
                padding: const EdgeInsets.only(bottom: 4),
                child: Row(
                  children: [
                    const Icon(
                      Icons.check,
                      size: 16,
                      color: AppTheme.success,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      feature,
                      style: GoogleFonts.inter(
                        fontSize: 14,
                        color: AppTheme.secondaryText,
                      ),
                    ),
                  ],
                ),
              )),
          const SizedBox(height: 16),
          if (!isCurrentPlan)
            ElevatedButton(
              onPressed: () {
                // TODO: Implement plan selection
                widget.onChanged();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.primaryAction,
                foregroundColor: AppTheme.primaryBackground,
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Text(
                'Select Plan',
                style: GoogleFonts.inter(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            )
          else
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: AppTheme.success.withAlpha(26),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                'Current Plan',
                style: GoogleFonts.inter(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: AppTheme.success,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildBillingCycleSection() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppTheme.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Billing Cycle',
            style: GoogleFonts.inter(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: AppTheme.primaryText,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: RadioListTile<String>(
                  title: Text(
                    'Monthly',
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      color: AppTheme.primaryText,
                    ),
                  ),
                  value: 'Monthly',
                  groupValue: _billingCycle,
                  onChanged: (value) {
                    setState(() {
                      _billingCycle = value!;
                    });
                    widget.onChanged();
                  },
                  activeColor: AppTheme.accent,
                  contentPadding: EdgeInsets.zero,
                ),
              ),
              Expanded(
                child: RadioListTile<String>(
                  title: Text(
                    'Yearly (Save 20%)',
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      color: AppTheme.primaryText,
                    ),
                  ),
                  value: 'Yearly',
                  groupValue: _billingCycle,
                  onChanged: (value) {
                    setState(() {
                      _billingCycle = value!;
                    });
                    widget.onChanged();
                  },
                  activeColor: AppTheme.accent,
                  contentPadding: EdgeInsets.zero,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          SwitchListTile(
            title: Text(
              'Auto-renewal',
              style: GoogleFonts.inter(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: AppTheme.primaryText,
              ),
            ),
            subtitle: Text(
              'Automatically renew your subscription',
              style: GoogleFonts.inter(
                fontSize: 14,
                color: AppTheme.secondaryText,
              ),
            ),
            value: _autoRenewal,
            onChanged: (value) {
              setState(() {
                _autoRenewal = value;
              });
              widget.onChanged();
            },
            activeColor: AppTheme.accent,
            contentPadding: EdgeInsets.zero,
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentMethodSection() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppTheme.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Payment Method',
            style: GoogleFonts.inter(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: AppTheme.primaryText,
            ),
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppTheme.primaryBackground,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: AppTheme.border),
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.credit_card,
                  color: AppTheme.accent,
                  size: 24,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Visa ending in 4242',
                        style: GoogleFonts.inter(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: AppTheme.primaryText,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Expires 12/2025',
                        style: GoogleFonts.inter(
                          fontSize: 12,
                          color: AppTheme.secondaryText,
                        ),
                      ),
                    ],
                  ),
                ),
                TextButton(
                  onPressed: () {
                    // TODO: Implement update payment method
                    widget.onChanged();
                  },
                  child: Text(
                    'Update',
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: AppTheme.accent,
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

  Widget _buildBillingHistorySection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Billing History',
          style: GoogleFonts.inter(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: AppTheme.primaryText,
          ),
        ),
        const SizedBox(height: 16),
        Container(
          decoration: BoxDecoration(
            color: AppTheme.surface,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppTheme.border),
          ),
          child: Column(
            children:
                _invoices.map((invoice) => _buildInvoiceRow(invoice)).toList(),
          ),
        ),
      ],
    );
  }

  Widget _buildInvoiceRow(Invoice invoice) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: AppTheme.border,
            width: 0.5,
          ),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  invoice.id,
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: AppTheme.primaryText,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  _formatDate(invoice.date),
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    color: AppTheme.secondaryText,
                  ),
                ),
              ],
            ),
          ),
          Text(
            '\$${invoice.amount.toStringAsFixed(2)}',
            style: GoogleFonts.inter(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: AppTheme.primaryText,
            ),
          ),
          const SizedBox(width: 16),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: invoice.status == 'Paid'
                  ? AppTheme.success.withAlpha(26)
                  : AppTheme.warning.withAlpha(26),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              invoice.status,
              style: GoogleFonts.inter(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: invoice.status == 'Paid'
                    ? AppTheme.success
                    : AppTheme.warning,
              ),
            ),
          ),
          const SizedBox(width: 16),
          IconButton(
            onPressed: () {
              // TODO: Implement invoice download
            },
            icon: const Icon(
              Icons.download,
              color: AppTheme.secondaryText,
              size: 20,
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
}

class Plan {
  final String name;
  final int price;
  final String currency;
  final List<String> features;
  final bool isPopular;

  Plan({
    required this.name,
    required this.price,
    required this.currency,
    required this.features,
    required this.isPopular,
  });
}

class Invoice {
  final String id;
  final double amount;
  final String currency;
  final DateTime date;
  final String status;
  final String downloadUrl;

  Invoice({
    required this.id,
    required this.amount,
    required this.currency,
    required this.date,
    required this.status,
    required this.downloadUrl,
  });
}