import 'package:flutter/material.dart';
import 'package:mobile/Components/ErrorPopup.dart';
import 'package:mobile/Components/TaskCard.dart';
import 'package:mobile/models/task.dart';
import 'package:mobile/services/app_state.dart';
import 'package:provider/provider.dart';

enum TasklistType {
  All,
  Available,
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
  
  static String getTitle(TasklistType type) {
    return switch (type) {
      TasklistType.All => 'All tasks',
      TasklistType.Available => 'Available tasks',
      TasklistType.Assigned => 'Assigned tasks',
      TasklistType.Completed => 'Completed tasks',
      TasklistType.Pending => 'Pending tasks',
    };
  }

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
    listTitle = Tasklist.getTitle(widget.listType);
    tasks = [];
    _getTasks();
  }
  
  Future<Map<String, dynamic>> _contactServer() async {
    int familyId = 1;
    return switch (widget.listType) {
      TasklistType.All => await appState.getTasks('/all/${familyId}'),
      TasklistType.Available => await appState.getTasks('/available/${familyId}'),
      TasklistType.Assigned => await appState.getTasks('/assigned/${familyId}'),
      TasklistType.Completed => await appState.getTasks('/completed/${familyId}'),
      // TasklistType.Pending => await appState.getTasks('/api/task/pending/${familyId}'),

      // to get something, it need to replaced with the one above.
      TasklistType.Pending => await appState.getTasks('/api/task/all/${familyId}'),
    };
  }

  Future<List<Task>> _readServerData() async {
    Map<String, dynamic> response = await _contactServer();
    if (response['statusCode'] == 200) {
      return response['tasks'];
    }
    else {
      CustomErrorPopup.openErrorPopup(context, response['Error']);
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
    return SizedBox(
      height: 600,
      child: Card(
        elevation: 4,
        margin: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(
                color: Color.fromRGBO(245, 197, 58, 1),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(10.0),
                  topRight: Radius.circular(10.0),
                ),
              ),
              padding: EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(listTitle),
                ],
              ),
            ),
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                    color: Color.fromRGBO(217, 217, 217, 1),
                    borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(10.0),
                    bottomRight: Radius.circular(10.0),
                  ),
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
                            child: Text('There are no tasks here.'),
                          ),
                        )
                    ],
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