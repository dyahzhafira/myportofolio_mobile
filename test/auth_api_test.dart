import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';

import 'test_app.dart';

Future<void> fillProjectForm(WidgetTester tester) async {
  await tester.enterText(find.widgetWithText(TextFormField, 'Title'), 'Baru');
  await tester.enterText(
    find.widgetWithText(TextFormField, 'Description'),
    'Deskripsi baru',
  );
  await tester.ensureVisible(find.text('Save'));
  await tester.tap(find.text('Save'));
  await tester.pumpAndSettle();
}

void main() {
  group('login dan route guard', () {
    testWidgets('Tambah Project mengarah ke login kalau belum login', (
      tester,
    ) async {
      await tester.pumpWidget(buildApp(token: null));

      await tester.tap(find.text('Tambah Project'));
      await tester.pumpAndSettle();

      expect(find.widgetWithText(ElevatedButton, 'Login'), findsOneWidget);
      expect(find.text('Add Project Form'), findsNothing);
    });

    testWidgets('login berhasil membuka form project', (tester) async {
      await tester.pumpWidget(buildApp(token: null));
      await tester.tap(find.text('Tambah Project'));
      await tester.pumpAndSettle();

      await tester.enterText(
        find.widgetWithText(TextFormField, 'Username'),
        'dyah',
      );
      await tester.enterText(
        find.widgetWithText(TextFormField, 'Password'),
        'benar',
      );
      await tester.tap(find.widgetWithText(ElevatedButton, 'Login'));
      await tester.pumpAndSettle();

      expect(find.text('Add Project Form'), findsOneWidget);
    });

    testWidgets('password salah menampilkan SnackBar dan tetap di login', (
      tester,
    ) async {
      await tester.pumpWidget(buildApp(token: null));
      await tester.tap(find.text('Tambah Project'));
      await tester.pumpAndSettle();

      await tester.enterText(
        find.widgetWithText(TextFormField, 'Username'),
        'dyah',
      );
      await tester.enterText(
        find.widgetWithText(TextFormField, 'Password'),
        'salah',
      );
      await tester.tap(find.widgetWithText(ElevatedButton, 'Login'));
      await tester.pumpAndSettle();

      expect(find.text('Username atau password salah (400)'), findsOneWidget);
      expect(find.widgetWithText(ElevatedButton, 'Login'), findsOneWidget);
    });

    testWidgets('login menolak username dan password kosong', (tester) async {
      await tester.pumpWidget(buildApp(token: null));
      await tester.tap(find.text('Tambah Project'));
      await tester.pumpAndSettle();

      await tester.tap(find.widgetWithText(ElevatedButton, 'Login'));
      await tester.pumpAndSettle();

      expect(find.text('Username tidak boleh kosong!'), findsOneWidget);
      expect(find.text('Password tidak boleh kosong!'), findsOneWidget);
    });

    testWidgets('drawer menampilkan Login kalau belum login', (tester) async {
      await tester.pumpWidget(buildApp(token: null));
      await tester.tap(find.byTooltip('Open navigation menu'));
      await tester.pumpAndSettle();

      expect(find.widgetWithText(ListTile, 'Login'), findsOneWidget);
      expect(find.widgetWithText(ListTile, 'Logout'), findsNothing);
    });

    testWidgets('drawer menampilkan Logout kalau sudah login', (tester) async {
      await tester.pumpWidget(buildApp());
      await tester.tap(find.byTooltip('Open navigation menu'));
      await tester.pumpAndSettle();

      expect(find.widgetWithText(ListTile, 'Logout'), findsOneWidget);
      expect(find.widgetWithText(ListTile, 'Login'), findsNothing);
    });
  });

  group('daftar dan detail project', () {
    testWidgets('menampilkan data dari backend tanpa login', (tester) async {
      await tester.pumpWidget(buildApp(token: null));

      await tester.tap(find.text('Lihat Project'));
      await tester.pumpAndSettle();

      expect(find.text('MyPortfolio'), findsOneWidget);
      expect(find.textContaining('Django, Flutter'), findsOneWidget);
    });

    testWidgets('mengetuk project membuka detail', (tester) async {
      await tester.pumpWidget(buildApp(token: null));
      await tester.tap(find.text('Lihat Project'));
      await tester.pumpAndSettle();

      await tester.tap(find.text('MyPortfolio'));
      await tester.pumpAndSettle();

      expect(find.text('Website portofolio'), findsOneWidget);
      expect(find.text('Django, Flutter'), findsOneWidget);
      expect(find.byType(Image), findsNothing);
    });

    testWidgets('tech_stack berisi objek name dan icon terbaca', (
      tester,
    ) async {
      final projects = [
        {
          'id': '22222222-2222-2222-2222-222222222222',
          'title': 'SignD',
          'description': 'Disaster response',
          'status': 'progress',
          'project_type': 'group',
          'tech_stack': [
            {'name': 'Flutter', 'icon': 'flutter'},
            {'name': 'Go/Fiber', 'icon': 'go'},
          ],
          'project_url': '',
          'project_image_url': '',
        },
      ];
      await tester.pumpWidget(
        buildApp(client: fakeBackend(projects: projects)),
      );
      await tester.tap(find.text('Lihat Project'));
      await tester.pumpAndSettle();

      expect(find.text('SignD'), findsOneWidget);
      expect(find.textContaining('Flutter, Go/Fiber'), findsOneWidget);
    });

    testWidgets('list kosong menampilkan pesan', (tester) async {
      await tester.pumpWidget(buildApp(client: fakeBackend(projects: [])));
      await tester.tap(find.text('Lihat Project'));
      await tester.pumpAndSettle();

      expect(find.text('Belum ada project.'), findsOneWidget);
    });

    testWidgets('error server menampilkan tombol coba lagi', (tester) async {
      final client = MockClient((_) async => http.Response('boom', 500));
      await tester.pumpWidget(buildApp(client: client));
      await tester.tap(find.text('Lihat Project'));
      await tester.pumpAndSettle();

      expect(find.textContaining('Gagal memuat project'), findsOneWidget);
      expect(find.text('Coba lagi'), findsOneWidget);
    });
  });

  group('POST project', () {
    testWidgets('mengirim data dengan header token dan field backend', (
      tester,
    ) async {
      final log = <http.Request>[];
      await tester.pumpWidget(buildApp(client: fakeBackend(log: log)));
      await tester.tap(find.text('Tambah Project'));
      await tester.pumpAndSettle();

      await fillProjectForm(tester);

      final post = log.firstWhere((r) => r.method == 'POST');
      expect(post.headers['Authorization'], 'Token token');
      final body = jsonDecode(post.body) as Map<String, dynamic>;
      expect(body['title'], 'Baru');
      expect(body['status'], 'progress');
      expect(body['project_type'], 'individual');
      expect(body.containsKey('id'), isFalse);
      expect(find.text('Proyek berhasil ditambahkan!'), findsOneWidget);
    });

    testWidgets('401 membuat logout dan meminta login ulang', (tester) async {
      await tester.pumpWidget(
        buildApp(client: fakeBackend(projectPostStatus: 401)),
      );
      await tester.tap(find.text('Tambah Project'));
      await tester.pumpAndSettle();

      await fillProjectForm(tester);

      expect(find.text('Sesi berakhir, silakan login ulang'), findsOneWidget);
      expect(find.widgetWithText(ElevatedButton, 'Login'), findsOneWidget);
    });

    testWidgets('error selain 401 menampilkan SnackBar dengan kode', (
      tester,
    ) async {
      await tester.pumpWidget(
        buildApp(client: fakeBackend(projectPostStatus: 400)),
      );
      await tester.tap(find.text('Tambah Project'));
      await tester.pumpAndSettle();

      await fillProjectForm(tester);

      expect(find.text('Gagal menyimpan project (400)'), findsOneWidget);
      expect(find.text('Proyek berhasil ditambahkan!'), findsNothing);
    });

    testWidgets('URL tanpa http ditolak', (tester) async {
      await tester.pumpWidget(buildApp());
      await tester.tap(find.text('Tambah Project'));
      await tester.pumpAndSettle();

      await tester.enterText(
        find.widgetWithText(TextFormField, 'Project URL (opsional)'),
        'bukan-url',
      );
      await tester.ensureVisible(find.text('Save'));
      await tester.tap(find.text('Save'));
      await tester.pumpAndSettle();

      expect(
        find.text('Project URL harus diawali http:// atau https://'),
        findsOneWidget,
      );
    });
  });
}
