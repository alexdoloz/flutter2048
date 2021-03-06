import 'package:flutter/foundation.dart';
import 'package:p2048/logic/audio_manager.dart';
import 'game_grid.dart';
import 'tile_container.dart';
import 'package:p2048/utils/durations.dart';
import 'package:p2048/logic/persistence.dart';

/// Current state of the game
/// Even if player won, game can continue
enum GameState {
  notLoaded,
  notStarted,
  inProgress,
  won,
  wonInProgress,
  lost
}

class GameManager {
  static final GameManager shared = GameManager();

  final score = ValueNotifier(0);
  final bestScore = ValueNotifier(0);
  final status = ValueNotifier(GameState.notLoaded);
  final tileContainer = TileContainer();
  
  final _persistence = PersistenceService();
  final _audioManager = AudioManager();

  GameManager() {
    _loadData();
    status.addListener(() {
      if (status.value == GameState.won) {
        _audioManager.play(Sound.win);
      }
      if (status.value == GameState.lost) {
        _audioManager.play(Sound.lose);
      }
    });
  }

  move(MoveDirection direction) {
    if (!tileContainer.canMove(direction)) return;
    int scoreDelta = tileContainer.move(direction);
    _updateScores(scoreDelta);
    Future
      .delayed(Durations.newTileDelay)
      .then((_) => _addTile());
  }

  startGame() {
    resetGame();
  }

  resetGame() {
    _audioManager.stop();
    tileContainer.reset();
    score.value = 0;
    Future
      .delayed(Durations.newTileDelay)
      .then((_) {
        tileContainer.addRandom(count: 2);
        _saveState();
      });
    status.value = GameState.inProgress;
  }

  continuePlaying() {
    if (status.value != GameState.won) return;
    status.value = GameState.wonInProgress;
  }

  // PRIVATE
  _updateScores(int scoreDelta) {
    score.value += scoreDelta;
    if (bestScore.value < score.value) {
      bestScore.value = score.value;
    }
  }

  _saveState() {
    _persistence.save(
      grid: tileContainer.gridFromTiles(), 
      state: status.value, 
      score: score.value,
      bestScore: bestScore.value
    );
  }

  _addTile() {
    tileContainer.addRandom();
    if (!tileContainer.canMakeAnyMove) {
      Future.delayed(
        Durations.tileMovementDuration, 
        () => status.value = GameState.lost
      );
      return;
    }
    if (tileContainer.has2048 && status.value == GameState.inProgress) {
      Future.delayed(
        Durations.tileMovementDuration, 
        () => status.value = GameState.won
      );
      return;
    }
    _saveState();
  }

  _loadData() async {
    await _audioManager.prepareSounds();
    await _persistence.load((grid, state, score, bestScore) {
      tileContainer.updateTilesFromGrid(grid);
      status.value = state;
      this.score.value = score;
      this.bestScore.value = bestScore;
    });
  }
}