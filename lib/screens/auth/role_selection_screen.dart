import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';
import '../student/student_home_screen.dart';
import '../teacher/teacher_home_screen.dart';

/// تُعرض مرة واحدة فقط بعد إنشاء الحساب لأول مرة
class RoleSelectionScreen extends StatelessWidget {
  final String userName;
  const RoleSelectionScreen({super.key, required this.userName});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('أهلاً بك $userName 👋',
                  style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              const Text('هل أنت طالب أم معلم؟', style: TextStyle(color: Colors.grey)),
              const SizedBox(height: 32),
              _RoleCard(
                icon: Icons.menu_book,
                title: 'طالب',
                subtitle: 'ملخصات، شروحات، اختبارات، أوتوماتيك',
                onTap: () => Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (_) => const StudentHomeScreen()),
                ),
              ),
              const SizedBox(height: 16),
              _RoleCard(
                icon: Icons.co_present,
                title: 'معلم',
                subtitle: 'شروحات مفصّلة جاهزة لكل درس',
                onTap: () => Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (_) => const TeacherHomeScreen()),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _RoleCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _RoleCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      child: ListTile(
        onTap: onTap,
        leading: Icon(icon, size: 36, color: AppTheme.primaryBlue),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(subtitle),
        trailing: const Icon(Icons.arrow_back_ios, size: 16),
        contentPadding: const EdgeInsets.all(16),
      ),
    );
  }
}
