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

import 'screen/buyer/home_screen.dart';
import 'screen/buyer/account.dart';
import 'screen/buyer/language.dart';
import 'screen/buyer/page_setting.dart';
import 'screen/buyer/my_ticket.dart';
import 'screen/buyer/concert_detail.dart';
import 'screen/buyer/concert_detail_completed.dart';

import 'screen/organizer/home_screen.dart';
import 'screen/organizer/overview_konser.dart';

import 'screen/complaint/submit_complaint.dart';
void main() {
  runApp(MyApp());
}

final GoRouter _router = GoRouter(
  // LANGKAH 2: Ubah initialLocation untuk menunjuk ke rute baru Anda.
  initialLocation: '/buyer-home', 
  routes: [
    GoRoute(
      path: '/ticket-overview',
      builder: (context, state) => const TicketOverviewScreen(),
    ),

    // LANGKAH 1: Tambahkan rute baru untuk QRScannerWeb
    GoRoute(
      path: '/qr-scanner',
      builder: (context, state) => const QRScannerWeb(),
    ),

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
    GoRoute(
      path: '/complaint',
      builder: (context, state) => const SubmitComplaintScreen(),
    ),
  ],
);

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