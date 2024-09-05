import 'package:flutter/material.dart';
import 'package:mobile/Components/ColorScheme.dart';
import 'package:mobile/Components/taskCreationDialog.dart';


class QuickAction extends StatefulWidget {
  const QuickAction({super.key});

  @override
  State<QuickAction> createState() => _QuickActionState();
}

class _QuickActionState extends State<QuickAction> {
  bool _isPanelVisible = false;
  final double panelWidth = 200;
  final double panelHeight = 125;

  void _togglePanel() {
    setState(() {
      _isPanelVisible = !_isPanelVisible;
    });
  }

  void _closePanel() {
    setState(() {
      _isPanelVisible = false;
    });
  }
  
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        if (_isPanelVisible)
          GestureDetector(
            onTap: _closePanel,  // Close panel when tapping outside
            child: Container(
              color: Colors.transparent,
            ),
          ),
        AnimatedPositioned(
          duration: Duration(milliseconds: 300),
          bottom: _isPanelVisible ? 80 : -200,
          right: 16,
          child: GestureDetector(
            onTap: () {},
            child: Container(
              width: panelWidth,
              height: panelHeight,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 10,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      SizedBox(height: 5),
                      Text('Quick Actions',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold
                        ),
                      ),
                      SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('Create task',
                            style: TextStyle(
                              fontSize: 20
                            ),
                          ),
                          SizedBox(width: 5),
                          FloatingActionButton(
                            elevation: 2,
                            child: Icon(Icons.add),
                            onPressed: () => showDialog(
                              context: context,
                              builder: (context) => TaskCreation(),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
        Positioned(
          bottom: 16,
          right: 16,
          child: FloatingActionButton(
            backgroundColor: CustomColorScheme.menu,
            onPressed: _togglePanel,
            child: Icon(_isPanelVisible ? Icons.close : Icons.add),
          ),
        ),
      ],
    );
  }
}
