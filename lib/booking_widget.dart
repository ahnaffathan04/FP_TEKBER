// lib/main.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'themes/app_theme.dart';
import 'screen/buyer/book_ticket_overview.dart';
import 'screen/buyer/category_booking_screen.dart';
import 'screen/buyer/sold_out_screen.dart';
import 'screen/buyer/ticket_order_screen.dart';
import 'screen/buyer/payment_method_selection_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light.copyWith(
    statusBarColor: Colors.transparent,
    statusBarIconBrightness: Brightness.light,
    statusBarBrightness: Brightness.dark,
  ));
  runApp(const TicketBookingApp());
}

class TicketBookingApp extends StatelessWidget {
  const TicketBookingApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Ticket Booking App',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.darkTheme, // Using the extracted theme
      initialRoute: '/',
      routes: {
        '/': (context) => const BookTicketOverviewScreen(),
        '/category_booking': (context) {
          final args = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
          return CategoryBookingScreen(
            category: args?['category'] ?? 'VVIP',
            price: args?['price'] ?? 900000.0,
            color: args?['color'] ?? Colors.purple,
          );
        },
        '/sold_out': (context) => const SoldOutScreen(),
        '/ticket_order': (context) {
          final args = ModalRoute.of(context)?.settings.arguments as Map<String, int>?;
          return TicketOrderScreen(initialTicketQuantities: args ?? {});
        },
        '/payment_method': (context) => const PaymentMethodSelectionScreen(),
      },
    );
  }
}