import 'package:get/get.dart';

import '../../../app/routes/app_routes.dart';
import '../../../domain/repositories/preferences_repository.dart';
import '../controllers/onboarding_controller.dart';
import '../services/onboarding_analytics.dart';

class OnboardingBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<OnboardingAnalytics>(() => const NoopOnboardingAnalytics());
    Get.lazyPut<OnboardingController>(
      () => OnboardingController(
        preferences: Get.find<PreferencesRepository>(),
        analytics: Get.find<OnboardingAnalytics>(),
        navigateToWrite: () async {
          await Get.offNamed<void>(AppRoutes.write);
        },
      ),
    );
  }
}
