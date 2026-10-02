import 'package:get/get.dart';

import '../../../core/logging/app_logger.dart';
import '../../../domain/repositories/preferences_repository.dart';
import '../services/onboarding_analytics.dart';

enum OnboardingStatus { idle, completing, completed, error }

class OnboardingController extends GetxController {
  OnboardingController({
    required this.preferences,
    required this.analytics,
    required this.navigateToWrite,
    this.logger = const AppLogger(),
  });

  final PreferencesRepository preferences;
  final OnboardingAnalytics analytics;
  final Future<void> Function() navigateToWrite;
  final AppLogger logger;

  final status = OnboardingStatus.idle.obs;
  final errorMessage = RxnString();

  Future<void> complete() async {
    if (status.value == OnboardingStatus.completing ||
        status.value == OnboardingStatus.completed) {
      return;
    }

    status.value = OnboardingStatus.completing;
    errorMessage.value = null;

    try {
      await preferences.setHasSeenOnboarding();
      await analytics.track('onboarding_completed');
      status.value = OnboardingStatus.completed;
      await navigateToWrite();
    } catch (error, stackTrace) {
      logger.error(
        'onboarding_completion_failed',
        error: error,
        stackTrace: stackTrace,
      );
      status.value = OnboardingStatus.error;
      errorMessage.value = 'We could not begin yet. Please try again.';
    }
  }

  Future<void> skip() => complete();
}
