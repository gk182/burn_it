import 'package:get/get.dart';

import '../../../core/logging/app_logger.dart';
import '../../../core/services/analytics_service.dart';
import '../../../core/services/haptic_service.dart';
import '../../../core/services/sound_service.dart';
import '../../../domain/repositories/release_counter_repository.dart';
import '../../write/controllers/write_controller.dart';
import '../services/burn_animation_player.dart';

class BurnLaunch {
  const BurnLaunch({required this.draft, required this.clearDraft});

  final ReleaseDraft draft;
  final void Function() clearDraft;
}

enum BurnStatus { idle, confirming, burning, released }

class BurnController extends GetxController {
  BurnController({
    required this.draft,
    required this.clearDraft,
    required this.animation,
    required this.haptics,
    required this.sound,
    required this.counter,
    required this.analytics,
    this.logger = const AppLogger(),
  });

  static const swipeThreshold = 160.0;

  final ReleaseDraft draft;
  final void Function() clearDraft;
  final BurnAnimationPlayer animation;
  final HapticService haptics;
  final SoundService sound;
  final ReleaseCounterRepository counter;
  final AnalyticsService analytics;
  final AppLogger logger;

  final status = BurnStatus.idle.obs;
  final diagnosticMessage = RxnString();

  void handleSwipeEnd(double distance) {
    if (status.value != BurnStatus.idle) return;
    if (distance >= swipeThreshold) status.value = BurnStatus.confirming;
  }

  Future<void> confirm({bool reducedMotion = false}) async {
    if (status.value != BurnStatus.confirming) return;

    clearDraft();
    status.value = BurnStatus.burning;
    await _bestEffortAnalytics('burn_started');
    await Future.wait<void>([
      _bestEffortEffect(haptics.impact, 'haptic_failed'),
      _bestEffortEffect(sound.playBurn, 'sound_failed'),
    ]);

    try {
      await animation.play(reducedMotion: reducedMotion);
    } catch (error, stackTrace) {
      logger.error(
        'burn_animation_failed',
        error: error,
        stackTrace: stackTrace,
      );
    }

    status.value = BurnStatus.released;
    try {
      await counter.increment();
    } catch (error, stackTrace) {
      logger.error(
        'release_counter_failed',
        error: error,
        stackTrace: stackTrace,
      );
      diagnosticMessage.value =
          'Release completed. Count could not be updated.';
    }
    await _bestEffortAnalytics('burn_completed');
  }

  Future<void> _bestEffortEffect(
    Future<void> Function() effect,
    String event,
  ) async {
    try {
      await effect();
    } catch (error, stackTrace) {
      logger.error(event, error: error, stackTrace: stackTrace);
    }
  }

  Future<void> _bestEffortAnalytics(String event) async {
    try {
      await analytics.track(event);
    } catch (error, stackTrace) {
      logger.error('analytics_failed', error: error, stackTrace: stackTrace);
    }
  }
}
