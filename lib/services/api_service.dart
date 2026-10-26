import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;

import '../core/config.dart';
import 'token_storage.dart';

/// Backend'den dönen hata mesajını taşıyan istisna.
class ApiException implements Exception {
  ApiException(this.message, {this.statusCode});

  final String message;
  final int? statusCode;

  @override
  String toString() => message;
}

/// Backend ile konuşan istemci (React Native sürümündeki `src/api.ts`).
/// Her isteğe varsa `Authorization: Bearer <token>` başlığını ekler.
class ApiService {
  ApiService({TokenStorage? tokenStorage, http.Client? client})
      : _tokenStorage = tokenStorage ?? TokenStorage(),
        _client = client ?? http.Client();

  final TokenStorage _tokenStorage;
  final http.Client _client;

  static const _timeout = Duration(seconds: 30);

  Future<dynamic> get(String path) => _request('GET', path);

  Future<dynamic> post(String path, [Object? body]) =>
      _request('POST', path, body);

  Future<dynamic> _request(String method, String path, [Object? body]) async {
    final uri = Uri.parse('${AppConfig.apiBase}$path');
    final token = await _tokenStorage.read();

    final headers = <String, String>{
      'Content-Type': 'application/json',
      if (token != null && token.isNotEmpty) 'Authorization': 'Bearer $token',
    };

    http.Response res;
    try {
      final req = http.Request(method, uri)..headers.addAll(headers);
      if (body != null) req.body = jsonEncode(body);
      final streamed = await _client.send(req).timeout(_timeout);
      res = await http.Response.fromStream(streamed);
    } on SocketException {
      throw ApiException("Backend'e bağlanılamadı. Adres: $uri");
    } on TimeoutException {
      throw ApiException('Sunucu yanıt vermedi. Lütfen tekrar deneyin.');
    } on http.ClientException {
      throw ApiException("Backend'e bağlanılamadı. Adres: $uri");
    }

    final text = utf8.decode(res.bodyBytes);
    dynamic data;
    try {
      data = text.isEmpty ? null : jsonDecode(text);
    } catch (_) {
      data = text;
    }

    if (res.statusCode < 200 || res.statusCode >= 300) {
      Object? message;
      if (data is Map) message = data['detail'] ?? data['message'];
      message ??= 'İstek başarısız (${res.statusCode})';
      throw ApiException(
        message is String ? message : jsonEncode(message),
        statusCode: res.statusCode,
      );
    }

    return data;
  }
}
