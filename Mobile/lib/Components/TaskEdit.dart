import 'package:flutter/material.dart';
import 'package:mobile/Components/CustomPopup.dart';
import 'package:mobile/Components/SelectDateTime.dart';
import 'package:mobile/models/task.dart';
import 'package:mobile/services/app_state.dart';
import 'package:provider/provider.dart';

class TaskEdit extends StatefulWidget {
  final Task task;

  const TaskEdit({
    super.key,
    required this.task,
  });

  @override
  State<TaskEdit> createState() => _TaskEditState();
}

class _TaskEditState extends State<TaskEdit> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _endDatetimestampController = TextEditingController();
  late RootAppState _appState;
  
  late int id;
  late String title;
  late String description;
  late String reward;
  late DateTime endDate;
  late bool recurring;
  late String recurringInterval;
  late bool singleCompletion;
  
  @override
  void initState() {
    super.initState();
    Task oldTask = widget.task;
    id = oldTask.id;
    title = oldTask.title;
    description = oldTask.description;
    reward = oldTask.reward.toString();
    endDate = oldTask.endDate;
    recurring = oldTask.recurring;
    recurringInterval = oldTask.recurringInterval.toString();
    singleCompletion = oldTask.singleCompletion;

    _endDatetimestampController.text = endDate.toString();
  }

  void _deleteTaskConfirmation() {
    CustomPopup.openDeleteTaskConfirmation(context, _deleteTask);
  }

  void _deleteTask() async {
    int statusCode = await _appState.deleteTask(id);
    if (statusCode == 204) {
      Navigator.of(context).pop({'action': 'delete', 'task': widget.task});
    }
    else {
      CustomPopup.openErrorPopup(context);
    }
  }

  void _updateTask() async {
    if (_formKey.currentState!.validate()) {
      int reward = int.parse(this.reward);
      int recurringInterval = int.parse(this.recurringInterval);
      Task task = new Task(id, title, description, reward, widget.task.startDate, endDate, recurring, recurringInterval, singleCompletion);
      
      int response = await _appState.updateTask(task);
      if(response == 200) {
        setState(() {
          // Can't override task because it is a final
          widget.task.title = title;
          widget.task.description = description;
          widget.task.reward = reward;
          widget.task.endDate = endDate;
          widget.task.recurring = recurring;
          widget.task.recurringInterval = recurringInterval;
          widget.task.singleCompletion = singleCompletion;
        });
        Navigator.of(context).pop({'action': 'update', 'task': widget.task});
      }
      else {
        CustomPopup.openErrorPopup(context);
      }
    }
  }

  Future<void> _selectDateTime() async {
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
      title: Row(
        children: [
          Text('Edit task'),
          Spacer(),
          TextButton(
            onPressed: _deleteTaskConfirmation,
            child: Text('Delete'),
          ),
        ],
      ), 
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text('Cancel'),
        ),
        TextButton(
          onPressed: _updateTask,
          child: Text('Save'),
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
                  initialValue: title,
                  maxLength: 100,
                  autovalidateMode: AutovalidateMode.onUnfocus,
                  decoration: InputDecoration(labelText: 'Title'),
                  onChanged: (value) => title = value,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Field is required and cannot be empty';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16),
                TextFormField(
                  initialValue: description,
                  maxLines: 3,
                  maxLength: 255,
                  autovalidateMode: AutovalidateMode.onUnfocus,
                  decoration: InputDecoration(labelText: 'Description'),
                  onChanged: (value) => description = value,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Field is required and cannot be empty';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16),
                TextFormField(
                  initialValue: reward,
                  keyboardType: TextInputType.number,
                  autovalidateMode: AutovalidateMode.onUnfocus,
                  decoration: InputDecoration(labelText: 'Reward'),
                  onChanged: (value) => reward = value,
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
                ),
                SizedBox(height: 16),
                TextFormField(
                  decoration: InputDecoration(labelText: 'End Date & Time'),
                  onTap: _selectDateTime,
                  controller: _endDatetimestampController,
                  validator: (value) {
                    if (value == null) {
                      return 'Please select an end date and time';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: Text('Recurring'),
                    ),
                    Switch(
                      value: recurring,
                      onChanged: (value) => setState(() {
                        recurring = value;
                      }),
                    ),
                  ],
                ),
                SizedBox(height: 16),
                TextFormField(
                  initialValue: recurringInterval,
                  enabled: recurring,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(labelText: 'Recurring Interval'),
                  onChanged: (value) => recurringInterval = value,
                  validator: (value) {
                    if (!recurring) {
                      return null;
                    }

                    if (value == null) {
                      return 'Please select a recurring interval';
                    }

                    if (double.tryParse(value) == null) {
                      return 'Please enter a whole number';
                    }
      
                    if (int.tryParse(value) == null) {
                      return 'Please enter a valid number';
                    }

                    return null;
                  },
                ),
                SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: Text('Single Completion'),
                    ),
                    Switch(
                      value: singleCompletion,
                      onChanged: (value) => setState(() {
                        singleCompletion = value;
                      }),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}