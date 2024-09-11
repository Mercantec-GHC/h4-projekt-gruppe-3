import 'package:flutter/material.dart';
import 'package:mobile/Components/TaskList.dart';
import 'package:mobile/Components/GradiantMesh.dart'; // Make sure this import is correct and refers to your gradient

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
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child:
                MeshGradientBackground(),
          ),
          // Main content
          Column(
            children: [
              Expanded(
                child: Tasklist(
                  key: ValueKey(widget.type),
                  listType: widget.type,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
