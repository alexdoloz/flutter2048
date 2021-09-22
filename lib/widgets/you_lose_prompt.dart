import 'package:flutter/material.dart';
import 'package:p2048/logic/game_manager.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:p2048/widgets/game_button.dart';

class YouLosePrompt extends StatelessWidget {
  const YouLosePrompt({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Color(0xaaeee4da),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(),
          SizedBox(
            width: 200,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text("You lost :(",
                  textAlign: TextAlign.center,
                  style: GoogleFonts.roboto(
                      textStyle: TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                ),
                GameButton(
                  title: "Restart game", 
                  onPressed: () {
                    GameManager.shared.resetGame();
                  }
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}