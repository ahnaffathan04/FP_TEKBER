import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

// Auth Screens
import 'screen/auth/login_screen.dart';
import 'screen/auth/register_screen.dart';
import 'screen/auth/change_password.dart';

import 'screen/buyer/home_screen.dart';
import 'screen/buyer/account.dart';
import 'screen/buyer/language.dart';
import 'screen/buyer/page_setting.dart';
import 'screen/buyer/my_ticket.dart';
import 'screen/buyer/concert_detail.dart';
import 'screen/buyer/concert_detail_completed.dart';

// Organizer Screens
import 'screen/organizer/home_screen.dart';
import 'screen/organizer/manage_tiket.dart';
import 'screen/organizer/tambah_tiket.dart';
import 'screen/organizer/manage_konser.dart';
import 'screen/organizer/edit_konser.dart';

// Complaint Screens
import 'screen/complaint/submit_complaint.dart';

// Providers
import 'screen/buyer/providers/user_provider.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'themes/app_theme.dart';
import 'screen/buyer/book_ticket_overview.dart';
import 'screen/buyer/category_booking_screen.dart';
import 'screen/buyer/sold_out_screen.dart';
import 'screen/buyer/ticket_order_screen.dart';
import 'screen/buyer/payment_method_selection_screen.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: 'https://ncasjwbrdpjjvoouemwj.supabase.co',
    anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Im5jYXNqd2JyZHBqanZvb3VlbXdqIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NTAwNzMxNTcsImV4cCI6MjA2NTY0OTE1N30.DLx94pbPm8cMoxfQlzup2BIZxCN6lP5RNtXFYuYA-Bw', // 🔁 Replace with your Supabase anon key
  );

  await initializeDateFormatting('id', null);

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => UserProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

final GoRouter _router = GoRouter(
  initialLocation: '/register',
  routes: [
    // Choose Role Route
    GoRoute(
      path: '/choose-role',
      builder: (context, state) => const ChooseRoleScreen(),
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
    
    // Buyer Routes
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
        );
      },
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
        );
      },
    ),
      GoRoute(
      path: '/payment_method',
      builder: (context, state) => const PaymentMethodSelectionScreen(),
    ),

      GoRoute(
      path: '/complaint',
      builder: (context, state) => const SubmitComplaintScreen(),
    ),
      GoRoute(
      path: '/sold_out',
      builder: (context, state) => const SoldOutScreen(),
    ),
  ],
);
    // GoRoute(
    //   path: '/manage-tiket',
    //   builder: (context, state) => ManageTiketScreen(),
    // ),
    // GoRoute(
    //   path: '/tambah-tiket',
    //   builder: (context, state) => TambahTiketScreen(),
    // ),
    // GoRoute(
    //   path: '/manage-konser',
    //   builder: (context, state) => ManageKonserScreen(),
    // ),
    // GoRoute(
    //   path: '/edit-konser',
    //   builder: (context, state) => EditKonserScreen(),
    // ),

    // Complaint Routes


class MyApp extends StatelessWidget {
  const MyApp({super.key});

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