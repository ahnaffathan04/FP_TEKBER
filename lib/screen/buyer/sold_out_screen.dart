// lib/screens/sold_out_screen.dart
import 'package:flutter/material.dart';

class SoldOutScreen extends StatelessWidget {
  const SoldOutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black.withOpacity(0.8),
      body: Center(
        child: Container(
          padding: const EdgeInsets.all(24),
          margin: const EdgeInsets.all(32),
          decoration: BoxDecoration(
            color: const Color(0xFF1A1F2E),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: const Color(0xFF00D4FF), width: 2),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  color: Colors.red.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(50),
                ),
                child: const Icon(
                  Icons.close,
                  color: Colors.red,
                  size: 60,
                ),
              ),
              const SizedBox(height: 20),
              Text(
                'WE\'RE SORRY',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(color: Colors.white),
              ),
              const SizedBox(height: 8),
              Text(
                'TICKETS ARE SOLD OUT !',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.white70),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {
                        Navigator.pop(context); // Go back to the previous screen
                      },
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: Color(0xFF00D4FF)),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                      child: const Text('OK', style: TextStyle(color: Color(0xFF00D4FF))),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}