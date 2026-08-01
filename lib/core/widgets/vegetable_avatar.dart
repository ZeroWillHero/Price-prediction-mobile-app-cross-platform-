import 'package:flutter/material.dart';

const Map<String, String> vegImages = {
  'Carrot': 'assets/carrot.png',
  'Cabbage': 'assets/cabbage-grated.png',
  'Leeks': 'assets/leek-emoji.png',
  'Brinjal': 'assets/brinjal.png',
  'Pumpkin': 'assets/pumpkin.png',
  'Snake Gourd': 'assets/snakegourd.png',
};

const Map<String, Color> vegAccents = {
  'Carrot': Color(0xFFFF6B35),
  'Cabbage': Color(0xFF27AE60),
  'Leeks': Color(0xFF6A9955),
  'Brinjal': Color(0xFF6C3483),
  'Pumpkin': Color(0xFFE67E22),
  'Snake Gourd': Color(0xFF3E8E5A),
};

class VegetableAvatar extends StatelessWidget {
  const VegetableAvatar({
    super.key,
    required this.name,
    required this.color,
    this.size = 48,
    this.glow = false,
  });

  final String name;
  final Color color;
  final double size;
  final bool glow;

  @override
  Widget build(BuildContext context) {
    final String? imagePath = vegImages[name];
    final vegColor = vegAccents[name] ?? color;
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: vegColor.withOpacity(0.14),
        border: Border.all(color: vegColor.withOpacity(0.26), width: 1.5),
        boxShadow: glow
            ? [
                BoxShadow(
                  color: vegColor.withOpacity(0.30),
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
                name.isNotEmpty ? name.substring(0, 1) : '?',
                style: TextStyle(fontSize: size * 0.50),
              ),
      ),
    );
  }
}
