import 'dart:math';
import 'package:flutter/foundation.dart';
import 'game_grid.dart';
import 'tile_container.dart';
import 'package:p2048/utils/durations.dart';

/// Current state of the game
/// Even if player won, game can continue
enum GameState {
  notStarted,
  inProgress,
  won,
  lost
}

class GameManager {
  static final GameManager shared = GameManager();

  final score = ValueNotifier(0);
  final bestScore = ValueNotifier(0);
  final status = ValueNotifier(GameState.notStarted);
  final tileContainer = TileContainer();

  tap() {
    score.value += Random().nextInt(20);
  }

  move(MoveDirection direction) {
    if (!tileContainer.canMove(direction)) return;
    int scoreDelta = tileContainer.move(direction);
    _updateScores(scoreDelta);
    Future
      .delayed(Durations.newTileDelay)
      .then((_) => tileContainer.addRandom());
  }

  startGame() {
    tileContainer.addRandom(count: 2);
    status.value = GameState.inProgress;
  }

  resetGame() {
    tileContainer.reset();
    Future
      .delayed(Durations.newTileDelay)
      .then((_) => tileContainer.addRandom(count: 2));
    status.value = GameState.inProgress;
  }

  // PRIVATE
  _updateScores(int scoreDelta) {
    score.value += scoreDelta;
    if (bestScore.value < score.value) {
      bestScore.value = score.value;
    }
  }
}