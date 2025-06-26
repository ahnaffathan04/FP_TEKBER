import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';

// Impor file detail yang sudah kita perbarui
import './concert_detail.dart'; 

// Layar utama yang menampilkan tiket mendatang dan link ke riwayat
class MyTicketScreen extends StatelessWidget {
  const MyTicketScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF111317),
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(70),
        child: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(colors: [Color(0xFF101316), Color(0xFF161821)]),
            border: Border(bottom: BorderSide(color: Color(0xFF1D1E2D), width: 1)),
          ),
          padding: const EdgeInsets.only(top: 40, left: 16, right: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Your Ticket', style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
              const CircleAvatar(radius: 16, backgroundImage: AssetImage('assets/profile.png')),
            ],
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            const Text('Upcoming Events', style: TextStyle(color: Color(0xFF10C7EF), fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 4),
            const Text('30 November 2024', style: TextStyle(color: Colors.white)),
            const SizedBox(height: 8),
            
            // Kartu Tiket Mendatang (Sudah benar)
            GestureDetector(
              onTap: () {
                // NAVIGASI 1: Buka detail dengan form QR Code
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const ConcertDetailScreen(showFeedbackForm: false),
                  ),
                );
              },
              child: _buildUpcomingTicketCard(),
            ),
            
            const SizedBox(height: 24),
            const Text('Past Activity', style: TextStyle(color: Color(0xFF10C7EF), fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),

            // Tombol ke Riwayat Tiket (Sudah benar)
            GestureDetector(
              onTap: () {
                 Navigator.push(
                   context,
                   MaterialPageRoute(builder: (_) => const YourTicketListScreen()),
                 );
              },
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(color: const Color(0xFF1D1E2D), borderRadius: BorderRadius.circular(12)),
                child: Row(
                  children: const [
                    Icon(LucideIcons.ticket, color: Colors.white),
                    SizedBox(width: 12),
                    Expanded(child: Text('YOUR TICKET LIST', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold))),
                    Icon(LucideIcons.chevronRight, color: Colors.white),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: const Color(0xFF151623),
        selectedItemColor: const Color(0xFF10C7EF),
        unselectedItemColor: Colors.white60,
        currentIndex: 1,
        onTap: (index) {
          if (index == 0) context.go('/buyer-home');
          else if (index == 2) context.go('/buyer-home/setting');
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: ''),
          BottomNavigationBarItem(icon: Icon(LucideIcons.ticket), label: ''),
          BottomNavigationBarItem(icon: Icon(Icons.settings), label: ''),
        ],
      ),
    );
  }

  Widget _buildUpcomingTicketCard() {
    return Container(
      decoration: BoxDecoration(
        gradient: const LinearGradient(colors: [Color(0xFF22E6CE), Color(0xFF10FF8C)]),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Stack(
        children: [
          Positioned.fill(child: ClipRRect(borderRadius: BorderRadius.circular(12), child: const Opacity(opacity: 0.25))),
          const Padding(
            padding: EdgeInsets.all(12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Sisforia : TGIF!', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                SizedBox(height: 8),
                Row(children: [Icon(LucideIcons.ticket, size: 20, color: Colors.white), SizedBox(width: 8), Text('x3 Tickets', style: TextStyle(color: Colors.white))]),
                SizedBox(height: 4),
                Row(children: [Icon(LucideIcons.building2, size: 20, color: Colors.white), SizedBox(width: 8), Text('Jatim International Expo (JIE)', style: TextStyle(color: Colors.white))]),
                SizedBox(height: 8),
                Text('Purchase Successful', style: TextStyle(color: Colors.white)),
                Align(alignment: Alignment.centerRight, child: Icon(LucideIcons.chevronRight, color: Colors.white)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// Layar untuk menampilkan daftar riwayat tiket
class YourTicketListScreen extends StatelessWidget {
  const YourTicketListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF111317),
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(70),
        child: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(colors: [Color(0xFF101316), Color(0xFF161821)]),
            border: Border(bottom: BorderSide(color: Color(0xFF1D1E2D), width: 1)),
          ),
          padding: const EdgeInsets.only(top: 40, left: 16, right: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              GestureDetector(onTap: () => Navigator.pop(context), child: const Icon(Icons.arrow_back_ios, color: Color(0xFF10C7EF))),
              const Text('Your Ticket List', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
              const CircleAvatar(radius: 16, backgroundImage: AssetImage('assets/profile.png')),
            ],
          ),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // ======================= PERBAIKAN ADA DI SINI =======================
          _buildPastTicketCard(context: context, title: 'Discofest 2024', date: '14 October 2024', tickets: 'x2 Tickets', location: 'Surabaya Expo Center'),
          const SizedBox(height: 16),
          _buildPastTicketCard(context: context, title: 'ECULF 3.0', date: '7 September 2024', tickets: 'x1 Tickets', location: 'Balai Pemuda Surabaya'),
        ],
      ),
    );
  }

  // ============== DAN DI METHOD DI BAWAH INI (DIBUNGKUS GESTUREDETECTOR) ==============
  Widget _buildPastTicketCard({required BuildContext context, required String title, required String date, required String tickets, required String location}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(date, style: const TextStyle(color: Colors.white)),
        const SizedBox(height: 8),
        // 1. DIBUNGKUS DENGAN GESTUREDETECTOR
        GestureDetector(
          onTap: () {
            // 2. JALANKAN NAVIGASI DENGAN PARAMETER YANG BENAR
            Navigator.push(
              context,
              MaterialPageRoute(
                // Arahkan ke detail dengan form feedback
                builder: (context) => const ConcertDetailScreen(showFeedbackForm: true),
              ),
            );
          },
          // 3. Child-nya adalah Container kartu tiket Anda
          child: Container(
            decoration: BoxDecoration(
              gradient: const LinearGradient(colors: [Color(0xFF22E6CE), Color(0xFF10FF8C)]),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Stack(
              children: [
                Positioned.fill(child: ClipRRect(borderRadius: BorderRadius.circular(12), child: const Opacity(opacity: 0.25))),
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(title, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 8),
                      Row(children: [const Icon(LucideIcons.ticket, size: 20, color: Colors.white), const SizedBox(width: 8), Text(tickets, style: const TextStyle(color: Colors.white))]),
                      const SizedBox(height: 4),
                      Row(children: [const Icon(LucideIcons.building2, size: 20, color: Colors.white), const SizedBox(width: 8), Text(location, style: const TextStyle(color: Colors.white))]),
                      const Align(alignment: Alignment.centerRight, child: Icon(LucideIcons.chevronRight, color: Colors.white)),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
