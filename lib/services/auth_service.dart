import 'package:hive/hive.dart';
import '../models/user_model.dart';

/// خدمة مصادقة محلية بالكامل (بدون إنترنت) عبر Hive.
/// TODO: استبدال password hashing البسيط بمكتبة تشفير حقيقية قبل الإنتاج.
class AuthService {
  static const String boxName = 'usersBox';

  Future<Box> _openBox() async => Hive.openBox(boxName);

  Future<UserModel?> getCurrentUser() async {
    final box = await _openBox();
    final data = box.get('currentUser');
    if (data == null) return null;
    return UserModel.fromJson(Map<String, dynamic>.from(data));
  }

  Future<UserModel> register({
    required String name,
    required String password,
    required UserRole role,
  }) async {
    final box = await _openBox();
    final user = UserModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      name: name,
      passwordHash: _hash(password),
      role: role,
    );
    await box.put('currentUser', user.toJson());
    return user;
  }

  Future<bool> login({required String name, required String password}) async {
    final box = await _openBox();
    final data = box.get('currentUser');
    if (data == null) return false;
    final user = UserModel.fromJson(Map<String, dynamic>.from(data));
    return user.name == name && user.passwordHash == _hash(password);
  }

  String _hash(String input) => input; // TODO: استبدال بتشفير حقيقي
}
