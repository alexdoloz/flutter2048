import 'dart:math';
import 'package:flutter/foundation.dart';

extension RandomItem<T> on Iterable<T> {
  T? get randomItem => isEmpty ? null : elementAt(Random().nextInt(length));
}

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