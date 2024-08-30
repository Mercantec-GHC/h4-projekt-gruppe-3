import 'package:flutter/material.dart';
import 'package:mobile/Components/TaskList.dart';
import 'package:mobile/Components/taskCreationDialog.dart';
import 'package:mobile/models/task.dart';
import 'package:mobile/services/app_state.dart';
import 'package:provider/provider.dart';

class AssignedTasks extends StatefulWidget {
  const AssignedTasks({super.key});

  @override
  State<AssignedTasks> createState() => _AssignedTasksState();
}

class _AssignedTasksState extends State<AssignedTasks> {
  late RootAppState _appState;
  List<Task> tasks = [];

  void createTask(Task newTask) {
    setState(() {
      _getTasks();
    });
  }

  void updateTask(Task updatedTask) {
    setState(() {
      int index = tasks.indexWhere((t) => t.id == updatedTask.id);
      if (index != -1) {
        tasks[index] = updatedTask;
      }
    });
  }

  void _deleteTask(Task taskToDelete) {
    setState(() {
      tasks.removeWhere((t) => t.id == taskToDelete.id);
    });
  }

  Future<void> _getTasks() async {
    Map<String, dynamic> response = await _appState.getAvailableTasks(1);
    if (response['statusCode'] == 200) {
      setState(() {
        tasks.clear();
        tasks.addAll(response['tasks']);
      });
    } else {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Something went wrong'),
          content: Text(response['Error']['message']),
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

  @override
  void initState() {
    super.initState();
    _appState = Provider.of<RootAppState>(context, listen: false);
    _getTasks();
  }

  @override
  Widget build(BuildContext context) {
    _appState = context.watch<RootAppState>();
    final _theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Assigned Tasks'),
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
        actions: [
          IconButton(
              icon: Icon(Icons.add),
              onPressed: () => showDialog(
                    context: context,
                    builder: (context) => TaskCreation(
                      onCreateTask: createTask,
                    ),
                  )),
        ],
      ),
      backgroundColor: _theme.colorScheme.primaryContainer,
      body: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TaskList(
              listTitle: 'Active Tasks',
              tasks: tasks,
              onUpdateTask: updateTask,
              onDeleteTask: _deleteTask,
            ),
          ],
        ),
      ),
    );
  }
}
