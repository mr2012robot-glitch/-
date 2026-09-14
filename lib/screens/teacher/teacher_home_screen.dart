import 'package:flutter/material.dart';
import 'teacher_lesson_list_screen.dart';

/// واجهة المعلم: الترم الأول / الترم الثاني ← قائمة الدروس ← شرح مفصّل بصور توضيحية
class TeacherHomeScreen extends StatelessWidget {
  const TeacherHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('رائد التاريخ - المعلم')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Card(
            child: ListTile(
              leading: const Icon(Icons.looks_one, size: 32),
              title: const Text('الترم الأول', style: TextStyle(fontWeight: FontWeight.bold)),
              trailing: const Icon(Icons.arrow_back_ios, size: 16),
              onTap: () => Navigator.of(context).push(MaterialPageRoute(
                builder: (_) => const TeacherLessonListScreen(termId: 'term1', termTitle: 'الترم الأول'),
              )),
            ),
          ),
          const SizedBox(height: 12),
          Card(
            child: ListTile(
              leading: const Icon(Icons.looks_two, size: 32),
              title: const Text('الترم الثاني', style: TextStyle(fontWeight: FontWeight.bold)),
              trailing: const Icon(Icons.arrow_back_ios, size: 16),
              onTap: () => Navigator.of(context).push(MaterialPageRoute(
                builder: (_) => const TeacherLessonListScreen(termId: 'term2', termTitle: 'الترم الثاني'),
              )),
            ),
          ),
        ],
      ),
    );
  }
}
