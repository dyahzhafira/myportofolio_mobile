# MyPortfolio Mobile

Nama  : Dyah Zhafira Wibowo
NPM   : 2506623723
Kelas : PBP E

### Deskripsi Proyek

Mobile app untuk portfolio berbasis Flutter, klien mobile untuk website portofolio Django ([myportofolio](https://github.com/dyahzhafira/myportofolio)). Saat ini baru halaman menu utama: kartu identitas dan menu aksi portofolio. Belum terhubung ke API Django.

### Setup Lokal

1. Pasang Flutter SDK (dikembangkan dengan Flutter 3.44.8, Dart 3.12.2).
2. Clone repo dan masuk ke foldernya.
3. Unduh dependensi: `flutter pub get`.
4. Jalankan di Chrome: `flutter run -d chrome` (atau `flutter run` untuk emulator Android).
5. Analisis kode: `flutter analyze`.
6. Jalankan test: `flutter test`.

### Struktur Proyek

| Berkas | Isi |
|---|---|
| `lib/main.dart` | Bootstrap aplikasi, `MaterialApp` dan tema (indigo, secondary amber) |
| `lib/menu.dart` | `MyHomePage` (Stateless), `InfoCard`, `ItemHomepage`, `ItemCard`, `showLogoutDialog` |
| `test/widget_test.dart` | Widget test halaman menu |

### Progres Mingguan

- Tutorial 08: setup Flutter, proyek `myportofolio_mobile`, pemisahan `menu.dart`, `MyHomePage` Stateless, `InfoCard`, `ItemCard`, `SnackBar`.
- Tugas 7: identitas sendiri pada `InfoCard`, warna latar berbeda per tombol lewat field `color` di `ItemHomepage`, tombol Lihat Project, Lihat Experience, Tambah Project, dan Logout.

### Fitur Menu

| Tombol | Ikon | Warna |
|---|---|---|
| Lihat Project | folder | biru |
| Lihat Experience | work | ungu |
| Tambah Project | add_circle | hijau |
| Logout | logout | merah |

Tiap tombol memunculkan SnackBar "Kamu telah menekan tombol [Nama]!".

#### FITUR TAMBAHAN (Tugas 7)

- Dialog konfirmasi Logout (Batal atau Keluar). Belum ada sesi login, jadi "Keluar" hanya menutup dialog.
- Halaman dapat di-scroll supaya tidak overflow di layar pendek.
- Tombol Lihat Experience untuk bagian portofolio dari Tugas 3 sampai 6.
- Widget test untuk identitas, SnackBar, dan dialog Logout.

### Tugas 7
1. Jelaskan apa yang dimaksud dengan widget tree pada Flutter dan bagaimana hubungan induk-anak (parent-child) bekerja antar-widget!
Widget tree itu susunan widget bentuk pohon dan seluruh UI Flutter dari situ. Tiap widget bisa memiliki 1 parent dan bisa punya 1 atau lebih child. Parent menentukan batas ukuran dan posisi child, sedangkan child nerima batasan itu dan menentukan ukurannya sendiri. Root project ini MaterialApp, lalu MyHomePage, Scaffold, AppBar, dan SingleChildScrollView, lalu Column dengan Row (3 InfoCard) dan GridView (ItemCard). Karena data dan konfigurasi dari parent ke child, sehingga ubah 1 widget cukup bangun ulang subtree bawahnya. Contohnya Theme.of(context) di ItemCard ambil data theme dari widget di atasnya. 

2. Sebutkan semua widget yang kamu gunakan dalam proyek ini dan jelaskan fungsinya masing-masing!
- MaterialApp: root app untuk setting theme & page awal
- Scaffold: Kerangka page (AppBar, Body, SnackBar place)
- AppBar: Bar title di atas
- SingleChildScrollView: create page bisa di scroll agar tidak overflow
- Padding: jarak di widget
- Column & Row: susun child vertikal & horizontal
- Center: agar child di tengah
- SizedBox: jarak kosong
- GridView.count: grid untuk tombol 3 kolom
- Card: card untuk InfoCard
- Container: kotak untuk size & padding
- Material: permukaan untuk ItemCard
- InkWell: area yang bisa ditekan dan efek ripple
- Icon & Text: ikon dan teks
- SnackBar: notif bawah layar
- AlertDialog, TextButton, FilledButton: dialog confirm logout
- Widget tambahan: MyHomePage, InfoCard, ItemCard

3. Apa fungsi dari widget MaterialApp? Jelaskan mengapa widget ini umumnya digunakan sebagai root widget pada aplikasi Flutter!
MaterialApp wrap aplikasi dan menyiapkan base nya, seperti tema Material (ThemeData), halaman awal (home), judul aplikasi, navigasi(Navigator), dan ScaffoldMessenger untuk SnackBar. Oleh karena itu widget seperti Scaffold dan Theme.of(context) baru berfungsi kalau ada MaterialApp. Karena semuanya perlu tersedia untuk seluruh halaman dan MaterialApp jadi root.

4. Jelaskan perbedaan antara StatelessWidget dan StatefulWidget! Kapan kita sebaiknya memilih StatelessWidget dan kapan harus menggunakan StatefulWidget?
StatelessWidget tidak simpan state yang berubah, jadi tampilannya hanya bergantung ke data yang dikirim waktu create. StatefulWidget punya objek State yang bisa berubah dan setState() agar widget di recreate. Stateless untuk tampilan yang statis, seperti MyHomePage, InfoCard, dan ItemCard kalau untuk projek ini. Stateful untuk tampila dengan data yang berubah saat digunakan, contoh isi form.

5. Apa itu BuildContext dan mengapa penting di Flutter? Bagaimana penggunaannya di dalam metode build?
BuildContext adalah penanda posisi widget di widget tree. Lewat context, widget nantinya bisa ambil hal yang disediakan dari widget di atasnya. Di build(BuildContext context) saya menggunakannya untuk Theme.of(context) (warna tema), MediaQuery.of(context) (lebar layar untuk InfoCard), dan ScaffoldMessenger.of(context) (show SnackBar). Di showLogoutDialog, context dipakai untuk showDialog, dan Navigator.of(dialogContent) untuk close dialog.

6. Jelaskan konsep hot reload di Flutter dan apa perbedaannya dengan hot restart! Kapan kita tidak bisa hanya mengandalkan hot reload dan harus melakukan hot restart atau full restart?
Hot reload inject code baru ke app yang sedang jalan dan recreate widget dengan state yang tetap terjaga dan biasanya selesai di hitungan detik. Hot restart itu restart app dari awal, sehingga state hilang tapi lebih cepat dari full restart. Hot reload perlu hot restart atau full restart ketika perubahannya berkaitan dengan hal yang hanya dibaca saat startup, seperti main(), nilai awal variabel final atau static, atau state yang sudah terbentuk. Full restart (stop lalu flutter run lagi) perlu ketika ubah dependensi di pubspec.yaml atau native code (folder android/ atau ios/), mengubah AndroidManifest, atau menambah aset.

### AI Disclosure (Tugas 7)
Tools: Claude
log chat: https://claude.ai/share/65b06adf-ba75-43d5-a3e1-8f1f8c6e08a5 
Saya memakai Claude dengan mengirimkan PDF tugas ke AI dan minta alur kerja dan penjelasan teori per langkah, karena saya belum paham Flutter. Selain itu, saya memberikan code yang error atau kurang saya mengerti untuk mengetahui reasoning dan debuggingnya. Bagian yang dibantu AI terkait penjelasan konsep dasar (widget tree, StatelessWidget, BuildContext, hot reload vs hot restart). Kerangka struktur menu.dart (model ItemHomepage, InfoCard, ItemCard) dan pola warna lewat atribut color. Selain itu review code dan review test yang sempat error.


Keterbatasan AI: Karena AI tidak bisa run code, sehingga terdapat beberapa penyesuaian yang dilakukan oleh saya sendiri. Salah satunya, karena AI hanya mengirimkan potongan code, sehingga function seperti ShowLogoutDialog saya sesuaikan karena pada awalnya itu masih berupa message saja tanpa konfirmasi. 