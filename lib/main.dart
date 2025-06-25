import 'package:flutter/material.dart';
import 'package:fp_festipass/screens/login_screen.dart';
import 'package:fp_festipass/screens/signup_screen.dart';
import 'package:fp_festipass/screens/forgot_password_1.dart';
import 'package:fp_festipass/screens/forgot_password_2.dart';
import 'package:fp_festipass/screens/forgot_password_3.dart';


void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  static const Color aqua = Color(0xFF22E6CE);
  static const Color bluishCyan = Color(0xFF21D3FE);
  static const Color shockingPink = Color(0xFFF51DAB);
  static const Color orange = Color(0xFFFC8B3A);
  static const Color lime = Color(0xFF0DD044);
  static const Color azureBlue = Color(0xFF3479FF);
  static const Color lovelyPurple = Color(0xFF8D29EE);
  static const Color yellow = Color(0xFFF1F446);

  static const Color grey1 = Color(0xFF252836);
  static const Color grey2 = Color(0xFF292E46);
  static const Color grey3 = Color(0xFF2E3553);
  static const Color grey4 = Color(0xFFF51DAB);
  static const Color gradientAquaEnd = Color(0xFF10FF8C);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FestiPass',
      theme: ThemeData(
        brightness: Brightness.dark, // Overall dark theme
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        scaffoldBackgroundColor: grey1, // Set default scaffold background
      ),
      // Define routes for easy navigation
      initialRoute: '/',
      routes: {
        '/': (context) => const LoginScreen(),
        '/signup': (context) => const SignUpScreen(),
        // Updated route names
        '/forgot_password_step1': (context) => const ForgotPassword1Screen(),
        '/forgot_password_step2': (context) => const ForgotPassword2Screen(),
        '/forgot_password_step3': (context) => const ForgotPassword3Screen(),
      },
    );
  }
}