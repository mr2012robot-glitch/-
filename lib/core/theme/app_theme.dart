import 'package:flutter/material.dart';

/// هوية بصرية عصرية بلمسة يمنية:
/// - أحمر/أبيض/أسود (ألوان علم الجمهورية اليمنية) بدرجات هادئة عصرية
/// - أزرق تاريخي (من غلاف كتاب التاريخ) كلون أساسي للواجهات التعليمية
class AppTheme {
  static const Color primaryBlue = Color(0xFF1B4B72); // أزرق تاريخي
  static const Color yemenRed = Color(0xFFCE1126);
  static const Color yemenWhite = Color(0xFFFFFFFF);
  static const Color yemenBlack = Color(0xFF1A1A1A);
  static const Color gold = Color(0xFFC9A227); // لمسة زخرفية

  static ThemeData get light => ThemeData(
        brightness: Brightness.light,
        primaryColor: primaryBlue,
        scaffoldBackgroundColor: const Color(0xFFF6F7FB),
        colorScheme: ColorScheme.fromSeed(
          seedColor: primaryBlue,
          brightness: Brightness.light,
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: primaryBlue,
          foregroundColor: Colors.white,
          centerTitle: true,
          elevation: 0,
        ),
        fontFamily: 'Cairo', // TODO: إضافة ملفات الخط في assets/fonts
        useMaterial3: true,
      );

  static ThemeData get dark => ThemeData(
        brightness: Brightness.dark,
        primaryColor: primaryBlue,
        scaffoldBackgroundColor: const Color(0xFF121212),
        colorScheme: ColorScheme.fromSeed(
          seedColor: primaryBlue,
          brightness: Brightness.dark,
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF1E1E1E),
          foregroundColor: Colors.white,
          centerTitle: true,
          elevation: 0,
        ),
        fontFamily: 'Cairo',
        useMaterial3: true,
      );
}
