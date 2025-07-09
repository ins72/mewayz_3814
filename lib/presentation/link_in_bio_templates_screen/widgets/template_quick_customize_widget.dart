import '../../../core/app_export.dart';

class TemplateQuickCustomizeWidget extends StatefulWidget {
  final String templateId;
  final Function(String, Map<String, dynamic>) onApplyChanges;

  const TemplateQuickCustomizeWidget({
    Key? key,
    required this.templateId,
    required this.onApplyChanges,
  }) : super(key: key);

  @override
  State<TemplateQuickCustomizeWidget> createState() => _TemplateQuickCustomizeWidgetState();
}

class _TemplateQuickCustomizeWidgetState extends State<TemplateQuickCustomizeWidget> {
  late ScrollController _scrollController;
  
  // Customization options
  int _selectedColorScheme = 0;
  int _selectedFontFamily = 0;
  String _profileName = 'John Doe';
  String _profileBio = 'Creative Designer';
  String _profileImageUrl = '';
  
  // Rename the custom ColorScheme class to avoid conflict
  final List<CustomColorScheme> _colorSchemes = [
    CustomColorScheme(name: 'Default', primary: AppTheme.accent, secondary: AppTheme.surface),
    CustomColorScheme(name: 'Purple', primary: const Color(0xFF8B5CF6), secondary: const Color(0xFF1E1B4B)),
    CustomColorScheme(name: 'Green', primary: const Color(0xFF10B981), secondary: const Color(0xFF064E3B)),
    CustomColorScheme(name: 'Orange', primary: const Color(0xFFF59E0B), secondary: const Color(0xFF92400E)),
    CustomColorScheme(name: 'Pink', primary: const Color(0xFFEC4899), secondary: const Color(0xFF831843)),
    CustomColorScheme(name: 'Teal', primary: const Color(0xFF14B8A6), secondary: const Color(0xFF134E4A)),
  ];

  final List<String> _fontFamilies = [
    'Inter',
    'Roboto',
    'Poppins',
    'Montserrat',
    'Open Sans',
    'Lato',
  ];

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _applyChanges() {
    final customizations = {
      'colorScheme': _selectedColorScheme,
      'fontFamily': _selectedFontFamily,
      'profileName': _profileName,
      'profileBio': _profileBio,
      'profileImageUrl': _profileImageUrl,
    };
    
    widget.onApplyChanges(widget.templateId, customizations);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.8,
      decoration: BoxDecoration(
        color: AppTheme.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        children: [
          // Header
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: AppTheme.border,
                  width: 1,
                ),
              ),
            ),
            child: Row(
              children: [
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Icon(
                    Icons.close,
                    color: AppTheme.secondaryText,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Text(
                    'Quick Customize',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: AppTheme.primaryText,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                TextButton(
                  onPressed: _applyChanges,
                  child: Text(
                    'Apply',
                    style: Theme.of(context).textTheme.labelLarge?.copyWith(
                      color: AppTheme.accent,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
          
          // Content
          Expanded(
            child: SingleChildScrollView(
              controller: _scrollController,
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Profile information
                  _buildSection(
                    title: 'Profile Information',
                    child: Column(
                      children: [
                        _buildInputField(
                          label: 'Name',
                          value: _profileName,
                          onChanged: (value) => setState(() => _profileName = value),
                        ),
                        const SizedBox(height: 16),
                        _buildInputField(
                          label: 'Bio',
                          value: _profileBio,
                          onChanged: (value) => setState(() => _profileBio = value),
                        ),
                      ],
                    ),
                  ),
                  
                  const SizedBox(height: 24),
                  
                  // Color schemes
                  _buildSection(
                    title: 'Color Scheme',
                    child: GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        crossAxisSpacing: 8,
                        mainAxisSpacing: 8,
                        childAspectRatio: 2.5,
                      ),
                      itemCount: _colorSchemes.length,
                      itemBuilder: (context, index) {
                        final colorScheme = _colorSchemes[index];
                        final isSelected = _selectedColorScheme == index;
                        
                        return GestureDetector(
                          onTap: () => setState(() => _selectedColorScheme = index),
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                color: isSelected ? colorScheme.primary : AppTheme.border,
                                width: 2,
                              ),
                            ),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Container(
                                    height: double.infinity,
                                    decoration: BoxDecoration(
                                      color: colorScheme.primary,
                                      borderRadius: const BorderRadius.only(
                                        topLeft: Radius.circular(6),
                                        bottomLeft: Radius.circular(6),
                                      ),
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: Container(
                                    height: double.infinity,
                                    decoration: BoxDecoration(
                                      color: colorScheme.secondary,
                                      borderRadius: const BorderRadius.only(
                                        topRight: Radius.circular(6),
                                        bottomRight: Radius.circular(6),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  
                  const SizedBox(height: 24),
                  
                  // Font families
                  _buildSection(
                    title: 'Font Family',
                    child: Column(
                      children: _fontFamilies.asMap().entries.map((entry) {
                        final index = entry.key;
                        final fontFamily = entry.value;
                        final isSelected = _selectedFontFamily == index;
                        
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 8),
                          child: GestureDetector(
                            onTap: () => setState(() => _selectedFontFamily = index),
                            child: Container(
                              width: double.infinity,
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: isSelected ? AppTheme.accent.withAlpha(26) : AppTheme.primaryBackground,
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(
                                  color: isSelected ? AppTheme.accent : AppTheme.border,
                                  width: 1,
                                ),
                              ),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      fontFamily,
                                      style: GoogleFonts.getFont(
                                        fontFamily.toLowerCase().replaceAll(' ', ''),
                                        fontSize: 16,
                                        fontWeight: FontWeight.w400,
                                        color: AppTheme.primaryText,
                                      ),
                                    ),
                                  ),
                                  if (isSelected)
                                    Icon(
                                      Icons.check_circle,
                                      color: AppTheme.accent,
                                      size: 20,
                                    ),
                                ],
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                  
                  const SizedBox(height: 24),
                  
                  // Preview
                  _buildSection(
                    title: 'Preview',
                    child: _buildPreview(),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSection({required String title, required Widget child}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            color: AppTheme.primaryText,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 12),
        child,
      ],
    );
  }

  Widget _buildInputField({
    required String label,
    required String value,
    required Function(String) onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: Theme.of(context).textTheme.labelMedium?.copyWith(
            color: AppTheme.secondaryText,
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: TextEditingController(text: value),
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: AppTheme.primaryText,
          ),
          decoration: InputDecoration(
            hintText: 'Enter $label',
            hintStyle: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: AppTheme.secondaryText,
            ),
            fillColor: AppTheme.primaryBackground,
            filled: true,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: AppTheme.border),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: AppTheme.accent),
            ),
          ),
          onChanged: onChanged,
        ),
      ],
    );
  }

  Widget _buildPreview() {
    final selectedColorScheme = _colorSchemes[_selectedColorScheme];
    final selectedFontFamily = _fontFamilies[_selectedFontFamily];
    
    return Container(
      width: double.infinity,
      height: 200,
      decoration: BoxDecoration(
        color: AppTheme.primaryBackground,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppTheme.border),
      ),
      child: Column(
        children: [
          // Header
          Container(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: selectedColorScheme.primary,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Icon(
                    Icons.person,
                    color: AppTheme.primaryText,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _profileName,
                        style: GoogleFonts.getFont(
                          selectedFontFamily.toLowerCase().replaceAll(' ', ''),
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: AppTheme.primaryText,
                        ),
                      ),
                      Text(
                        _profileBio,
                        style: GoogleFonts.getFont(
                          selectedFontFamily.toLowerCase().replaceAll(' ', ''),
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          color: AppTheme.secondaryText,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          
          // Sample link
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: selectedColorScheme.secondary,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: selectedColorScheme.primary),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.link,
                    color: selectedColorScheme.primary,
                    size: 20,
                  ),
                  const SizedBox(width: 12),
                  Text(
                    'Sample Link',
                    style: GoogleFonts.getFont(
                      selectedFontFamily.toLowerCase().replaceAll(' ', ''),
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: AppTheme.primaryText,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class CustomColorScheme {
  final String name;
  final Color primary;
  final Color secondary;

  CustomColorScheme({
    required this.name,
    required this.primary,
    required this.secondary,
  });
}