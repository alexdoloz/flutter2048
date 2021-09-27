import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/material.dart';
import 'package:p2048/widgets/centered_square.dart';
import 'package:p2048/widgets/game_field_background.dart';
import 'package:p2048/widgets/you_lose_prompt.dart';
import 'widgets/game_field.dart';
import 'widgets/game_header.dart';
import 'logic/game_manager.dart';
import 'package:p2048/widgets/new_game_prompt.dart';
import 'package:p2048/widgets/you_win_prompt.dart';

void main() {
  runApp(App());
}

var player = AssetsAudioPlayer();

class App extends StatelessWidget {
   Widget _widgetForStatus(GameState status) {
    switch (status) {
    case GameState.notStarted: return CenteredSquare(
      key: ValueKey(0),
      children: [
        GameFieldBackground(),
        NewGamePrompt(),
      ],
    );
    case GameState.lost: return CenteredSquare(
      key: ValueKey(1),
      children: [
        GameFieldWidget(),
        YouLosePrompt(),
      ]
    );
    case GameState.inProgress:
    case GameState.wonInProgress: return CenteredSquare(
      key: ValueKey(2),
      children: [GameFieldWidget()],
    );
    case GameState.won: return CenteredSquare(
      key: ValueKey(3),
      children: [
        GameFieldWidget(),
        YouWinPrompt(),
      ]
    );
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter 2048',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
        body: Builder(
          builder: (context) {
            return SafeArea(
              child: Container(
                color: Color(0xfffaf8ef),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(0, 20, 0, 30),
                  child: ValueListenableBuilder(
                    valueListenable: GameManager.shared.status,
                    builder: (_, GameState status, __) {
                      return Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        mainAxisSize: MainAxisSize.max,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ElevatedButton(onPressed: () { 
                            GameManager.shared.status.value = GameState.lost;
                          }, child: Text("lose")),
                          ElevatedButton(onPressed: () { 
                            GameManager.shared.status.value = GameState.won;
                          }, child: Text("win")),
                          GameHeader(),
                          Spacer(),
                          AnimatedSwitcher(
                            duration: Duration(milliseconds: 250), 
                            child: _widgetForStatus(status),
                          ),
                          Spacer(),
                        ],
                      );
                    }
                  ),
                ),
              ),
            );
          }
        ),
        ),
    );
  }
}