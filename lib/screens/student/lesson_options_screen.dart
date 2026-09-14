import 'package:flutter/material.dart';
import '../../models/lesson_model.dart';
import 'summary_screen.dart';
import 'explanation_screen.dart';
import 'quiz_screen.dart';

/// بعد اختيار الطالب لدرس معيّن، يظهر له: ملخص الدرس / الشرح / نموذج اختبار الدرس
class LessonOptionsScreen extends StatelessWidget {
  final LessonModel lesson;
  const LessonOptionsScreen({super.key, required this.lesson});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(lesson.title, maxLines: 1, overflow: TextOverflow.ellipsis)),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _OptionCard(
            icon: Icons.summarize,
            title: 'ملخص الدرس',
            subtitle: 'أهم نقاط الدرس بصياغة مبسّطة',
            onTap: () => Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => SummaryScreen(lesson: lesson)),
            ),
          ),
          const SizedBox(height: 12),
          _OptionCard(
            icon: Icons.menu_book,
            title: 'الشرح',
            subtitle: 'شرح كامل + استماع صوتي',
            onTap: () => Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => ExplanationScreen(lesson: lesson)),
            ),
          ),
          const SizedBox(height: 12),
          _OptionCard(
            icon: Icons.quiz,
            title: 'نموذج اختبار الدرس',
            subtitle: 'صح/خطأ ثم اختيار من متعدد + تقييم كامل',
            onTap: () => Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) => QuizScreen(scopeId: lesson.id, scopeType: 'lesson', title: lesson.title),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _OptionCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;
  const _OptionCard({required this.icon, required this.title, required this.subtitle, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      child: ListTile(
        onTap: onTap,
        leading: CircleAvatar(child: Icon(icon)),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(subtitle),
        trailing: const Icon(Icons.arrow_back_ios, size: 14),
        contentPadding: const EdgeInsets.all(16),
      ),
    );
  }
}
