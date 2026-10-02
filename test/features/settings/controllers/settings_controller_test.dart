import 'package:flutter_test/flutter_test.dart';
import 'package:burn_it/features/settings/controllers/settings_controller.dart';
import 'package:burn_it/domain/repositories/preferences_repository.dart';

class _FakePreferences implements PreferencesRepository {
  bool sound = false;
  bool haptic = true;
  bool? reducedMotion;
  String? receivedText;

  @override
  Future<bool> hasSeenOnboarding() async => false;

  @override
  Future<void> setHasSeenOnboarding() async {}

  @override
  Future<bool> getSoundEnabled() async => sound;

  @override
  Future<void> setSoundEnabled(bool value) async => sound = value;

  @override
  Future<bool> getHapticEnabled() async => haptic;

  @override
  Future<void> setHapticEnabled(bool value) async => haptic = value;

  @override
  Future<bool?> getReducedMotionOverride() async => reducedMotion;

  @override
  Future<void> setReducedMotionOverride(bool? value) async =>
      reducedMotion = value;
}

void main() {
  test(
    'T05-1: loads sound off, haptic on, and OS motion override unset',
    () async {
      final preferences = _FakePreferences();
      final controller = SettingsController(preferences: preferences);

      await controller.load();

      expect(controller.soundEnabled.value, isFalse);
      expect(controller.hapticEnabled.value, isTrue);
      expect(controller.reducedMotionOverride.value, isNull);
    },
  );

  test('T05-2: preference changes persist without accepting text', () async {
    final preferences = _FakePreferences();
    final controller = SettingsController(preferences: preferences);

    await controller.setSoundEnabled(true);
    await controller.setHapticEnabled(false);
    await controller.setReducedMotionOverride(true);

    expect(preferences.sound, isTrue);
    expect(preferences.haptic, isFalse);
    expect(preferences.reducedMotion, isTrue);
    expect(preferences.receivedText, isNull);
  });
}
