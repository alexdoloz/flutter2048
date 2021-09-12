import 'package:flutter/material.dart';
import 'package:p2048/widgets/game_field.dart';

void main() {
  runApp(App());
}

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter 2048',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
        body: Center(
          child: GameFieldWidget(),
        ),
      ),
    );
  }
}