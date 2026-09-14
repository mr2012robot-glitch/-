import 'package:flutter/material.dart';
import '../../models/lesson_model.dart';
import '../../services/tts_service.dart';

/// شاشة الشرح المفصّل — تُستخدم من واجهة الطالب وواجهة المعلم معًا.
/// [isTeacherMode] يضيف عناصر مساعدة إضافية للمعلم (نقاط تحضير الحصة).
class ExplanationScreen extends StatefulWidget {
  final LessonModel lesson;
  final bool isTeacherMode;
  const ExplanationScreen({super.key, required this.lesson, this.isTeacherMode = false});

  @override
  State<ExplanationScreen> createState() => _ExplanationScreenState();
}

class _ExplanationScreenState extends State<ExplanationScreen> {
  final TtsService _tts = TtsService();
  bool _isReading = false;

  Future<void> _toggleReading() async {
    if (_isReading) {
      await _tts.stop();
    } else {
      await _tts.readFull(widget.lesson.explanation);
    }
    setState(() => _isReading = !_isReading);
  }

  @override
  void dispose() {
    _tts.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('الشرح'),
        actions: [
          IconButton(
            icon: Icon(_isReading ? Icons.stop_circle : Icons.volume_up),
            tooltip: 'قراءة الشرح كاملًا بصوت عربي واضح',
            onPressed: _toggleReading,
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(widget.lesson.title,
                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            if (widget.isTeacherMode) ...[
              const SizedBox(height: 10),
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.amber.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Row(
                  children: [
                    Icon(Icons.school, size: 18),
                    SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'وضع المعلم: استخدم زر الاستماع لعرض الشرح صوتيًا على الطلاب، وشجّعهم على طرح الأسئلة أثناء العرض.',
                        style: TextStyle(fontSize: 12),
                      ),
                    ),
                  ],
                ),
              ),
            ],
            const SizedBox(height: 16),
            // TODO: إدراج صور توضيحية هنا من widget.lesson.imageAssets بين الفقرات
            SelectableText(
              widget.lesson.explanation,
              style: const TextStyle(fontSize: 17, height: 2.0),
            ),
          ],
        ),
      ),
    );
  }
}
