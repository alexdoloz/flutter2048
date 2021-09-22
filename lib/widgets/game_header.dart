import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:p2048/logic/game_manager.dart';
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
          children: [
            Expanded(
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
            ),
            ValueListenableBuilder(
              valueListenable: GameManager.shared.score,
              builder: (_, score, __) =>
                ScoreWidget(scoreLabel: "Score", score: '$score'),
            ),
            SizedBox(
              width: 20,
            ),
            ValueListenableBuilder(
              valueListenable: GameManager.shared.bestScore,
              builder: (_, bestScore, __) =>
                ScoreWidget(scoreLabel: "Best", score: '$bestScore'),
            ),
          ],
        ),
      ),
    );
  }
}