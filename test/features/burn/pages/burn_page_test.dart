import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:burn_it/core/services/analytics_service.dart';
import 'package:burn_it/core/services/haptic_service.dart';
import 'package:burn_it/core/services/sound_service.dart';
import 'package:burn_it/domain/repositories/release_counter_repository.dart';
import 'package:burn_it/features/burn/controllers/burn_controller.dart';
import 'package:burn_it/features/burn/pages/burn_page.dart';
import 'package:burn_it/features/burn/services/burn_animation_player.dart';
import 'package:burn_it/features/write/controllers/write_controller.dart';

class _Counter implements ReleaseCounterRepository {
  @override
  Future<void> increment() async {}
}

class _Analytics implements AnalyticsService {
  @override
  Future<void> track(String event) async {}
}

class _Haptics implements HapticService {
  @override
  Future<void> impact() async {}
}

class _Sound implements SoundService {
  @override
  Future<void> playBurn() async {}
}

class _Animation implements BurnAnimationPlayer {
  @override
  Future<void> play({required bool reducedMotion}) async {}
}

void main() {
  tearDown(Get.reset);

  BurnController buildController() {
    return BurnController(
      draft: ReleaseDraft(
        text: 'private thought',
        promptId: 'test',
        createdAt: DateTime(2026, 10, 2),
      ),
      clearDraft: () {},
      animation: _Animation(),
      haptics: _Haptics(),
      sound: _Sound(),
      counter: _Counter(),
      analytics: _Analytics(),
    );
  }

  testWidgets('T04-10: burn page renders confirmation affordance', (
    tester,
  ) async {
    Get.put<BurnController>(buildController());

    await tester.pumpWidget(const GetMaterialApp(home: BurnPage()));

    expect(find.text('Ready to let it go?'), findsOneWidget);
    expect(find.bySemanticsLabel('Confirm burn'), findsOneWidget);
  });
}
