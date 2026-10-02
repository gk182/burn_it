import 'package:flutter_test/flutter_test.dart';
import 'package:burn_it/core/logging/app_logger.dart';
import 'package:burn_it/features/onboarding/controllers/onboarding_controller.dart';
import 'package:burn_it/features/onboarding/services/onboarding_analytics.dart';
import 'package:burn_it/domain/repositories/preferences_repository.dart';

class _FakePreferencesRepository implements PreferencesRepository {
  bool hasSeen = false;
  int writes = 0;
  Object? failure;

  @override
  Future<bool> hasSeenOnboarding() async => hasSeen;

  @override
  Future<void> setHasSeenOnboarding() async {
    if (failure != null) throw failure!;
    writes++;
    hasSeen = true;
  }

  @override
  Future<bool> getSoundEnabled() async => false;

  @override
  Future<void> setSoundEnabled(bool value) async {}

  @override
  Future<bool> getHapticEnabled() async => true;

  @override
  Future<void> setHapticEnabled(bool value) async {}

  @override
  Future<bool?> getReducedMotionOverride() async => null;

  @override
  Future<void> setReducedMotionOverride(bool? value) async {}
}

class _FakeAnalytics implements OnboardingAnalytics {
  final events = <String>[];

  @override
  Future<void> track(String event) async => events.add(event);
}

void main() {
  late _FakePreferencesRepository preferences;
  late _FakeAnalytics analytics;
  late List<String> navigations;

  OnboardingController createController() {
    return OnboardingController(
      preferences: preferences,
      analytics: analytics,
      navigateToWrite: () async => navigations.add('/write'),
      logger: const AppLogger(),
    );
  }

  setUp(() {
    preferences = _FakePreferencesRepository();
    analytics = _FakeAnalytics();
    navigations = <String>[];
  });

  test('T02-2: Begin persists the flag and navigates to write', () async {
    final controller = createController();

    await controller.complete();

    expect(preferences.writes, 1);
    expect(navigations, ['/write']);
    expect(analytics.events, ['onboarding_completed']);
    expect(controller.status.value, OnboardingStatus.completed);
  });

  test('T02-3: Skip uses the same privacy-safe completion path', () async {
    final controller = createController();

    await controller.skip();

    expect(preferences.writes, 1);
    expect(navigations, ['/write']);
    expect(analytics.events, ['onboarding_completed']);
  });

  test('T02-4: a second tap is ignored while completing', () async {
    final controller = createController();

    final first = controller.complete();
    final second = controller.complete();
    await Future.wait([first, second]);

    expect(preferences.writes, 1);
    expect(navigations, ['/write']);
  });

  test(
    'T02-5: preference failure exposes a safe error and does not navigate',
    () async {
      preferences.failure = StateError('private failure');
      final controller = createController();

      await controller.complete();

      expect(controller.status.value, OnboardingStatus.error);
      expect(controller.errorMessage.value, isNotEmpty);
      expect(navigations, isEmpty);
      expect(analytics.events, isEmpty);
    },
  );
}
