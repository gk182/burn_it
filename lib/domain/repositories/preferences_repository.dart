abstract interface class PreferencesRepository {
  Future<bool> hasSeenOnboarding();

  Future<void> setHasSeenOnboarding();

  Future<bool> getSoundEnabled();

  Future<void> setSoundEnabled(bool value);

  Future<bool> getHapticEnabled();

  Future<void> setHapticEnabled(bool value);

  Future<bool?> getReducedMotionOverride();

  Future<void> setReducedMotionOverride(bool? value);
}
