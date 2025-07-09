import '../../../core/app_export.dart';

class ContentComposerWidget extends StatefulWidget {
  final TextEditingController controller;
  final List<String> selectedPlatforms;
  final Function(String) onContentChanged;

  const ContentComposerWidget({
    super.key,
    required this.controller,
    required this.selectedPlatforms,
    required this.onContentChanged,
  });

  @override
  State<ContentComposerWidget> createState() => _ContentComposerWidgetState();
}

class _ContentComposerWidgetState extends State<ContentComposerWidget> {
  final List<String> _suggestions = ['#marketing', '#business', '#socialmedia', '#growth'];
  bool _showSuggestions = false;

  @override
  Widget build(BuildContext context) {
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
          Row(
            children: [
              const Text(
                'Content',
                style: TextStyle(
                  color: AppTheme.primaryText,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const Spacer(),
              _buildCharacterCounter(),
            ],
          ),
          const SizedBox(height: 12),
          TextField(
            controller: widget.controller,
            maxLines: 6,
            style: const TextStyle(
              color: AppTheme.primaryText,
              fontSize: 16,
            ),
            decoration: const InputDecoration(
              hintText: 'What\'s on your mind?',
              hintStyle: TextStyle(color: AppTheme.secondaryText),
              border: InputBorder.none,
              contentPadding: EdgeInsets.zero,
            ),
            onChanged: (value) {
              setState(() {
                _showSuggestions = value.endsWith('#') || value.endsWith('@');
              });
              widget.onContentChanged(value);
            },
          ),
          if (_showSuggestions) _buildSuggestions(),
          const SizedBox(height: 16),
          _buildPlatformSpecificOptions(),
        ],
      ),
    );
  }

  Widget _buildCharacterCounter() {
    final currentLength = widget.controller.text.length;
    final maxLength = _getMaxCharacterLimit();
    final isOverLimit = currentLength > maxLength;
    
    return Text(
      '$currentLength/$maxLength',
      style: TextStyle(
        color: isOverLimit ? AppTheme.error : AppTheme.secondaryText,
        fontSize: 12,
        fontWeight: FontWeight.w500,
      ),
    );
  }

  Widget _buildSuggestions() {
    return Container(
      margin: const EdgeInsets.only(top: 8),
      decoration: BoxDecoration(
        color: AppTheme.primaryBackground,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppTheme.border),
      ),
      child: Column(
        children: _suggestions.map((suggestion) {
          return ListTile(
            dense: true,
            title: Text(
              suggestion,
              style: const TextStyle(
                color: AppTheme.primaryText,
                fontSize: 14,
              ),
            ),
            onTap: () {
              final text = widget.controller.text;
              final lastChar = text.substring(text.length - 1);
              final newText = text.substring(0, text.length - 1) + suggestion + ' ';
              widget.controller.text = newText;
              widget.controller.selection = TextSelection.fromPosition(
                TextPosition(offset: newText.length),
              );
              setState(() {
                _showSuggestions = false;
              });
            },
          );
        }).toList(),
      ),
    );
  }

  Widget _buildPlatformSpecificOptions() {
    return Wrap(
      spacing: 8,
      children: [
        _buildActionButton(
          icon: Icons.tag,
          label: 'Hashtags',
          onTap: () => _showHashtagSuggestions(),
        ),
        _buildActionButton(
          icon: Icons.alternate_email,
          label: 'Mentions',
          onTap: () => _showMentionSuggestions(),
        ),
        _buildActionButton(
          icon: Icons.emoji_emotions,
          label: 'Emojis',
          onTap: () => _showEmojiPicker(),
        ),
        _buildActionButton(
          icon: Icons.link,
          label: 'Link',
          onTap: () => _addLink(),
        ),
      ],
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: AppTheme.primaryBackground,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppTheme.border),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: AppTheme.secondaryText, size: 16),
            const SizedBox(width: 4),
            Text(
              label,
              style: const TextStyle(
                color: AppTheme.secondaryText,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }

  int _getMaxCharacterLimit() {
    int maxLimit = 2200; // Default Twitter limit
    
    for (String platform in widget.selectedPlatforms) {
      switch (platform) {
        case 'twitter':
          maxLimit = 280;
          break;
        case 'instagram':
          maxLimit = 2200;
          break;
        case 'facebook':
          maxLimit = 63206;
          break;
        case 'linkedin':
          maxLimit = 3000;
          break;
        case 'tiktok':
          maxLimit = 2200;
          break;
        case 'youtube':
          maxLimit = 5000;
          break;
      }
    }
    
    return maxLimit;
  }

  void _showHashtagSuggestions() {
    // Show hashtag suggestions modal
  }

  void _showMentionSuggestions() {
    // Show mention suggestions modal
  }

  void _showEmojiPicker() {
    // Show emoji picker modal
  }

  void _addLink() {
    // Add link functionality
  }
}