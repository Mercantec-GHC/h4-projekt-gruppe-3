import 'package:flutter/material.dart';
import 'dart:math';

class CustomColorScheme {
  static final random = Random();
  
  static List<Color> colorScheme = const [
      Color.fromRGBO(194, 232, 255, 77),
      Color.fromRGBO(137, 213, 107, 1),
      Color.fromRGBO(240, 110, 81, 1),
    ];


    static Color getRandomColor() {
    int index = random.nextInt(colorScheme.length);
    return colorScheme[index];
  }
}
