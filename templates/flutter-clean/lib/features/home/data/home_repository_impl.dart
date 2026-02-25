import 'dart:math';

import '../domain/home_repository.dart';

/// Data implementation: swap this with remote config later without touching UI.
class HomeRepositoryImpl implements HomeRepository {
  final _rnd = Random();

  static const _sarcastic = <String>[
    'Wow. Another click. Productivity is trembling.',
    'You pressed it again… bold strategy.',
    'Clean code? Sure. Clean vibes? Questionable.',
    'Riverpod says hi. Your bugs say bye.',
    'If this were spaghetti, it would be al dente.',
  ];

  static const _memes = <String>[
    'Fahhh achieved. Mission mostly accomplished.',
    'When it works on the first try: suspicious.',
    'SOLID detected. Spaghetti rejected.',
    'No nulls were harmed in this increment.',
    'Ship it. Then pretend it was easy.',
  ];

  @override
  String randomSarcasticMessage() => _sarcastic[_rnd.nextInt(_sarcastic.length)];

  @override
  String randomMemeSnack() => _memes[_rnd.nextInt(_memes.length)];
}

