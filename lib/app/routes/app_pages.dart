import 'package:get/get.dart';

import '../../features/onboarding/pages/onboarding_page.dart';
import '../../features/onboarding/bindings/onboarding_binding.dart';
import '../../features/burn/bindings/burn_binding.dart';
import '../../features/burn/pages/burn_page.dart';
import '../../features/settings/bindings/safety_binding.dart';
import '../../features/settings/bindings/settings_binding.dart';
import '../../features/settings/pages/safety_page.dart';
import '../../features/settings/pages/settings_page.dart';
import '../../core/services/support_service.dart';
import '../../features/startup/pages/startup_error_page.dart';
import '../../features/write/pages/write_page.dart';
import '../../features/write/bindings/write_binding.dart';
import 'app_routes.dart';

abstract final class AppPages {
  static final pages = <GetPage<void>>[
    GetPage<void>(
      name: AppRoutes.onboarding,
      page: OnboardingPage.new,
      binding: OnboardingBinding(),
    ),
    GetPage<void>(
      name: AppRoutes.write,
      page: WritePage.new,
      binding: WriteBinding(),
    ),
    GetPage<void>(
      name: AppRoutes.burn,
      page: BurnPage.new,
      binding: BurnBinding(),
    ),
    GetPage<void>(
      name: AppRoutes.settings,
      page: SettingsPage.new,
      binding: SettingsBinding(),
    ),
    GetPage<void>(
      name: AppRoutes.safety,
      page: () => SafetyPage(onSupport: Get.find<SupportService>().open),
      binding: SafetyBinding(),
    ),
    GetPage<void>(name: AppRoutes.startupError, page: StartupErrorPage.new),
  ];
}
