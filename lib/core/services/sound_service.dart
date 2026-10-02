abstract interface class SoundService {
  Future<void> playBurn();
}

class NoopSoundService implements SoundService {
  const NoopSoundService();

  @override
  Future<void> playBurn() async {}
}
