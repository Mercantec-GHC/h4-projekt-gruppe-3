import 'package:english_words/english_words.dart';
import 'package:flutter/material.dart';
import 'package:mobile/Components/TaskCard.dart';
import 'package:mobile/Components/taskCreationDialog.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    final _theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () =>
              showDialog(
                context: context,
                builder: (context) => TaskCreation(),
              )
          ),
        ],
      ),
      backgroundColor: _theme.colorScheme.primaryContainer,
      body: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              height: 575,
              child: Card(
                elevation: 4,
                margin: EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 8, right: 8, left: 8),
                      child: Container(
                        decoration: BoxDecoration(
                          color: _theme.colorScheme.primaryContainer,
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        padding: EdgeInsets.all(16),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text('Active Tasks'),
                          ],
                        ),
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          decoration: BoxDecoration(
                            color: _theme.colorScheme.primaryContainer,
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          child: SingleChildScrollView(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                for (var i = 0; i < 10; i++)
                                  TaskCard(
                                    taskId: i, 
                                    title: WordPair.random().toString(), 
                                    description: 'This is the description of the card. It provides more details about the content or purpose of the card.'
                                  )
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}