# MyPortfolio Mobile

![CI](https://github.com/dyahzhafira/myportofolio_mobile/actions/workflows/main.yaml/badge.svg)

Nama  : Dyah Zhafira Wibowo
NPM   : 2506623723
Kelas : PBP E

### Deskripsi Proyek

Mobile app untuk portfolio berbasis Flutter, klien mobile untuk website portofolio Django ([myportofolio](https://github.com/dyahzhafira/myportfolio)). Aplikasi punya menu utama, drawer navigasi, login token, serta daftar, detail, dan form tambah untuk Project dan Experience yang terhubung ke API Django (`/api/v1/projects/` dan `/api/v1/experiences/`). Melihat data bersifat publik, sedangkan menambah data butuh login dengan akun superuser.

### Setup Lokal

1. Pasang Flutter SDK (dikembangkan dengan Flutter 3.44.8, Dart 3.12.2).
2. Clone repo dan masuk ke foldernya.
3. Unduh dependensi: `flutter pub get`.
4. Generate kode model: `dart run build_runner build --delete-conflicting-outputs` 
5. Jalankan backend Django ([myportfolio](https://github.com/dyahzhafira/myportfolio)) dengan `python manage.py runserver`.
6. Jalankan Flutter:
   - Emulator Android: `flutter run` (default `http://10.0.2.2:8000`).
   - Chrome: `flutter run -d chrome --dart-define=API_BASE_URL=http://localhost:8000`.
   - Backend yang sudah di-deploy (`https://dyah-zhafira-myportfolio.pws.cs.ui.ac.id`): `flutter run --dart-define=API_BASE_URL=https://dyah-zhafira-myportfolio.pws.cs.ui.ac.id`.
7. Analisis kode: `flutter analyze`.
8. Jalankan test: `flutter test`.

### Struktur Proyek

| Berkas | Isi |
|---|---|
| `lib/main.dart` | Bootstrap aplikasi, `MaterialApp` dan tema (indigo, secondary amber) |
| `lib/config.dart` | `apiBaseUrl`, dapat ditimpa lewat `--dart-define` |
| `lib/models/project.dart`, `lib/models/experience.dart` | Model `@JsonSerializable` sesuai serializer Django |
| `lib/services/api_client.dart` | `ApiClient` (GET dan POST project dan experience, DELETE experience, token, logout) dan `ApiException` |
| `lib/services/auth_state.dart` | `AuthState` (`ChangeNotifier`), token disimpan di memori |
| `lib/utils/format_date.dart` | `formatDate` untuk tampilan tanggal |
| `lib/screens/menu.dart` | `MyHomePage` (Stateless) dan `InfoCard` |
| `lib/screens/login_screen.dart` | Halaman login |
| `lib/screens/project_list_screen.dart`, `project_detail_screen.dart` | Daftar (`FutureBuilder`, `RefreshIndicator`) dan detail project |
| `lib/screens/experience_list_screen.dart`, `experience_detail_screen.dart` | Daftar dan detail experience |
| `lib/screens/project_form.dart`, `lib/screens/experience_form.dart` | Form tambah, POST terautentikasi |
| `lib/widgets/left_drawer.dart` | `LeftDrawer`, dipakai di semua halaman |
| `lib/widgets/project_card.dart` | `ItemHomepage`, `ItemCard`, `showLogoutDialog` |
| `lib/widgets/auth_guard.dart` | `ensureLoggedIn`: route guard ke halaman login |
| `.github/workflows/main.yaml` | CI (format, analyze, test) dan build APK |
| `test/` | Widget test dan unit test API (backend palsu lewat `MockClient`) |

### Progres Mingguan

- Tutorial 08: setup Flutter, proyek `myportofolio_mobile`, pemisahan `menu.dart`, `MyHomePage` Stateless, `InfoCard`, `ItemCard`, `SnackBar`.
- Tugas 7: identitas sendiri pada `InfoCard`, warna latar berbeda per tombol lewat field `color` di `ItemHomepage`, tombol Lihat Project, Lihat Experience, Tambah Project, dan Logout.
- Tutorial 09: `LeftDrawer`, form Tambah Project (validasi dan dialog ringkasan), navigasi dengan `Navigator.push` dan `pushReplacement`, refactor ke `lib/screens/` dan `lib/widgets/`.
- Tugas 8: form Tambah Experience (date picker, validasi tanggal dan URL), card Tambah Experience, opsi Add Experience di drawer.
- Tugas 9: model `@JsonSerializable`, API Experience untuk GET, POST, dan DELETE, halaman daftar dan detail dengan `FutureBuilder` dan `RefreshIndicator`, form tambah experience dengan token dan penanganan 401, fitur hapus experience, GitHub Actions untuk CI dan build APK beserta badge, serta unit dan widget test menggunakan `MockClient`.

### Fitur Menu

| Tombol | Ikon | Warna |
|---|---|---|
| Lihat Project | folder | biru |
| Lihat Experience | work | ungu |
| Tambah Project | add_circle | hijau |
| Tambah Experience | post_add | oranye |
| Logout | logout | merah |

#### Form Tambah Experience (Tugas 8)

| Field | Input | Validasi |
|---|---|---|
| Judul | teks | wajib, tidak hanya spasi, maks 255 karakter |
| Kategori | dropdown | Internship, Research, Volunteer, Part-Time, Full-Time (default), Freelance |
| Tanggal Mulai | `showDatePicker` | wajib |
| Tanggal Selesai | `showDatePicker` | wajib kecuali "Masih bekerja", tidak boleh sebelum tanggal mulai |
| Deskripsi | teks multibaris | wajib, maks 300 karakter |
| Thumbnail URL | teks URL | opsional, harus diawali `http://` atau `https://` |

Field mengikuti model `Experience` di website Django. 

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

### Tugas 8
1. Jelaskan perbedaan antara Navigator.push(), Navigator.pushReplacement(), dan Navigator.pop(). Metode apa yang digunakan untuk membuka formulir dari kartu aksi? Jelaskan juga bagaimana opsi Home di drawer membawa pengguna kembali ke halaman utama.

Navigator.push() tambah halaman baru di stack, jadi halaman yang lama tetap ada di bawahnya dan tombol back kembali ke sana, pushReplacement() untuk ganti page paling atas ke page baru, sehingga nanti page lama dibuang dari stack. pop() untuk tutup page/dialog paling atas dan balik ke bawahnya. Untuk membuka form dari action card, saya menggunakan Navigator.push() di ItemCard agar user bisa kembali ke menu dengan button back. Opsi home di drawer menggunakan pushReplacement() ke MyHomePage, sehingga page form diganti ke halaman utama dan stack ga menumpuk tiap pindah lewat drawer.

2. Bagaimana susunan Scaffold, AppBar, dan Drawer membantu menjaga struktur halaman tetap konsisten? Berikan satu contoh penggunaan warna tema portofolio di lebih dari satu halaman.

Scaffold untuk slot tetap appBar, drawer, dan body. Jadi, tiap halaman punya kerangka yang sama dan diisi body yang berbeda aja, LeftDrawer dibuat satu kali di lib/widgets/ dan dipasang di main page, form project, dan form experience, sehingga navigasinya sama dan perubahan hanya di 1 tempat. Cotoh warna tema, pakai indigo di AppBar halaman utama dari colorScheme.primary, AppBar form Project & form Experience, DrawerHeader, dan save button dengan teks putih semua.

3. Mengapa tata letak tersebut dipilih untuk formulir? Jelaskan peran widget pengatur jarak dan widget penggulir ketika ruang layar terbatas.

Karena form punya banyak field, seperti judul, kategori, tanggal, deskripsi, URL, dan tombol. Sehingga, di screen HP atau sedang terdapat keyboard. tampilan Column bisa overflow. Oleh karena itu, form disusun dalam Column di SingleChildScrollView  dan tiap fieldnya diwrap Padding. SingleChildScrollView akan membuat bisa discroll, sehingga semua field dan button save bisa dijangkau. Padding juga kasih jarak antar dield agar tidak terlalu nempel.

4. Apa peran GlobalKey<FormState>, validator, dan validate() saat tombol Simpan ditekan? Berikan satu contoh nilai yang ditolak oleh validasi dan jelaskan mengapa memilih jenis input atau papan ketik saja belum cukup.
GlobalKey<FormSate> dipasang di widget Form agar button save yang ada di luar field bisa akses FormState. Validator berfungsi di tiap field yang return message error or null kalau isinya valid. Ketika button save diklik, _formKey.currentState!.validate() akan jalanin semua validator sekaligus, dan nampilin error message di kolom yang bermasalah dan return true kalau semua valid, baru show dialog ringkasan. Contoh nilai yang ditolak, title berisi space aja, URL thumbnail bukan url, atay tanggal selesai yang lebih awal dari tanggal mulai. Jenis input atau keyboard itu belum cukup karena hanya atur tampilan input, keyboardType: url, tapi ga cegah user buat ketik atau paste text apapun. Selain itu, date picker tidak tau bahwa tanggal selesai itu harus setelah tanggal mulai, sehingga, untuk aturan seperti itu harus dicek dengan validator.

### AI Disclosure (Tugas 8)
Tools: Claude 
log chat: https://claude.ai/share/8f2c00f8-8baf-42f7-bfd7-a722c8cf83ec
Saya kirim PDF tutorial dan tugas, lalu minta Claude cek repo, chekclist apa yang belum dikerjakan, dan mengerjakan bertahap mulai dari drawer sampai experience form. Bagian yang dibantu AI salah satunya template form dan AppDrawer.

Keterbatasan AI dan perbaikan yang dilakukan:
- Draf action card Experience itu masih berupa kode tanpa class dan import, selain itu masih menggunakan `AppDrawer` yang tidak sesuai dengan projek ini, sehingga dilakukan perbaikan dan penyesuaian manual. 
- AI awalnya tidak tahu model data di web django sebelumnya, sehingga field form (Posisi, Perusahaan) tidak sesuai. Sehingga perlu penyesuaian lagi dengan model data di repo web. 

#### FITUR TAMBAHAN (Tugas 8)
- Checkbox "Masih bekerja di sini", bakal nonaktifin tanggal selesai, dialog show "Selesai: Sekarang".

### Tugas 9
1. Mengapa kita menggunakan @JsonSerializable(fieldRename: FieldRename.snake) dan @JsonKey(includeToJson: false) alih-alih mengirim objek Map<String, dynamic> mentah langsung dari widget? Jelaskan satu bug yang dicegah atau dapat dicegah oleh pendekatan ini pada model bagianmu.
Karena dengan model Experience, key JSON itu akan dibuat otomatis dan nama field dart yang camelCase akan menjadi snake_case ke django, seperti categoryDisplay menjadi category_display tanpa ketik manual. Selain itu, tipenya juga dicek di compiler seperti startedAt itu DateTime. Sedangkan di Map, semua nilai tipe dynamic dan ketika salah ketik baru ketahuan saat dijalankan. includeToJson: false itu dipakai di field yang dibuat dan di hitung server, contoh id, categoryDisplay, isOngoing, isStarred, starCount, dan starredByNames, sehingga ga ikut kekirim di body POST. Bug yang dicegah adalah ketika saya tulis manual map dengan key startedAt, nanti django akan tolak dengan 400 karna field required started_at itu gaada. Dan dengan fieldRename.snake, key yang dirim selalu started_at dan field server ga pernah salah kirim.

2. Mengapa Future yang diteruskan ke FutureBuilder harus diinisialisasi di dalam initState() alih-alih langsung di dalam build(), dan mengapa ApiClient sebaiknya melempar ApiException daripada mengembalikan null pada respons HTTP non-2xx?

build() itu bisa dipanggil berkali kali tiap setState, perubahan ukuran layar, atau saat keyboard muncu;. Kalau Future dibuat di dalam build(), tiap panggilan kirim request HTTP baru, FutureBuilder akan kembali ke status loading, dan tampilan berkedip bahkan bisa berulang. initState() itu cuman jalan sekali, jadi ketika request sekali, pengambilan ulang itu cuman lewat _reload() (tombol retry atau tarik buat refresh). ApiException bawa statusCode, sedangkan null itu akan membuat informasi apakah masalahnya itu 401, 400, atau 500 itu hilang, sehingga pemanggil bisa lupa cek null. Dengan exception, form bisa membedakan penanganannya, misal 401 itu untuk sesi dihapus dan user diminta login ulang. Sedangkan FutureBuilder itu menggunakan snapshot.hasError untuk tampilin pesan dan tombol Retry.

3. Bandingkan SessionAuthentication milik Django (dari Tutorial 04/07) dengan TokenAuthentication milik DRF (dari Tutorial 10). Mengapa myportfolio_mobile menggunakan TokenAuthentication sementara SessionAuthentication tetap diaktifkan pada backend Django?

SessionAuthentication itu save login di server dan identify user lewat cookie sessionid dan butuh token CSRF untuk request yang ubah data karna cookie dikirim otomatis sama browser. Hal ini cocok untuk web. TokenAuthentication itu menggunakan token dari /api/v1/auth/token, kemudian dikirim lewat header Authorization: Token <key> di tiap request dan tanpa cookie & CSRF. 

Aplikasi Flutter itu bukan browser, sehingga tidak mengelola cookie dan CSRF dengan sendirinya, jadi token itu disimpan di memory AuthState dan dikirim lewat header. Logout bakal manggil /api/v1/auth/logout yang hapus token di server. SessionAuthentication bakal tetap diaktifkan karena page web Django (template, admin, sama star button di web) masih pakai login session based. Urutannya TokenAuthentication dulu, agar request tanpa credential dapet 401 bukan 403, baru SessionAuthentication di web.

4. Jelaskan peran job build (very_good_workflows) dan build_apk dalam pipeline .github/workflows/main.yaml milikmu (termasuk pemeriksaan apa saja yang dijalankan very_good_workflows di balik layar). Mengapa berkas *.g.dart dimasukkan ke .gitignore meskipun CI membutuhkannya untuk menganalisis dan membangun aplikasi?

Job build manggil workflow flutter_package.yml dari very_good_workflows. Di background dia jalanin langkah setup, download dependensi, cek format, dan jalanin flutter analyze, trakhir flutter test dengan coverage dan cek min coverage dan *.g.dart itu ga termasuk di coverage. Job build_apk cuman jalan after build sukses dan pasang Flutter 3.44.8 dan jalanun pub get dan build runner dan flutter build apk --release dengan --dart-define=API_BASE_URL dari variabel repo dan upload app-release apk as artefak app-release-apk. *.g.dart masuk ke gitignore karena berkas itu hasil generate yang bisa dibuat ulang dari model dan build_runner. Sehingga, jika di commit diff bisa konflik dan resikonya bisa bikin model ga sinkron. CI itu ga bergantung ke hasil commit karna build_runner dijalanin dulu di setup sebelum analisis dan build.

### AI Disclosure (Tugas 9)
Tools: Claude
log chat: https://claude.ai/share/7db4b4c4-0d02-41a6-bbd2-7dbedefd0345
Saya mengirim PDF tugas ke Claude, lalu meminta Claude cek repo, create checklist, dan memandu pengerjaan bagian Experience secara bertahap (model, ApiClient, screen daftar, screen detail, sambungan ke menu dan drawer, form POST, tes, README) 

Saya mengirim PDF tugas ke Claude, lalu meminta Claude memeriksa repo, crate checklist, dan bantu kasih template step by step bertahap. Claude kasih penjelasan, review, dan potongan kode untuk model, ApiClient, layar daftar dan detail, navigasi, form POST, dan tes.

Keterbatasan AI dan perbaikan:
Claude hanya mengirimkan beberapa potongan code sebagai base template, sehingga saya menyesuaikannya kembali dengan struktur code saya.
Contoh builder dari Claude untuk screen daftar itu lebih sederhana, sehingga saya mengikuti project_list_screen.dart, contohnya untuk padding.
Claude tidak bisa menjalankan Flutter, sehingga build, analyze, dan tes perlu saya jalankan sendiri.

#### FITUR TAMBAHAN (Tugas 9)
- Hapus Experience dengan `DELETE` dengan token. Delete button hanya muncul saat login, ada konfirmasi, dan daftar dimuat ulang setelah berhasil. Error 401 minta login ulang, 403 kasih message khusus, dan error lainnya ditampilin lewat SnackBar.
- Testing mencakup unit test `ApiClient` untuk GET, POST, DELETE, token, dan `ApiException`, serta widget test untuk daftar, detail, POST, 401, dan hapus Experience.
