import 'package:flutter_test/flutter_test.dart';
import 'package:burn_it/features/burn/controllers/burn_controller.dart';
import 'package:burn_it/features/burn/services/burn_animation_player.dart';
import 'package:burn_it/features/write/controllers/write_controller.dart';
import 'package:burn_it/core/services/analytics_service.dart';
import 'package:burn_it/core/services/haptic_service.dart';
import 'package:burn_it/core/services/sound_service.dart';
import 'package:burn_it/domain/repositories/release_counter_repository.dart';

class _FakeAnimation implements BurnAnimationPlayer {
  _FakeAnimation({this.failure});

  final Object? failure;
  bool reducedMotion = false;
  bool clearHappened = false;

  @override
  Future<void> play({required bool reducedMotion}) async {
    this.reducedMotion = reducedMotion;
    if (!clearHappened) throw StateError('draft was not cleared first');
    if (failure != null) throw failure!;
  }
}

class _FakeHaptics implements HapticService {
  _FakeHaptics({this.failure});

  final Object? failure;

  @override
  Future<void> impact() async {
    if (failure != null) throw failure!;
  }
}

class _FakeSound implements SoundService {
  _FakeSound({this.failure});

  final Object? failure;

  @override
  Future<void> playBurn() async {
    if (failure != null) throw failure!;
  }
}

class _FakeCounter implements ReleaseCounterRepository {
  _FakeCounter({this.failure});

  final Object? failure;
  int increments = 0;

  @override
  Future<void> increment() async {
    if (failure != null) throw failure!;
    increments++;
  }
}

class _FakeAnalytics implements AnalyticsService {
  final events = <String>[];

  @override
  Future<void> track(String event) async => events.add(event);
}

class _FakeDraftSource {
  _FakeDraftSource() : draft = _draft;

  static final _draft = ReleaseDraft(
    text: 'private thought',
    promptId: 'test',
    createdAt: DateTime(2026, 10, 2),
  );

  final ReleaseDraft draft;
  bool cleared = false;
}

BurnController _createController({
  required _FakeDraftSource source,
  _FakeAnimation? animation,
  _FakeHaptics? haptics,
  _FakeSound? sound,
  _FakeCounter? counter,
  _FakeAnalytics? analytics,
}) {
  final player = animation ?? _FakeAnimation();
  return BurnController(
    draft: source.draft,
    clearDraft: () {
      source.cleared = true;
      player.clearHappened = true;
    },
    animation: player,
    haptics: haptics ?? _FakeHaptics(),
    sound: sound ?? _FakeSound(),
    counter: counter ?? _FakeCounter(),
    analytics: analytics ?? _FakeAnalytics(),
  );
}

void main() {
  test('T04-1: swipe below threshold does not begin a release', () {
    final source = _FakeDraftSource();
    final controller = _createController(source: source);

    controller.handleSwipeEnd(100);

    expect(controller.status.value, BurnStatus.idle);
    expect(source.cleared, isFalse);
  });

  test('T04-2: confirmed release clears draft before animation', () async {
    final source = _FakeDraftSource();
    final animation = _FakeAnimation();
    final controller = _createController(source: source, animation: animation);
    controller.handleSwipeEnd(BurnController.swipeThreshold + 1);

    await controller.confirm();

    expect(source.cleared, isTrue);
    expect(controller.status.value, BurnStatus.released);
  });

  test('T04-3: successful animation releases and increments once', () async {
    final source = _FakeDraftSource();
    final counter = _FakeCounter();
    final analytics = _FakeAnalytics();
    final controller = _createController(
      source: source,
      counter: counter,
      analytics: analytics,
    );
    controller.handleSwipeEnd(200);

    await controller.confirm();

    expect(controller.status.value, BurnStatus.released);
    expect(counter.increments, 1);
    expect(analytics.events, ['burn_started', 'burn_completed']);
  });

  test('T04-4: animation failure still reaches Released', () async {
    final source = _FakeDraftSource();
    final controller = _createController(
      source: source,
      animation: _FakeAnimation(failure: StateError('asset failed')),
    );
    controller.handleSwipeEnd(200);

    await controller.confirm();

    expect(controller.status.value, BurnStatus.released);
    expect(source.cleared, isTrue);
  });

  test('T04-6: repeated confirmation is idempotent', () async {
    final source = _FakeDraftSource();
    final counter = _FakeCounter();
    final controller = _createController(source: source, counter: counter);
    controller.handleSwipeEnd(200);

    await Future.wait([controller.confirm(), controller.confirm()]);

    expect(counter.increments, 1);
  });

  test('T04-7: haptic and sound failures do not fail release', () async {
    final source = _FakeDraftSource();
    final controller = _createController(
      source: source,
      haptics: _FakeHaptics(failure: StateError('haptic unavailable')),
      sound: _FakeSound(failure: StateError('sound unavailable')),
    );
    controller.handleSwipeEnd(200);

    await controller.confirm();

    expect(controller.status.value, BurnStatus.released);
  });

  test('T04-8: reduced motion uses the static animation fallback', () async {
    final source = _FakeDraftSource();
    final animation = _FakeAnimation();
    final controller = _createController(source: source, animation: animation);
    controller.handleSwipeEnd(200);

    await controller.confirm(reducedMotion: true);

    expect(animation.reducedMotion, isTrue);
    expect(controller.status.value, BurnStatus.released);
  });

  test(
    'T04-9: counter failure keeps release completed with a diagnostic',
    () async {
      final source = _FakeDraftSource();
      final controller = _createController(
        source: source,
        counter: _FakeCounter(failure: StateError('storage unavailable')),
      );
      controller.handleSwipeEnd(200);

      await controller.confirm();

      expect(controller.status.value, BurnStatus.released);
      expect(controller.diagnosticMessage.value, isNotNull);
      expect(source.cleared, isTrue);
    },
  );
}
