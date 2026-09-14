import 'package:flutter/material.dart';
import 'core/theme/app_theme.dart';
import 'screens/splash_screen.dart';

/// إشعار عام بسيط لحالة الوضع الليلي، يمكن لأي شاشة في التطبيق
/// تبديله عبر: AppThemeController.mode.value = ThemeMode.dark;
class AppThemeController {
  static final ValueNotifier<ThemeMode> mode = ValueNotifier(ThemeMode.light);

  static void toggle() {
    mode.value = mode.value == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
  }
}

class RaedAlTarikhApp extends StatelessWidget {
  const RaedAlTarikhApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: AppThemeController.mode,
      builder: (context, mode, _) {
        return MaterialApp(
          title: 'رائد التاريخ',
          debugShowCheckedModeBanner: false,
          locale: const Locale('ar'),
          supportedLocales: const [Locale('ar')],
          theme: AppTheme.light,
          darkTheme: AppTheme.dark,
          themeMode: mode,
          // اتجاه الواجهة من اليمين لليسار (اللغة العربية)
          builder: (context, child) => Directionality(
            textDirection: TextDirection.rtl,
            child: child!,
          ),
          home: const SplashScreen(),
        );
      },
    );
  }
}
