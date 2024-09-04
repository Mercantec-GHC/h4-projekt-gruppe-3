import 'package:flutter/material.dart';
import 'package:mobile/Components/CustomPopup.dart';
import 'package:mobile/Components/SelectDateTime.dart';
import 'package:mobile/models/task.dart';
import 'package:mobile/services/app_state.dart';
import 'package:provider/provider.dart';

class TaskCreation extends StatefulWidget {
  const TaskCreation({
    super.key,
  });

  @override
  State<TaskCreation> createState() => _TaskCreationState();
}

class _TaskCreationState extends State<TaskCreation> {
  // Page needs to run.
  late RootAppState _appState;
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _endDatetimestampController = TextEditingController();

  // Data storage.
  String title = '';
  String description = '';
  String reward = '';
  DateTime endDate = DateTime.now();
  bool recurring = false;
  String recurringInterval = '';
  bool singleCompletion = false;

  void _createTask() async {
    if (_formKey.currentState!.validate()) {
      int reward = int.parse(this.reward);
      int recurringInterval = int.tryParse(this.recurringInterval) ?? 0;
      Task task = new Task(0, title, description, reward, DateTime.now(), endDate, recurring, recurringInterval, singleCompletion);
      int response = await _appState.createTask(task);
      if (response == 201) {
        _appState.AddTask(task);
        Navigator.of(context).pop();
      }
      else {
        CustomPopup.openErrorPopup(context, '');
      }
    }
  }

  Future<void> _selectDateTime(BuildContext context) async {
    DateTime? newDateTime = await Selectdatetime.SelectDateTime(context);

    if(newDateTime != null) {
      setState(() {
        endDate = newDateTime;
        _endDatetimestampController.text = newDateTime.toString();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    _appState = context.watch<RootAppState>();
    return AlertDialog(
      scrollable: true,
      title: Text('Create task'),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text('Close'),
        ),
        TextButton(
          onPressed: _createTask,
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
                CustomTextFormField(labelText: 'Title', AddPadding: false, maxLength: 100,
                  onChanged: (value) {
                    title = value!;
                  },
                ),
                CustomTextFormField(labelText: 'Description', 
                  maxLength: 255, maxLines: 3,
                  onChanged: (value) {
                    description = value!;
                  }
                ),
                CustomTextFormField(labelText: 'Reward', keyboardType: TextInputType.number, 
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Field is required and cannot be empty';
                    }
      
                    if (double.tryParse(value) == null) {
                      return 'Please enter a whole number';
                    }
      
                    if (int.tryParse(value) == null) {
                      return 'Please enter a valid number';
                    }
      
                    return null;
                  },
                  onChanged: (value) {
                    reward = value!;
                  },
                ),
      
                CustomTextFormField(labelText: 'End Date & Time', 
                  onChanged: null,
                  controller: _endDatetimestampController,
                  onTap: () => _selectDateTime(context),
                  validator: (value) {
                    if (value == null) {
                      return 'Please select an end date and time';
                    }
                    return null;
                  },
                ),
      
                CustomBooleanField(value: recurring, labelText: 'Recurring', 
                  onChanged: (bool value) {
                    setState(() {
                      recurring = value;
                    });
                  },
                ),
      
                CustomTextFormField(labelText: 'Recurring Interval (days)', 
                  enabled: recurring, 
                  keyboardType: TextInputType.number,
                  paddingAmount: 8,
                  validator: (value) {
                    if (!recurring) {
                      return null;
                    }
      
                    if (value == null || value.isEmpty) {
                      return 'Field is required and cannot be empty';
                    }
      
                    if (double.tryParse(value) == null) {
                      return 'Please enter a whole number';
                    }
      
                    if (int.tryParse(value) == null) {
                      return 'Please enter a valid number';
                    }
      
                    return null;
                  },
                  onChanged: (value) {
                    description = value!;
                  },
                ),
      
                CustomBooleanField(value: singleCompletion, labelText: 'Single completion', 
                  onChanged: (bool value) {
                    setState(() {
                      singleCompletion = value;
                    });
                  }
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