import 'package:flutter/material.dart';
import 'dart:math';

class CustomColorScheme {
  static final random = Random();

  static Color primary = const Color.fromRGBO(194, 232, 255, 1);
  static Color secondary = const Color.fromRGBO(245, 197, 58, 1);
  static Color error = const Color.fromRGBO(238, 100, 118, 1);
  static Color limeGreen = const Color.fromRGBO(137, 213, 107, 1);
  static Color tangerineOrange = const Color.fromRGBO(240, 110, 81, 1);
  static Color menu = const Color.fromRGBO(217, 217, 217, 1);

  static List<Color> taskCardColorSheme = [
    primary,
    limeGreen,
    tangerineOrange,
  ];

  static Color getRandomColor() {
    int index = random.nextInt(taskCardColorSheme.length);
    return taskCardColorSheme[index];
  }
}
