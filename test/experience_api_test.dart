import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:myportofolio_mobile/models/experience.dart';
import 'package:myportofolio_mobile/services/api_client.dart';

import 'test_app.dart';

void main() {
  final experience = Experience(
    title: 'Intern',
    description: 'Membuat aplikasi',
    category: 'internship',
    startedAt: DateTime.utc(2026, 1, 5, 12),
  );

  test('createExperience mengirim token dan payload yang benar', () async {
    final log = <http.Request>[];
    final api = ApiClient(client: fakeBackend(log: log));

    await api.createExperience(experience, token: 'abc');

    final request = log.single;
    expect(request.url.path, '/api/v1/experiences/');
    expect(request.headers['Authorization'], 'Token abc');
    final body = jsonDecode(request.body) as Map<String, dynamic>;
    expect(body['started_at'], '2026-01-05T12:00:00.000Z');
    expect(body.containsKey('id'), isFalse);
  });

  test('createExperience melempar ApiException saat 401', () {
    final api = ApiClient(client: fakeBackend(experiencePostStatus: 401));

    expect(
      api.createExperience(experience, token: 'abc'),
      throwsA(
        isA<ApiException>().having((e) => e.statusCode, 'statusCode', 401),
      ),
    );
  });

  testWidgets('Lihat Experience membuka daftar dan menampilkan data', (
    tester,
  ) async {
    final client = MockClient((request) async {
      return http.Response(
        jsonEncode([
          {
            'id': '33333333-3333-3333-3333-333333333333',
            'title': 'Asdos PBP',
            'description': 'Membantu mahasiswa',
            'category': 'part-time',
            'category_display': 'Part-Time',
            'thumbnail': '',
            'started_at': '2026-01-05T12:00:00Z',
            'ended_at': null,
            'is_ongoing': true,
          },
        ]),
        200,
      );
    });
    await tester.pumpWidget(buildApp(client: client, token: null));

    await tester.ensureVisible(find.text('Lihat Experience'));
    await tester.tap(find.text('Lihat Experience'));
    await tester.pumpAndSettle();

    expect(find.text('Asdos PBP'), findsOneWidget);
    expect(find.textContaining('Sekarang'), findsOneWidget);

    await tester.tap(find.text('Asdos PBP'));
    await tester.pumpAndSettle();
    expect(find.text('Membantu mahasiswa'), findsOneWidget);
  });

  testWidgets('daftar experience kosong menampilkan pesan', (tester) async {
    await tester.pumpWidget(buildApp(token: null));

    await tester.ensureVisible(find.text('Lihat Experience'));
    await tester.tap(find.text('Lihat Experience'));
    await tester.pumpAndSettle();

    expect(find.text('Belum ada experience.'), findsOneWidget);
  });

  testWidgets('form experience mengirim POST dan menampilkan dialog', (
    tester,
  ) async {
    final log = <http.Request>[];
    await tester.pumpWidget(buildApp(client: fakeBackend(log: log)));

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
    await tester.ensureVisible(find.text('Save'));
    await tester.tap(find.text('Save'));
    await tester.pumpAndSettle();

    final post = log.firstWhere((r) => r.method == 'POST');
    final body = jsonDecode(post.body) as Map<String, dynamic>;
    expect(post.url.path, '/api/v1/experiences/');
    expect(post.headers['Authorization'], 'Token token');
    expect(body['category'], 'full-time');
    expect(body['ended_at'], isNull);
    expect(find.text('Experience berhasil ditambahkan!'), findsOneWidget);
  });

  testWidgets('POST experience 401 meminta login ulang', (tester) async {
    await tester.pumpWidget(
      buildApp(client: fakeBackend(experiencePostStatus: 401)),
    );

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
    await tester.ensureVisible(find.text('Save'));
    await tester.tap(find.text('Save'));
    await tester.pumpAndSettle();

    expect(find.text('Sesi berakhir, silakan login ulang'), findsOneWidget);
    expect(find.widgetWithText(ElevatedButton, 'Login'), findsOneWidget);
  });
}
