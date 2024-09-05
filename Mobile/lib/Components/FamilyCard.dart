import 'dart:math';
import 'package:mobile/models/family.dart';
import 'package:mobile/pages/home.dart';
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
      onTap: () {
        _chooseFamily(appState, context);
      },
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
                      const SizedBox(height: 10),
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

  Future<void> _chooseFamily(RootAppState appState, context) async {
    Map<String, dynamic> response = await appState.GetFamily(family);
    if (response['statusCode'] == 200) {
      appState.family = response['body'];
    } else {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Something went wrong'),
          content: Text(response['error']['message']),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Close'),
            ),
          ],
        ),
      );
    }
  }
}
