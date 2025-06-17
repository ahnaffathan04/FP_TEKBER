import 'package:ezrameeting2tekber/screen/organizer/manage_tiket.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'screen/organizer/home_screen.dart';
import 'screen/organizer/tambah_konser.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Supabase.initialize(
    url: 'https://eatimucqelcaoswpzitc.supabase.co',
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImVhdGltdWNxZWxjYW9zd3B6aXRjIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NTAxMjU0OTMsImV4cCI6MjA2NTcwMTQ5M30.cWdbKCj6zK38cpO4OvyNpRHRPHRgF0VUuRSfPuoUcho',
  );
  runApp(MyApp());
}

final GoRouter _router = GoRouter(
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => OrganizerButtonScreen(),
    ),
    GoRoute(
      path: '/organizer-home',
      builder: (context, state) => OrganizerHomeScreen(),
    ),
    GoRoute(
      path: '/tambah-konser',
      builder: (context, state) => TambahKonserScreen(),
    ),
    GoRoute(
      path: '/tambah-tiket',
      builder: (context, state) => TambahTiketScreen(),
    ),
  ],
);

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerDelegate: _router.routerDelegate,
      routeInformationParser: _router.routeInformationParser,
      routeInformationProvider: _router.routeInformationProvider,
      title: 'Organizer App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
    );
  }
}

class OrganizerButtonScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ElevatedButton(
          child: Text('Organizer Home Screen'),
          onPressed: () {
            context.go('/organizer-home');
          },
        ),
      ),
    );
  }
}
