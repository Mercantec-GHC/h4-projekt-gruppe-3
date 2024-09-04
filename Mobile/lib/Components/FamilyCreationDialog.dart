import 'package:flutter/material.dart';
import 'package:mobile/models/family.dart';
import 'package:mobile/services/app_state.dart';
import 'package:provider/provider.dart';
import 'package:mobile/services/api.dart';

class FamilyCreation extends StatefulWidget {
  const FamilyCreation({
    super.key,
    required this.onCreateFamily,
  });

  final Function(Family) onCreateFamily;

  @override
  State<FamilyCreation> createState() => _TaskCreationState();
}

class _TaskCreationState extends State<FamilyCreation> {
  // Page needs to run.
  late RootAppState _appState;
  late Api api;
  final _formKey = GlobalKey<FormState>();

  // Data storage.
  String name = '';

  void _createFamily() async {
    if (_formKey.currentState!.validate()) {
      Family family = new Family(0, name);
      int response = (await api.createFamily(family, _appState)).statusCode;
      if (response == 201) {
        widget.onCreateFamily(family);
        Navigator.of(context).pop();
      }
      else {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('Something went wrong'),
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
                CustomTextFormField(labelText: 'Name', AddPadding: false, maxLength: 100,
                  onChanged: (value) {
                    name = value!;
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

class CustomBooleanField extends StatelessWidget {
  final String labelText;
  final bool value;
  final ValueChanged<bool> onChanged;
  final bool AddPadding;
  final double paddingAmount;

  CustomBooleanField({
    required this.value,
    required this.labelText,
    required this.onChanged,
    this.AddPadding = true,
    this.paddingAmount = 16.0,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: AddPadding ? paddingAmount : 0),
      child: Row(
        children: [
          Expanded(
            child: Text(labelText),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }
}

class CustomTextFormField extends StatelessWidget {
  final String labelText;
  final TextInputType keyboardType;
  final FormFieldValidator<String>? validator;
  final FormFieldSetter<String>? onChanged;
  final VoidCallback? onTap;
  final TextEditingController? controller;
  final int maxLength;
  final int maxLines;
  final bool AddPadding;
  final double paddingAmount;
  final bool enabled;

  CustomTextFormField({
    required this.labelText,
    required this.onChanged,
    this.validator,
    this.onTap,
    this.keyboardType = TextInputType.text,
    this.controller,
    this.maxLength = -1,
    this.maxLines = -1,
    this.AddPadding = true,
    this.paddingAmount = 16.0,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: AddPadding ? paddingAmount : 0),
      child: TextFormField(
        enabled: enabled,
        controller: controller,
        maxLength: maxLength > 0 ? maxLength : null,
        maxLines: maxLines > 0 ? maxLines : 1,
        autovalidateMode: AutovalidateMode.onUnfocus,
        keyboardType: keyboardType,
        decoration: InputDecoration(labelText: labelText),
        validator: validator != null ? validator : (value) {
          if (value == null || value.isEmpty) {
            return 'Field is required and cannot be empty';
          }
          return null;
        },
        onChanged: onChanged,
        onTap: onTap,
        readOnly: controller != null,
      ),
    );
  }
}