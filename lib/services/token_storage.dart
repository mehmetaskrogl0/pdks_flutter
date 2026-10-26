import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../core/config.dart';

/// JWT token'ı cihazda güvenli şekilde saklar.
/// Android'de EncryptedSharedPreferences, iOS'ta Keychain kullanır.
/// (React Native sürümündeki `storage.secureGet/secureSet/secureRemove`.)
class TokenStorage {
  TokenStorage({FlutterSecureStorage? storage})
      : _storage = storage ??
            const FlutterSecureStorage(
              aOptions: AndroidOptions(encryptedSharedPreferences: true),
            );

  final FlutterSecureStorage _storage;

  Future<String?> read() async {
    try {
      return await _storage.read(key: AppConfig.tokenKey);
    } catch (_) {
      return null;
    }
  }

  Future<void> save(String token) async {
    await _storage.write(key: AppConfig.tokenKey, value: token);
  }

  Future<void> clear() async {
    try {
      await _storage.delete(key: AppConfig.tokenKey);
    } catch (_) {}
  }
}
