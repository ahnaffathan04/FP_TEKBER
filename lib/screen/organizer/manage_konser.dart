import 'package:flutter/material.dart';
import 'edit_konser.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ManageKonserScreen extends StatefulWidget {
  final Map<String, dynamic> konser;
  const ManageKonserScreen({Key? key, required this.konser}) : super(key: key);

  @override
  _ManageKonserScreenState createState() => _ManageKonserScreenState();
}

class _ManageKonserScreenState extends State<ManageKonserScreen> {
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    // Format tanggal ke dd/MM/yyyy
    String formatTanggal(String tanggal) {
      try {
        final date = DateTime.parse(tanggal);
        return "${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}";
      } catch (_) {
        return tanggal;
      }
    }

    return Scaffold(
      backgroundColor: const Color(0xFF0E0F1A),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0E0F1A),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          'Detail Konser',
          style: TextStyle(
            color: Colors.white,
            fontFamily: 'Poppins',
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Poster & Rating
            Container(
              width: double.infinity,
              height: 120,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFF00FFB3), width: 2),
                image: widget.konser['poster_url'] != null &&
                        widget.konser['poster_url'] != ''
                    ? DecorationImage(
                        image: NetworkImage(widget.konser['poster_url']),
                        fit: BoxFit.cover,
                        colorFilter: ColorFilter.mode(
                          Colors.black.withOpacity(0.4),
                          BlendMode.darken,
                        ),
                      )
                    : null,
              ),
              child: Stack(
                children: [
                  Positioned(
                    top: 8,
                    left: 12,
                    child: Row(
                      children: [
                        const Text(
                          'Rating (5.0)',
                          style: TextStyle(
                            color: Color(0xFFC8EFF8),
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.w600,
                            fontSize: 13,
                          ),
                        ),
                        const SizedBox(width: 4),
                        ...List.generate(
                          5,
                          (index) => const Icon(Icons.star,
                              color: Color(0xFFFFD700), size: 16),
                        ),
                      ],
                    ),
                  ),
                  const Positioned(
                    bottom: 12,
                    left: 12,
                    child: Text(
                      'Poster',
                      style: TextStyle(
                        color: Color(0xFF22E6CE),
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 18),
            // Lihat Semua Ulasan
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                  onTap: () {
                    // TODO: Navigasi ke halaman ulasan jika ada
                  },
                  child: const Text(
                    'Lihat Semua Ulasan',
                    style: TextStyle(
                      color: Color(0xFF22E6CE),
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                    ),
                  ),
                ),
                const Icon(Icons.arrow_forward_ios,
                    color: Color(0xFF22E6CE), size: 18),
              ],
            ),
            const SizedBox(height: 18),
            // Nama Konser
            const Text(
              'Nama Konser',
              style: TextStyle(
                color: Color(0xFFC8EFF8),
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w600,
                fontSize: 13,
              ),
            ),
            Text(
              widget.konser['nama_konser'] ?? '',
              style: const TextStyle(
                color: Colors.white,
                fontFamily: 'Poppins',
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
            const SizedBox(height: 12),
            // Tanggal Konser
            const Text(
              'Tanggal Konser',
              style: TextStyle(
                color: Color(0xFFC8EFF8),
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w600,
                fontSize: 13,
              ),
            ),
            Text(
              formatTanggal(widget.konser['tanggal'] ?? ''),
              style: const TextStyle(
                color: Colors.white,
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w600,
                fontSize: 15,
              ),
            ),
            const SizedBox(height: 12),
            // Lokasi Konser
            const Text(
              'Lokasi Konser',
              style: TextStyle(
                color: Color(0xFFC8EFF8),
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w600,
                fontSize: 13,
              ),
            ),
            Text(
              widget.konser['lokasi'] ?? '',
              style: const TextStyle(
                color: Colors.white,
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w600,
                fontSize: 15,
              ),
            ),
            const SizedBox(height: 12),
            // Daftar Artist
            const Text(
              'Daftar Artist',
              style: TextStyle(
                color: Color(0xFFC8EFF8),
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w600,
                fontSize: 13,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 8.0, top: 2),
              child: Text(
                '• ${widget.konser['artist'] ?? ''}',
                style: const TextStyle(
                  color: Colors.white,
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w600,
                  fontSize: 15,
                ),
              ),
            ),
            const SizedBox(height: 12),
            // Deskripsi
            const Text(
              'Deskripsi',
              style: TextStyle(
                color: Color(0xFFC8EFF8),
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w600,
                fontSize: 13,
              ),
            ),
            Text(
              widget.konser['deskripsi'] ?? '',
              style: const TextStyle(
                color: Colors.white,
                fontFamily: 'Poppins',
                fontWeight: FontWeight.normal,
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 24),
            // Tombol Aksi
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Batal
                Expanded(
                  child: ElevatedButton(
                    onPressed: isLoading
                        ? null
                        : () async {
                            final confirm = await showDialog<bool>(
                              context: context,
                              builder: (context) => AlertDialog(
                                title: const Text('Konfirmasi'),
                                content: const Text(
                                    'Yakin ingin membatalkan (menghapus) konser ini?'),
                                actions: [
                                  TextButton(
                                    onPressed: () =>
                                        Navigator.pop(context, false),
                                    child: const Text('Batal'),
                                  ),
                                  TextButton(
                                    onPressed: () =>
                                        Navigator.pop(context, true),
                                    child: const Text('Ya, Hapus'),
                                  ),
                                ],
                              ),
                            );
                            if (confirm == true) {
                              setState(() => isLoading = true);
                              await Supabase.instance.client
                                  .from('konser')
                                  .delete()
                                  .eq('id', widget.konser['id']);
                              setState(() => isLoading = false);
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content:
                                        Text('Konser berhasil dibatalkan!')),
                              );
                              Navigator.pop(
                                  context, true); // Kembali & trigger refresh
                            }
                          },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.redAccent,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    child: isLoading
                        ? const CircularProgressIndicator()
                        : const Text(
                            'Batalkan',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                              color: Colors.white,
                            ),
                          ),
                  ),
                ),
                const SizedBox(width: 12),
                // Tambah Tiket (gradient)
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFF22E6CE), Color(0xFF10FF8C)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(18),
                    ),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.transparent,
                        shadowColor: Colors.transparent,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                      onPressed: () {
                        // TODO: Navigasi ke tambah tiket
                      },
                      child: const Text(
                        'Tambah Tiket',
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                          color: Color(0xFF04181D),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                // Edit
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF44E3EF),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              EditKonserScreen(konser: widget.konser),
                        ),
                      );
                    },
                    child: const Text(
                      'Edit',
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
    );
  }
}