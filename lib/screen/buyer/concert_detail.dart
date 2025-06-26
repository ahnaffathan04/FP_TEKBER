import 'package:flutter/material.dart';

class ConcertDetailScreen extends StatelessWidget {
  const ConcertDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF111317),
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFF101316), Color(0xFF161821)],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
                border: Border(
                  bottom: BorderSide(color: Color(0xFF1D1E2D), width: 1),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: const Icon(Icons.arrow_back, color: Colors.white),
                  ),
                  Text(
                    'Your Ticket',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      foreground: Paint()
                        ..shader = const LinearGradient(
                          colors: [Colors.white, Color(0xFFC105FF)],
                        ).createShader(const Rect.fromLTWH(0, 0, 200, 70)),
                    ),
                  ),
                  const CircleAvatar(
                    radius: 18,
                    backgroundImage: AssetImage('assets/images/profile.jpg'),
                  ),
                ],
              ),
            ),

            Expanded(
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  const SizedBox(height: 10),
                  const Text(
                    'Order No.1234567890',
                    style: TextStyle(
                      color: Color(0xFFC105FF),
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),

                  Container(
                    decoration: BoxDecoration(
                      color: const Color(0xFF1D1E2D),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.all(16),
                    child: const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        InfoRow(label: 'Purchased', value: 'Fri, 15 Nov 2024'),
                        InfoRow(label: 'Payment Method', value: 'DANA'),
                        InfoRow(label: 'Total Price', value: 'Rp280.000,00 (x3 Tickets)'),
                        SizedBox(height: 12),
                        Text('Your Seat', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                        SizedBox(height: 6),
                        Text('VIP A4\nVIP A5\nCAT1 B5', style: TextStyle(color: Colors.white)),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

                  const Text(
                    'Event Details',
                    style: TextStyle(
                      color: Color(0xFFC105FF),
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Container(
                    decoration: BoxDecoration(
                      color: const Color(0xFF1D1E2D),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.all(16),
                    child: const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        InfoRow(label: 'Date', value: 'Sat 30 Nov 2024'),
                        InfoRow(label: 'Venue', value: 'Jatim International Expo (JIE)'),
                        InfoRow(label: 'Lineup', value: 'Sisforia'),
                        SizedBox(height: 12),
                        Text('Rundown :', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                        SizedBox(height: 4),
                        Text(
                          '18.00 - 18.15   Opening\n'
                          '18.15 - 19.15   Sisforia\n'
                          '19.15 - 19.30   Closing',
                          style: TextStyle(color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

                  const Text(
                    'Feedback',
                    style: TextStyle(
                      color: Color(0xFFC105FF),
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: const Color(0xFF1D1E2D),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Text(
                      'Anda belum dapat mengisi feedback karena konser belum berjalan',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  const SizedBox(height: 24),

                  Center(
                    child: Column(
                      children: [
                        Container(
                          width: double.infinity,
                          height: 1,
                          margin: const EdgeInsets.symmetric(vertical: 12),
                          child: CustomPaint(painter: DashedLinePainter()),
                        ),
                        const SizedBox(height: 12),
                        const Text('Scan QR ketika di tempat', style: TextStyle(color: Color(0xFFC105FF))),
                        const SizedBox(height: 12),
                        Center(
                          child: Image.asset(
                            'assets/images/qr-code.png',
                            width: 150,
                            height: 150,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: const Color(0xFF151623),
        selectedItemColor: const Color(0xFFC105FF),
        unselectedItemColor: Colors.white60,
        currentIndex: 1,
        onTap: (index) {
          if (index == 0) {
            Navigator.pushNamedAndRemoveUntil(context, '/homebuyer', (route) => false);
          } else if (index == 1) {
            // Stay on current screen
          } else if (index == 2) {
            Navigator.pushNamed(context, '/homebuyer/setting');
          }
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: ''),
          BottomNavigationBarItem(icon: Icon(Icons.confirmation_number), label: ''),
          BottomNavigationBarItem(icon: Icon(Icons.settings), label: ''),
        ],
      ),
    );
  }
}

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
            child: Text(value, textAlign: TextAlign.right, style: const TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}

class DashedLinePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    const dashWidth = 5.0;
    const dashSpace = 5.0;
    final paint = Paint()
      ..color = const Color(0xFFC105FF)
      ..strokeWidth = 1;

    double startX = 0;
    while (startX < size.width) {
      canvas.drawLine(Offset(startX, 0), Offset(startX + dashWidth, 0), paint);
      startX += dashWidth + dashSpace;
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}