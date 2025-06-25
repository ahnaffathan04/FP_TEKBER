import 'package:ezrameeting2tekber/screen/complaint/submit_complaint_page.dart';
import 'package:flutter/material.dart';
import 'package:ezrameeting2tekber/screen/auth/login_screen.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SignupScreen extends StatefulWidget {
  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController numberController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController userNameController = TextEditingController();
  TextEditingController userCategoryController = TextEditingController();
  TextEditingController userAddressController = TextEditingController();
  TextEditingController profilePictureController = TextEditingController();
  TextEditingController dateOfBirthController = TextEditingController();

  bool isLoading = false;

  final supabase = Supabase.instance.client;

  // Fungsi signup
  Future<void> _signup() async {
    final name = nameController.text.trim();
    final email = emailController.text.trim();
    final number = numberController.text.trim();
    final password = passwordController.text.trim();
    final userName = userNameController.text.trim();
    final userCategory = userCategoryController.text.trim();
    final userAddress = userAddressController.text.trim();
    final profilePicture = profilePictureController.text.trim();
    final dateOfBirth = dateOfBirthController.text.trim();

    if (name.isEmpty ||
        number.isEmpty ||
        email.isEmpty ||
        password.isEmpty ||
        userName.isEmpty ||
        userCategory.isEmpty ||
        userAddress.isEmpty ||
        profilePicture.isEmpty ||
        dateOfBirth.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text(
          "Harap isi semua detail",
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.red,
      ));
      return;
    }

    // Validasi tipe data
    final emailRegex = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');
    final phoneRegex = RegExp(r'^\d+$');
    final dateRegex = RegExp(r'^\d{4}-\d{2}-\d{2}$');
    final urlRegex = RegExp(r'^(http|https)://');

    if (!emailRegex.hasMatch(email)) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("Format email tidak valid"),
        backgroundColor: Colors.red,
      ));
      return;
    }
    if (!phoneRegex.hasMatch(number)) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("Nomor telepon hanya boleh angka"),
        backgroundColor: Colors.red,
      ));
      return;
    }
    if (!dateRegex.hasMatch(dateOfBirth)) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("Tanggal lahir harus format YYYY-MM-DD"),
        backgroundColor: Colors.red,
      ));
      return;
    }
    if (!urlRegex.hasMatch(profilePicture)) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("Link foto profil harus berupa URL valid (http/https)"),
        backgroundColor: Colors.red,
      ));
      return;
    }
    setState(() {
      isLoading = true;
    });

    try {
      final userCreate = await supabase.auth.signUp(
        email: email,
        password: password,
        data: {
          'full_name': name,
          'phone_number': number,
        },
      );

      // print("Respon signup: ${userCreate.toString()}");

      if (userCreate.user != null) {
        final profileData = {
          'id': userCreate.user!.id,
          'user_id': userCreate.user!.id,
          'user_name': userName,
          'user_category': userCategory,
          'email': email,
          'phone_number': number,
          'user_address': userAddress,
          'profile_picture': profilePicture,
          'date_of_birth': dateOfBirth,
          'fullname': name,
          'registration_date': DateTime.now().toIso8601String(),
          'is_active': true,
          'created_at': DateTime.now().toIso8601String(),
        };

        // print("Data profil: $profileData");

        final response =
            await supabase.from('profiles').upsert(profileData).select();
        // print("Respon insert profil: ${response.toString()}");

        // response is a List, check if data is returned
        if (response.isNotEmpty) {
          // print("Insert profil berhasil: $response");
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text(
              "Pendaftaran berhasil!",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            backgroundColor: Colors.green,
          ));
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => LoginScreen()),
          );
        } else {
          // Tidak ada data yang dikembalikan
          // print("Tidak ada data yang dikembalikan setelah insert profil.");
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text("Data profil tidak berhasil disimpan."),
            backgroundColor: Colors.orange,
          ));
        }
      }
    } catch (e) {
      // print("Error saat signup: $e");
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Gagal: $e"),
        backgroundColor: Colors.red,
      ));
    }

    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  "lib/assets/icons/account.png",
                  height: 200,
                ),
                const Text("Welcome",
                    style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue)),
                const SizedBox(height: 20),

                // Name
                TextField(
                  controller: nameController,
                  decoration: const InputDecoration(
                      labelText: "Full Name", border: OutlineInputBorder()),
                ),
                const SizedBox(height: 10),

                // Email
                TextField(
                  controller: emailController,
                  decoration: const InputDecoration(
                      labelText: "Email", border: OutlineInputBorder()),
                ),
                const SizedBox(height: 10),

                // Phone Number
                TextField(
                  controller: numberController,
                  keyboardType: TextInputType.phone,
                  decoration: const InputDecoration(
                      labelText: "Phone Number", border: OutlineInputBorder()),
                ),
                const SizedBox(height: 10),

                // Password
                TextField(
                  controller: passwordController,
                  obscureText: true,
                  decoration: const InputDecoration(
                      labelText: "Password", border: OutlineInputBorder()),
                ),
                const SizedBox(height: 20),

                // User Name
                TextField(
                  controller: userNameController,
                  decoration: const InputDecoration(
                      labelText: "User Name", border: OutlineInputBorder()),
                ),
                const SizedBox(height: 10),

                // User Category
                TextField(
                  controller: userCategoryController,
                  decoration: const InputDecoration(
                      labelText: "User Category", border: OutlineInputBorder()),
                ),
                const SizedBox(height: 10),

                // User Address
                TextField(
                  controller: userAddressController,
                  decoration: const InputDecoration(
                      labelText: "Alamat", border: OutlineInputBorder()),
                ),
                const SizedBox(height: 10),

                // Profile Picture (link)
                TextField(
                  controller: profilePictureController,
                  decoration: const InputDecoration(
                      labelText: "Link Foto Profil",
                      border: OutlineInputBorder()),
                ),
                const SizedBox(height: 10),

                // Date of Birth
                TextField(
                  controller: dateOfBirthController,
                  decoration: const InputDecoration(
                      labelText: "Tanggal Lahir (YYYY-MM-DD)",
                      border: OutlineInputBorder()),
                ),
                const SizedBox(height: 10),

                ElevatedButton(
                  onPressed: () {
                    _signup();
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
                          "Sign Up ",
                          style: TextStyle(
                              fontSize: 23, fontWeight: FontWeight.bold),
                        ),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => LoginScreen()),
                    );
                  },
                  child: const Text(
                    "Already have an account? Login",
                    style: TextStyle(fontSize: 18),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            // Import the page at the top of your file:
                            // import 'package:ezrameeting2tekber/screen/complaint/submit_complaint_page.dart';
                            SubmitComplaintPage(),
                      ),
                    );
                  },
                  child: const Text(
                    "Laporkan masalah di sini",
                    style: TextStyle(fontSize: 16, color: Colors.red),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
