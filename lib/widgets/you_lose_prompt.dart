import 'package:flutter/material.dart';
import 'package:p2048/logic/game_manager.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:p2048/utils/colors.dart';
import 'package:p2048/widgets/game_button.dart';

class YouLosePrompt extends StatelessWidget {
  const YouLosePrompt({ Key? key }) : super(key: key);

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
                Text("🤦‍♂️", style: TextStyle(fontSize: 70),),
                Spacer(flex: 3,),
                Text("You lost :(",
                  textAlign: TextAlign.center,
                  
                  style: GoogleFonts.roboto(
                      textStyle: TextStyle(
                        fontSize: 40,
                        color: GameColors.darkForeground,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                ),
                Spacer(flex: 20,),
                GameButton(
                  title: "Restart game", 
                  onPressed: () {
                    GameManager.shared.resetGame();
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