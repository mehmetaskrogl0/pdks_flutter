/// Backend'in `GET /users/me` cevabı (UserResponse şeması).
class User {
  final int id;
  final String name;
  final String surname;
  final String email;
  final String role; // 'employee' | 'admin'
  final int? workplaceId;

  const User({
    required this.id,
    required this.name,
    required this.surname,
    required this.email,
    required this.role,
    this.workplaceId,
  });

  bool get isAdmin => role == 'admin';

  String get fullName => '$name $surname'.trim();

  /// Avatar için baş harfler (ör. "Ayşe Yılmaz" → "AY").
  String get initials {
    final parts = fullName.split(' ').where((s) => s.isNotEmpty);
    final letters = parts.map((s) => s[0]).join();
    final result = letters.length > 2 ? letters.substring(0, 2) : letters;
    return result.isEmpty ? 'AY' : result.toUpperCase();
  }

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] as int,
      name: (json['name'] ?? '') as String,
      surname: (json['surname'] ?? '') as String,
      email: (json['email'] ?? '') as String,
      role: (json['role'] ?? 'employee') as String,
      workplaceId: json['workplace_id'] as int?,
    );
  }
}
