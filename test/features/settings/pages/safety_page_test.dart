import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:burn_it/features/settings/pages/safety_page.dart';

void main() {
  tearDown(Get.reset);

  testWidgets(
    'T05-4/T05-5: shows non-diagnostic safety copy and support action',
    (tester) async {
      var supportOpened = false;
      await tester.pumpWidget(
        GetMaterialApp(
          home: SafetyPage(onSupport: () async => supportOpened = true),
        ),
      );

      expect(
        find.textContaining('Burn It is not professional care.'),
        findsOneWidget,
      );
      expect(find.text('Need immediate support?'), findsOneWidget);
      await tester.tap(find.text('Find support'));
      expect(supportOpened, isTrue);
    },
  );
}
