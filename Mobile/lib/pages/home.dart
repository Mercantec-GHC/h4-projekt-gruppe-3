import 'package:flutter/material.dart';
import 'package:mobile/Components/TaskList.dart';
import 'package:mobile/Components/taskCreationDialog.dart';
import 'package:mobile/models/task.dart';
import 'package:mobile/services/app_state.dart';
import 'package:provider/provider.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  void createTask(Task newTask) {}

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final _theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
        backgroundColor: _theme.colorScheme.primaryContainer,
        actions: [
          IconButton(
              icon: Icon(Icons.add),
              onPressed: () => showDialog(
                    context: context,
                    builder: (context) =>
                        TaskCreation(onCreateTask: createTask),
                  )),
        ],
      ),
      backgroundColor: _theme.colorScheme.primaryContainer,
      body: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Tasklist(listType: TasklistType.All),
          ],
        ),
      ),
    );
  }
}
