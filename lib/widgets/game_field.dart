import 'package:flutter/material.dart';
import 'package:p2048/logic/game_grid.dart';
import 'package:p2048/logic/game_manager.dart';
import 'package:p2048/logic/tile.dart';
import 'package:p2048/widgets/game_field_background.dart';
import 'package:p2048/widgets/animated_tile.dart';
import 'package:p2048/utils/durations.dart';
import 'dart:math';

class GameFieldWidget extends StatefulWidget {
  const GameFieldWidget({ Key? key }) : super(key: key);

  @override
  _GameFieldWidgetState createState() => _GameFieldWidgetState();
}

class _GameFieldWidgetState extends State<GameFieldWidget> {
  late Animation<double> animation;
  late AnimationController controller;
  
  // var justCreatedTiles = <Tile>{};
    
  double _toGridPosition(int logicalPosition) =>
    logicalPosition * 
    (GameFieldBackground.tileSize + GameFieldBackground.innerSpace) 
    + GameFieldBackground.sideEdge;

  Duration _animationDurationForTile(Tile tile) =>
    GameManager.shared.tileContainer.justAddedTiles.contains(tile) ? 
      Duration.zero : Durations.tileMovementDuration;


  List<Widget> _tileWidgets() => 
    GameManager.shared.tileContainer.tiles
    .map((tile) => AnimatedPositioned(
      key: ValueKey(tile.index),
      duration: _animationDurationForTile(tile),
      left: _toGridPosition(tile.position.x),
      top: _toGridPosition(tile.position.y),
      child: AnimatedTile(
        key: ValueKey(tile.index), 
        power: tile.power,
        opacity: tile.isHidden ? 0.0 : 1.0
      ),
    ))
    .toList();

  @override
  void initState() {
    super.initState();
    // setState(() {
    //   justCreatedTiles = <Tile>{...logic.startNewGame()};  
    // });
  }

  // _newTile([int count = 1]) {
  //   setState(() {
  //     justCreatedTiles = {};
  //     var newTiles = logic.addRandom(count);
  //     justCreatedTiles.addAll(newTiles);
  //   });
  // }

  // waitAndMakeNew() {
  //   Future.delayed(Durations.newTileDelay).then((value) => _newTile());
  // }

  /// Perform move if possible
  // move(MoveDirection direction) {
  //   if (!logic.canMove(direction)) return;
  //   justCreatedTiles = {};
  //   setState(() {
  //     logic.move(direction);
  //   });
  //   waitAndMakeNew();
  // }

  static const _threshold = 0.8;

  Function(DragEndDetails) _handleDrag({ bool horizontally = true }) =>
    (details) {
      var velocityDirection = details.velocity.pixelsPerSecond.direction;
      var trigFunction = horizontally ? cos : sin;
      var result = trigFunction(velocityDirection);
      if (result.abs() < _threshold) return;
      var moveDirection = 
        horizontally ? 
          (result > 0 ? MoveDirection.right : MoveDirection.left) :
          (result > 0 ? MoveDirection.down : MoveDirection.up);
      // move(moveDirection);
      GameManager.shared.move(moveDirection);
  };

  @override
  Widget build(BuildContext context) =>
    GestureDetector(
      behavior: HitTestBehavior.opaque,
      onHorizontalDragEnd: _handleDrag(horizontally: true),
      onVerticalDragEnd: _handleDrag(horizontally: false),
      child: OverflowBox(
        alignment: Alignment.center,
        child: Padding(
          padding: EdgeInsets.all(20),
          child: AnimatedBuilder(
            animation: GameManager.shared.tileContainer, 
            builder: (_, background) => Stack(
              alignment: AlignmentDirectional.center,
              children: [
                background!,
                ..._tileWidgets()
              ],
            ),
            child: GameFieldBackground(),
          )
        ),
      )
    );
}
