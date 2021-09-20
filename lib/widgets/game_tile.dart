import 'package:flutter/material.dart';
import 'dart:math';
import 'package:google_fonts/google_fonts.dart';

class GameTile extends StatelessWidget {
  static const tileSize = 80.0;
  final int power;

  Color get _backgroundColor => 
    power >= _backgroundColors.length ? 
      _backgroundColors.last : _backgroundColors[power];
  Color get _textColor => power < 4 && power > 1 ? 
    Color(0xff776e65) : 
    Color(0xfff9f6f2);
  String get _tileText => '${pow(2, power)}';
  double get _textSize => 45.0 - _tileText.length;

  static List<Color> _backgroundColors = [
    Color(0x59eee4da), 
    Colors.pink[300]!, 
    Color(0xffede0c8),
    Color(0xfff2b179),
    Color(0xfff59563), 
    Color(0xfff67c5f), 
    Color(0xfff65e3b), 
    Color(0xffedcf72),
    Color(0xffedcc61), 
    Color(0xffedc850), 
    Color(0xffedc53f), 
    Color(0xffedc22e)
  ];

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