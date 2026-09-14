import 'package:flutter_tts/flutter_tts.dart';

/// خدمة القراءة الصوتية — تعمل بدون إنترنت عبر محرك TTS المدمج بالجهاز
class TtsService {
  final FlutterTts _tts = FlutterTts();
  bool _initialized = false;

  Future<void> _init() async {
    if (_initialized) return;
    await _tts.setLanguage('ar-SA'); // نطق عربي فصيح واضح
    await _tts.setSpeechRate(0.45); // بطء مناسب للشرح التعليمي
    await _tts.setPitch(1.0);
    _initialized = true;
  }

  /// قراءة الشرح كاملاً (زر أعلى شاشة الشرح)
  Future<void> readFull(String text) async {
    await _init();
    await _tts.stop();
    await _tts.speak(text);
  }

  /// قراءة نص محدد فقط (عند تحديد جملة في أي شاشة)
  Future<void> readSelection(String selectedText) async {
    await _init();
    await _tts.stop();
    await _tts.speak(selectedText);
  }

  Future<void> stop() => _tts.stop();
  Future<void> pause() => _tts.pause();
}
