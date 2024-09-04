import 'package:flutter/material.dart';

class OutlinedText extends StatelessWidget {
  final String text;
  final TextStyle style;
  final Color outlineColor;
  final double outlineWidth;

  const OutlinedText({
    Key? super.key,
    required this.text,
    this.style = const TextStyle(
      fontSize: 18.75,
      color: Colors.white,
    ),
    this.outlineColor = Colors.black,
    this.outlineWidth = 2.0,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Outline
        Text(
          text,
          style: style.copyWith(
            foreground: Paint()
              ..style = PaintingStyle.stroke
              ..strokeWidth = outlineWidth
              ..color = outlineColor,
          ),
        ),
        // Main Text
        Text(
          text,
          style: style,
        ),
      ],
    );
  }
}
