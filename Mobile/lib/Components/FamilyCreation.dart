import 'package:flutter/material.dart';
import 'package:mobile/Components/CustomPopup.dart';
import 'package:mobile/services/app_state.dart';
import 'package:provider/provider.dart';

import '../models/family.dart';
import '../services/api.dart';

class Familycreation extends StatefulWidget {
  const Familycreation({super.key});

  @override
  State<Familycreation> createState() => _FamilycreationState();
}

class _FamilycreationState extends State<Familycreation> {
  late RootAppState _appState;
  Api api = Api();
  final _formKey = GlobalKey<FormState>();

  String name = '';

  // TextEditingController to capture input from the TextFormField
  final TextEditingController _nameController = TextEditingController();

  void _createFamily() async {
    if (_formKey.currentState!.validate()) {
      name = _nameController.text;
      Family family = Family(0, name);
      var response = await api.createFamily(family, _appState);
      if (response.statusCode == 201) {
        Navigator.of(context).pop();
      } else {
        CustomPopup.openErrorPopup(context, response.body);
      }
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _appState = context.watch<RootAppState>();
    return AlertDialog(
      scrollable: true,
      title: Text('Create Family'),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text('Close'),
        ),
        TextButton(
          onPressed: _createFamily,
          child: Text('Create'),
        ),
      ],
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Form(
            key: _formKey,
            child: Column(
              children: [
                TextFormField(
                  controller: _nameController,
                  maxLength: 200,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  decoration: InputDecoration(labelText: 'Name'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Field is required and cannot be empty';
                    }
                    return null;
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
