import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';
import 'login_screen.dart';

/// أول شاشة تظهر عند فتح التطبيق: شعار "رائد التاريخ" مع إعداد عبدالكريم الزوعري
/// وزخرفة بصرية بهوية يمنية، ثم انتقال تلقائي لشاشة تسجيل الدخول.
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _fade;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: const Duration(milliseconds: 900));
    _fade = CurvedAnimation(parent: _controller, curve: Curves.easeIn);
    _controller.forward();

    Future.delayed(const Duration(milliseconds: 2600), () {
      if (!mounted) return;
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const LoginScreen()),
      );
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [AppTheme.primaryBlue, Color(0xFF0D2B40)],
          ),
        ),
        child: FadeTransition(
          opacity: _fade,
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // شعار زخرفي دائري يرمز إلى الهوية اليمنية
                // TODO: استبدال هذا بأيقونة شعار الجمهورية اليمنية الرسمية
                // (ضع الملف في assets/images/yemen_emblem.png واستخدم Image.asset)
                Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white.withOpacity(0.08),
                    border: Border.all(color: AppTheme.gold, width: 2.5),
                  ),
                  child: const Icon(Icons.account_balance, size: 56, color: AppTheme.gold),
                ),
                const SizedBox(height: 24),
                const Text(
                  'رائد التاريخ',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.2,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  'تاريخ الصف التاسع الأساسي — الجمهورية اليمنية',
                  style: TextStyle(color: Colors.white.withOpacity(0.75), fontSize: 13),
                ),
                const SizedBox(height: 40),
                const SizedBox(
                  width: 28,
                  height: 28,
                  child: CircularProgressIndicator(strokeWidth: 2.5, color: AppTheme.gold),
                ),
                const SizedBox(height: 28),
                Text(
                  'إعداد: عبدالكريم الزوعري',
                  style: TextStyle(color: Colors.white.withOpacity(0.65), fontSize: 12),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
