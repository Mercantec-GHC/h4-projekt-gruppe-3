import 'package:flutter/material.dart';
import 'package:mobile/Components/SelectDateTime.dart';
import 'package:mobile/config/app_pages.dart';
import 'package:mobile/models/task.dart';
import 'package:mobile/services/app_state.dart';
import 'package:provider/provider.dart';

class TaskEdit extends StatefulWidget {
  final Task task;
  
  const TaskEdit({
    super.key,
    required this.task
  });

  @override
  State<TaskEdit> createState() => _TaskEditState();
}

class _TaskEditState extends State<TaskEdit> {
  final _formKey = GlobalKey<FormState>();
  final Selectdatetime selectdatetime = new Selectdatetime();
  final TextEditingController _endDatetimestampController = TextEditingController();
  late RootAppState _appState;
  
  late Task oldTask;
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
    oldTask = widget.task;
    title = oldTask.title;
    description = oldTask.description;
    reward = oldTask.reward.toString();
    endDate = oldTask.endDate;
    recurring = oldTask.recurring;
    recurringInterval = oldTask.recurringInterval.toString();
    singleCompletion = oldTask.singleCompletion;

    _endDatetimestampController.text = endDate.toString();
  }

  void _deleteTaskConfimation() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Delete task: ' + oldTask.title),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text('Close'),
          ),
          TextButton(
            onPressed: _deleteTask,
            child: Text('Confirm'),
          ),
        ],
      ),
    );
  }

  void _deleteTask() async {
    int statusCode = await _appState.deleteTask(oldTask.id);
    if (statusCode == 204) {
      Navigator.of(context).pop();
      Navigator.of(context).pop();
      Navigator.of(context).pop();
      _appState.switchPage(_appState.page);
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

  void _updateTask() async {
    int reward = int.parse(this.reward);
    int recurringInterval = int.parse(this.recurringInterval);
    Task task = new Task(oldTask.id, title, description, reward, endDate, recurring, recurringInterval, singleCompletion);
    int response = await _appState.updateTask(task);
    if(response == 200) {
      // Closes both alert dialog.
      Navigator.of(context).pop();
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

  Future<void> _selectDateTime(BuildContext context) async {
    DateTime? newDateTime = await selectdatetime.SelectDateTime(context);

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
            onPressed: _deleteTaskConfimation,
            child: Text('Delete'),
          ),
        ],
      ), 
      // Text('Edit task'),
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
                      return 'Please enter a hold number';
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
                  onTap: () => _selectDateTime(context),
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
                  enabled: recurring,
                  decoration: InputDecoration(labelText: 'Recurring Interval'),
                  onChanged: (value) => recurringInterval = value,
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