abstract interface class BurnAnimationPlayer {
  Future<void> play({required bool reducedMotion});
}

class StaticBurnAnimationPlayer implements BurnAnimationPlayer {
  const StaticBurnAnimationPlayer();

  @override
  Future<void> play({required bool reducedMotion}) async {
    await Future<void>.delayed(
      Duration(milliseconds: reducedMotion ? 120 : 2200),
    );
  }
}
