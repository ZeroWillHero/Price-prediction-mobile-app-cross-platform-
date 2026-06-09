class HistoryEvent {
  const HistoryEvent({
    required this.emoji,
    required this.title,
    required this.period,
    required this.deltaLabel,
  });

  final String emoji;
  final String title;
  final String period;
  final String deltaLabel;
}

class AlertHistoryEntry {
  const AlertHistoryEntry({
    required this.vegetableName,
    required this.summary,
    required this.whenLabel,
    required this.actualPriceLabel,
  });

  final String vegetableName;
  final String summary;
  final String whenLabel;
  final String actualPriceLabel;
}
