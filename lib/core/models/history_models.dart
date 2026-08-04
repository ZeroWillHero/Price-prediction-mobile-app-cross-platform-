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
