import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:path_provider/path_provider.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';

/// يعرض الكتاب المدرسي الرسمي (الفصلين الدراسيين) كملف PDF مضمَّن
/// داخل التطبيق نفسه، بحيث يعمل بدون إنترنت بالكامل.
/// الملف موجود مسبقًا في: assets/data/history_book.pdf
class BookViewerScreen extends StatefulWidget {
  const BookViewerScreen({super.key});

  @override
  State<BookViewerScreen> createState() => _BookViewerScreenState();
}

class _BookViewerScreenState extends State<BookViewerScreen> {
  String? _localPath;
  String? _error;
  int _currentPage = 0;
  int _totalPages = 0;

  @override
  void initState() {
    super.initState();
    _prepareFile();
  }

  /// ينسخ ملف الـ PDF من الأصول (assets) إلى مجلد مؤقت على الجهاز،
  /// لأن عارض PDFView يحتاج مسار ملف فعلي على القرص، لا مسار أصول.
  Future<void> _prepareFile() async {
    try {
      final bytes = await rootBundle.load('assets/data/history_book.pdf');
      final dir = await getTemporaryDirectory();
      final file = File('${dir.path}/history_book.pdf');
      // لا ننسخ الملف من جديد إذا كان موجودًا مسبقًا (يوفر وقت فتح التطبيق)
      if (!await file.exists() || await file.length() != bytes.lengthInBytes) {
        await file.writeAsBytes(bytes.buffer.asUint8List(), flush: true);
      }
      if (!mounted) return;
      setState(() => _localPath = file.path);
    } catch (e) {
      if (!mounted) return;
      setState(() => _error = 'تعذّر تحميل الكتاب: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_totalPages > 0
            ? 'الكتاب المدرسي — صفحة ${_currentPage + 1}/$_totalPages'
            : 'الكتاب المدرسي'),
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (_error != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Text(_error!, textAlign: TextAlign.center),
        ),
      );
    }
    if (_localPath == null) {
      return const Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 12),
            Text('جارٍ تحميل الكتاب...'),
          ],
        ),
      );
    }
    return PDFView(
      filePath: _localPath!,
      enableSwipe: true,
      swipeHorizontal: false, // تصفح عمودي أنسب لصفحات الكتاب العربي
      autoSpacing: true,
      pageFling: true,
      nightMode: Theme.of(context).brightness == Brightness.dark,
      onRender: (pages) => setState(() => _totalPages = pages ?? 0),
      onPageChanged: (page, total) => setState(() => _currentPage = page ?? 0),
      onError: (error) => setState(() => _error = 'خطأ في عرض الملف: $error'),
    );
  }
}
