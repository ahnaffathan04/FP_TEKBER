// Importing necessary packages
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:go_router/go_router.dart';

// Importing neccessary screens
import '../constants/app_colors.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final supabase = Supabase.instance.client;

  bool _obscureText = true;
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    setState(() => _isLoading = true);
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    try {
      final authResponse = await supabase.auth.signInWithPassword(
        email: email,
        password: password,
      );

      final userId = authResponse.user?.id;
      if (userId == null) throw Exception('User ID not found');

      final profile = await supabase
          .from('profiles')
          .select('user_category')
          .eq('user_id', userId)
          .single();

      final userCategory = profile['user_category'];

      if (userCategory == 'buyer') {
        context.go('/buyer-home');
      } else if (userCategory == 'organizer') {
        context.go('/organizer-home'); // Update this if organizer home exists
      } else {
        _showSnackBar("Kategori user tidak dikenali.", isError: true);
      }

      _showSnackBar("Successfully login", isSuccess: true);
    } catch (e) {
      _showSnackBar("Login Failed", isError: true);
    }

    setState(() => _isLoading = false);
  }

  void _showSnackBar(String message, {bool isSuccess = false, bool isError = false}) {
    final bgColor = isSuccess
        ? Colors.green
        : isError
            ? Colors.red
            : Colors.blue;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: bgColor,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF111317),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: ListView(
          children: <Widget>[
            const SizedBox(height: 100),
            ShaderMask(
              shaderCallback: (Rect bounds) {
                return const LinearGradient(
                  colors: [AppColors.lovelyPurple, AppColors.shockingPink],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ).createShader(bounds);
              },
              child: const Text(
                'FestiPass',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 48,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
            const SizedBox(height: 80.0),
            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Sign In',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
            const SizedBox(height: 24.0),

            // Email
            TextFormField(
              controller: _emailController,
              keyboardType: TextInputType.emailAddress,
              style: const TextStyle(color: Colors.white),
              decoration: _buildInputDecoration(
                hint: 'Enter Email',
                onClear: () => _emailController.clear(),
              ),
            ),
            const SizedBox(height: 16.0),

            // Password
            TextFormField(
              controller: _passwordController,
              obscureText: _obscureText,
              style: const TextStyle(color: Colors.white),
              decoration: _buildInputDecoration(
                hint: '••••••••',
                icon: IconButton(
                  icon: Icon(
                    _obscureText ? Icons.visibility : Icons.visibility_off,
                    color: Colors.grey,
                  ),
                  onPressed: () => setState(() => _obscureText = !_obscureText),
                ),
              ),
            ),

            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: () {
                  context.push('/forgot_password_step1');
                },
                child: const Text(
                  'Forgot Password?', 
                  style: TextStyle(color: AppColors.bluishCyan),
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Login button
            Container(
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [AppColors.bluishCyan, AppColors.lovelyPurple],
                ),
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: ElevatedButton(
                onPressed: _login,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  shadowColor: Colors.transparent,
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
                child: _isLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text(
                        'Sign In',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
              ),
            ),
            const SizedBox(height: 60),

            // Register
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  "Don't have an account?",
                  style: TextStyle(color: Colors.white70),
                ),
                TextButton(
                  onPressed: () => context.go('/register'),
                  child: const Text(
                    'Register',
                    style: TextStyle(
                      color: AppColors.bluishCyan,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }

  InputDecoration _buildInputDecoration({
    required String hint,
    VoidCallback? onClear,
    Widget? icon,
  }) {
    return InputDecoration(
      hintText: hint,
      hintStyle: const TextStyle(color: Colors.grey),
      filled: true,
      fillColor: Colors.transparent,
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.0),
        borderSide: const BorderSide(color: AppColors.bluishCyan, width: 1.0),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.0),
        borderSide: const BorderSide(color: AppColors.bluishCyan, width: 2.0),
      ),
      suffixIcon: icon ??
          (onClear != null
              ? IconButton(
                  icon: const Icon(Icons.cancel, color: Colors.grey),
                  onPressed: onClear,
                )
              : null),
      contentPadding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 20.0),
    );
  }
}
