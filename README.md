# PDKS Flutter

Atlas PDKS (Personel Devam Kontrol Sistemi) mobil uygulamasının **Flutter / Dart** versiyonu.

Orijinal mobil uygulama ([PDKS_mobil](https://github.com/mehmetaskrogl0/PDKS_mobil) → `mobile_app/mobil-main/frontend`) React Native (Expo, TypeScript) ile yazılmıştı. Bu repo, o uygulamanın **giriş yapma, kayıt olma ve çıkış yapma** kısımlarını Flutter widget'ları ile yeniden yazar.

**Backend (Python / FastAPI) ve veritabanında hiçbir değişiklik yoktur.** Uygulama mevcut backend'in aynı uç noktalarını kullanır.

## Özellikler

- E-posta + şifre ile giriş (`POST /auth/login`, ardından `GET /users/me`)
- Yeni çalışan kaydı (`POST /auth/register`, ardından otomatik giriş)
- JWT token'ın cihazda güvenli saklanması (Android Keystore / iOS Keychain)
- Uygulama açılışında kayıtlı oturumun otomatik yüklenmesi
- Profil ekranı ve çıkış yapma (token silinir, giriş ekranına dönülür)
- Form doğrulama ve backend hata mesajlarının gösterilmesi

## Proje yapısı

```
lib/
├── main.dart                    # Uygulama girişi, rotalar, AuthGate
├── core/
│   ├── config.dart              # Backend adresi ve token anahtarı
│   └── theme.dart               # Renkler, boşluklar, gölgeler
├── models/
│   └── user.dart                # User modeli (UserResponse şeması)
├── services/
│   ├── api_service.dart         # HTTP istemcisi + Bearer token
│   └── token_storage.dart       # flutter_secure_storage sarmalayıcı
├── providers/
│   └── auth_provider.dart       # Oturum durumu (ChangeNotifier)
├── screens/
│   ├── login_screen.dart        # Giriş ekranı
│   ├── register_screen.dart     # Kayıt ekranı
│   └── home_screen.dart         # Profil + Çıkış Yap
└── widgets/
    ├── app_text_field.dart      # Etiketli metin alanı
    ├── primary_button.dart      # Yükleniyor durumlu ana buton
    └── form_card.dart           # Form kartı ve hata metni
test/
└── auth_flow_test.dart          # Giriş / kayıt / çıkış widget testleri
```

## React Native → Flutter karşılıkları

| React Native (Expo) | Flutter |
|---|---|
| `src/api.ts` (`fetch`) | `services/api_service.dart` (`http`) |
| `expo-secure-store` | `flutter_secure_storage` |
| `src/auth.tsx` (`AuthProvider`, `useAuth`) | `providers/auth_provider.dart` (`ChangeNotifier` + `provider`) |
| `app/index.tsx` (yönlendirme) | `main.dart` → `AuthGate` |
| `app/(auth)/login.tsx` | `screens/login_screen.dart` |
| `app/(auth)/register.tsx` | `screens/register_screen.dart` |
| `app/(tabs)/profile.tsx` (Çıkış Yap) | `screens/home_screen.dart` |
| `useState` | `StatefulWidget` + `setState` |
| `TextInput` | `TextField` + `TextEditingController` |
| `Pressable` | `ElevatedButton` / `InkWell` / `GestureDetector` |
| `View` + `StyleSheet` | `Container` + `BoxDecoration`, `Row`, `Column` |
| `ScrollView` / `KeyboardAvoidingView` | `SingleChildScrollView` (Scaffold klavyeye göre ayarlanır) |
| `SafeAreaView` | `SafeArea` |
| `router.replace` / `Link` | `Navigator` + named routes |

## Kurulum ve çalıştırma

Gereksinim: Flutter 3.27 veya üzeri.

```bash
git clone https://github.com/mehmetaskrogl0/pdks_flutter.git
cd pdks_flutter

# Android / iOS platform klasörlerini oluştur (lib/ dosyalarına dokunmaz)
flutter create --platforms android,ios --org com.atlaspdks .

flutter pub get
flutter run
```

> Android'de release derlemede internet izni için `android/app/src/main/AndroidManifest.xml` içine
> `<uses-permission android:name="android.permission.INTERNET"/>` satırını `<application>` etiketinin üstüne ekleyin.
> Yerel (http) backend ile denemek için `<application ... android:usesCleartextTraffic="true">` ekleyin.

### Backend adresi

Varsayılan adres orijinal uygulamadakiyle aynıdır: `https://pdks-mobil.onrender.com`.
Farklı bir sunucu için:

```bash
# Android emülatörden bilgisayardaki backend'e:
flutter run --dart-define=BACKEND_URL=http://10.0.2.2:8000

# Backend /api önekiyle çalışıyorsa:
flutter run --dart-define=BACKEND_URL=http://10.0.2.2:8001 --dart-define=API_PREFIX=/api
```

## Testler

```bash
flutter test
```

Testler gerçek sunucu yerine sahte bir HTTP istemcisi kullanır ve şunları doğrular: boş form uyarısı, yanlış şifre mesajı, giriş → profil → çıkış akışı, kayıt → otomatik giriş akışı.
