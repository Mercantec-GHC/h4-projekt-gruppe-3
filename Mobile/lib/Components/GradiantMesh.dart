// lib/mesh_gradient_background.dart

import 'package:flutter/material.dart';
import 'package:mesh_gradient/mesh_gradient.dart';
import 'package:mobile/Components/ColorScheme.dart';

class MeshGradientBackground extends StatelessWidget {
  final meshGradient = MeshGradient(
    points: [
      MeshGradientPoint(
        position: const Offset(0.9, 0.9),
        color: CustomColorScheme.primary,
      ),
      MeshGradientPoint(
        position: const Offset(0.4, 0.5),
        color: CustomColorScheme.secondary,
      ),
      MeshGradientPoint(
        position: const Offset(0.7, 0.4),
        color: CustomColorScheme.limeGreen,
      ),
      MeshGradientPoint(
        position: const Offset(0.4, 0.2),
        color: CustomColorScheme.tangerineOrange,
      ),
    ],
    options: MeshGradientOptions(), // Add any specific options here if needed
  );
  MeshGradientBackground({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Positioned.fill(child: meshGradient);
  }
}
