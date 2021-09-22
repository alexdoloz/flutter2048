import 'package:flutter/material.dart';
import 'package:p2048/widgets/game_field_background.dart';
import 'package:p2048/widgets/you_lose_prompt.dart';
import 'widgets/game_field.dart';
import 'widgets/game_header.dart';
import 'logic/game_manager.dart';
import 'package:p2048/widgets/new_game_prompt.dart';
import 'package:p2048/widgets/you_win_prompt.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
        body: SafeArea(
          child: Padding(
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
                      ), 
                      if (status == GameState.lost)
                      Center(
                        child: SizedBox(
                          width: 400,
                          height: 400,
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              GameFieldWidget(),
                              YouLosePrompt(),
                            ],
                          ),
                        ),
                      ),
                      if (status == GameState.won)
                      Center(
                        child: SizedBox(
                          width: 400,
                          height: 400,
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              GameFieldWidget(),
                              YouWinPrompt(),
                            ],
                          ),
                        ),
                      ),
                      if (status == GameState.inProgress || status == GameState.wonInProgress)
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
        ),
    );
  }
}