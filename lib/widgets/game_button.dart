import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:p2048/utils/colors.dart';

class GameButton extends StatelessWidget {
  final Function onPressed;
  final String title;

  const GameButton({ 
    Key? key, 
    required String title,
    required Function onPressed 
  }) : 
    this.onPressed = onPressed, 
    this.title = title,
    super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        primary: GameColors.darkForeground,
        textStyle: GoogleFonts.roboto(
          textStyle: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.bold
          ),
        ),
      ),
      onPressed: () {
        onPressed();
      }, 
      child: Text(title.toUpperCase())
    );
  }
}