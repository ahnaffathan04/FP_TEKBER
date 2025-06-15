// lib/screens/book_ticket_overview_screen.dart (perubahan)
import 'package:flutter/material.dart';

class BookTicketOverviewScreen extends StatelessWidget {
  const BookTicketOverviewScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Booking'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new),
          onPressed: () {
            // Navigator.pop(context); // If there's a previous screen
          },
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            _buildShowDetailsCard(context),
            const SizedBox(height: 20),
            // Menggunakan gambar untuk denah tempat duduk
            _buildSeatMapOverview(context),
            const SizedBox(height: 20),
            Text('Select Seat Category', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 10),
            _buildCategoryRow(context, 'VVIP', 'RP900K', Colors.purple, false),
            _buildCategoryRow(context, 'CAT 1', 'RP600K', Colors.pink, false),
            _buildCategoryRow(context, 'CAT 2', 'RP450K', Colors.blue, false),
            _buildCategoryRow(context, 'CAT 3', 'RP300K', Colors.green, true), // Sold out
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Information is not available yet!')),
                  );
                },
                // Tambahkan styleFrom untuk mengatur warna
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF2E323D), // Warna latar belakang seperti di gambar (dark blue-gray)
                  foregroundColor: const Color(0xFF00D4FF), // Warna teks cyan
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12), // Sesuaikan radius jika perlu
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 16), // Sesuaikan padding jika perlu
                ),
                child: const Text('About Concert', style: TextStyle(fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildShowDetailsCard(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1F2E),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('SISFORIA: TGIF!', style: Theme.of(context).textTheme.bodyLarge),
              const Icon(Icons.info_outline, color: Colors.white70),
            ],
          ),
          const SizedBox(height: 8),
          Text('MUSIC SHOW', style: Theme.of(context).textTheme.bodyMedium),
          const SizedBox(height: 15),
          Row(
            children: [
              const Icon(Icons.calendar_today, size: 16, color: Colors.white70),
              const SizedBox(width: 8),
              Text('28 November 2021', style: Theme.of(context).textTheme.bodyMedium),
              const Spacer(),
              const Icon(Icons.access_time, size: 16, color: Colors.white70),
              const SizedBox(width: 8),
              Text('09:00 PM', style: Theme.of(context).textTheme.bodyMedium),
            ],
          ),
        ],
      ),
    );
  }

  // Menggunakan gambar untuk denah tempat duduk
  Widget _buildSeatMapOverview(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 200, // Sesuaikan tinggi sesuai kebutuhan gambar
      decoration: BoxDecoration(
        color: const Color(0xFF1A1F2E),
        borderRadius: BorderRadius.circular(12),
      ),
      child: ClipRRect( // ClipRRect untuk menerapkan borderRadius pada gambar
        borderRadius: BorderRadius.circular(12),
        child: Image.asset(
          'assets/images/layout-stage1.png',
          fit: BoxFit.contain, // Sesuaikan fit sesuai kebutuhan
          // Tambahkan colorBlendMode atau color jika ingin mengubah warna gambar
          // color: Colors.white.withOpacity(0.8),
          // colorBlendMode: BlendMode.modulate,
        ),
      ),
    );
  }

  Widget _buildCategoryRow(BuildContext context, String category, String price, Color color, bool isSoldOut) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: GestureDetector(
        onTap: () {
          if (isSoldOut) {
            Navigator.pushNamed(context, '/sold_out');
          } else {
            Navigator.pushNamed(context, '/category_booking', arguments: {
              'category': category,
              'price': _getPriceFromString(price),
              'color': color,
            });
          }
        },
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: const Color(0xFF1A1F2E),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.transparent),
          ),
          child: Row(
            children: [
              Container(
                width: 24,
                height: 24,
                decoration: BoxDecoration(
                  color: isSoldOut ? Colors.grey : color,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
              const SizedBox(width: 16),
              Text(
                category,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: isSoldOut ? Colors.grey : Colors.white,
                    ),
              ),
              const Spacer(),
              if (isSoldOut)
                Text(
                  'SOLD OUT',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.red),
                )
              else
                Text(price, style: Theme.of(context).textTheme.bodyMedium),
              const SizedBox(width: 8),
              Icon(
                Icons.arrow_forward_ios,
                size: 16,
                color: isSoldOut ? Colors.grey : Colors.white70,
              ),
            ],
          ),
        ),
      ),
    );
  }

  double _getPriceFromString(String priceStr) {
    // Convert RP900K to actual price
    switch (priceStr) {
      case 'RP900K':
        return 900000.0;
      case 'RP600K':
        return 600000.0;
      case 'RP450K':
        return 450000.0;
      case 'RP300K':
        return 300000.0;
      default:
        return 0.0;
    }
  }
}