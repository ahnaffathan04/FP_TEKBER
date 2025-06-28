import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'dart:async';
import 'package:supabase_flutter/supabase_flutter.dart';

class TicketOrderScreen extends StatefulWidget {
  final String category;
  final double price;
  final Color color;
  final Map<String, int> initialTicketQuantities;
  final int concertId;
  final String concertName;
  final String concertDate;
  final String location;
  final String poster;
  final String paymentMethod;
  final String concertTicketId;
  final List<String> selectedSeats;

  const TicketOrderScreen({
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
    required this.paymentMethod,
    required this.concertTicketId,
    required this.selectedSeats,
  });

  @override
  State<TicketOrderScreen> createState() => _TicketOrderScreenState();
}

class _TicketOrderScreenState extends State<TicketOrderScreen> {
  late String _selectedPaymentMethod;
  int _countdownSeconds = 599; // 9 minutes 59 seconds
  Timer? _timer;
  Map<String, int> _ticketQuantities = {};
  final Map<String, double> _ticketPrices = {
    'VVIP': 100000.00,
    'CAT 1': 80000.00,
    'CAT 2': 60000.00,
    'CAT 3': 40000.00,
  };
  final int _maxTotalTickets = 4;

  @override
  void initState() {
    super.initState();
    _selectedPaymentMethod = widget.paymentMethod;
    _ticketQuantities = Map.from(widget.initialTicketQuantities);
    _ticketQuantities.removeWhere((key, value) => value == 0);

    if (_ticketQuantities.isEmpty) {
      _ticketQuantities['VVIP'] = 1;
    }
    _startCountdown();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _startCountdown() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (_countdownSeconds > 0) {
          _countdownSeconds--;
        } else {
          _timer?.cancel();
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Payment time has expired!')),
          );
        }
      });
    });
  }

  double _calculateTotal() {
    final qty = widget.initialTicketQuantities[widget.category] ?? 1;
    return widget.price * qty;
  }

  String _formatCurrency(double value) {
    final intVal = value.toInt();
    final formatted = intVal
        .toString()
        .replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (m) => '${m[1]}.');
    return 'Rp$formatted,00';
  }

  String _formatTime(int seconds) {
    final minutes = seconds ~/ 60;
    final remainingSeconds = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')} : ${remainingSeconds.toString().padLeft(2, '0')}';
  }

  Future<void> _finishPayment() async {
    final supabase = Supabase.instance.client;
    final userId = supabase.auth.currentUser?.id;
    final orderNumber = 'ORD-${DateTime.now().millisecondsSinceEpoch}';
    final totalAmount = _calculateTotal().toInt();
    final now = DateTime.now();

    try {
      for (final seat in widget.selectedSeats) {
        await supabase.from('purchase_table').insert({
          'concert_ticket_id': widget.concertTicketId,
          'ordered_seat_number': seat,
          'order_number': orderNumber,
          'created_at': now.toIso8601String(),
          'payment_method': _selectedPaymentMethod,
          'user_id': userId,
          'total_amount': totalAmount,
          'status': 'completed',
          'purchase_date': now.toIso8601String().split('T').first,
        });
      }
      // --- Correct way to increment filled ---
      final purchasedCount = widget.selectedSeats.length;
      final ticketRes = await supabase
          .from('concert_ticket')
          .select('filled')
          .eq('concert_ticket_id', widget.concertTicketId)
          .single();
      final currentFilled = (ticketRes['filled'] ?? 0) as int;
      final newFilled = currentFilled + purchasedCount;
      await supabase
          .from('concert_ticket')
          .update({'filled': newFilled})
          .eq('concert_ticket_id', widget.concertTicketId);
      // ---------------------------------------

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Payment Finished!')),
      );
      context.go('/buyer-home');
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to finish payment: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final total = _calculateTotal();
    return Scaffold(
      backgroundColor: const Color(0xFF11121A),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text('TICKET ORDER', style: TextStyle(letterSpacing: 1.2)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Concert Info Card
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: 120,
                          height: 120,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: const Color(0xFF00D4FF),
                              width: 2,
                            ),
                            image: DecorationImage(
                              image: widget.poster.isNotEmpty
                                  ? NetworkImage(widget.poster)
                                  : const AssetImage('assets/images/concert.jpg') as ImageProvider,
                              fit: BoxFit.cover,
                            ),
                          ),
                          child: Align(
                            alignment: Alignment.bottomLeft,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                widget.concertName,
                                style: const TextStyle(
                                  color: Color(0xFF00FFD0),
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                  shadows: [
                                    Shadow(
                                      color: Colors.black,
                                      blurRadius: 4,
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                widget.concertName.toUpperCase(),
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                ),
                              ),
                              const SizedBox(height: 6),
                              Row(
                                children: List.generate(
                                  4,
                                  (i) => const Icon(Icons.star, color: Colors.yellow, size: 18),
                                )
                                  ..add(const Icon(Icons.star_half, color: Colors.yellow, size: 18)),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                widget.concertDate,
                                style: const TextStyle(color: Colors.white70, fontSize: 14),
                              ),
                              Text(
                                widget.location,
                                style: const TextStyle(color: Colors.white70, fontSize: 14),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 28),
                    // Transaction Details
                    Text('Transaction Details :',
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: Colors.white)),
                    const SizedBox(height: 12),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 18),
                      decoration: BoxDecoration(
                        color: const Color(0xFF1A1F2E),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Column(
                        children: _ticketQuantities.entries.map((entry) {
                          String category = entry.key;
                          int quantity = entry.value;
                          double price = _ticketPrices[category] ?? 0.0;
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 6.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  category,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 16,
                                  ),
                                ),
                                Row(
                                  children: [
                                    Text(
                                      _formatCurrency(price),
                                      style: const TextStyle(
                                        color: Colors.white70,
                                        fontWeight: FontWeight.w500,
                                        fontSize: 16,
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    Text(
                                      'x $quantity',
                                      style: const TextStyle(
                                        color: Colors.white54,
                                        fontWeight: FontWeight.w500,
                                        fontSize: 16,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                    const SizedBox(height: 28),
                    // Payment Method
                    Text('Payment Method :',
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: Colors.white)),
                    const SizedBox(height: 12),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(18),
                      decoration: BoxDecoration(
                        color: const Color(0xFF1A1F2E),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Container(
                                width: 32,
                                height: 32,
                                decoration: const BoxDecoration(
                                  color: Color(0xFF2196F3),
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(Icons.account_balance_wallet,
                                    color: Colors.white, size: 20),
                              ),
                              const SizedBox(width: 12),
                              Text(
                                _selectedPaymentMethod,
                                style: const TextStyle(
                                  color: Color(0xFF21D3FE),
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20,
                                ),
                              ),
                              const Spacer(),
                              const Icon(Icons.circle, color: Colors.amber, size: 16),
                            ],
                          ),
                          const SizedBox(height: 10),
                          const Text(
                            'Get a voucher reward of IDR 5.000 for the first transaction use limited DANA during the period promo.',
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 28),
                    // Countdown
                    Text('Finish your payment in :',
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: Colors.white)),
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: _formatTime(_countdownSeconds)
                          .split(' ')
                          .expand((e) => e.split(':'))
                          .map((e) => Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 4.0),
                                child: Container(
                                  width: 48,
                                  height: 56,
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                    color: const Color(0xFF23243A),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Text(
                                    e,
                                    style: const TextStyle(
                                      color: Color(0xFF00D4FF),
                                      fontWeight: FontWeight.bold,
                                      fontSize: 28,
                                    ),
                                  ),
                                ),
                              ))
                          .toList(),
                    ),
                  ],
                ),
              ),
            ),
            // Bottom Bar
            Container(
              width: double.infinity,
              decoration: const BoxDecoration(
                color: Color(0xFF1A1F2E),
                borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
                border: Border(
                  top: BorderSide(color: Color(0xFF00D4FF), width: 2),
                ),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Total',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                          ),
                        ),
                        Text(
                          _formatCurrency(total),
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF00D4FF),
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(12),
                            bottomRight: Radius.circular(12),
                          ),
                        ),
                        elevation: 0,
                      ),
                      onPressed: _finishPayment,
                      child: const Text(
                        'FINISH PAYMENT',
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                          letterSpacing: 1.1,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}