enum AlertComparison { above, below }

class AlertRule {
  const AlertRule({
    required this.id,
    required this.vegetableId,
    required this.comparison,
    required this.threshold,
    required this.enabled,
    required this.createdLabel,
  });

  final int id;

  /// Backend vegetable identifier (e.g. `snake_gourd`).
  final String vegetableId;
  final AlertComparison comparison;
  final double threshold;
  final bool enabled;
  final String createdLabel;

  String get conditionLabel {
    final String prefix =
        comparison == AlertComparison.above ? 'Price exceeds' : 'Price drops below';
    return '$prefix Rs ${threshold.toStringAsFixed(0)}/kg';
  }

  AlertRule copyWith({
    int? id,
    String? vegetableId,
    AlertComparison? comparison,
    double? threshold,
    bool? enabled,
    String? createdLabel,
  }) {
    return AlertRule(
      id: id ?? this.id,
      vegetableId: vegetableId ?? this.vegetableId,
      comparison: comparison ?? this.comparison,
      threshold: threshold ?? this.threshold,
      enabled: enabled ?? this.enabled,
      createdLabel: createdLabel ?? this.createdLabel,
    );
  }
}
