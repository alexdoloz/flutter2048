import 'dart:math';
import 'package:p2048/game_grid.dart';

// class Tile {
//   int power = 1;
//   GridPoint position = GridPoint.zero();
//   String get text => '${pow(2, power)}';

//   Tile.generated({ Set<GridPoint> excludedPoints = const {} }) {
//     power = Random().nextInt(10) == 0 ? 2 : 1;

//   }
// }

// enum GameActionType {
//   create, merge, move
// }

// class GameAction {
//   var actionType = GameActionType.create;

// }

/// Current state of the game
/// Even if player won, game can continue
enum GameState {
  notStarted,
  inProgress,
  won,
  lost
}

/// Game logic 
class GameLogic {
  int count = 0;
  late GameGrid grid;
  var state = GameState.notStarted;

  startNewGame() {
    grid = GameGrid();
    addRandomTile();
    addRandomTile();
    state = GameState.inProgress;
  }

  addRandomTile() {
    final power = Random().nextInt(10) == 0 ? 2 : 1;
    final point = GridPoint.random(excluding: grid.taken);
    grid[point] = power;
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




