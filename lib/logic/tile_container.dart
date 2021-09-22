import 'package:flutter/foundation.dart';
import 'package:p2048/logic/tile.dart';
import 'package:p2048/logic/grid_point.dart';
import 'package:p2048/utils/utils.dart';
import 'package:p2048/logic/oriented_line.dart';
import 'dart:math';
import 'game_grid.dart';

class TileContainer extends ChangeNotifier {
  late var _tiles = _resettedTiles();

  var _justAddedTiles = Set<Tile>();

  Set<Tile> get justAddedTiles => _justAddedTiles;

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

  bool get canMakeAnyMove => 
    MoveDirection.values.any((direction) => canMove(direction));

  bool canMove(MoveDirection direction) {
    var result = false;
    _enumerateLines(direction: direction, closure: (line) {
      if (_canSquash(line)) {
        result = true;
        return true;
      }
      return false;
    });
    return result;
  }

  int move(MoveDirection direction) {
    justAddedTiles.clear();
    int score = 0;
    _enumerateLines(direction: direction, closure: (line) {
      score += _squash(line);
      return false;
    });
    notifyListeners();
    return score;
  }

  addRandom({ int count = 1 }) {
    if (count <= 0) return;
    justAddedTiles.clear();
    count.forEach((_) {
      var tile = freeTile;
      var position = freePositions.randomItem;
      if (tile == null || position == null) return;
      tile 
        ..isHidden = false
        ..power = Random().nextInt(10) == 0 ? 2 : 1
        ..position = position;
      justAddedTiles.add(tile);
    });
    notifyListeners();
  }

  void reset() {
    _justAddedTiles.clear();
    _tiles.forEach((tile) {
      tile.isHidden = true;
    });
    notifyListeners();
  }

// PRIVATE
  void _enumerateLines({
    MoveDirection? direction,
    required bool Function(OrientedLine) closure
  }) {
    var directions = direction == null ? MoveDirection.values : [direction];
    for (var i = 0; i < 4; i++) {
      for (var d in directions) {
        var line = OrientedLine(direction: d, index: i);
        if (closure(line)) return;
      }
    }
  }

  bool _canSquash(OrientedLine line) {
    final sorted = _matchingTiles(line);
    line.sort(sorted);
    var currentPower = -1;
    var currentPoint = line.firstPoint;
    for (var tile in sorted) {
      if (tile.power == currentPower) return true;
      if (tile.position != currentPoint) return true;
      currentPower = tile.power;
      currentPoint = line.nextPoint(currentPoint);
    }
    return false;
  }

  int _squash(OrientedLine line) {
    var sortedTiles = _matchingTiles(line);
    if (sortedTiles.isEmpty) return 0;
    int score = 0;
    line.sort(sortedTiles);
    Tile? lastTile;
    GridPoint nextAvailablePosition = line.firstPoint;
    for (var tile in sortedTiles) {
      if (lastTile == null || lastTile.power != tile.power) {
        lastTile = tile;
        tile.position = nextAvailablePosition;
        nextAvailablePosition = line.nextPoint(nextAvailablePosition);
        continue;
      }
      if (lastTile.power == tile.power) { // doubling last tile
        tile
          ..position = lastTile.position
          ..isHidden = true;
        lastTile.power = lastTile.power + 1;
        score += (2 << tile.power);
        lastTile = null;
        continue;
      }
    }
    return score;
  }

  List<Tile> _matchingTiles(OrientedLine line) {
    return tiles
      .where((tile) => !tile.isHidden && line.containsPoint(tile.position))
      .toList();
  }

  List<Tile> _resettedTiles() => List<Tile>.generate(
    16, (index) => Tile()..index = index, growable: false
  );
}
