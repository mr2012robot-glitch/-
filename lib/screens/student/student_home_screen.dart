import 'package:flutter/material.dart';
import '../../app.dart';
import '../shared/analysis_history_screen.dart';
import 'term_menu_screen.dart';
import 'book_viewer_screen.dart';

/// واجهة الطالب الرئيسية: الترم الأول / الترم الثاني / الكتاب المدرسي
/// + قائمة جانبية فيها "سجل التحليل" و"الوضع الليلي"
class StudentHomeScreen extends StatelessWidget {
  const StudentHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('رائد التاريخ - الطالب')),
      drawer: Drawer(
        child: ListView(
          children: [
            const DrawerHeader(child: Text('القائمة')),
            ListTile(
              leading: const Icon(Icons.history),
              title: const Text('سجل التحليل'),
              onTap: () => Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => const AnalysisHistoryScreen()),
              ),
            ),
            ValueListenableBuilder<ThemeMode>(
              valueListenable: AppThemeController.mode,
              builder: (context, mode, _) => SwitchListTile(
                secondary: const Icon(Icons.dark_mode),
                title: const Text('الوضع الليلي'),
                value: mode == ThemeMode.dark,
                onChanged: (_) => AppThemeController.toggle(),
              ),
            ),
          ],
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _StudentMenuCard(
            icon: Icons.looks_one,
            title: 'الترم الأول',
            onTap: () => Navigator.of(context).push(MaterialPageRoute(
              builder: (_) => const TermMenuScreen(termId: 'term1', termTitle: 'الترم الأول'),
            )),
          ),
          const SizedBox(height: 12),
          _StudentMenuCard(
            icon: Icons.looks_two,
            title: 'الترم الثاني',
            onTap: () => Navigator.of(context).push(MaterialPageRoute(
              builder: (_) => const TermMenuScreen(termId: 'term2', termTitle: 'الترم الثاني'),
            )),
          ),
          const SizedBox(height: 12),
          _StudentMenuCard(
            icon: Icons.picture_as_pdf,
            title: 'الكتاب المدرسي',
            onTap: () => Navigator.of(context).push(MaterialPageRoute(
              builder: (_) => const BookViewerScreen(),
            )),
          ),
        ],
      ),
    );
  }
}

class _StudentMenuCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;
  const _StudentMenuCard({required this.icon, required this.title, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: Icon(icon, size: 32),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        trailing: const Icon(Icons.arrow_back_ios, size: 16),
        onTap: onTap,
        contentPadding: const EdgeInsets.all(16),
      ),
    );
  }
}
