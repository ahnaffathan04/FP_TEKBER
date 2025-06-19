import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF111317),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: const Color(0xFF151623),
        selectedItemColor: const Color(0xFFC105FF),
        unselectedItemColor: Colors.white,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.confirmation_num),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: '',
          ),
        ],
        currentIndex: 0,
        onTap: (index) {
          if (index == 0) {
            // Already on home
          } else if (index == 1) {
            Navigator.pushNamed(context, '/myticket');
          } else if (index == 2) {
            Navigator.pushNamed(context, '/buyer-home/setting');
          }
        },
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: ListView(
            children: [
              // Header Logo + Profile
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'FestiPass',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      foreground: Paint()
                        ..shader = const LinearGradient(
                          colors: [Colors.pink, Color(0xFFC105FF)],
                        ).createShader(const Rect.fromLTWH(0.0, 0.0, 200.0, 70.0)),
                    ),
                  ),
                  const CircleAvatar(
                    radius: 20,
                    backgroundImage: AssetImage('assets/images/profile.jpg'),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Search bar
              Container(
                decoration: BoxDecoration(
                  color: const Color(0xFFB9B9C3), // Search bar color
                  borderRadius: BorderRadius.circular(30),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: const TextField(
                  decoration: InputDecoration(
                    hintText: 'Search here..',
                    hintStyle: TextStyle(color: Colors.white70),
                    border: InputBorder.none,
                    icon: Icon(Icons.search, color: Colors.white),
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Filter location
              Container(
                decoration: BoxDecoration(
                  color: const Color(0xFF1D1E2D),
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: Row(
                  children: const [
                    Icon(Icons.location_on, color: Colors.white),
                    SizedBox(width: 8),
                    Text(
                      'Surabaya',
                      style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                    Spacer(),
                    Icon(Icons.expand_more, color: Colors.white),
                  ],
                ),
              ),
              const SizedBox(height: 12),

              // Filter chips
              Wrap(
                spacing: 10,
                children: const [
                  FilterChipWidget(label: 'Artist'),
                  FilterChipWidget(label: 'Genre'),
                  FilterChipWidget(label: 'Location'),
                  FilterChipWidget(label: 'Price'),
                ],
              ),
              const SizedBox(height: 24),

              // Showing Now
              gradientTitle("Showing Now"),
              const SizedBox(height: 12),
              buildConcertGrid([
                ConcertCard(title: "EXSIST 2.0\nBernadya", imagePath: "assets/images/exsist.jpg"),
                ConcertCard(title: "Sisforia:\nTGIF!", imagePath: "assets/images/sisforia.jpg"),
              ]),
              const SizedBox(height: 24),

              // Coming Soon
              gradientTitle("Coming Soon"),
              const SizedBox(height: 12),
              buildConcertGrid([
                ConcertCard(title: "Buzz Youth Fest\nSheila On 7, RAN, dll", imagePath: "assets/images/buzz.jpg"),
                ConcertCard(title: "Onfest 2024\nTipe-X, Juicy Luicy, dll", imagePath: "assets/images/onfest.jpg"),
              ]),
            ],
          ),
        ),
      ),
    );
  }

  Widget gradientTitle(String title) {
    return Text(
      title,
      style: TextStyle(
        fontSize: 22,
        fontWeight: FontWeight.bold,
        foreground: Paint()
          ..shader = const LinearGradient(
            colors: [Colors.white, Color(0xFFC105FF)],
          ).createShader(const Rect.fromLTWH(0.0, 0.0, 200.0, 70.0)),
      ),
    );
  }

  Widget buildConcertGrid(List<ConcertCard> cards) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: cards.map((card) => Expanded(child: card)).toList(),
    );
  }
}

class FilterChipWidget extends StatelessWidget {
  final String label;

  const FilterChipWidget({super.key, required this.label});

  @override
  Widget build(BuildContext context) {
    return Chip(
      label: Text(label),
      backgroundColor: const Color(0xFF1D1E2D),
      labelStyle: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
    );
  }
}

class ConcertCard extends StatelessWidget {
  final String title;
  final String imagePath;

  const ConcertCard({super.key, required this.title, required this.imagePath});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.pop(context);
      },
      child: Container(
        margin: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          border: Border.all(color: const Color(0xFF22E6CE), width: 2),
          borderRadius: BorderRadius.circular(12),
          image: DecorationImage(
            image: AssetImage(imagePath),
            fit: BoxFit.cover,
            colorFilter: ColorFilter.mode(Colors.black.withOpacity(0.3), BlendMode.darken),
          ),
        ),
        height: 160,
        child: Align(
          alignment: Alignment.bottomLeft,
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Text(
              title,
              style: const TextStyle(
                color: Color(0xFF22E6CE),
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
