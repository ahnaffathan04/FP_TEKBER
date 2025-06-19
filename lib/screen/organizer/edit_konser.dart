import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';


class EditKonserScreen extends StatefulWidget {
  final Map konser;

  const EditKonserScreen({Key? key, required this.konser}) : super(key: key);

  @override
  State<EditKonserScreen> createState() => _EditKonserScreenState();
}

class _EditKonserScreenState extends State<EditKonserScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _namaKonserController;
  late TextEditingController _tanggalController;
  late TextEditingController _lokasiController;
  late TextEditingController _artistController;
  late TextEditingController _deskripsiController;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    _namaKonserController =
        TextEditingController(text: widget.konser['nama_konser']);
    _tanggalController = TextEditingController(text: widget.konser['tanggal']);
    _lokasiController = TextEditingController(text: widget.konser['lokasi']);
    _artistController = TextEditingController(text: widget.konser['artist']);
    _deskripsiController =
        TextEditingController(text: widget.konser['deskripsi']);
  }

  @override
  void dispose() {
    _namaKonserController.dispose();
    _tanggalController.dispose();
    _lokasiController.dispose();
    _artistController.dispose();
    _deskripsiController.dispose();
    super.dispose();
  }

  Future<void> _updateKonser() async {
    if (_formKey.currentState!.validate()) {
      setState(() => isLoading = true);

      await Supabase.instance.client.from('konser').update({
        'nama_konser': _namaKonserController.text,
        'tanggal': _tanggalController.text,
        'lokasi': _lokasiController.text,
        'artist': _artistController.text,
        'deskripsi': _deskripsiController.text,
      }).eq('id', widget.konser['id']);

      setState(() => isLoading = false);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Konser berhasil diupdate!')),
      );
      Navigator.pop(context, true);
    }
  }

  Widget label(String text) => Padding(
        padding: const EdgeInsets.only(top: 16, bottom: 4),
        child: Text(
          text,
          style: const TextStyle(
            color: Color(0xFF44E3EF),
            fontWeight: FontWeight.bold,
            fontSize: 15,
          ),
        ),
      );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF181A20),
      appBar: AppBar(
        backgroundColor: const Color(0xFF181A20),
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text(
          'Edit Konser',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 22,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              label('Nama Konser'),
              TextFormField(
                controller: _namaKonserController,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 17,
                ),
                decoration: InputDecoration(
                  filled: true,
                  fillColor: const Color(0xFF23252B),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  contentPadding:
                      const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                ),
                validator: (v) => v == null || v.isEmpty ? 'Wajib diisi' : null,
              ),
              label('Tanggal Konser'),
              TextFormField(
                controller: _tanggalController,
                readOnly: true,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 17,
                ),
                decoration: InputDecoration(
                  filled: true,
                  fillColor: const Color(0xFF23252B),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  contentPadding:
                      const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                  suffixIcon: const Icon(Icons.calendar_today,
                      color: Color(0xFF44E3EF)),
                ),
                onTap: () async {
                  DateTime? picked = await showDatePicker(
                    context: context,
                    initialDate: DateTime.tryParse(_tanggalController.text) ??
                        DateTime.now(),
                    firstDate: DateTime(2000),
                    lastDate: DateTime(2100),
                  );
                  if (picked != null) {
                    _tanggalController.text =
                        picked.toIso8601String().substring(0, 10);
                  }
                },
                validator: (v) => v == null || v.isEmpty ? 'Wajib diisi' : null,
              ),
              label('Lokasi Konser'),
              TextFormField(
                controller: _lokasiController,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 17,
                ),
                decoration: InputDecoration(
                  filled: true,
                  fillColor: const Color(0xFF23252B),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  contentPadding:
                      const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                ),
                validator: (v) => v == null || v.isEmpty ? 'Wajib diisi' : null,
              ),
              label('Daftar Artist'),
              TextFormField(
                controller: _artistController,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 17,
                ),
                decoration: InputDecoration(
                  filled: true,
                  fillColor: const Color(0xFF23252B),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  contentPadding:
                      const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                ),
                validator: (v) => v == null || v.isEmpty ? 'Wajib diisi' : null,
              ),
              label('Deskripsi'),
              TextFormField(
                controller: _deskripsiController,
                maxLines: 3,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 17,
                ),
                decoration: InputDecoration(
                  filled: true,
                  fillColor: const Color(0xFF23252B),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  contentPadding:
                      const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                ),
                validator: (v) => v == null || v.isEmpty ? 'Wajib diisi' : null,
              ),
              const SizedBox(height: 32),
              Row(
                children: [
                  // Tombol Batalkan (nonaktif)
                  Expanded(
                    child: ElevatedButton(
                      onPressed: null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.grey.shade300,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                      child: const Text(
                        'Batalkan',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  // Tombol Tambah Tiket (nonaktif)
                  Expanded(
                    child: ElevatedButton(
                      onPressed: null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.grey.shade300,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                      child: const Text(
                        'Tambah Tiket',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  // Tombol Simpan (aktif)
                  Expanded(
                    child: ElevatedButton(
                      onPressed: isLoading ? null : _updateKonser,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF44E3EF),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                      child: isLoading
                          ? const CircularProgressIndicator()
                          : const Text(
                              'Simpan',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 15,
                                color: Color(0xFF04181D),
                              ),
                            ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}