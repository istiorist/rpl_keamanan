import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;

import '../config/app_config.dart';
import '../models/post.dart';
import '../models/user.dart';
import '../utils/logger.dart';

/// Exception dengan pesan yang aman ditampilkan kepada pengguna.
///
/// Detail teknis tidak pernah dimasukkan ke dalam [message]; detail
/// dicatat lewat [Logger] saja.
class ApiException implements Exception {
  final String message;
  const ApiException(this.message);

  @override
  String toString() => message;
}

/// Service untuk komunikasi HTTP dengan REST API.
///
/// Class ini menangani semua request HTTP ke API, termasuk
/// penanganan error dan timeout.
class ApiService {
  final http.Client _client;
  final String _baseUrl;

  ApiService({http.Client? client, String? baseUrl})
    : _client = client ?? http.Client(),
      _baseUrl = baseUrl ?? AppConfig.baseUrl;

  /// Mengambil daftar pengguna dari API.
  Future<List<User>> getUsers() {
    return _get<List<User>>(
      '/users',
      (json) => (json as List<dynamic>)
          .map((item) => User.fromJson(item as Map<String, dynamic>))
          .toList(),
      resource: 'data pengguna',
    );
  }

  /// Mengambil pengguna berdasarkan [id].
  Future<User> getUserById(int id) {
    return _get<User>(
      '/users/$id',
      (json) => User.fromJson(json as Map<String, dynamic>),
      resource: 'data pengguna',
    );
  }

  /// Mengambil daftar post dari API (/posts).
  Future<List<Post>> getPosts() {
    return _get<List<Post>>(
      '/posts',
      (json) => (json as List<dynamic>)
          .map((item) => Post.fromJson(item as Map<String, dynamic>))
          .toList(),
      resource: 'post',
    );
  }

  /// Melakukan request GET dan mengubah hasilnya dengan [parse].
  ///
  /// Semua error diubah menjadi [ApiException] dengan pesan yang ramah
  /// pengguna. Detail teknis hanya dicatat lewat [Logger].
  Future<T> _get<T>(
    String endpoint,
    T Function(dynamic json) parse, {
    String resource = 'data',
  }) async {
    try {
      _logRequest('GET', endpoint);
      final response = await _client
          .get(Uri.parse('$_baseUrl$endpoint'), headers: _buildHeaders())
          .timeout(Duration(seconds: AppConfig.timeoutSeconds));
      _logResponse(response.statusCode);

      if (response.statusCode != 200) {
        throw ApiException(
          'Gagal memuat $resource. Status: ${response.statusCode}',
        );
      }
      return parse(jsonDecode(response.body));
    } on ApiException {
      // Sudah berupa pesan aman; jangan dibungkus ulang.
      rethrow;
    } on TimeoutException {
      throw const ApiException(
        'Request timeout. Periksa koneksi internet Anda.',
      );
    } on SocketException {
      throw const ApiException(
        'Tidak ada koneksi internet. Periksa jaringan Anda.',
      );
    } on http.ClientException {
      // Pada platform web, gangguan jaringan muncul sebagai ClientException.
      throw const ApiException(
        'Tidak ada koneksi internet. Periksa jaringan Anda.',
      );
    } on FormatException {
      throw const ApiException('Format data tidak valid.');
    } catch (e) {
      // Detail teknis hanya masuk log, tidak ke pesan untuk pengguna.
      Logger.error('Request $endpoint gagal: $e');
      throw const ApiException('Terjadi kesalahan. Silakan coba lagi.');
    }
  }

  /// Membangun header untuk request HTTP.
  Map<String, String> _buildHeaders() {
    return {'Content-Type': 'application/json', 'X-API-Key': AppConfig.apiKey};
  }

  /// Logging request yang aman (tidak mencetak token/API key).
  void _logRequest(String method, String endpoint) {
    Logger.debug('[$method] $endpoint');
  }

  /// Logging response yang aman (hanya status code).
  void _logResponse(int statusCode) {
    Logger.debug('Response status: $statusCode');
  }

  /// Menutup client.
  void dispose() {
    _client.close();
  }
}
