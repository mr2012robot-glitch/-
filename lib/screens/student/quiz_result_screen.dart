import 'package:flutter/material.dart';
import '../../models/question_model.dart';
import '../../models/quiz_attempt_model.dart';

/// شاشة التقييم بعد انتهاء الاختبار:
/// - النسبة من 100
/// - عدد الصح/الخطأ
/// - الوقت المستغرق
/// - قائمة قابلة للفتح للأسئلة الخاطئة مع الإجابة الصحيحة ومكان مراجعتها
/// - قائمة مماثلة للأسئلة الصحيحة
class QuizResultScreen extends StatelessWidget {
  final QuizAttemptModel attempt;
  final List<QuestionModel> questions;
  const QuizResultScreen({super.key, required this.attempt, required this.questions});

  QuestionModel _questionFor(String id) => questions.firstWhere((q) => q.id == id);

  @override
  Widget build(BuildContext context) {
    final score = attempt.scoreOutOf100;
    final minutes = attempt.timeTaken.inMinutes;
    final seconds = attempt.timeTaken.inSeconds % 60;

    return Scaffold(
      appBar: AppBar(title: const Text('نتيجة الاختبار'), automaticallyImplyLeading: false),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Center(
            child: Column(
              children: [
                CircleAvatar(
                  radius: 56,
                  backgroundColor: score >= 50
                      ? Colors.green.withOpacity(0.15)
                      : Colors.red.withOpacity(0.15),
                  child: Text(
                    score.toStringAsFixed(0),
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: score >= 50 ? Colors.green[700] : Colors.red[700],
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                const Text('من 100', style: TextStyle(color: Colors.grey)),
              ],
            ),
          ),
          const SizedBox(height: 24),
          Row(
            children: [
              Expanded(
                child: _StatCard(
                  label: 'إجابات صحيحة',
                  value: '${attempt.correctCount}',
                  color: Colors.green,
                  icon: Icons.check_circle,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _StatCard(
                  label: 'إجابات خاطئة',
                  value: '${attempt.wrongCount}',
                  color: Colors.red,
                  icon: Icons.cancel,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _StatCard(
                  label: 'الوقت',
                  value: '$minutes:${seconds.toString().padLeft(2, '0')}',
                  color: Colors.blueGrey,
                  icon: Icons.timer,
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          if (attempt.wrongAnswers.isNotEmpty) ...[
            const Text('نقاط تحتاج مراجعة', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            const SizedBox(height: 8),
            ...attempt.wrongAnswers.map((a) {
              final q = _questionFor(a.questionId);
              return Card(
                color: Colors.red.withOpacity(0.05),
                child: ExpansionTile(
                  leading: const Icon(Icons.close, color: Colors.red),
                  title: Text(q.text),
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('إجابتك: ${q.options[a.selectedOptionIndex]}',
                              style: const TextStyle(color: Colors.red)),
                          Text('الإجابة الصحيحة: ${q.options[q.correctOptionIndex]}',
                              style: const TextStyle(color: Colors.green)),
                          const SizedBox(height: 6),
                          Text('راجع: ${q.referenceInExplanation} (صفحة ${q.referenceBookPage} في الكتاب)',
                              style: const TextStyle(fontSize: 12, color: Colors.grey)),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            }),
            const SizedBox(height: 16),
          ],
          ExpansionTile(
            title: Text('الإجابات الصحيحة (${attempt.correctCount})'),
            children: attempt.correctAnswers.map((a) {
              final q = _questionFor(a.questionId);
              return ListTile(
                leading: const Icon(Icons.check, color: Colors.green),
                title: Text(q.text),
              );
            }).toList(),
          ),
          const SizedBox(height: 24),
          FilledButton(
            onPressed: () => Navigator.of(context).popUntil((route) => route.isFirst),
            child: const Padding(
              padding: EdgeInsets.symmetric(vertical: 14),
              child: Text('العودة للرئيسية'),
            ),
          ),
        ],
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final String label;
  final String value;
  final Color color;
  final IconData icon;
  const _StatCard({required this.label, required this.value, required this.color, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: color.withOpacity(0.08),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
        child: Column(
          children: [
            Icon(icon, color: color),
            const SizedBox(height: 6),
            Text(value, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: color)),
            Text(label, style: const TextStyle(fontSize: 11), textAlign: TextAlign.center),
          ],
        ),
      ),
    );
  }
}
