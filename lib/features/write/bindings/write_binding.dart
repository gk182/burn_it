import 'package:get/get.dart';

import '../../../app/routes/app_routes.dart';
import '../../burn/controllers/burn_controller.dart';
import '../controllers/write_controller.dart';
import '../data/prompt_catalog.dart';

class WriteBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<WriteController>(
      () => WriteController(
        prompts: PromptCatalog.items,
        onBurnRequested: (draft) async {
          await Get.toNamed<void>(
            AppRoutes.burn,
            arguments: BurnLaunch(
              draft: draft,
              clearDraft: Get.find<WriteController>().clearDraft,
            ),
          );
        },
      ),
    );
  }
}
