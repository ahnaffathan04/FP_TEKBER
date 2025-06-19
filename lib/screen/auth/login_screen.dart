import 'package:flutter/material.dart';
import 'package:ezrameeting2tekber/screen/auth/register_screen.dart';
import 'package:ezrameeting2tekber/screen/buyer/home_screen.dart';
//kalo page organizser udah ada, ini di uncomment aja
// import 'package:ezrameeting2tekber/screen/organizer/home_screen.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class LoginScreen extends StatefulWidget {
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  final supabase = Supabase.instance.client;
  bool isLoading = false;

  /// function for login
  Future<void> _login() async {
    final password = passwordController.text.trim();
    final email = emailController.text.trim();

    setState(() {
      isLoading = true;
    });
    try {
      final authResponse = await supabase.auth
          .signInWithPassword(password: password, email: email);
      final userId = authResponse.user?.id;
      if (userId == null) throw Exception('User ID not found');
      // Ambil data user_category dari tabel profiles
      final profileResponse = await supabase
          .from('profiles')
          .select('user_category')
          .eq('user_id', userId)
          .single();
      final userCategory = profileResponse['user_category'];
      // print('user_category: $userCategory');
      if (userCategory == 'buyer') {
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) => const HomeScreen()));
      } else if (userCategory == 'organizer') {
        //arah redirectnya nanti tolong diganti ke pagenya homescreen organizer ya
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => HomeScreen()));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text("Kategori user tidak dikenali."),
          backgroundColor: Colors.red,
        ));
      }
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text(
          "Successfully login",
          style: TextStyle(
              fontWeight: FontWeight.bold, fontSize: 21, color: Colors.white),
        ),
        backgroundColor: Colors.greenAccent,
      ));
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text("Login Failed")));
    }
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              "lib/assets/icons/login (1).png",
              height: 200,
            ),
            const Text("Welcome Back!",
                style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue)),
            const SizedBox(height: 20),
            TextField(
              controller: emailController,
              decoration: const InputDecoration(
                  labelText: "Email", border: OutlineInputBorder()),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: passwordController,
              obscureText: true,
              decoration: const InputDecoration(
                  labelText: "Password", border: OutlineInputBorder()),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                _login();
              },
              style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue.shade200,
                  foregroundColor: Colors.white,
                  minimumSize: const Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(6)),
                  side: const BorderSide(width: 2, color: Colors.blue)),
              child: isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : const Text(
                      "Login",
                      style:
                          TextStyle(fontSize: 23, fontWeight: FontWeight.bold),
                    ),
            ),
            TextButton(
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => SignupScreen()));
              },
              child: const Text(
                "Don't have an account? Sign Up",
                style: TextStyle(fontSize: 18),
              ),
            )
          ],
        ),
      ),
    );
  }
}
