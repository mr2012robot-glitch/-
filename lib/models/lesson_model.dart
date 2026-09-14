class LessonModel {
  final String id; // مثال: t1_l1
  final String termId; // term1 / term2
  final String unitId; // الوحدة (كل ترم = وحدة في اختبارات الوحدات)
  final int order;
  final String title;
  final String summary; // ملخص الدرس
  final String explanation; // الشرح الموسّع (كأستاذ متخصص)
  final List<String> imageAssets; // صور توضيحية للشرح
  final int bookPageStart; // رقم صفحة البداية في الكتاب المدرسي (للربط عند مراجعة خطأ)
  final int bookPageEnd;

  LessonModel({
    required this.id,
    required this.termId,
    required this.unitId,
    required this.order,
    required this.title,
    required this.summary,
    required this.explanation,
    required this.imageAssets,
    required this.bookPageStart,
    required this.bookPageEnd,
  });

  factory LessonModel.fromJson(Map<String, dynamic> json) => LessonModel(
        id: json['id'],
        termId: json['termId'],
        unitId: json['unitId'],
        order: json['order'],
        title: json['title'],
        summary: json['summary'],
        explanation: json['explanation'],
        imageAssets: List<String>.from(json['imageAssets'] ?? []),
        bookPageStart: json['bookPageStart'],
        bookPageEnd: json['bookPageEnd'],
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'termId': termId,
        'unitId': unitId,
        'order': order,
        'title': title,
        'summary': summary,
        'explanation': explanation,
        'imageAssets': imageAssets,
        'bookPageStart': bookPageStart,
        'bookPageEnd': bookPageEnd,
      };
}
