import 'package:flutter/material.dart';

import 'app_colors.dart';

abstract final class AppTextStyles {
  static const display = TextStyle(
    color: AppColors.ink,
    fontSize: 36,
    fontWeight: FontWeight.w600,
    height: 1.1,
  );

  static const body = TextStyle(
    color: AppColors.ink,
    fontSize: 17,
    height: 1.5,
  );
}
