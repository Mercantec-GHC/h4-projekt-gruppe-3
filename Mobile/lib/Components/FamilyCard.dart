import 'dart:convert';
import 'package:mobile/Components/ColorScheme.dart';
import 'package:mobile/Components/CustomPopup.dart';
import 'package:mobile/models/family.dart';
import 'package:mobile/services/api.dart';
import 'package:mobile/services/app_state.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:mobile/pages/update_family_profile.dart';

class Familycard extends StatelessWidget {
  const Familycard({
    super.key,
    required this.family,
  });

  final Family family;

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<RootAppState>();

    return GestureDetector(
      onTap: () {
        _chooseFamily(appState, context);
      },
      child: Card(
        color: CustomColorScheme.getRandomColor(),
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
                      // Conditionally display the button if the user is the owner
                      if (appState.user!.id == family.ownerId)
                        ElevatedButton(
                          onPressed: () async {
                            await _chooseFamily(appState, context);
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => UpdateFamilyProfilePage(),
                              ),
                            );
                          },
                          child: Text('Edit Family'),
                        ),
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
    String? jwt = await appState.storage.read(key: 'auth_token');
    final response = await Api().GetFamily(family, jwt);
    var jsonData = json.decode(response.body);
    if (response.statusCode == 200) {
      Family family = new Family(
        jsonData['id'],
        jsonData['name'],
        jsonData['owner_id'],
      );
      appState.family = family;
    } else {
      CustomPopup.openErrorPopup(context, errorText: jsonData);
    }
  }
}
