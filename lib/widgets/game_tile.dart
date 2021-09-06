import 'package:flutter/material.dart';
import 'dart:math';

class GameTile extends StatelessWidget {
  static const tileSize = 80.0;
  final int power;

  static List<Color> colors = [
    Color.fromARGB(89, 238, 228, 218), 
    Color(0xffeee4da), 
    Color(0xffede0c8),
    Colors.orange, // TODO: Заменить на настоящие цвета
    Colors.purple, Colors.red, Colors.deepOrange, Colors.blue,
    Colors.teal, Colors.cyan, Colors.black, Colors.lime
  ];

  GameTile(this.power);
  GameTile.empty() : power = 0;

  @override
  Widget build(BuildContext context) {
    final text = '${pow(2, power)}';
    var textWidget = Text(
      text,
      style: TextStyle(fontSize: 25.0 - text.length, color: Colors.white),
    );
    return Container(
      decoration: BoxDecoration(
        border: Border.fromBorderSide(
          BorderSide(
            color: Colors.transparent,
            style: BorderStyle.solid,
            width: 0.0,
          )
        ),
        borderRadius: BorderRadius.circular(5.0),
        color: GameTile.colors[power],
      ),
      width: tileSize,
      height: tileSize,
      alignment: Alignment.center, 
      child: power == 0 ? null : textWidget,
    );
  }
}