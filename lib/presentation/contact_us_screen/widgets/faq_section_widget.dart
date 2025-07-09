import '../../../core/app_export.dart';

class FaqSectionWidget extends StatefulWidget {
  const FaqSectionWidget({super.key});

  @override
  State<FaqSectionWidget> createState() => _FaqSectionWidgetState();
}

class _FaqSectionWidgetState extends State<FaqSectionWidget> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  final List<String> _expandedFaqs = [];

  final List<Map<String, String>> _faqs = [
    {
      'question': 'How do I reset my password?',
      'answer':
          'You can reset your password by clicking the "Forgot Password" link on the login page. Enter your email address and follow the instructions sent to your email.',
    },
    {
      'question': 'How do I invite team members to my workspace?',
      'answer':
          'Go to your workspace settings, click on "Team Management", then click "Invite Member". Enter their email address and select their role.',
    },
    {
      'question': 'What payment methods do you accept?',
      'answer':
          'We accept all major credit cards (Visa, MasterCard, American Express), PayPal, and bank transfers for enterprise customers.',
    },
    {
      'question': 'How do I cancel my subscription?',
      'answer':
          'You can cancel your subscription anytime from your billing settings. Go to Settings > Billing & Subscriptions > Cancel Subscription.',
    },
    {
      'question': 'Is there a free trial available?',
      'answer':
          'Yes, we offer a 14-day free trial for all new users. No credit card required to start your trial.',
    },
    {
      'question': 'How do I connect my social media accounts?',
      'answer':
          'Go to Settings > Integrations > Social Media Accounts. Click "Connect" next to the platform you want to integrate.',
    },
    {
      'question': 'What are the system requirements?',
      'answer':
          'Mewayz works on any modern web browser and mobile device. For optimal performance, we recommend Chrome, Firefox, or Safari.',
    },
    {
      'question': 'How do I export my data?',
      'answer':
          'You can export your data from Settings > Account Settings > Data Export. Choose the format (CSV, JSON, or PDF) and data range.',
    },
  ];

  List<Map<String, String>> get _filteredFaqs {
    if (_searchQuery.isEmpty) return _faqs;

    return _faqs.where((faq) {
      final questionMatch =
          faq['question']!.toLowerCase().contains(_searchQuery.toLowerCase());
      final answerMatch =
          faq['answer']!.toLowerCase().contains(_searchQuery.toLowerCase());
      return questionMatch || answerMatch;
    }).toList();
  }

  void _toggleFaq(String question) {
    setState(() {
      if (_expandedFaqs.contains(question)) {
        _expandedFaqs.remove(question);
      } else {
        _expandedFaqs.add(question);
      }
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppTheme.border.withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Frequently Asked Questions',
            style: GoogleFonts.inter(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: AppTheme.primaryText,
            ),
          ),
          const SizedBox(height: 16),

          // Search FAQ
          Container(
            decoration: BoxDecoration(
              color: AppTheme.primaryBackground,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: AppTheme.border.withValues(alpha: 0.3),
                width: 1,
              ),
            ),
            child: TextField(
              controller: _searchController,
              onChanged: (value) {
                setState(() {
                  _searchQuery = value;
                });
              },
              style: GoogleFonts.inter(
                fontSize: 14,
                fontWeight: FontWeight.w400,
                color: AppTheme.primaryText,
              ),
              decoration: InputDecoration(
                hintText: 'Search FAQ...',
                hintStyle: GoogleFonts.inter(
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  color: AppTheme.secondaryText,
                ),
                prefixIcon: Icon(
                  Icons.search,
                  color: AppTheme.secondaryText,
                  size: 20,
                ),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                        onPressed: () {
                          _searchController.clear();
                          setState(() {
                            _searchQuery = '';
                          });
                        },
                        icon: Icon(
                          Icons.clear,
                          color: AppTheme.secondaryText,
                          size: 20,
                        ),
                      )
                    : null,
                border: InputBorder.none,
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              ),
            ),
          ),
          const SizedBox(height: 16),

          // FAQ items
          ..._filteredFaqs.map((faq) {
            final isExpanded = _expandedFaqs.contains(faq['question']);
            final isHighlighted = _searchQuery.isNotEmpty &&
                (faq['question']!
                        .toLowerCase()
                        .contains(_searchQuery.toLowerCase()) ||
                    faq['answer']!
                        .toLowerCase()
                        .contains(_searchQuery.toLowerCase()));

            return Container(
              margin: const EdgeInsets.only(bottom: 8),
              decoration: BoxDecoration(
                color: isHighlighted
                    ? AppTheme.accent.withValues(alpha: 0.05)
                    : AppTheme.primaryBackground,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: isHighlighted
                      ? AppTheme.accent.withValues(alpha: 0.3)
                      : AppTheme.border.withValues(alpha: 0.3),
                  width: 1,
                ),
              ),
              child: Column(
                children: [
                  InkWell(
                    onTap: () => _toggleFaq(faq['question']!),
                    borderRadius: BorderRadius.circular(8),
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              faq['question']!,
                              style: GoogleFonts.inter(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                color: isHighlighted
                                    ? AppTheme.accent
                                    : AppTheme.primaryText,
                              ),
                            ),
                          ),
                          AnimatedRotation(
                            turns: isExpanded ? 0.5 : 0,
                            duration: const Duration(milliseconds: 200),
                            child: Icon(
                              Icons.keyboard_arrow_down,
                              color: AppTheme.secondaryText,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  // Expanded answer
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    height: isExpanded ? null : 0,
                    child: isExpanded
                        ? Container(
                            padding: const EdgeInsets.only(
                              left: 16,
                              right: 16,
                              bottom: 16,
                            ),
                            decoration: BoxDecoration(
                              border: Border(
                                top: BorderSide(
                                  color: AppTheme.border.withValues(alpha: 0.3),
                                  width: 1,
                                ),
                              ),
                            ),
                            child: Text(
                              faq['answer']!,
                              style: GoogleFonts.inter(
                                fontSize: 13,
                                fontWeight: FontWeight.w400,
                                color: AppTheme.secondaryText,
                              ),
                            ),
                          )
                        : const SizedBox.shrink(),
                  ),
                ],
              ),
            );
          }),

          const SizedBox(height: 16),

          // Still need help section
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppTheme.accent.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Still need help?',
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.primaryText,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  "Can't find what you're looking for? Submit a support request above and our team will get back to you.",
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                    color: AppTheme.secondaryText,
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