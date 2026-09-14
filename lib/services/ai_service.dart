import 'package:connectivity_plus/connectivity_plus.dart';
import '../models/lesson_model.dart';

/// خدمة موحّدة للذكاء الاصطناعي:
/// - بدون إنترنت: بحث محلي داخل محتوى الدروس (assets/data) — راجع docs/AI_STRATEGY.md
/// - مع إنترنت: يمكن ربطها لاحقًا بواجهة API خارجية لإجابات أوسع
class AiService {
  Future<bool> get isOnline async {
    final result = await Connectivity().checkConnectivity();
    return result.any((r) => r != ConnectivityResult.none);
  }

  /// السؤال المباشر أو طلب توضيح مصطلح
  Future<String> ask(String question, List<LessonModel> availableLessons) async {
    if (await isOnline) {
      return _askOnline(question);
    }
    return _askOffline(question, availableLessons);
  }

  Future<String> _askOffline(
      String question, List<LessonModel> lessons) async {
    // بحث بسيط بالكلمات المفتاحية داخل الملخصات والشروحات المحلية
    // TODO: ترقيته لاحقًا إلى بحث دلالي (Semantic Search) بنموذج TFLite مصغّر
    final normalized = question.trim();
    for (final lesson in lessons) {
      if (lesson.title.contains(normalized) ||
          lesson.summary.contains(normalized) ||
          lesson.explanation.contains(normalized)) {
        return 'من درس "${lesson.title}":\n${lesson.summary}';
      }
    }
    return 'لم أجد إجابة مباشرة في المحتوى المحلي. جرّب صياغة أوضح، أو اتصل بالإنترنت لإجابة أشمل.';
  }

  Future<String> _askOnline(String question) async {
    // TODO: استبدال هذا باستدعاء API فعلي (مثل Anthropic API) عند توفر الإنترنت
    throw UnimplementedError('ربط الذكاء الاصطناعي الأونلاين لم يُنفَّذ بعد');
  }
}
