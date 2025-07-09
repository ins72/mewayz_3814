import '../models/step_data.dart';

class OnboardingStepsData {
  static const List<StepData> steps = [
    StepData(
      illustration: 'workspace_illustration',
      title: 'Welcome to Mewayz',
      subtitle: 'Your All-in-One Digital Workspace',
      description: 'Create, manage, and grow your online presence with powerful tools designed for modern creators and businesses.',
      features: [
        FeatureData(
          icon: 'link',
          title: 'Link-in-Bio Builder',
          description: 'Create stunning, customizable link-in-bio pages that showcase your content and drive engagement.',
        ),
        FeatureData(
          icon: 'storefront',
          title: 'Built-in Marketplace',
          description: 'Sell products and services directly from your profile with integrated payment processing.',
        ),
        FeatureData(
          icon: 'analytics',
          title: 'Advanced Analytics',
          description: 'Track performance, understand your audience, and optimize your content strategy.',
        ),
      ],
    ),
    StepData(
      illustration: 'social_media_illustration',
      title: 'Social Media Management',
      subtitle: 'Streamline Your Social Presence',
      description: 'Manage all your social media accounts from one place. Schedule posts, track engagement, and grow your audience across platforms.',
      features: [
        FeatureData(
          icon: 'schedule',
          title: 'Content Scheduling',
          description: 'Plan and schedule your posts across multiple platforms with our intuitive calendar.',
        ),
        FeatureData(
          icon: 'hashtag',
          title: 'Hashtag Research',
          description: 'Discover trending hashtags and optimize your content for maximum reach.',
        ),
        FeatureData(
          icon: 'bar_chart',
          title: 'Performance Tracking',
          description: 'Monitor your social media performance with detailed analytics and insights.',
        ),
      ],
    ),
    StepData(
      illustration: 'crm_illustration',
      title: 'Customer Management',
      subtitle: 'Build Stronger Relationships',
      description: 'Manage your contacts, track interactions, and nurture relationships with integrated CRM tools and automation.',
      features: [
        FeatureData(
          icon: 'contacts',
          title: 'Contact Management',
          description: 'Organize and manage your contacts with detailed profiles and interaction history.',
        ),
        FeatureData(
          icon: 'email',
          title: 'Email Marketing',
          description: 'Create and send targeted email campaigns to engage your audience.',
        ),
        FeatureData(
          icon: 'calendar_today',
          title: 'Appointment Booking',
          description: 'Let clients book appointments directly through your profile with automated scheduling.',
        ),
      ],
    ),
  ];

  static StepData getStep(int index) {
    if (index >= 0 && index < steps.length) {
      return steps[index];
    }
    return steps[0]; // Return first step as default
  }

  static int get totalSteps => steps.length;
}