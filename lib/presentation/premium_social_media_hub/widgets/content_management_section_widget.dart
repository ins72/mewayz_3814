import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';


class ContentManagementSectionWidget extends StatelessWidget {
  const ContentManagementSectionWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Enhanced Scheduler Section
          _buildEnhancedSchedulerSection(context),
          const SizedBox(height: 24),
          
          // Refined Templates Section
          _buildRefinedTemplatesSection(context),
          const SizedBox(height: 24),
          
          // Multi-Platform Posting Section
          _buildMultiPlatformPostingSection(context),
        ],
      ),
    );
  }

  Widget _buildEnhancedSchedulerSection(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF191919),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: const Color(0xFF2C2C2E),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Enhanced Scheduler',
                    style: GoogleFonts.inter(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Drag-and-drop scheduling with optimization',
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      color: const Color(0xFF8E8E93),
                    ),
                  ),
                ],
              ),
              GestureDetector(
                onTap: () {
                  // Navigator.pushNamed(context, AppRoutes.socialMediaScheduler);
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: const Color(0xFF007AFF),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    'Open Scheduler',
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          
          // Quick scheduling preview
          Container(
            height: 120,
            decoration: BoxDecoration(
              color: const Color(0xFF1C1C1E),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                // Calendar preview
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Today\'s Schedule',
                          style: GoogleFonts.inter(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            Container(
                              width: 8,
                              height: 8,
                              decoration: const BoxDecoration(
                                color: Color(0xFF34C759),
                                shape: BoxShape.circle,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              '2:00 PM - Product Launch',
                              style: GoogleFonts.inter(
                                fontSize: 12,
                                color: const Color(0xFF8E8E93),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            Container(
                              width: 8,
                              height: 8,
                              decoration: const BoxDecoration(
                                color: Color(0xFF007AFF),
                                shape: BoxShape.circle,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              '4:30 PM - Behind the Scenes',
                              style: GoogleFonts.inter(
                                fontSize: 12,
                                color: const Color(0xFF8E8E93),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                
                // Drag and drop preview
                Container(
                  width: 80,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: const Color(0xFF007AFF).withAlpha(26),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Icon(
                          Icons.drag_handle,
                          color: Color(0xFF007AFF),
                          size: 20,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Drag & Drop',
                        style: GoogleFonts.inter(
                          fontSize: 10,
                          color: const Color(0xFF8E8E93),
                        ),
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

  Widget _buildRefinedTemplatesSection(BuildContext context) {
    final templates = [
      {
        'title': 'Product Showcase',
        'category': 'E-commerce',
        'image': 'https://images.unsplash.com/photo-1560472354-b33ff0c44a43?w=300&h=200&fit=crop',
        'color': const Color(0xFF007AFF),
      },
      {
        'title': 'Behind the Scenes',
        'category': 'Lifestyle',
        'image': 'https://images.unsplash.com/photo-1542744173-8e7e53415bb0?w=300&h=200&fit=crop',
        'color': const Color(0xFF34C759),
      },
      {
        'title': 'Quote Post',
        'category': 'Motivational',
        'image': 'https://images.unsplash.com/photo-1506905925346-21bda4d32df4?w=300&h=200&fit=crop',
        'color': const Color(0xFFFF9500),
      },
    ];

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF191919),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: const Color(0xFF2C2C2E),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Refined Templates',
                    style: GoogleFonts.inter(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Preview and customize before posting',
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      color: const Color(0xFF8E8E93),
                    ),
                  ),
                ],
              ),
              GestureDetector(
                onTap: () {
                  // Navigator.pushNamed(context, AppRoutes.contentTemplatesScreen);
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: const Color(0xFF34C759),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    'Browse All',
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          
          SizedBox(
            height: 140,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: templates.length,
              itemBuilder: (context, index) {
                final template = templates[index];
                return Container(
                  width: 120,
                  margin: const EdgeInsets.only(right: 12),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: const Color(0xFF2C2C2E),
                      width: 1,
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: ClipRRect(
                          borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                          child: CachedNetworkImage(
                            imageUrl: template['image'] as String,
                            width: double.infinity,
                            fit: BoxFit.cover,
                            placeholder: (context, url) => Container(
                              color: const Color(0xFF3A3A3C),
                              child: const Center(
                                child: CircularProgressIndicator(
                                  color: Color(0xFF007AFF),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.all(8),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              template['title'] as String,
                              style: GoogleFonts.inter(
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              template['category'] as String,
                              style: GoogleFonts.inter(
                                fontSize: 10,
                                color: const Color(0xFF8E8E93),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMultiPlatformPostingSection(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF191919),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: const Color(0xFF2C2C2E),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Multi-Platform Posting',
                    style: GoogleFonts.inter(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Optimization suggestions for each platform',
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      color: const Color(0xFF8E8E93),
                    ),
                  ),
                ],
              ),
              GestureDetector(
                onTap: () {
                  // Navigator.pushNamed(context, AppRoutes.multiPlatformPostingScreen);
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: const Color(0xFF5856D6),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    'Create Post',
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          
          // Platform optimization suggestions
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFF1C1C1E),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              children: [
                _buildOptimizationSuggestion(
                  'Instagram',
                  'Use 3-5 hashtags for better reach',
                  const Color(0xFFE1306C),
                  Icons.camera_alt,
                ),
                const SizedBox(height: 12),
                _buildOptimizationSuggestion(
                  'Facebook',
                  'Add location tag for local engagement',
                  const Color(0xFF1877F2),
                  Icons.facebook,
                ),
                const SizedBox(height: 12),
                _buildOptimizationSuggestion(
                  'Twitter',
                  'Keep text under 280 characters',
                  const Color(0xFF1DA1F2),
                  Icons.alternate_email,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOptimizationSuggestion(String platform, String suggestion, Color color, IconData icon) {
    return Row(
      children: [
        Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            color: color.withAlpha(26),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            icon,
            color: color,
            size: 16,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                platform,
                style: GoogleFonts.inter(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Colors.white,
                ),
              ),
              Text(
                suggestion,
                style: GoogleFonts.inter(
                  fontSize: 12,
                  color: const Color(0xFF8E8E93),
                ),
              ),
            ],
          ),
        ),
        const Icon(
          Icons.lightbulb_outline,
          color: Color(0xFFFF9500),
          size: 16,
        ),
      ],
    );
  }
}