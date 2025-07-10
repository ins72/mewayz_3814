import '../../core/app_export.dart';
import './widgets/domain_status_header_widget.dart';

class CustomDomainManagementScreen extends StatefulWidget {
  const CustomDomainManagementScreen({Key? key}) : super(key: key);

  @override
  State<CustomDomainManagementScreen> createState() => _CustomDomainManagementScreenState();
}

class _CustomDomainManagementScreenState extends State<CustomDomainManagementScreen> with TickerProviderStateMixin {
  late TabController _tabController;
  final TextEditingController _domainController = TextEditingController();
  final TextEditingController _subdomainController = TextEditingController();
  
  List<Map<String, dynamic>> _domains = [];
  List<Map<String, dynamic>> _dnsRecords = [];
  bool _isLoading = false;
  bool _isAddingDomain = false;
  bool _isDnsPropagatoinChecking = false;
  String? _selectedDomain;
  String _selectedRegistrar = 'godaddy';
  Map<String, dynamic>? _sslCertificate;
  
  final List<String> _registrars = ['godaddy', 'namecheap', 'cloudflare', 'other'];
  
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 5, vsync: this);
    _loadDomains();
    _loadDnsRecords();
  }

  @override
  void dispose() {
    _tabController.dispose();
    _domainController.dispose();
    _subdomainController.dispose();
    super.dispose();
  }

  Future<void> _loadDomains() async {
    setState(() => _isLoading = true);
    
    try {
      // Simulate API call
      await Future.delayed(const Duration(seconds: 1));
      
      setState(() {
        _domains = [
          {
            'id': '1',
            'domain': 'example.com',
            'status': 'connected',
            'ssl_status': 'active',
            'created_at': '2025-07-08T10:00:00Z',
            'verified_at': '2025-07-08T10:30:00Z',
            'ssl_expires_at': '2025-10-08T10:30:00Z',
            'traffic_count': 1250,
            'is_primary': true,
          },
          {
            'id': '2',
            'domain': 'test.mysite.com',
            'status': 'pending',
            'ssl_status': 'pending',
            'created_at': '2025-07-10T08:00:00Z',
            'verified_at': null,
            'ssl_expires_at': null,
            'traffic_count': 0,
            'is_primary': false,
          },
          {
            'id': '3',
            'domain': 'broken.example.com',
            'status': 'error',
            'ssl_status': 'failed',
            'created_at': '2025-07-09T15:00:00Z',
            'verified_at': null,
            'ssl_expires_at': null,
            'traffic_count': 0,
            'is_primary': false,
          },
        ];
        _isLoading = false;
      });
    } catch (error) {
      setState(() => _isLoading = false);
      _showErrorSnackBar('Failed to load domains: $error');
    }
  }

  Future<void> _loadDnsRecords() async {
    setState(() {
      _dnsRecords = [
        {
          'type': 'A',
          'name': '@',
          'value': '192.168.1.100',
          'ttl': 300,
          'priority': null,
          'required': true,
        },
        {
          'type': 'CNAME',
          'name': 'www',
          'value': 'example.com',
          'ttl': 300,
          'priority': null,
          'required': true,
        },
        {
          'type': 'TXT',
          'name': '@',
          'value': 'mewayz-verification=abc123def456',
          'ttl': 300,
          'priority': null,
          'required': true,
        },
        {
          'type': 'MX',
          'name': '@',
          'value': 'mail.example.com',
          'ttl': 300,
          'priority': 10,
          'required': false,
        },
      ];
    });
  }

  Future<void> _addDomain() async {
    if (_domainController.text.trim().isEmpty) return;
    
    setState(() => _isAddingDomain = true);
    
    try {
      await Future.delayed(const Duration(seconds: 2));
      
      final newDomain = {
        'id': DateTime.now().millisecondsSinceEpoch.toString(),
        'domain': _domainController.text.trim(),
        'status': 'pending',
        'ssl_status': 'pending',
        'created_at': DateTime.now().toIso8601String(),
        'verified_at': null,
        'ssl_expires_at': null,
        'traffic_count': 0,
        'is_primary': false,
      };
      
      setState(() {
        _domains.add(newDomain);
        _domainController.clear();
        _isAddingDomain = false;
      });
      
      _showSuccessSnackBar('Domain added successfully! Follow DNS setup instructions.');
    } catch (error) {
      setState(() => _isAddingDomain = false);
      _showErrorSnackBar('Failed to add domain: $error');
    }
  }

  Future<void> _verifyDomain(String domainId) async {
    try {
      await Future.delayed(const Duration(seconds: 2));
      
      setState(() {
        final index = _domains.indexWhere((d) => d['id'] == domainId);
        if (index != -1) {
          _domains[index]['status'] = 'connected';
          _domains[index]['verified_at'] = DateTime.now().toIso8601String();
          _domains[index]['ssl_status'] = 'active';
          _domains[index]['ssl_expires_at'] = DateTime.now().add(const Duration(days: 90)).toIso8601String();
        }
      });
      
      _showSuccessSnackBar('Domain verified successfully!');
    } catch (error) {
      _showErrorSnackBar('Failed to verify domain: $error');
    }
  }

  Future<void> _deleteDomain(String domainId) async {
    try {
      await Future.delayed(const Duration(seconds: 1));
      
      setState(() {
        _domains.removeWhere((d) => d['id'] == domainId);
      });
      
      _showSuccessSnackBar('Domain deleted successfully');
    } catch (error) {
      _showErrorSnackBar('Failed to delete domain: $error');
    }
  }

  Future<void> _checkDnsPropagation() async {
    setState(() => _isDnsPropagatoinChecking = true);
    
    try {
      await Future.delayed(const Duration(seconds: 3));
      
      setState(() => _isDnsPropagatoinChecking = false);
      
      _showSuccessSnackBar('DNS propagation check completed! 8/12 locations verified.');
    } catch (error) {
      setState(() => _isDnsPropagatoinChecking = false);
      _showErrorSnackBar('DNS propagation check failed: $error');
    }
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: AppTheme.error,
      ),
    );
  }

  void _showSuccessSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: AppTheme.success,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.primaryBackground,
      appBar: CustomAppBarWidget(
        title: 'Custom Domain Management',
        showBackButton: true,
        backgroundColor: Color(0xFF101010),
        actions: [
          IconButton(
            onPressed: _loadDomains,
            icon: CustomIconWidget(
              iconName: 'refresh',
              color: AppTheme.primaryText,
              size: 20,
            ),
            tooltip: 'Refresh domains',
          ),
        ],
      ),
      body: Column(
        children: [
          // Domain Status Header
          DomainStatusHeaderWidget(
            domains: _domains,
            onDomainSelect: (domain) {
              setState(() => _selectedDomain = domain['id']);
            },
          ),
          
          // Tab Bar
          Container(
            decoration: BoxDecoration(
              color: AppTheme.surface,
              border: Border(
                bottom: BorderSide(
                  color: AppTheme.border,
                  width: 1,
                ),
              ),
            ),
            child: TabBar(
              controller: _tabController,
              indicatorColor: AppTheme.accent,
              labelColor: AppTheme.primaryText,
              unselectedLabelColor: AppTheme.secondaryText,
              indicatorSize: TabBarIndicatorSize.label,
              isScrollable: true,
              tabs: const [
                Tab(text: 'Overview'),
                Tab(text: 'Add Domain'),
                Tab(text: 'DNS Setup'),
                Tab(text: 'SSL Certificates'),
                Tab(text: 'Analytics'),
              ],
            ),
          ),
          
          // Tab Content
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildOverviewTab(),
                _buildAddDomainTab(),
                _buildDnsSetupTab(),
                _buildSslCertificatesTab(),
                _buildAnalyticsTab(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOverviewTab() {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    return SingleChildScrollView(
      padding: EdgeInsets.all(AppTheme.spacingM),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Domain List
          Row(
            children: [
              Text(
                'Your Domains',
                style: AppTheme.darkTheme.textTheme.titleLarge?.copyWith(
                  color: AppTheme.primaryText,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const Spacer(),
              Text(
                '${_domains.length} domains',
                style: AppTheme.darkTheme.textTheme.bodyMedium?.copyWith(
                  color: AppTheme.secondaryText,
                ),
              ),
            ],
          ),
          
          SizedBox(height: AppTheme.spacingM),
          
          if (_domains.isEmpty)
            Container(
              padding: EdgeInsets.all(AppTheme.spacingXl),
              decoration: AppTheme.cardDecoration(),
              child: Column(
                children: [
                  CustomIconWidget(
                    iconName: 'domain_disabled',
                    color: AppTheme.secondaryText,
                    size: 48,
                  ),
                  SizedBox(height: AppTheme.spacingM),
                  Text(
                    'No domains configured',
                    style: AppTheme.darkTheme.textTheme.titleMedium?.copyWith(
                      color: AppTheme.primaryText,
                    ),
                  ),
                  SizedBox(height: AppTheme.spacingS),
                  Text(
                    'Add your first custom domain to get started',
                    style: AppTheme.darkTheme.textTheme.bodyMedium?.copyWith(
                      color: AppTheme.secondaryText,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            )
          else
            ..._domains.map((domain) => _buildDomainCard(domain)).toList(),
        ],
      ),
    );
  }

  Widget _buildDomainCard(Map<String, dynamic> domain) {
    final status = domain['status'] as String;
    final sslStatus = domain['ssl_status'] as String;
    final isPrimary = domain['is_primary'] as bool;
    
    Color statusColor;
    IconData statusIcon;
    
    switch (status) {
      case 'connected':
        statusColor = AppTheme.success;
        statusIcon = Icons.check_circle;
        break;
      case 'error':
        statusColor = AppTheme.error;
        statusIcon = Icons.error;
        break;
      default:
        statusColor = AppTheme.warning;
        statusIcon = Icons.pending;
    }

    return Container(
      margin: EdgeInsets.only(bottom: AppTheme.spacingM),
      decoration: AppTheme.cardDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Padding(
            padding: EdgeInsets.all(AppTheme.spacingM),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            domain['domain'],
                            style: AppTheme.darkTheme.textTheme.titleMedium?.copyWith(
                              color: AppTheme.primaryText,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          if (isPrimary) ...[
                            SizedBox(width: AppTheme.spacingS),
                            Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: AppTheme.spacingS,
                                vertical: 2,
                              ),
                              decoration: BoxDecoration(
                                color: AppTheme.accent.withAlpha(26),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text(
                                'PRIMARY',
                                style: AppTheme.darkTheme.textTheme.labelSmall?.copyWith(
                                  color: AppTheme.accent,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),
                      SizedBox(height: AppTheme.spacingXs),
                      Row(
                        children: [
                          Icon(
                            statusIcon,
                            color: statusColor,
                            size: 16,
                          ),
                          SizedBox(width: AppTheme.spacingXs),
                          Text(
                            status.toUpperCase(),
                            style: AppTheme.darkTheme.textTheme.labelSmall?.copyWith(
                              color: statusColor,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          SizedBox(width: AppTheme.spacingM),
                          Icon(
                            Icons.security,
                            color: sslStatus == 'active' ? AppTheme.success : AppTheme.warning,
                            size: 16,
                          ),
                          SizedBox(width: AppTheme.spacingXs),
                          Text(
                            'SSL ${sslStatus.toUpperCase()}',
                            style: AppTheme.darkTheme.textTheme.labelSmall?.copyWith(
                              color: sslStatus == 'active' ? AppTheme.success : AppTheme.warning,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                PopupMenuButton<String>(
                  onSelected: (value) {
                    switch (value) {
                      case 'verify':
                        _verifyDomain(domain['id']);
                        break;
                      case 'delete':
                        _showDeleteDialog(domain);
                        break;
                      case 'set_primary':
                        _setPrimaryDomain(domain['id']);
                        break;
                    }
                  },
                  itemBuilder: (context) => [
                    if (status != 'connected')
                      const PopupMenuItem(
                        value: 'verify',
                        child: Text('Verify Domain'),
                      ),
                    if (!isPrimary && status == 'connected')
                      const PopupMenuItem(
                        value: 'set_primary',
                        child: Text('Set as Primary'),
                      ),
                    const PopupMenuItem(
                      value: 'delete',
                      child: Text('Delete Domain'),
                    ),
                  ],
                  child: Icon(
                    Icons.more_vert,
                    color: AppTheme.secondaryText,
                  ),
                ),
              ],
            ),
          ),
          
          // Stats
          if (status == 'connected') ...[
            Divider(color: AppTheme.border, height: 1),
            Padding(
              padding: EdgeInsets.all(AppTheme.spacingM),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Traffic',
                          style: AppTheme.darkTheme.textTheme.labelMedium?.copyWith(
                            color: AppTheme.secondaryText,
                          ),
                        ),
                        Text(
                          '${domain['traffic_count']} visits',
                          style: AppTheme.darkTheme.textTheme.titleSmall?.copyWith(
                            color: AppTheme.primaryText,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (domain['ssl_expires_at'] != null)
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'SSL Expires',
                            style: AppTheme.darkTheme.textTheme.labelMedium?.copyWith(
                              color: AppTheme.secondaryText,
                            ),
                          ),
                          Text(
                            _formatDate(domain['ssl_expires_at']),
                            style: AppTheme.darkTheme.textTheme.titleSmall?.copyWith(
                              color: AppTheme.primaryText,
                              fontWeight: FontWeight.w600,
                            ),
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

  Widget _buildAddDomainTab() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(AppTheme.spacingM),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Add New Domain',
            style: AppTheme.darkTheme.textTheme.titleLarge?.copyWith(
              color: AppTheme.primaryText,
              fontWeight: FontWeight.w600,
            ),
          ),
          
          SizedBox(height: AppTheme.spacingM),
          
          // Domain input
          Container(
            decoration: AppTheme.cardDecoration(),
            padding: EdgeInsets.all(AppTheme.spacingM),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Domain Name',
                  style: AppTheme.darkTheme.textTheme.titleMedium?.copyWith(
                    color: AppTheme.primaryText,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: AppTheme.spacingS),
                TextField(
                  controller: _domainController,
                  decoration: AppTheme.inputDecoration(
                    hint: 'example.com',
                    label: 'Enter your domain',
                  ),
                  keyboardType: TextInputType.url,
                ),
                SizedBox(height: AppTheme.spacingM),
                
                // Add subdomain section
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        'Add Subdomain',
                        style: AppTheme.darkTheme.textTheme.titleSmall?.copyWith(
                          color: AppTheme.primaryText,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    Switch(
                      value: false,
                      onChanged: (value) {},
                    ),
                  ],
                ),
                
                SizedBox(height: AppTheme.spacingM),
                
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _isAddingDomain ? null : _addDomain,
                    child: _isAddingDomain
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Text('Add Domain'),
                  ),
                ),
              ],
            ),
          ),
          
          SizedBox(height: AppTheme.spacingL),
          
          // Requirements
          Container(
            decoration: AppTheme.cardDecoration(),
            padding: EdgeInsets.all(AppTheme.spacingM),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.info_outline,
                      color: AppTheme.accent,
                      size: 20,
                    ),
                    SizedBox(width: AppTheme.spacingS),
                    Text(
                      'Requirements',
                      style: AppTheme.darkTheme.textTheme.titleMedium?.copyWith(
                        color: AppTheme.primaryText,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: AppTheme.spacingM),
                
                ...[
                  'You must have access to DNS settings for this domain',
                  'Domain must be registered and active',
                  'DNS propagation may take up to 24 hours',
                  'SSL certificates are automatically provisioned',
                ].map((requirement) => Padding(
                  padding: EdgeInsets.only(bottom: AppTheme.spacingS),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(
                        Icons.check_circle_outline,
                        color: AppTheme.success,
                        size: 16,
                      ),
                      SizedBox(width: AppTheme.spacingS),
                      Expanded(
                        child: Text(
                          requirement,
                          style: AppTheme.darkTheme.textTheme.bodyMedium?.copyWith(
                            color: AppTheme.secondaryText,
                          ),
                        ),
                      ),
                    ],
                  ),
                )),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDnsSetupTab() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(AppTheme.spacingM),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'DNS Configuration',
            style: AppTheme.darkTheme.textTheme.titleLarge?.copyWith(
              color: AppTheme.primaryText,
              fontWeight: FontWeight.w600,
            ),
          ),
          
          SizedBox(height: AppTheme.spacingM),
          
          // Registrar selection
          Container(
            decoration: AppTheme.cardDecoration(),
            padding: EdgeInsets.all(AppTheme.spacingM),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Select Your Registrar',
                  style: AppTheme.darkTheme.textTheme.titleMedium?.copyWith(
                    color: AppTheme.primaryText,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: AppTheme.spacingM),
                
                Wrap(
                  spacing: AppTheme.spacingS,
                  runSpacing: AppTheme.spacingS,
                  children: _registrars.map((registrar) => FilterChip(
                    label: Text(registrar.toUpperCase()),
                    selected: _selectedRegistrar == registrar,
                    onSelected: (selected) {
                      setState(() => _selectedRegistrar = registrar);
                    },
                  )).toList(),
                ),
              ],
            ),
          ),
          
          SizedBox(height: AppTheme.spacingM),
          
          // DNS Records
          Container(
            decoration: AppTheme.cardDecoration(),
            padding: EdgeInsets.all(AppTheme.spacingM),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      'Required DNS Records',
                      style: AppTheme.darkTheme.textTheme.titleMedium?.copyWith(
                        color: AppTheme.primaryText,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const Spacer(),
                    TextButton.icon(
                      onPressed: () {
                        // Copy all DNS records
                        final records = _dnsRecords.where((r) => r['required'] == true).map((r) => 
                          '${r['type']} | ${r['name']} | ${r['value']} | ${r['ttl']}'
                        ).join('\n');
                        
                        Clipboard.setData(ClipboardData(text: records));
                        _showSuccessSnackBar('DNS records copied to clipboard');
                      },
                      icon: Icon(Icons.copy, size: 16),
                      label: Text('Copy All'),
                    ),
                  ],
                ),
                SizedBox(height: AppTheme.spacingM),
                
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: DataTable(
                    headingRowColor: WidgetStateProperty.all(AppTheme.surfaceVariant),
                    headingTextStyle: AppTheme.darkTheme.textTheme.labelMedium?.copyWith(
                      color: AppTheme.primaryText,
                      fontWeight: FontWeight.w600,
                    ),
                    dataTextStyle: AppTheme.darkTheme.textTheme.bodySmall?.copyWith(
                      color: AppTheme.secondaryText,
                    ),
                    columns: const [
                      DataColumn(label: Text('Type')),
                      DataColumn(label: Text('Name')),
                      DataColumn(label: Text('Value')),
                      DataColumn(label: Text('TTL')),
                      DataColumn(label: Text('Action')),
                    ],
                    rows: _dnsRecords.where((r) => r['required'] == true).map((record) => DataRow(
                      cells: [
                        DataCell(Text(record['type'])),
                        DataCell(Text(record['name'])),
                        DataCell(
                          SizedBox(
                            width: 200,
                            child: Text(
                              record['value'],
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ),
                        DataCell(Text(record['ttl'].toString())),
                        DataCell(
                          IconButton(
                            onPressed: () {
                              Clipboard.setData(ClipboardData(text: record['value']));
                              _showSuccessSnackBar('Value copied to clipboard');
                            },
                            icon: Icon(Icons.copy, size: 16),
                          ),
                        ),
                      ],
                    )).toList(),
                  ),
                ),
              ],
            ),
          ),
          
          SizedBox(height: AppTheme.spacingM),
          
          // DNS Propagation Checker
          Container(
            decoration: AppTheme.cardDecoration(),
            padding: EdgeInsets.all(AppTheme.spacingM),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      'DNS Propagation Check',
                      style: AppTheme.darkTheme.textTheme.titleMedium?.copyWith(
                        color: AppTheme.primaryText,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const Spacer(),
                    ElevatedButton.icon(
                      onPressed: _isDnsPropagatoinChecking ? null : _checkDnsPropagation,
                      icon: _isDnsPropagatoinChecking 
                          ? const SizedBox(
                              width: 16,
                              height: 16,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : Icon(Icons.check_circle_outline),
                      label: Text('Check Now'),
                    ),
                  ],
                ),
                SizedBox(height: AppTheme.spacingM),
                
                // Global verification status
                Container(
                  padding: EdgeInsets.all(AppTheme.spacingM),
                  decoration: BoxDecoration(
                    color: AppTheme.surfaceVariant,
                    borderRadius: BorderRadius.circular(AppTheme.radiusM),
                  ),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Text(
                            'Global Propagation Status',
                            style: AppTheme.darkTheme.textTheme.titleSmall?.copyWith(
                              color: AppTheme.primaryText,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const Spacer(),
                          Text(
                            '8/12 locations',
                            style: AppTheme.darkTheme.textTheme.labelMedium?.copyWith(
                              color: AppTheme.success,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: AppTheme.spacingS),
                      LinearProgressIndicator(
                        value: 8/12,
                        backgroundColor: AppTheme.border,
                        valueColor: AlwaysStoppedAnimation<Color>(AppTheme.success),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSslCertificatesTab() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(AppTheme.spacingM),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'SSL Certificates',
            style: AppTheme.darkTheme.textTheme.titleLarge?.copyWith(
              color: AppTheme.primaryText,
              fontWeight: FontWeight.w600,
            ),
          ),
          
          SizedBox(height: AppTheme.spacingM),
          
          // Auto SSL
          Container(
            decoration: AppTheme.cardDecoration(),
            padding: EdgeInsets.all(AppTheme.spacingM),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.security,
                      color: AppTheme.success,
                      size: 24,
                    ),
                    SizedBox(width: AppTheme.spacingS),
                    Text(
                      'Automatic SSL Provisioning',
                      style: AppTheme.darkTheme.textTheme.titleMedium?.copyWith(
                        color: AppTheme.primaryText,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: AppTheme.spacingM),
                
                Container(
                  padding: EdgeInsets.all(AppTheme.spacingM),
                  decoration: BoxDecoration(
                    color: AppTheme.success.withAlpha(26),
                    borderRadius: BorderRadius.circular(AppTheme.radiusM),
                    border: Border.all(color: AppTheme.success.withAlpha(77)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.check_circle,
                            color: AppTheme.success,
                            size: 20,
                          ),
                          SizedBox(width: AppTheme.spacingS),
                          Text(
                            'SSL certificates are automatically provisioned',
                            style: AppTheme.darkTheme.textTheme.titleSmall?.copyWith(
                              color: AppTheme.success,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: AppTheme.spacingS),
                      Text(
                        'Once your domain is verified, we automatically provision and renew SSL certificates using Let\'s Encrypt. No manual intervention required.',
                        style: AppTheme.darkTheme.textTheme.bodyMedium?.copyWith(
                          color: AppTheme.secondaryText,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          
          SizedBox(height: AppTheme.spacingM),
          
          // SSL Certificate Status
          Container(
            decoration: AppTheme.cardDecoration(),
            padding: EdgeInsets.all(AppTheme.spacingM),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Certificate Status',
                  style: AppTheme.darkTheme.textTheme.titleMedium?.copyWith(
                    color: AppTheme.primaryText,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: AppTheme.spacingM),
                
                ..._domains.map((domain) => Container(
                  margin: EdgeInsets.only(bottom: AppTheme.spacingS),
                  padding: EdgeInsets.all(AppTheme.spacingM),
                  decoration: BoxDecoration(
                    color: AppTheme.surfaceVariant,
                    borderRadius: BorderRadius.circular(AppTheme.radiusS),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        domain['ssl_status'] == 'active' ? Icons.lock : Icons.lock_open,
                        color: domain['ssl_status'] == 'active' ? AppTheme.success : AppTheme.warning,
                        size: 20,
                      ),
                      SizedBox(width: AppTheme.spacingS),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              domain['domain'],
                              style: AppTheme.darkTheme.textTheme.titleSmall?.copyWith(
                                color: AppTheme.primaryText,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            if (domain['ssl_expires_at'] != null)
                              Text(
                                'Expires: ${_formatDate(domain['ssl_expires_at'])}',
                                style: AppTheme.darkTheme.textTheme.bodySmall?.copyWith(
                                  color: AppTheme.secondaryText,
                                ),
                              ),
                          ],
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: AppTheme.spacingS,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: domain['ssl_status'] == 'active' 
                              ? AppTheme.success.withAlpha(26)
                              : AppTheme.warning.withAlpha(26),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          domain['ssl_status'].toString().toUpperCase(),
                          style: AppTheme.darkTheme.textTheme.labelSmall?.copyWith(
                            color: domain['ssl_status'] == 'active' ? AppTheme.success : AppTheme.warning,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                )).toList(),
              ],
            ),
          ),
          
          SizedBox(height: AppTheme.spacingM),
          
          // Manual Certificate Upload
          Container(
            decoration: AppTheme.cardDecoration(),
            padding: EdgeInsets.all(AppTheme.spacingM),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Manual Certificate Upload',
                  style: AppTheme.darkTheme.textTheme.titleMedium?.copyWith(
                    color: AppTheme.primaryText,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: AppTheme.spacingS),
                Text(
                  'For advanced users who prefer to manage their own certificates',
                  style: AppTheme.darkTheme.textTheme.bodyMedium?.copyWith(
                    color: AppTheme.secondaryText,
                  ),
                ),
                SizedBox(height: AppTheme.spacingM),
                
                OutlinedButton.icon(
                  onPressed: () {
                    // Show upload dialog
                  },
                  icon: Icon(Icons.file_upload),
                  label: Text('Upload Certificate'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAnalyticsTab() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(AppTheme.spacingM),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Domain Analytics',
            style: AppTheme.darkTheme.textTheme.titleLarge?.copyWith(
              color: AppTheme.primaryText,
              fontWeight: FontWeight.w600,
            ),
          ),
          
          SizedBox(height: AppTheme.spacingM),
          
          // Traffic Overview
          Container(
            decoration: AppTheme.cardDecoration(),
            padding: EdgeInsets.all(AppTheme.spacingM),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Traffic Overview',
                  style: AppTheme.darkTheme.textTheme.titleMedium?.copyWith(
                    color: AppTheme.primaryText,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: AppTheme.spacingM),
                
                Row(
                  children: [
                    Expanded(
                      child: _buildMetricCard('Total Visits', '12,458', AppTheme.accent),
                    ),
                    SizedBox(width: AppTheme.spacingM),
                    Expanded(
                      child: _buildMetricCard('Unique Visitors', '8,234', AppTheme.success),
                    ),
                  ],
                ),
                SizedBox(height: AppTheme.spacingM),
                Row(
                  children: [
                    Expanded(
                      child: _buildMetricCard('Avg. Session', '2m 34s', AppTheme.warning),
                    ),
                    SizedBox(width: AppTheme.spacingM),
                    Expanded(
                      child: _buildMetricCard('Bounce Rate', '42.3%', AppTheme.error),
                    ),
                  ],
                ),
              ],
            ),
          ),
          
          SizedBox(height: AppTheme.spacingM),
          
          // Geographic Distribution
          Container(
            decoration: AppTheme.cardDecoration(),
            padding: EdgeInsets.all(AppTheme.spacingM),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Geographic Distribution',
                  style: AppTheme.darkTheme.textTheme.titleMedium?.copyWith(
                    color: AppTheme.primaryText,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: AppTheme.spacingM),
                
                ...[
                  {'country': 'United States', 'visits': '4,521', 'percentage': '36.3%'},
                  {'country': 'United Kingdom', 'visits': '2,134', 'percentage': '17.1%'},
                  {'country': 'Canada', 'visits': '1,876', 'percentage': '15.1%'},
                  {'country': 'Germany', 'visits': '1,234', 'percentage': '9.9%'},
                  {'country': 'France', 'visits': '987', 'percentage': '7.9%'},
                ].map((item) => Container(
                  margin: EdgeInsets.only(bottom: AppTheme.spacingS),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          item['country']!,
                          style: AppTheme.darkTheme.textTheme.bodyMedium?.copyWith(
                            color: AppTheme.primaryText,
                          ),
                        ),
                      ),
                      SizedBox(width: AppTheme.spacingS),
                      Text(
                        item['visits']!,
                        style: AppTheme.darkTheme.textTheme.bodyMedium?.copyWith(
                          color: AppTheme.secondaryText,
                        ),
                      ),
                      SizedBox(width: AppTheme.spacingS),
                      Text(
                        item['percentage']!,
                        style: AppTheme.darkTheme.textTheme.bodyMedium?.copyWith(
                          color: AppTheme.accent,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                )).toList(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMetricCard(String title, String value, Color color) {
    return Container(
      padding: EdgeInsets.all(AppTheme.spacingM),
      decoration: BoxDecoration(
        color: AppTheme.surfaceVariant,
        borderRadius: BorderRadius.circular(AppTheme.radiusM),
        border: Border.all(color: color.withAlpha(77)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: AppTheme.darkTheme.textTheme.labelMedium?.copyWith(
              color: AppTheme.secondaryText,
            ),
          ),
          SizedBox(height: AppTheme.spacingXs),
          Text(
            value,
            style: AppTheme.darkTheme.textTheme.titleLarge?.copyWith(
              color: color,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  void _showDeleteDialog(Map<String, dynamic> domain) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Delete Domain'),
        content: Text('Are you sure you want to delete ${domain['domain']}? This action cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _deleteDomain(domain['id']);
            },
            style: TextButton.styleFrom(
              foregroundColor: AppTheme.error,
            ),
            child: Text('Delete'),
          ),
        ],
      ),
    );
  }

  void _setPrimaryDomain(String domainId) async {
    try {
      await Future.delayed(const Duration(seconds: 1));
      
      setState(() {
        for (var domain in _domains) {
          domain['is_primary'] = domain['id'] == domainId;
        }
      });
      
      _showSuccessSnackBar('Primary domain updated successfully');
    } catch (error) {
      _showErrorSnackBar('Failed to update primary domain: $error');
    }
  }

  String _formatDate(String dateString) {
    try {
      final date = DateTime.parse(dateString);
      return '${date.day}/${date.month}/${date.year}';
    } catch (e) {
      return 'Invalid date';
    }
  }
}