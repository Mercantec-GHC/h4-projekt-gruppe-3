import 'package:flutter/material.dart';
import 'package:mobile/Components/CustomPopup.dart';
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
  final bool isTransparent;

  const Tasklist({
    super.key,
    required this.listType,
    this.isTransparent = true,
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

  @override
  void initState() {
    super.initState();
    appState = Provider.of<RootAppState>(context, listen: false);
    listTitle = Tasklist.getTitle(widget.listType);
    _getTasks();
  }

  Future<Map<String, dynamic>> _getTasksFromServer() async {
    int familyId = appState.family!.id;
    return switch (widget.listType) {
      TasklistType.All => await appState.getTasks('/all/$familyId'),
      TasklistType.Available => await appState.getTasks('/available/$familyId'),
      TasklistType.Assigned => await appState.getTasks('/assigned/$familyId'),
      TasklistType.Completed => await appState.getTasks('/completed/$familyId'),
      TasklistType.Pending => await appState.getTasks('/pending/$familyId'),
    };
  }

  void _getTasks() async {
    Map<String, dynamic> response = await _getTasksFromServer();
    if (response['statusCode'] == 200) {
      setState(() {
        appState.taskList.clear();
        appState.taskList.addAll(response['tasks']);
      });
    } else {
      CustomPopup.openErrorPopup(context, errorText: response['Error']);
    }
  }

  void updateTask(Task updatedTask) {
    setState(() {
      int index = appState.taskList.indexWhere((t) => t.id == updatedTask.id);
      if (index != -1) {
        appState.taskList[index] = updatedTask;
      }
    });
  }

  void _deleteTask(Task taskToDelete) {
    setState(() {
      appState.taskList.removeWhere((t) => t.id == taskToDelete.id);
    });
  }

  @override
  Widget build(BuildContext context) {
    appState = context.watch<RootAppState>();
    return SizedBox(
      height: 600,
      child: Card(
        elevation: widget.isTransparent ? 0 : 4,
        margin: const EdgeInsets.all(16.0),
        color: Colors.transparent,
        child: Column(
          children: [
            // Header
            Container(
              decoration: BoxDecoration(
                color: widget.isTransparent
                    ? Colors.transparent
                    : const Color.fromRGBO(245, 197, 58, 1),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(10.0),
                  topRight: Radius.circular(10.0),
                ),
              ),
              padding: const EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    listTitle,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            // Content Area
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: widget.isTransparent
                      ? Colors.transparent
                      : const Color.fromRGBO(217, 217, 217, 1),
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(10.0),
                    bottomRight: Radius.circular(10.0),
                  ),
                ),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if (appState.taskList.isNotEmpty)
                        for (Task task in appState.taskList)
                          TaskCard(
                            task: task,
                            onUpdateTask: updateTask,
                            onDeleteTask: _deleteTask,
                          ),
                      if (appState.taskList.isEmpty)
                        const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Center(
                            child: Text('There are no tasks here.'),
                          ),
                        ),
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
