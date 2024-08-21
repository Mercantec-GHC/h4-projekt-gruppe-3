import 'package:flutter/material.dart';
import 'package:mobile/Components/Navigation.dart';
import 'package:mobile/services/app_state.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => RootAppState(),
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'ChoreCash',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
            seedColor: const Color.fromARGB(255, 4, 57, 77)),
      ),
      home: NavigationComponent(),
    );
  }
}
