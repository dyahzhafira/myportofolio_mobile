import 'package:flutter/material.dart';
import 'package:myportofolio_mobile/models/experience.dart';
import 'package:myportofolio_mobile/services/api_client.dart';
import 'package:myportofolio_mobile/services/auth_state.dart';
import 'package:myportofolio_mobile/utils/format_date.dart';
import 'package:myportofolio_mobile/widgets/auth_guard.dart';
import 'package:provider/provider.dart';

class ExperienceDetailScreen extends StatelessWidget {
  const ExperienceDetailScreen({required this.experience, super.key});

  final Experience experience;

  Widget _field(String label, String value) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      title: Text(label),
      subtitle: Text(value.isEmpty ? '-' : value),
    );
  }

  Future<void> _delete(BuildContext context) async {
    final id = experience.id;
    if (id == null) return;

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Hapus experience?'),
        content: Text('"${experience.title}" akan dihapus permanen.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: const Text('Batal'),
          ),
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () => Navigator.pop(dialogContext, true),
            child: const Text('Hapus'),
          ),
        ],
      ),
    );
    if (confirmed != true || !context.mounted) return;

    final api = context.read<ApiClient>();
    final auth = context.read<AuthState>();
    final messenger = ScaffoldMessenger.of(context);
    final navigator = Navigator.of(context);

    void showMessage(String message) {
      messenger.hideCurrentSnackBar();
      messenger.showSnackBar(SnackBar(content: Text(message)));
    }

    try {
      await api.deleteExperience(id, token: auth.token!);
      navigator.pop(true);
      showMessage('Experience berhasil dihapus');
    } on ApiException catch (e) {
      if (e.statusCode == 401) {
        await auth.logout();
        showMessage('Sesi berakhir, silakan login ulang');
        if (context.mounted) await ensureLoggedIn(context);
      } else if (e.statusCode == 403) {
        showMessage('Hanya pemilik portofolio yang dapat menghapus');
      } else {
        showMessage('Gagal menghapus experience (${e.statusCode})');
      }
    } on Exception {
      showMessage('Tidak dapat terhubung ke server');
    }
  }

  @override
  Widget build(BuildContext context) {
    final endedAt = experience.endedAt;
    final isLoggedIn = context.watch<AuthState>().isLoggedIn;

    return Scaffold(
      appBar: AppBar(
        title: Text(experience.title),
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
        actions: [
          if (isLoggedIn && experience.id != null)
            IconButton(
              icon: const Icon(Icons.delete_outline),
              tooltip: 'Hapus',
              onPressed: () => _delete(context),
            ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (experience.thumbnail.isNotEmpty)
              Image.network(
                experience.thumbnail,
                errorBuilder: (context, error, stackTrace) =>
                    const Text('Gambar tidak dapat dimuat'),
              ),
            _field('ID', experience.id ?? ''),
            _field('Kode Kategori', experience.category),
            _field('Kategori', experience.categoryDisplay),
            _field('Thumbnail', experience.thumbnail),
            _field('Sedang Berlangsung', experience.isOngoing ? 'Ya' : 'Tidak'),
            _field('Dibintangi', experience.isStarred ? 'Ya' : 'Tidak'),
            _field('Jumlah Bintang', experience.starCount.toString()),
            _field('Dibintangi Oleh', experience.starredByNames),
            _field('Judul', experience.title),
            _field('Deskripsi', experience.description),
            _field('Tanggal Mulai', formatDate(experience.startedAt)),
            _field(
              'Tanggal Selesai',
              endedAt == null ? 'Sekarang' : formatDate(endedAt),
            ),
          ],
        ),
      ),
    );
  }
}
