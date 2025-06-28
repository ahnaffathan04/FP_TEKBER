import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'category_booking_screen.dart';

class BookTicketOverviewScreen extends StatelessWidget {
  final int concertId;
  final String concertName;
  final String concertDate;
  final String location;
  final String poster;

  const BookTicketOverviewScreen({
    super.key,
    required this.concertId,
    required this.concertName,
    required this.concertDate,
    required this.location,
    required this.poster,
  });

  Future<List<Map<String, dynamic>>> fetchTicketCategories() async {
    final response = await Supabase.instance.client
        .from('concert_ticket')
        .select()
        .eq('concert_id', concertId);
    return List<Map<String, dynamic>>.from(response);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Booking'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new),
          onPressed: () {
            context.go('/buyer-home');
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Concert name outside the container
            Text(
              concertName,
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 20),

            // --- STAGE & SEAT MAP MOCKUP START ---
            Center(
              child: Column(
                children: [
                  // Stage
                  Container(
                    width: 160,
                    height: 32,
                    decoration: BoxDecoration(
                      color: const Color(0xFF353759),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    alignment: Alignment.center,
                    child: const Text(
                      'STAGE',
                      style: TextStyle(
                        color: Colors.white70,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.2,
                        fontSize: 16,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  // Simple seat map mockup (colored squares)
                  Wrap(
                    alignment: WrapAlignment.center,
                    spacing: 6,
                    runSpacing: 6,
                    children: List.generate(24, (i) {
                      // Color logic for demo only
                      Color color;
                      if (i < 6) {
                        color = const Color(0xFFFF5B99); // Red
                      } else if (i < 12) {
                        color = const Color(0xFFB96FFF); // Purple
                      } else {
                        color = const Color(0xFF21D3FE); // Blue
                      }
                      return Container(
                        width: 22,
                        height: 22,
                        decoration: BoxDecoration(
                          color: color,
                          borderRadius: BorderRadius.circular(6),
                          boxShadow: [
                            BoxShadow(
                              color: color.withOpacity(0.3),
                              blurRadius: 6,
                              spreadRadius: 1,
                            ),
                          ],
                        ),
                      );
                    }),
                  ),
                  const SizedBox(height: 18),
                ],
              ),
            ),
            // --- STAGE & SEAT MAP MOCKUP END ---

            Expanded(
              child: FutureBuilder<List<Map<String, dynamic>>>(
                future: fetchTicketCategories(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  }
                  final tickets = snapshot.data ?? [];
                  if (tickets.isEmpty) {
                    return const Center(child: Text('No ticket categories found.'));
                  }
                  return ListView.builder(
                    itemCount: tickets.length,
                    itemBuilder: (context, index) {
                      final ticket = tickets[index];
                      final category = ticket['category'] ?? '';
                      final concertTicketId = ticket['concert_ticket_id'];

                      int parseInt(dynamic value) {
                        if (value == null) return 0;
                        if (value is int) return value;
                        if (value is double) return value.toInt();
                        if (value is String) return int.tryParse(value) ?? 0;
                        return 0;
                      }

                      final price = parseInt(ticket['price']);
                      final filled = parseInt(ticket['filled']);
                      final availability = parseInt(ticket['availability']);

                      // Icon and color logic based on category
                      IconData icon;
                      Color iconColor;
                      Color priceColor;
                      switch (category.toUpperCase()) {
                        case 'REGULAR EARLY':
                          icon = Icons.star;
                          iconColor = const Color(0xFFB96FFF);
                          priceColor = const Color(0xFFB96FFF);
                          break;
                        case 'VIP EARLY':
                          icon = Icons.favorite;
                          iconColor = const Color(0xFF21D3FE);
                          priceColor = const Color(0xFF21D3FE);
                          break;
                        case 'REGULAR':
                          icon = Icons.circle;
                          iconColor = const Color(0xFF21FEC4);
                          priceColor = const Color(0xFF21FEC4);
                          break;
                        case 'VIP':
                          icon = Icons.emoji_events;
                          iconColor = const Color(0xFFFFD600);
                          priceColor = const Color(0xFFFFD600);
                          break;
                        default:
                          icon = Icons.confirmation_num;
                          iconColor = Colors.white;
                          priceColor = Colors.white;
                      }

                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => CategoryBookingScreen(
                                category: category,
                                price: price.toDouble(),
                                color: iconColor,
                                initialTicketQuantities: {},
                                concertId: concertId,
                                concertName: concertName,
                                concertDate: concertDate,
                                location: location,
                                poster: poster,
                                concertTicketId: concertTicketId,
                              ),
                            ),
                          );
                        },
                        child: Container(
                          margin: const EdgeInsets.symmetric(vertical: 10),
                          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
                          decoration: BoxDecoration(
                            color: const Color(0xFF23243A),
                            borderRadius: BorderRadius.circular(18),
                          ),
                          child: Row(
                            children: [
                              // Icon
                              Container(
                                width: 44,
                                height: 44,
                                decoration: BoxDecoration(
                                  color: iconColor.withOpacity(0.15),
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(icon, color: iconColor, size: 28),
                              ),
                              const SizedBox(width: 16),
                              // Category and sold info
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      category.toUpperCase(),
                                      style: TextStyle(
                                        color: iconColor,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                        letterSpacing: 1,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      '$filled/$availability SOLD',
                                      style: TextStyle(
                                        color: Colors.white.withOpacity(0.6),
                                        fontWeight: FontWeight.w500,
                                        fontSize: 13,
                                        letterSpacing: 0.5,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              // Price and chevron
                              Row(
                                children: [
                                  Text(
                                    'RP${price}',
                                    style: TextStyle(
                                      color: priceColor,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 17,
                                      letterSpacing: 1,
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  const Icon(Icons.chevron_right, color: Colors.white, size: 28),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}