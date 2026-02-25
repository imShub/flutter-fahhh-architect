class HomeModel {
  const HomeModel({
    required this.counter,
    required this.sarcasticMessage,
    required this.memeSnack,
    required this.lastSoundAsset,
  });

  final int counter;
  final String sarcasticMessage;
  final String memeSnack;
  final String lastSoundAsset;

  HomeModel copyWith({
    int? counter,
    String? sarcasticMessage,
    String? memeSnack,
    String? lastSoundAsset,
  }) {
    return HomeModel(
      counter: counter ?? this.counter,
      sarcasticMessage: sarcasticMessage ?? this.sarcasticMessage,
      memeSnack: memeSnack ?? this.memeSnack,
      lastSoundAsset: lastSoundAsset ?? this.lastSoundAsset,
    );
  }
}

