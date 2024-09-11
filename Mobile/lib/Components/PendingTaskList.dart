import 'package:flutter/material.dart';
import 'package:mobile/Components/ColorScheme.dart';
import 'package:mobile/Components/CustomPopup.dart';
import 'package:mobile/Components/TaskCard.dart';
import 'package:mobile/Components/TaskList.dart';
import 'package:mobile/models/task.dart';
import 'package:mobile/services/app_state.dart';
import 'package:provider/provider.dart';

class Tasklist extends StatefulWidget {
  final TasklistType listType = TasklistType.Pending;
  final bool isTransparent;

  const Tasklist({
    super.key,
    this.isTransparent = true,
  });

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
    listTitle = 'Task waiting for approval';
    _getTasks();
  }

  void _getTasks() async {
    int familyId = appState.family!.id;
    Map<String, dynamic> response =
        await appState.getTasks('/pending/$familyId');
    if (response['statusCode'] == 200) {
      appState.addListOfTasks(response['tasks'], widget.listType);
    } else {
      CustomPopup.openErrorPopup(context, errorText: response['Error']);
    }
  }

  void updateTask(Task updatedTask) {
    setState(() {
      int? index = appState.taskList[widget.listType]
          ?.indexWhere((t) => t.id == updatedTask.id);
      if (index != -1 && index != null) {
        appState.taskList[widget.listType]?[index] = updatedTask;
      }
    });
  }

  void _deleteTask(Task taskToDelete) {
    setState(() {
      appState.taskList[widget.listType]
          ?.removeWhere((t) => t.id == taskToDelete.id);
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
                    : CustomColorScheme.secondary,
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
                      : CustomColorScheme.menu,
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
                        for (Task task
                            in appState.taskList[widget.listType] ?? [])
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
