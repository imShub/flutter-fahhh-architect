import 'dart:math';

import 'package:audioplayers/audioplayers.dart';

/// SoundService is an abstraction so UI/controllers don't talk to audioplayers directly.
class SoundService {
  SoundService({AudioPlayer? player}) : _player = player ?? AudioPlayer();

  final AudioPlayer _player;

  static const List<String> _assetSounds = <String>[
    'sounds/fahhh.mp3',
    'sounds/bruh.mp3',
  ];

  /// Plays a random “Fahhh” sound from `assets/sounds/`.
  ///
  /// Note: The template references these assets; you must add real files in your app.
  Future<String> playRandomFahhh() async {
    final sound = _assetSounds[Random().nextInt(_assetSounds.length)];
    await _player.stop();
    await _player.play(AssetSource(sound));
    return sound;
  }
}

