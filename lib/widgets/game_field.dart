import 'package:flutter/material.dart';
import 'package:p2048/logic/game_grid.dart';
import 'package:p2048/logic/game_logic.dart';
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
  final logic = GameLogic();
  
  var justCreatedTiles = <Tile>{};
    
  double _toGridPosition(int logicalPosition) =>
    logicalPosition * 
    (GameFieldBackground.tileSize + GameFieldBackground.innerSpace) 
    + GameFieldBackground.sideEdge;

  List<Widget> _tileWidgets() => 
    logic.tileContainer.tiles
    .map((tile) => AnimatedPositioned(
      key: ValueKey(tile.index),
      duration: justCreatedTiles.contains(tile) ? Duration.zero : Durations.tileMovementDuration,
      left: _toGridPosition(tile.position.x),
      top: _toGridPosition(tile.position.y),
      child: AnimatedTile(power: tile.power, opacity: tile.isHidden ? 0.0 : 1.0),
    ))
    .toList();

  @override
  void initState() {
    super.initState();
    setState(() {
      justCreatedTiles = <Tile>{...logic.startNewGame()};  
    });
  }

  _newTile([int count = 1]) {
    setState(() {
      justCreatedTiles = {};
      var newTiles = logic.addRandom(count);
      justCreatedTiles.addAll(newTiles);
    });
  }

  waitAndMakeNew() {
    Future.delayed(Durations.newTileDelay).then((value) => _newTile());
  }

  /// Perform move if possible
  move(MoveDirection direction) {
    if (!logic.canMove(direction)) return;
    justCreatedTiles = {};
    setState(() {
      logic.move(direction);
    });
    waitAndMakeNew();
  }

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
        move(moveDirection);
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
          child: Stack(
            alignment: AlignmentDirectional.center,
            children: [
              GameFieldBackground(),
              ..._tileWidgets(),
            ],
          ),
        ),
      )
    );
}
