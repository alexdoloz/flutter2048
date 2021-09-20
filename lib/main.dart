import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:p2048/widgets/game_field.dart';
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

// ignore: must_be_immutable
class ScoreWidget extends StatelessWidget {
  String scoreLabel;
  String score;

  ScoreWidget({ 
    required String scoreLabel, 
    required String score, 
    Key? key
  }) :
    this.scoreLabel = scoreLabel,
    this.score = score,
    super(key: key);

  @override
  Widget build(BuildContext context) {
    final decoration = BoxDecoration(
      borderRadius: BorderRadius.all(Radius.circular(5)),
      color: Color(0xffad9d8f),
    );
    return SizedBox(
        height: 60,

        child: Container(
          decoration: decoration,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text(
                  scoreLabel.toUpperCase(),
                  style: GoogleFonts.roboto(
                    textStyle: TextStyle(
                      color: Color(0xffeee4da),
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                  ),),
                ),
                Text(
                  score,
                  style: GoogleFonts.roboto(
                    textStyle: TextStyle(
                      color: Color(0xffffffff),
                      fontSize: 25,
                      fontWeight: FontWeight.w700,
                  ),),
                ),
            ],
        ),
          ),
      ),
    );
  }
}

class GameHeader extends StatelessWidget {
  const GameHeader({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      child: Text(
        '2048', 
        style: GoogleFonts.roboto(
          textStyle: TextStyle(
            color: Color(0xff776e65), 
            fontWeight: FontWeight.w700, 
            fontSize: 80
          )
        ),
      ),
    );
  }
}