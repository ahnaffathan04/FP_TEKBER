import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ConcertWithTicket {
  final int concertId;
  final String concertName;
  final String concertDate;
  final String location;
  final int filled;
  final int availability;
  final String concertPoster;

  ConcertWithTicket({
    required this.concertId,
    required this.concertName,
    required this.concertDate,
    required this.location,
    required this.filled,
    required this.availability,
    required this.concertPoster,
  });

  factory ConcertWithTicket.fromMap(Map<String, dynamic> map) {
    return ConcertWithTicket(
      concertId: map['concert_id'],
      concertName: map['concert_name'] ?? '',
      concertDate: map['concert_date'] ?? '',
      location: map['location'] ?? '',
      filled: map['concert_ticket'] != null && map['concert_ticket'].isNotEmpty
          ? map['concert_ticket'][0]['filled'] ?? 0
          : 0,
      availability:
          map['concert_ticket'] != null && map['concert_ticket'].isNotEmpty
              ? map['concert_ticket'][0]['availability'] ?? 0
              : 0,
      concertPoster: map['concert_poster'] ?? '',
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Future<List<ConcertWithTicket>> concertListFuture;
  final TextEditingController _searchController = TextEditingController();
  List<ConcertWithTicket> _allConcerts = [];
  List<ConcertWithTicket> _filteredConcerts = [];

  @override
  void initState() {
    super.initState();
    concertListFuture = fetchConcerts();
    concertListFuture.then((list) {
      setState(() {
        _allConcerts = list;
        _filteredConcerts = list;
      });
    });
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      _filteredConcerts = _allConcerts.where((concert) {
        return concert.concertName.toLowerCase().contains(query) ||
            concert.concertDate.toLowerCase().contains(query) ||
            concert.location.toLowerCase().contains(query);
      }).toList();
    });
  }

  Future<List<ConcertWithTicket>> fetchConcerts() async {
    final response = await Supabase.instance.client
        .from('concert_table')
        .select(
            'concert_id, concert_name, concert_date, location, concert_poster, concert_ticket(filled, availability)')
        .order('concert_date', ascending: true);

    return (response as List)
        .map((item) => ConcertWithTicket.fromMap(item as Map<String, dynamic>))
        .toList();
  }

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
            context.go('/myticket');
          } else if (index == 2) {
            context.go('/buyer-home/setting');
          }
        },
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: FutureBuilder<List<ConcertWithTicket>>(
            future: concertListFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }
              if (snapshot.hasError) {
                return Center(
                  child: Text(
                    'Error: ${snapshot.error}',
                    style: TextStyle(color: Colors.white),
                  ),
                );
              }
              final concertList = _filteredConcerts;
              if (concertList.isEmpty) {
                return const Center(
                  child: Text(
                    'No concerts found.',
                    style: TextStyle(color: Colors.white),
                  ),
                );
              }
              return ListView(
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
                            ).createShader(
                              const Rect.fromLTWH(0.0, 0.0, 200.0, 70.0),
                            ),
                        ),
                      ),
                      const CircleAvatar(
                        radius: 20,
                        backgroundImage:
                            AssetImage('assets/images/profile.jpg'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Search bar
                  Container(
                    decoration: BoxDecoration(
                      color: const Color(0xFFB9B9C3),
                      borderRadius: BorderRadius.circular(30),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: TextField(
                      controller: _searchController,
                      style: const TextStyle(color: Colors.white),
                      decoration: const InputDecoration(
                        hintText: 'Search here..',
                        hintStyle: TextStyle(color: Colors.white70),
                        border: InputBorder.none,
                        icon: Icon(Icons.search, color: Colors.black54),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),

                  gradientTitle("All Concerts"),
                  const SizedBox(height: 12),
                  ...concertList.map(
                    (concert) => ConcertSimpleCard(
                      concertName: concert.concertName,
                      concertDate: concert.concertDate,
                      location: concert.location,
                      filled: concert.filled,
                      availability: concert.availability,
                      concertPoster: concert.concertPoster,
                      onTap: () {
                        context.go(
                          '/book-ticket-overview',
                          extra: {
                            'concertId': concert.concertId,
                            'concertName': concert.concertName,
                            'concertDate': concert.concertDate,
                            'location': concert.location,
                            'poster': concert.concertPoster,
                          },
                        );
                      },
                    ),
                  ),
                ],
              );
            },
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
          ).createShader(
            const Rect.fromLTWH(0.0, 0.0, 200.0, 70.0),
          ),
      ),
    );
  }
}

class ConcertSimpleCard extends StatelessWidget {
  final String concertName;
  final String concertDate;
  final String location;
  final int filled;
  final int availability;
  final String concertPoster;
  final VoidCallback onTap;

  const ConcertSimpleCard({
    super.key,
    required this.concertName,
    required this.concertDate,
    required this.location,
    required this.filled,
    required this.availability,
    required this.concertPoster,
    required this.onTap,
  });

  String get formattedDate {
    try {
      final date = DateTime.parse(concertDate);
      return DateFormat('d MMMM yyyy', 'id').format(date);
    } catch (_) {
      return concertDate;
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 8),
        height: 180,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          image: concertPoster.isNotEmpty
              ? DecorationImage(
                  image: NetworkImage(concertPoster),
                  fit: BoxFit.cover,
                  colorFilter: ColorFilter.mode(
                    Colors.black.withOpacity(0.4),
                    BlendMode.darken,
                  ),
                )
              : null,
          color: const Color(0xFF1D1E2D),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                concertName,
                style: const TextStyle(
                  color: Color(0xFFC105FF),
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                formattedDate,
                style: const TextStyle(color: Colors.white, fontSize: 16),
              ),
              const SizedBox(height: 8),
              Text(
                location,
                style: const TextStyle(color: Colors.white, fontSize: 16),
              ),
              const Spacer(),
              Text(
                'Sold: $filled / $availability',
                style: const TextStyle(color: Colors.white, fontSize: 16),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
