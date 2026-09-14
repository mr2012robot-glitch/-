import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'app.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // تهيئة قاعدة البيانات المحلية (تعمل بدون إنترنت بالكامل)
  await Hive.initFlutter();
  // TODO: تسجيل الـ Adapters بعد إنشاء نماذج Hive
  // Hive.registerAdapter(UserModelAdapter());
  // Hive.registerAdapter(QuizAttemptAdapter());

  runApp(const RaedAlTarikhApp());
}
