import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:burn_it/main.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('T04-10: completes onboarding, write, burn, and release', (
    tester,
  ) async {
    final preferences = await SharedPreferences.getInstance();
    await preferences.clear();

    await app.main();
    await tester.pumpAndSettle();

    expect(find.text('Write it. Burn it. Let it go.'), findsOneWidget);
    await tester.tap(find.text('Begin'));
    await tester.pumpAndSettle();

    final input = find.byType(TextField);
    expect(input, findsOneWidget);
    await tester.enterText(input, 'A thought I am ready to release.');
    await tester.drag(find.text('Swipe to burn'), const Offset(240, 0));
    await tester.pumpAndSettle();

    expect(find.text('Ready to let it go?'), findsOneWidget);
    await tester.drag(find.text('Swipe to burn'), const Offset(240, 0));
    await tester.pump(const Duration(milliseconds: 100));
    await tester.pumpAndSettle(const Duration(seconds: 3));

    expect(find.text('Released.'), findsOneWidget);
    expect(find.text('A thought I am ready to release.'), findsNothing);
  });
}
