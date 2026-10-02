import 'dart:async';

import 'package:get/get.dart';

import '../../../domain/repositories/preferences_repository.dart';

class SettingsController extends GetxController {
  SettingsController({required this.preferences});

  final PreferencesRepository preferences;
  final soundEnabled = false.obs;
  final hapticEnabled = true.obs;
  final reducedMotionOverride = RxnBool();
  final isLoading = false.obs;
  final errorMessage = RxnString();

  @override
  void onInit() {
    super.onInit();
    unawaited(load());
  }

  Future<void> load() async {
    isLoading.value = true;
    errorMessage.value = null;
    try {
      soundEnabled.value = await preferences.getSoundEnabled();
      hapticEnabled.value = await preferences.getHapticEnabled();
      reducedMotionOverride.value = await preferences
          .getReducedMotionOverride();
    } catch (_) {
      errorMessage.value = 'Settings could not be loaded.';
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> setSoundEnabled(bool value) async {
    await preferences.setSoundEnabled(value);
    soundEnabled.value = value;
  }

  Future<void> setHapticEnabled(bool value) async {
    await preferences.setHapticEnabled(value);
    hapticEnabled.value = value;
  }

  Future<void> setReducedMotionOverride(bool? value) async {
    await preferences.setReducedMotionOverride(value);
    reducedMotionOverride.value = value;
  }
}
