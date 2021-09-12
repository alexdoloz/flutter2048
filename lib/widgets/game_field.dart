import 'package:flutter/material.dart';
import 'package:p2048/logic/game_grid.dart';
import 'package:p2048/logic/game_logic.dart';
import 'package:p2048/widgets/game_field_background.dart';
import 'package:p2048/widgets/animated_tile.dart';

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
      duration: justCreatedTiles.contains(tile) ? Duration(milliseconds: 0) : Duration(milliseconds: 500),
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
    Future.delayed(Duration(milliseconds: 500)).then((value) => _newTile());
  }

  move(MoveDirection direction) {
    if (!logic.canMove(direction)) return;
    justCreatedTiles = {};
    setState(() {
      logic.move(direction);
    });
    waitAndMakeNew();
  }

  static const dragThreshold = 30.0;

  Function(DragEndDetails) _handleDrag(MoveDirection negative, MoveDirection positive) =>
    (details) {
      if (details.primaryVelocity == null) return;
        var velocity = details.primaryVelocity ?? 0;
        MoveDirection direction;
        if (velocity > dragThreshold) {
          direction = positive;
        } else if (velocity < -dragThreshold) {
          direction = negative;
        } else {
          return;
        }
        if (!logic.canMove(direction)) return;
        justCreatedTiles = {};
        setState(() {
          logic.move(direction);
        });
        Future.delayed(Duration(milliseconds: 550)).then((_) => _newTile());
    };

  @override
  Widget build(BuildContext context) =>
    GestureDetector(
      behavior: HitTestBehavior.opaque,
      onHorizontalDragEnd: _handleDrag(MoveDirection.left, MoveDirection.right),
      onVerticalDragEnd: _handleDrag(MoveDirection.up, MoveDirection.down),
      child: Padding(
        padding: EdgeInsets.all(50),
        child: Stack(
            alignment: AlignmentDirectional.center,
            children: [
              GameFieldBackground(),
              ..._tileWidgets()
            ],
          ),
      ),
    );
}
