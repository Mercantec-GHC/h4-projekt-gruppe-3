import 'package:flutter/material.dart';
import 'package:mobile/Components/ColorScheme.dart';
import 'package:mobile/Components/TaskDialog.dart';
import 'package:mobile/config/task_list_types.dart';
import 'package:mobile/models/task.dart';

class TaskCard extends StatelessWidget {
  const TaskCard({
    super.key,
    required this.task,
    required this.onUpdateTask,
    required this.onDeleteTask,
    required this.currentListType,
  });

  final Task task;
  final Function(Task) onDeleteTask;
  final Function(Task) onUpdateTask;
  final TasklistType currentListType;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => OpenDetailedDescription(context),
      child: Container(
        width: double.infinity,
        margin: EdgeInsets.all(6),
        child: Card(
          color: CustomColorScheme.getRandomColor(),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0),
          ),
          child: Padding(
            padding: const EdgeInsets.all(17.5),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  isTextOverflowing(context, task.title),
                  style: TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 7.5),
                Text(
                  isTextOverflowing(context, task.description),
                  style: TextStyle(
                    fontSize: 16.0,
                    color: Colors.black54,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void OpenDetailedDescription(BuildContext context) async {
    showDialog(
      context: context,
      builder: (context) => Taskdialog(
        task: task,
        onUpdateTask: onUpdateTask,
        onDeleteTask: onDeleteTask,
        currentListType: currentListType,
      ),
    );
  }

  String isTextOverflowing(BuildContext context, String text) {
    final TextPainter textPainter = TextPainter(
      text: TextSpan(
        text: text,
        style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
      ),
      maxLines: 1,
      textDirection: TextDirection.ltr,
    )..layout(maxWidth: MediaQuery.of(context).size.width);

    // Check where the text overflows
    int endIndex = text.length;
    while (endIndex > 0 && textPainter.didExceedMaxLines) {
      endIndex--;
      textPainter.text = TextSpan(
        text: text.substring(0, endIndex) + '...',
        style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
      );
      textPainter.layout(maxWidth: MediaQuery.of(context).size.width - 15);
    }

    return text.substring(0, endIndex) + (endIndex < text.length ? '...' : '');
  }
}
