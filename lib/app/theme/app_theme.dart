import 'package:flutter/material.dart';

import 'app_colors.dart';
import 'app_text_styles.dart';

abstract final class AppTheme {
  static ThemeData get light => _buildTheme(
    brightness: Brightness.light,
    surface: AppColors.paper,
    onSurface: AppColors.ink,
  );

  static ThemeData get dark => _buildTheme(
    brightness: Brightness.dark,
    surface: AppColors.paperDark,
    onSurface: AppColors.inkDark,
  );

  static ThemeData _buildTheme({
    required Brightness brightness,
    required Color surface,
    required Color onSurface,
  }) {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: AppColors.ember,
      brightness: brightness,
      surface: surface,
      onSurface: onSurface,
    );

    return ThemeData(
      brightness: brightness,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: surface,
      useMaterial3: true,
      textTheme: ThemeData(
        brightness: brightness,
      ).textTheme.apply(bodyColor: onSurface, displayColor: onSurface),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          minimumSize: const Size(44, 48),
          textStyle: AppTextStyles.body.copyWith(fontWeight: FontWeight.w600),
        ),
      ),
    );
  }
}
