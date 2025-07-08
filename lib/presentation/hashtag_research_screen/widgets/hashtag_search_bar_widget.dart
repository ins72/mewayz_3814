import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../widgets/custom_icon_widget.dart';

class HashtagSearchBarWidget extends StatefulWidget {
  final Function(String) onSearchChanged;
  final VoidCallback onVoiceSearch;

  const HashtagSearchBarWidget({
    Key? key,
    required this.onSearchChanged,
    required this.onVoiceSearch,
  }) : super(key: key);

  @override
  State<HashtagSearchBarWidget> createState() => _HashtagSearchBarWidgetState();
}

class _HashtagSearchBarWidgetState extends State<HashtagSearchBarWidget> {
  final TextEditingController _controller = TextEditingController();
  bool _isExpanded = false;

  final List<String> _trendingSuggestions = [
    '#marketing',
    '#entrepreneur',
    '#smallbusiness',
    '#contentcreator',
    '#socialmedia',
    '#digitalmarketing',
    '#branding',
    '#startup',
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.all(16),
        color: const Color(0xFF101010),
        child: Column(children: [
          // Search Input
          Container(
              decoration: BoxDecoration(
                  color: const Color(0xFF191919),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: const Color(0xFF282828), width: 1)),
              child: TextField(
                  controller: _controller,
                  style: GoogleFonts.inter(
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                      color: const Color(0xFFF1F1F1)),
                  decoration: InputDecoration(
                      hintText: 'Search hashtags...',
                      hintStyle: GoogleFonts.inter(
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                          color: const Color(0xFF7B7B7B)),
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 16),
                      prefixIcon: const Padding(
                          padding: EdgeInsets.all(12),
                          child: CustomIconWidget(
                              iconName: 'search',
                              color: Color(0xFF7B7B7B),
                              size: 20)),
                      suffixIcon:
                          Row(mainAxisSize: MainAxisSize.min, children: [
                        if (_controller.text.isNotEmpty)
                          IconButton(
                              icon: const Icon(Icons.clear),
                              onPressed: () {
                                _controller.clear();
                                widget.onSearchChanged('');
                              }),
                        IconButton(
                            icon: const Icon(Icons.mic),
                            onPressed: widget.onVoiceSearch),
                        IconButton(
                            icon: const Icon(Icons.expand_more),
                            onPressed: () {
                              setState(() {
                                _isExpanded = !_isExpanded;
                              });
                            }),
                      ])),
                  onChanged: widget.onSearchChanged)),

          // Trending Suggestions
          AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              height: _isExpanded ? 100 : 0,
              child: _isExpanded
                  ? Container(
                      margin: const EdgeInsets.only(top: 8),
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                          color: const Color(0xFF191919),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                              color: const Color(0xFF282828), width: 1)),
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(children: [
                              const CustomIconWidget(
                                  iconName: 'trending',
                                  color: Color(0xFF3B82F6),
                                  size: 16),
                              const SizedBox(width: 6),
                              Text('Trending Now',
                                  style: GoogleFonts.inter(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500,
                                      color: const Color(0xFF7B7B7B))),
                            ]),
                            const SizedBox(height: 8),
                            Expanded(
                                child: SingleChildScrollView(
                                    scrollDirection: Axis.horizontal,
                                    child: Row(
                                        children:
                                            _trendingSuggestions.map((hashtag) {
                                      return GestureDetector(
                                          onTap: () {
                                            _controller.text = hashtag;
                                            widget.onSearchChanged(hashtag);
                                            setState(() {
                                              _isExpanded = false;
                                            });
                                          },
                                          child: Container(
                                              margin: const EdgeInsets.only(
                                                  right: 8),
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 8,
                                                      vertical: 4),
                                              decoration: BoxDecoration(
                                                  color:
                                                      const Color(0xFF282828),
                                                  borderRadius:
                                                      BorderRadius.circular(6)),
                                              child: Text(hashtag,
                                                  style: GoogleFonts.inter(
                                                      fontSize: 11,
                                                      fontWeight:
                                                          FontWeight.w400,
                                                      color: const Color(
                                                          0xFFF1F1F1)))));
                                    }).toList()))),
                          ]))
                  : null),
        ]));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
