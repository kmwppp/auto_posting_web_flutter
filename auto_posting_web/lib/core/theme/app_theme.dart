import 'package:flutter/material.dart';

import '../constants/app_colors.dart';
import 'app_text_styles.dart';

class AppTheme {
  static ThemeData primary() {
    final base = ThemeData(
      useMaterial3: true,
      scaffoldBackgroundColor: Colors.black,
      primaryColor: AppColors.primary,
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.textColor,
        elevation: 0,
      ),
    );

    return base.copyWith(
      textTheme: base.textTheme.copyWith(
        titleLarge: AppTextStyles.titleLarge,
        bodyMedium: AppTextStyles.bodyLarge,
        bodySmall: AppTextStyles.caption,
      ),
    );
  }
}
