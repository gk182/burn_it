import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../app/routes/app_routes.dart';
import '../../../app/theme/app_spacing.dart';
import '../controllers/settings_controller.dart';

class SettingsPage extends GetView<SettingsController> {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }
        return ListView(
          padding: const EdgeInsets.all(AppSpacing.md),
          children: [
            SwitchListTile.adaptive(
              title: const Text('Sound'),
              subtitle: const Text('Play a quiet sound during release'),
              value: controller.soundEnabled.value,
              onChanged: controller.setSoundEnabled,
            ),
            SwitchListTile.adaptive(
              title: const Text('Haptic feedback'),
              value: controller.hapticEnabled.value,
              onChanged: controller.setHapticEnabled,
            ),
            SwitchListTile.adaptive(
              title: const Text('Reduce motion'),
              subtitle: const Text('Use a simpler release animation'),
              value:
                  controller.reducedMotionOverride.value ??
                  MediaQuery.of(context).disableAnimations,
              onChanged: controller.setReducedMotionOverride,
            ),
            if (controller.reducedMotionOverride.value != null)
              TextButton(
                onPressed: () => controller.setReducedMotionOverride(null),
                child: const Text('Use system motion setting'),
              ),
            const Divider(),
            ListTile(
              title: const Text('Need immediate support?'),
              subtitle: const Text('Open local and crisis support resources'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () => Get.toNamed<void>(AppRoutes.safety),
            ),
            ListTile(
              title: const Text('Privacy promise'),
              subtitle: const Text('No account. No history.'),
            ),
            if (controller.errorMessage.value != null)
              Text(
                controller.errorMessage.value!,
                style: TextStyle(color: Theme.of(context).colorScheme.error),
              ),
          ],
        );
      }),
    );
  }
}
