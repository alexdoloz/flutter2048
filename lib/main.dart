import 'package:flutter/material.dart';
import 'widgets/game_field.dart';
import 'widgets/game_header.dart';
import 'logic/game_manager.dart';

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
        body: Padding(
          padding: const EdgeInsets.fromLTRB(0, 20, 0, 10),
          child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(flex: 1, child: GameHeader()),
                ElevatedButton(onPressed: () {
                  GameManager.shared.tap();
                }, child: Text("Tap")),
                ElevatedButton(onPressed: () {
                  if (GameManager.shared.status.value == GameState.notStarted) {
                    GameManager.shared.startGame();
                  } else {
                    GameManager.shared.resetGame();
                  }
                }, 
                child: Text("New game")),
                Center(
                  child: SizedBox(
                    width: 400,
                    height: 400,
                    child: GameFieldWidget(),
                  ),
                ),
                Spacer(flex: 1,)
              ],
            ),
          ),
        ),
    );
  }
}