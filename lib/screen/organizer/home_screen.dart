import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class OrganizerHomeScreen extends StatefulWidget {
  const OrganizerHomeScreen({Key? key}) : super(key: key);

  @override
  State<OrganizerHomeScreen> createState() => _OrganizerHomeScreenState();
}

class _OrganizerHomeScreenState extends State<OrganizerHomeScreen> {
  final TextEditingController _searchController = TextEditingController();

  final List<Map<String, String>> concerts = [
    {
      'title': 'Sisforia : TGIF!\nSisforia',
      'date': 'Sunday, 10 November 2024',
      'venue': 'Jatim International Expo (JIE)',
      'sold': 'Sold 183/200',
      'image': 'organizer/concert1.png',
      'rating': 'Rating (5.0)',
    },
    {
      'title': 'EXSIST 2.0\nBernadya',
      'date': 'Thursday, 12 December 2024',
      'venue': 'Balai Pemuda Surabaya',
      'sold': 'Sold : 115/300',
      'image': 'organizer/concert2.png',
      'rating': 'Rating (5.0)',
    },
    {
      'title': 'Onfest 2024\nTipe-X, Juicy Luicy, dll',
      'date': 'Saturday, 30 November 2024',
      'venue': 'PTC Surabaya',
      'sold': 'Sold : 285/300',
      'image': 'organizer/concert3.png',
      'rating': 'Rating (5.0)',
    },
    {
      'title': 'Buzz Youth Fest\nSheila On 7, RAN, dll',
      'date': 'Saturday, 25 January 2025',
      'venue': 'Lap. Bhumi Marinir Karangpilang, Surabaya',
      'sold': 'Sold : 310/400',
      'image': 'organizer/concert4.png',
      'rating': 'Rating (5.0)',
    },
  ];

  String _searchText = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<Map<String, String>> get _filteredConcerts {
    if (_searchText.isEmpty) return concerts;
    return concerts.where((concert) {
      final title = concert['title']!.toLowerCase();
      return title.contains(_searchText.toLowerCase());
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0E0F1A),
      body: SafeArea(
        child: Stack(
          children: [
            // Main content
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildHeader(),
                  const SizedBox(height: 8),
                  _buildSearchSection(),
                  const SizedBox(height: 24),
                  Expanded(
                    child: _buildConcertList(),
                  ),
                ],
              ),
            ),
            // Floating camera button
            Positioned(
              bottom: 100,
              right: 16,
              child: _buildFloatingCameraButton(),
            ),
            // Bottom navigation
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: _buildBottomNavigation(context),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Stack(
      children: [
        Positioned(
          top: 0,
          right: 0,
          child: Image.asset(
            'organizer/GradientBG.png',
            width: 150,
            height: 150,
            fit: BoxFit.fill,
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 8, bottom: 1, top: 32),
          child: Row(
            children: [
              Container(
                width: 42,
                height: 42,
                margin: const EdgeInsets.symmetric(vertical: 17),
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  image: DecorationImage(
                    image: AssetImage('profile.png'),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Welcome back',
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Color(0xFFC9EFF8),
                    ),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'John!',
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 24,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSearchSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 6),
        Container(
          width: double.infinity,
          height: 53,
          decoration: BoxDecoration(
            color: const Color(0xFF1A1B2E),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: const Color.fromARGB(26, 255, 255, 255), // 0.1 opacity
              width: 1,
            ),
          ),
          child: Row(
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: TextField(
                    controller: _searchController,
                    style: const TextStyle(
                      color: Colors.white,
                      fontFamily: 'Poppins',
                    ),
                    decoration: const InputDecoration(
                      hintText: 'Search here..',
                      hintStyle: TextStyle(
                        color: Color(0xFF8F9BB3),
                        fontSize: 14,
                      ),
                      border: InputBorder.none,
                    ),
                    onChanged: (value) {
                      setState(() {
                        _searchText = value;
                      });
                    },
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(right: 16),
                child: Icon(
                  Icons.search,
                  color: const Color(0xFF8F9BB3),
                  size: 20,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildConcertList() {
    final filteredConcerts = _filteredConcerts;
    if (filteredConcerts.isEmpty) {
      return const Center(
        child: Text(
          'No concert found.',
          style: TextStyle(
            color: Colors.white54,
            fontFamily: 'Poppins',
            fontSize: 16,
          ),
        ),
      );
    }
    return ListView.builder(
      itemCount: filteredConcerts.length,
      itemBuilder: (context, index) {
        final concert = filteredConcerts[index];
        return _buildConcertCard(
          title: concert['title']!,
          date: concert['date']!,
          venue: concert['venue']!,
          sold: concert['sold']!,
          imagePath: concert['image']!,
          rating: concert['rating']!,
        );
      },
    );
  }

  Widget _buildConcertCard({
    required String title,
    required String date,
    required String venue,
    required String sold,
    required String imagePath,
    required String rating,
  }) {
    return Container(
      width: 333,
      height: 150,
      margin: const EdgeInsets.only(bottom: 18),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: const Color(0xFF00FFB3),
          width: 2,
        ),
        image: imagePath.isNotEmpty
            ? DecorationImage(
                image: AssetImage(imagePath),
                fit: BoxFit.cover,
                colorFilter: ColorFilter.mode(
                  Colors.black.withOpacity(0.4),
                  BlendMode.darken,
                ),
              )
            : null,
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ShaderMask(
              shaderCallback: (Rect bounds) {
                return const LinearGradient(
                  colors: [Color(0xFF22E6CE), Color(0xFF10FF8C)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ).createShader(bounds);
              },
              child: Text(
                title,
                style: const TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 17.77,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  height: 1.2,
                ),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              '$date\n$venue\n$sold',
              style: const TextStyle(
                fontFamily: 'Poppins',
                fontSize: 10,
                fontWeight: FontWeight.w600,
                color: Color(0xFF32BDAC),
                height: 1.4,
              ),
            ),
            const SizedBox(height: 4),
            Row(
              children: [
                Text(
                  rating,
                  style: const TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF32BDAC),
                  ),
                ),
                const Icon(
                  Icons.star,
                  color: Color(0xFFFFD700),
                  size: 8,
                ),
                const SizedBox(width: 4),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFloatingCameraButton() {
    return Container(
      width: 47,
      height: 47,
      decoration: const BoxDecoration(
        color: Color(0xFF545C8D),
        shape: BoxShape.circle,
      ),
      child: Center(
        child: Image.asset(
          'organizer/Camera.png',
          width: 24,
          height: 24,
        ),
      ),
    );
  }

  Widget _buildBottomNavigation(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 60,
      decoration: BoxDecoration(
        color: const Color(0xFF1A1B2E),
        border: Border(
          top: BorderSide(
            width: 1,
            color: Colors.white12,
          ),
        ),
      ),
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 28),
            child: Image.asset(
              'organizer/navbar/Home.png',
              width: 32,
              height: 32,
            ),
          ),
          Expanded(
            child: Center(
              child: GestureDetector(
                behavior: HitTestBehavior.translucent,
                onTap: () {
                  context.push('/tambah-konser');
                },
                child: Image.asset(
                  'organizer/navbar/Plus.png',
                  width: 32,
                  height: 32,
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 28),
            child: Image.asset(
              'organizer/navbar/Settings.png',
              width: 32,
              height: 32,
            ),
          ),
        ],
      ),
    );
  }
}
