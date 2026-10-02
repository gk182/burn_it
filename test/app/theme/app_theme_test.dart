import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:burn_it/app/routes/app_pages.dart';
import 'package:burn_it/app/routes/app_routes.dart';
import 'package:burn_it/app/theme/app_theme.dart';

void main() {
  test(
    'T01-6: light and dark themes expose accessible primary text colors',
    () {
      final light = AppTheme.light;
      final dark = AppTheme.dark;

      expect(light.colorScheme.onSurface, isNot(light.colorScheme.surface));
      expect(dark.colorScheme.onSurface, isNot(dark.colorScheme.surface));
      expect(
        ThemeData.estimateBrightnessForColor(light.colorScheme.surface),
        Brightness.light,
      );

      final routes = AppPages.pages.map((page) => page.name).toSet();
      expect(
        routes,
        containsAll(<String>[
          AppRoutes.onboarding,
          AppRoutes.write,
          AppRoutes.startupError,
        ]),
      );
    },
  );
}
