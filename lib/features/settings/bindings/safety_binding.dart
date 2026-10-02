import 'package:get/get.dart';

import '../../../core/services/analytics_service.dart';
import '../../../core/services/support_service.dart';

class SafetyBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SupportService>(
      () => UrlLauncherSupportService(Get.find<AnalyticsService>()),
    );
  }
}
