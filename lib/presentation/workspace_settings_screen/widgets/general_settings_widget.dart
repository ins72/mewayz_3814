import '../../../core/app_export.dart';

class GeneralSettingsWidget extends StatefulWidget {
  final VoidCallback onChanged;

  const GeneralSettingsWidget({
    super.key,
    required this.onChanged,
  });

  @override
  State<GeneralSettingsWidget> createState() => _GeneralSettingsWidgetState();
}

class _GeneralSettingsWidgetState extends State<GeneralSettingsWidget> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _workspaceNameController;
  late TextEditingController _descriptionController;
  String _selectedIndustry = 'Technology';
  bool _isPublic = false;
  bool _allowGuestAccess = false;
  bool _enableNotifications = true;
  String? _logoUrl;

  final List<String> _industries = [
    'Technology',
    'Marketing',
    'Healthcare',
    'Finance',
    'Education',
    'E-commerce',
    'Real Estate',
    'Consulting',
    'Other',
  ];

  @override
  void initState() {
    super.initState();
    _workspaceNameController = TextEditingController(text: 'My Workspace');
    _descriptionController =
        TextEditingController(text: 'This is my workspace description.');
  }

  @override
  void dispose() {
    _workspaceNameController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  void _selectLogo() {
    // TODO: Implement logo selection
    widget.onChanged();
  }

  void _removeLogo() {
    setState(() {
      _logoUrl = null;
    });
    widget.onChanged();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
            key: _formKey,
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              _buildSectionHeader('Basic Information'),
              const SizedBox(height: 16),
              _buildWorkspaceNameField(),
              const SizedBox(height: 16),
              _buildDescriptionField(),
              const SizedBox(height: 16),
              _buildIndustryDropdown(),
              const SizedBox(height: 32),
              _buildSectionHeader('Logo'),
              const SizedBox(height: 16),
              _buildLogoSection(),
              const SizedBox(height: 32),
              _buildSectionHeader('Privacy Settings'),
              const SizedBox(height: 16),
              _buildPrivacySettings(),
              const SizedBox(height: 32),
              _buildSectionHeader('Notifications'),
              const SizedBox(height: 16),
              _buildNotificationSettings(),
            ])));
  }

  Widget _buildSectionHeader(String title) {
    return Text(title,
        style: GoogleFonts.inter(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: AppTheme.primaryText));
  }

  Widget _buildWorkspaceNameField() {
    return TextFormField(
        controller: _workspaceNameController,
        decoration: InputDecoration(
            labelText: 'Workspace Name',
            hintText: 'Enter workspace name',
            prefixIcon:
                const Icon(Icons.business, color: AppTheme.secondaryText),
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: AppTheme.border)),
            filled: true,
            fillColor: AppTheme.surface),
        style: GoogleFonts.inter(fontSize: 16, color: AppTheme.primaryText),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please enter workspace name';
          }
          return null;
        },
        onChanged: (_) => widget.onChanged());
  }

  Widget _buildDescriptionField() {
    return TextFormField(
        controller: _descriptionController,
        decoration: InputDecoration(
            labelText: 'Description',
            hintText: 'Enter workspace description',
            prefixIcon:
                const Icon(Icons.description, color: AppTheme.secondaryText),
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: AppTheme.border)),
            filled: true,
            fillColor: AppTheme.surface),
        style: GoogleFonts.inter(fontSize: 16, color: AppTheme.primaryText),
        maxLines: 3,
        onChanged: (_) => widget.onChanged());
  }

  Widget _buildIndustryDropdown() {
    return Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
            color: AppTheme.surface,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppTheme.border)),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text('Industry',
              style: GoogleFonts.inter(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: AppTheme.primaryText)),
          const SizedBox(height: 8),
          DropdownButtonFormField<String>(
              value: _selectedIndustry,
              decoration: const InputDecoration(
                  border: InputBorder.none, contentPadding: EdgeInsets.zero),
              style:
                  GoogleFonts.inter(fontSize: 16, color: AppTheme.primaryText),
              dropdownColor: AppTheme.surface,
              items: _industries.map((industry) {
                return DropdownMenuItem(value: industry, child: Text(industry));
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _selectedIndustry = value!;
                });
                widget.onChanged();
              }),
        ]));
  }

  Widget _buildLogoSection() {
    return Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
            color: AppTheme.surface,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppTheme.border)),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(children: [
            Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                    color: AppTheme.primaryBackground,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: AppTheme.border)),
                child: _logoUrl != null
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: CustomImageWidget(
                            imageUrl: _logoUrl!, fit: BoxFit.cover))
                    : const Icon(Icons.business,
                        size: 40, color: AppTheme.secondaryText)),
            const SizedBox(width: 16),
            Expanded(
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                  Text('Workspace Logo',
                      style: GoogleFonts.inter(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: AppTheme.primaryText)),
                  const SizedBox(height: 4),
                  Text('Upload a logo for your workspace',
                      style: GoogleFonts.inter(
                          fontSize: 12, color: AppTheme.secondaryText)),
                ])),
          ]),
          const SizedBox(height: 16),
          Row(children: [
            ElevatedButton(
                onPressed: _selectLogo,
                style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.primaryAction,
                    foregroundColor: AppTheme.primaryBackground,
                    padding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8))),
                child: Text(_logoUrl != null ? 'Replace' : 'Upload',
                    style: GoogleFonts.inter(
                        fontSize: 14, fontWeight: FontWeight.w500))),
            if (_logoUrl != null) ...[
              const SizedBox(width: 8),
              TextButton(
                  onPressed: _removeLogo,
                  child: Text('Remove',
                      style: GoogleFonts.inter(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: AppTheme.error))),
            ],
          ]),
        ]));
  }

  Widget _buildPrivacySettings() {
    return Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
            color: AppTheme.surface,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppTheme.border)),
        child: Column(children: [
          _buildSwitchTile(
              title: 'Public Workspace',
              subtitle: 'Make this workspace visible to everyone',
              value: _isPublic,
              onChanged: (value) {
                setState(() {
                  _isPublic = value;
                });
                widget.onChanged();
              }),
          const Divider(color: AppTheme.border),
          _buildSwitchTile(
              title: 'Allow Guest Access',
              subtitle: 'Allow non-members to view public content',
              value: _allowGuestAccess,
              onChanged: (value) {
                setState(() {
                  _allowGuestAccess = value;
                });
                widget.onChanged();
              }),
        ]));
  }

  Widget _buildNotificationSettings() {
    return Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
            color: AppTheme.surface,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppTheme.border)),
        child: _buildSwitchTile(
            title: 'Enable Notifications',
            subtitle: 'Receive notifications for workspace activities',
            value: _enableNotifications,
            onChanged: (value) {
              setState(() {
                _enableNotifications = value;
              });
              widget.onChanged();
            }));
  }

  Widget _buildSwitchTile({
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return SwitchListTile(
        title: Text(title,
            style: GoogleFonts.inter(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: AppTheme.primaryText)),
        subtitle: Text(subtitle,
            style:
                GoogleFonts.inter(fontSize: 14, color: AppTheme.secondaryText)),
        value: value,
        onChanged: onChanged,
        activeColor: AppTheme.accent,
        contentPadding: EdgeInsets.zero);
  }
}