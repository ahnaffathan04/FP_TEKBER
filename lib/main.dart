import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'screen/organizer/home_screen.dart';
import 'screen/organizer/tambah_konser.dart';

void main() {
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
  ],
);

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerDelegate: _router.routerDelegate,
      routeInformationParser: _router.routeInformationParser,
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
