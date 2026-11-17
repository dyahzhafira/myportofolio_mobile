import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:myportofolio_mobile/main.dart';

void main() {
  testWidgets('menampilkan identitas dan tombol menu', (tester) async {
    await tester.pumpWidget(const MyApp());

    expect(find.text('2506623723'), findsOneWidget);
    expect(find.text('Dyah Zhafira'), findsOneWidget);
    expect(find.text('PBP E'), findsOneWidget);
    expect(find.text('Lihat Project'), findsOneWidget);
    expect(find.text('Tambah Project'), findsOneWidget);
    expect(find.text('Logout'), findsOneWidget);
  });

  testWidgets('menekan tombol memunculkan SnackBar', (tester) async {
    await tester.pumpWidget(const MyApp());

    await tester.tap(find.text('Tambah Project'));
    await tester.pump();

    expect(
      find.text('Kamu telah menekan tombol Tambah Project!'),
      findsOneWidget,
    );
  });

  testWidgets('menekan Logout membuka dialog konfirmasi', (tester) async {
    await tester.pumpWidget(const MyApp());

    await tester.ensureVisible(find.text('Logout'));
    await tester.tap(find.text('Logout'));
    await tester.pumpAndSettle();

    expect(find.text('Yakin mau keluar dari MyPortfolio?'), findsOneWidget);

    await tester.tap(find.text('Batal'));
    await tester.pumpAndSettle();

    expect(find.text('Yakin mau keluar dari MyPortfolio?'), findsNothing);
  });

  testWidgets('menekan Keluar menutup dialog dan menampilkan SnackBar', (
    tester,
  ) async {
    await tester.pumpWidget(const MyApp());

    await tester.ensureVisible(find.text('Logout'));
    await tester.tap(find.text('Logout'));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Keluar'));
    await tester.pumpAndSettle();

    expect(find.text('Yakin mau keluar dari MyPortfolio?'), findsNothing);
    expect(find.text('Kamu telah keluar dari MyPortfolio'), findsOneWidget);
  });

  testWidgets('drawer membuka form lalu kembali ke Home', (tester) async {
    await tester.pumpWidget(const MyApp());

    await tester.tap(find.byTooltip('Open navigation menu'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Add Project'));
    await tester.pumpAndSettle();
    expect(find.text('Add Project Form'), findsOneWidget);

    await tester.tap(find.byTooltip('Open navigation menu'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Home'));
    await tester.pumpAndSettle();
    expect(find.text('Selamat datang di MyPortfolio Mobile!'), findsOneWidget);
  });

  testWidgets('tombol Tambah Project membuka form', (tester) async {
    await tester.pumpWidget(const MyApp());

    await tester.tap(find.text('Tambah Project'));
    await tester.pumpAndSettle();

    expect(find.text('Add Project Form'), findsOneWidget);
  });

  testWidgets('form menolak input kosong', (tester) async {
    await tester.pumpWidget(const MyApp());
    await tester.tap(find.text('Tambah Project'));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Save'));
    await tester.pumpAndSettle();

    expect(find.text('Nama proyek tidak boleh kosong!'), findsOneWidget);
    expect(find.text('Deskripsi proyek tidak boleh kosong!'), findsOneWidget);
    expect(find.text('Proyek berhasil ditambahkan!'), findsNothing);
  });

  testWidgets('form valid menampilkan dialog berisi data', (tester) async {
    await tester.pumpWidget(const MyApp());
    await tester.tap(find.text('Tambah Project'));
    await tester.pumpAndSettle();

    await tester.enterText(
      find.widgetWithText(TextFormField, 'Nama Proyek'),
      'MyPortfolio',
    );
    await tester.enterText(
      find.widgetWithText(TextFormField, 'Deskripsi Proyek'),
      'Aplikasi portofolio',
    );
    await tester.tap(find.text('Save'));
    await tester.pumpAndSettle();

    expect(find.text('Proyek berhasil ditambahkan!'), findsOneWidget);
    expect(find.text('Nama Proyek: MyPortfolio'), findsOneWidget);

    await tester.tap(find.text('OK'));
    await tester.pumpAndSettle();
    expect(find.text('Proyek berhasil ditambahkan!'), findsNothing);
  });

  testWidgets('drawer membuka form experience', (tester) async {
    await tester.pumpWidget(const MyApp());

    await tester.tap(find.byTooltip('Open navigation menu'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Add Experience'));
    await tester.pumpAndSettle();

    expect(find.text('Add Experience Form'), findsOneWidget);
  });

  testWidgets('form experience menolak input kosong', (tester) async {
    await tester.pumpWidget(const MyApp());
    await tester.ensureVisible(find.text('Tambah Experience'));
    await tester.tap(find.text('Tambah Experience'));
    await tester.pumpAndSettle();

    await tester.ensureVisible(find.text('Simpan'));
    await tester.tap(find.text('Simpan'));
    await tester.pumpAndSettle();

    expect(find.text('Judul tidak boleh kosong!'), findsOneWidget);
    expect(find.text('Tanggal mulai harus dipilih!'), findsOneWidget);
    expect(find.text('Tanggal selesai harus dipilih!'), findsOneWidget);
    expect(find.text('Experience berhasil ditambahkan!'), findsNothing);
  });

  testWidgets('form experience valid menampilkan dialog ringkasan', (
    tester,
  ) async {
    await tester.pumpWidget(const MyApp());
    await tester.ensureVisible(find.text('Tambah Experience'));
    await tester.tap(find.text('Tambah Experience'));
    await tester.pumpAndSettle();

    await tester.enterText(
      find.widgetWithText(TextFormField, 'Judul'),
      'Intern',
    );
    await tester.enterText(
      find.widgetWithText(TextFormField, 'Deskripsi'),
      'Membuat aplikasi',
    );
    await tester.tap(find.widgetWithText(TextFormField, 'Tanggal Mulai'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('OK'));
    await tester.pumpAndSettle();
    await tester.ensureVisible(find.text('Masih bekerja di sini'));
    await tester.tap(find.text('Masih bekerja di sini'));
    await tester.pumpAndSettle();

    await tester.ensureVisible(find.text('Simpan'));
    await tester.tap(find.text('Simpan'));
    await tester.pumpAndSettle();

    expect(find.text('Experience berhasil ditambahkan!'), findsOneWidget);
    expect(find.text('Judul: Intern'), findsOneWidget);
    expect(find.text('Selesai: Sekarang'), findsOneWidget);
  });

  testWidgets('form experience menolak tautan tanpa http', (tester) async {
    await tester.pumpWidget(const MyApp());
    await tester.ensureVisible(find.text('Tambah Experience'));
    await tester.tap(find.text('Tambah Experience'));
    await tester.pumpAndSettle();

    await tester.enterText(
      find.widgetWithText(TextFormField, 'Thumbnail URL (opsional)'),
      'bukan-url',
    );
    await tester.ensureVisible(find.text('Simpan'));
    await tester.tap(find.text('Simpan'));
    await tester.pumpAndSettle();

    expect(
      find.text('URL harus diawali http:// atau https://'),
      findsOneWidget,
    );
  });

  testWidgets('SnackBar tidak menutupi form setelah pindah halaman', (
    tester,
  ) async {
    await tester.pumpWidget(const MyApp());
    await tester.ensureVisible(find.text('Tambah Experience'));
    await tester.tap(find.text('Tambah Experience'));
    await tester.pumpAndSettle();

    expect(find.text('Add Experience Form'), findsOneWidget);
    expect(find.textContaining('Kamu telah menekan'), findsNothing);
  });
}
