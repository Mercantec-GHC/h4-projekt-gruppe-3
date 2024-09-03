import 'package:flutter/material.dart';
import 'package:mobile/Components/TaskEdit.dart';
import 'package:mobile/models/task.dart';

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
  @override
  Widget build(BuildContext context) {
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
                scrollable: true,
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text('Close'),
                  ),
                  TextButton(
                    onPressed: () => _editTask(context),
                    child: Text('Edit'),
                  ),
                ],
              
                title: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.task.title,
                      maxLines: 2,
                      style: TextStyle(
                        fontSize: 23, 
                        fontWeight: FontWeight.bold
                      ),
                    ),
                    Text(
                      "Reward:" + widget.task.reward.toString(),
                      style: TextStyle(fontSize: 15, fontWeight: FontWeight.normal),
                    ),
                  ],
                ),
                content: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(widget.task.description),
                    SizedBox(height: 10),
                    Text("Start date: " + widget.task.startDate.toString()),
                    SizedBox(height: 10),
                    Text("End date: " + widget.task.endDate.toString()),
                    SizedBox(height: 10),
                    Text("Recurring: " + (widget.task.recurring ? "Yes" : "No")),
                    SizedBox(height: 5),
                    Text("Recurring Interval: " + widget.task.recurringInterval.toString() + " day(s)"),
                    SizedBox(height: 10),
                    Text("Single Completion: " + (widget.task.singleCompletion ? "Yes" : "No")),
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