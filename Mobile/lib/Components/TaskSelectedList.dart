import 'package:flutter/material.dart';
import 'package:mobile/Components/TaskList.dart';

class TaskSelectedList extends StatefulWidget {
  const TaskSelectedList({
    super.key,
    required this.type,
  });

  final TasklistType type;

  @override
  State<TaskSelectedList> createState() => _TaskSelectedListState();
}

class _TaskSelectedListState extends State<TaskSelectedList> {
  @override
  Widget build(BuildContext context) {
    final _theme = Theme.of(context);
    final String title = Tasklist.getTitle(widget.type);

    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        backgroundColor: _theme.colorScheme.primaryContainer,
      ),
      backgroundColor: _theme.colorScheme.primaryContainer,
      body: Tasklist(
        key: ValueKey(widget.type),
        listType: widget.type,
      ),
    );
  }
}