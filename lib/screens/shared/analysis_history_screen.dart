import 'package:flutter/material.dart';
import 'package:intl/intl.dart' as intl;
import '../../models/quiz_attempt_model.dart';

/// يعرض كل محاولات الاختبار السابقة (تاريخ + وقت + نتيجة)
/// TODO: جلب البيانات فعليًا من Hive بدل القائمة التجريبية أدناه
class AnalysisHistoryScreen extends StatelessWidget {
  const AnalysisHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final List<QuizAttemptModel> attempts = []; // TODO: استبدال بالبيانات الفعلية

    return Scaffold(
      appBar: AppBar(title: const Text('سجل التحليل')),
      body: attempts.isEmpty
          ? const Center(child: Text('لا يوجد سجل اختبارات بعد'))
          : ListView.builder(
              itemCount: attempts.length,
              itemBuilder: (context, index) {
                final a = attempts[index];
                final formatted =
                    intl.DateFormat('yyyy/MM/dd - hh:mm a').format(a.dateTime);
                return ListTile(
                  leading: CircleAvatar(
                    child: Text('${a.scoreOutOf100.toStringAsFixed(0)}'),
                  ),
                  title: Text(a.scopeId),
                  subtitle: Text(formatted),
                );
              },
            ),
    );
  }
}
