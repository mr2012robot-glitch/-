enum UserRole { student, teacher }

class UserModel {
  final String id;
  final String name;
  final String passwordHash; // TODO: استخدام تشفير حقيقي (bcrypt/argon2) بدل نص عادي
  final UserRole role;

  UserModel({
    required this.id,
    required this.name,
    required this.passwordHash,
    required this.role,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'passwordHash': passwordHash,
        'role': role.name,
      };

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
        id: json['id'],
        name: json['name'],
        passwordHash: json['passwordHash'],
        role: UserRole.values.byName(json['role']),
      );
}
