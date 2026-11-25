import 'package:flutter/material.dart';
import 'package:myportofolio_mobile/models/project.dart';

class ProjectDetailScreen extends StatelessWidget {
  const ProjectDetailScreen({required this.project, super.key});

  final Project project;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(project.title),
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (project.projectImageUrl.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.network(
                    project.projectImageUrl,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) =>
                        const Text('Gambar tidak dapat dimuat'),
                  ),
                ),
              ),
            Text(
              project.title,
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              children: [
                Chip(label: Text(project.status)),
                Chip(label: Text(project.projectType)),
              ],
            ),
            const SizedBox(height: 16),
            Text('Tech Stack', style: Theme.of(context).textTheme.titleMedium),
            Text(
              project.techStack.isEmpty ? '-' : project.techStack.join(', '),
            ),
            const SizedBox(height: 16),
            Text('Deskripsi', style: Theme.of(context).textTheme.titleMedium),
            Text(project.description),
            if (project.projectUrl.isNotEmpty) ...[
              const SizedBox(height: 16),
              Text(
                'Project URL',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              SelectableText(project.projectUrl),
            ],
          ],
        ),
      ),
    );
  }
}
