import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../app/routes/app_routes.dart';
import '../../../app/theme/app_spacing.dart';
import '../controllers/burn_controller.dart';
import '../widgets/swipe_to_burn.dart';

class BurnPage extends GetView<BurnController> {
  const BurnPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Obx(() {
            switch (controller.status.value) {
              case BurnStatus.released:
                return _ReleasedView(
                  diagnosticMessage: controller.diagnosticMessage.value,
                );
              case BurnStatus.burning:
                return const _BurningView();
              case BurnStatus.idle:
              case BurnStatus.confirming:
                return _ConfirmView(controller: controller);
            }
          }),
        ),
      ),
    );
  }
}

class _ConfirmView extends StatelessWidget {
  const _ConfirmView({required this.controller});

  final BurnController controller;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'Ready to let it go?',
          style: Theme.of(context).textTheme.headlineMedium,
        ),
        const SizedBox(height: AppSpacing.sm),
        const Text('This cannot be undone.'),
        const SizedBox(height: AppSpacing.lg),
        SwipeToBurn(controller: controller),
      ],
    );
  }
}

class _BurningView extends StatelessWidget {
  const _BurningView();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CircularProgressIndicator(),
          SizedBox(height: AppSpacing.md),
          Text('Letting it go...'),
        ],
      ),
    );
  }
}

class _ReleasedView extends StatelessWidget {
  const _ReleasedView({required this.diagnosticMessage});

  final String? diagnosticMessage;

  @override
  Widget build(BuildContext context) {
    final message = diagnosticMessage;
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'Released.',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.displaySmall,
          ),
          if (message != null) ...[
            const SizedBox(height: AppSpacing.sm),
            Text(message, textAlign: TextAlign.center),
          ],
          const SizedBox(height: AppSpacing.lg),
          FilledButton(
            onPressed: () => Get.offNamed<void>(AppRoutes.write),
            child: const Text('Write another'),
          ),
          TextButton(onPressed: Get.back, child: const Text('Close')),
        ],
      ),
    );
  }
}
