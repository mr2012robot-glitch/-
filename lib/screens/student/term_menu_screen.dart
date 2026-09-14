import 'package:flutter/material.dart';
import '../../models/lesson_model.dart';
import '../../services/content_service.dart';
import 'lesson_list_screen.dart';
import 'unit_test_screen.dart';
import 'automatic_mode_screen.dart';

/// بعد اختيار الطالب للترم، تظهر الخيارات الخمسة المطلوبة:
/// نماذج اختبارات لكل درس، ملخصات الدروس، الشرح، اختبارات الوحدات، الأوتوماتيك
class TermMenuScreen extends StatelessWidget {
  final String termId;
  final String termTitle;
  const TermMenuScreen({super.key, required this.termId, required this.termTitle});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(termTitle)),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _MenuTile(
            icon: Icons.quiz,
            title: 'نماذج اختبارات لكل درس',
            subtitle: 'اختر الدرس ثم أجب على أسئلة صح/خطأ واختيار من متعدد',
            onTap: () => Navigator.of(context).push(MaterialPageRoute(
              builder: (_) => LessonListScreen(termId: termId, termTitle: termTitle),
            )),
          ),
          _MenuTile(
            icon: Icons.summarize,
            title: 'ملخصات الدروس',
            subtitle: 'ملخص مبسّط لكل درس',
            onTap: () => Navigator.of(context).push(MaterialPageRoute(
              builder: (_) => LessonListScreen(termId: termId, termTitle: termTitle),
            )),
          ),
          _MenuTile(
            icon: Icons.menu_book,
            title: 'الشرح',
            subtitle: 'شرح كامل مع استماع صوتي',
            onTap: () => Navigator.of(context).push(MaterialPageRoute(
              builder: (_) => LessonListScreen(termId: termId, termTitle: termTitle),
            )),
          ),
          _MenuTile(
            icon: Icons.view_module,
            title: 'نماذج اختبارات الوحدات',
            subtitle: 'اختبار وحدة كاملة أو الترم بأكمله',
            onTap: () => Navigator.of(context).push(MaterialPageRoute(
              builder: (_) => UnitTestScreen(termId: termId, termTitle: termTitle),
            )),
          ),
          _MenuTile(
            icon: Icons.auto_mode,
            title: 'الأوتوماتيك',
            subtitle: 'تسلسل تلقائي: شرح ← ملخص ← اختبار ← تقييم',
            onTap: () => _showAutomaticPicker(context),
          ),
        ],
      ),
    );
  }

  void _showAutomaticPicker(BuildContext context) async {
    final lessons = await ContentService().getLessons(termId: termId);
    if (!context.mounted) return;
    showModalBottomSheet(
      context: context,
      builder: (context) => ListView(
        shrinkWrap: true,
        children: [
          const Padding(
            padding: EdgeInsets.all(16),
            child: Text('اختر الدرس لبدء الوضع الأوتوماتيكي', style: TextStyle(fontWeight: FontWeight.bold)),
          ),
          ...lessons.map((LessonModel lesson) => ListTile(
                title: Text(lesson.title),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (_) => AutomaticModeScreen(lesson: lesson),
                  ));
                },
              )),
        ],
      ),
    );
  }
}

class _MenuTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;
  const _MenuTile({required this.icon, required this.title, required this.subtitle, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: CircleAvatar(child: Icon(icon)),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(subtitle, style: const TextStyle(fontSize: 12)),
        trailing: const Icon(Icons.arrow_back_ios, size: 14),
        onTap: onTap,
        contentPadding: const EdgeInsets.all(14),
      ),
    );
  }
}
