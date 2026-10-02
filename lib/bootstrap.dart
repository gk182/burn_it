import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'app/app.dart';
import 'core/bindings/initial_binding.dart';
import 'core/logging/app_logger.dart';
import 'core/startup/startup_task.dart';
import 'data/repositories/preferences_repository_impl.dart';
import 'domain/repositories/preferences_repository.dart';

class BootstrapResult {
  const BootstrapResult({required this.routeName, this.error});

  final String routeName;
  final Object? error;
}

class BootstrapCoordinator {
  BootstrapCoordinator({
    required this.preferences,
    this.tasks = const <StartupTask>[],
    AppLogger? logger,
  }) : _logger = logger ?? const AppLogger();

  final PreferencesRepository preferences;
  final List<StartupTask> tasks;
  final AppLogger _logger;

  Future<BootstrapResult> resolveInitialRoute() async {
    try {
      final hasSeenOnboarding = await preferences.hasSeenOnboarding();
      return BootstrapResult(
        routeName: hasSeenOnboarding ? '/write' : '/onboarding',
      );
    } catch (error, stackTrace) {
      _logger.error(
        'bootstrap_preferences_failed',
        error: error,
        stackTrace: stackTrace,
      );
      return BootstrapResult(routeName: '/startup-error', error: error);
    }
  }

  Future<void> runDeferredTasks() async {
    for (final task in tasks) {
      try {
        await task.run();
      } catch (error, stackTrace) {
        _logger.error(
          'deferred_startup_task_failed',
          error: error,
          stackTrace: stackTrace,
        );
      }
    }
  }
}

Future<void> bootstrap() async {
  WidgetsFlutterBinding.ensureInitialized();

  final preferences = await SharedPreferences.getInstance();
  final preferencesRepository = PreferencesRepositoryImpl(preferences);
  final coordinator = BootstrapCoordinator(preferences: preferencesRepository);
  final result = await coordinator.resolveInitialRoute();

  Get.put<PreferencesRepository>(preferencesRepository, permanent: true);
  Get.put<SharedPreferences>(preferences, permanent: true);
  InitialBinding().dependencies();
  runApp(BurnItApp(initialRoute: result.routeName));

  WidgetsBinding.instance.addPostFrameCallback((_) {
    unawaited(coordinator.runDeferredTasks());
  });
}
