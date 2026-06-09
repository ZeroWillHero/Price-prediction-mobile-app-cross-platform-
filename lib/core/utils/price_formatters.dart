String formatRs(num value) => 'Rs ${value.toStringAsFixed(0)}/kg';

String formatPercent(double value) =>
    value >= 0 ? '+${value.toStringAsFixed(0)}%' : '${value.toStringAsFixed(0)}%';
