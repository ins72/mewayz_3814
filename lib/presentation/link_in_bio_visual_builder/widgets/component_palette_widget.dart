import '../../../core/app_export.dart';

class ComponentPaletteWidget extends StatelessWidget {
  final Function(String) onComponentAdd;

  const ComponentPaletteWidget({
    Key? key,
    required this.onComponentAdd,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Add Components',
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
              color: AppTheme.primaryText,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 16),
          
          Expanded(
            child: ListView(
              children: [
                _buildComponentSection(
                  context,
                  'Basic Elements',
                  [
                    _ComponentItem(
                      type: 'link_button',
                      title: 'Link Button',
                      description: 'Clickable button with URL',
                      icon: Icons.link,
                      color: AppTheme.accent,
                    ),
                    _ComponentItem(
                      type: 'text_block',
                      title: 'Text Block',
                      description: 'Custom text content',
                      icon: Icons.text_fields,
                      color: Colors.green,
                    ),
                    _ComponentItem(
                      type: 'image',
                      title: 'Image',
                      description: 'Upload or link images',
                      icon: Icons.image,
                      color: Colors.purple,
                    ),
                  ],
                ),
                
                const SizedBox(height: 24),
                
                _buildComponentSection(
                  context,
                  'Social & Media',
                  [
                    _ComponentItem(
                      type: 'social_links',
                      title: 'Social Links',
                      description: 'Social media icons',
                      icon: Icons.share,
                      color: Colors.orange,
                    ),
                    _ComponentItem(
                      type: 'video',
                      title: 'Video Embed',
                      description: 'YouTube, Vimeo videos',
                      icon: Icons.play_circle_fill,
                      color: Colors.red,
                    ),
                  ],
                ),
                
                const SizedBox(height: 24),
                
                _buildComponentSection(
                  context,
                  'Layout & Design',
                  [
                    _ComponentItem(
                      type: 'divider',
                      title: 'Divider',
                      description: 'Visual separator line',
                      icon: Icons.horizontal_rule,
                      color: Colors.grey,
                    ),
                    _ComponentItem(
                      type: 'spacer',
                      title: 'Spacer',
                      description: 'Add vertical spacing',
                      icon: Icons.height,
                      color: Colors.blue,
                    ),
                  ],
                ),
                
                const SizedBox(height: 24),
                
                _buildComponentSection(
                  context,
                  'Advanced',
                  [
                    _ComponentItem(
                      type: 'contact_form',
                      title: 'Contact Form',
                      description: 'Capture visitor info',
                      icon: Icons.contact_mail,
                      color: Colors.teal,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildComponentSection(
    BuildContext context,
    String title,
    List<_ComponentItem> components,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.labelMedium?.copyWith(
            color: AppTheme.secondaryText,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 8),
        
        ...components.map((component) => _buildComponentCard(context, component)),
      ],
    );
  }

  Widget _buildComponentCard(BuildContext context, _ComponentItem component) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => onComponentAdd(component.type),
          borderRadius: BorderRadius.circular(8),
          child: Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppTheme.primaryBackground,
              border: Border.all(color: AppTheme.border),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: component.color.withAlpha(26),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    component.icon,
                    color: component.color,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        component.title,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: AppTheme.primaryText,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        component.description,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AppTheme.secondaryText,
                        ),
                      ),
                    ],
                  ),
                ),
                
                Icon(
                  Icons.add,
                  color: AppTheme.secondaryText,
                  size: 20,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _ComponentItem {
  final String type;
  final String title;
  final String description;
  final IconData icon;
  final Color color;

  const _ComponentItem({
    required this.type,
    required this.title,
    required this.description,
    required this.icon,
    required this.color,
  });
}