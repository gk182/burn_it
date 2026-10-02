import 'package:get/get.dart';

import '../../../domain/repositories/preferences_repository.dart';
import '../controllers/settings_controller.dart';

class SettingsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SettingsController>(
      () => SettingsController(preferences: Get.find<PreferencesRepository>()),
    );
  }
}
