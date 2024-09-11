import 'package:flutter/material.dart';
import 'package:mobile/Components/TaskList.dart';
import 'package:mobile/Components/GradiantMesh.dart';
import 'package:mobile/services/app_state.dart';
import 'package:provider/provider.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  late RootAppState _appState;

  @override
  Widget build(BuildContext context) {
    _appState = context.watch<RootAppState>();
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: MeshGradientBackground(),
          ),
          Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (_appState.user?.isParent ?? false)
                          Tasklist(
                            listType: TasklistType.Pending,
                            isTransparent: false,
                          ),
                        Tasklist(
                          listType: TasklistType.Available,
                          isTransparent: false,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
