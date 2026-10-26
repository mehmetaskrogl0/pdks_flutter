/// Backend bağlantı ayarları.
///
/// React Native sürümündeki `EXPO_PUBLIC_BACKEND_URL` ve
/// `EXPO_PUBLIC_API_PREFIX` ortam değişkenlerinin karşılığıdır.
/// Farklı bir sunucu kullanmak için:
///   flutter run --dart-define=BACKEND_URL=http://10.0.2.2:8000
class AppConfig {
  AppConfig._();

  static const String _defaultBaseUrl = 'https://pdks-mobil.onrender.com';

  static const String backendUrl = String.fromEnvironment(
    'BACKEND_URL',
    defaultValue: _defaultBaseUrl,
  );

  static const String apiPrefix = String.fromEnvironment(
    'API_PREFIX',
    defaultValue: '',
  );

  static String get apiBase => '${backendUrl.trim()}${apiPrefix.trim()}';

  /// Token'ın güvenli depolamadaki anahtarı.
  static const String tokenKey = 'atlas_pdks_token';
}
