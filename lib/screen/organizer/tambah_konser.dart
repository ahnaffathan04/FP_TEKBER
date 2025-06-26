import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

class TambahKonserScreen extends StatefulWidget {
  const TambahKonserScreen({Key? key}) : super(key: key);
  get context => null;

  @override
  State<TambahKonserScreen> createState() => _TambahKonserScreenState();
}

class _TambahKonserScreenState extends State<TambahKonserScreen> {
  bool isLoading = false;
  Future<String?> uploadPoster(File file) async {
    final fileName = file.path.split('/').last;
    final storageResponse = await Supabase.instance.client.storage
        .from('posterkonser')
        .upload(fileName, file);

    if (storageResponse.isEmpty) return null;

    final url = Supabase.instance.client.storage
        .from('posterkonser')
        .getPublicUrl(fileName);
    return url;
  }

  Future<String?> uploadPosterWeb(Uint8List bytes, String fileName) async {
    final response = await Supabase.instance.client.storage
        .from('posterkonser')
        .uploadBinary(fileName, bytes);

    if (response.isEmpty) return null;

    final url = Supabase.instance.client.storage
        .from('posterkonser')
        .getPublicUrl(fileName);
    return url;
  }

  final _formKey = GlobalKey<FormState>();

  final _namaKonserController = TextEditingController();
  final _tanggalController = TextEditingController();
  final _lokasiController = TextEditingController();
  final _artistController = TextEditingController();
  final _deskripsiController = TextEditingController();

  Uint8List? _posterImageBytes;
  File? _posterImage;

  @override
  void dispose() {
    _namaKonserController.dispose();
    _tanggalController.dispose();
    _lokasiController.dispose();
    _artistController.dispose();
    _deskripsiController.dispose();
    super.dispose();
  }

  // Date picker logic
  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      _tanggalController.text =
          "${picked.year.toString().padLeft(2, '0')}/${picked.month.toString().padLeft(2, '0')}/${picked.day}";
      setState(() {});
    }
  }

  // Image picker logic
  Future<void> _pickPosterImage() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.image,
      allowMultiple: false,
      withData: true,
    );
    if (result != null) {
      setState(() {
        if (result.files.single.bytes != null) {
          _posterImageBytes = result.files.single.bytes;
          _posterImage = null;
        } else if (result.files.single.path != null) {
          _posterImage = File(result.files.single.path!);
          _posterImageBytes = null;
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0E0F1A),
      appBar: _buildAppBar(),
      body: _buildBody(),
      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: const Color(0xFF0E0F1A),
      elevation: 0,
      centerTitle: true,
      leading: IconButton(
        icon: const Icon(
          Icons.arrow_back_ios,
          color: const Color(0xFF2EE6FF),
          size: 24,
        ),
        onPressed: () => Navigator.of(context).pop(),
      ),
      title: const Text(
        'Tambah Konser',
        style: TextStyle(
          fontFamily: 'Poppins',
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: Color(0xFFC8EFF8),
        ),
      ),
    );
  }

  Widget _buildBody() {
    return Form(
      key: _formKey,
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildTextField(
              label: 'Nama Konser',
              controller: _namaKonserController,
              maxLines: 1,
            ),
            const SizedBox(height: 16),
            // Date Picker Field
            GestureDetector(
              onTap: _pickDate,
              child: AbsorbPointer(
                child: _buildTextField(
                  label: 'Tanggal Konser',
                  controller: _tanggalController,
                  maxLines: 1,
                  hintText: '',
                ),
              ),
            ),
            const SizedBox(height: 16),
            _buildTextField(
              label: 'Lokasi Konser',
              controller: _lokasiController,
              maxLines: 2,
              hintText: '',
            ),
            const SizedBox(height: 16),
            _buildTextField(
              label: 'Daftar Artist',
              controller: _artistController,
              maxLines: 6,
              hintText: '',
            ),
            const SizedBox(height: 16),
            _buildTextField(
              label: 'Deskripsi',
              controller: _deskripsiController,
              maxLines: 10,
              fontWeight: FontWeight.w400,
              hintText: '',
            ),
            const SizedBox(height: 16),
            // Poster Image Upload
            Text(
              'Poster Konser',
              style: const TextStyle(
                fontFamily: 'Poppins',
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Color(0xFFC8EFF8),
              ),
            ),
            const SizedBox(height: 8),
            GestureDetector(
              onTap: _pickPosterImage,
              child: Container(
                height: 150,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: const Color(0xFF1A1B2E),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: Colors.white.withOpacity(0.1),
                    width: 1,
                  ),
                ),
                child: _posterImageBytes != null
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.memory(
                          _posterImageBytes!,
                          fit: BoxFit.cover,
                          width: double.infinity,
                          height: 150,
                        ),
                      )
                    : _posterImage != null
                        ? ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: Image.file(
                              _posterImage!,
                              fit: BoxFit.cover,
                              width: double.infinity,
                              height: 150,
                            ),
                          )
                        : Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: const [
                                SizedBox(height: 4),
                              ],
                            ),
                          ),
              ),
            ),
            const SizedBox(height: 32),
            _buildActionButtons(),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField({
    required String label,
    required TextEditingController controller,
    required int maxLines,
    FontWeight fontWeight = FontWeight.w600,
    String? hintText,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontFamily: 'Poppins',
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Color(0xFFC8EFF8),
          ),
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: const Color(0xFF1A1B2E),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: Colors.white.withOpacity(0.1),
              width: 1,
            ),
          ),
          child: TextFormField(
            controller: controller,
            maxLines: maxLines,
            style: TextStyle(
              fontFamily: 'Poppins',
              fontSize: 14,
              fontWeight: fontWeight,
              color: Colors.white,
              height: 1.4,
            ),
            decoration: InputDecoration(
              contentPadding: const EdgeInsets.all(16),
              border: InputBorder.none,
              hintText: hintText,
              hintStyle: const TextStyle(
                color: Color(0xFF8F9BB3),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildActionButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // Batal Button
        Container(
          width: 120,
          height: 50,
          decoration: BoxDecoration(
            color: const Color(0xFFFF2D55),
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFFFF2D55).withOpacity(0.3),
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: ElevatedButton(
            onPressed: () {
              context.push('/organizer-home');
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.transparent,
              shadowColor: Colors.transparent,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text(
              'Batal',
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: Color(0xFF04181D),
              ),
            ),
          ),
        ),

        // Simpan Button
        Container(
          width: 120,
          height: 50,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [
                Color(0xFF10C7EF),
                Color(0xFF44E3EF),
              ],
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
            ),
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF10C7EF).withOpacity(0.3),
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: ElevatedButton(
            onPressed: () {
              _simpanKonser();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.transparent,
              shadowColor: Colors.transparent,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text(
              'Simpan',
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: const Color(0xFF04181D),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildBottomNavigationBar() {
    return Container(
      height: 64,
      decoration: BoxDecoration(
        color: const Color(0xFF151723),
        border: Border(
          top: BorderSide(
            color: Colors.white.withOpacity(0.1),
            width: 1,
          ),
        ),
      ),
      child: Row(
        children: [
          // Home
          Padding(
            padding: const EdgeInsets.only(left: 28),
            child: IconButton(
              icon: Icon(
                Icons.home,
                color: const Color(0xFF8F9BB3),
                size: 32,
              ),
              onPressed: () {
                context.push('/organizer-home');
              },
            ),
          ),
          // Add Concert (active)
          Expanded(
            child: Center(
              child: IconButton(
                icon: Icon(
                  Icons.add_circle,
                  color: const Color(0xFF44E3EF),
                  size: 32,
                ),
                onPressed: () {
                  // Sudah di halaman tambah konser
                },
              ),
            ),
          ),
          // Settings
          Padding(
            padding: const EdgeInsets.only(right: 28),
            child: IconButton(
              icon: Icon(
                Icons.settings,
                color: const Color(0xFF8F9BB3),
                size: 32,
              ),
              onPressed: () {
                context.push('/organizer-home/setting');
              },
            ),
          ),
        ],
      ),
    );
  }

  // Update _buildNavItem agar menerima parameter iconSize
  Widget _buildNavItem({
    required String iconPath,
    required bool isActive,
    required VoidCallback onTap,
    double iconSize = 24,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(
              iconPath,
              width: iconSize,
              height: iconSize,
              color:
                  isActive ? const Color(0xFF44E3EF) : const Color(0xFF8F9BB3),
            ),
            const SizedBox(height: 6),
          ],
        ),
      ),
    );
  }

  Future<void> _simpanKonser() async {
    if (_formKey.currentState!.validate()) {
      setState(() => isLoading = true);

      String? posterUrl;
      if (kIsWeb) {
        // Untuk web: gunakan _posterImageBytes
        if (_posterImageBytes == null) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
                content: Text('Pilih gambar poster terlebih dahulu!')),
          );
          setState(() => isLoading = false);
          return;
        } else {
          final fileName =
              'poster_${DateTime.now().millisecondsSinceEpoch}.png';
          posterUrl = await uploadPosterWeb(_posterImageBytes!, fileName);
        }
      } else {
        // Untuk mobile/desktop: gunakan _posterImage
        if (_posterImage == null) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
                content: Text('Pilih gambar poster terlebih dahulu!')),
          );
          setState(() => isLoading = false);
          return;
        }
        posterUrl = await uploadPoster(_posterImage!);
      }

      await Supabase.instance.client.from('concert_table').insert({
        'concert_name': _namaKonserController.text,
        'concert_date': _tanggalController.text,
        'location': _lokasiController.text,
        'artist': _artistController.text,
        'description': _deskripsiController.text,
        'concert_poster': posterUrl ?? '',
      });

      setState(() => isLoading = false);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Konser berhasil disimpan!')),
      );
      Navigator.pop(context);
    }
  }
}