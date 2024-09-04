import 'dart:math';
import 'package:mobile/models/family.dart';
import 'package:mobile/services/app_state.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Familycard extends StatelessWidget {
  const Familycard({
    super.key,
    required this.family,
    this.colorScheme = const [
      Color.fromRGBO(194, 232, 255, 77),
      Color.fromRGBO(137, 213, 107, 1),
      Color.fromRGBO(240, 110, 81, 1),
    ],
  });

  final Family family;
  final List<Color> colorScheme;

  Color _getRandomColor() {
    final random = Random();
    int index = random.nextInt(colorScheme.length);
    return colorScheme[index];
  }

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<RootAppState>();
    return GestureDetector(
      onTap: (){appState.GetFamily(family);},
      child: Card(
        color: _getRandomColor(),
        margin: EdgeInsets.all(10.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: SizedBox(
            height: 80,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Text content on the left
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        family.name,
                        style: TextStyle(
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(
                          height: 10),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
