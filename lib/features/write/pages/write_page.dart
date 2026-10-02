import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../app/routes/app_routes.dart';
import '../../../app/theme/app_spacing.dart';
import '../controllers/write_controller.dart';
import '../widgets/burn_affordance.dart';
import '../widgets/paper_surface.dart';
import '../widgets/prompt_header.dart';

class WritePage extends GetView<WriteController> {
  const WritePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Burn It'),
        actions: [
          IconButton(
            onPressed: () => Get.toNamed<void>(AppRoutes.settings),
            tooltip: 'Settings',
            icon: const Icon(Icons.tune),
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Obx(
                () => PromptHeader(
                  prompt: controller.currentPrompt.value,
                  onRefresh: controller.refreshPrompt,
                ),
              ),
              const SizedBox(height: AppSpacing.md),
              PaperSurface(
                controller: controller.textController,
                onChanged: controller.updateText,
              ),
              const SizedBox(height: AppSpacing.md),
              Obx(
                () => BurnAffordance(
                  enabled: controller.canBurn,
                  onTriggered: controller.requestBurn,
                ),
              ),
              Obx(() {
                final error = controller.errorMessage.value;
                return error == null
                    ? const SizedBox(height: AppSpacing.sm)
                    : Padding(
                        padding: const EdgeInsets.only(top: AppSpacing.sm),
                        child: Text(
                          error,
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.error,
                          ),
                        ),
                      );
              }),
            ],
          ),
        ),
      ),
    );
  }
}
