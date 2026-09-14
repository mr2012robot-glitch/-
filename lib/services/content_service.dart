import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import '../models/lesson_model.dart';
import '../models/question_model.dart';

/// يقرأ محتوى الدروس والأسئلة من assets/data/*.json
/// هذا يجعل التطبيق يعمل بالكامل بدون إنترنت — كل المحتوى مضمَّن داخل التطبيق.
class ContentService {
  List<LessonModel>? _cachedLessons;
  List<QuestionModel>? _cachedQuestions;

  Future<List<LessonModel>> getLessons({String? termId}) async {
    _cachedLessons ??= await _loadLessons();
    if (termId == null) return _cachedLessons!;
    return _cachedLessons!.where((l) => l.termId == termId).toList()
      ..sort((a, b) => a.order.compareTo(b.order));
  }

  Future<List<QuestionModel>> getQuestionsForLesson(String lessonId) async {
    _cachedQuestions ??= await _loadQuestions();
    return _cachedQuestions!.where((q) => q.lessonId == lessonId).toList();
  }

  Future<List<QuestionModel>> getQuestionsForUnit(String unitId) async {
    final lessons = await getLessons();
    final lessonIds =
        lessons.where((l) => l.unitId == unitId).map((l) => l.id).toSet();
    _cachedQuestions ??= await _loadQuestions();
    return _cachedQuestions!
        .where((q) => lessonIds.contains(q.lessonId))
        .toList();
  }

  Future<List<LessonModel>> _loadLessons() async {
    final raw = await rootBundle.loadString('assets/data/lessons.json');
    final List<dynamic> list = jsonDecode(raw);
    return list.map((e) => LessonModel.fromJson(e)).toList();
  }

  Future<List<QuestionModel>> _loadQuestions() async {
    final raw = await rootBundle.loadString('assets/data/questions.json');
    final List<dynamic> list = jsonDecode(raw);
    return list.map((e) => QuestionModel.fromJson(e)).toList();
  }
}
