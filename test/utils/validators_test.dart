import 'package:flutter_test/flutter_test.dart';
import 'package:rpl_keamanan/utils/validators.dart';

void main() {
  group('Validators - isValidEmail() (Poin a)', () {
    test('mengembalikan true untuk format email yang valid', () {
      expect(Validators.isValidEmail('user@example.com'), isTrue);
      expect(Validators.isValidEmail('mahasiswa.ti@kampus.ac.id'), isTrue);
      expect(Validators.isValidEmail('  admin@domain.co.id  '), isTrue);
    });

    test('mengembalikan false untuk format email yang tidak valid', () {
      expect(Validators.isValidEmail('userexample.com'), isFalse);
      expect(Validators.isValidEmail('user@'), isFalse);
      expect(Validators.isValidEmail('@example.com'), isFalse);
      expect(Validators.isValidEmail('user@domain'), isFalse);
      expect(Validators.isValidEmail('user name@example.com'), isFalse);
    });

    test('mengembalikan false jika email kosong atau null', () {
      expect(Validators.isValidEmail(''), isFalse);
      expect(Validators.isValidEmail('   '), isFalse);
      expect(Validators.isValidEmail(null), isFalse);
    });
  });

  group('Validators - sanitize() (Poin b)', () {
    test('menghapus tag <script> berbahaya (XSS)', () {
      const malicious = 'Halo <script>alert("XSS")</script> Dunia';
      expect(Validators.sanitize(malicious), equals('Halo  Dunia'));
    });

    test('meng-escape tag HTML berbahaya seperti <img> dan <iframe>', () {
      const imgPayload = '<img src=x onerror="alert(1)">';
      expect(
        Validators.sanitize(imgPayload),
        equals('&lt;img src=x onerror=&quot;alert(1)&quot;&gt;'),
      );
    });

    test('meng-escape karakter khusus HTML (<, >, ", \')', () {
      const specialChars = '<div class="user">\'Admin\' & Guest</div>';
      expect(
        Validators.sanitize(specialChars),
        equals(
          '&lt;div class=&quot;user&quot;&gt;&#x27;Admin&#x27; & Guest&lt;/div&gt;',
        ),
      );
    });

    test('membiarkan teks normal tetap utuh setelah di-trim', () {
      const safeInput = '  Budi Santoso 123  ';
      expect(Validators.sanitize(safeInput), equals('Budi Santoso 123'));
    });
  });

  group('Validators - validateText() (Poin c)', () {
    test(
      'mengembalikan pesan error jika teks kosong, hanya spasi, atau null',
      () {
        expect(
          Validators.validateText(null, fieldName: 'Nama'),
          equals('Nama tidak boleh kosong'),
        );
        expect(
          Validators.validateText('', fieldName: 'Nama'),
          equals('Nama tidak boleh kosong'),
        );
        expect(
          Validators.validateText('   ', fieldName: 'Nama'),
          equals('Nama tidak boleh kosong'),
        );
      },
    );

    test(
      'mengembalikan pesan error jika panjang teks kurang dari minLength',
      () {
        expect(
          Validators.validateText('Ab', fieldName: 'Username', minLength: 3),
          equals('Username minimal 3 karakter'),
        );
        expect(
          Validators.validateText(
            'Halo',
            fieldName: 'Deskripsi',
            minLength: 10,
          ),
          equals('Deskripsi minimal 10 karakter'),
        );
      },
    );

    test('mengembalikan null jika panjang teks valid (batas min, normal, batas max)', () {
      // Tepat batas minimum (3 karakter)
      expect(
        Validators.validateText('Adi', minLength: 3, maxLength: 20),
        isNull,
      );
      // Panjang normal di tengah rentang
      expect(
        Validators.validateText('Budi Santoso', minLength: 3, maxLength: 20),
        isNull,
      );
      // Tepat batas maksimum (10 karakter)
      expect(
        Validators.validateText('1234567890', minLength: 3, maxLength: 10),
        isNull,
      );
    });

    test('mengembalikan pesan error jika panjang teks melebihi maxLength', () {
      expect(
        Validators.validateText(
          'Teks ini terlalu panjang',
          fieldName: 'Judul',
          maxLength: 10,
        ),
        equals('Judul maksimal 10 karakter'),
      );
    });
  });
}
