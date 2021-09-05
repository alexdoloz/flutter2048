import 'dart:math';
import 'package:flutter/foundation.dart';

/// Possible movement directions
enum MoveDirection {
  left, right, up, down
}

extension RandomListItem<T> on List<T> {
  T randomItem() {
    return this[Random().nextInt(length)];
  }
}

/// Point for 4x4 grid
class GridPoint {
  final int _number;

  int get x => _number % 4;
  int get y => _number ~/ 4;

  bool get isValid => x >= 0 && x < 4 && y >= 0 && y < 4;

  @override
  int get hashCode => _number;

  @override
  bool operator == (Object other) {
    if (other is GridPoint) {
      return other._number == this._number;
    } else {
      return false;
    }
  }

  const GridPoint.number(int n):
    _number = n;

  const GridPoint.xy(int x, int y):
    _number = 4*y + x;

  const GridPoint.zero():
    _number = 0;

  GridPoint.random({ Set<int> excluding = const {} }):
    _number = List<int>
      .generate(16, (i) => i)
      .where((i) => !excluding.contains(i))
      .toList()
      .randomItem();
}

class GameGrid {
  List<int> _cells = [
    0, 0, 0, 0,
    0, 0, 0, 0,
    0, 0, 0, 0,
    0, 0, 0, 0 
  ];

  Set<int> get empty => {
    for(var i = 0; i < _cells.length; i++) 
      if (_cells[i] == 0) i 
  };

  Set<int> get taken => {
    for(var i = 0; i < _cells.length; i++) 
      if (_cells[i] != 0) i 
  };

  int get filledCount => _cells.length - empty.length;
  bool get noRoom => empty.length == 0;
  bool get hasMoves => 
    canMove(MoveDirection.up) || canMove(MoveDirection.down) ||
    canMove(MoveDirection.left) || canMove(MoveDirection.right);

  operator [](GridPoint p) => _cells[p._number];
  operator []=(GridPoint p, int power) => _cells[p._number] = power;

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
  String toString() {
    return '\n' + 
      4.map(
        (y) => row(y)
          .map((p) => p == 0 ? '   .' : '${pow(2, p)}'.padLeft(4)).join(' ')
      ).join('\n');
  }
}

/// EXTENSIONS
extension Counting on int {
  forEach(Function(int) closure) {
    for (var i = 0; i < this; i++) {
      closure(i);
    }
  }

  List<T> map<T>(Function(int) closure) {
    var result = <T>[];
    for (var i = 0; i < this; i++) {
      result.add(closure(i));
    }
    return result;
  }
}

extension Squash on List<int> {
  bool get isSquashable => !listEquals(this, this.squash());
  bool get isSquashableBackwards => !listEquals(this, this.squashBackwards());

  void appendToLength({ int item = 0, int length = 0 }) {
    var numberOfItems = length - this.length;
    if (numberOfItems <= 0) {
      return;
    }
    this.addAll(List<int>.generate(numberOfItems, (index) => item));
  }

  List<int> squash() {
    var squashed = <int>[];
    var noZeroes = List<int>.from(this);
    noZeroes.removeWhere((e) => e == 0);
    for (int i = 0; i < noZeroes.length; i++) {
      final p1 = noZeroes[i];
      final p2 = i == noZeroes.length - 1 ? -1 : noZeroes[i + 1];
      if (p1 == p2) {
        squashed.add(p1 + 1);
        i += 1;
      } else {
        squashed.add(p1);
      }
    }
    squashed.appendToLength(item: 0, length: this.length);
    return squashed;
  }

  List<int> squashBackwards() {
    return List<int>.from(
      List<int>.from(this.reversed)
          .squash()
          .reversed
    );
  }
}