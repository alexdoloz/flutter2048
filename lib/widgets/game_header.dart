import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:p2048/logic/game_manager.dart';
import 'package:p2048/widgets/game_button.dart';
import 'package:p2048/widgets/score_widget.dart';

class GameHeader extends StatelessWidget {
  const GameHeader({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              flex: 1,
              child: ValueListenableBuilder(
                valueListenable: GameManager.shared.status,
                child: Text(
                  '2048', 
                  textAlign: TextAlign.center,
                  style: GoogleFonts.roboto(
                    textStyle: TextStyle(
                      color: Color(0xff776e65), 
                      fontWeight: FontWeight.w700, 
                      fontSize: 80
                    )
                  ),
                ),
                builder: (context, status, header) {
                  return Column(
                    children: [
                      header!,
                      if (
                        status == GameState.inProgress || 
                        status == GameState.wonInProgress
                      ) GameButton(
                        title: "Restart game", 
                        onPressed: () {
                          _showAlertDialog(context);
                        }
                      ),
                    ],
                  );
                }
              ),
            ),
            Container(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                mainAxisSize: MainAxisSize.max,
                children: [
                  ValueListenableBuilder(
                    valueListenable: GameManager.shared.score,
                    builder: (_, int score, __) =>  
                      ScoreWidget(scoreLabel: "Score", score: score),
                  ),
                  SizedBox(height: 10,),
                  ValueListenableBuilder(
                    valueListenable: GameManager.shared.bestScore,
                    builder: (_, int bestScore, __) =>
                      ScoreWidget(scoreLabel: "Best", score: bestScore),
                  ),
                ],
              ),
            ), 
          ],
        ),
      ),
    );
  }

  _showAlertDialog(BuildContext context) {
    Widget restartButton = TextButton(
      child: Text("Restart"),
      onPressed: () { 
        GameManager.shared.resetGame();
        Navigator.pop(context);
      },
    );

    Widget cancelButton = TextButton(
      child: Text("Cancel"),
      onPressed: () {
        Navigator.pop(context);
      },
    );

    AlertDialog alert = AlertDialog(
      title: Text("Do you really want to restart the game?"),
      content: Text("All current progress will be lost."),
      actions: [
        restartButton,
        cancelButton,
      ],
    );

    showDialog(
      context: context,
      builder: (BuildContext context) => alert,
    );
  }
}