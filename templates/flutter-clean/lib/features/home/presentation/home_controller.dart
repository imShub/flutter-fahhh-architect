import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/services/sound_service.dart';
import '../data/home_repository_impl.dart';
import '../domain/home_repository.dart';

class HomeState {
  const HomeState({
    required this.counter,
    required this.sarcasticMessage,
    required this.memeSnack,
    required this.lastSoundAsset,
  });

  final int counter;
  final String sarcasticMessage;
  final String memeSnack;
  final String lastSoundAsset;

  HomeState copyWith({
    int? counter,
    String? sarcasticMessage,
    String? memeSnack,
    String? lastSoundAsset,
  }) {
    return HomeState(
      counter: counter ?? this.counter,
      sarcasticMessage: sarcasticMessage ?? this.sarcasticMessage,
      memeSnack: memeSnack ?? this.memeSnack,
      lastSoundAsset: lastSoundAsset ?? this.lastSoundAsset,
    );
  }
}

final homeRepositoryProvider = Provider<HomeRepository>((ref) {
  // In a real app, inject remote config, caches, etc.
  return HomeRepositoryImpl();
});

final soundServiceProvider = Provider<SoundService>((ref) => SoundService());

class HomeController extends Notifier<HomeState> {
  @override
  HomeState build() {
    return const HomeState(
      counter: 0,
      sarcasticMessage: 'Press the button. I dare you.',
      memeSnack: 'Welcome to Fahhh-land.',
      lastSoundAsset: '',
    );
  }

  /// Increments counter, picks sarcasm + meme, and plays a random sound.
  Future<void> increment() async {
    final repo = ref.read(homeRepositoryProvider);
    final sound = ref.read(soundServiceProvider);

    final newCounter = state.counter + 1;
    final msg = repo.randomSarcasticMessage();
    final meme = repo.randomMemeSnack();

    // Keep UI snappy: update state first, then play.
    state = state.copyWith(counter: newCounter, sarcasticMessage: msg, memeSnack: meme);

    final played = await sound.playRandomFahhh();
    state = state.copyWith(lastSoundAsset: played);
  }
}

final homeControllerProvider = NotifierProvider<HomeController, HomeState>(HomeController.new);

