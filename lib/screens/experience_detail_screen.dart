import 'package:flutter/material.dart';
import 'package:myportofolio_mobile/models/experience.dart';
import 'package:myportofolio_mobile/utils/format_date.dart';

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

  @override
  Widget build(BuildContext context) {
    final endedAt = experience.endedAt;

    return Scaffold(
      appBar: AppBar(
        title: Text(experience.title),
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
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
