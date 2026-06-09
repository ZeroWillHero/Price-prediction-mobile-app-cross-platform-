enum AlertComparison { above, below }

class AlertRule {
  const AlertRule({
    required this.id,
    required this.vegetableName,
    required this.comparison,
    required this.threshold,
    required this.enabled,
    required this.createdLabel,
  });

  final int id;
  final String vegetableName;
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
    String? vegetableName,
    AlertComparison? comparison,
    double? threshold,
    bool? enabled,
    String? createdLabel,
  }) {
    return AlertRule(
      id: id ?? this.id,
      vegetableName: vegetableName ?? this.vegetableName,
      comparison: comparison ?? this.comparison,
      threshold: threshold ?? this.threshold,
      enabled: enabled ?? this.enabled,
      createdLabel: createdLabel ?? this.createdLabel,
    );
  }
}
