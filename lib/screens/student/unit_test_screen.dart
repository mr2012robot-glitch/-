import 'package:flutter/material.dart';
import 'quiz_screen.dart';

/// خيار "نماذج اختبارات الوحدات": يختار الطالب بين اختبار وحدة واحدة
/// أو اختبار الترم (الوحدة) كاملاً بكل دروسه
class UnitTestScreen extends StatelessWidget {
  final String termId; // term1 أو term2
  final String termTitle;
  const UnitTestScreen({super.key, required this.termId, required this.termTitle});

  @override
  Widget build(BuildContext context) {
    // في هذا المنهج: كل ترم يمثّل وحدة واحدة (unit1 لأول، unit2 للثاني)
    final unitId = termId == 'term1' ? 'unit1' : 'unit2';

    return Scaffold(
      appBar: AppBar(title: const Text('اختبارات الوحدات')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text('$termTitle يمثّل وحدة كاملة من الكتاب المكوّن من وحدتين.',
                style: const TextStyle(color: Colors.grey)),
            const SizedBox(height: 24),
            Card(
              child: ListTile(
                leading: const Icon(Icons.view_module, size: 32),
                title: const Text('اختبار الوحدة كاملة', style: TextStyle(fontWeight: FontWeight.bold)),
                subtitle: const Text('كل أسئلة دروس هذا الترم مجمّعة في اختبار واحد'),
                trailing: const Icon(Icons.arrow_back_ios, size: 14),
                onTap: () => Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => QuizScreen(
                      scopeId: unitId,
                      scopeType: 'unit',
                      title: 'اختبار $termTitle',
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 12),
            const Card(
              child: ListTile(
                leading: Icon(Icons.list_alt, size: 32),
                title: Text('اختبار كل الوحدتين معًا', style: TextStyle(fontWeight: FontWeight.bold)),
                subtitle: Text('اختبار شامل لكل الكتاب (الترمين) — قريبًا'),
                enabled: false,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
