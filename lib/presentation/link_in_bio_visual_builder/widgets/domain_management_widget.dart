import '../../../core/app_export.dart';
import '../../../services/link_in_bio_service.dart';

class DomainManagementWidget extends StatefulWidget {
  final String? pageId;
  final Map<String, dynamic>? currentPage;

  const DomainManagementWidget({
    Key? key,
    required this.pageId,
    required this.currentPage,
  }) : super(key: key);

  @override
  State<DomainManagementWidget> createState() => _DomainManagementWidgetState();
}

class _DomainManagementWidgetState extends State<DomainManagementWidget> {
  final LinkInBioService _linkService = LinkInBioService();
  final TextEditingController _domainController = TextEditingController();
  
  List<Map<String, dynamic>> _customDomains = [];
  bool _isLoading = false;
  bool _isAddingDomain = false;

  @override
  void initState() {
    super.initState();
    _loadCustomDomains();
  }

  @override
  void dispose() {
    _domainController.dispose();
    super.dispose();
  }

  Future<void> _loadCustomDomains() async {
    if (widget.pageId == null) return;
    
    setState(() => _isLoading = true);
    
    try {
      final userId = 'current-user-id'; // Get from auth service
      final domains = await _linkService.getUserCustomDomains(userId);
      setState(() {
        _customDomains = domains.where((d) => d['link_page_id'] == widget.pageId).toList();
        _isLoading = false;
      });
    } catch (error) {
      setState(() => _isLoading = false);
      _showErrorSnackBar('Failed to load domains: $error');
    }
  }

  Future<void> _addCustomDomain() async {
    if (widget.pageId == null || _domainController.text.trim().isEmpty) return;
    
    final domainName = _domainController.text.trim().toLowerCase();
    
    // Basic domain validation
    if (!_isValidDomain(domainName)) {
      _showErrorSnackBar('Please enter a valid domain name');
      return;
    }
    
    setState(() => _isAddingDomain = true);
    
    try {
      final userId = 'current-user-id'; // Get from auth service
      final newDomain = await _linkService.addCustomDomain(
        userId: userId,
        linkPageId: widget.pageId!,
        domainName: domainName,
      );
      
      setState(() {
        _customDomains.add(newDomain);
        _domainController.clear();
        _isAddingDomain = false;
      });
      
      _showSuccessSnackBar('Domain added successfully! Follow the verification steps below.');
    } catch (error) {
      setState(() => _isAddingDomain = false);
      _showErrorSnackBar('Failed to add domain: $error');
    }
  }

  Future<void> _verifyDomain(String domainId) async {
    try {
      await _linkService.verifyCustomDomain(domainId);
      _loadCustomDomains(); // Refresh the list
      _showSuccessSnackBar('Domain verified successfully!');
    } catch (error) {
      _showErrorSnackBar('Failed to verify domain: $error');
    }
  }

  Future<void> _deleteDomain(String domainId) async {
    try {
      await _linkService.deleteCustomDomain(domainId);
      setState(() {
        _customDomains.removeWhere((d) => d['id'] == domainId);
      });
      _showSuccessSnackBar('Domain deleted successfully');
    } catch (error) {
      _showErrorSnackBar('Failed to delete domain: $error');
    }
  }

  bool _isValidDomain(String domain) {
    final domainRegex = RegExp(
      r'^[a-zA-Z0-9][a-zA-Z0-9-]{0,61}[a-zA-Z0-9]?\.[a-zA-Z]{2,}$',
    );
    return domainRegex.hasMatch(domain);
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
      ),
    );
  }

  void _showSuccessSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.green,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Domain Settings',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: AppTheme.primaryText,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 16),

          // Global domain section
          _buildGlobalDomainSection(),
          
          const SizedBox(height: 24),
          
          // Custom domains section
          _buildCustomDomainsSection(),
        ],
      ),
    );
  }

  Widget _buildGlobalDomainSection() {
    final globalDomain = 'linkbio.com'; // Replacing EnvironmentConfig.globalLinkInBioDomain
    final slug = widget.currentPage?['slug'] as String? ?? 'your-page';
    final globalUrl = 'https://$globalDomain/$slug';

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.surface,
        border: Border.all(color: AppTheme.border),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.public,
                color: AppTheme.accent,
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(
                'Global Domain',
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  color: AppTheme.primaryText,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppTheme.primaryBackground,
              borderRadius: BorderRadius.circular(6),
              border: Border.all(color: AppTheme.border),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    globalUrl,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: AppTheme.primaryText,
                      fontFamily: 'monospace',
                    ),
                  ),
                ),
                IconButton(
                  onPressed: () => _copyToClipboard(globalUrl),
                  icon: Icon(
                    Icons.copy,
                    color: AppTheme.secondaryText,
                    size: 18,
                  ),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                ),
              ],
            ),
          ),
          
          const SizedBox(height: 8),
          Text(
            'This is your default URL that works immediately',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: AppTheme.secondaryText,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCustomDomainsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              Icons.domain,
              color: AppTheme.accent,
              size: 20,
            ),
            const SizedBox(width: 8),
            Text(
              'Custom Domains',
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                color: AppTheme.primaryText,
                fontWeight: FontWeight.w600,
              ),
            ),
            const Spacer(),
            // Using a default value since EnvironmentConfig.enableCustomDomains is undefined
            IconButton(
              onPressed: _showAddDomainDialog,
              icon: Icon(
                Icons.add,
                color: AppTheme.accent,
                size: 20,
              ),
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
            ),
          ],
        ),
        const SizedBox(height: 12),

        if (_isLoading)
          const Center(child: CircularProgressIndicator())
        else if (_customDomains.isEmpty)
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppTheme.surface,
              border: Border.all(color: AppTheme.border),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              children: [
                Icon(
                  Icons.domain_disabled,
                  color: AppTheme.secondaryText,
                  size: 32,
                ),
                const SizedBox(height: 8),
                Text(
                  'No custom domains yet',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppTheme.secondaryText,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Connect your own domain for a\nprofessional branded experience',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppTheme.secondaryText,
                  ),
                ),
              ],
            ),
          )
        else
          ...(_customDomains.map((domain) => _buildDomainCard(domain)).toList()),
      ],
    );
  }

  Widget _buildDomainCard(Map<String, dynamic> domain) {
    final domainName = domain['domain_name'] as String;
    final status = domain['status'] as String;
    final verificationToken = domain['verification_token'] as String?;

    Color statusColor;
    IconData statusIcon;
    String statusText;

    switch (status) {
      case 'verified':
        statusColor = Colors.green;
        statusIcon = Icons.check_circle;
        statusText = 'Verified';
        break;
      case 'failed':
        statusColor = Colors.red;
        statusIcon = Icons.error;
        statusText = 'Failed';
        break;
      case 'pending':
      default:
        statusColor = Colors.orange;
        statusIcon = Icons.pending;
        statusText = 'Pending';
        break;
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.surface,
        border: Border.all(color: AppTheme.border),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  domainName,
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    color: AppTheme.primaryText,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: statusColor.withAlpha(26),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      statusIcon,
                      color: statusColor,
                      size: 14,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      statusText,
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        color: statusColor,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              PopupMenuButton<String>(
                onSelected: (value) {
                  switch (value) {
                    case 'verify':
                      _verifyDomain(domain['id']);
                      break;
                    case 'delete':
                      _showDeleteDialog(domain);
                      break;
                  }
                },
                itemBuilder: (context) => [
                  if (status != 'verified')
                    const PopupMenuItem(
                      value: 'verify',
                      child: Text('Verify Domain'),
                    ),
                  const PopupMenuItem(
                    value: 'delete',
                    child: Text('Delete Domain'),
                  ),
                ],
                child: Icon(
                  Icons.more_vert,
                  color: AppTheme.secondaryText,
                  size: 18,
                ),
              ),
            ],
          ),

          if (status == 'pending' && verificationToken != null) ...[
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.blue.withAlpha(26),
                borderRadius: BorderRadius.circular(6),
                border: Border.all(color: Colors.blue.withAlpha(77)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Verification Required',
                    style: Theme.of(context).textTheme.labelMedium?.copyWith(
                      color: Colors.blue[800],
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Add this TXT record to your DNS:',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Colors.blue[700],
                    ),
                  ),
                  const SizedBox(height: 4),
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(4),
                      border: Border.all(color: Colors.blue.withAlpha(77)),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            'mewayz-verification=$verificationToken',
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              fontFamily: 'monospace',
                              color: Colors.blue[800],
                            ),
                          ),
                        ),
                        IconButton(
                          onPressed: () => _copyToClipboard('mewayz-verification=$verificationToken'),
                          icon: Icon(
                            Icons.copy,
                            color: Colors.blue[600],
                            size: 16,
                          ),
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  void _showAddDomainDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add Custom Domain'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Enter your custom domain name:'),
            const SizedBox(height: 8),
            TextField(
              controller: _domainController,
              decoration: const InputDecoration(
                hintText: 'example.com',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.url,
            ),
            const SizedBox(height: 8),
            Text(
              'Make sure you have access to the DNS settings for this domain.',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: AppTheme.secondaryText,
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              _domainController.clear();
              Navigator.pop(context);
            },
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: _isAddingDomain
                ? null
                : () {
                    Navigator.pop(context);
                    _addCustomDomain();
                  },
            child: _isAddingDomain
                ? const SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Text('Add Domain'),
          ),
        ],
      ),
    );
  }

  void _showDeleteDialog(Map<String, dynamic> domain) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Domain'),
        content: Text('Are you sure you want to delete ${domain['domain_name']}? This action cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _deleteDomain(domain['id']);
            },
            style: TextButton.styleFrom(
              foregroundColor: Colors.red,
            ),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  void _copyToClipboard(String text) {
    Clipboard.setData(ClipboardData(text: text));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Copied to clipboard'),
        duration: Duration(seconds: 2),
      ),
    );
  }
}