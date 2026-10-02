import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:burn_it/features/onboarding/controllers/onboarding_controller.dart';
import 'package:burn_it/features/onboarding/pages/onboarding_page.dart';
import 'package:burn_it/features/onboarding/services/onboarding_analytics.dart';
import 'package:burn_it/domain/repositories/preferences_repository.dart';

class _FakePreferencesRepository implements PreferencesRepository {
  @override
  Future<bool> hasSeenOnboarding() async => false;

  @override
  Future<void> setHasSeenOnboarding() async {}

  @override
  Future<bool> getSoundEnabled() async => false;

  @override
  Future<void> setSoundEnabled(bool value) async {}

  @override
  Future<bool> getHapticEnabled() async => true;

  @override
  Future<void> setHapticEnabled(bool value) async {}

  @override
  Future<bool?> getReducedMotionOverride() async => null;

  @override
  Future<void> setReducedMotionOverride(bool? value) async {}
}

class _FakeAnalytics implements OnboardingAnalytics {
  @override
  Future<void> track(String event) async {}
}

void main() {
  tearDown(Get.reset);

  OnboardingController buildController() {
    return OnboardingController(
      preferences: _FakePreferencesRepository(),
      analytics: _FakeAnalytics(),
      navigateToWrite: () async {},
    );
  }

  testWidgets('T02-1: renders the privacy promise and Begin action', (
    tester,
  ) async {
    Get.put<OnboardingController>(buildController());

    await tester.pumpWidget(const GetMaterialApp(home: OnboardingPage()));

    expect(find.text('Write it. Burn it. Let it go.'), findsOneWidget);
    expect(find.text('No account. No history.'), findsOneWidget);
    expect(find.bySemanticsLabel('Begin writing'), findsOneWidget);
  });

  testWidgets('T02-6: actions remain discoverable with large text', (
    tester,
  ) async {
    Get.put<OnboardingController>(buildController());

    await tester.pumpWidget(
      GetMaterialApp(
        builder: (context, child) => MediaQuery(
          data: const MediaQueryData(textScaler: TextScaler.linear(2)),
          child: child!,
        ),
        home: const OnboardingPage(),
      ),
    );

    expect(find.bySemanticsLabel('Begin writing'), findsOneWidget);
    expect(find.bySemanticsLabel('Skip onboarding'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
