import 'package:flutter/foundation.dart';

/// Level log yang didukung oleh Logger terstruktur.
enum LogLevel { debug, info, warning, error }

class Logger {
  /// Pola regex untuk mendeteksi dan menyensor data sensitif sebelum dicatat.
  static final List<RegExp> _sensitivePatterns = [
    // Menyensor nilai setelah kata kunci sensitif (contoh: password=123, "token": "abc", apiKey: xyz)
    RegExp(
      r'(["\x27]?(?:password|passwd|pwd|token|access_token|refresh_token|secret|api_key|apikey|authorization|pin|cvv|credit_card)["\x27]?\s*[:=]\s*["\x27]?)([^"\x27,\s\}]+)',
      caseSensitive: false,
    ),
    // Menyensor Bearer token di header HTTP
    RegExp(r'(Bearer\s+)[A-Za-z0-9\-._~+/]+=*', caseSensitive: false),
    // Menyensor alamat email agar PII (Personally Identifiable Information) tidak bocor
    RegExp(r'[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}'),
  ];

  /// Menyensor data sensitif dari teks log sebelum ditampilkan.
  static String _sanitize(String input) {
    var sanitized = input;
    for (final pattern in _sensitivePatterns) {
      sanitized = sanitized.replaceAllMapped(pattern, (match) {
        if (match.groupCount >= 2 && match.group(1) != null) {
          return '${match.group(1)}***REDACTED***';
        }
        return '***REDACTED***';
      });
    }
    return sanitized;
  }

  /// Mencatat pesan untuk keperluan debugging pengembangan.
  static void debug(String message, {String? tag}) {
    _log(LogLevel.debug, message, tag: tag);
  }

  /// Mencatat informasi umum alur aplikasi.
  static void info(String message, {String? tag}) {
    _log(LogLevel.info, message, tag: tag);
  }

  /// Mencatat peringatan (kondisi tidak ideal namun aplikasi tetap berjalan).
  static void warning(String message, {String? tag}) {
    _log(LogLevel.warning, message, tag: tag);
  }

  /// Mencatat kesalahan/error beserta detail exception atau stackTrace jika ada.
  static void error(
    String message, {
    String? tag,
    Object? error,
    StackTrace? stackTrace,
  }) {
    _log(
      LogLevel.error,
      message,
      tag: tag,
      error: error,
      stackTrace: stackTrace,
    );
  }

  /// Method internal untuk memformat dan mencetak log.
  /// Log hanya dicetak apabila aplikasi berjalan dalam mode debug ([kDebugMode])
  /// serta telah disaring dari data sensitif.
  static void _log(
    LogLevel level,
    String message, {
    String? tag,
    Object? error,
    StackTrace? stackTrace,
  }) {
    // Abaikan seluruh pencatatan log jika bukan mode debug
    if (!kDebugMode) return;

    final timestamp = DateTime.now().toIso8601String();
    final levelLabel = level.name.toUpperCase();
    final tagLabel = tag != null ? '[$tag] ' : '';

    // Pastikan pesan maupun detail error sudah disensor dari data sensitif
    final safeMessage = _sanitize(message);

    debugPrint('[$timestamp] [$levelLabel] $tagLabel$safeMessage');

    if (error != null) {
      debugPrint('  Error: ${_sanitize(error.toString())}');
    }
    if (stackTrace != null) {
      debugPrint('  StackTrace: $stackTrace');
    }
  }
}

// sampai sini dulu
