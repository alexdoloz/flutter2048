import 'package:flutter/material.dart';
import 'package:p2048/logic/game_manager.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:p2048/utils/colors.dart';
import 'package:p2048/widgets/game_button.dart';

class YouWinPrompt extends StatelessWidget {
  const YouWinPrompt({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: GameColors.semiTransparentBackground,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(),
          SizedBox(
            width: 200,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Spacer(flex: 8,),
                Text("👏", style: TextStyle(fontSize: 70),),
                Spacer(flex: 3,),
                Text("You win!",
                  textAlign: TextAlign.center,
                  style: GoogleFonts.roboto(
                    textStyle: TextStyle(
                      fontSize: 40,
                      color: GameColors.darkForeground,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
                Text(
                  "You can continue playing or start the new game",
                  textAlign: TextAlign.center,
                  style: GoogleFonts.roboto(
                    textStyle: TextStyle(
                      fontSize: 25,
                      color: GameColors.darkForeground,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                Spacer(flex: 20,),
                GameButton(
                  title: "New game", 
                  onPressed: () {
                    GameManager.shared.startGame();
                  }
                ),
                Spacer(flex: 4,),
                GameButton(
                  title: "Continue", 
                  onPressed: () {
                    GameManager.shared.continuePlaying();
                  }
                ),
                Spacer(flex: 20,),
              ],
            ),
          ),
        ],
      ),
    );
  }
}