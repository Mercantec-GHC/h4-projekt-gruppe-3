import 'package:flutter/material.dart';
import 'package:mobile/Components/FamilyCard.dart';
import 'package:mobile/models/family.dart';
import 'package:provider/provider.dart';
import '../Components/FamilyCreation.dart';
import '../services/app_state.dart';
import 'package:mobile/Components/GradiantMesh.dart'; // Import for MeshGradientBackground

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background gradient
          Positioned.fill(
            child: MeshGradientBackground(),
          ),
          // Main content
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                // Title and action button row
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Your Families',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    // Add family button
                    IconButton(
                      icon: Icon(
                        Icons.add, // Adjust color for contrast
                      ),
                      onPressed: () => openCreateFamily(context),
                    ),
                  ],
                ),
                Expanded(
                  child: Container(
                    child: Card(
                      elevation: 0,
                      margin: EdgeInsets.zero,
                      color: Colors.transparent,
                      child: Column(
                        children: [
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Align(
                                alignment: Alignment.topCenter,
                                child: FractionallySizedBox(
                                  widthFactor: 1,
                                  child: ListView.builder(
                                    itemCount: families.length,
                                    itemBuilder: (context, index) {
                                      return Familycard(
                                        family: families[index],
                                      );
                                    },
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
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
        families.addAll(response['family']);
      });
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

  static void openCreateFamily(BuildContext context) {
    showDialog(context: context, builder: (context) => Familycreation());
  }
}
