import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:go_router/go_router.dart';

class TambahKonserScreen extends StatefulWidget {
  const TambahKonserScreen({Key? key}) : super(key: key);
  get context => null;

  @override
  State<TambahKonserScreen> createState() => _TambahKonserScreenState();
}

class _TambahKonserScreenState extends State<TambahKonserScreen> {
  final _formKey = GlobalKey<FormState>();

  // Controllers for text fields (tanpa default value)
  final _namaKonserController = TextEditingController();
  final _tanggalController = TextEditingController();
  final _lokasiController = TextEditingController();
  final _artistController = TextEditingController();
  final _deskripsiController = TextEditingController();

  // Tambahkan variabel untuk menyimpan bytes (web) dan file (mobile)
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
          "${picked.day.toString().padLeft(2, '0')}/${picked.month.toString().padLeft(2, '0')}/${picked.year}";
      setState(() {});
    }
  }

  // Image picker logic
  Future<void> _pickPosterImage() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.image,
      allowMultiple: false,
      withData: true, // penting untuk web
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
                  hintText: 'Pilih tanggal konser',
                ),
              ),
            ),
            const SizedBox(height: 16),
            _buildTextField(
              label: 'Lokasi Konser',
              controller: _lokasiController,
              maxLines: 2,
              hintText: 'Masukkan lokasi konser',
            ),
            const SizedBox(height: 16),
            _buildTextField(
              label: 'Daftar Artist',
              controller: _artistController,
              maxLines: 6,
              hintText: 'Masukkan daftar artist',
            ),
            const SizedBox(height: 16),
            _buildTextField(
              label: 'Deskripsi',
              controller: _deskripsiController,
              maxLines: 10,
              fontWeight: FontWeight.w400,
              hintText: 'Masukkan deskripsi konser',
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
                                Icon(Icons.upload_file,
                                    color: Color(0xFF44E3EF), size: 40),
                                SizedBox(height: 8),
                                Text(
                                  'Upload Poster',
                                  style: TextStyle(
                                    color: Color(0xFF8F9BB3),
                                    fontFamily: 'Poppins',
                                    fontSize: 14,
                                  ),
                                ),
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
              primary: Colors.transparent,
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
              primary: Colors.transparent,
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
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildNavItem(
            iconPath: 'organizer/navbar/home.png',
            isActive: false,
            onTap: () {
              context.push('/organizer-home');
            },
          ),
          _buildNavItem(
            iconPath: 'organizer/navbar/plus.png',
            isActive: true,
            onTap: () {},
          ),
          _buildNavItem(
            iconPath: 'organizer/navbar/settings.png',
            isActive: false,
            onTap: () {
              // Navigate to settings
            },
          ),
        ],
      ),
    );
  }

  Widget _buildNavItem({
    required String iconPath,
    required bool isActive,
    required VoidCallback onTap,
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
              width: 24,
              height: 24,
              color:
                  isActive ? const Color(0xFF44E3EF) : const Color(0xFF8F9BB3),
            ),
            const SizedBox(height: 6),
          ],
        ),
      ),
    );
  }

  void _simpanKonser() {
    if (_formKey.currentState!.validate()) {
      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Konser berhasil disimpan!',
            style: TextStyle(
              fontFamily: 'Poppins',
              fontWeight: FontWeight.w500,
            ),
          ),
          backgroundColor: Color(0xFF10C7EF),
          duration: Duration(seconds: 2),
        ),
      );

      // Navigate back or to another screen
      Navigator.of(context).pop();
    }
  }
}
