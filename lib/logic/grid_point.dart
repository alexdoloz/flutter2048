import 'package:p2048/utils/utils.dart';

/// Point for 4x4 grid
class GridPoint {
  final int number;

  int get x => number % 4;
  int get y => number ~/ 4;

  bool get isValid => x >= 0 && x < 4 && y >= 0 && y < 4;

  @override
  int get hashCode => number;

  @override
  bool operator == (Object other) {
    if (other is GridPoint) {
      return other.number == this.number;
    } else {
      return false;
    }
  }

  const GridPoint.number(int n):
    number = n;

  const GridPoint.xy(int x, int y):
    number = 4*y + x;

  const GridPoint.zero():
    number = 0;

  GridPoint.random({ Set<int> excluding = const {} }):
    number = List<int>
      .generate(16, (i) => i)
      .where((i) => !excluding.contains(i))
      .toList()
      .randomItem();
}