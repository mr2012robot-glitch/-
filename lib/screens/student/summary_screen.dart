import 'package:flutter/material.dart';
import '../../models/lesson_model.dart';
import '../../services/tts_service.dart';

/// عرض ملخص الدرس، مع دعم تحديد أي جملة والاستماع لها بالصوت
class SummaryScreen extends StatefulWidget {
  final LessonModel lesson;
  const SummaryScreen({super.key, required this.lesson});

  @override
  State<SummaryScreen> createState() => _SummaryScreenState();
}

class _SummaryScreenState extends State<SummaryScreen> {
  final TtsService _tts = TtsService();

  @override
  void dispose() {
    _tts.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ملخص الدرس'),
        actions: [
          IconButton(
            icon: const Icon(Icons.volume_up),
            tooltip: 'استماع للملخص كاملًا',
            onPressed: () => _tts.readFull(widget.lesson.summary),
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
            const SizedBox(height: 16),
            // SelectableText يتيح للطالب تحديد أي جملة، ثم يمكن ربط قائمة
            // سياق مخصصة (context menu) بزر "استماع" لنفس التحديد.
            SelectableText(
              widget.lesson.summary,
              style: const TextStyle(fontSize: 17, height: 1.9),
              toolbarOptions: const ToolbarOptions(copy: true, selectAll: true),
              onSelectionChanged: (selection, cause) {
                // TODO: عند التحديد، إظهار زر عائم "استماع لهذا المقطع" يستدعي
                // _tts.readSelection(selectedSubstring) بعد استخراج النص المحدد.
              },
            ),
            const SizedBox(height: 24),
            Card(
              color: Theme.of(context).colorScheme.primaryContainer.withOpacity(0.3),
              child: Padding(
                padding: const EdgeInsets.all(14),
                child: Row(
                  children: [
                    const Icon(Icons.lightbulb_outline),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        'مرجع الدرس في الكتاب المدرسي: صفحة ${widget.lesson.bookPageStart} - ${widget.lesson.bookPageEnd}',
                        style: const TextStyle(fontSize: 13),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
