import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../widgets/custom_icon_widget.dart';

class HashtagGeneratorWidget extends StatefulWidget {
  final Function(String) onGenerate;

  const HashtagGeneratorWidget({
    Key? key,
    required this.onGenerate,
  }) : super(key: key);

  @override
  State<HashtagGeneratorWidget> createState() => _HashtagGeneratorWidgetState();
}

class _HashtagGeneratorWidgetState extends State<HashtagGeneratorWidget> {
  final TextEditingController _controller = TextEditingController();
  bool _isGenerating = false;
  List<String> _generatedHashtags = [];

  void _generateHashtags() {
    if (_controller.text.trim().isEmpty) return;

    setState(() {
      _isGenerating = true;
    });

    // Mock generation
    final mockHashtags = [
      '#marketing',
      '#digitalmarketing',
      '#contentmarketing',
      '#socialmediamarketing',
      '#marketingstrategy',
      '#branding',
      '#business',
      '#entrepreneur',
      '#startup',
      '#growth',
      '#strategy',
      '#success',
      '#innovation',
      '#leadership',
      '#motivation',
    ];

    Future.delayed(const Duration(seconds: 2), () {
      setState(() {
        _isGenerating = false;
        _generatedHashtags = mockHashtags.take(10).toList();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          // Header
          Text('AI Hashtag Generator',
              style: GoogleFonts.inter(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFFF1F1F1))),
          const SizedBox(height: 8),
          Text(
              'Describe your content and we\'ll generate relevant hashtags for you.',
              style: GoogleFonts.inter(
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  color: const Color(0xFF7B7B7B))),

          const SizedBox(height: 24),

          // Input Section
          Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                  color: const Color(0xFF191919),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: const Color(0xFF282828), width: 1)),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Content Description',
                        style: GoogleFonts.inter(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: const Color(0xFFF1F1F1))),
                    const SizedBox(height: 12),
                    TextField(
                        controller: _controller,
                        maxLines: 4,
                        style: GoogleFonts.inter(
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                            color: const Color(0xFFF1F1F1)),
                        decoration: InputDecoration(
                            hintText:
                                'e.g., Digital marketing tips for small businesses...',
                            hintStyle: GoogleFonts.inter(
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                                color: const Color(0xFF7B7B7B)),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: const BorderSide(
                                    color: Color(0xFF282828), width: 1)),
                            enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: const BorderSide(
                                    color: Color(0xFF282828), width: 1)),
                            focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: const BorderSide(
                                    color: Color(0xFF3B82F6), width: 2)),
                            fillColor: const Color(0xFF282828),
                            filled: true)),
                    const SizedBox(height: 16),
                    SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                            onPressed: _isGenerating ? null : _generateHashtags,
                            style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFFFDFDFD),
                                foregroundColor: const Color(0xFF141414),
                                padding:
                                    const EdgeInsets.symmetric(vertical: 16),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8))),
                            child: _isGenerating
                                ? Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                        const SizedBox(
                                            width: 16,
                                            height: 16,
                                            child: CircularProgressIndicator(
                                                color: Color(0xFF141414),
                                                strokeWidth: 2)),
                                        const SizedBox(width: 8),
                                        Text('Generating...',
                                            style: GoogleFonts.inter(
                                                fontSize: 14,
                                                fontWeight: FontWeight.w500,
                                                color:
                                                    const Color(0xFF141414))),
                                      ])
                                : Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                        const CustomIconWidget(
                                            iconName: 'auto_awesome',
                                            color: Color(0xFF141414),
                                            size: 16),
                                        const SizedBox(width: 8),
                                        Text('Generate Hashtags',
                                            style: GoogleFonts.inter(
                                                fontSize: 14,
                                                fontWeight: FontWeight.w500,
                                                color:
                                                    const Color(0xFF141414))),
                                      ]))),
                  ])),

          const SizedBox(height: 24),

          // Generated Hashtags
          if (_generatedHashtags.isNotEmpty) ...[
            Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                    color: const Color(0xFF191919),
                    borderRadius: BorderRadius.circular(12),
                    border:
                        Border.all(color: const Color(0xFF282828), width: 1)),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(children: [
                        Expanded(
                            child: Text('Generated Hashtags',
                                style: GoogleFonts.inter(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    color: const Color(0xFFF1F1F1)))),
                        TextButton(
                            onPressed: () {
                              // Copy all hashtags
                            },
                            child:
                                Row(mainAxisSize: MainAxisSize.min, children: [
                              const CustomIconWidget(
                                  iconName: 'copy',
                                  color: Color(0xFF3B82F6),
                                  size: 16),
                              const SizedBox(width: 4),
                              Text('Copy All',
                                  style: GoogleFonts.inter(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500,
                                      color: const Color(0xFF3B82F6))),
                            ])),
                      ]),
                      const SizedBox(height: 12),
                      Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: _generatedHashtags.map((hashtag) {
                            return GestureDetector(
                                onTap: () {
                                  // Copy individual hashtag
                                },
                                child: Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 12, vertical: 6),
                                    decoration: BoxDecoration(
                                        color: const Color(0xFF282828),
                                        borderRadius: BorderRadius.circular(8),
                                        border: Border.all(
                                            color: const Color(0xFF3B82F6)
                                                .withAlpha(77),
                                            width: 1)),
                                    child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Text(hashtag,
                                              style: GoogleFonts.inter(
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.w400,
                                                  color:
                                                      const Color(0xFFF1F1F1))),
                                          const SizedBox(width: 6),
                                          const CustomIconWidget(
                                              iconName: 'copy',
                                              color: Color(0xFF7B7B7B),
                                              size: 12),
                                        ])));
                          }).toList()),
                      const SizedBox(height: 16),
                      Row(children: [
                        Expanded(
                            child: OutlinedButton(
                                onPressed: () {
                                  // Save as set
                                },
                                style: OutlinedButton.styleFrom(
                                    side: const BorderSide(
                                        color: Color(0xFF282828), width: 1),
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(8))),
                                child: Text('Save as Set',
                                    style: GoogleFonts.inter(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500,
                                        color: const Color(0xFFF1F1F1))))),
                        const SizedBox(width: 12),
                        Expanded(
                            child: ElevatedButton(
                                onPressed: () {
                                  // Use hashtags
                                },
                                style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xFF3B82F6),
                                    foregroundColor: const Color(0xFFF1F1F1),
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(8))),
                                child: Text('Use Hashtags',
                                    style: GoogleFonts.inter(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500,
                                        color: const Color(0xFFF1F1F1))))),
                      ]),
                    ])),
          ],
        ]));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
