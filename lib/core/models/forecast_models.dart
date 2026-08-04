class ForecastPackage {
  const ForecastPackage({
    required this.vegetableId,
    required this.horizon,
    required this.predictedPrice,
    required this.lowPrice,
    required this.highPrice,
    required this.modelFamily,
    required this.typicalErrorRs,
  });

  final String vegetableId;
  final String horizon;
  final double predictedPrice;
  final double lowPrice;
  final double highPrice;

  /// The backend model family that produced this forecast (e.g. `random_forest`).
  final String modelFamily;

  /// Mean absolute error (Rs) of that model family on its holdout set — shown
  /// to farmers as "usually accurate within about Rs X", not as raw MAE.
  final double typicalErrorRs;
}
