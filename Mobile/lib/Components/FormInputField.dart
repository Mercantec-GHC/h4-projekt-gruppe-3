import 'package:flutter/material.dart';

class FormInputField extends StatelessWidget {
  final void Function(String?) onSave;
  final String? Function(String?)? validator;
  final TextInputType? keyboardType;
  final String? initialValue;
  final String fieldLabel;
  final String placeholder;

  const FormInputField({
    super.key,
    required this.onSave,
    this.validator,
    this.initialValue = '',
    required this.fieldLabel,
    required this.placeholder,
    this.keyboardType,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Align(
          alignment: Alignment.centerLeft,
          child: Text(fieldLabel),
        ),
        TextFormField(
          initialValue: initialValue,
          decoration: InputDecoration(
            hintText: placeholder,
            border: OutlineInputBorder(),
            contentPadding: EdgeInsets.symmetric(horizontal: 10),
          ),
          keyboardType: keyboardType,
          validator: validator,
          onSaved: onSave,
        ),
      ],
    );
  }
}
