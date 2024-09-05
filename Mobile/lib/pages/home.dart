import 'package:flutter/material.dart';
import 'package:mobile/Components/TaskList.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
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
