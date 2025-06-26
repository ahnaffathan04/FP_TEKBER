import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class TicketOverviewScreen extends StatelessWidget {
  const TicketOverviewScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF111317),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Color(0xFF44E3EF)),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Sisforia : TGIF!',
          style: TextStyle(
            color: Color(0xFF44E3EF),
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        elevation: 0,
      ),
      body: Column(
        children: [
          // STAGE IMAGE
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12),
            child: Image.asset(
              'assets/images/stage_seat.png', // gunakan gambar yang Anda upload
              fit: BoxFit.contain,
            ),
          ),
          // TICKET CATEGORIES
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: const [
                TicketCategoryCard(
                  color: Color(0xFFD132EB),
                  icon: Icons.star,
                  label: 'REGULAR EARLY',
                  soldInfo: '30/30 SOLD',
                  price: 'RP80K',
                ),
                TicketCategoryCard(
                  color: Color(0xFF10C7EF),
                  icon: Icons.favorite,
                  label: 'VIP EARLY',
                  soldInfo: '20/20 SOLD',
                  price: 'RP110K',
                ),
                TicketCategoryCard(
                  color: Color(0xFF44E3EF),
                  icon: Icons.radio_button_checked,
                  label: 'REGULAR',
                  soldInfo: '93/110 SOLD',
                  price: 'RP90K',
                ),
                TicketCategoryCard(
                  color: Color(0xFFF1F345),
                  icon: Icons.verified,
                  label: 'VIP',
                  soldInfo: '40/40 SOLD',
                  price: 'RP130K',
                ),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: const Color(0xFF151623),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home, color: Colors.white),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add_circle, color: Color(0xFF44E3EF), size: 36),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings, color: Colors.white),
            label: '',
          ),
        ],
      ),
    );
  }
}

class TicketCategoryCard extends StatelessWidget {
  final Color color;
  final IconData icon;
  final String label;
  final String soldInfo;
  final String price;

  const TicketCategoryCard({
    super.key,
    required this.color,
    required this.icon,
    required this.label,
    required this.soldInfo,
    required this.price,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1D1E2D),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              CircleAvatar(
                backgroundColor: color,
                child: Icon(icon, color: Colors.black),
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    soldInfo,
                    style: const TextStyle(color: Colors.white70, fontSize: 12),
                  ),
                ],
              ),
            ],
          ),
          Text(
            price,
            style: TextStyle(
              color: color,
              fontWeight: FontWeight.bold,
            ),
          ),
          Icon(Icons.chevron_right, color: color)
        ],
      ),
    );
  }
}
