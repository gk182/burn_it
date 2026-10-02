import 'package:flutter_test/flutter_test.dart';
import 'package:burn_it/bootstrap.dart';
import 'package:burn_it/core/startup/startup_task.dart';
import 'package:burn_it/domain/repositories/preferences_repository.dart';

class _FakePreferencesRepository implements PreferencesRepository {
  _FakePreferencesRepository({this.seen = false, this.failure});

  bool seen;
  Object? failure;

  @override
  Future<bool> hasSeenOnboarding() async {
    if (failure != null) throw failure!;
    return seen;
  }

  @override
  Future<void> setHasSeenOnboarding() async {
    seen = true;
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

class _FakeStartupTask implements StartupTask {
  int runs = 0;

  @override
  Future<void> run() async {
    runs++;
  }
}

void main() {
  group('T01 bootstrap', () {
    test('T01-1: selects onboarding for a fresh install', () async {
      final coordinator = BootstrapCoordinator(
        preferences: _FakePreferencesRepository(),
      );

      final result = await coordinator.resolveInitialRoute();

      expect(result.routeName, '/onboarding');
      expect(result.error, isNull);
    });

    test('T01-2: selects write after onboarding is complete', () async {
      final coordinator = BootstrapCoordinator(
        preferences: _FakePreferencesRepository(seen: true),
      );

      final result = await coordinator.resolveInitialRoute();

      expect(result.routeName, '/write');
      expect(result.error, isNull);
    });

    test('T01-3: exposes a startup error when preferences fail', () async {
      final coordinator = BootstrapCoordinator(
        preferences: _FakePreferencesRepository(failure: StateError('failed')),
      );

      final result = await coordinator.resolveInitialRoute();

      expect(result.routeName, '/startup-error');
      expect(result.error, isNotNull);
    });

    test(
      'T01-4: defers non-critical startup tasks until explicitly run',
      () async {
        final task = _FakeStartupTask();
        final coordinator = BootstrapCoordinator(
          preferences: _FakePreferencesRepository(),
          tasks: [task],
        );

        expect(task.runs, 0);
        await coordinator.runDeferredTasks();

        expect(task.runs, 1);
      },
    );
  });
}
