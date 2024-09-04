import 'package:flutter/material.dart';
import 'package:mobile/Components/FamilyCard.dart';
import 'package:mobile/models/family.dart';
import 'package:provider/provider.dart';
import '../services/app_state.dart';
import 'package:mobile/Components/FamilyCreationDialog.dart';

class ChooseFamilyPage extends StatefulWidget {
  const ChooseFamilyPage({super.key});

  @override
  State<ChooseFamilyPage> createState() => _ChooseFamilyPageState();
}

class _ChooseFamilyPageState extends State<ChooseFamilyPage> {
  late RootAppState _appState;
  List<Family> families = [];

  @override
  void initState() {
    super.initState();
    _appState = Provider.of<RootAppState>(context, listen: false);
    _getFamilies();
  }

  createFamily() {}
  @override
  Widget build(BuildContext context) {
    final _theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
          title: Text('Families'),
          backgroundColor: _theme.colorScheme.primaryContainer,
          actions: [
            IconButton(
                icon: Icon(Icons.add),
                onPressed: () => showDialog(
                      context: context,
                      builder: (context) =>
                          FamilyCreation(onCreateFamily: createFamily()),
                    )),
          ]),
      backgroundColor: _theme.colorScheme.primaryContainer,
      body: Column(
        children: [
          Expanded(
            child: Card(
              elevation: 4,
              margin: EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 8, right: 8, left: 8),
                    child: Container(
                      decoration: BoxDecoration(
                        color: _theme.colorScheme.primaryContainer,
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      padding: EdgeInsets.all(16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Your families', //maybe type the family name here
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        decoration: BoxDecoration(
                          color: _theme.colorScheme.primaryContainer,
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        child: Align(
                          alignment: Alignment.topCenter,
                          child: FractionallySizedBox(
                            widthFactor: 1,
                            child: Column(
                              children: [
                                for (Family family in families)
                                  Familycard(
                                    family: family,
                                  ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _getFamilies() async {
    Map<String, dynamic> response = await _appState.GetFamilies();
    if (response['statusCode'] == 200) {
      setState(() {
        families.clear();
        families.addAll(response['families']);
      });
    } else {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Something went wrong'),
          content: Text(response['Error']['message']),
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
