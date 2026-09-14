import 'package:flutter/material.dart';
import '../../models/lesson_model.dart';
import '../../services/tts_service.dart';
import 'quiz_screen.dart';

enum _AutoStep { explanation, summary }

/// خيار "الأوتوماتيك بالدرس": يعرض تلقائيًا الشرح ثم الملخص، وبعد الضغط
/// على "التالي" في الملخص ينتقل مباشرة لاختبار الدرس، ثم لشاشة التقييم.
/// يدعم إيقافًا مؤقتًا في أي لحظة.
class AutomaticModeScreen extends StatefulWidget {
  final LessonModel lesson;
  const AutomaticModeScreen({super.key, required this.lesson});

  @override
  State<AutomaticModeScreen> createState() => _AutomaticModeScreenState();
}

class _AutomaticModeScreenState extends State<AutomaticModeScreen> {
  _AutoStep _step = _AutoStep.explanation;
  bool _isPaused = false;
  final TtsService _tts = TtsService();

  void _next() {
    if (_step == _AutoStep.explanation) {
      setState(() => _step = _AutoStep.summary);
    } else {
      // الانتقال إلى اختبار الدرس، ثم شاشة التقييم تلقائيًا من داخل QuizScreen
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (_) => QuizScreen(
            scopeId: widget.lesson.id,
            scopeType: 'lesson',
            title: 'اختبار ${widget.lesson.title}',
          ),
        ),
      );
    }
  }

  @override
  void dispose() {
    _tts.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isExplanation = _step == _AutoStep.explanation;
    final content = isExplanation ? widget.lesson.explanation : widget.lesson.summary;

    return Scaffold(
      appBar: AppBar(
        title: Text('الأوتوماتيك — ${isExplanation ? "الشرح" : "الملخص"}'),
        actions: [
          IconButton(
            icon: Icon(_isPaused ? Icons.play_arrow : Icons.pause),
            tooltip: _isPaused ? 'استئناف' : 'إيقاف مؤقت',
            onPressed: () => setState(() => _isPaused = !_isPaused),
          ),
        ],
      ),
      body: _isPaused
          ? const Center(child: Text('متوقف مؤقتًا — اضغط زر التشغيل للمتابعة', style: TextStyle(fontSize: 16)))
          : Column(
              children: [
                LinearProgressIndicator(value: isExplanation ? 0.33 : 0.66),
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(widget.lesson.title,
                            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 12),
                        SelectableText(content, style: const TextStyle(fontSize: 16, height: 1.9)),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      IconButton.filledTonal(
                        icon: const Icon(Icons.volume_up),
                        onPressed: () => _tts.readFull(content),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: FilledButton(
                          onPressed: _next,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            child: Text(isExplanation ? 'التالي: الملخص' : 'التالي: نموذج الاختبار'),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
    );
  }
}
