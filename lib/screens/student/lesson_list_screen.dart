import 'package:flutter/material.dart';
import '../../models/lesson_model.dart';
import '../../services/content_service.dart';
import 'lesson_options_screen.dart';

/// تعرض دروس الترم المختار؛ الضغط على أي درس يفتح خيارات الدرس
/// (ملخص / شرح / نموذج اختبار)
class LessonListScreen extends StatefulWidget {
  final String termId;
  final String termTitle;
  const LessonListScreen({super.key, required this.termId, required this.termTitle});

  @override
  State<LessonListScreen> createState() => _LessonListScreenState();
}

class _LessonListScreenState extends State<LessonListScreen> {
  final ContentService _contentService = ContentService();
  late Future<List<LessonModel>> _lessonsFuture;

  @override
  void initState() {
    super.initState();
    _lessonsFuture = _contentService.getLessons(termId: widget.termId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.termTitle)),
      body: FutureBuilder<List<LessonModel>>(
        future: _lessonsFuture,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          final lessons = snapshot.data!;
          return ListView.separated(
            padding: const EdgeInsets.all(12),
            itemCount: lessons.length,
            separatorBuilder: (_, __) => const SizedBox(height: 8),
            itemBuilder: (context, index) {
              final lesson = lessons[index];
              return Card(
                child: ListTile(
                  leading: CircleAvatar(child: Text('${lesson.order}')),
                  title: Text(lesson.title, style: const TextStyle(fontWeight: FontWeight.bold)),
                  trailing: const Icon(Icons.arrow_back_ios, size: 14),
                  onTap: () => Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => LessonOptionsScreen(lesson: lesson),
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
