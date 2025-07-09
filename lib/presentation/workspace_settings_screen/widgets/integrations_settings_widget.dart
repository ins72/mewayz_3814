import '../../../core/app_export.dart';

class IntegrationsSettingsWidget extends StatefulWidget {
  final VoidCallback onChanged;

  const IntegrationsSettingsWidget({
    super.key,
    required this.onChanged,
  });

  @override
  State<IntegrationsSettingsWidget> createState() =>
      _IntegrationsSettingsWidgetState();
}

class _IntegrationsSettingsWidgetState
    extends State<IntegrationsSettingsWidget> {
  final List<Integration> _integrations = [
    Integration(
      id: 'slack',
      name: 'Slack',
      description: 'Team communication and notifications',
      logoUrl:
          'https://images.unsplash.com/photo-1611224923853-80b023f02d71?w=100&h=100&fit=crop',
      category: 'Communication',
      isConnected: true,
      isEnabled: true,
    ),
    Integration(
      id: 'google_drive',
      name: 'Google Drive',
      description: 'File storage and sharing',
      logoUrl:
          'https://images.unsplash.com/photo-1573804633927-bfcbcd909acd?w=100&h=100&fit=crop',
      category: 'Storage',
      isConnected: true,
      isEnabled: false,
    ),
    Integration(
      id: 'github',
      name: 'GitHub',
      description: 'Code repository and version control',
      logoUrl:
          'https://images.unsplash.com/photo-1618401471353-b98afee0b2eb?w=100&h=100&fit=crop',
      category: 'Development',
      isConnected: false,
      isEnabled: false,
    ),
    Integration(
      id: 'zoom',
      name: 'Zoom',
      description: 'Video conferencing and meetings',
      logoUrl:
          'https://images.unsplash.com/photo-1588196749597-9ff075ee6b5b?w=100&h=100&fit=crop',
      category: 'Communication',
      isConnected: false,
      isEnabled: false,
    ),
    Integration(
      id: 'trello',
      name: 'Trello',
      description: 'Project management and task tracking',
      logoUrl:
          'https://images.unsplash.com/photo-1611224923853-80b023f02d71?w=100&h=100&fit=crop',
      category: 'Productivity',
      isConnected: false,
      isEnabled: false,
    ),
    Integration(
      id: 'mailchimp',
      name: 'Mailchimp',
      description: 'Email marketing and automation',
      logoUrl:
          'https://images.unsplash.com/photo-1596526131083-e8c633c948d2?w=100&h=100&fit=crop',
      category: 'Marketing',
      isConnected: false,
      isEnabled: false,
    ),
  ];

  final List<String> _categories = [
    'All',
    'Communication',
    'Storage',
    'Development',
    'Productivity',
    'Marketing'
  ];
  String _selectedCategory = 'All';
  String _searchQuery = '';

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(),
          const SizedBox(height: 24),
          _buildConnectedIntegrations(),
          const SizedBox(height: 24),
          _buildAvailableIntegrations(),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'Integrations',
          style: GoogleFonts.inter(
            fontSize: 24,
            fontWeight: FontWeight.w600,
            color: AppTheme.primaryText,
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: AppTheme.accent.withAlpha(26),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            '${_integrations.where((i) => i.isConnected).length} connected',
            style: GoogleFonts.inter(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: AppTheme.accent,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildConnectedIntegrations() {
    final connectedIntegrations =
        _integrations.where((i) => i.isConnected).toList();

    if (connectedIntegrations.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Connected Integrations',
          style: GoogleFonts.inter(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: AppTheme.primaryText,
          ),
        ),
        const SizedBox(height: 16),
        ...connectedIntegrations
            .map((integration) => _buildIntegrationCard(integration)),
      ],
    );
  }

  Widget _buildAvailableIntegrations() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Available Integrations',
          style: GoogleFonts.inter(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: AppTheme.primaryText,
          ),
        ),
        const SizedBox(height: 16),
        _buildSearchAndFilter(),
        const SizedBox(height: 16),
        ..._getFilteredIntegrations()
            .map((integration) => _buildIntegrationCard(integration)),
      ],
    );
  }

  Widget _buildSearchAndFilter() {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: TextFormField(
                decoration: InputDecoration(
                  hintText: 'Search integrations...',
                  prefixIcon:
                      const Icon(Icons.search, color: AppTheme.secondaryText),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(color: AppTheme.border),
                  ),
                  filled: true,
                  fillColor: AppTheme.surface,
                ),
                style: GoogleFonts.inter(
                    fontSize: 16, color: AppTheme.primaryText),
                onChanged: (value) {
                  setState(() {
                    _searchQuery = value;
                  });
                },
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: _categories.map((category) {
              final isSelected = category == _selectedCategory;
              return Container(
                margin: const EdgeInsets.only(right: 8),
                child: FilterChip(
                  label: Text(
                    category,
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: isSelected
                          ? AppTheme.primaryBackground
                          : AppTheme.primaryText,
                    ),
                  ),
                  selected: isSelected,
                  onSelected: (selected) {
                    setState(() {
                      _selectedCategory = category;
                    });
                  },
                  backgroundColor: AppTheme.surface,
                  selectedColor: AppTheme.accent,
                  side: BorderSide(
                    color: isSelected ? AppTheme.accent : AppTheme.border,
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }

  Widget _buildIntegrationCard(Integration integration) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppTheme.border),
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: AppTheme.border),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: CustomImageWidget(
                imageUrl: integration.logoUrl,
                fit: BoxFit.cover,
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      integration.name,
                      style: GoogleFonts.inter(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: AppTheme.primaryText,
                      ),
                    ),
                    const SizedBox(width: 8),
                    if (integration.isConnected)
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: AppTheme.success.withAlpha(26),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          'Connected',
                          style: GoogleFonts.inter(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: AppTheme.success,
                          ),
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  integration.description,
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    color: AppTheme.secondaryText,
                  ),
                ),
                const SizedBox(height: 4),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppTheme.accent.withAlpha(26),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    integration.category,
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: AppTheme.accent,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 16),
          Column(
            children: [
              if (integration.isConnected) ...[
                Switch(
                  value: integration.isEnabled,
                  onChanged: (value) {
                    setState(() {
                      integration.isEnabled = value;
                    });
                    widget.onChanged();
                  },
                  activeColor: AppTheme.accent,
                ),
                const SizedBox(height: 8),
                PopupMenuButton<String>(
                  icon: const Icon(Icons.more_vert,
                      color: AppTheme.secondaryText),
                  color: AppTheme.surface,
                  onSelected: (value) {
                    _handleIntegrationAction(integration, value);
                  },
                  itemBuilder: (context) => [
                    PopupMenuItem(
                      value: 'configure',
                      child: Text(
                        'Configure',
                        style: GoogleFonts.inter(color: AppTheme.primaryText),
                      ),
                    ),
                    PopupMenuItem(
                      value: 'disconnect',
                      child: Text(
                        'Disconnect',
                        style: GoogleFonts.inter(color: AppTheme.error),
                      ),
                    ),
                  ],
                ),
              ] else ...[
                ElevatedButton(
                  onPressed: () => _connectIntegration(integration),
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
                    'Connect',
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }

  List<Integration> _getFilteredIntegrations() {
    var filtered = _integrations.where((i) => !i.isConnected).toList();

    if (_selectedCategory != 'All') {
      filtered =
          filtered.where((i) => i.category == _selectedCategory).toList();
    }

    if (_searchQuery.isNotEmpty) {
      filtered = filtered
          .where((i) =>
              i.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
              i.description.toLowerCase().contains(_searchQuery.toLowerCase()))
          .toList();
    }

    return filtered;
  }

  void _connectIntegration(Integration integration) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'Connect ${integration.name}',
          style: GoogleFonts.inter(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: AppTheme.primaryText,
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'You will be redirected to ${integration.name} to authorize this connection.',
              style: GoogleFonts.inter(
                fontSize: 14,
                color: AppTheme.secondaryText,
              ),
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppTheme.accent.withAlpha(26),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  const Icon(Icons.info_outline,
                      color: AppTheme.accent, size: 20),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'This integration will have access to your workspace data.',
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        color: AppTheme.accent,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(
              'Cancel',
              style: GoogleFonts.inter(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: AppTheme.secondaryText,
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              _processConnection(integration);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.primaryAction,
              foregroundColor: AppTheme.primaryBackground,
            ),
            child: Text(
              'Connect',
              style: GoogleFonts.inter(
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _processConnection(Integration integration) {
    // TODO: Implement actual connection process
    setState(() {
      integration.isConnected = true;
      integration.isEnabled = true;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          '${integration.name} connected successfully',
          style: GoogleFonts.inter(fontSize: 14, color: AppTheme.primaryText),
        ),
        backgroundColor: AppTheme.success,
      ),
    );

    widget.onChanged();
  }

  void _handleIntegrationAction(Integration integration, String action) {
    switch (action) {
      case 'configure':
        _configureIntegration(integration);
        break;
      case 'disconnect':
        _disconnectIntegration(integration);
        break;
    }
  }

  void _configureIntegration(Integration integration) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'Configure ${integration.name}',
          style: GoogleFonts.inter(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: AppTheme.primaryText,
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Configure settings for ${integration.name} integration.',
              style: GoogleFonts.inter(
                fontSize: 14,
                color: AppTheme.secondaryText,
              ),
            ),
            const SizedBox(height: 16),
            // TODO: Add specific configuration options based on integration type
            TextFormField(
              decoration: InputDecoration(
                labelText: 'API Key',
                hintText: 'Enter API key',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: const BorderSide(color: AppTheme.border),
                ),
                filled: true,
                fillColor: AppTheme.surface,
              ),
              style:
                  GoogleFonts.inter(fontSize: 16, color: AppTheme.primaryText),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(
              'Cancel',
              style: GoogleFonts.inter(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: AppTheme.secondaryText,
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              // TODO: Implement configuration save
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    '${integration.name} configuration saved',
                    style: GoogleFonts.inter(
                        fontSize: 14, color: AppTheme.primaryText),
                  ),
                  backgroundColor: AppTheme.success,
                ),
              );
              widget.onChanged();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.primaryAction,
              foregroundColor: AppTheme.primaryBackground,
            ),
            child: Text(
              'Save',
              style: GoogleFonts.inter(
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _disconnectIntegration(Integration integration) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'Disconnect ${integration.name}',
          style: GoogleFonts.inter(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: AppTheme.primaryText,
          ),
        ),
        content: Text(
          'Are you sure you want to disconnect ${integration.name}? This will remove all associated data and settings.',
          style: GoogleFonts.inter(
            fontSize: 14,
            color: AppTheme.secondaryText,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(
              'Cancel',
              style: GoogleFonts.inter(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: AppTheme.secondaryText,
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              setState(() {
                integration.isConnected = false;
                integration.isEnabled = false;
              });

              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    '${integration.name} disconnected',
                    style: GoogleFonts.inter(
                        fontSize: 14, color: AppTheme.primaryText),
                  ),
                  backgroundColor: AppTheme.warning,
                ),
              );

              widget.onChanged();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.error,
              foregroundColor: AppTheme.primaryBackground,
            ),
            child: Text(
              'Disconnect',
              style: GoogleFonts.inter(
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class Integration {
  final String id;
  final String name;
  final String description;
  final String logoUrl;
  final String category;
  bool isConnected;
  bool isEnabled;

  Integration({
    required this.id,
    required this.name,
    required this.description,
    required this.logoUrl,
    required this.category,
    required this.isConnected,
    required this.isEnabled,
  });
}