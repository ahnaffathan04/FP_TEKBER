import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

// Auth Screens
import 'screen/auth/register_screen.dart';
import 'screen/auth/login_screen.dart';

// Buyer Screens
import 'screen/buyer/home_screen.dart';
import 'screen/buyer/account.dart';
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

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Supabase.initialize(
    url: 'https://ncasjwbrdpjjvoouemwj.supabase.co',
    anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Im5jYXNqd2JyZHBqanZvb3VlbXdqIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NTAwNzMxNTcsImV4cCI6MjA2NTY0OTE1N30.DLx94pbPm8cMoxfQlzup2BIZxCN6lP5RNtXFYuYA-Bw',
  );
  runApp(const MyApp());
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
      path: '/buyer-home/account',
      builder: (context, state) => AccountScreen(),
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
      title: 'FestiPass App',
      theme: ThemeData.dark(),
      routerConfig: _router,
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
