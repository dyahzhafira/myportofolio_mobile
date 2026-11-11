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
}
