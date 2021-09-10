import 'package:flutter/material.dart';
import 'package:p2048/widgets/game_tile.dart';
import 'package:p2048/utils/utils.dart';

class GameFieldBackground extends StatelessWidget {
  static const sideEdge = 8.0;
  static const innerSpace = 8.0;
  static const tileSize = GameTile.tileSize;

  const GameFieldBackground({ Key? key }) : super(key: key);

  Widget _row(int index) => Row(
    children: 4.map((x) => GameTile.empty()),
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
  );

  List<Widget> _rows() => 4.map((y) => _row(y));

  @override
  Widget build(BuildContext context) {
    const side = 2*sideEdge + 3*innerSpace + 4*tileSize;
    const gameColor = const Color(0xffbbada0);
    final borderSide = BorderSide(
      color: gameColor, 
      style: BorderStyle.solid,
      width: sideEdge,
    );
    return Container(
      child: SizedBox(
        width: side,
        height: side,
        child: Container(
          decoration: BoxDecoration(
            border: Border.fromBorderSide(borderSide),
            borderRadius: BorderRadius.circular(5.0),
            color: gameColor,
          ),
          child: Column(
            children: _rows(),
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
          ),
        ),
      ),
    );
  }
}