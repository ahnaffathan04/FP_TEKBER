import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

// Import screen QRScannerWeb
import 'qr_scanner_web.dart';

// Auth Screens
import 'screen/auth/login_screen.dart';
import 'screen/auth/register_screen.dart';
import 'screen/auth/change_password.dart';
import 'screen/auth/forgot_password_1.dart';
import 'screen/auth/forgot_password_2.dart';
import 'screen/auth/forgot_password_3.dart';

// Buyer Screens
import 'screen/buyer/home_screen.dart';
import 'screen/buyer/account.dart';
import 'screen/buyer/language.dart';
import 'screen/buyer/page_setting.dart';
import 'screen/buyer/ticket/my_ticket.dart';
import 'screen/buyer/ticket/concert_detail.dart';
import 'screen/buyer/ticket/concert_detail_completed.dart';
import 'screen/buyer/ticket/book_ticket_overview.dart';
import 'screen/buyer/ticket/category_booking_screen.dart';
import 'screen/buyer/ticket/ticket_order_screen.dart';
import 'screen/buyer/ticket/payment_method_selection_screen.dart';
import 'screen/buyer/ticket/sold_out_screen.dart';

// Organizer Screens
import 'screen/organizer/home_screen.dart';
import 'screen/organizer/tambah_tiket.dart';
import 'screen/organizer/tambah_konser.dart';
import 'screen/organizer/manage_konser.dart';
import 'screen/organizer/edit_konser.dart';
import 'screen/organizer/page_setting_organizer.dart';
import 'screen/organizer/account_organizer.dart';
import 'screen/organizer/language_organizer.dart';

// Complaint Screens
import 'screen/complaint/submit_complaint.dart';

// Providers
import 'screen/buyer/providers/user_provider.dart';
import 'screen/organizer/providers/concert_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: 'https://ncasjwbrdpjjvoouemwj.supabase.co',
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Im5jYXNqd2JyZHBqanZvb3VlbXdqIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NTAwNzMxNTcsImV4cCI6MjA2NTY0OTE1N30.DLx94pbPm8cMoxfQlzup2BIZxCN6lP5RNtXFYuYA-Bw', // 🔁 Replace with your Supabase anon key
  );

  await initializeDateFormatting('id', null);

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => UserProvider()),
        ChangeNotifierProvider(create: (_) => ConcertProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

final GoRouter _router = GoRouter(
  initialLocation: '/login',
  routes: [
    // Choose Role Route
    GoRoute(
      path: '/choose-role',
      builder: (context, state) => const ChooseRoleScreen(),
    ),

    // QR Scanner Web Route
    GoRoute(
      path: '/qr-scanner',
      builder: (context, state) => const QRScannerWeb(),
    ),

    // Auth Routes
    GoRoute(
      path: '/login',
      builder: (context, state) => LoginScreen(),
    ),
    GoRoute(
      path: '/register',
      builder: (context, state) => RegisterScreen(),
    ),
    GoRoute(
      path: '/change-password',
      builder: (context, state) => ChangePasswordScreen(),
    ),
    GoRoute(
      path: '/forgot_password_step1',
      builder: (context, state) => ForgotPassword1Screen(),
    ),
    GoRoute(
      path: '/forgot_password_step2',
      builder: (context, state) => ForgotPassword2Screen(),
    ),
    GoRoute(
      path: '/forgot_password_step3',
      builder: (context, state) => ForgotPassword3Screen(),
    ),

    // Buyer Routes
    GoRoute(
      path: '/sold_out',
      builder: (context, state) => const SoldOutScreen(),
    ),

    GoRoute(
      path: '/payment_method',
      builder: (context, state) => const PaymentMethodSelectionScreen(),
    ),

    GoRoute(
      path: '/ticket_order',
      builder: (context, state) {
        final args = state.extra as Map<String, dynamic>;
        return TicketOrderScreen(
          category: args['category'],
          price: args['price'],
          color: args['color'],
          concertId: args['concertId'],
          concertName: args['concertName'],
          concertDate: args['concertDate'],
          location: args['location'],
          poster: args['poster'],
          initialTicketQuantities: args['initialTicketQuantities'] ?? {},
          paymentMethod: args['paymentMethod'] ?? '', // <-- add this
          concertTicketId: args['concertTicketId'] ?? '', // <-- add this
          selectedSeats: args['selectedSeats'] ?? <String>[], // <-- add this
        );
      },
    ),
    GoRoute(
      path: '/category_booking',
      builder: (context, state) {
        final args = state.extra! as Map<String, dynamic>;
        return CategoryBookingScreen(
          category: args['category'],
          price: args['price'],
          color: args['color'],
          concertId: args['concertId'],
          concertName: args['concertName'],
          concertDate: args['concertDate'],
          location: args['location'],
          poster: args['poster'],
          initialTicketQuantities: args['initialTicketQuantities'] ?? {},
          concertTicketId: args['concertTicketId'], // <-- ADD THIS LINE
        );
      },
    ),

    GoRoute(
      path: '/book-ticket-overview',
      builder: (context, state) {
        final extra = state.extra as Map<String, dynamic>?;

        return BookTicketOverviewScreen(
          concertId: extra?['concertId'],
          concertName: extra?['concertName'],
          concertDate: extra?['concertDate'],
          location: extra?['location'],
          poster: extra?['poster'],
        );
      },
    ),

    GoRoute(
      path: '/buyer-home',
      builder: (context, state) => HomeScreen(),
    ),
    GoRoute(
      path: '/buyer-home/setting',
      builder: (context, state) => PageSetting(),
    ),
    GoRoute(
      path: '/buyer-home/setting/account',
      builder: (context, state) => AccountScreen(),
    ),
    GoRoute(
      path: '/buyer-home/setting/language',
      builder: (context, state) => LanguageScreen(),
    ),
    GoRoute(
      path: '/myticket',
      builder: (context, state) => MyTicketScreen(),
    ),
    GoRoute(
      path: '/concert/detail',
      builder: (context, state) => ConcertDetailScreen(),
    ),
    GoRoute(
      path: '/concert/detail/completed',
      builder: (context, state) => ConcertDetailCompleted(),
    ),

    // Organizer Routes
    GoRoute(
      path: '/organizer-home',
      builder: (context, state) => OrganizerHomeScreen(),
    ),
    GoRoute(
      path: '/organizer-home/setting',
      builder: (context, state) => OrganizerPageSetting(),
    ),
    GoRoute(
      path: '/organizer-home/setting/account_organizer',
      builder: (context, state) => OrganizerAccountScreen(),
    ),
    GoRoute(
      path: '/organizer-home/tambah-konser',
      builder: (context, state) => TambahKonserScreen(),
    ),
    GoRoute(
      path: '/organizer-home/setting/language_organizer',
      builder: (context, state) => OrganizerLanguageScreen(),
    ),
    GoRoute(
      path: '/organizer-home/manage-konser',
      builder: (context, state) {
        final concertTable = state.extra as Map<String, dynamic>?;
        if (concertTable == null) {
          return const Scaffold(
            body: Center(child: Text('No concert data provided.')),
          );
        }
        return ManageKonserScreen(concert_table: concertTable);
      },
    ),
    GoRoute(
      path: '/organizer-home/tambah-tiket',
      builder: (context, state) {
        final concertTable = state.extra as Map<String, dynamic>?;
        if (concertTable == null) {
          return const Scaffold(
            body: Center(child: Text('No concert data provided.')),
          );
        }
        return TambahTiketScreen(concertId: concertTable['concert_id'] as int);
      },
    ),
    GoRoute(
      path: '/edit-konser',
      builder: (context, state) {
        final concertTable = state.extra as Map<String, dynamic>?;
        if (concertTable == null) {
          return const Scaffold(
            body: Center(child: Text('No concert data provided.')),
          );
        }
        return EditKonserScreen(concert_table: concertTable);
      },
    ),

    // Complaint Routes
    GoRoute(
      path: '/complaint',
      builder: (context, state) => const SubmitComplaintScreen(),
    ),
  ],
);

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  static const Color bluishCyan = Color(0xFF21D3FE);
  static const Color lovelyPurple = Color(0xFF8D29EE);
  // ...add other colors as needed...

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: _router,
      title: 'FestiPass App',
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: const Color(0xFF111317),
      ),
      debugShowCheckedModeBanner: false,
    );
  }
}

class ChooseRoleScreen extends StatelessWidget {
  const ChooseRoleScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF111317),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () => context.go('/buyer-home'),
              child: const Text('Buyer Mode'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => context.go('/organizer-home'),
              child: const Text('Organizer Mode'),
            ),
          ],
        ),
      ),
    );
  }
}
