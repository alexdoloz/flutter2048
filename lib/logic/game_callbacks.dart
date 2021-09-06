import 'package:p2048/logic/game_grid.dart';
import 'package:p2048/utils/utils.dart';
import 'package:p2048/logic/grid_point.dart';

/// Type of action for 2048 tiles
enum TileActionType {
  create, // new tile
  move, // just move from one point to another
  moveAndDelete, // when tile is moved and merged into another one
  moveAndDouble, // when tile is moved and merged to
  double
}

/// Action for tile
class TileAction {
  var type = TileActionType.create;
  var sourcePoint = GridPoint.zero();
  var destinationPoint = GridPoint.zero(); // ignored for create, double types
  var power = 0; // ignored for move, moveAndDelete types
}

