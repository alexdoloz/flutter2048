import 'package:p2048/logic/game_grid.dart';
import 'package:p2048/utils/utils.dart';
import 'package:p2048/logic/grid_point.dart';

/// Type of action for 2048 tiles
enum TileActionType {
  create, // new tile
  move, // just move from one point to another
  merge, // merges two tiles
}

/// Action for tile
class TileAction {
  final TileActionType type;
  final GridPoint sourcePoint;
  final GridPoint sourcePoint2;
  final GridPoint destinationPoint;
  final int destinationPower;

  const TileAction.create(
    { required GridPoint destinationPoint, required int destinationPower }
  ) :
    this.destinationPoint = destinationPoint,
    this.destinationPower = destinationPower,
    sourcePoint = const GridPoint.zero(),
    sourcePoint2 = const GridPoint.zero(),
    type = TileActionType.create;

  const TileAction.merge(
    { 
      required GridPoint sourcePoint,
      required GridPoint sourcePoint2,
      required GridPoint destinationPoint, 
      required int destinationPower,
    }
  ) :
    this.sourcePoint = sourcePoint,
    this.sourcePoint2 = sourcePoint2,
    this.destinationPoint = destinationPoint,
    this.destinationPower = destinationPower,
    type = TileActionType.merge;

  const TileAction.move(
    { 
      required GridPoint sourcePoint,
      required GridPoint destinationPoint, 
      required int destinationPower,
    }
  ) : 
    this.sourcePoint = sourcePoint,
    this.sourcePoint2 = const GridPoint.zero(),
    this.destinationPoint = destinationPoint,
    this.destinationPower = destinationPower,
    type = TileActionType.move;
}

