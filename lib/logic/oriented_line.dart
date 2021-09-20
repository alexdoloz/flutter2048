import 'game_grid.dart';
import 'grid_point.dart';
import 'tile.dart';

class OrientedLine {
  final int index;
  final MoveDirection direction;

  const OrientedLine({ 
    int index = 0, 
    MoveDirection direction = MoveDirection.up,
  }) :
    this.index = index,
    this.direction = direction;

  bool get isRow => 
    direction == MoveDirection.left || direction == MoveDirection.right;
  
  bool get isCol => 
    direction == MoveDirection.up || direction == MoveDirection.down;

  int pointLine(GridPoint point) =>
    isRow ? point.y : point.x;

  int pointOrder(GridPoint point) =>
    isRow ? point.x : point.y;

  bool containsPoint(GridPoint point) => 
    pointLine(point) == index;

  bool get backwards =>
    direction == MoveDirection.down || direction == MoveDirection.right;

  GridPoint get firstPoint => 
    {
      MoveDirection.left: GridPoint.xy(0, index),
      MoveDirection.right: GridPoint.xy(3, index),
      MoveDirection.up: GridPoint.xy(index, 0),
      MoveDirection.down: GridPoint.xy(index, 3),
    }[direction]!;
    
  GridPoint nextPoint(GridPoint point) =>
    {
      MoveDirection.left: GridPoint.xy(point.x + 1, index),
      MoveDirection.right: GridPoint.xy(point.x - 1, index),
      MoveDirection.up: GridPoint.xy(index, point.y + 1),
      MoveDirection.down: GridPoint.xy(index, point.y - 1),
    }[direction]!;

  void sort(List<Tile> tiles) {
    tiles.sort(
      (tile1, tile2) =>
        (backwards ? -1 : 1) * (pointOrder(tile1.position) - pointOrder(tile2.position))
    );
  }
}