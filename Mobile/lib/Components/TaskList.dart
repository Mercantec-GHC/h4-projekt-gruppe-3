import 'package:flutter/material.dart';
import 'package:mobile/Components/TaskCard.dart';
import 'package:mobile/models/task.dart';
import 'package:mobile/services/app_state.dart';
import 'package:provider/provider.dart';

enum TasklistType {
  All,
  Available,
  Family,
  Assigned,
  Completed,
  Pending,
}

class Tasklist extends StatefulWidget {
  final TasklistType listType;

  const Tasklist({
    super.key,
    required this.listType,
  });

  @override
  State<Tasklist> createState() => _TasklistState();
}

class _TasklistState extends State<Tasklist> {
  late RootAppState appState;
  late String listTitle;
  late List<Task> tasks;

  @override
  void initState() {
    super.initState();
    appState = Provider.of<RootAppState>(context, listen: false);
    listTitle = _getTitle();
    tasks = [];
    _getTasks();
  }

  String _getTitle() {
    switch (widget.listType){
      case TasklistType.All:
        return 'All tasks';
      case TasklistType.Available:
        return 'Available tasks';
      case TasklistType.Family:
        return 'All the family tasks';
      case TasklistType.Assigned:
        return 'Assigned tasks';
      case TasklistType.Completed:
        return 'Completed tasks';
      case TasklistType.Pending:
        return 'Pending tasks';
      default:
        return 'This type is not supported';
    }
  }
  
  Future<Map<String, dynamic>> _contactServer() async {
    switch (widget.listType){
      case TasklistType.All:
        return await appState.getAvailableTasks(1);
      case TasklistType.Available:
        return await appState.getAvailableTasks(1);
      case TasklistType.Family:
        return await appState.getAvailableTasks(1);
      case TasklistType.Assigned:
        return await appState.getAvailableTasks(1);
      case TasklistType.Completed:
        return await appState.getAvailableTasks(1);
      case TasklistType.Pending:
        return await appState.getAvailableTasks(1);
      default:
        return { 'statusCode': '404', 'message': 'This functionality is not implemented.'};
    }
  }

  Future<List<Task>> _readServerData() async {
    Map<String, dynamic> response = await _contactServer();
    if (response['statusCode'] == 200) {
      return response['tasks'];
    }
    else {
      _openErrorPopup(response['message']);
      return [];
    }
  }

  void _getTasks() async {
    List<Task> newTasks = await _readServerData();
    setState(() {
      if (newTasks.isNotEmpty) {
        tasks.clear();
        tasks.addAll(newTasks);
      }
    });
  }

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

  @override
  Widget build(BuildContext context) {
    appState = context.watch<RootAppState>();
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
                            TaskCard(task: task, onUpdateTask: updateTask, onDeleteTask: _deleteTask),
                        
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

  void _openErrorPopup(String _errorText) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Something went wrong'),
        content: Text(_errorText),
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