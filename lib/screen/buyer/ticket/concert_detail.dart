import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:lucide_icons/lucide_icons.dart';

// Class utama yang cerdas, bisa menampilkan QR atau Feedback
class ConcertDetailScreen extends StatefulWidget {
  // Parameter untuk menentukan konten yang akan ditampilkan
  final bool showFeedbackForm;

  const ConcertDetailScreen({
    super.key,
    this.showFeedbackForm = false, // Default: tampilkan QR Code
  });

  @override
  State<ConcertDetailScreen> createState() => _ConcertDetailScreenState();
}

class _ConcertDetailScreenState extends State<ConcertDetailScreen> {
  // State untuk form feedback
  double _rating = 0;
  final TextEditingController _feedbackController = TextEditingController();

  @override
  void dispose() {
    _feedbackController.dispose();
    super.dispose();
  }

  // Fungsi untuk menampilkan dialog sukses
  void _showSuccessDialog() {
    showDialog(
      context: context,
      barrierDismissible: false, // User harus menekan tombol OK
      builder: (BuildContext dialogContext) {
        // Menggunakan dialogContext agar jelas
        return Dialog(
          backgroundColor: Colors.transparent,
          child: Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: const Color(0xFF1D1E2D),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: const Color(0xFF10C7EF), width: 1.5),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const CircleAvatar(
                  radius: 30,
                  backgroundColor: Color(0x3322E6CE),
                  child: Icon(Icons.check, color: Color(0xFF22E6CE), size: 35),
                ),
                const SizedBox(height: 20),
                const Text(
                  'Your Feedback has been Sent!',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: 100,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF10C7EF),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    onPressed: () {
                      // ======== PERBAIKAN ADA DI SINI ========
                      // Pop pertama untuk menutup dialog
                      Navigator.of(dialogContext).pop();
                      // Pop kedua untuk kembali dari ConcertDetailScreen ke halaman sebelumnya
                      Navigator.of(context).pop();
                    },
                    child: const Text(
                      'OK',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF111317),
      body: SafeArea(
        child: Column(
          children: [
            // Header (Tidak berubah)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: const Icon(Icons.arrow_back, color: Colors.white),
                  ),
                  const Text(
                    'Your Ticket',
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                  const CircleAvatar(
                    radius: 18,
                    backgroundImage:
                        AssetImage('assets/profile.png'), // Sesuaikan path
                  ),
                ],
              ),
            ),
            // Konten utama yang bisa di-scroll
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                children: [
                  const SizedBox(height: 10),
                  const Text('Order No.1234567890',
                      style: TextStyle(
                          color: Color(0xFFC105FF),
                          fontSize: 16,
                          fontWeight: FontWeight.bold)),
                  const SizedBox(height: 12),
                  // Box info tiket
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                        color: const Color(0xFF1D1E2D),
                        borderRadius: BorderRadius.circular(12)),
                    child: const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        InfoRow(label: 'Purchased', value: 'Fri, 15 Nov 2024'),
                        InfoRow(label: 'Payment Method', value: 'DANA'),
                        InfoRow(
                            label: 'Total Price',
                            value: 'Rp280.000,00 (x3 Tickets)'),
                        SizedBox(height: 12),
                        Text('Your Seat',
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold)),
                        SizedBox(height: 6),
                        Text('VIP A4\nVIP A5\nCAT1 B5',
                            style: TextStyle(color: Colors.white)),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  // Box event details
                  const Text('Event Details',
                      style: TextStyle(
                          color: Color(0xFFC105FF),
                          fontSize: 16,
                          fontWeight: FontWeight.bold)),
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                        color: const Color(0xFF1D1E2D),
                        borderRadius: BorderRadius.circular(12)),
                    child: const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        InfoRow(label: 'Date', value: 'Sat 30 Nov 2024'),
                        InfoRow(
                            label: 'Venue',
                            value: 'Jatim International Expo (JIE)'),
                        InfoRow(label: 'Lineup', value: 'Sisforia'),
                        SizedBox(height: 12),
                        Text('Rundown :',
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold)),
                        SizedBox(height: 4),
                        Text(
                            '18.00 - 18.15    Opening\n18.15 - 19.15    Sisforia\n19.15 - 19.30    Closing',
                            style: TextStyle(color: Colors.white)),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

                  // KONTEN KONDISIONAL: Menampilkan widget berdasarkan parameter
                  if (widget.showFeedbackForm)
                    _buildFeedbackSection()
                  else
                    _buildQrSection(),

                  const SizedBox(height: 24),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Widget untuk menampilkan QR Code (untuk acara mendatang)
  Widget _buildQrSection() {
    return Column(
      children: [
        const Text('Feedback',
            style: TextStyle(
                color: Color(0xFFC105FF),
                fontSize: 16,
                fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
              color: const Color(0xFF1D1E2D),
              borderRadius: BorderRadius.circular(12)),
          child: const Text(
              'Anda belum dapat mengisi feedback karena konser belum berjalan',
              style: TextStyle(color: Colors.white)),
        ),
        const SizedBox(height: 24),
        Center(
          child: Column(
            children: [
              Container(
                  width: double.infinity,
                  height: 1,
                  margin: const EdgeInsets.symmetric(vertical: 12),
                  child: CustomPaint(painter: DashedLinePainter())),
              const SizedBox(height: 12),
              const Text('Scan QR ketika di tempat',
                  style: TextStyle(color: Color(0xFFC105FF))),
              const SizedBox(height: 12),
              Image.asset('assets/images/qr-code.png', width: 150, height: 150),
            ],
          ),
        ),
      ],
    );
  }

  // Widget untuk menampilkan form feedback (untuk acara yang sudah selesai)
  Widget _buildFeedbackSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Feedback',
            style: TextStyle(
                color: Color(0xFFC105FF),
                fontWeight: FontWeight.bold,
                fontSize: 16)),
        const SizedBox(height: 8),
        Center(
          child: RatingBar.builder(
            initialRating: _rating,
            minRating: 1,
            itemCount: 5,
            unratedColor: Colors.white24,
            itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
            itemBuilder: (context, _) =>
                const Icon(Icons.star, color: Colors.amber),
            onRatingUpdate: (value) => setState(() => _rating = value),
          ),
        ),
        const SizedBox(height: 12),
        TextField(
          controller: _feedbackController,
          maxLines: 4,
          style: const TextStyle(color: Colors.white),
          decoration: InputDecoration(
            hintText: 'Isi komentar disini',
            hintStyle: const TextStyle(color: Colors.white54),
            filled: true,
            fillColor: const Color(0xFF1D1E2D),
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none),
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          width: double.infinity,
          height: 48,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.transparent,
              padding: EdgeInsets.zero,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
              elevation: 0,
            ),
            onPressed: () {
              // TODO: Simpan data feedback ke database
              print('Rating: $_rating, Feedback: ${_feedbackController.text}');

              // Tampilkan dialog sukses
              _showSuccessDialog();

              // Reset form
              _feedbackController.clear();
              setState(() => _rating = 0);
            },
            child: Ink(
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                    colors: [Color(0xFF00D1FF), Color(0xFF0077FF)]),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Center(
                child: Text('Post',
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold)),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

// Helper widgets (tidak berubah)
class InfoRow extends StatelessWidget {
  final String label;
  final String value;
  const InfoRow({super.key, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: Colors.white)),
          const SizedBox(width: 12),
          Expanded(
              child: Text(value,
                  textAlign: TextAlign.right,
                  style: const TextStyle(color: Colors.white))),
        ],
      ),
    );
  }
}

class DashedLinePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFFC105FF)
      ..strokeWidth = 1;
    double startX = 0;
    while (startX < size.width) {
      canvas.drawLine(Offset(startX, 0), Offset(startX + 5.0, 0), paint);
      startX += 5.0 + 5.0;
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
