class DatedPrice {
  const DatedPrice({
    required this.date,
    required this.price,
    required this.isPredicted,
  });

  final DateTime date;
  final double price;
  final bool isPredicted;
}
