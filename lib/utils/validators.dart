class Validators {
  /// Memvalidasi field wajib diisi
  static String? validateRequired(String? value, String fieldName) {
    if (value == null || value.trim().isEmpty) {
      return '$fieldName tidak boleh kosong';
    }
    return null;
  }

  /// Memvalidasi format email (mengembalikan pesan error atau null)
  static String? validateEmail(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Email tidak boleh kosong';
    }
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(value.trim())) {
      return 'Format email tidak valid';
    }
    return null;
  }

  /// Latihan 3a) Memvalidasi nomor telepon:
  /// - Tidak boleh kosong
  /// - Hanya boleh berisi angka (0-9)
  /// - Panjang antara 10 hingga 13 digit
  static String? validatePhone(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Nomor telepon tidak boleh kosong';
    }

    final trimmed = value.trim();
    final phoneRegex = RegExp(r'^[0-9]{10,13}$');

    if (!phoneRegex.hasMatch(trimmed)) {
      return 'Nomor telepon harus berupa 10-13 digit angka';
    }

    return null;
  }

  /// Latihan 3b) Memvalidasi format URL:
  /// - Tidak boleh kosong
  /// - Harus diawali dengan http:// atau https://
  /// - Memiliki nama domain yang valid tanpa spasi
  static String? validateUrl(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'URL tidak boleh kosong';
    }

    final trimmed = value.trim();
    final urlRegex = RegExp(
      r'^https?:\/\/(www\.)?[-a-zA-Z0-9@:%._\+~#=]{1,256}\.[a-zA-Z0-9()]{1,6}\b([-a-zA-Z0-9()@:%_\+.~#?&//=]*)$',
      caseSensitive: false,
    );

    if (!urlRegex.hasMatch(trimmed)) {
      return 'URL harus valid dan dimulai dengan http:// atau https://';
    }

    return null;
  }

  /// Latihan 3c) Memvalidasi kekuatan password:
  /// - Tidak boleh kosong
  /// - Minimal 8 karakter
  /// - Mengandung minimal satu huruf kapital (A-Z)
  /// - Mengandung minimal satu angka (0-9)
  /// - Mengandung minimal satu simbol/karakter spesial
  static String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password tidak boleh kosong';
    }

    if (value.length < 8) {
      return 'Password minimal 8 karakter';
    }

    if (!RegExp(r'[A-Z]').hasMatch(value)) {
      return 'Password harus mengandung minimal 1 huruf kapital';
    }

    if (!RegExp(r'[0-9]').hasMatch(value)) {
      return 'Password harus mengandung minimal 1 angka';
    }

    if (!RegExp(r'[!@#\$%^&*(),.?":{}|<>_\-+=\[\]\\\/~`]').hasMatch(value)) {
      return 'Password harus mengandung minimal 1 simbol';
    }

    return null;
  }

  /// Latihan 5a) Mengecek apakah format email valid (mengembalikan bool)
  static bool isValidEmail(String? value) {
    return validateEmail(value) == null;
  }

  /// Latihan 5b) Membersihkan karakter HTML/script berbahaya (mencegah XSS)
  static String sanitize(String input) {
    return input
        .replaceAll(
          RegExp(
            r'<script[^>]*>.*?</script>',
            caseSensitive: false,
            dotAll: true,
          ),
          '',
        )
        .replaceAll('<', '&lt;')
        .replaceAll('>', '&gt;')
        .replaceAll('"', '&quot;')
        .replaceAll("'", '&#x27;')
        .trim();
  }

  /// Latihan 5c) Memvalidasi teks berdasarkan panjang minimal dan maksimal
  static String? validateText(
    String? value, {
    String fieldName = 'Teks',
    int minLength = 3,
    int maxLength = 100,
  }) {
    if (value == null || value.trim().isEmpty) {
      return '$fieldName tidak boleh kosong';
    }
    final trimmed = value.trim();
    if (trimmed.length < minLength) {
      return '$fieldName minimal $minLength karakter';
    }
    if (trimmed.length > maxLength) {
      return '$fieldName maksimal $maxLength karakter';
    }
    return null;
  }
}
