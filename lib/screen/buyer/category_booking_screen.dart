// lib/screens/category_booking_screen.dart (perubahan)
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

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
  });

  @override
  State<CategoryBookingScreen> createState() => _CategoryBookingScreenState();
}

class _CategoryBookingScreenState extends State<CategoryBookingScreen> {
  int _numberOfTickets = 0;
  final int _maxTicketsPerCategory = 4; // Max 4 tickets per category

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.category} Ticket'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('BOOK YOUR TICKET',
                      style: Theme.of(context).textTheme.titleLarge),
                  const SizedBox(height: 20),
                  // Menggunakan gambar untuk denah tempat duduk
                  _buildSeatMap(context),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      Container(
                        width: 20,
                        height: 20,
                        decoration: BoxDecoration(
                          color: widget.color,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Text(
                        widget.category,
                        style: Theme.of(context)
                            .textTheme
                            .titleLarge
                            ?.copyWith(color: widget.color),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  _buildTicketCounter(),
                  const SizedBox(height: 20),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: const Color(0xFF1A1F2E),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Ticket',
                            style: Theme.of(context).textTheme.bodyLarge),
                        Text(
                            'RP${(widget.price * _numberOfTickets / 1000).toStringAsFixed(0)}K',
                            style: Theme.of(context).textTheme.bodyLarge),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          _buildBottomBar(context),
        ],
      ),
    );
  }

  // Menggunakan gambar untuk denah tempat duduk
  Widget _buildSeatMap(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 200, // Sesuaikan tinggi sesuai kebutuhan gambar
      decoration: BoxDecoration(
        color: const Color(0xFF1A1F2E),
        borderRadius: BorderRadius.circular(12),
      ),
      child: ClipRRect(
        // ClipRRect untuk menerapkan borderRadius pada gambar
        borderRadius: BorderRadius.circular(12),
        child: Image.asset(
          'assets/images/layout-stage1.png', // Path ke gambar yang diunggah
          fit: BoxFit.contain, // Sesuaikan fit sesuai kebutuhan
        ),
      ),
    );
  }

  Widget _buildTicketCounter() {
    // This screen limits selection to _maxTicketsPerCategory for the current category.
    // The overall _maxTotalTicketsAllowed is enforced on the TicketOrderScreen.
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1F2E),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Number of Tickets',
                  style: Theme.of(context).textTheme.bodyLarge),
              Row(
                children: [
                  IconButton(
                    icon: Icon(
                      Icons.remove_circle,
                      color: _numberOfTickets > 0
                          ? const Color(0xFF00D4FF)
                          : Colors.grey,
                    ),
                    onPressed: () {
                      setState(() {
                        if (_numberOfTickets > 0) {
                          _numberOfTickets--;
                        }
                      });
                    },
                  ),
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: const Color(0xFF00D4FF),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Center(
                      child: Text(
                        '$_numberOfTickets',
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                    ),
                  ),
                  IconButton(
                    icon: Icon(
                      Icons.add_circle,
                      color: _numberOfTickets < _maxTicketsPerCategory
                          ? const Color(0xFF00D4FF)
                          : Colors.grey,
                    ),
                    onPressed: () {
                      setState(() {
                        if (_numberOfTickets < _maxTicketsPerCategory) {
                          _numberOfTickets++;
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                                content: Text(
                                    'Cannot buy more than $_maxTicketsPerCategory tickets for this category!')),
                          );
                        }
                      });
                    },
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            'Max $_maxTicketsPerCategory tickets per category.',
            style: Theme.of(context)
                .textTheme
                .bodySmall
                ?.copyWith(color: Colors.white54),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomBar(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1F2E),
        borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 10,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('TOTAL', style: Theme.of(context).textTheme.bodyMedium),
              Text(
                'RP${(widget.price * _numberOfTickets / 1000).toStringAsFixed(0)}K',
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ],
          ),
          SizedBox(
            height: 50,
            child: ElevatedButton(
              onPressed: () {
                if (_numberOfTickets > 0) {
                  context.push('/ticket_order', extra: {
                    'initialTicketQuantities': {
                      widget.category: _numberOfTickets,
                    },
                    'category': widget.category,
                    'price': widget.price,
                    'color': widget.color,
                    'concertId': widget.concertId,
                    'concertName': widget.concertName,
                    'concertDate': widget.concertDate,
                    'location': widget.location,
                    'poster': widget.poster,
                  });
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content: Text('Please select at least one ticket!')),
                  );
                }
              },
              child: const Text(
                'BUY TICKET',
                style:
                    TextStyle(color: Colors.blue, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
