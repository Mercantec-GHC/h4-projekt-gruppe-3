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
  // late RootAppState _appState;

  void createTask(Task newTask) {
  //   setState(() {
  //     _getTasks();
  //   });
  }

  @override
  void initState() {
    super.initState();
    // _appState = Provider.of<RootAppState>(context, listen: false);
  }

  @override
  Widget build(BuildContext context) {
    // RootAppState _appState = context.watch<RootAppState>();
    final _theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
        backgroundColor: _theme.colorScheme.primaryContainer,
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () =>
              showDialog(
                context: context,
                builder: (context) => TaskCreation(onCreateTask: createTask),
              )
          ),
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
