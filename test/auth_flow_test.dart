import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:provider/provider.dart';

import 'package:pdks_flutter/main.dart';
import 'package:pdks_flutter/providers/auth_provider.dart';
import 'package:pdks_flutter/services/api_service.dart';
import 'package:pdks_flutter/services/token_storage.dart';

/// Testlerde cihaz depolaması yerine bellekte tutulan token.
class MemoryTokenStorage extends TokenStorage {
  String? _token;

  @override
  Future<String?> read() async => _token;

  @override
  Future<void> save(String token) async => _token = token;

  @override
  Future<void> clear() async => _token = null;
}

/// Türkçe karakterli JSON cevabı (UTF-8 bayt olarak).
http.Response jsonRes(Object body, int status) => http.Response.bytes(
      utf8.encode(jsonEncode(body)),
      status,
      headers: {'content-type': 'application/json; charset=utf-8'},
    );

/// Gerçek backend'in /auth ve /users/me cevaplarını taklit eder.
MockClient fakeBackend() {
  return MockClient((req) async {
    final path = req.url.path;
    if (path.endsWith('/auth/login')) {
      final body = jsonDecode(req.body) as Map<String, dynamic>;
      if (body['password'] != 'Sifre123') {
        return jsonRes({'detail': 'Şifre yanlış'}, 400);
      }
      return jsonRes({'access_token': 'tok', 'token_type': 'bearer'}, 200);
    }
    if (path.endsWith('/auth/register')) {
      return jsonRes({'message': 'Kullanıcı oluşturuldu', 'user_id': 7}, 200);
    }
    if (path.endsWith('/users/me')) {
      if (req.headers['Authorization'] != 'Bearer tok') {
        return jsonRes({'detail': 'Yetkisiz'}, 401);
      }
      return jsonRes({
        'id': 7,
        'name': 'Ayşe',
        'surname': 'Yılmaz',
        'email': 'ayse@sirket.com',
        'role': 'employee',
        'workplace_id': null,
      }, 200);
    }
    return jsonRes({'detail': 'Not found'}, 404);
  });
}

Widget buildApp() {
  final storage = MemoryTokenStorage();
  final api = ApiService(tokenStorage: storage, client: fakeBackend());
  return ChangeNotifierProvider(
    create: (_) => AuthProvider(api: api, tokenStorage: storage)..init(),
    child: const PdksApp(),
  );
}

Finder field(String key) => find.descendant(
      of: find.byKey(Key(key)),
      matching: find.byType(TextField),
    );

void main() {
  testWidgets('boş form gönderilince uyarı gösterilir', (tester) async {
    await tester.pumpWidget(buildApp());
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(const Key('login-submit-button')));
    await tester.pump();

    expect(find.text('E-posta ve şifre gerekli'), findsOneWidget);
  });

  testWidgets('yanlış şifrede backend mesajı gösterilir', (tester) async {
    await tester.pumpWidget(buildApp());
    await tester.pumpAndSettle();

    await tester.enterText(field('login-email-input'), 'ayse@sirket.com');
    await tester.enterText(field('login-password-input'), 'yanlis');
    await tester.tap(find.byKey(const Key('login-submit-button')));
    await tester.pumpAndSettle();

    expect(find.text('Şifre yanlış'), findsOneWidget);
  });

  testWidgets('giriş yap → profil → çıkış yap', (tester) async {
    await tester.pumpWidget(buildApp());
    await tester.pumpAndSettle();

    await tester.enterText(field('login-email-input'), 'ayse@sirket.com');
    await tester.enterText(field('login-password-input'), 'Sifre123');
    await tester.tap(find.byKey(const Key('login-submit-button')));
    await tester.pumpAndSettle();

    expect(find.byKey(const Key('profile-screen')), findsOneWidget);
    expect(find.text('Ayşe Yılmaz'), findsWidgets);

    await tester.tap(find.byKey(const Key('logout-button')));
    await tester.pumpAndSettle();

    expect(find.text('Hoş geldiniz'), findsOneWidget);
  });

  testWidgets('kayıt ol → otomatik giriş → profil', (tester) async {
    await tester.pumpWidget(buildApp());
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(const Key('goto-register-button')));
    await tester.pumpAndSettle();
    expect(find.text('Yeni çalışan hesabı oluşturun'), findsOneWidget);

    await tester.enterText(field('reg-name-input'), 'Ayşe');
    await tester.enterText(field('reg-surname-input'), 'Yılmaz');
    await tester.enterText(field('reg-email-input'), 'ayse@sirket.com');
    await tester.enterText(field('reg-password-input'), '123');
    await tester.tap(find.byKey(const Key('reg-submit-button')));
    await tester.pump();
    expect(find.text('Şifre en az 6 karakter olmalı'), findsOneWidget);

    await tester.enterText(field('reg-password-input'), 'Sifre123');
    await tester.tap(find.byKey(const Key('reg-submit-button')));
    await tester.pumpAndSettle();

    expect(find.byKey(const Key('profile-screen')), findsOneWidget);
  });
}
