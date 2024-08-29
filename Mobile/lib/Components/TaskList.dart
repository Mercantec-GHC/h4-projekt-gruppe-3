
import 'package:flutter/material.dart';
import 'package:mobile/Components/TaskCard.dart';
import 'package:mobile/models/task.dart';

class TaskList extends StatelessWidget {
  const TaskList({
    super.key,
    required this.listTitle,
    required this.tasks,
    required this.onUpdateTask,
    required this.onDeleteTask,
  });

  final String listTitle;
  final List<Task> tasks;
  final Function(Task) onUpdateTask;
  final Function(Task) onDeleteTask;

  @override
  Widget build(BuildContext context) {
    final _theme = Theme.of(context);
    return SizedBox(
      height: 575,
      child: Card(
        elevation: 4,
        margin: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 8, right: 8, left: 8),
              child: Container(
                decoration: BoxDecoration(
                  color: _theme.colorScheme.primaryContainer,
                  borderRadius: BorderRadius.circular(10.0),
                ),
                padding: EdgeInsets.all(16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(listTitle),
                  ],
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  decoration: BoxDecoration(
                    color: _theme.colorScheme.primaryContainer,
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        if (tasks.isNotEmpty)
                          for (Task task in tasks)
                            TaskCard(task: task, onUpdateTask: onUpdateTask, onDeleteTask: onDeleteTask,),
                        
                        if (tasks.isEmpty) 
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Center(
                              child: Text('There are no tasks here. ^_^'),
                            ),
                          )
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}