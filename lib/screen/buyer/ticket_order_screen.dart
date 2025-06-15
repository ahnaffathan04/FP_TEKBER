// lib/screens/ticket_order_screen.dart
import 'package:flutter/material.dart';
import 'dart:async';

class TicketOrderScreen extends StatefulWidget {
  final Map<String, int> initialTicketQuantities;

  const TicketOrderScreen({super.key, required this.initialTicketQuantities});

  @override
  State<TicketOrderScreen> createState() => _TicketOrderScreenState();
}

class _TicketOrderScreenState extends State<TicketOrderScreen> {
  String _selectedPaymentMethod = 'Change Payment Method';
  int _countdownSeconds = 599; // 9 minutes 59 seconds
  Timer? _timer;
  Map<String, int> _ticketQuantities = {};
  final Map<String, double> _ticketPrices = {
    'VVIP': 900000.00,
    'CAT 1': 600000.00,
    'CAT 2': 450000.00,
    'CAT 3': 300000.00,
  };
  final int _maxTotalTickets = 4; // Max 4 tickets across all categories for the user

  @override
  void initState() {
    super.initState();
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
    double total = 0.0;
    _ticketQuantities.forEach((category, quantity) {
      total += (_ticketPrices[category] ?? 0.0) * quantity;
    });
    return total;
  }

  int _getTotalTicketCount() {
    return _ticketQuantities.values.fold(0, (sum, quantity) => sum + quantity);
  }

  void _updateTicketQuantity(String category, int newQuantity) {
    setState(() {
      if (newQuantity < 0) {
        newQuantity = 0;
      }
      
      int currentCategoryQuantity = _ticketQuantities[category] ?? 0;
      int difference = newQuantity - currentCategoryQuantity;
      int totalAfterChange = _getTotalTicketCount() + difference;

      if (totalAfterChange > _maxTotalTickets) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Maximum $_maxTotalTickets tickets allowed across all categories!')),
        );
        return;
      }

      if (newQuantity == 0) {
        _ticketQuantities.remove(category);
      } else {
        _ticketQuantities[category] = newQuantity;
      }
    });
  }

  String _formatTime(int seconds) {
    final minutes = seconds ~/ 60;
    final remainingSeconds = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')} : ${remainingSeconds.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('TICKET ORDER'),
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
                  _buildShowOrderSummary(context),
                  const SizedBox(height: 20),
                  _buildTicketQuantitiesSection(),
                  const SizedBox(height: 20),
                  _buildPaymentMethodSection(context),
                  const SizedBox(height: 20),
                  Text('Finish your payment in', style: Theme.of(context).textTheme.bodyLarge),
                  const SizedBox(height: 10),
                  _buildCountdownTimer(context),
                ],
              ),
            ),
          ),
          _buildBottomPayBar(context),
        ],
      ),
    );
  }

  Widget _buildShowOrderSummary(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1F2E),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              gradient: const LinearGradient(
                colors: [Color(0xFF6A1B9A), Color(0xFFE91E63)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: const Center(
              child: Text('TGIF!', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('SISFORIA: TGIF!', style: Theme.of(context).textTheme.bodyLarge),
                const SizedBox(height: 4),
                Row(
                  children: const [
                    Icon(Icons.star, color: Colors.yellow, size: 16),
                    Icon(Icons.star, color: Colors.yellow, size: 16),
                    Icon(Icons.star, color: Colors.yellow, size: 16),
                    Icon(Icons.star, color: Colors.yellow, size: 16),
                    Icon(Icons.star_half, color: Colors.yellow, size: 16),
                  ],
                ),
                const SizedBox(height: 4),
                Text('Sunday 28 November 2021', style: Theme.of(context).textTheme.bodySmall),
                Text('Balai Sarbini, South Jakarta', style: Theme.of(context).textTheme.bodySmall),
                Text('09:00 PM', style: Theme.of(context).textTheme.bodySmall),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTicketQuantitiesSection() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1F2E),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Transaction Details :', style: Theme.of(context).textTheme.bodyLarge),
          const Divider(height: 30, color: Colors.white12),
          if (_ticketQuantities.isEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Text('No tickets selected.', style: Theme.of(context).textTheme.bodyMedium),
            ),
          ..._ticketQuantities.entries.map((entry) {
            String category = entry.key;
            int quantity = entry.value;
            double price = _ticketPrices[category] ?? 0.0;
            return _buildAdjustableOrderItem(
              category,
              price,
              quantity,
              onDecrement: () {
                _updateTicketQuantity(category, quantity - 1);
              },
              onIncrement: () {
                _updateTicketQuantity(category, quantity + 1);
              },
            );
          }).toList(),
          const Divider(height: 30, color: Colors.white12),
          Text(
            'Total tickets: ${_getTotalTicketCount()}/$_maxTotalTickets',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Colors.white54),
          ),
        ],
      ),
    );
  }

  Widget _buildAdjustableOrderItem(
      String category, double price, int quantity, {required VoidCallback onDecrement, required VoidCallback onIncrement}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(category, style: Theme.of(context).textTheme.bodyMedium),
                Text('RP${(price * quantity / 1000).toStringAsFixed(0)}K', style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.white54)),
              ],
            ),
          ),
          Row(
            children: [
              IconButton(
                icon: Icon(Icons.remove_circle_outline, color: quantity > 0 ? const Color(0xFF00D4FF) : Colors.grey),
                onPressed: quantity > 0 ? onDecrement : null,
              ),
              Text('$quantity', style: Theme.of(context).textTheme.bodyLarge),
              IconButton(
                icon: Icon(Icons.add_circle_outline, color: _getTotalTicketCount() < _maxTotalTickets ? const Color(0xFF00D4FF) : Colors.grey),
                onPressed: _getTotalTicketCount() < _maxTotalTickets ? onIncrement : null,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentMethodSection(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1F2E),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Payment Method', style: Theme.of(context).textTheme.bodyLarge),
          const SizedBox(height: 10),
          GestureDetector(
            onTap: () async {
              final result = await Navigator.pushNamed(context, '/payment_method');
              if (result != null && result is String) {
                setState(() {
                  _selectedPaymentMethod = result;
                });
              }
            },
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
              decoration: BoxDecoration(
                color: const Color(0xFF2C2C2C),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(_selectedPaymentMethod, style: Theme.of(context).textTheme.bodyLarge),
                  const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.white70),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCountdownTimer(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      decoration: BoxDecoration(
        color: const Color(0xFF00D4FF),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Center(
        child: Text(
          _formatTime(_countdownSeconds),
          style: Theme.of(context).textTheme.titleLarge?.copyWith(fontSize: 32, color: Colors.black, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  Widget _buildBottomPayBar(BuildContext context) {
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
            children: [
              Text('TOTAL', style: Theme.of(context).textTheme.bodyMedium),
              Text('RP${(_calculateTotal() / 1000).toStringAsFixed(0)}K', style: Theme.of(context).textTheme.titleLarge),
            ],
          ),
          SizedBox(
            height: 50,
            child: ElevatedButton(
              onPressed: () {
                if (_calculateTotal() <= 0) {
                   ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Please select at least one ticket to proceed.')),
                  );
                  return;
                }
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Proceeding to payment... (Not implemented)')),
                );
              },
              child: const Text('PAID-PAYMENT', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
            ),
          ),
        ],
      ),
    );
  }
}