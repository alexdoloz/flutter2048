import 'package:flutter/material.dart';
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
          child: Container(
            color: Color(0xfffaf8ef),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(0, 20, 0, 30),
              child: ValueListenableBuilder(
                valueListenable: GameManager.shared.status,
                builder: (_, status, __) {
                  return Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      mainAxisSize: MainAxisSize.max,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                            height: 130,
                            child: GameHeader(),
                        ),
                        Spacer(),
                        if (status == GameState.notStarted) 
                        CenteredSquare(
                          children: [
                            GameFieldBackground(),
                            NewGamePrompt(),
                          ],
                        ),
                        if (status == GameState.lost)
                        CenteredSquare(
                          children: [
                            GameFieldWidget(),
                            YouLosePrompt(),
                          ]
                        ),
                        if (status == GameState.won)
                        CenteredSquare(
                          children: [
                            GameFieldWidget(),
                            YouWinPrompt(),
                          ]
                        ),
                        if (
                          status == GameState.inProgress || 
                          status == GameState.wonInProgress
                        )
                        CenteredSquare(
                          children: [GameFieldWidget()],
                        ),
                      ],
                    );
                }
              ),
              ),
          ),
        ),
        ),
    );
  }
}

class CenteredSquare extends StatelessWidget {
  final List<Widget> children;

  const CenteredSquare({ 
    Key? key, 
    required List<Widget> children 
  }) : 
    this.children = children,
    super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: 400,
        height: 400,
        child: Stack(
          alignment: Alignment.center,
          children: children,
        ),
      ),
    );
  }
}