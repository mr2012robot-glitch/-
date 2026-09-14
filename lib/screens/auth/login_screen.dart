import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';
import 'role_selection_screen.dart';

/// أول شاشة تظهر للمستخدم — إنشاء حساب (اسم + كلمة مرور)
/// TODO: إضافة شعار الجمهورية اليمنية وشاشة splash قبل هذه الشاشة
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _nameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  void _submit() {
    if (!_formKey.currentState!.validate()) return;
    // TODO: استدعاء AuthService.register() وحفظ المستخدم فعليًا
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (_) => RoleSelectionScreen(userName: _nameController.text),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.school, size: 72, color: AppTheme.primaryBlue),
                  const SizedBox(height: 12),
                  const Text(
                    'رائد التاريخ',
                    style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 4),
                  const Text('أنشئ حسابك للبدء', style: TextStyle(color: Colors.grey)),
                  const SizedBox(height: 32),
                  TextFormField(
                    controller: _nameController,
                    decoration: const InputDecoration(
                      labelText: 'الاسم',
                      border: OutlineInputBorder(),
                    ),
                    validator: (v) =>
                        (v == null || v.isEmpty) ? 'الرجاء إدخال الاسم' : null,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _passwordController,
                    obscureText: true,
                    decoration: const InputDecoration(
                      labelText: 'كلمة السر',
                      border: OutlineInputBorder(),
                    ),
                    validator: (v) => (v == null || v.length < 4)
                        ? 'كلمة السر ٤ أحرف على الأقل'
                        : null,
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    child: FilledButton(
                      onPressed: _submit,
                      child: const Padding(
                        padding: EdgeInsets.symmetric(vertical: 14),
                        child: Text('متابعة'),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
