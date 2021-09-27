import 'package:flutter/material.dart';
import 'dart:math';
import 'package:google_fonts/google_fonts.dart';
import 'package:p2048/utils/colors.dart';

class GameTile extends StatelessWidget {
  static const tileSize = 80.0;
  final int power;

  List<Color> get _backgroundColors => GameColors.tileBackground;
  Color get _backgroundColor => 
    power >= _backgroundColors.length ? 
      _backgroundColors.last : _backgroundColors[power];
  Color get _textColor => power < 4 && power > 1 ? 
    GameColors.darkForeground : 
    GameColors.lightForeground;
  String get _tileText => '${pow(2, power)}';
  double get _textSize => 45.0 - (_tileText.length - 1) * 5;

  GameTile(this.power);
  GameTile.empty() : power = 0;

  @override
  Widget build(BuildContext context) {
    final textWidget = Text(
      _tileText,
      style: GoogleFonts.roboto(
        textStyle: TextStyle(
          fontSize: _textSize, 
          color: _textColor,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
    final border = Border.fromBorderSide(
      BorderSide(
        color: Colors.transparent,
        style: BorderStyle.solid,
        width: 0.0,
      )
    );
    return Container(
      decoration: BoxDecoration(
        border: border,
        borderRadius: BorderRadius.circular(5.0),
        color: _backgroundColor,
      ),
      width: tileSize,
      height: tileSize,
      alignment: Alignment.center, 
      child: power == 0 ? null : textWidget,
    );
  }
}