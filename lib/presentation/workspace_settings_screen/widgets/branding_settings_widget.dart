import 'package:flutter/material.dart';

import '../../../core/app_export.dart';

class BrandingSettingsWidget extends StatefulWidget {
  final VoidCallback onChanged;

  const BrandingSettingsWidget({
    super.key,
    required this.onChanged,
  });

  @override
  State<BrandingSettingsWidget> createState() => _BrandingSettingsWidgetState();
}

class _BrandingSettingsWidgetState extends State<BrandingSettingsWidget> {
  late TextEditingController _companyNameController;
  late TextEditingController _taglineController;
  late TextEditingController _websiteController;
  late TextEditingController _supportEmailController;

  String? _logoUrl;
  String? _faviconUrl;
  String _primaryColor = '#007AFF';
  String _secondaryColor = '#34C759';
  bool _customBranding = true;
  bool _hideWatermark = false;

  final List<String> _brandColors = [
    '#007AFF',
    '#34C759',
    '#FF3B30',
    '#FF9500',
    '#FFCC00',
    '#AF52DE',
    '#FF2D92',
    '#5856D6',
    '#32ADE6',
    '#30B0C7',
    '#667C8A',
    '#8E8E93',
  ];

  @override
  void initState() {
    super.initState();
    _companyNameController = TextEditingController(text: 'Acme Corporation');
    _taglineController =
        TextEditingController(text: 'Innovation at its finest');
    _websiteController = TextEditingController(text: 'https://acme.com');
    _supportEmailController = TextEditingController(text: 'support@acme.com');
  }

  @override
  void dispose() {
    _companyNameController.dispose();
    _taglineController.dispose();
    _websiteController.dispose();
    _supportEmailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildBrandIdentitySection(),
          const SizedBox(height: 24),
          _buildLogosSection(),
          const SizedBox(height: 24),
          _buildColorSchemeSection(),
          const SizedBox(height: 24),
          _buildCustomBrandingSection(),
          const SizedBox(height: 24),
          _buildPreviewSection(),
        ],
      ),
    );
  }

  Widget _buildBrandIdentitySection() {
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
            'Brand Identity',
            style: GoogleFonts.inter(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: AppTheme.primaryText,
            ),
          ),
          const SizedBox(height: 16),
          _buildTextField(
            controller: _companyNameController,
            label: 'Company Name',
            hint: 'Enter your company name',
            icon: Icons.business,
          ),
          const SizedBox(height: 16),
          _buildTextField(
            controller: _taglineController,
            label: 'Tagline',
            hint: 'Enter your company tagline',
            icon: Icons.format_quote,
          ),
          const SizedBox(height: 16),
          _buildTextField(
            controller: _websiteController,
            label: 'Website',
            hint: 'Enter your website URL',
            icon: Icons.language,
          ),
          const SizedBox(height: 16),
          _buildTextField(
            controller: _supportEmailController,
            label: 'Support Email',
            hint: 'Enter support email address',
            icon: Icons.email,
          ),
        ],
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
  }) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        prefixIcon: Icon(icon, color: AppTheme.secondaryText),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: AppTheme.border),
        ),
        filled: true,
        fillColor: AppTheme.primaryBackground,
      ),
      style: GoogleFonts.inter(fontSize: 16, color: AppTheme.primaryText),
      onChanged: (_) => widget.onChanged(),
    );
  }

  Widget _buildLogosSection() {
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
            'Logos & Icons',
            style: GoogleFonts.inter(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: AppTheme.primaryText,
            ),
          ),
          const SizedBox(height: 16),
          _buildLogoUpload(
            title: 'Company Logo',
            subtitle: 'Upload your company logo (PNG, JPG, SVG)',
            imageUrl: _logoUrl,
            onUpload: () {
              // TODO: Implement logo upload
              widget.onChanged();
            },
            onRemove: () {
              setState(() {
                _logoUrl = null;
              });
              widget.onChanged();
            },
          ),
          const SizedBox(height: 16),
          _buildLogoUpload(
            title: 'Favicon',
            subtitle: 'Upload your website favicon (16x16 or 32x32)',
            imageUrl: _faviconUrl,
            onUpload: () {
              // TODO: Implement favicon upload
              widget.onChanged();
            },
            onRemove: () {
              setState(() {
                _faviconUrl = null;
              });
              widget.onChanged();
            },
          ),
        ],
      ),
    );
  }

  Widget _buildLogoUpload({
    required String title,
    required String subtitle,
    required String? imageUrl,
    required VoidCallback onUpload,
    required VoidCallback onRemove,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.primaryBackground,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppTheme.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: AppTheme.surface,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: AppTheme.border),
                ),
                child: imageUrl != null
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: CustomImageWidget(
                          imageUrl: imageUrl,
                          fit: BoxFit.cover,
                        ),
                      )
                    : const Icon(
                        Icons.image,
                        size: 30,
                        color: AppTheme.secondaryText,
                      ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: GoogleFonts.inter(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: AppTheme.primaryText,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        color: AppTheme.secondaryText,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              ElevatedButton(
                onPressed: onUpload,
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
                  imageUrl != null ? 'Replace' : 'Upload',
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              if (imageUrl != null) ...[
                const SizedBox(width: 8),
                TextButton(
                  onPressed: onRemove,
                  child: Text(
                    'Remove',
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: AppTheme.error,
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

  Widget _buildColorSchemeSection() {
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
            'Color Scheme',
            style: GoogleFonts.inter(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: AppTheme.primaryText,
            ),
          ),
          const SizedBox(height: 16),
          _buildColorPicker(
            title: 'Primary Color',
            selectedColor: _primaryColor,
            onColorChanged: (color) {
              setState(() {
                _primaryColor = color;
              });
              widget.onChanged();
            },
          ),
          const SizedBox(height: 16),
          _buildColorPicker(
            title: 'Secondary Color',
            selectedColor: _secondaryColor,
            onColorChanged: (color) {
              setState(() {
                _secondaryColor = color;
              });
              widget.onChanged();
            },
          ),
        ],
      ),
    );
  }

  Widget _buildColorPicker({
    required String title,
    required String selectedColor,
    required Function(String) onColorChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: GoogleFonts.inter(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: AppTheme.primaryText,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: AppTheme.primaryBackground,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: AppTheme.border),
          ),
          child: Column(
            children: [
              Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: Color(
                          int.parse(selectedColor.substring(1, 7), radix: 16) +
                              0xFF000000),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: AppTheme.border),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: TextFormField(
                      initialValue: selectedColor,
                      decoration: InputDecoration(
                        hintText: '#000000',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: const BorderSide(color: AppTheme.border),
                        ),
                        filled: true,
                        fillColor: AppTheme.surface,
                      ),
                      style: GoogleFonts.inter(
                          fontSize: 16, color: AppTheme.primaryText),
                      onChanged: onColorChanged,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: _brandColors.map((color) {
                  final isSelected = color == selectedColor;
                  return GestureDetector(
                    onTap: () => onColorChanged(color),
                    child: Container(
                      width: 32,
                      height: 32,
                      decoration: BoxDecoration(
                        color: Color(
                            int.parse(color.substring(1, 7), radix: 16) +
                                0xFF000000),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: isSelected
                              ? AppTheme.primaryText
                              : AppTheme.border,
                          width: isSelected ? 2 : 1,
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildCustomBrandingSection() {
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
            'Custom Branding',
            style: GoogleFonts.inter(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: AppTheme.primaryText,
            ),
          ),
          const SizedBox(height: 16),
          SwitchListTile(
            title: Text(
              'Enable Custom Branding',
              style: GoogleFonts.inter(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: AppTheme.primaryText,
              ),
            ),
            subtitle: Text(
              'Apply your brand colors and logos throughout the app',
              style: GoogleFonts.inter(
                fontSize: 14,
                color: AppTheme.secondaryText,
              ),
            ),
            value: _customBranding,
            onChanged: (value) {
              setState(() {
                _customBranding = value;
              });
              widget.onChanged();
            },
            activeColor: AppTheme.accent,
            contentPadding: EdgeInsets.zero,
          ),
          const Divider(color: AppTheme.border),
          SwitchListTile(
            title: Text(
              'Hide Platform Watermark',
              style: GoogleFonts.inter(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: AppTheme.primaryText,
              ),
            ),
            subtitle: Text(
              'Remove "Powered by" branding from public pages',
              style: GoogleFonts.inter(
                fontSize: 14,
                color: AppTheme.secondaryText,
              ),
            ),
            value: _hideWatermark,
            onChanged: (value) {
              setState(() {
                _hideWatermark = value;
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

  Widget _buildPreviewSection() {
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
            'Preview',
            style: GoogleFonts.inter(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: AppTheme.primaryText,
            ),
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppTheme.primaryBackground,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: AppTheme.border),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: Color(int.parse(_primaryColor.substring(1, 7),
                                radix: 16) +
                            0xFF000000),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(
                        Icons.business,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            _companyNameController.text.isEmpty
                                ? 'Company Name'
                                : _companyNameController.text,
                            style: GoogleFonts.inter(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: AppTheme.primaryText,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            _taglineController.text.isEmpty
                                ? 'Company tagline'
                                : _taglineController.text,
                            style: GoogleFonts.inter(
                              fontSize: 12,
                              color: AppTheme.secondaryText,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: Color(
                        int.parse(_primaryColor.substring(1, 7), radix: 16) +
                            0xFF000000),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    'Primary Action',
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: Color(
                        int.parse(_secondaryColor.substring(1, 7), radix: 16) +
                            0xFF000000),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    'Secondary Action',
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Colors.white,
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
}