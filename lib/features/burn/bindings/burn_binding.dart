import 'package:get/get.dart';

import '../../../core/services/analytics_service.dart';
import '../../../core/services/haptic_service.dart';
import '../../../core/services/sound_service.dart';
import '../../../domain/repositories/release_counter_repository.dart';
import '../controllers/burn_controller.dart';
import '../services/burn_animation_player.dart';

class BurnBinding extends Bindings {
  @override
  void dependencies() {
    final launch = Get.arguments as BurnLaunch;
    Get.lazyPut<BurnController>(
      () => BurnController(
        draft: launch.draft,
        clearDraft: launch.clearDraft,
        animation: const StaticBurnAnimationPlayer(),
        haptics: const NoopHapticService(),
        sound: const NoopSoundService(),
        counter: Get.find<ReleaseCounterRepository>(),
        analytics: Get.find<AnalyticsService>(),
      ),
    );
  }
}
