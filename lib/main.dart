import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'MyState.dart';
import 'HomeView.dart';

void main() {
  var state = MyState();

  runApp(
    ChangeNotifierProvider(
      create: (context) => state,
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'To-do List',
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
      ),
      home: const HomeView(),
    );
  }
}
