import 'package:flutter/material.dart';

/// Renkler — React Native sürümündeki `src/theme.ts` ile aynı değerler.
class AppColors {
  AppColors._();

  static const surface = Color(0xFFFFFFFF);
  static const onSurface = Color(0xFF111827);
  static const surfaceSecondary = Color(0xFFF4F6F9);
  static const onSurfaceSecondary = Color(0xFF4B5563);
  static const brand = Color(0xFF2E5BFF);
  static const brandSecondary = Color(0xFF1A3BCC);
  static const brandTertiary = Color(0xFFE8EEFF);
  static const onBrand = Color(0xFFFFFFFF);
  static const error = Color(0xFFEF4444);
  static const errorBg = Color(0xFFFEE2E2);
  static const border = Color(0xFFE5E7EB);
  static const muted = Color(0xFF9CA3AF);
}

class AppSpacing {
  AppSpacing._();

  static const double xs = 4;
  static const double sm = 8;
  static const double md = 12;
  static const double lg = 16;
  static const double xl = 24;
  static const double xxl = 32;
}

class AppRadius {
  AppRadius._();

  static const double sm = 6;
  static const double md = 12;
  static const double lg = 20;
  static const double pill = 999;
}

class AppShadows {
  AppShadows._();

  static const card = [
    BoxShadow(
      color: Color(0x0F0F172A),
      offset: Offset(0, 2),
      blurRadius: 8,
    ),
  ];

  static const strong = [
    BoxShadow(
      color: Color(0x402E5BFF),
      offset: Offset(0, 8),
      blurRadius: 16,
    ),
  ];
}

ThemeData buildAppTheme() {
  return ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(
      seedColor: AppColors.brand,
      primary: AppColors.brand,
      error: AppColors.error,
      surface: AppColors.surface,
    ),
    scaffoldBackgroundColor: AppColors.surface,
  );
}
