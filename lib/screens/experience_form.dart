import 'package:flutter/material.dart';
import 'package:myportofolio_mobile/widgets/left_drawer.dart';

/// Halaman form tambah experience (belum disimpan ke database)
class ExperienceFormPage extends StatefulWidget {
  const ExperienceFormPage({super.key});

  @override
  State<ExperienceFormPage> createState() => _ExperienceFormPageState();
}

class _ExperienceFormPageState extends State<ExperienceFormPage> {
  final _formKey = GlobalKey<FormState>();
  final _positionCtrl = TextEditingController();
  final _companyCtrl = TextEditingController();
  final _startCtrl = TextEditingController();
  final _endCtrl = TextEditingController();
  final _descCtrl = TextEditingController();
  final _linkCtrl = TextEditingController();
  DateTime? _start;
  DateTime? _end;
  bool _isCurrent = false;

  @override
  void dispose() {
    _positionCtrl.dispose();
    _companyCtrl.dispose();
    _startCtrl.dispose();
    _endCtrl.dispose();
    _descCtrl.dispose();
    _linkCtrl.dispose();
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
    return valid ? null : 'Tautan harus diawali http:// atau https://';
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
      _startCtrl.clear();
      _endCtrl.clear();
    });
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Experience berhasil ditambahkan!'),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Posisi: ${_positionCtrl.text.trim()}'),
              Text('Perusahaan: ${_companyCtrl.text.trim()}'),
              Text('Mulai: ${_startCtrl.text}'),
              Text('Selesai: ${_isCurrent ? 'Sekarang' : _endCtrl.text}'),
              Text('Deskripsi: ${_descCtrl.text.trim()}'),
              Text('Tautan: ${_linkCtrl.text.trim()}'),
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
                  controller: _positionCtrl,
                  decoration: _decoration('Posisi'),
                  validator: (v) => _validateRequired(v, 'Posisi'),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  controller: _companyCtrl,
                  decoration: _decoration('Perusahaan'),
                  validator: (v) => _validateRequired(v, 'Perusahaan'),
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
                  controller: _linkCtrl,
                  keyboardType: TextInputType.url,
                  decoration: _decoration(
                    'Tautan (opsional)',
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
                    onPressed: _submit,
                    child: const Text(
                      'Simpan',
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
