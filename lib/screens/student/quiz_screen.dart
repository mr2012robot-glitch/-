import 'dart:async';
import 'package:flutter/material.dart';
import '../../models/question_model.dart';
import '../../models/quiz_attempt_model.dart';
import '../../services/content_service.dart';
import 'quiz_result_screen.dart';

/// محرك الاختبار المطلوب بالمواصفات:
/// - صح/خطأ أولًا، ثم اختيار من متعدد
/// - سؤال واحد في الشاشة، لا ينتقل للتالي إلا بعد اختيار إجابة
/// - لا يظهر صح/خطأ أثناء الحل (يظهر فقط في شاشة التقييم النهائية)
/// - خيار إيقاف مؤقت (Pause) يحفظ التقدم الحالي في الذاكرة
class QuizScreen extends StatefulWidget {
  final String scopeId; // معرف الدرس أو الوحدة
  final String scopeType; // 'lesson' أو 'unit'
  final String title;
  const QuizScreen({super.key, required this.scopeId, required this.scopeType, required this.title});

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  final ContentService _contentService = ContentService();
  List<QuestionModel> _questions = [];
  final List<AnsweredQuestion> _answers = [];
  int _currentIndex = 0;
  int? _selectedOption;
  bool _isPaused = false;
  bool _isLoading = true;
  late DateTime _startTime;
  Duration _pausedDuration = Duration.zero;
  DateTime? _pauseStart;

  @override
  void initState() {
    super.initState();
    _startTime = DateTime.now();
    _loadQuestions();
  }

  Future<void> _loadQuestions() async {
    final questions = widget.scopeType == 'unit'
        ? await _contentService.getQuestionsForUnit(widget.scopeId)
        : await _contentService.getQuestionsForLesson(widget.scopeId);

    // ترتيب مطلوب بالمواصفات: كل أسئلة الصح/الخطأ أولًا، ثم كل أسئلة الاختيار من متعدد
    questions.sort((a, b) {
      if (a.type == b.type) return 0;
      return a.type == QuestionType.trueFalse ? -1 : 1;
    });

    setState(() {
      _questions = questions;
      _isLoading = false;
    });
  }

  void _togglePause() {
    setState(() {
      _isPaused = !_isPaused;
      if (_isPaused) {
        _pauseStart = DateTime.now();
      } else if (_pauseStart != null) {
        _pausedDuration += DateTime.now().difference(_pauseStart!);
        _pauseStart = null;
      }
    });
  }

  void _selectOption(int index) {
    if (_selectedOption != null) return; // منع تغيير الإجابة بعد الاختيار
    setState(() => _selectedOption = index);
  }

  void _next() {
    final question = _questions[_currentIndex];
    _answers.add(AnsweredQuestion(
      questionId: question.id,
      selectedOptionIndex: _selectedOption!,
      isCorrect: _selectedOption == question.correctOptionIndex,
    ));

    if (_currentIndex == _questions.length - 1) {
      _finishQuiz();
    } else {
      setState(() {
        _currentIndex++;
        _selectedOption = null;
      });
    }
  }

  void _finishQuiz() {
    final totalTime = DateTime.now().difference(_startTime) - _pausedDuration;
    final attempt = QuizAttemptModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      userId: 'current_user', // TODO: ربطه بالمستخدم الفعلي من AuthService
      scopeId: widget.scopeId,
      scopeType: widget.scopeType,
      dateTime: DateTime.now(),
      timeTaken: totalTime,
      answers: List.of(_answers),
    );
    // TODO: حفظ attempt في Hive لعرضه لاحقًا في "سجل التحليل"
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (_) => QuizResultScreen(attempt: attempt, questions: _questions),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    if (_questions.isEmpty) {
      return Scaffold(
        appBar: AppBar(title: Text(widget.title)),
        body: const Center(child: Text('لا توجد أسئلة متاحة لهذا الاختيار بعد.')),
      );
    }

    final question = _questions[_currentIndex];
    final progress = (_currentIndex + 1) / _questions.length;

    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.title} — سؤال ${_currentIndex + 1}/${_questions.length}'),
        actions: [
          IconButton(
            icon: Icon(_isPaused ? Icons.play_arrow : Icons.pause),
            tooltip: _isPaused ? 'استئناف' : 'إيقاف مؤقت',
            onPressed: _togglePause,
          ),
        ],
      ),
      body: _isPaused
          ? const Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.pause_circle, size: 64),
                  SizedBox(height: 12),
                  Text('الاختبار متوقف مؤقتًا', style: TextStyle(fontSize: 18)),
                ],
              ),
            )
          : Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  LinearProgressIndicator(value: progress),
                  const SizedBox(height: 24),
                  Text(
                    question.type == QuestionType.trueFalse ? 'صح أم خطأ؟' : 'اختر الإجابة الصحيحة',
                    style: TextStyle(color: Theme.of(context).colorScheme.primary, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Text(question.text, style: const TextStyle(fontSize: 19, fontWeight: FontWeight.w600)),
                  const SizedBox(height: 24),
                  Expanded(
                    child: ListView.separated(
                      itemCount: question.options.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 10),
                      itemBuilder: (context, i) {
                        final isSelected = _selectedOption == i;
                        return OutlinedButton(
                          onPressed: () => _selectOption(i),
                          style: OutlinedButton.styleFrom(
                            backgroundColor: isSelected
                                ? Theme.of(context).colorScheme.primaryContainer
                                : null,
                            padding: const EdgeInsets.all(16),
                            alignment: Alignment.centerRight,
                          ),
                          child: Text(question.options[i], style: const TextStyle(fontSize: 16)),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 12),
                  FilledButton(
                    onPressed: _selectedOption == null ? null : _next,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      child: Text(_currentIndex == _questions.length - 1 ? 'إنهاء الاختبار' : 'التالي'),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
