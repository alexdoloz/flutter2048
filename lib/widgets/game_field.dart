import 'package:flutter/material.dart';
import 'package:p2048/logic/game_grid.dart';
import 'package:p2048/logic/game_manager.dart';
import 'package:p2048/logic/tile.dart';
import 'package:p2048/widgets/game_field_background.dart';
import 'package:p2048/widgets/animated_tile.dart';
import 'package:p2048/utils/durations.dart';
import 'dart:ui';

/// Widget for displaying game field and handle reactions
class GameFieldWidget extends StatefulWidget {
  const GameFieldWidget({ Key? key }) : super(key: key);

  static const _threshold = 0.75;
  static const _distanceThreshold = 50;

  @override
  _GameFieldWidgetState createState() => _GameFieldWidgetState();
}

class _GameFieldWidgetState extends State<GameFieldWidget> {
  Offset? startOffset;
  Offset? endOffset;

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

  MoveDirection? _directionFromDelta(Offset delta) {
    if (delta.distance < GameFieldWidget._distanceThreshold) return null;
    var scaledDelta = delta / delta.distance;
    if (scaledDelta.dx > GameFieldWidget._threshold) return MoveDirection.right;
    if (scaledDelta.dx < -GameFieldWidget._threshold) return MoveDirection.left;
    if (scaledDelta.dy > GameFieldWidget._threshold) return MoveDirection.down;
    if (scaledDelta.dy < -GameFieldWidget._threshold) return MoveDirection.up;
  }

  @override
  Widget build(BuildContext context) => GestureDetector(
    behavior: HitTestBehavior.opaque,
    onPanStart: (details) {
      startOffset = details.globalPosition;
    },
    onPanEnd: (details) {
      if (startOffset == null || endOffset == null) return;
      var delta = endOffset! - startOffset!;
      var direction = _directionFromDelta(delta);
      if (direction == null) return;
      GameManager.shared.move(direction);
    },
    onPanCancel: () {
      print("Cancelled");
    },
    onPanUpdate: (details) {
      endOffset = details.globalPosition;
    },
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