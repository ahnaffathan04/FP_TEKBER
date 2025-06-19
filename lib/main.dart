import 'package:flutter/material.dart'; // Importing Flutter Material package for UI components
import 'package:go_router/go_router.dart'; // Importing GoRouter for navigation
import 'package:supabase_flutter/supabase_flutter.dart'; // Importing Supabase for backend 

// Constants Screens
import 'screen/constants/app_colors.dart'; // Importing AppColors for consistent theming

// Auth Screens
import 'screen/auth/register_screen.dart'; // Importing RegisterScreen for user registration
import 'screen/auth/login_screen.dart'; // Importing LoginScreen for user login

// Buyer Screens
import 'screen/buyer/home_screen.dart'; // Importing HomeScreen for Buyer
import 'screen/buyer/account.dart'; // Importing AccountScreen for Buyer
import 'screen/buyer/page_setting.dart'; // Importing PageSetting for Buyer
import 'screen/buyer/my_ticket.dart'; // Importing MyTicketScreen for Buyer
import 'screen/buyer/concert_detail.dart'; // Importing ConcertDetailScreen for Buyer
import 'screen/buyer/concert_detail_completed.dart'; // Importing ConcertDetailCompleted for Buyer

// Organizer Screens
import 'screen/organizer/home_screen.dart'; // Importing OrganizerHomeScreen for Organizer
import 'screen/organizer/manage_tiket.dart'; // Importing ManageTiketScreen for Organizer
import 'screen/organizer/manage_konser.dart'; // Importing ManageKonserScreen for Organizer
import 'screen/organizer/edit_konser.dart'; // Importing EditKonserScreen for Organizer
import 'screen/organizer/tambah_tiket.dart'; //  Importing TambahTiketScreen for Organizer

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Supabase.initialize(
    url: '', // Insert your Supabase URL
    anonKey: '', // Insert your Supabase anon key
  );
  runApp(MyApp());
}

// GoRouter Configuration
final GoRouter _router = GoRouter(
  initialLocation: '/choose-role',
  routes: [
    // Common entry screen
    GoRoute(
      path: '/choose-role',
      builder: (context, state) => ChooseRoleScreen(),
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
    // GoRoute(
    //   path: '/tambah-konser',
    //   builder: (context, state) => TambahKonserScreen(),
    // ),
    // GoRoute(
    //   path: '/tambah-tiket',
    //   builder: (context, state) => const TambahTiketScreen(),
    // ),
  ],
);

class MyApp extends StatelessWidget {
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

// Entry screen to choose between buyer/organizer
class ChooseRoleScreen extends StatelessWidget {
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
              child: Text('Buyer Mode'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => context.go('/organizer-home'),
              child: Text('Organizer Mode'),
            ),
          ],
        ),
      ),
    );
  }
}
