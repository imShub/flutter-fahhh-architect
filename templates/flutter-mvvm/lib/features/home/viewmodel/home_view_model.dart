import 'dart:math';

import 'package:flutter/foundation.dart';

import '../../../core/services/sound_service.dart';
import '../model/home_model.dart';

class HomeViewModel extends ChangeNotifier {
  HomeViewModel({required SoundService soundService}) : _soundService = soundService;

  final SoundService _soundService;
  final _rnd = Random();

  HomeModel _state = const HomeModel(
    counter: 0,
    sarcasticMessage: 'Press the button. I dare you.',
    memeSnack: 'Welcome to Fahhh-land.',
    lastSoundAsset: '',
  );

  HomeModel get state => _state;

  static const _sarcastic = <String>[
    'Another increment? Truly groundbreaking.',
    'Your finger is doing cardio today.',
    'If this is a demo, why am I judging you?',
    'MVVM: because chaos deserves structure.',
    'Spaghetti code detected… just kidding. For now.',
  ];

  static const _memes = <String>[
    'Fahhh achieved. Celebrate responsibly.',
    'It works. Don’t touch anything.',
    'No state was harmed in this update.',
    'Architectural purity +1. Ego +2.',
    'Ship it. Then nap.',
  ];

  Future<void> increment() async {
    final newCounter = _state.counter + 1;
    final msg = _sarcastic[_rnd.nextInt(_sarcastic.length)];
    final meme = _memes[_rnd.nextInt(_memes.length)];

    _state = _state.copyWith(counter: newCounter, sarcasticMessage: msg, memeSnack: meme);
    notifyListeners();

    final played = await _soundService.playRandomFahhh();
    _state = _state.copyWith(lastSoundAsset: played);
    notifyListeners();
  }
}

