import 'package:get/get.dart';

import '../../core/services/analytics_service.dart';
import '../../data/repositories/release_counter_repository_impl.dart';
import '../../domain/repositories/preferences_repository.dart';
import '../../domain/repositories/release_counter_repository.dart';

class InitialBinding extends Bindings {
  @override
  void dependencies() {
    if (!Get.isRegistered<PreferencesRepository>()) {
      throw StateError(
        'PreferencesRepository must be initialized by bootstrap',
      );
    }
    if (!Get.isRegistered<AnalyticsService>()) {
      Get.put<AnalyticsService>(const NoopAnalyticsService(), permanent: true);
    }
    Get.lazyPut<ReleaseCounterRepository>(
      () => ReleaseCounterRepositoryImpl(Get.find()),
      fenix: true,
    );
  }
}
