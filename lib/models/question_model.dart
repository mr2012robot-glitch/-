enum QuestionType { trueFalse, multipleChoice }

class QuestionModel {
  final String id;
  final String lessonId;
  final QuestionType type;
  final String text;

  /// لسؤال صح/خطأ: ["صح", "خطأ"]
  /// لسؤال اختيار من متعدد: ٤ خيارات
  final List<String> options;

  final int correctOptionIndex;

  /// مرجع لمكان الإجابة الصحيحة — يُستخدم لتوجيه الطالب بعد الخطأ
  /// إلى مكانها في الشرح/الملخص/الكتاب
  final String referenceInExplanation; // مقطع قصير أو معرّف داخل الشرح
  final int referenceBookPage;

  QuestionModel({
    required this.id,
    required this.lessonId,
    required this.type,
    required this.text,
    required this.options,
    required this.correctOptionIndex,
    required this.referenceInExplanation,
    required this.referenceBookPage,
  });

  factory QuestionModel.fromJson(Map<String, dynamic> json) => QuestionModel(
        id: json['id'],
        lessonId: json['lessonId'],
        type: QuestionType.values.byName(json['type']),
        text: json['text'],
        options: List<String>.from(json['options']),
        correctOptionIndex: json['correctOptionIndex'],
        referenceInExplanation: json['referenceInExplanation'],
        referenceBookPage: json['referenceBookPage'],
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'lessonId': lessonId,
        'type': type.name,
        'text': text,
        'options': options,
        'correctOptionIndex': correctOptionIndex,
        'referenceInExplanation': referenceInExplanation,
        'referenceBookPage': referenceBookPage,
      };
}
