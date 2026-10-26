import 'package:flutter/foundation.dart';

import '../models/user.dart';
import '../services/api_service.dart';
import '../services/token_storage.dart';

/// Oturum durumunu yöneten sınıf (React Native sürümündeki `AuthProvider`
/// / `useAuth`). Değişiklik olduğunda `notifyListeners()` ile dinleyen
/// widget'ları yeniden çizer.
class AuthProvider extends ChangeNotifier {
  AuthProvider._(this._api, this._tokenStorage);

  /// API istemcisi ve oturum aynı token deposunu paylaşır.
  factory AuthProvider({ApiService? api, TokenStorage? tokenStorage}) {
    final storage = tokenStorage ?? TokenStorage();
    return AuthProvider._(api ?? ApiService(tokenStorage: storage), storage);
  }

  final ApiService _api;
  final TokenStorage _tokenStorage;

  User? _user;
  bool _loading = true;

  User? get user => _user;
  bool get loading => _loading;
  bool get isLoggedIn => _user != null;

  /// Uygulama açılışında kayıtlı token varsa kullanıcıyı yükler.
  Future<void> init() async {
    await refresh();
    _loading = false;
    notifyListeners();
  }

  /// Token geçerliyse `/users/me` ile kullanıcıyı getirir,
  /// geçersizse token'ı siler.
  Future<void> refresh() async {
    final token = await _tokenStorage.read();
    if (token == null || token.isEmpty) {
      _user = null;
      notifyListeners();
      return;
    }
    try {
      final me = await _api.get('/users/me');
      _user = User.fromJson(me as Map<String, dynamic>);
    } catch (_) {
      await _tokenStorage.clear();
      _user = null;
    }
    notifyListeners();
  }

  /// POST /auth/login → {access_token, token_type}
  /// Ardından GET /users/me ile kullanıcı bilgisi alınır.
  Future<User> login(String email, String password) async {
    final res = await _api.post('/auth/login', {
      'email': email,
      'password': password,
    });
    await _tokenStorage.save(res['access_token'] as String);

    final me = await _api.get('/users/me');
    _user = User.fromJson(me as Map<String, dynamic>);
    notifyListeners();
    return _user!;
  }

  /// POST /auth/register → {message, user_id} (token dönmez),
  /// bu yüzden kayıttan hemen sonra giriş yapılır.
  Future<User> register(
    String name,
    String surname,
    String email,
    String password,
  ) async {
    await _api.post('/auth/register', {
      'name': name,
      'surname': surname,
      'email': email,
      'password': password,
    });
    return login(email, password);
  }

  /// Token'ı siler ve kullanıcıyı oturumdan çıkarır.
  Future<void> logout() async {
    await _tokenStorage.clear();
    _user = null;
    notifyListeners();
  }
}
