import 'package:ezrameeting2tekber/screen/organizer/tambah_tiket.dart';
import 'package:flutter/material.dart';
import 'edit_konser.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:provider/provider.dart';
import 'providers/concert_provider.dart';

class ManageKonserScreen extends StatefulWidget {
  final Map<String, dynamic> concert_table;
  const ManageKonserScreen({Key? key, required this.concert_table}) : super(key: key);

  @override
  _ManageKonserScreenState createState() => _ManageKonserScreenState();
}

class _ManageKonserScreenState extends State<ManageKonserScreen> {
  bool isLoading = false;
  List<Map<String, dynamic>> tickets = [];

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      Provider.of<ConcertProvider>(context, listen: false)
          .setConcert(widget.concert_table);
      fetchTickets();
    });
  }

Future<void> fetchTickets() async {
  try {
    final concert = Provider.of<ConcertProvider>(context, listen: false).concert;
    final concertId = concert['concert_id'];

    final response = await Supabase.instance.client
        .from('concert_ticket')
        .select('category, availability') // hanya ambil data yg dibutuhkan
        .eq('concert_id', concertId);

    setState(() {
      tickets = List<Map<String, dynamic>>.from(response);
    });
  } catch (e) {
    print('Error fetching tickets: $e');
  }
}


  @override
  Widget build(BuildContext context) {
    final concert = Provider.of<ConcertProvider>(context).concert;

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
                image: concert['concert_poster'] != null &&
                        concert['concert_poster'] != ''
                    ? DecorationImage(
                        image: NetworkImage(concert['concert_poster']),
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
                    // TODO: Navigasi ke halaman ulasan
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
              concert['concert_name'] ?? '',
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
              formatTanggal(concert['concert_date'] ?? ''),
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
              concert['location'] ?? '',
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
                '• ${concert['artist'] ?? ''}',
                style: const TextStyle(
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
              concert['description'] ?? '',
              style: const TextStyle(
                color: Colors.white,
                fontFamily: 'Poppins',
                fontWeight: FontWeight.normal,
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 12),
            // Ticket Availability Section
            const Text(
              'Tiket Tersedia',
              style: TextStyle(
                color: Color(0xFFC8EFF8),
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w600,
                fontSize: 13,
              ),
            ),
            tickets.isEmpty
              ? const Text('Tidak ada tiket tersedia.')
              : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: tickets.map((ticket) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 2.0),
                    child: Text(
                      '${ticket['category'] ?? 'Tiket'}: ${ticket['availability']} tersedia',
                      style: const TextStyle(
                        color: Colors.white,
                    fontSize: 15,
                  ),
                ),
              );
            }).toList(),
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
                                  .from('concert_table')
                                  .delete()
                                  .eq('concert_id', concert['concert_id']); 
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
                      onPressed: () async {
                        await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => TambahTiketScreen(),
                          ),
                        );
                        // Refresh tickets after returning from TambahTiketScreen
                        fetchTickets();
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
                    onPressed: () async {
                      await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => EditKonserScreen(
                            concert_table: Provider.of<ConcertProvider>(context, listen: false).concert,
                          ),
                        ),
                      );
                      // No need to setState or update widget.concert_table!
                      // The UI will rebuild automatically because Provider notifies listeners.
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