import 'dart:math';
import 'package:p2048/utils/utils.dart';
import 'package:p2048/logic/grid_point.dart';

/// Possible movement directions
enum MoveDirection {
  left, right, up, down
}

class GameGrid {
  List<int> _cells = [
    0, 0, 0, 0,
    0, 0, 0, 0,
    0, 0, 0, 0,
    0, 0, 0, 0 
  ];

  Set<int> get empty => {
    for (var i = 0; i < _cells.length; i++) 
      if (_cells[i] == 0) i 
  };

  Set<int> get taken => {
    for (var i = 0; i < _cells.length; i++) 
      if (_cells[i] != 0) i 
  };

  int get filledCount => _cells.length - empty.length;
  bool get noRoom => empty.length == 0;
  bool get hasMoves => 
    canMove(MoveDirection.up) || canMove(MoveDirection.down) ||
    canMove(MoveDirection.left) || canMove(MoveDirection.right);

  int operator [](GridPoint p) => _cells[p.number];
  operator []=(GridPoint p, int power) => _cells[p.number] = power;

  List<int> row(int index) => 4.map((x) => _cells[4*index+x]);
  List<int> col(int index) => 4.map((y) => _cells[4*y+index]);

  setRow(int index, List<int> row) => 
    4.forEach((x) => _cells[4*index+x] = row[x]);

  setCol(int index, List<int> col) =>
    4.forEach((y) => _cells[4*y+index] = col[y]);

  bool canMove(MoveDirection direction) {
    switch (direction) {
      case MoveDirection.up:
      return 4.map((x) => col(x).isSquashable).contains(true);
      case MoveDirection.down:
      return 4.map((x) => col(x).isSquashableBackwards).contains(true);
      case MoveDirection.left:
      return 4.map((y) => row(y).isSquashable).contains(true);
      case MoveDirection.right:
      return 4.map((y) => row(y).isSquashableBackwards).contains(true);
    }
  }

  @override
  String toString() => 
    '\n' + 
    4.map(
      (y) => row(y)
        .map((p) => p == 0 ? '   .' : '${pow(2, p)}'.padLeft(4)).join(' ')
    ).join('\n');
}