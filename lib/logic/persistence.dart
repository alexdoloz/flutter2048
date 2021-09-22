import 'package:p2048/logic/game_grid.dart';
import 'package:p2048/logic/game_manager.dart';
import 'package:p2048/logic/grid_point.dart';
// import 'package:p2048/logic/tile.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class Persistence {
  save({ 
    required GameGrid grid, 
    required GameState state,
    required int score,
    required int bestScore,
  });

  load(Function(GameGrid grid, GameState state, int score, int bestScore) callback);
}

class PersistenceService implements Persistence {
  @override
  load(Function(GameGrid grid, GameState state, int score, int bestScore) callback) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var statusIndex = prefs.getInt('status') ?? 0;
    var status = GameState.values[statusIndex];
    var firstHalf = prefs.getInt('first_half');
    var secondHalf = prefs.getInt('second_half');
    var bestScore = prefs.getInt('best_score') ?? 0;
    var score = prefs.getInt('score') ?? 0;
    if (firstHalf == null || secondHalf == null) {
      firstHalf = 0;
      secondHalf = 0;
      score = 0;
    }
    var grid = GameGrid();
    _split(grid, 0, 7, firstHalf);
    _split(grid, 8, 15, secondHalf);
    callback(grid, status, score, bestScore);
  }

  @override
  save({
    required GameGrid grid, 
    required GameState state, 
    required int score, 
    required int bestScore
  }) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setInt('status', GameState.values.indexOf(state));
    await prefs.setInt('score', score);
    await prefs.setInt('best_score', bestScore);
    final firstHalf = _join(grid, 0, 7);
    final secondHalf = _join(grid, 8, 15);
    await prefs.setInt('first_half', firstHalf);
    await prefs.setInt('second_half', secondHalf);
  }
}

int _join(GameGrid grid, int start, int end) {
  var result = 0;
  for (var i = start; i <= end; i++) {
    result |= (grid[GridPoint.number(i)] << 5*(i - start));
  }
  return result;
}

_split(GameGrid grid, int start, int end, int number) {
  for (var i = start; i <= end; i++) {
    var value = 31 & (number >> 5*(i - start));
    grid[GridPoint.number(i)] = value;
  }
}