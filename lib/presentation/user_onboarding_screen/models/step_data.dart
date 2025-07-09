class StepData {
  final String illustration;
  final String title;
  final String subtitle;
  final String description;
  final List<FeatureData> features;

  const StepData({
    required this.illustration,
    required this.title,
    required this.subtitle,
    required this.description,
    required this.features,
  });

  // Convert to Map for backward compatibility
  Map<String, dynamic> toMap() {
    return {
      'illustration': illustration,
      'title': title,
      'subtitle': subtitle,
      'description': description,
      'features': features.map((f) => f.toMap()).toList(),
    };
  }

  // Create from Map
  factory StepData.fromMap(Map<String, dynamic> map) {
    return StepData(
      illustration: map['illustration'] ?? '',
      title: map['title'] ?? '',
      subtitle: map['subtitle'] ?? '',
      description: map['description'] ?? '',
      features: (map['features'] as List<dynamic>? ?? [])
          .map((f) => FeatureData.fromMap(f as Map<String, dynamic>))
          .toList(),
    );
  }
}

class FeatureData {
  final String icon;
  final String title;
  final String description;

  const FeatureData({
    required this.icon,
    required this.title,
    required this.description,
  });

  // Convert to Map
  Map<String, dynamic> toMap() {
    return {
      'icon': icon,
      'title': title,
      'description': description,
    };
  }

  // Create from Map
  factory FeatureData.fromMap(Map<String, dynamic> map) {
    return FeatureData(
      icon: map['icon'] ?? '',
      title: map['title'] ?? '',
      description: map['description'] ?? '',
    );
  }
}