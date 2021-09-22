import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ScoreWidget extends StatelessWidget {
  final String scoreLabel;
  final String score;

  const ScoreWidget({ 
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
        constraints: BoxConstraints(maxWidth: 120),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Spacer(flex: 3,),
              Text(
                scoreLabel.toUpperCase(),
                textAlign: TextAlign.center,
                style: GoogleFonts.roboto(
                  textStyle: TextStyle(
                    color: Color(0xffeee4da),
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              Spacer(flex: 1,),
              Text(
                score,
                textAlign: TextAlign.center,
                style: GoogleFonts.roboto(
                  textStyle: TextStyle(
                    color: Color(0xffffffff),
                    fontSize: 25,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              Spacer(flex: 2,),
            ],
          ),
        ),
      ),
    );
  }
}