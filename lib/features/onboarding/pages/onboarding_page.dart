import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../app/theme/app_spacing.dart';
import '../controllers/onboarding_controller.dart';
import '../widgets/onboarding_action.dart';
import '../widgets/privacy_promise.dart';

class OnboardingPage extends GetView<OnboardingController> {
  const OnboardingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) => SingleChildScrollView(
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: constraints.maxHeight),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const SizedBox(height: AppSpacing.xl),
                  const _OnboardingIntro(),
                  const PrivacyPromise(),
                  Obx(() {
                    final isCompleting =
                        controller.status.value == OnboardingStatus.completing;
                    return _OnboardingActions(
                      controller: controller,
                      isCompleting: isCompleting,
                      error: controller.errorMessage.value,
                    );
                  }),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _OnboardingIntro extends StatelessWidget {
  const _OnboardingIntro();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Burn It', style: theme.textTheme.labelLarge),
        const SizedBox(height: AppSpacing.md),
        Text(
          'Write it. Burn it. Let it go.',
          style: theme.textTheme.displaySmall?.copyWith(
            fontWeight: FontWeight.w600,
            height: 1.1,
          ),
        ),
      ],
    );
  }
}

class _OnboardingActions extends StatelessWidget {
  const _OnboardingActions({
    required this.controller,
    required this.isCompleting,
    required this.error,
  });

  final OnboardingController controller;
  final bool isCompleting;
  final String? error;

  @override
  Widget build(BuildContext context) {
    final errorText = error;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (errorText != null) ...[
          Text(
            errorText,
            style: TextStyle(color: Theme.of(context).colorScheme.error),
          ),
          const SizedBox(height: AppSpacing.sm),
        ],
        OnboardingAction(
          label: isCompleting ? 'Starting...' : 'Begin',
          semanticLabel: 'Begin writing',
          onPressed: isCompleting ? null : controller.complete,
          isPrimary: true,
        ),
        OnboardingAction(
          label: 'Skip',
          semanticLabel: 'Skip onboarding',
          onPressed: isCompleting ? null : controller.skip,
        ),
      ],
    );
  }
}
