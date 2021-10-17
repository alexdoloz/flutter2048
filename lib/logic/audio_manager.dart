import 'package:assets_audio_player/assets_audio_player.dart';

enum Sound {
  move, smallMerge, bigMerge, lose, win
}

class AudioManager {
  final _player = AssetsAudioPlayer();

  String _pathForSound(Sound sound) {
    switch (sound) {
    case Sound.win: return "sounds/win.m4a";
    case Sound.lose: return "sounds/fail.mp3";
    default: return "";
    }
  }

  Future<void> prepareSounds() async {
    // Sound.values.forEach((sound) async { 
    //   await _player.open(
    //     Audio(_pathForSound(sound)), 
    //     autoStart: false,
    //   );
    // });
  }

  Future<void> play(Sound sound) async {
    // await stop();
    // await _player.open(
    //   Audio(_pathForSound(sound)), 
    //   autoStart: true, 
    //   showNotification: false
    // );
  }

  stop() async {
    // await _player.stop();
  }
}