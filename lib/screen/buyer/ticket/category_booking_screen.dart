import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'payment_method_selection_screen.dart';
import 'ticket_order_screen.dart';

class CategoryBookingScreen extends StatefulWidget {
  final String category;
  final double price;
  final Color color;
  final Map<String, int> initialTicketQuantities;
  final int concertId;
  final String concertName;
  final String concertDate;
  final String location;
  final String poster;
  final String concertTicketId;

  const CategoryBookingScreen({
    super.key,
    required this.category,
    required this.price,
    required this.color,
    required this.initialTicketQuantities,
    required this.concertId,
    required this.concertName,
    required this.concertDate,
    required this.location,
    required this.poster,
    required this.concertTicketId,
  });

  @override
  State<CategoryBookingScreen> createState() => _CategoryBookingScreenState();
}

class _CategoryBookingScreenState extends State<CategoryBookingScreen> {
  int _numberOfTickets = 1;
  final int _maxTicketsPerCategory = 4;
  List<String?> _selectedSeats = [null];
  List<String> _unavailableSeats = [];
  bool _loadingSeats = true;

  @override
  void initState() {
    super.initState();
    _fetchUnavailableSeats();
  }

  Future<void> _fetchUnavailableSeats() async {
    final supabase = Supabase.instance.client;
    final res = await supabase
        .from('purchase_table')
        .select('ordered_seat_number')
        .eq('concert_ticket_id', widget.concertTicketId);
    setState(() {
      _unavailableSeats = (res as List)
          .map((row) => row['ordered_seat_number'] as String?)
          .where((seat) => seat != null && seat.trim().isNotEmpty)
          .map((seat) => seat!.trim())
          .toList();
      _loadingSeats = false;
    });
    print('Unavailable seats: $_unavailableSeats');
  }

  String get priceFormattedSingle {
    final priceInt = widget.price.toInt();
    final formatted = priceInt
        .toString()
        .replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (m) => '${m[1]}.');
    return 'Rp$formatted,00';
  }

  String get priceFormattedTotal {
    final total = (widget.price * _numberOfTickets).toInt();
    final formatted = total
        .toString()
        .replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (m) => '${m[1]}.');
    return 'Rp$formatted,00';
  }

  List<String> get seatOptions {
    List<String> seats = [];
    for (var row in ['A', 'B', 'C', 'D', 'E']) {
      for (int i = 1; i <= 100; i++) {
        final seat = '$row$i';
        if (!_unavailableSeats.contains(seat)) {
          seats.add(seat);
        }
      }
    }
    return seats;
  }

  bool get allSeatsSelected =>
      _selectedSeats.length == _numberOfTickets &&
      !_selectedSeats.contains(null);

  @override
  Widget build(BuildContext context) {
    if (_loadingSeats) {
      return const Scaffold(
        backgroundColor: Color(0xFF11121A),
        body: Center(child: CircularProgressIndicator()),
      );
    }
    return Scaffold(
      backgroundColor: const Color(0xFF11121A),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(widget.concertName),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(height: 8),
          Text(
            "BOOK YOUR TICKET",
            style: const TextStyle(
              color: Colors.white,
              fontSize: 28,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.2,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          Center(
            child: Column(
              children: [
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
                Wrap(
                  alignment: WrapAlignment.center,
                  spacing: 6,
                  runSpacing: 6,
                  children: List.generate(24, (i) {
                    Color seatColor;
                    if (i < 6) {
                      seatColor = const Color(0xFFFF5B99);
                    } else if (i < 12) {
                      seatColor = const Color(0xFFB96FFF);
                    } else {
                      seatColor = const Color(0xFF21D3FE);
                    }
                    return Container(
                      width: 22,
                      height: 22,
                      decoration: BoxDecoration(
                        color: seatColor,
                        borderRadius: BorderRadius.circular(6),
                        boxShadow: [
                          BoxShadow(
                            color: seatColor.withOpacity(0.3),
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
          Text(
            widget.category.toUpperCase(),
            style: TextStyle(
              color: widget.color,
              fontWeight: FontWeight.bold,
              fontSize: 36,
              letterSpacing: 2,
            ),
          ),
          const SizedBox(height: 16),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 16),
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
            decoration: BoxDecoration(
              color: const Color(0xFF23243A),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    Text(
                      "Number of tickets",
                      style: TextStyle(
                        color: const Color(0xFF21D3FE),
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const Spacer(),
                    IconButton(
                      icon: const Icon(Icons.remove_circle, color: Color(0xFF21D3FE)),
                      onPressed: _numberOfTickets > 1
                          ? () {
                              setState(() {
                                _numberOfTickets--;
                                _selectedSeats.removeLast();
                              });
                            }
                          : null,
                    ),
                    Text(
                      '$_numberOfTickets',
                      style: const TextStyle(
                        color: Color(0xFF21D3FE),
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.add_circle, color: Color(0xFF21D3FE)),
                      onPressed: () {
                        if (_numberOfTickets < _maxTicketsPerCategory) {
                          setState(() {
                            _numberOfTickets++;
                            _selectedSeats.add(null);
                          });
                        }
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Align(
                  alignment: Alignment.centerRight,
                  child: Text(
                    '$priceFormattedSingle/ticket',
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.7),
                      fontSize: 16,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Column(
                  children: List.generate(_numberOfTickets, (index) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4.0),
                      child: DropdownButtonFormField<String>(
                        value: _selectedSeats[index],
                        decoration: InputDecoration(
                          labelText: 'Seat for Ticket ${index + 1}',
                          filled: true,
                          fillColor: const Color(0xFF23243A),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        dropdownColor: const Color(0xFF23243A),
                        items: seatOptions
                            .where((seat) => !_selectedSeats.contains(seat) || _selectedSeats[index] == seat)
                            .map((seat) => DropdownMenuItem(
                                  value: seat,
                                  child: Text(seat, style: const TextStyle(color: Colors.white)),
                                ))
                            .toList(),
                        onChanged: (val) {
                          setState(() {
                            _selectedSeats[index] = val;
                          });
                        },
                      ),
                    );
                  }),
                ),
              ],
            ),
          ),
          const Spacer(),
          Padding(
            padding: const EdgeInsets.only(bottom: 24, left: 8, right: 8),
            child: GestureDetector(
              onTap: () async {
                if (!allSeatsSelected) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Please select all seat numbers!')),
                  );
                  return;
                }
                final selectedPaymentMethod = await Navigator.push<String>(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const PaymentMethodSelectionScreen(),
                  ),
                );
                if (selectedPaymentMethod != null && selectedPaymentMethod.isNotEmpty) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => TicketOrderScreen(
                        category: widget.category,
                        price: widget.price,
                        color: widget.color,
                        initialTicketQuantities: {widget.category: _numberOfTickets},
                        concertId: widget.concertId,
                        concertName: widget.concertName,
                        concertDate: widget.concertDate,
                        location: widget.location,
                        poster: widget.poster,
                        paymentMethod: selectedPaymentMethod,
                        concertTicketId: widget.concertTicketId,
                        selectedSeats: _selectedSeats.whereType<String>().toList(),
                      ),
                    ),
                  );
                }
              },
              child: Container(
                height: 64,
                decoration: BoxDecoration(
                  color: const Color(0xFF23243A),
                  borderRadius: BorderRadius.circular(32),
                ),
                child: Row(
                  children: [
                    const SizedBox(width: 24),
                    Text(
                      '$_numberOfTickets ticket',
                      style: const TextStyle(
                        color: Color(0xFF21D3FE),
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Text(
                      priceFormattedTotal,
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.7),
                        fontSize: 16,
                      ),
                    ),
                    const Spacer(),
                    Container(
                      margin: const EdgeInsets.only(right: 16),
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.transparent,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Icon(Icons.confirmation_num_outlined, color: Color(0xFF21D3FE), size: 32),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}