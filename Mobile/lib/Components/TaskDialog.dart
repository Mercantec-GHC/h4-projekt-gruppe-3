import 'package:flutter/material.dart';
import 'package:mobile/Components/ColorScheme.dart';
import 'package:mobile/Components/ErrorPopup.dart';
import 'package:mobile/Components/OutlinedText.dart';
import 'package:mobile/Components/TaskEdit.dart';
import 'package:mobile/models/task.dart';
import 'package:mobile/models/user.dart';
import 'package:mobile/services/app_state.dart';
import 'package:provider/provider.dart';

class Taskdialog extends StatefulWidget {
  const Taskdialog({
    super.key,
    required this.task,
    required this.onUpdateTask,
    required this.onDeleteTask,
  });

  final Task task;
  final Function(Task) onUpdateTask;
  final Function(Task) onDeleteTask;

  @override
  State<Taskdialog> createState() => _TaskdialogState();
}

class _TaskdialogState extends State<Taskdialog> {
  late RootAppState appState;
  List<User> userAssignedToThisTask = [];

  void _getuser() async {
    List<User> newTasks = await _getuserAssignedToThisTask();
    setState(() {
      if (newTasks.isNotEmpty) {
        userAssignedToThisTask.clear();
        userAssignedToThisTask.addAll(newTasks);
      }
    });
  }

  Future<List<User>> _getuserAssignedToThisTask() async {
    Map<String, dynamic> response = await appState.getuserAssignedToTask(widget.task.id);
    if (response['statusCode'] == 200) {
      return response['tasks'];
    }
    else {
      CustomErrorPopup.openErrorPopup(context, response['Error']);
      return [];
    }
  }

  @override
  void initState() {
    super.initState();
    appState = Provider.of<RootAppState>(context, listen: false);
    _getuser();
  }

  @override
  Widget build(BuildContext context) {
    RootAppState appState = context.watch<RootAppState>();
    Color backgroundColor = CustomColorScheme.getRandomColor();

    return GestureDetector(
      onTap: () => Navigator.of(context).pop(),
      child: Dialog(
        backgroundColor: Colors.transparent,
        child: GestureDetector(
          onTap: () {}, // Prevents the dialog from closing when tapped inside
          child: LayoutBuilder(
          builder: (context, constraints) {
            return Container(
              width: constraints.maxWidth,
              child: AlertDialog(
                backgroundColor: backgroundColor,
                scrollable: true,
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: OutlinedText(text: 'Close'),
                  ),
                  if (appState.user?.isParent ?? false)
                  TextButton(
                    onPressed: () => _editTask(context),
                    child: OutlinedText(text: 'Edit'),
                  ),
                ],
              
                title: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    OutlinedText(
                      text:  widget.task.title,
                      style: TextStyle(
                        fontSize: 23,
                        color: Colors.white,
                        fontWeight: FontWeight.bold
                      ),
                    ),
                    OutlinedText(
                      text: "Reward:" + widget.task.reward.toString(),
                      style: TextStyle(fontSize: 20, color: Colors.white),
                    ),
                  ],
                ),
                content: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    OutlinedText(text: widget.task.description),
                    SizedBox(height: 10),
                    OutlinedText(text: "Starting date: " + widget.task.startDate.toString()),
                    SizedBox(height: 10),
                    OutlinedText(text: "End date: " + widget.task.endDate.toString()),
                    SizedBox(height: 10),
                    OutlinedText(text: "Recurring: " + (widget.task.recurring ? "Yes" : "No")),
                    SizedBox(height: 5),
                    OutlinedText(text: "Recurring Interval: " + widget.task.recurringInterval.toString() + " day(s)"),
                    SizedBox(height: 10),
                    OutlinedText(text: "Single Completion: " + (widget.task.singleCompletion ? "Yes" : "No")),

                    if (userAssignedToThisTask.isNotEmpty)
                      SizedBox(height: 15),
                      OutlinedText(text: 'Children assigned:'),
                      for (User user in userAssignedToThisTask)
                        Padding(
                          padding: const EdgeInsets.only(bottom: 5, left: 5),
                          child: OutlinedText(text: user.name),
                        ),
                    if (userAssignedToThisTask.isEmpty)
                      Text('This task is not assigned to anyone.'),
                  ],
                ),
              ),
            );
            }
          ),
        ),
      ),
    );
  }
  
  void _editTask(BuildContext context) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => TaskEdit(task: widget.task)),
    );
    if (result != null) {
      final action = result['action'];
      final updatedTask = result['task'] as Task;

      if (action == 'update') {
        widget.onUpdateTask(updatedTask);
      } else if (action == 'delete') {
        widget.onDeleteTask(updatedTask);
      }
      
      Navigator.of(context).pop();
    }
  }
}