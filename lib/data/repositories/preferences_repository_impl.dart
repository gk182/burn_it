import 'package:shared_preferences/shared_preferences.dart';

import '../../domain/repositories/preferences_repository.dart';

class PreferencesRepositoryImpl implements PreferencesRepository {
  PreferencesRepositoryImpl(this._preferences);

  static const _hasSeenOnboardingKey = 'has_seen_onboarding_v1';
  static const _soundEnabledKey = 'sound_enabled_v1';
  static const _hapticEnabledKey = 'haptic_enabled_v1';
  static const _reducedMotionOverrideKey = 'reduced_motion_override_v1';
  final SharedPreferences _preferences;

  @override
  Future<bool> hasSeenOnboarding() async {
    return _preferences.getBool(_hasSeenOnboardingKey) ?? false;
  }

  @override
  Future<void> setHasSeenOnboarding() async {
    await _preferences.setBool(_hasSeenOnboardingKey, true);
  }

  @override
  Future<bool> getSoundEnabled() async {
    return _preferences.getBool(_soundEnabledKey) ?? false;
  }

  @override
  Future<void> setSoundEnabled(bool value) async {
    await _preferences.setBool(_soundEnabledKey, value);
  }

  @override
  Future<bool> getHapticEnabled() async {
    return _preferences.getBool(_hapticEnabledKey) ?? true;
  }

  @override
  Future<void> setHapticEnabled(bool value) async {
    await _preferences.setBool(_hapticEnabledKey, value);
  }

  @override
  Future<bool?> getReducedMotionOverride() async {
    return _preferences.getBool(_reducedMotionOverrideKey);
  }

  @override
  Future<void> setReducedMotionOverride(bool? value) async {
    if (value == null) {
      await _preferences.remove(_reducedMotionOverrideKey);
      return;
    }
    await _preferences.setBool(_reducedMotionOverrideKey, value);
  }
}
