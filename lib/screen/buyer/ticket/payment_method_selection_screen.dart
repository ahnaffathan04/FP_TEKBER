import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class PaymentMethodSelectionScreen extends StatelessWidget {
  const PaymentMethodSelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Payment Method'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new),
          onPressed: () {
            context.go('/category_booking');
          },
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('QRIS', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 10),
            _buildPaymentOption(context, 'QRIS', Icons.qr_code, 'QRIS'),
            const SizedBox(height: 20),
            Text('E-WALLET', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 10),
            _buildPaymentOption(context, 'Gopay',
                Icons.account_balance_wallet_outlined, 'Gopay'),
            _buildPaymentOption(
                context, 'ShopeePay', Icons.wallet_outlined, 'ShopeePay'),
            _buildPaymentOption(
                context, 'DANA', Icons.monetization_on_outlined, 'DANA'),
            _buildPaymentOption(context, 'OVO', Icons.circle, 'OVO'),
            const SizedBox(height: 20),
            Text('BANK', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 10),
            _buildPaymentOption(
                context, 'Bank Mandiri', Icons.house, 'Bank Mandiri'),
            _buildPaymentOption(
                context, 'Bank BRI', Icons.business, 'Bank BRI'),
            _buildPaymentOption(
                context, 'Bank BCA', Icons.account_balance, 'Bank BCA'),
          ],
        ),
      ),
    );
  }

  Widget _buildPaymentOption(
      BuildContext context, String title, IconData icon, String valueToReturn) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: GestureDetector(
        onTap: () {
          Navigator.pop(context, valueToReturn); // Return selected payment method
        },
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: const Color(0xFF1A1F2E),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              Icon(icon, color: const Color(0xFF00D4FF)),
              const SizedBox(width: 16),
              Text(title, style: Theme.of(context).textTheme.bodyLarge),
              const Spacer(),
              const Icon(Icons.arrow_forward_ios,
                  size: 16, color: Colors.white70),
            ],
          ),
        ),
      ),
    );
  }
}