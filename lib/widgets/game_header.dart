import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

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