import 'package:flutter/material.dart';
import 'package:p2048/widgets/game_field_background.dart';
import 'widgets/game_field.dart';
import 'widgets/game_header.dart';
import 'logic/game_manager.dart';
import 'package:p2048/widgets/new_game_prompt.dart';

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
          child: ValueListenableBuilder(
            valueListenable: GameManager.shared.status,
            builder: (_, status, __) {
              return Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(flex: 1, child: GameHeader()),
                    if (status == GameState.notStarted) 
                    Center(
                      child: SizedBox(
                        width: 400,
                        height: 400,
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            GameFieldBackground(),
                            NewGamePrompt()
                          ],
                        ),
                      ),
                    ) else 
                    Center(
                      child: SizedBox(
                        width: 400,
                        height: 400,
                        child: GameFieldWidget(),
                      ),
                    ),
                    Spacer(flex: 1,)
                  ],
                );
            }
          ),
          ),
        ),
    );
  }
}