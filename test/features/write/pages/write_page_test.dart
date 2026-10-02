import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:burn_it/features/write/controllers/write_controller.dart';
import 'package:burn_it/features/write/data/prompt_catalog.dart';
import 'package:burn_it/features/write/pages/write_page.dart';

void main() {
  tearDown(() {
    Get.reset();
  });

  WriteController buildController() {
    return WriteController(
      prompts: PromptCatalog.items,
      onBurnRequested: (_) async {},
    );
  }

  testWidgets('T03-1: renders prompt, paper input, and burn affordance', (
    tester,
  ) async {
    Get.put<WriteController>(buildController());

    await tester.pumpWidget(const GetMaterialApp(home: WritePage()));

    expect(find.text('What are you done carrying today?'), findsOneWidget);
    expect(find.byType(TextField), findsOneWidget);
    expect(find.text('Swipe to burn'), findsOneWidget);
  });

  testWidgets('T03-7: small screen and large text do not overflow', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(320, 568);
    tester.view.devicePixelRatio = 1;
    Get.put<WriteController>(buildController());

    await tester.pumpWidget(
      GetMaterialApp(
        builder: (context, child) => MediaQuery(
          data: const MediaQueryData(textScaler: TextScaler.linear(1.8)),
          child: child!,
        ),
        home: const WritePage(),
      ),
    );
    await tester.pump();

    expect(tester.takeException(), isNull);
    tester.view.resetPhysicalSize();
    tester.view.resetDevicePixelRatio();
  });
}
