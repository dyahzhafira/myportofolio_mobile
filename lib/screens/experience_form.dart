import 'package:flutter/material.dart';
import 'package:myportofolio_mobile/models/experience.dart';
import 'package:myportofolio_mobile/screens/experience_list_screen.dart';
import 'package:myportofolio_mobile/services/api_client.dart';
import 'package:myportofolio_mobile/services/auth_state.dart';
import 'package:myportofolio_mobile/widgets/auth_guard.dart';
import 'package:myportofolio_mobile/widgets/left_drawer.dart';
import 'package:provider/provider.dart';

class ExperienceFormPage extends StatefulWidget {
  const ExperienceFormPage({super.key});

  @override
  State<ExperienceFormPage> createState() => _ExperienceFormPageState();
}

class _ExperienceFormPageState extends State<ExperienceFormPage> {
  final _formKey = GlobalKey<FormState>();
  final _titleCtrl = TextEditingController();
  final _startCtrl = TextEditingController();
  final _endCtrl = TextEditingController();
  final _descCtrl = TextEditingController();
  final _thumbnailCtrl = TextEditingController();
  DateTime? _start;
  DateTime? _end;
  bool _isCurrent = false;
  String _category = 'full-time';
  bool _isSubmitting = false;

  static const _categories = {
    'internship': 'Internship',
    'research': 'Research',
    'volunteer': 'Volunteer',
    'part-time': 'Part-Time',
    'full-time': 'Full-Time',
    'freelance': 'Freelance',
  };

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) ScaffoldMessenger.of(context).hideCurrentSnackBar();
    });
  }

  @override
  void dispose() {
    _titleCtrl.dispose();
    _startCtrl.dispose();
    _endCtrl.dispose();
    _descCtrl.dispose();
    _thumbnailCtrl.dispose();
    super.dispose();
  }

  String _formatDate(DateTime d) =>
      '${d.day.toString().padLeft(2, '0')}/${d.month.toString().padLeft(2, '0')}/${d.year}';

  InputDecoration _decoration(String label, {String? hint, Widget? suffix}) {
    return InputDecoration(
      labelText: label,
      hintText: hint,
      suffixIcon: suffix,
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(5.0)),
    );
  }

  String? _validateRequired(String? value, String label, {int max = 100}) {
    if (value == null || value.trim().isEmpty) {
      return '$label tidak boleh kosong!';
    }
    if (value.trim().length > max) {
      return '$label maksimal $max karakter!';
    }
    return null;
  }

  String? _validateLink(String? value) {
    final link = value?.trim() ?? '';
    if (link.isEmpty) return null;
    final uri = Uri.tryParse(link);
    final valid =
        uri != null &&
        (uri.scheme == 'http' || uri.scheme == 'https') &&
        uri.host.isNotEmpty;
    return valid ? null : 'URL harus diawali http:// atau https://';
  }

  Future<void> _pickDate({required bool isStart}) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    );
    if (picked == null) return;
    setState(() {
      if (isStart) {
        _start = picked;
        _startCtrl.text = _formatDate(picked);
      } else {
        _end = picked;
        _endCtrl.text = _formatDate(picked);
      }
    });
  }

  void _resetForm() {
    _formKey.currentState!.reset();
    setState(() {
      _start = null;
      _end = null;
      _isCurrent = false;
      _category = 'full-time';
      _startCtrl.clear();
      _endCtrl.clear();
    });
  }

  DateTime _toApiDate(DateTime d) => DateTime.utc(d.year, d.month, d.day, 12);

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    if (!await ensureLoggedIn(context)) return;
    if (!mounted) return;

    final api = context.read<ApiClient>();
    final auth = context.read<AuthState>();
    final messenger = ScaffoldMessenger.of(context);
    final experience = Experience(
      title: _titleCtrl.text.trim(),
      description: _descCtrl.text.trim(),
      category: _category,
      startedAt: _toApiDate(_start!),
      endedAt: _isCurrent ? null : _toApiDate(_end!),
      thumbnail: _thumbnailCtrl.text.trim(),
    );

    void showMessage(String message) {
      messenger.hideCurrentSnackBar();
      messenger.showSnackBar(SnackBar(content: Text(message)));
    }

    setState(() => _isSubmitting = true);
    try {
      await api.createExperience(experience, token: auth.token!);
      if (!mounted) return;
      _showSuccessDialog();
    } on ApiException catch (e) {
      if (e.statusCode == 401) {
        await auth.logout();
        showMessage('Sesi berakhir, silakan login ulang');
        if (mounted) await ensureLoggedIn(context);
      } else {
        showMessage('Gagal menyimpan experience (${e.statusCode})');
      }
    } on Exception {
      showMessage('Tidak dapat terhubung ke server');
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Experience berhasil ditambahkan!'),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Judul: ${_titleCtrl.text.trim()}'),
              Text('Kategori: ${_categories[_category]}'),
              Text('Mulai: ${_startCtrl.text}'),
              Text('Selesai: ${_isCurrent ? 'Sekarang' : _endCtrl.text}'),
              Text('Deskripsi: ${_descCtrl.text.trim()}'),
              Text('Thumbnail: ${_thumbnailCtrl.text.trim()}'),
            ],
          ),
        ),
        actions: [
          TextButton(
            child: const Text('OK'),
            onPressed: () {
              Navigator.pop(dialogContext);
              _resetForm();
            },
          ),
          TextButton(
            child: const Text('Lihat Daftar'),
            onPressed: () {
              Navigator.pop(dialogContext);
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => const ExperienceListScreen(),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(child: Text('Add Experience Form')),
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
      ),
      drawer: const LeftDrawer(),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  controller: _titleCtrl,
                  decoration: _decoration('Judul'),
                  validator: (v) => _validateRequired(v, 'Judul', max: 255),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: DropdownButtonFormField<String>(
                  isExpanded: true,
                  decoration: _decoration('Kategori'),
                  initialValue: _category,
                  items: _categories.entries
                      .map(
                        (e) => DropdownMenuItem(
                          value: e.key,
                          child: Text(e.value),
                        ),
                      )
                      .toList(),
                  onChanged: (value) => setState(() => _category = value!),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  controller: _startCtrl,
                  readOnly: true,
                  onTap: () => _pickDate(isStart: true),
                  decoration: _decoration(
                    'Tanggal Mulai',
                    suffix: const Icon(Icons.calendar_today),
                  ),
                  validator: (_) =>
                      _start == null ? 'Tanggal mulai harus dipilih!' : null,
                ),
              ),
              CheckboxListTile(
                value: _isCurrent,
                title: const Text('Masih bekerja di sini'),
                controlAffinity: ListTileControlAffinity.leading,
                onChanged: (value) {
                  setState(() {
                    _isCurrent = value ?? false;
                    if (_isCurrent) {
                      _end = null;
                      _endCtrl.clear();
                    }
                  });
                },
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  controller: _endCtrl,
                  readOnly: true,
                  enabled: !_isCurrent,
                  onTap: () => _pickDate(isStart: false),
                  decoration: _decoration(
                    'Tanggal Selesai',
                    suffix: const Icon(Icons.calendar_today),
                  ),
                  validator: (_) {
                    if (_isCurrent) return null;
                    if (_end == null) return 'Tanggal selesai harus dipilih!';
                    if (_start != null && _end!.isBefore(_start!)) {
                      return 'Tanggal selesai tidak boleh sebelum tanggal mulai!';
                    }
                    return null;
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  controller: _descCtrl,
                  maxLines: 4,
                  decoration: _decoration('Deskripsi'),
                  validator: (v) => _validateRequired(v, 'Deskripsi', max: 300),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  controller: _thumbnailCtrl,
                  keyboardType: TextInputType.url,
                  decoration: _decoration(
                    'Thumbnail URL (opsional)',
                    hint: 'https://...',
                  ),
                  validator: _validateLink,
                ),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor: WidgetStateProperty.all(Colors.indigo),
                    ),
                    onPressed: _isSubmitting ? null : _submit,
                    child: const Text(
                      'Save',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
