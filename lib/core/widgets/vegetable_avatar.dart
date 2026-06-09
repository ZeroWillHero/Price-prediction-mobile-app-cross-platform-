import 'package:flutter/material.dart';

class VegetableAvatar extends StatelessWidget {
  const VegetableAvatar({
    super.key,
    required this.name,
    required this.color,
    this.size = 48,
  });

  final String name;
  final Color color;
  final double size;

  @override
  Widget build(BuildContext context) {
    final String letter = name.isEmpty ? '?' : name.substring(0, 1).toUpperCase();
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(
          colors: <Color>[
            color,
            color.withOpacity(0.6),
          ],
        ),
      ),
      child: Center(
        child: Text(
          letter,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.w800,
              ),
        ),
      ),
    );
  }
}
