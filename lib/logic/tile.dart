import 'package:p2048/logic/grid_point.dart';
import 'dart:math';

/// Model of game tile
class Tile {
  /// Position of tile
  GridPoint position;

  /// Is it displayed on screen
  bool isHidden;

  /// Current power of 2 on the tile
  int power;

  /// Tile identifier
  int index;

  Tile({ 
    GridPoint position = const GridPoint.zero(),
    bool isHidden = true,
    int power = 1,
    int index = 0,
  }) : 
    this.position = position,
    this.isHidden = isHidden,
    this.power = power,
    this.index = index;

  /// Formatted string for displaying in UI
  String get displayString => '${pow(2, power)}';
}
