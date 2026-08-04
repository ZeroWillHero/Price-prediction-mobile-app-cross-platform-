import 'package:flutter/material.dart';

/// Keyed by the backend vegetable identifier (e.g. `snake_gourd`), not the
/// display label.
const Map<String, String> vegImages = {
  'carrot': 'assets/carrot.png',
  'cabbage': 'assets/cabbage-grated.png',
  'leeks': 'assets/leek-emoji.png',
  'brinjal': 'assets/brinjal.png',
  'pumpkin': 'assets/pumpkin.png',
  'snake_gourd': 'assets/snakegourd.png',
};

const Map<String, Color> vegAccents = {
  'carrot': Color(0xFFFF6B35),
  'cabbage': Color(0xFF27AE60),
  'leeks': Color(0xFF6A9955),
  'brinjal': Color(0xFF6C3483),
  'pumpkin': Color(0xFFE67E22),
  'snake_gourd': Color(0xFF3E8E5A),
};

class VegetableAvatar extends StatelessWidget {
  const VegetableAvatar({
    super.key,
    required this.id,
    required this.color,
    this.size = 48,
    this.glow = false,
  });

  /// The backend vegetable identifier, used to look up its image/accent.
  final String id;
  final Color color;
  final double size;
  final bool glow;

  @override
  Widget build(BuildContext context) {
    final String? imagePath = vegImages[id];
    final vegColor = vegAccents[id] ?? color;
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: vegColor.withValues(alpha: 0.14),
        border: Border.all(color: vegColor.withValues(alpha: 0.26), width: 1.5),
        boxShadow: glow
            ? [
                BoxShadow(
                  color: vegColor.withValues(alpha: 0.30),
                  blurRadius: 14,
                  spreadRadius: 1,
                ),
              ]
            : null,
      ),
      child: Center(
        child: imagePath != null
            ? SizedBox(
                width: size * 0.56,
                height: size * 0.56,
                child: Image.asset(imagePath, fit: BoxFit.contain),
              )
            : Text(
                id.isNotEmpty ? id.substring(0, 1).toUpperCase() : '?',
                style: TextStyle(fontSize: size * 0.50),
              ),
      ),
    );
  }
}
