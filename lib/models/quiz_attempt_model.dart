class AnsweredQuestion {
  final String questionId;
  final int selectedOptionIndex;
  final bool isCorrect;

  AnsweredQuestion({
    required this.questionId,
    required this.selectedOptionIndex,
    required this.isCorrect,
  });
}

/// يمثّل نتيجة اختبار كامل (لدرس واحد أو لوحدة)، يُخزَّن محليًا
/// ويظهر في "سجل التحليل" بالقائمة الجانبية
class QuizAttemptModel {
  final String id;
  final String userId;
  final String scopeId; // معرّف الدرس أو الوحدة
  final String scopeType; // 'lesson' أو 'unit'
  final DateTime dateTime;
  final Duration timeTaken;
  final List<AnsweredQuestion> answers;

  QuizAttemptModel({
    required this.id,
    required this.userId,
    required this.scopeId,
    required this.scopeType,
    required this.dateTime,
    required this.timeTaken,
    required this.answers,
  });

  int get correctCount => answers.where((a) => a.isCorrect).length;
  int get wrongCount => answers.length - correctCount;

  /// التقييم من ١٠٠
  double get scoreOutOf100 =>
      answers.isEmpty ? 0 : (correctCount / answers.length) * 100;

  List<AnsweredQuestion> get wrongAnswers =>
      answers.where((a) => !a.isCorrect).toList();

  List<AnsweredQuestion> get correctAnswers =>
      answers.where((a) => a.isCorrect).toList();
}
