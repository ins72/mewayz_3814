import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../widgets/custom_icon_widget.dart';

class TemplateCreatorWidget extends StatefulWidget {
  final Function(Map<String, dynamic>) onCreateTemplate;

  const TemplateCreatorWidget({
    Key? key,
    required this.onCreateTemplate,
  }) : super(key: key);

  @override
  State<TemplateCreatorWidget> createState() => _TemplateCreatorWidgetState();
}

class _TemplateCreatorWidgetState extends State<TemplateCreatorWidget> {
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  String _selectedCategory = 'promotional';
  String _selectedIndustry = 'General';
  List<String> _selectedPlatforms = ['Instagram'];
  List<String> _selectedColors = ['#FF6B6B', '#4ECDC4', '#45B7D1'];
  List<String> _tags = [];
  final _tagController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          // Header
          Text('Create New Template',
              style: GoogleFonts.inter(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFFF1F1F1))),
          const SizedBox(height: 8),
          Text(
              'Design and create custom templates for your social media content.',
              style: GoogleFonts.inter(
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  color: const Color(0xFF7B7B7B))),

          const SizedBox(height: 24),

          // Basic Information
          _buildSection(
              'Basic Information',
              Column(children: [
                _buildTextField('Template Title', _titleController,
                    'Enter template title...'),
                const SizedBox(height: 16),
                _buildTextField('Description', _descriptionController,
                    'Describe your template...',
                    maxLines: 3),
              ])),

          const SizedBox(height: 24),

          // Category Selection
          _buildSection(
              'Category & Industry',
              Column(children: [
                _buildDropdown(
                    'Category',
                    _selectedCategory,
                    [
                      'promotional',
                      'quotes',
                      'announcements',
                      'stories',
                      'seasonal'
                    ],
                    (value) => setState(() => _selectedCategory = value!)),
                const SizedBox(height: 16),
                _buildDropdown(
                    'Industry',
                    _selectedIndustry,
                    [
                      'General',
                      'E-commerce',
                      'Business',
                      'Events',
                      'Retail',
                      'Technology'
                    ],
                    (value) => setState(() => _selectedIndustry = value!)),
              ])),

          const SizedBox(height: 24),

          // Platform Selection
          _buildSection(
              'Platform Support',
              Column(children: [
                Text('Select platforms this template will support:',
                    style: GoogleFonts.inter(
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        color: const Color(0xFF7B7B7B))),
                const SizedBox(height: 12),
                Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      'Instagram',
                      'Facebook',
                      'Twitter',
                      'LinkedIn',
                      'TikTok'
                    ].map((platform) {
                      final isSelected = _selectedPlatforms.contains(platform);
                      return GestureDetector(
                          onTap: () {
                            setState(() {
                              if (isSelected) {
                                _selectedPlatforms.remove(platform);
                              } else {
                                _selectedPlatforms.add(platform);
                              }
                            });
                          },
                          child: Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 8),
                              decoration: BoxDecoration(
                                  color: isSelected
                                      ? const Color(0xFF3B82F6)
                                      : const Color(0xFF282828),
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(
                                      color: isSelected
                                          ? const Color(0xFF3B82F6)
                                          : const Color(0xFF282828),
                                      width: 1)),
                              child: Text(platform,
                                  style: GoogleFonts.inter(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500,
                                      color: isSelected
                                          ? const Color(0xFFF1F1F1)
                                          : const Color(0xFF7B7B7B)))));
                    }).toList()),
              ])),

          const SizedBox(height: 24),

          // Color Palette
          _buildSection(
              'Color Palette',
              Column(children: [
                Text('Choose colors for your template:',
                    style: GoogleFonts.inter(
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        color: const Color(0xFF7B7B7B))),
                const SizedBox(height: 12),
                Row(
                    children: _selectedColors.map((color) {
                  return Container(
                      width: 40,
                      height: 40,
                      margin: const EdgeInsets.only(right: 8),
                      decoration: BoxDecoration(
                          color:
                              Color(int.parse(color.replaceAll('#', '0xFF'))),
                          shape: BoxShape.circle,
                          border: Border.all(
                              color: const Color(0xFF282828), width: 2)));
                }).toList()),
                const SizedBox(height: 8),
                TextButton(
                    onPressed: () {
                      // Color picker functionality
                    },
                    child: Text('Change Colors',
                        style: GoogleFonts.inter(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: const Color(0xFF3B82F6)))),
              ])),

          const SizedBox(height: 24),

          // Tags
          _buildSection(
              'Tags',
              Column(children: [
                Row(children: [
                  Expanded(
                      child: TextField(
                          controller: _tagController,
                          style: GoogleFonts.inter(
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                              color: const Color(0xFFF1F1F1)),
                          decoration: InputDecoration(
                              hintText: 'Add tag...',
                              hintStyle: GoogleFonts.inter(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400,
                                  color: const Color(0xFF7B7B7B)),
                              filled: true,
                              fillColor: const Color(0xFF282828),
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  borderSide: BorderSide.none)),
                          onSubmitted: (value) {
                            if (value.isNotEmpty &&
                                !_tags.contains(value.toLowerCase())) {
                              setState(() {
                                _tags.add(value.toLowerCase());
                                _tagController.clear();
                              });
                            }
                          })),
                  const SizedBox(width: 8),
                  IconButton(
                    onPressed: () {
                      final value = _tagController.text.trim();
                      if (value.isNotEmpty &&
                          !_tags.contains(value.toLowerCase())) {
                        setState(() {
                          _tags.add(value.toLowerCase());
                          _tagController.clear();
                        });
                      }
                    },
                    icon: const Icon(Icons.add),
                  ),
                ]),
                const SizedBox(height: 12),
                if (_tags.isNotEmpty)
                  Wrap(
                      spacing: 6,
                      runSpacing: 6,
                      children: _tags.map((tag) {
                        return Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                                color: const Color(0xFF282828),
                                borderRadius: BorderRadius.circular(6)),
                            child:
                                Row(mainAxisSize: MainAxisSize.min, children: [
                              Text('#$tag',
                                  style: GoogleFonts.inter(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w400,
                                      color: const Color(0xFFF1F1F1))),
                              const SizedBox(width: 4),
                              GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      _tags.remove(tag);
                                    });
                                  },
                                  child: const CustomIconWidget(
                                      iconName: 'close',
                                      color: Color(0xFF7B7B7B),
                                      size: 14)),
                            ]));
                      }).toList()),
              ])),

          const SizedBox(height: 24),

          // Template Design Area
          _buildSection(
              'Template Design',
              Container(
                  width: double.infinity,
                  height: 200,
                  decoration: BoxDecoration(
                      color: const Color(0xFF282828),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                          color: const Color(0xFF3B82F6),
                          width: 2,
                          style: BorderStyle.solid)),
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const CustomIconWidget(
                            iconName: 'upload',
                            color: Color(0xFF7B7B7B),
                            size: 48),
                        const SizedBox(height: 16),
                        Text('Upload Template Design',
                            style: GoogleFonts.inter(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                color: const Color(0xFFF1F1F1))),
                        const SizedBox(height: 8),
                        Text('Drag and drop your image or click to browse',
                            style: GoogleFonts.inter(
                                fontSize: 12,
                                fontWeight: FontWeight.w400,
                                color: const Color(0xFF7B7B7B))),
                      ]))),

          const SizedBox(height: 32),

          // Action Buttons
          Row(children: [
            Expanded(
                child: OutlinedButton(
                    onPressed: () {
                      // Preview template
                    },
                    style: OutlinedButton.styleFrom(
                        side: const BorderSide(
                            color: Color(0xFF282828), width: 1),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12))),
                    child: Text('Preview',
                        style: GoogleFonts.inter(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: const Color(0xFFF1F1F1))))),
            const SizedBox(width: 12),
            Expanded(
                child: ElevatedButton(
                    onPressed: _canCreateTemplate() ? _createTemplate : null,
                    style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFFDFDFD),
                        foregroundColor: const Color(0xFF141414),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12))),
                    child: Text('Create Template',
                        style: GoogleFonts.inter(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: const Color(0xFF141414))))),
          ]),
        ]));
  }

  Widget _buildSection(String title, Widget content) {
    return Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
            color: const Color(0xFF191919),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: const Color(0xFF282828), width: 1)),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(title,
              style: GoogleFonts.inter(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFFF1F1F1))),
          const SizedBox(height: 16),
          content,
        ]));
  }

  Widget _buildTextField(
      String label, TextEditingController controller, String hint,
      {int maxLines = 1}) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(label,
          style: GoogleFonts.inter(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: const Color(0xFFF1F1F1))),
      const SizedBox(height: 8),
      TextField(
          controller: controller,
          maxLines: maxLines,
          style: GoogleFonts.inter(
              fontSize: 14,
              fontWeight: FontWeight.w400,
              color: const Color(0xFFF1F1F1)),
          decoration: InputDecoration(
              hintText: hint,
              hintStyle: GoogleFonts.inter(
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  color: const Color(0xFF7B7B7B)),
              filled: true,
              fillColor: const Color(0xFF282828),
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide.none))),
    ]);
  }

  Widget _buildDropdown(String label, String value, List<String> options,
      Function(String?) onChanged) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(label,
          style: GoogleFonts.inter(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: const Color(0xFFF1F1F1))),
      const SizedBox(height: 8),
      Container(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
              color: const Color(0xFF282828),
              borderRadius: BorderRadius.circular(8)),
          child: DropdownButton<String>(
              value: value,
              onChanged: onChanged,
              isExpanded: true,
              underline: const SizedBox(),
              dropdownColor: const Color(0xFF282828),
              style: GoogleFonts.inter(
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  color: const Color(0xFFF1F1F1)),
              items: options.map((option) {
                return DropdownMenuItem<String>(
                    value: option, child: Text(option));
              }).toList())),
    ]);
  }

  bool _canCreateTemplate() {
    return _titleController.text.isNotEmpty &&
        _descriptionController.text.isNotEmpty &&
        _selectedPlatforms.isNotEmpty;
  }

  void _createTemplate() {
    final template = {
      'title': _titleController.text,
      'description': _descriptionController.text,
      'category': _selectedCategory,
      'industry': _selectedIndustry,
      'platform': _selectedPlatforms,
      'colors': _selectedColors,
      'tags': _tags,
      'engagementScore': 0.0,
      'usageCount': 0,
      'isFavorite': false,
      'thumbnail': '', // Would be set after image upload
    };

    widget.onCreateTemplate(template);

    // Reset form
    _titleController.clear();
    _descriptionController.clear();
    setState(() {
      _selectedCategory = 'promotional';
      _selectedIndustry = 'General';
      _selectedPlatforms = ['Instagram'];
      _selectedColors = ['#FF6B6B', '#4ECDC4', '#45B7D1'];
      _tags = [];
    });
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _tagController.dispose();
    super.dispose();
  }
}
