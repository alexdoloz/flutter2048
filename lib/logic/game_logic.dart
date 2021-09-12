import 'dart:math';
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

class Tile {
  GridPoint position = GridPoint.zero();
  bool isHidden = true;
  int power = 1;
  int index = 0;
}

abstract class GameDelegate {
  void runGameActions(List<TileAction> actions);
}

// typedef TileCallback = void Function({required Tile tile});
// typedef TileDestinationCallback

enum OrientedLineType {
  row, col
}

class TileContainer {
  var _tiles = List<Tile>.generate(
    16, (index) => Tile()..index = index, growable: false
  );

  List<Tile> get tiles => _tiles;
  
  Iterable<Tile> get activeTiles => _tiles.where((tile) => !tile.isHidden);

  Set<GridPoint> get freePositions => 
    GridPoint.allPoints.difference(<GridPoint>{
      for (var tile in _tiles)
        if (!tile.isHidden) tile.position
    });

  Tile? get freeTile =>
    activeTiles.length == _tiles.length ?
      null : _tiles.firstWhere((tile) => tile.isHidden);

  bool get has2048 => activeTiles.any((tile) => tile.power == 11);

  List<Tile> addRandom({ int count = 1 }) {
    var createdTiles = <Tile>[];
    count.forEach((_) {
      var tile = freeTile;
      var position = freePositions.randomItem;
      if (tile == null || position == null) return;
      tile.isHidden = false;
      tile.power = Random().nextInt(10) == 0 ? 2 : 1;
      tile.position = position;
      createdTiles.add(tile);
    });
    return createdTiles;
  }

  void squash({ required OrientedLine along }) {

  }

  void reset() {
  }
}

class OrientedLine {
  final int index;
  final OrientedLineType type;
  final bool backwards;

  const OrientedLine({ 
    OrientedLineType type = OrientedLineType.row, 
    int index = 0, 
    bool backwards = false 
  }) :
    this.type = type,
    this.index = index,
    this.backwards = backwards;

  int tileLine(Tile tile) =>
    type == OrientedLineType.row ? tile.position.y : tile.position.x;

  int tileOrder(Tile tile) =>
    type == OrientedLineType.row ? tile.position.x : tile.position.y;

  GridPoint get firstPoint => 
    type == OrientedLineType.row ? 
      (backwards ? GridPoint.xy(3, index) : GridPoint.xy(0, index)) :
      (backwards ? GridPoint.xy(index, 3) : GridPoint.xy(index, 0));

  GridPoint nextPoint(GridPoint point) =>
    type == OrientedLineType.row ? 
      (backwards ? GridPoint.xy(point.x - 1, index) : GridPoint.xy(point.x + 1, index)) :
      (backwards ? GridPoint.xy(index, point.y - 1) : GridPoint.xy(index, point.y + 1));

  List<Tile> matchingTiles(List<Tile> tiles) {
    return tiles
      .where((tile) => !tile.isHidden && tileLine(tile) == index)
      .toList();
  }

  void sort(List<Tile> tiles) {
    tiles.sort(
      (tile1, tile2) => (backwards ? -1 : 1) * (tileOrder(tile1) - tileOrder(tile2))
    );
  }

  bool canSquash(List<Tile> tiles) {
    var sortedTiles = tiles.toList();
    sort(sortedTiles);
    var currentPower = -1;
    var currentPoint = firstPoint;
    for (var tile in sortedTiles) {
      if (tile.power == currentPower) return true;
      if (tile.position != currentPoint) return true;
      currentPower = tile.power;
      currentPoint = nextPoint(currentPoint);
    }
    return false;
  }

  List<Tile> squash(List<Tile> tiles) {
    if (tiles.isEmpty) return tiles;
    var sortedTiles = tiles.toList();
    sort(sortedTiles);
    Tile? lastTile;
    GridPoint nextAvailablePosition = firstPoint;
    for (var tile in sortedTiles) {
      if (lastTile == null || lastTile.power != tile.power) {
        lastTile = tile;
        tile.position = nextAvailablePosition;
        nextAvailablePosition = nextPoint(nextAvailablePosition);
        continue;
      }
      if (lastTile.power == tile.power) { // doubling last tile
        tile.position = lastTile.position;
        tile.isHidden = true;
        lastTile.power = lastTile.power + 1;
        lastTile = null;
        continue;
      }
    }
    return sortedTiles;
  }

  static void enumerateLines({ 
    OrientedLineType? type, 
    bool? backwards,
    required bool Function(OrientedLine) closure
  }) {
    var types = type == null ? OrientedLineType.values : <OrientedLineType>[type];
    var directions = backwards == null ? [true, false] : [backwards];
    for (var i = 0; i < 4; i++) {
      for (var t in types) {
        for (var b in directions) {
          var line = OrientedLine(type: t, index: i, backwards: b);
          if (closure(line)) return;
        }
      }
    }
  }

  static OrientedLine firstLineForDirection(MoveDirection direction) {
    switch (direction) {
      case MoveDirection.up:
      return OrientedLine(type: OrientedLineType.col);
      case MoveDirection.down:
      return OrientedLine(type: OrientedLineType.col, backwards: true);
      case MoveDirection.left:
      return OrientedLine(type: OrientedLineType.row);
      case MoveDirection.right:
      return OrientedLine(type: OrientedLineType.row, backwards: true);
    } 
  }

  static void enumerateAlongDirection({ 
    MoveDirection direction = MoveDirection.up,
    required bool Function(OrientedLine) closure
  }) {
    var firstLine = firstLineForDirection(direction);
    enumerateLines(type: firstLine.type, backwards: firstLine.backwards, closure: closure);
  }

  static void squashAlongDirection({
    MoveDirection direction = MoveDirection.up,
    required List<Tile> tiles
  }) {
    enumerateAlongDirection(direction: direction, closure: (line) {
      line.squash(line.matchingTiles(tiles));
      return false;
    });
  }

  static bool canSquashAlongDirection({
    MoveDirection direction = MoveDirection.up,
    required List<Tile> tiles
  }) {
    var result = false;
    enumerateAlongDirection(direction: direction, closure: (line) {
      if (line.canSquash(line.matchingTiles(tiles))) {
        result = true;
        return true;
      }
      return false;
    });
    return result;
  }

  static bool canSquashAtAll({
    required List<Tile> tiles
  }) =>
    canSquashAlongDirection(direction: MoveDirection.up, tiles: tiles) ||
    canSquashAlongDirection(direction: MoveDirection.down, tiles: tiles) ||
    canSquashAlongDirection(direction: MoveDirection.left, tiles: tiles) ||
    canSquashAlongDirection(direction: MoveDirection.right, tiles: tiles);
}

/// Game logic 
class GameLogic {
  final tileContainer = TileContainer();
  int count = 0;
  late GameGrid grid;
  var state = GameState.notStarted;

  List<Tile> startNewGame() {
    tileContainer.reset();
    state = GameState.inProgress;
    return addRandom(2);
  }

  List<Tile> addRandom(int count) {
    var newTiles = tileContainer.addRandom(count: count);
    _afterAdd();
    return newTiles;
  }

  bool canMove(MoveDirection direction) {
    return OrientedLine.canSquashAlongDirection(
      direction: direction, 
      tiles: tileContainer.tiles
    );
  }

  move(MoveDirection direction) {
    if (![GameState.inProgress, GameState.won].contains(state)) return;
    if (!canMove(direction)) return;
    OrientedLine.squashAlongDirection(direction: direction, tiles: tileContainer.tiles);
    _afterMove();
  }

  _announceLosing() {
    state = GameState.lost;
    print('You lose!');
  }

  _announceWinning() {
    state = GameState.won;
    print('You win!');
  }

  _afterMove() {
    if (tileContainer.has2048) {
      _announceWinning();
    }
  }

  _afterAdd() {
    if (!OrientedLine.canSquashAtAll(tiles: tileContainer.tiles)) {
      _announceLosing();
    }
  }
}




