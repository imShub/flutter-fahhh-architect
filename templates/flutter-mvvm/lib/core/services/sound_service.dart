import 'dart:math';

import 'package:audioplayers/audioplayers.dart';

class SoundService {
  SoundService({AudioPlayer? player}) : _player = player ?? AudioPlayer();

  final AudioPlayer _player;

  static const List<String> _assetSounds = <String>[
    'sounds/fahhh.mp3',
    'sounds/bruh.mp3',
  ];

  Future<String> playRandomFahhh() async {
    final sound = _assetSounds[Random().nextInt(_assetSounds.length)];
    await _player.stop();
    await _player.play(AssetSource(sound));
    return sound;
  }
}

