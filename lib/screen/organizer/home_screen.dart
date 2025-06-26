import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:intl/intl.dart';
import '../organizer/manage_konser.dart';

class OrganizerHomeScreen extends StatefulWidget {
  const OrganizerHomeScreen({Key? key}) : super(key: key);

  @override
  State<OrganizerHomeScreen> createState() => _OrganizerHomeScreenState();
}

class _OrganizerHomeScreenState extends State<OrganizerHomeScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<Map<String, dynamic>> concerts = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchConcerts();
  }

  Future<void> fetchConcerts() async {
    final response = await Supabase.instance.client
        .from('concert_table')
        .select()
        .order('concert_date', ascending: true);
    setState(() {
      concerts = List<Map<String, dynamic>>.from(response);
      isLoading = false;
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<Map<String, dynamic>> get _filteredConcerts {
    if (_searchController.text.isEmpty) return concerts;
    return concerts.where((concert) {
      final title =
          (concert['concert_name'] ?? '').toLowerCase(); // Ganti nama kolom
      return title.contains(_searchController.text.toLowerCase());
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
                      setState(() {});
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
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }
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
        return GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ManageKonserScreen(konser: concert),
              ),
            );
          },
          child: _buildConcertCard(
            title: concert['concert_name'] ?? '',
            date: concert['concert_date']?.toString() ?? '',
            venue: concert['location'] ?? '',
            artist: concert['artist'] ?? '',
            posterUrl: concert['concert_poster'] ?? '',
            sold: 'Sold 183/200', // dummy
            rating: 'Rating (5.0)', // dummy
          ),
        );
      },
    );
  }

  // Fungsi untuk format tanggal
  String formatTanggal(String tanggal) {
    try {
      final date = DateTime.parse(tanggal);
      return DateFormat('EEEE, dd MMMM yyyy')
          .format(date); // Sunday, 10 November 2024
    } catch (_) {
      return tanggal;
    }
  }

  Widget _buildConcertCard({
    required String title,
    required String date,
    required String venue,
    required String artist,
    required String posterUrl,
    required String sold,
    required String rating,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 18),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: const Color(0xFF00FFB3),
          width: 2,
        ),
        image: posterUrl.isNotEmpty
            ? DecorationImage(
                image: NetworkImage(posterUrl),
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
            // Nama Konser
            Text(
              title,
              style: const TextStyle(
                fontFamily: 'Poppins',
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color(0xFF22E6CE),
                height: 1.2,
              ),
            ),
            // Artist (style sama dengan title)
            Text(
              artist,
              style: const TextStyle(
                fontFamily: 'Poppins',
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color(0xFF22E6CE),
                height: 1.2,
              ),
            ),
            const SizedBox(height: 8),
            // Tanggal (format panjang)
            Text(
              formatTanggal(date),
              style: const TextStyle(
                fontFamily: 'Poppins',
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: Color(0xFFC8EFF8),
              ),
            ),
            // Lokasi
            Text(
              venue,
              style: const TextStyle(
                fontFamily: 'Poppins',
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: Color(0xFFC8EFF8),
              ),
            ),
            const SizedBox(height: 8),
            // Sold
            Text(
              sold,
              style: const TextStyle(
                fontFamily: 'Poppins',
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: Color(0xFFC8EFF8),
              ),
            ),
            // Rating
            Row(
              children: [
                Text(
                  rating,
                  style: const TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFFC8EFF8),
                  ),
                ),
                const SizedBox(width: 4),
                ...List.generate(
                    5,
                    (index) => const Icon(Icons.star,
                        color: Color(0xFFFFD700), size: 16)),
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
