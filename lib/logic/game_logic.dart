import 'dart:math';
import 'package:flutter/material.dart';
import 'package:p2048/logic/game_grid.dart';
import 'package:p2048/logic/grid_point.dart';
import 'package:p2048/utils/utils.dart';
import 'package:p2048/logic/game_callbacks.dart';

/// Current state of the game
/// Even if player won, game can continue
enum GameState {
  notStarted,
  inProgress,
  won,
  lost
}

class Tile extends Object {
  GridPoint position;
  int power;

  String get stringDescription => '${pow(2, power)}';

  Tile(this.position, this.power);
}

abstract class GameDelegate {
  void runGameActions(List<TileAction> actions);
}

// typedef TileCallback = void Function({required Tile tile});
// typedef TileDestinationCallback

enum Line4Type {
  row, col
}

class Line4 {
  final int index;
  final Line4Type type;
  final bool backwards;

  const Line4({ 
    Line4Type type = Line4Type.row, 
    int index = 0, 
    bool backwards = false 
  }) :
    this.type = type,
    this.index = index,
    this.backwards = backwards;

  int tileLine(Tile tile) =>
    type == Line4Type.row ? tile.position.y : tile.position.x;

  int tileOrder(Tile tile) =>
    type == Line4Type.row ? tile.position.x : tile.position.y;

  List<Tile> matchingTiles(Set<Tile> tiles) {
    return tiles
      .where((tile) => tileLine(tile) == index)
      .toList()
      ..sort((t1, t2) => (backwards ? -1 : 1) * (tileOrder(t1) - tileOrder(t2)));
  }

  static void enumerateLines({ Line4Type? type, bool? backwards }) {
    
  }
}

/// Game logic 
class GameLogic {
  Set<Tile> _tiles = {};
  int count = 0;
  late GameGrid grid;
  var state = GameState.notStarted;
  GameDelegate? delegate;
  // Function(Tile tile) onTileCreated = (Tile t) {};
  // void Function({required Tile tile, GridPoint? destination}) onTileDestroyed = ({required Tile tile, GridPoint? destination}) {};
  // Function(Tile tile) onTileDoubled = (Tile t) {};
  // Function(Tile tile) onTile
  

  startNewGame() {
    grid = GameGrid();
    addRandomTile();
    addRandomTile();
    state = GameState.inProgress;
  }

  addRandomTile() {
    final power = Random().nextInt(10) == 0 ? 2 : 1;
    final point = GridPoint.random(excluding: grid.taken);
    final tile = Tile(point, power);
    _tiles.add(tile);
    
    grid[point] = power;
    delegate?.runGameActions([
      TileAction.create(destinationPoint: point, destinationPower: power)
    ]);
  }

  move(MoveDirection direction) {
    if (![GameState.inProgress, GameState.won].contains(state)) return;
    if (!grid.canMove(direction)) return;
    switch (direction) {
      case MoveDirection.up:
      4.forEach((x) => grid.setCol(x, grid.col(x).squash()));
      break;
      case MoveDirection.down:
      4.forEach((x) => grid.setCol(x, grid.col(x).squashBackwards()));
      break;
      case MoveDirection.left:
      4.forEach((y) => grid.setRow(y, grid.row(y).squash()));
      break;
      case MoveDirection.right:
      4.forEach((y) => grid.setRow(y, grid.row(y).squashBackwards()));
      break;
    }
    _afterMove();
  }

  _announceLosing() {
    state = GameState.lost;
    print('You lose!');
  }

  _afterMove() {
    if (grid.noRoom) { 
      _announceLosing();
      return;
    }
    addRandomTile();
    if (!grid.hasMoves) {
      _announceLosing();
      return;
    }
  }
}




